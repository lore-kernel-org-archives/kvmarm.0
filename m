From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v7 02/11] run_tests: allow disabling of
 timeouts
Date: Mon, 28 Nov 2016 10:00:57 +0100
Message-ID: <20161128090057.pm2x24iyq2a65hyb@kamzik.brq.redhat.com>
References: <20161124161033.11456-1-alex.bennee@linaro.org>
 <20161124161033.11456-3-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161124161033.11456-3-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, qemu-devel@nongnu.org, mttcg@greensocs.com, fred.konrad@greensocs.com, a.rigo@virtualopensystems.com, cota@braap.org, bobby.prani@gmail.com, nikunj@linux.vnet.ibm.com, mark.burton@greensocs.com, pbonzini@redhat.com, jan.kiszka@siemens.com, serge.fdrv@gmail.com, rth@twiddle.net, peter.maydell@linaro.org, claudio.fontana@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Nov 24, 2016 at 04:10:24PM +0000, Alex Bennée wrote:
> Certainly during development of the tests and MTTCG there are times when
> the timeout just gets in the way.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> ---
>  run_tests.sh         | 8 ++++++--
>  scripts/runtime.bash | 4 ++++
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/run_tests.sh b/run_tests.sh
> index b88c36f..4f2e5cb 100755
> --- a/run_tests.sh
> +++ b/run_tests.sh
> @@ -13,10 +13,11 @@ function usage()
>  {
>  cat <<EOF
>  
> -Usage: $0 [-g group] [-a accel] [-h] [-v]
> +Usage: $0 [-g group] [-a accel] [-t] [-h] [-v]
>  
>      -g: Only execute tests in the given group
>      -a: Force acceleration mode (tcg/kvm)
> +    -t: disable timeouts
>      -h: Output this help text
>      -v: Enables verbose mode
>  
> @@ -29,7 +30,7 @@ EOF
>  RUNTIME_arch_run="./$TEST_DIR/run"
>  source scripts/runtime.bash
>  
> -while getopts "g:a:hv" opt; do
> +while getopts "g:a:thv" opt; do
>      case $opt in
>          g)
>              only_group=$OPTARG
> @@ -37,6 +38,9 @@ while getopts "g:a:hv" opt; do
>          a)
>              force_accel=$OPTARG
>              ;;
> +        t)
> +            no_timeout="yes"
> +            ;;
>          h)
>              usage
>              exit
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index 578cf32..968ff6d 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -79,6 +79,10 @@ function run()
>          accel=$force_accel
>      fi
>  
> +    if [ "$no_timeout" = "yes" ]; then
> +        timeout=""
> +    fi
> +
>      if [ -n "$arch" ] && [ "$arch" != "$ARCH" ]; then
>          echo "`SKIP` $1 ($arch only)"
>          return 2
> -- 
> 2.10.1
>

A timeout value of zero disables the timeout. So you just need to run
 TIMEOUT=0 ./run_tests.sh, or add it to config.mak.

drew
