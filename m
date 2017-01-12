From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 6/6] run_tests: allow passing of options
 to QEMU
Date: Thu, 12 Jan 2017 18:32:04 +0100
Message-ID: <20170112173204.ufd2ggw7iz7xv772@hawk.localdomain>
References: <20170111162841.15569-1-alex.bennee@linaro.org>
 <20170111162841.15569-7-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20170111162841.15569-7-alex.bennee@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jan 11, 2017 at 04:28:41PM +0000, Alex Benn=E9e wrote:
> This allows additional options to be passed to QEMU. It follows the
> convention of passing parameters after a -- to the child process. In
> my case I'm using it to toggle MTTCG on an off:
> =

>   ./run_tests.sh -- --accel tcg,thread=3Dmulti
> =

> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> =

> ---
> v1
>   - changes from -o to --
>   - fixed whitespace damage
> ---
>  README.md              |  6 ++++++
>  run_tests.sh           | 13 +++++++++++--
>  scripts/functions.bash |  7 ++++---
>  3 files changed, 21 insertions(+), 5 deletions(-)
> =

> diff --git a/README.md b/README.md
> index fa3a445..1bd6dcb 100644
> --- a/README.md
> +++ b/README.md
> @@ -55,6 +55,12 @@ To extend or disable the timeouts:
>  =

>      TIMEOUT=3D0 ./run_tests.sh
>  =

> +Any arguments past the end-of-arguments marker (--) is passed on down
> +to the QEMU invocation. This can of course be combined with the other
> +modifiers:
> +
> +    ACCEL=3Dtcg ./run_tests.sh -v -- --accel tcg,thread=3Dmulti
> +
>  # Contributing
>  =

>  ## Directory structure
> diff --git a/run_tests.sh b/run_tests.sh
> index 254129d..3270fba 100755
> --- a/run_tests.sh
> +++ b/run_tests.sh
> @@ -13,7 +13,7 @@ function usage()
>  {
>  cat <<EOF
>  =

> -Usage: $0 [-g group] [-h] [-v]
> +Usage: $0 [-g group] [-h] [-v] [-- QEMU options]
>  =

>      -g: Only execute tests in the given group
>      -h: Output this help text
> @@ -22,6 +22,8 @@ Usage: $0 [-g group] [-h] [-v]
>  Set the environment variable QEMU=3D/path/to/qemu-system-ARCH to
>  specify the appropriate qemu binary for ARCH-run.
>  =

> +All options specified after -- are passed on to QEMU.
> +
>  EOF
>  }
>  =

> @@ -29,6 +31,7 @@ RUNTIME_arch_run=3D"./$TEST_DIR/run"
>  source scripts/runtime.bash
>  =

>  while getopts "g:hv" opt; do
> +

stray blank line added?

>      case $opt in
>          g)
>              only_group=3D$OPTARG
> @@ -46,6 +49,12 @@ while getopts "g:hv" opt; do
>      esac
>  done
>  =

> +# Any options left for QEMU?
> +shift $((OPTIND-1))
> +if [ "$#" -gt  0 ]; then
> +    extra_opts=3D"$@"
> +fi

We can unconditionally do the extra_opts=3D"$@", extra_opts will just
be null in the case there aren't more args, like it was before.

> +
>  RUNTIME_log_stderr () { cat >> test.log; }
>  RUNTIME_log_stdout () {
>      if [ "$PRETTY_PRINT_STACKS" =3D "yes" ]; then
> @@ -59,4 +68,4 @@ RUNTIME_log_stdout () {
>  config=3D$TEST_DIR/unittests.cfg
>  rm -f test.log
>  printf "BUILD_HEAD=3D$(cat build-head)\n\n" > test.log
> -for_each_unittest $config run
> +for_each_unittest $config run "$extra_opts"
> diff --git a/scripts/functions.bash b/scripts/functions.bash
> index ee9143c..60fbc6a 100644
> --- a/scripts/functions.bash
> +++ b/scripts/functions.bash
> @@ -3,10 +3,11 @@ function for_each_unittest()
>  {
>  	local unittests=3D"$1"
>  	local cmd=3D"$2"
> +	local extra_opts=3D$3
>  	local testname
>  	local smp
>  	local kernel
> -	local opts
> +	local opts=3D$extra_opts
>  	local groups
>  	local arch
>  	local check
> @@ -21,7 +22,7 @@ function for_each_unittest()
>  			testname=3D${BASH_REMATCH[1]}
>  			smp=3D1
>  			kernel=3D""
> -			opts=3D""
> +			opts=3D$extra_opts
>  			groups=3D""
>  			arch=3D""
>  			check=3D""
> @@ -32,7 +33,7 @@ function for_each_unittest()
>  		elif [[ $line =3D~ ^smp\ *=3D\ *(.*)$ ]]; then
>  			smp=3D${BASH_REMATCH[1]}
>  		elif [[ $line =3D~ ^extra_params\ *=3D\ *(.*)$ ]]; then
> -			opts=3D${BASH_REMATCH[1]}
> +			opts=3D"$opts ${BASH_REMATCH[1]}"

How do QEMU opts work with respect to precedence? If the later
opts override the earlier (I think they do), then we should put
opts after rematch here, because the user explicitly added those
options to the command line, and therefore probably prefers them.

>  		elif [[ $line =3D~ ^groups\ *=3D\ *(.*)$ ]]; then
>  			groups=3D${BASH_REMATCH[1]}
>  		elif [[ $line =3D~ ^arch\ *=3D\ *(.*)$ ]]; then
> -- =

> 2.11.0
>

Thanks for this patch! I'm looking forward to making use of it for
testing Peter's EL2 series with/without "-machine virtualization=3Don"

drew
