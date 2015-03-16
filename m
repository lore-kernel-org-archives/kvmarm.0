From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 4/5] target-arm: kvm64 fix save/restore of SPSR regs
Date: Mon, 16 Mar 2015 13:52:04 +0100
Message-ID: <20150316125204.GB26480@cbox>
References: <1426503716-13931-1-git-send-email-alex.bennee@linaro.org>
 <1426503716-13931-5-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1426503716-13931-5-git-send-email-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, Peter Maydell <peter.maydell@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Mar 16, 2015 at 11:01:55AM +0000, Alex Benn=E9e wrote:
> From: Christoffer Dall <christoffer.dall@linaro.org>
>=20
> The current code was negatively indexing the cpu state array and not
> synchronizing banked spsr register state with the current mode's spsr
> state, causing occasional failures with migration.
>=20
> Some munging is done to take care of the aarch64 mapping and also to
> ensure the most current value of the spsr is updated to the banked
> registers (relevant for KVM<->TCG migration).
>=20
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
>=20
> ---
> v2 (ajb)
>   - minor tweaks and clarifications
> v3
>   - Use the correct bank index function for setting/getting env->spsr
>   - only deal with spsrs in elevated exception levels
> v4
>  - try and make commentary clearer
>  - ensure env->banked_spsr[0] =3D env->spsr before we sync
>=20
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
> =20
>      ARMCPU *cpu =3D ARM_CPU(cs);
>      CPUARMState *env =3D &cpu->env;
> @@ -206,9 +207,29 @@ int kvm_arch_put_registers(CPUState *cs, int lev=
el)
>          return ret;
>      }
> =20
> +    /* Saved Program State Registers
> +     *
> +     * Before we restore from the banked_spsr[] array we need to
> +     * ensure that any modifications to env->spsr are correctly
> +     * reflected and map aarch64 exception levels if required.
> +     */
> +    el =3D arm_current_el(env);
> +    if (el > 0) {
> +        if (is_a64(env)) {
> +            g_assert(el =3D=3D 1);
> +            env->banked_spsr[0] =3D env->spsr;
> +            /* QEMUs AARCH64 EL1 SPSR is in bank 0, so map it to
> +             * KVM_SPSR_SVC for syncing to KVM */
> +            env->banked_spsr[1] =3D env->banked_spsr[0];
> +        } else {
> +            i =3D bank_number(env->uncached_cpsr & CPSR_M);
> +            env->banked_spsr[i] =3D env->spsr;
> +        }
> +    }
> +
>      for (i =3D 0; i < KVM_NR_SPSR; i++) {
>          reg.id =3D AARCH64_CORE_REG(spsr[i]);
> -        reg.addr =3D (uintptr_t) &env->banked_spsr[i - 1];
> +        reg.addr =3D (uintptr_t) &env->banked_spsr[i+1];
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
> =20
> @@ -326,15 +348,34 @@ int kvm_arch_get_registers(CPUState *cs)
>          return ret;
>      }
> =20
> +    /* Fetch the SPSR registers
> +     *
> +     * KVM has an array of state indexed for all the possible aarch3=
2
> +     * privilege levels. These map onto QEMUs aarch32 banks 1 - 4.
> +     */
>      for (i =3D 0; i < KVM_NR_SPSR; i++) {
>          reg.id =3D AARCH64_CORE_REG(spsr[i]);
> -        reg.addr =3D (uintptr_t) &env->banked_spsr[i - 1];
> +        reg.addr =3D (uintptr_t) &env->banked_spsr[i+1];
>          ret =3D kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &reg);
>          if (ret) {
>              return ret;
>          }
>      }
> =20
> +    el =3D arm_current_el(env);
> +    if (el > 0) {
> +        if (is_a64(env)) {
> +            g_assert(el =3D=3D 1);
> +            /* KVM_SPSR_SVC holds the AARCH64 EL1 SPSR which QEMU
> +             * keeps in bank 0 so copy it across. */
> +            env->banked_spsr[0] =3D env->banked_spsr[1];
> +            i =3D aarch64_banked_spsr_index(el);
> +        } else {
> +            i =3D bank_number(env->uncached_cpsr & CPSR_M);
> +        }
> +        env->spsr =3D env->banked_spsr[i];
> +    }
> +
>      /* Advanced SIMD and FP registers */
>      for (i =3D 0; i < 32; i++) {
>          reg.id =3D AARCH64_SIMD_CORE_REG(fp_regs.vregs[i]);
> --=20
> 2.3.2
>=20

looks good!
-Christoffer
