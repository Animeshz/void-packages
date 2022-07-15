#
# This helper is for building node projects which use npm for building
#

do_build() {
	: ${npm_cmd:=npm}

        export npm_config_build_from_source=true
	export npm_config_cache="$srcdir/npm_cache"

	[ -f package-lock.json ] && install_cmd="clean-install" || install_cmd="install"
        ${npm_cmd} ${install_cmd}

        if [ -n ${npm_build_script} ]; then
            ${npm_cmd} run ${npm_build_script} -- ${npm_build_args}
        fi
}

do_check() {
	: ${npm_cmd:=npm}

	${npm_cmd} test -- ${npm_test_args}
}

do_install() {
	: ${npm_cmd:=npm}
        npm install --omit=dev --location=global --prefix "${DESTDIR}/usr" \
            ${npm_install_args} $(npm pack . | tail -1)

        # https://github.com/npm/npm/issues/9359
        chmod -R u=rwX,go=rX "${DESTDIR}"

        find . -name "*.ts,.bin,.github,.vscode,bin.js" -delete
}
