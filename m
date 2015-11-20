From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v9 5/6] target-arm: kvm - re-inject guest debug exceptions
Date: Fri, 20 Nov 2015 16:14:41 +0000
Message-ID: <CAFEAcA9xXULtmcq7n353gZEyObUx+ZafsfNKUep8_CWNmLzdcA@mail.gmail.com>
References: <1447345251-22625-1-git-send-email-alex.bennee@linaro.org> <1447345251-22625-6-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1447345251-22625-6-git-send-email-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Cc: QEMU Developers <qemu-devel@nongnu.org>, qemu-arm@nongnu.org, Christoffer Dall <christoffer.dall@linaro.org>, Zhichao Huang <zhichao.huang@linaro.org>, kvm-devel <kvm@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <marc.zyngier@arm.com>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex@bennee.com>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 12 November 2015 at 16:20, Alex Benn=C3=A9e <alex.bennee@linaro.org>=
 wrote:
> From: Alex Benn=C3=A9e <alex@bennee.com>
>
> If we can't find details for the debug exception in our debug state
> then we can assume the exception is due to debugging inside the guest=
=2E
> To inject the exception into the guest state we re-use the TCG except=
ion
> code (do_interupt).

"do_interrupt".

>
> However while guest debugging is in effect we currently can't handle =
the
> guest using single step which is heavily used by GDB.

Can you expand this to be clearer about what the problem is here?
Is this a thing fixed by this commit or a remaining issue after it?

> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>
> ---
> v5:
>   - new for v5
> ---
>  target-arm/helper-a64.c | 12 ++++++++++--
>  target-arm/kvm.c        | 27 +++++++++++++++++++--------
>  2 files changed, 29 insertions(+), 10 deletions(-)
>
> diff --git a/target-arm/helper-a64.c b/target-arm/helper-a64.c
> index deb8dbe..fc3ccdf 100644
> --- a/target-arm/helper-a64.c
> +++ b/target-arm/helper-a64.c
> @@ -25,6 +25,7 @@
>  #include "qemu/bitops.h"
>  #include "internals.h"
>  #include "qemu/crc32c.h"
> +#include "sysemu/kvm.h"
>  #include <zlib.h> /* For crc32 */
>
>  /* C2.4.7 Multiply and divide */
> @@ -469,7 +470,8 @@ void aarch64_cpu_do_interrupt(CPUState *cs)
>                    new_el);
>      if (qemu_loglevel_mask(CPU_LOG_INT)
>          && !excp_is_internal(cs->exception_index)) {
> -        qemu_log_mask(CPU_LOG_INT, "...with ESR 0x%" PRIx32 "\n",
> +        qemu_log_mask(CPU_LOG_INT, "...with ESR %x/0x%" PRIx32 "\n",
> +                      env->exception.syndrome >> ARM_EL_EC_SHIFT,
>                        env->exception.syndrome);
>      }
>
> @@ -535,6 +537,12 @@ void aarch64_cpu_do_interrupt(CPUState *cs)
>      aarch64_restore_sp(env, new_el);
>
>      env->pc =3D addr;
> -    cs->interrupt_request |=3D CPU_INTERRUPT_EXITTB;
> +
> +    qemu_log_mask(CPU_LOG_INT, "...to EL%d PC 0x%" PRIx64 " PSTATE 0=
x%x\n",
> +                  new_el, env->pc, pstate_read(env));
> +
> +    if (!kvm_enabled()) {
> +        cs->interrupt_request |=3D CPU_INTERRUPT_EXITTB;
> +    }
>  }
>  #endif
> diff --git a/target-arm/kvm.c b/target-arm/kvm.c
> index 1f57e92..4ac177a 100644
> --- a/target-arm/kvm.c
> +++ b/target-arm/kvm.c
> @@ -529,9 +529,10 @@ static int kvm_handle_debug(CPUState *cs, struct=
 kvm_run *run)
>      struct kvm_debug_exit_arch *arch_info =3D &run->debug.arch;
>      int hsr_ec =3D arch_info->hsr >> ARM_EL_EC_SHIFT;
>      ARMCPU *cpu =3D ARM_CPU(cs);
> +    CPUClass *cc =3D CPU_GET_CLASS(cs);
>      CPUARMState *env =3D &cpu->env;
>
> -    /* Ensure PC is synchronised */
> +    /* Ensure all state is synchronised */

You might as well have just written the comment like that to start with=
 :-)

>      kvm_cpu_synchronize_state(cs);
>
>      switch (hsr_ec) {
> @@ -539,7 +540,14 @@ static int kvm_handle_debug(CPUState *cs, struct=
 kvm_run *run)
>          if (cs->singlestep_enabled) {
>              return true;
>          } else {
> -            error_report("Came out of SINGLE STEP when not enabled")=
;
> +            /*
> +             * The kernel should have supressed the guests ability t=
o

"suppressed". "guest's".

> +             * single step at this point so something has gone wrong=
=2E
> +             */
> +            error_report("%s: guest single-step while debugging unsu=
pported"
> +                         " (%"PRIx64", %"PRIx32")\n",
> +                         __func__, env->pc, arch_info->hsr);
> +            return false;

Why didn't we just write the error_report this way to start with?

>          }
>          break;
>      case EC_AA64_BKPT:
> @@ -564,14 +572,17 @@ static int kvm_handle_debug(CPUState *cs, struc=
t kvm_run *run)
>      default:
>          error_report("%s: unhandled debug exit (%"PRIx32", %"PRIx64"=
)\n",
>                       __func__, arch_info->hsr, env->pc);
> +        return false;

Might as well put this "return false;" in the original code that
adds the default case, rather than changing the control flow in this
patch.

>      }
>
> -    /* If we don't handle this it could be it really is for the
> -       guest to handle */
> -    qemu_log_mask(LOG_UNIMP,
> -                  "%s: re-injecting exception not yet implemented"
> -                  " (0x%"PRIx32", %"PRIx64")\n",
> -                  __func__, hsr_ec, env->pc);
> +    /* If we are not handling the debug exception it must belong to
> +     * the guest. Let's re-use the existing TCG interrupt code to se=
t
> +     * everything up properly

Missing trailing ".".

> +     */
> +    cs->exception_index =3D EXCP_BKPT;
> +    env->exception.syndrome =3D arch_info->hsr;
> +    env->exception.vaddress =3D arch_info->far;

You need to set env->exception.target_el to 1 as well.

> +    cc->do_interrupt(cs);
>
>      return false;
>  }
> --
> 2.6.3
>

thanks
-- PMM
