From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v5 5/6] target-arm: kvm64 fix save/restore of SPSR regs
Date: Thu, 26 Mar 2015 17:25:28 +0000
Message-ID: <CAFEAcA-eGLYSF+T8siJKh+N2SZ+9T_pJ-rw80eFByzOT2W1LwA@mail.gmail.com>
References: <1427130344-27986-1-git-send-email-alex.bennee@linaro.org> <1427130344-27986-6-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1427130344-27986-6-git-send-email-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Cc: QEMU Developers <qemu-devel@nongnu.org>, kvm-devel <kvm@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 23 March 2015 at 17:05, Alex Benn=C3=A9e <alex.bennee@linaro.org> wr=
ote:
> The current code was negatively indexing the cpu state array and not
> synchronizing banked spsr register state with the current mode's spsr
> state, causing occasional failures with migration.
>
> Some munging is done to take care of the aarch64 mapping and also to
> ensure the most current value of the spsr is updated to the banked
> registers (relevant for KVM<->TCG migration).
>
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
> v5
>  - fix banking index now banking fixed
>  - keep wide spacing on [ ] forms
>  - claimed authorship
>
> diff --git a/target-arm/kvm64.c b/target-arm/kvm64.c
> index 857e970..5270fa7 100644
> --- a/target-arm/kvm64.c
> +++ b/target-arm/kvm64.c
> @@ -139,6 +139,7 @@ int kvm_arch_put_registers(CPUState *cs, int leve=
l)
>      uint64_t val;
>      int i;
>      int ret;
> +    unsigned int el;
>
>      ARMCPU *cpu =3D ARM_CPU(cs);
>      CPUARMState *env =3D &cpu->env;
> @@ -205,9 +206,24 @@ int kvm_arch_put_registers(CPUState *cs, int lev=
el)
>          return ret;
>      }
>
> +    /* Saved Program State Registers
> +     *
> +     * Before we restore from the banked_spsr[] array we need to
> +     * ensure that any modifications to env->spsr are correctly
> +     * reflected in the banks.
> +     */
> +    el =3D arm_current_el(env);
> +    if (el > 0) {
> +        i =3D is_a64(env) ?
> +            aarch64_banked_spsr_index(el) :
> +            bank_number(env->uncached_cpsr & CPSR_M);
> +        env->banked_spsr[i] =3D env->spsr;

This doesn't look right. If we're currently A64 then
env->spsr is unused and this code will trash one of
the banked_spsr[] fields.

> +    }
> +
> +    /* KVM 0-4 map to QEMU banks 1-5 */
>      for (i =3D 0; i < KVM_NR_SPSR; i++) {
>          reg.id =3D AARCH64_CORE_REG(spsr[i]);
> -        reg.addr =3D (uintptr_t) &env->banked_spsr[i - 1];
> +        reg.addr =3D (uintptr_t) &env->banked_spsr[i + 1];
>          ret =3D kvm_vcpu_ioctl(cs, KVM_SET_ONE_REG, &reg);
>          if (ret) {
>              return ret;
> @@ -253,11 +269,13 @@ int kvm_arch_put_registers(CPUState *cs, int le=
vel)
>      return ret;
>  }
>
> +

Stray extra space.

-- PMM
