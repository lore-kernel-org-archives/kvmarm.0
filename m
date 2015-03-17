From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v4 4/5] target-arm: kvm64 fix save/restore of SPSR regs
Date: Tue, 17 Mar 2015 16:18:16 +0000
Message-ID: <CAFEAcA8hJTFeR63gJO9QX7nWuFktkehDzGmJjqhTBkTjw4=7Jw@mail.gmail.com>
References: <1426503716-13931-1-git-send-email-alex.bennee@linaro.org> <1426503716-13931-5-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1426503716-13931-5-git-send-email-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Cc: QEMU Developers <qemu-devel@nongnu.org>, kvm-devel <kvm@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 16 March 2015 at 11:01, Alex Benn=C3=A9e <alex.bennee@linaro.org> wr=
ote:
> From: Christoffer Dall <christoffer.dall@linaro.org>
>
> The current code was negatively indexing the cpu state array and not
> synchronizing banked spsr register state with the current mode's spsr
> state, causing occasional failures with migration.
>
> Some munging is done to take care of the aarch64 mapping and also to
> ensure the most current value of the spsr is updated to the banked
> registers (relevant for KVM<->TCG migration).
>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>
> ---
> v2 (ajb)
>   - minor tweaks and clarifications
> v3
>   - Use the correct bank index function for setting/getting env->spsr
>   - only deal with spsrs in elevated exception levels
> v4
>  - try and make commentary clearer
>  - ensure env->banked_spsr[0] =3D env->spsr before we sync
>
> diff --git a/target-arm/kvm64.c b/target-arm/kvm64.c
> index 8fd0c8d..7ddb1b1 100644
> --- a/target-arm/kvm64.c
> +++ b/target-arm/kvm64.c
> @@ -140,6 +140,7 @@ int kvm_arch_put_registers(CPUState *cs, int leve=
l)
>      uint64_t val;
>      int i;
>      int ret;
> +    unsigned int el;
>
>      ARMCPU *cpu =3D ARM_CPU(cs);
>      CPUARMState *env =3D &cpu->env;
> @@ -206,9 +207,29 @@ int kvm_arch_put_registers(CPUState *cs, int lev=
el)
>          return ret;
>      }
>
> +    /* Saved Program State Registers
> +     *
> +     * Before we restore from the banked_spsr[] array we need to
> +     * ensure that any modifications to env->spsr are correctly
> +     * reflected and map aarch64 exception levels if required.

"AArch64". Not entirely sure what the "map exception levels"
is saying.

> +     */
> +    el =3D arm_current_el(env);
> +    if (el > 0) {
> +        if (is_a64(env)) {
> +            g_assert(el =3D=3D 1);
> +            env->banked_spsr[0] =3D env->spsr;

If we're in AArch64 mode then I don't believe
env->spsr has valid content at this point. The live
copy is in env->banked_sprsr[] for all cases.

> +            /* QEMUs AARCH64 EL1 SPSR is in bank 0, so map it to
> +             * KVM_SPSR_SVC for syncing to KVM */

"QEMU's" and "AArch64", but this is just a bug in our
implementation -- the mapping between AArch64 SPSR_EL1
and AArch32 SPSR_svc is architecturally mandated.
We should be using banked_spsr[1] for our regdef for
SPSR_EL1 in helper.c.

Also the "*/" should be on its own line.

> +            env->banked_spsr[1] =3D env->banked_spsr[0];

What is going on here? Architecturally, AArch64 SPSR_EL1
is mapped to AArch32 SPSR_svc, which is env->banked_spsr[1].
env->banked_spsr[0] would be the SPSR for USR and SYS, except
they don't have an SPSR (you cannot take exceptions into them).
I think QEMU just has a banked_spsr[0] for convenience of
implementation and it should never actually be used.
Is this code just working around the QEMU SPSR_EL1 bug?

> +            i =3D bank_number(env->uncached_cpsr & CPSR_M);
> +            env->banked_spsr[i] =3D env->spsr;
> +        }
> +    }
> +
>      for (i =3D 0; i < KVM_NR_SPSR; i++) {
>          reg.id =3D AARCH64_CORE_REG(spsr[i]);
> -        reg.addr =3D (uintptr_t) &env->banked_spsr[i - 1];
> +        reg.addr =3D (uintptr_t) &env->banked_spsr[i+1];

Coding style demands spaces around the "+" operator.

Note that this code is implicitly relying on the
ordering of register banks defined by the bank_number()
function, which is a bit icky.

>          ret =3D kvm_vcpu_ioctl(cs, KVM_SET_ONE_REG, &reg);
>          if (ret) {
>              return ret;
> @@ -254,6 +275,7 @@ int kvm_arch_get_registers(CPUState *cs)
>      struct kvm_one_reg reg;
>      uint64_t val;
>      uint32_t fpr;
> +    unsigned int el;
>      int i;
>      int ret;
>
> @@ -326,15 +348,34 @@ int kvm_arch_get_registers(CPUState *cs)
>          return ret;
>      }
>
> +    /* Fetch the SPSR registers
> +     *
> +     * KVM has an array of state indexed for all the possible aarch3=
2
> +     * privilege levels. These map onto QEMUs aarch32 banks 1 - 4.

QEMU's. AArch32. Also, you mean "1 - 5".

> +     */
>      for (i =3D 0; i < KVM_NR_SPSR; i++) {
>          reg.id =3D AARCH64_CORE_REG(spsr[i]);
> -        reg.addr =3D (uintptr_t) &env->banked_spsr[i - 1];
> +        reg.addr =3D (uintptr_t) &env->banked_spsr[i+1];

Spaces again.

>          ret =3D kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &reg);
>          if (ret) {
>              return ret;
>          }
>      }
>
> +    el =3D arm_current_el(env);
> +    if (el > 0) {
> +        if (is_a64(env)) {
> +            g_assert(el =3D=3D 1);
> +            /* KVM_SPSR_SVC holds the AARCH64 EL1 SPSR which QEMU
> +             * keeps in bank 0 so copy it across. */
> +            env->banked_spsr[0] =3D env->banked_spsr[1];
> +            i =3D aarch64_banked_spsr_index(el);

More workarounds for a bug we should just fix, I think.

> +        } else {
> +            i =3D bank_number(env->uncached_cpsr & CPSR_M);
> +        }
> +        env->spsr =3D env->banked_spsr[i];
> +    }
> +
>      /* Advanced SIMD and FP registers */
>      for (i =3D 0; i < 32; i++) {
>          reg.id =3D AARCH64_SIMD_CORE_REG(fp_regs.vregs[i]);
> --
> 2.3.2

thanks
-- PMM
