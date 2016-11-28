From: Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH v7 03/11] run_tests: allow
 passing of options to QEMU
Date: Mon, 28 Nov 2016 10:10:51 +0100
Message-ID: <20161128091051.zvtsvoow34b2nd5w@kamzik.brq.redhat.com>
References: <20161124161033.11456-1-alex.bennee@linaro.org>
 <20161124161033.11456-4-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161124161033.11456-4-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, mttcg@greensocs.com, peter.maydell@linaro.org, claudio.fontana@huawei.com, nikunj@linux.vnet.ibm.com, jan.kiszka@siemens.com, mark.burton@greensocs.com, a.rigo@virtualopensystems.com, qemu-devel@nongnu.org, cota@braap.org, serge.fdrv@gmail.com, pbonzini@redhat.com, bobby.prani@gmail.com, rth@twiddle.net, fred.konrad@greensocs.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Nov 24, 2016 at 04:10:25PM +0000, Alex Bennée wrote:
> This introduces a the option -o for passing of options directly to QEMU
> which is useful. In my case I'm using it to toggle MTTCG on an off:
> 
>   ./run_tests.sh -t -o "-tcg mttcg=on"
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> ---
>  run_tests.sh           | 10 +++++++---
>  scripts/functions.bash | 13 +++++++------
>  2 files changed, 14 insertions(+), 9 deletions(-)
> 
> diff --git a/run_tests.sh b/run_tests.sh
> index 4f2e5cb..05cc7fb 100755
> --- a/run_tests.sh
> +++ b/run_tests.sh
> @@ -13,10 +13,11 @@ function usage()
>  {
>  cat <<EOF
>  
> -Usage: $0 [-g group] [-a accel] [-t] [-h] [-v]
> +Usage: $0 [-g group] [-a accel] [-o qemu_opts] [-t] [-h] [-v]
>  
>      -g: Only execute tests in the given group
>      -a: Force acceleration mode (tcg/kvm)
> +    -o: additional options for QEMU command line
>      -t: disable timeouts
>      -h: Output this help text
>      -v: Enables verbose mode
> @@ -30,7 +31,7 @@ EOF
>  RUNTIME_arch_run="./$TEST_DIR/run"
>  source scripts/runtime.bash
>  
> -while getopts "g:a:thv" opt; do
> +while getopts "g:a:o:thv" opt; do
>      case $opt in
>          g)
>              only_group=$OPTARG
> @@ -38,6 +39,9 @@ while getopts "g:a:thv" opt; do
>          a)
>              force_accel=$OPTARG
>              ;;
> +        o)
> +            extra_opts=$OPTARG
> +            ;;
>          t)
>              no_timeout="yes"
>              ;;
> @@ -67,4 +71,4 @@ RUNTIME_log_stdout () {
>  config=$TEST_DIR/unittests.cfg
>  rm -f test.log
>  printf "BUILD_HEAD=$(cat build-head)\n\n" > test.log
> -for_each_unittest $config run
> +for_each_unittest $config run "$extra_opts"
> diff --git a/scripts/functions.bash b/scripts/functions.bash
> index ee9143c..d38a69e 100644
> --- a/scripts/functions.bash
> +++ b/scripts/functions.bash
> @@ -2,11 +2,12 @@
>  function for_each_unittest()
>  {
>  	local unittests="$1"
> -	local cmd="$2"
> -	local testname
> +        local cmd="$2"
> +        local extra_opts=$3
> +        local testname

We use tabs in this file. Not sure why cmd and testname got
changed too...

>  	local smp
>  	local kernel
> -	local opts
> +        local opts=$extra_opts
>  	local groups
>  	local arch
>  	local check
> @@ -21,7 +22,7 @@ function for_each_unittest()
>  			testname=${BASH_REMATCH[1]}
>  			smp=1
>  			kernel=""
> -			opts=""
> +                        opts=$extra_opts
>  			groups=""
>  			arch=""
>  			check=""
> @@ -32,7 +33,7 @@ function for_each_unittest()
>  		elif [[ $line =~ ^smp\ *=\ *(.*)$ ]]; then
>  			smp=${BASH_REMATCH[1]}
>  		elif [[ $line =~ ^extra_params\ *=\ *(.*)$ ]]; then
> -			opts=${BASH_REMATCH[1]}
> +                        opts="$opts ${BASH_REMATCH[1]}"
>  		elif [[ $line =~ ^groups\ *=\ *(.*)$ ]]; then
>  			groups=${BASH_REMATCH[1]}
>  		elif [[ $line =~ ^arch\ *=\ *(.*)$ ]]; then
> @@ -45,6 +46,6 @@ function for_each_unittest()
>  			timeout=${BASH_REMATCH[1]}
>  		fi
>  	done
> -	"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
> +        "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
>  	exec {fd}<&-
>  }
> -- 
> 2.10.1
> 
>

This is a pretty good idea, but I think I might like the extra options
to be given like this instead

  ./run_tests.sh [run_tests.sh options] -- [qemu options]

Thanks,
drew 
