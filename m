From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v5 6/6] target-arm: kvm - re-inject guest debug exceptions
Date: Thu, 4 Jun 2015 12:29:49 +0100
Message-ID: <CAFEAcA9dM8yxtOWxzzj4j1hQNp-RfPY1d0qkq4X86icm-oQOGw@mail.gmail.com>
References: <1432912764-7073-1-git-send-email-alex.bennee@linaro.org> <1432912764-7073-7-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1432912764-7073-7-git-send-email-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Cc: QEMU Developers <qemu-devel@nongnu.org>, Christoffer Dall <christoffer.dall@linaro.org>, Zhichao Huang <zhichao.huang@linaro.org>, kvm-devel <kvm@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <marc.zyngier@arm.com>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex@bennee.com>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 29 May 2015 at 16:19, Alex Benn=C3=A9e <alex.bennee@linaro.org> wrot=
e:
> From: Alex Benn=C3=A9e <alex@bennee.com>
>
> If we can't find details for the debug exception in our debug state
> then we can assume the exception is due to debugging inside the guest=
=2E
> To inject the exception into the guest state we re-use the TCG except=
ion
> code (do_interupt).
>
> However while guest debugging is in effect we currently can't handle =
the
> guest using single step which is heavily used by GDB.

Is this just the kernel not supporting this, or would QEMU need
to change as well? Worth mentioning either way.

> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>
> ---
> v5:
>   - new for v5
> ---
>  target-arm/cpu.h        |  1 +
>  target-arm/helper-a64.c | 17 ++++++++++++++---
>  target-arm/internals.h  |  1 +
>  target-arm/kvm.c        | 30 ++++++++++++++++++++++--------
>  4 files changed, 38 insertions(+), 11 deletions(-)
>
> diff --git a/target-arm/cpu.h b/target-arm/cpu.h
> index 083211c..95ae3a8 100644
> --- a/target-arm/cpu.h
> +++ b/target-arm/cpu.h
> @@ -56,6 +56,7 @@
>  #define EXCP_SMC            13   /* Secure Monitor Call */
>  #define EXCP_VIRQ           14
>  #define EXCP_VFIQ           15
> +#define EXCP_WAPT           16

Why do we need a new EXCP value here? In hardware watchpoints
are reported via a particular syndrome value and (for AArch32)
as Data Aborts, so I would expect that we would just do the same.
The code in this patch doesn't seem to treat EXCP_WAPT any
differently from EXCP_DABT...

>  #define ARMV7M_EXCP_RESET   1
>  #define ARMV7M_EXCP_NMI     2
> diff --git a/target-arm/helper-a64.c b/target-arm/helper-a64.c
> index 861f6fa..32bd27d 100644
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
> @@ -478,10 +479,13 @@ void aarch64_cpu_do_interrupt(CPUState *cs)
>      }
>
>      arm_log_exception(cs->exception_index);
> -    qemu_log_mask(CPU_LOG_INT, "...from EL%d\n", arm_current_el(env)=
);
> +    qemu_log_mask(CPU_LOG_INT, "...from EL%d PC 0x%" PRIx64 "\n",
> +                  arm_current_el(env), env->pc);
> +
>      if (qemu_loglevel_mask(CPU_LOG_INT)
>          && !excp_is_internal(cs->exception_index)) {
> -        qemu_log_mask(CPU_LOG_INT, "...with ESR 0x%" PRIx32 "\n",
> +        qemu_log_mask(CPU_LOG_INT, "...with ESR %x/0x%" PRIx32 "\n",
> +                      env->exception.syndrome >> ARM_EL_EC_SHIFT,
>                        env->exception.syndrome);
>      }

If you just want to improve our debug logging that should be
a separate patch.

>
> @@ -494,6 +498,7 @@ void aarch64_cpu_do_interrupt(CPUState *cs)
>      switch (cs->exception_index) {
>      case EXCP_PREFETCH_ABORT:
>      case EXCP_DATA_ABORT:
> +    case EXCP_WAPT:
>          env->cp15.far_el[new_el] =3D env->exception.vaddress;
>          qemu_log_mask(CPU_LOG_INT, "...with FAR 0x%" PRIx64 "\n",
>                        env->cp15.far_el[new_el]);
> @@ -539,6 +544,12 @@ void aarch64_cpu_do_interrupt(CPUState *cs)
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

Do we need a similar change in the AArch32 do_interrupt
code, to handle the case of debugging a 32-bit guest?

>  }
>  #endif
> diff --git a/target-arm/internals.h b/target-arm/internals.h
> index 2cc3017..10e8999 100644
> --- a/target-arm/internals.h
> +++ b/target-arm/internals.h
> @@ -58,6 +58,7 @@ static const char * const excnames[] =3D {
>      [EXCP_SMC] =3D "Secure Monitor Call",
>      [EXCP_VIRQ] =3D "Virtual IRQ",
>      [EXCP_VFIQ] =3D "Virtual FIQ",
> +    [EXCP_WAPT] =3D "Watchpoint",
>  };
>
>  static inline void arm_log_exception(int idx)
> diff --git a/target-arm/kvm.c b/target-arm/kvm.c
> index e1fccdd..6f608d8 100644
> --- a/target-arm/kvm.c
> +++ b/target-arm/kvm.c
> @@ -523,9 +523,11 @@ static int kvm_handle_debug(CPUState *cs, struct=
 kvm_run *run)
>      struct kvm_debug_exit_arch *arch_info =3D &run->debug.arch;
>      int hsr_ec =3D arch_info->hsr >> ARM_EL_EC_SHIFT;
>      ARMCPU *cpu =3D ARM_CPU(cs);
> +    CPUClass *cc =3D CPU_GET_CLASS(cs);
>      CPUARMState *env =3D &cpu->env;
> +    int forward_excp =3D EXCP_BKPT;
>
> -    /* Ensure PC is synchronised */
> +    /* Ensure all state is synchronised */
>      kvm_cpu_synchronize_state(cs);

Not sure the comment is providing any useful information now;
it probably should either be more explanatory or just deleted.

>      switch (hsr_ec) {
> @@ -533,7 +535,14 @@ static int kvm_handle_debug(CPUState *cs, struct=
 kvm_run *run)
>          if (cs->singlestep_enabled) {
>              return true;
>          } else {
> -            error_report("Came out of SINGLE STEP when not enabled")=
;
> +            /*
> +             * The kernel should have supressed the guests ability t=
o

"suppressed"; "guest's".

> +             * single step at this point so something has gone wrong=
=2E
> +             */
> +            error_report("%s: guest single-step while debugging unsu=
pported"
> +                         " (%"PRIx64", %"PRIx32")\n",
> +                         __func__, env->pc, arch_info->hsr);
> +            return false;
>          }
>          break;
>      case EC_AA64_BKPT:
> @@ -549,19 +558,24 @@ static int kvm_handle_debug(CPUState *cs, struc=
t kvm_run *run)
>      case EC_WATCHPOINT:
>          if (kvm_arm_find_hw_watchpoint(cs, arch_info->far)) {
>              return true;
> +        } else {
> +            forward_excp =3D EXCP_WAPT;
>          }
>          break;
>      default:
>          error_report("%s: unhandled debug exit (%"PRIx32", %"PRIx64"=
)\n",
>                       __func__, arch_info->hsr, env->pc);
> +        return false;
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
> +     */
> +    cs->exception_index =3D forward_excp;
> +    env->exception.syndrome =3D arch_info->hsr;

You need to do at least some manipulation of the HSR, surely?
=46or instance, the EC value for "watchpoint from lower exception
level" and "watchpoint from current exception level" are different,
so if this was a wp from EL1 then it'll be reported to KVM (at EL2)
as the former, but if we reflect it into the EL1 guest it should
become the latter.

> +    env->exception.vaddress =3D arch_info->far;

Breakpoints and watchpoints need to set env->exception.fsr too.
You need to set env->exception.target_el as well (patches for
that have now hit master).

I also feel it would be better to set all of hsr/exception_index/
vaddress within the switch cases handling each type of exception,
possibly with a fallback for "generic something's wrong". I think
they turn out to be different enough to make it worth doing, and
it's easier to review the code and be clear that every case is
setting a coherent set of values.

> +    cc->do_interrupt(cs);
>
>      return false;
>  }
> --
> 2.4.1
>

thanks
-- PMM
