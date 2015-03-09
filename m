From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 5/6] target-arm: kvm64 fix save/restore of SPSR regs
Date: Mon, 9 Mar 2015 14:26:11 +0100
Message-ID: <20150309132611.GB20559@cbox>
References: <1425479753-18349-1-git-send-email-alex.bennee@linaro.org>
 <1425479753-18349-6-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE0D148180
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Mar 2015 09:19:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KX86+fP4sBjY for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Mar 2015 09:19:43 -0400 (EDT)
Received: from mail-lb0-f180.google.com (mail-lb0-f180.google.com
 [209.85.217.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C895648172
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Mar 2015 09:19:42 -0400 (EDT)
Received: by lbiz12 with SMTP id z12so48168639lbi.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Mar 2015 06:25:56 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1425479753-18349-6-git-send-email-alex.bennee@linaro.org>
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
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, qemu-devel@nongnu.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Mar 04, 2015 at 02:35:52PM +0000, Alex Benn=E9e wrote:
> From: Christoffer Dall <christoffer.dall@linaro.org>
> =

> The current code was negatively indexing the cpu state array and not
> synchronizing banked spsr register state with the current mode's spsr
> state, causing occasional failures with migration.
> =

> Some munging is done to take care of the aarch64 mapping and also to
> ensure the most current value of the spsr is updated to the banked
> registers (relevant for KVM<->TCG migration).
> =

> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> =

> ---
> v2 (ajb)
>   - minor tweaks and clarifications
> v3
>   - Use the correct bank index function for setting/getting env->spsr
>   - only deal with spsrs in elevated exception levels
> =

> diff --git a/target-arm/kvm64.c b/target-arm/kvm64.c
> index c60e989..45e5c3f 100644
> --- a/target-arm/kvm64.c
> +++ b/target-arm/kvm64.c
> @@ -140,6 +140,7 @@ int kvm_arch_put_registers(CPUState *cs, int level)
>      uint64_t val;
>      int i;
>      int ret;
> +    unsigned int el;
>  =

>      ARMCPU *cpu =3D ARM_CPU(cs);
>      CPUARMState *env =3D &cpu->env;
> @@ -206,9 +207,27 @@ int kvm_arch_put_registers(CPUState *cs, int level)
>          return ret;
>      }
>  =

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
> +            /* KVM only maps KVM_SPSR_SVC to KVM_SPSR_EL1 for aarch64 AT=
M */

not sure about the 'for aarch64' comment; I would say that it's for
aarch32 support.  Also, you can drop the ATM, since this is user space
ABI that we don't change easily.


don't you need to do env->banked_spsr[0] =3D env->spsr first?

> +            env->banked_spsr[1] =3D env->banked_spsr[0];


> +        } else {
> +            i =3D bank_number(env->uncached_cpsr & CPSR_M);
> +            env->banked_spsr[i] =3D env->spsr;

so here we don't need to worry about banked_spsr[1] =3D banked_spsr[0]
because banked_spsr[0] is meaningless for 32-bit state and we only sync
banked_spsr[1] and up to KVM, correct?  I think this is what may deserve
a comment.

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
> @@ -253,6 +272,7 @@ int kvm_arch_get_registers(CPUState *cs)
>      struct kvm_one_reg reg;
>      uint64_t val;
>      uint32_t fpr;
> +    unsigned int el;
>      int i;
>      int ret;
>  =

> @@ -325,15 +345,35 @@ int kvm_arch_get_registers(CPUState *cs)
>          return ret;
>      }
>  =

> +    /* Fetch the SPSR registers
> +     *
> +     * KVM has an array of state indexed for all the possible aarch32
> +     * privilage levels. Although not all are valid at all points

privilege

> +     * there are some transitions possible which can access old state
> +     * so it is worth keeping them all.
> +     */

dubious comment overall

>      for (i =3D 0; i < KVM_NR_SPSR; i++) {
>          reg.id =3D AARCH64_CORE_REG(spsr[i]);
> -        reg.addr =3D (uintptr_t) &env->banked_spsr[i - 1];
> +        reg.addr =3D (uintptr_t) &env->banked_spsr[i+1];
>          ret =3D kvm_vcpu_ioctl(cs, KVM_GET_ONE_REG, &reg);
>          if (ret) {
>              return ret;
>          }
>      }
>  =

> +    el =3D arm_current_el(env);
> +    if (el > 0) {
> +        if (is_a64(env)) {
> +            g_assert(el =3D=3D 1);
> +            /* KVM maps KVM_SPSR_SVC to KVM_SPSR_EL1 for aarch64 */

same as above

> +            env->banked_spsr[0] =3D env->banked_spsr[1];
> +            i =3D aarch64_banked_spsr_index(el);
> +        } else {
> +            i =3D bank_number(env->uncached_cpsr & CPSR_M);

same potential place for comment as above.

> +        }
> +        env->spsr =3D env->banked_spsr[i];
> +    }
> +
>      /* Advanced SIMD and FP registers */
>      for (i =3D 0; i < 32; i++) {
>          reg.id =3D AARCH64_SIMD_CORE_REG(fp_regs.vregs[i]);
> -- =

> 2.3.1
> =
