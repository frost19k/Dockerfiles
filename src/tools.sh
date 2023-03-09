#!/usr/bin/env bash

declare -A gotools
gotools["amass"]="github.com/OWASP/Amass/v3/...@master"
gotools["Gxss"]="github.com/KathanP19/Gxss@latest"
gotools["Web-Cache-Vulnerability-Scanner"]="github.com/Hackmanit/Web-Cache-Vulnerability-Scanner@latest"
gotools["analyticsrelationships"]="github.com/Josue87/analyticsrelationships@latest"
gotools["anew"]="github.com/tomnomnom/anew@latest"
gotools["cero"]="github.com/glebarez/cero@latest"
gotools["crlfuzz"]="github.com/dwisiswant0/crlfuzz/cmd/crlfuzz@latest"
gotools["dalfox"]="github.com/hahwul/dalfox/v2@latest"
gotools["dnstake"]="github.com/pwnesia/dnstake/cmd/dnstake@latest"
gotools["dnsx"]="github.com/projectdiscovery/dnsx/cmd/dnsx@latest"
gotools["dsieve"]="github.com/trickest/dsieve@master"
gotools["enumerepo"]="github.com/trickest/enumerepo@latest"
gotools["ffuf"]="github.com/ffuf/ffuf@latest"
gotools["gau"]="github.com/lc/gau/v2/cmd/gau@latest"
gotools["gf"]="github.com/tomnomnom/gf@latest"
gotools["gitdorks_go"]="github.com/damit5/gitdorks_go@latest"
gotools["github-endpoints"]="github.com/gwen001/github-endpoints@latest"
gotools["github-subdomains"]="github.com/gwen001/github-subdomains@latest"
gotools["gospider"]="github.com/jaeles-project/gospider@latest"
gotools["gotator"]="github.com/Josue87/gotator@latest"
gotools["gowitness"]="github.com/sensepost/gowitness@latest"
gotools["httpx"]="github.com/projectdiscovery/httpx/cmd/httpx@latest"
gotools["inscope"]="github.com/tomnomnom/hacks/inscope@latest"
gotools["interactsh-client"]="github.com/projectdiscovery/interactsh/cmd/interactsh-client@latest"
gotools["ipcdn"]="github.com/six2dez/ipcdn@latest"
gotools["mapcidr"]="github.com/projectdiscovery/mapcidr/cmd/mapcidr@latest"
gotools["notify"]="github.com/projectdiscovery/notify/cmd/notify@latest"
gotools["nuclei"]="github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest"
gotools["puredns"]="github.com/d3mondev/puredns/v2@latest"
gotools["qsreplace"]="github.com/tomnomnom/qsreplace@latest"
gotools["roboxtractor"]="github.com/Josue87/roboxtractor@latest"
gotools["rush"]="github.com/shenwei356/rush@latest"
gotools["smap"]="github.com/s0md3v/smap/cmd/smap@latest"
gotools["subfinder"]="github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest"
gotools["subjack"]="github.com/haccer/subjack@latest"
gotools["subjs"]="github.com/lc/subjs@latest"
gotools["subzy"]="github.com/LukaSikic/subzy@latest"
gotools["tlsx"]="github.com/projectdiscovery/tlsx/cmd/tlsx@latest"
gotools["unfurl"]="github.com/tomnomnom/unfurl@latest"
gotools["waybackurls"]="github.com/tomnomnom/waybackurls@latest"

declare -A repos
repos["CMSeeK"]="Tuhinshubhra/CMSeeK"
repos["Corsy"]="s0md3v/Corsy"
repos["Gf-Patterns"]="1ndianl33t/Gf-Patterns"
repos["JSA"]="w9w/JSA"
repos["LinkFinder"]="GerbenJavado/LinkFinder"
repos["Oralyzer"]="r0075h3ll/Oralyzer"
repos["Web-Cache-Vulnerability-Scanner"]="Hackmanit/Web-Cache-Vulnerability-Scanner"
repos["brutespray"]="x90skysn3k/brutespray"
repos["clairvoyance"]="nikitastupin/clairvoyance"
repos["cloud_enum"]="initstring/cloud_enum"
repos["commix"]="commixproject/commix"
repos["ctfr"]="UnaPibaGeek/ctfr"
repos["dnsvalidator"]="vortexau/dnsvalidator"
repos["dorks_hunter"]="six2dez/dorks_hunter"
repos["fav-up"]="pielco11/fav-up"
repos["gf"]="tomnomnom/gf"
repos["gitdorks_go"]="damit5/gitdorks_go"
repos["graphw00f"]="dolevf/graphw00f"
repos["interlace"]="codingo/Interlace"
repos["massdns"]="blechschmidt/massdns"
repos["pwndb"]="davidtavarez/pwndb"
repos["pydictor"]="LandGrey/pydictor"
repos["regulator"]="cramppet/regulator"
repos["smuggler"]="defparam/smuggler"
repos["sqlmap"]="sqlmapproject/sqlmap"
repos["testssl.sh"]="drwetter/testssl.sh"
repos["theHarvester"]="laramies/theHarvester"
repos["trufflehog"]="trufflesecurity/trufflehog"
repos["ultimate-nmap-parser"]="shifty0g/ultimate-nmap-parser"
repos["urless"]="xnl-h4ck3r/urless"
repos["wafw00f"]="EnableSecurity/wafw00f"
repos["xnLinkFinder"]="xnl-h4ck3r/xnLinkFinder"
repos["Arjun"]="s0md3v/Arjun"
repos["ParamSpider"]="devanshbatham/ParamSpider"

declare -a files
files+=( 'https://gist.github.com/six2dez/a307a04a222fab5a57466c51e1569acf/raw ${subs_wordlist}' )
files+=( 'https://gist.github.com/six2dez/d62ab8f8ffd28e1c206d401081d977ae/raw ${tools}/headers_inject.txt' )
files+=( 'https://gist.github.com/six2dez/ffc2b14d283e8f8eff6ac83e20a3c4b4/raw ${tools}/permutations_list.txt' )
files+=( 'https://gist.githubusercontent.com/six2dez/23a996bca189a11e88251367e6583053/raw ${HOME}/.config/notify/provider-config.yaml' )
files+=( 'https://gist.githubusercontent.com/six2dez/6e2d9f4932fd38d84610eb851014b26e/raw ${tools}/axiom_config.sh' )
files+=( 'https://gist.githubusercontent.com/six2dez/a89a0c7861d49bb61a09822d272d5395/raw ${lfi_wordlist}' )
files+=( 'https://gist.githubusercontent.com/six2dez/ab5277b11da7369bf4e9db72b49ad3c1/raw ${ssti_wordlist}' )
files+=( 'https://gist.githubusercontent.com/six2dez/ae9ed7e5c786461868abd3f2344401b6/raw ${resolvers_trusted}' )
files+=( 'https://raw.githubusercontent.com/NagliNagli/BountyTricks/main/sap-redirect.yaml ${HOME}/nuclei-templates/extra_templates/sap-redirect.yaml' )
files+=( 'https://raw.githubusercontent.com/NagliNagli/BountyTricks/main/ssrf.yaml ${HOME}/nuclei-templates/extra_templates/ssrf.yaml' )
files+=( 'https://raw.githubusercontent.com/OWASP/Amass/master/examples/config.ini ${HOME}/.config/amass/config.ini' )
files+=( 'https://raw.githubusercontent.com/devanshbatham/ParamSpider/master/gf_profiles/potential.json ${HOME}/.gf/potential.json' )
files+=( 'https://raw.githubusercontent.com/dolevf/nmap-graphql-introspection-nse/master/graphql-introspection.nse /usr/share/nmap/scripts/graphql-introspection.nse' )
files+=( 'https://raw.githubusercontent.com/haccer/subjack/master/fingerprints.json /root/.config/subjack/fingerprints.json' )
files+=( 'https://raw.githubusercontent.com/m4ll0k/Bug-Bounty-Toolz/master/getjswords.py ${tools}/getjswords.py' )
files+=( 'https://raw.githubusercontent.com/proabiral/Fresh-Resolvers/master/resolvers.txt ${resolvers}' )
files+=( 'https://raw.githubusercontent.com/six2dez/OneListForAll/main/onelistforallmicro.txt ${fuzz_wordlist}' )
files+=( 'https://wordlists-cdn.assetnote.io/data/manual/best-dns-wordlist.txt ${subs_wordlist_big}' )
