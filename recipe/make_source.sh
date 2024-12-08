#!/bin/bash
this_script=$(pwd)/$0
prefix=${prefix:-external/}

git submodule init
git submodule update
for submodule in $(git config -f .gitmodules --list | grep path=); do
    submodule_path=$(echo ${submodule} | awk -F= '{print $2}')
    pushd ${submodule_path} 2>>/dev/null 1>>/dev/null

        giturl=$(git config --get remote.origin.url | sed 's/\.git$//')
        gitrev=$(git rev-parse HEAD)
        fn="${gitrev}.tar.gz"
        source_url="${giturl}/archive/${fn}"
        comment=""

        wget --quiet ${source_url}
        # wget ${source_url}
        sha256=$(openssl sha256 ${fn} | awk '{print $2}')
        rm ${fn}

        cat <<EOF
  - folder: ${prefix}${submodule_path}
    url: ${source_url}
    ${comment}sha256: ${sha256}
EOF

        if [[ ${submodule_path} == "third_party/gloo" ]]; then
            echo null >/dev/null
        elif [[ -f .gitmodules ]]; then
            cp $this_script make_source.sh
            prefix="${prefix}${submodule_path}/" bash make_source.sh
            rm make_source.sh
        fi
    popd 2>>/dev/null 1>>/dev/null
done
