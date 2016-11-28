From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v7 01/11] run_tests: allow forcing of
 acceleration mode
Date: Mon, 28 Nov 2016 09:51:28 +0100
Message-ID: <20161128085128.sqr7nmfc7hzugdis@kamzik.brq.redhat.com>
References: <20161124161033.11456-1-alex.bennee@linaro.org>
 <20161124161033.11456-2-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 244F84069B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2016 03:50:51 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bWoouoadEZhL for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Nov 2016 03:50:49 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D0FD74066D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2016 03:50:48 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20161124161033.11456-2-alex.bennee@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: mttcg@greensocs.com, nikunj@linux.vnet.ibm.com, kvm@vger.kernel.org, marc.zyngier@arm.com, jan.kiszka@siemens.com, mark.burton@greensocs.com, qemu-devel@nongnu.org, cota@braap.org, linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, serge.fdrv@gmail.com, bobby.prani@gmail.com, kvmarm@lists.cs.columbia.edu, rth@twiddle.net
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Nov 24, 2016 at 04:10:23PM +0000, Alex Benn=E9e wrote:
> While tests can be pegged to tcg it is useful to override this from time
> to time, especially when testing correctness on real systems.
> ---
>  run_tests.sh         | 8 ++++++--
>  scripts/runtime.bash | 4 ++++
>  2 files changed, 10 insertions(+), 2 deletions(-)
> =

> diff --git a/run_tests.sh b/run_tests.sh
> index 254129d..b88c36f 100755
> --- a/run_tests.sh
> +++ b/run_tests.sh
> @@ -13,9 +13,10 @@ function usage()
>  {
>  cat <<EOF
>  =

> -Usage: $0 [-g group] [-h] [-v]
> +Usage: $0 [-g group] [-a accel] [-h] [-v]
>  =

>      -g: Only execute tests in the given group
> +    -a: Force acceleration mode (tcg/kvm)
>      -h: Output this help text
>      -v: Enables verbose mode
>  =

> @@ -28,11 +29,14 @@ EOF
>  RUNTIME_arch_run=3D"./$TEST_DIR/run"
>  source scripts/runtime.bash
>  =

> -while getopts "g:hv" opt; do
> +while getopts "g:a:hv" opt; do
>      case $opt in
>          g)
>              only_group=3D$OPTARG
>              ;;
> +        a)
> +            force_accel=3D$OPTARG
> +            ;;
>          h)
>              usage
>              exit
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index 11a40a9..578cf32 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -75,6 +75,10 @@ function run()
>          return;
>      fi
>  =

> +    if [ -n "$force_accel" ]; then
> +        accel=3D$force_accel
> +    fi
> +
>      if [ -n "$arch" ] && [ "$arch" !=3D "$ARCH" ]; then
>          echo "`SKIP` $1 ($arch only)"
>          return 2
> -- =

> 2.10.1

We can already do 'ACCEL=3Dtcg ./run_tests.sh' to force, for example, tcg.
Additionally, you can add any env you want to the config.mak after running
configure,

 echo ACCEL=3Dtcg >> config.mak

If you still prefer a cmdline parameter, then I'd suggest a boolean
instead, with the default being KVM. So the param would be '-tcg', or
something.

Thanks,
drew
