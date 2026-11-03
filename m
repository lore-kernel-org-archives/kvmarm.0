Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793721646;
	b=yrPPJN2nZ1bpQQyprjep2xc58/wVOzNzCoP87yUHa6XFpZo8X0lq+rRM2PyoAvlXVGwt
	 Mmyg8csdZsu7uscfQLs0uITdiHi3+XgLuqndDZ6ARGAQnSq/mR7AtjXrXcRQtPuACz11x
	 ImfwFvX86bgE3MTBoqlmLZhNlEsQQX17rTVoSgQDy018hZfgo2t1JT2jp4c8XMJNnQmnV
	 gGLOsJTb8cMrOB/GbQBpHuqY1TBca4UcoEGfJii72aBhHyYEpB04EPyETBht0deRskijO
	 3YnlKK3ddwT4ncS5FPTLI5GEl5nahTaoSycK2LrrJfCrcfBKNXQgZOC2FvubIs4wVYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793721646;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=VM2xUMqlvZUWHJVPQPZMkrWO6MVfESPs+MulljspmYU=;
	b=irPHdmngA/PpYymxesfUhY9hIw8QLXpKfIDZR7OZ5pxBoear26aX5zXMwGNv7g+dzh7V
	 SKHxYrBThxG3O9/6M9dYyAIe8nsz7o2kNIdxiBu5TusUAV43KWfvjoQ3VsAuQonFQY+yo
	 T0CN67yGV7FDrrHXMNdWd3sZO/7JMC10mJzbVnE8kX0RPkU+fRKj2MrrqPo4jgFsilEdj
	 Y5N9Uz/Va1SOp7J+jhD4RYCSi2BjabHDolbD83cDl6VHVsTj2W5dbQVNVTM5iuW4TnYpZ
	 pyaTQ1uAZB5QgVbCAC48UlECEbzLxaj6b37ZzdYa+G0UhN4uCDGBxmUdR6RUdxYb+qQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="nwteXk/V";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3138606D81E;
	Tue,  3 Nov 2026 16:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nwteXk/V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 096031F000C1;
	Tue,  3 Nov 2026 16:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793721645;
	bh=VM2xUMqlvZUWHJVPQPZMkrWO6MVfESPs+MulljspmYU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nwteXk/VvpcUznKRUNJgDnXsaK6Uc/HAq6pQLbpDUhnEKAxidiPztx51ujx+GCaVo
	 8O6jAK+IukWDVGegikgeqUwsrbF4x8SbYVrYOXStufScvN967N7P3BpucEoLoswH+B
	 bzItCkqp1Iq3D7x73cLhFSf0eeNZ65QnquJ15fkJlWuJdYMaq4kCZnCZ4VVYYHo72e
	 JgKHCq0EqxIxm8VDDrafLyg43NDjwqSHVoxfYNAS4s0pCtVow0fdsK3mx4m7+GA4ZP
	 QztwBbfJVJ8LwNcyDp5LL7l9OC2yG6BubanpaKg8U/ai4WFzzzodh45uD1nGOAwi+g
	 /mdhKphEqLBcw==
Date: Tue, 3 Nov 2026 16:00:39 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev, 
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	will@kernel.org, mark.rutland@arm.com, linux-perf-users@vger.kernel.org, 
	catalin.marinas@arm.com, james.clark@linaro.org
Subject: Re: [RFC PATCH v7 19/28] KVM: arm64: VHE: Context switch SPE state
Message-ID: <aunTMX7oOYNqmMFg@gremlin>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-20-alexandru.elisei@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903160623.315525-20-alexandru.elisei@arm.com>

On Thu, Sep 03, 2026 at 05:06:14PM +0100, Alexandru Elisei wrote:
> Save and restore the SPE register state when a VCPU is run. The SPE
> resources are shared between the guest and the host (the resources are not
> partitioned) so KVM has to save the host state, change the owning

Digging into this it seems that while there are as many _SPE instances_ as
distinctly heterogeneous CPU types in a system (e.g. 2 for big.LITTLE) BUT
there are as many _units_.

However obviously all of this is shared between guest and host there's no
partitioning at that level.

> translation regime, and then restore the guest state before entering a
> guest. The sequence is performed in reverse when exiting a guest.

Ack.

>
> Somewhat unexpectedly, the owning regime is not modified in
> kvm_arm_setup_mdcr_el2(), where MDCR_EL2 is written in the VHE case. That's

nVHE guests don't get SPE at all right?

I'd perhaps rephrase this is a bit as 'somewhat unexpectedly' suggests that
there is a surprising thing that already exists in this logic :) Also I
think implied from function name that MDCR_EL2 is written.

Maybe something like:

	"Counterintuitively, the owning regime cannot be altered in
	kvm_arm_setup_mdcr_el2(), because there is a window when the VCPU
	runs with interrupts enabled..."

> because after kvm_arm_setup_mdcr_el2() there is a window where the VCPU
> runs with interrupts enabled, and during this window perf on the host might
> install a new event on the physical CPU via an IPI. If the owning regime
> were modified in kvm_arm_setup_mdcr_el2(), the buffer would use the guest
> EL1 translation tables to write to memory, leading at best to buffer
> management events due to faults, at worst to random memory corruption.

I think you need another paragraph to say what it is you do re: owning
regime in light of this.

Also worth calling out the relevant register field, MDCR_EL2.E2PB I think?

OK so [0] tells me that MDCR_EL2 is the register used to control debug
configuration, which includes 3 SPE fields MDCR_EL2.HPMFZS (hyp performance
monitors freeze-on-SPE event), MDCR_EL2.TPMS (trap performance monitor
sampling), MDCR_EL2.E2PB (EL2 profiling buffer).

And these are the ones that need to be saved/restored.

[0]:https://support.arm.com/documentation/ddi0601/2026-09/AArch64-Registers/MDCR-EL2--Monitor-Debug-Configuration-Register--EL2-?lang=en

>
> Note that now the host now stops profiling KVM in

NIT: 'Note that now the host' -> 'Note that the host now'.

> __kvm_spe_save_host_state_vhe(), as opposed to when the guest starts
> executing with PMSCR_EL1.{E1SPE,E0SPE} = {0,0} following the ERET to EL1.
>
> Buffer management event interrupts will be handled later.
>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |   1 +
>  arch/arm64/include/asm/kvm_hyp.h  |  26 +++-
>  arch/arm64/include/asm/kvm_spe.h  |   4 +
>  arch/arm64/kvm/arm.c              |   4 +-
>  arch/arm64/kvm/hyp/vhe/Makefile   |   1 +
>  arch/arm64/kvm/hyp/vhe/debug-sr.c |  18 +++
>  arch/arm64/kvm/hyp/vhe/spe-sr.c   | 209 ++++++++++++++++++++++++++++++
>  arch/arm64/kvm/hyp/vhe/switch.c   |   9 ++
>  arch/arm64/kvm/spe.c              |   9 ++
>  9 files changed, 279 insertions(+), 2 deletions(-)
>  create mode 100644 arch/arm64/kvm/hyp/vhe/spe-sr.c
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index b92b19229c36..81abfb705aeb 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -796,6 +796,7 @@ struct kvm_host_data {
>  		struct kvm_guest_debug_arch regs;
>  		/* Statistical profiling extension */
>  		u64 pmscr_el1;

I was curious where this field came from, and it seems it is commit
f85279b4bd48 ("arm64: KVM: Save/restore the host SPE state when
entering/leaving a VM"), where Will added a little dance for nVHE SPE :)

> +		u64 pmscr_el2;

See below, I wonder if adding the field here is the right thing to do.

>  		u64 pmblimitr_el1;
>  		/* Self-hosted trace */
>  		u64 trfcr_el1;
> diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> index 4974492744cc..a98c0d445260 100644
> --- a/arch/arm64/include/asm/kvm_hyp.h
> +++ b/arch/arm64/include/asm/kvm_hyp.h
> @@ -119,7 +119,31 @@ void __debug_switch_to_host(struct kvm_vcpu *vcpu);
>  #ifdef __KVM_NVHE_HYPERVISOR__
>  void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu);
>  void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu);
> -#endif
> +#else
> +#ifdef CONFIG_KVM_ARM_SPE
> +void __kvm_spe_save_host_state_vhe(struct kvm_vcpu *vcpu, struct kvm_cpu_context *host_ctxt);
> +void __kvm_spe_restore_guest_state_vhe(struct kvm_vcpu *vcpu, struct kvm_cpu_context *guest_ctxt);
> +void __kvm_spe_save_guest_state_vhe(struct kvm_vcpu *vcpu, struct kvm_cpu_context *guest_ctxt);
> +void __kvm_spe_restore_host_state_vhe(struct kvm_vcpu *vcpu, struct kvm_cpu_context *host_ctxt);
> +#else
> +static inline void __kvm_spe_save_host_state_vhe(struct kvm_vcpu *vcpu,
> +						 struct kvm_cpu_context *host_ctxt)
> +{
> +}
> +static inline void __kvm_spe_restore_guest_state_vhe(struct kvm_vcpu *vcpu,
> +						     struct kvm_cpu_context *guest_ctxt)
> +{
> +}
> +static inline void __kvm_spe_save_guest_state_vhe(struct kvm_vcpu *vcpu,
> +						  struct kvm_cpu_context *guest_ctxt)
> +{
> +}
> +static inline void __kvm_spe_restore_host_state_vhe(struct kvm_vcpu *vcpu,
> +						    struct kvm_cpu_context *host_ctxt)
> +{
> +}
> +#endif /* CONFIG_KVM_ARM_SPE */
> +#endif /* __KVM_NVHE_HYPERVISOR__ */
>
>  u64 __guest_enter(struct kvm_vcpu *vcpu);
>
> diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
> index 618051dcf59f..ad0ad6ace93c 100644
> --- a/arch/arm64/include/asm/kvm_spe.h
> +++ b/arch/arm64/include/asm/kvm_spe.h
> @@ -30,6 +30,7 @@ bool kvm_supports_spe(void);
>  bool kvm_vcpu_spe_initialized(struct kvm_vcpu *vcpu);
>
>  int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu);
> +void kvm_vcpu_put_spe_vhe(struct kvm_vcpu *vcpu);
>  void kvm_spe_destroy_vm(struct kvm *kvm);
>
>  void kvm_spe_finalize_idregs(struct kvm *kvm);
> @@ -68,6 +69,9 @@ static inline int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu)
>  {
>  	return 0;
>  }
> +static inline void kvm_vcpu_put_spe_vhe(struct kvm_vcpu *vcpu)
> +{
> +}
>  static inline void kvm_spe_destroy_vm(struct kvm *kvm)
>  {
>  }
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index c9a026c61ce7..5992efc4f94b 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -804,8 +804,10 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>
>  	kvm_vcpu_put_debug(vcpu);
>  	kvm_arch_vcpu_put_fp(vcpu);
> -	if (has_vhe())
> +	if (has_vhe()) {
> +		kvm_vcpu_put_spe_vhe(vcpu);
>  		kvm_vcpu_put_vhe(vcpu);
> +	}
>  	kvm_timer_vcpu_put(vcpu);
>  	kvm_vgic_put(vcpu);
>  	kvm_vcpu_pmu_restore_host(vcpu);
> diff --git a/arch/arm64/kvm/hyp/vhe/Makefile b/arch/arm64/kvm/hyp/vhe/Makefile
> index d6b3475145c0..e757d7a24212 100644
> --- a/arch/arm64/kvm/hyp/vhe/Makefile
> +++ b/arch/arm64/kvm/hyp/vhe/Makefile
> @@ -11,3 +11,4 @@ CFLAGS_switch.o += -Wno-override-init
>  obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o
>  obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
>  	 ../hyp-entry.o ../exception.o ../vgic-v5-sr.o
> +obj-$(CONFIG_KVM_ARM_SPE) += spe-sr.o
> diff --git a/arch/arm64/kvm/hyp/vhe/debug-sr.c b/arch/arm64/kvm/hyp/vhe/debug-sr.c
> index 0100339b09e0..7b03f2611259 100644
> --- a/arch/arm64/kvm/hyp/vhe/debug-sr.c
> +++ b/arch/arm64/kvm/hyp/vhe/debug-sr.c
> @@ -13,9 +13,27 @@
>  void __debug_switch_to_guest(struct kvm_vcpu *vcpu)
>  {
>  	__debug_switch_to_guest_common(vcpu);
> +	if (vcpu_has_spe(vcpu)) {
> +		u64 mdcr_el2 = vcpu->arch.mdcr_el2;

Be good to have a comment here to explain what you're doing :) though I
assume this is related to the commit message stuff about interrupts?

> +
> +		mdcr_el2 &= ~MDCR_EL2_E2PB;
> +		/* Set buffer owner to EL1 and trap the buffer registers. */
> +		mdcr_el2 |= FIELD_PREP(MDCR_EL2_E2PB, MDCR_EL2_E2PB_EL1_TRAP);
> +
> +		/* Do not trap sampling control registers. */
> +		mdcr_el2 &= ~MDCR_EL2_TPMS;

Why? Isn't E2PB the only field affected by the interrupts concern?

Can't this just be cleared in kvm_arm_setup_mdcr_el2() like:

static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
{
	...

        vcpu->arch.mdcr_el2 |= (MDCR_EL2_TPM |
                                MDCR_EL2_TPMS |
                                MDCR_EL2_TTRF |
                                MDCR_EL2_TPMCR |
                                MDCR_EL2_TDRA |
                                MDCR_EL2_TDOSA);

+       /* SPE guests get the sampling control registers untrapped. */
+       if (vcpu_has_spe(vcpu))
+               vcpu->arch.mdcr_el2 &= ~MDCR_EL2_TPMS;
+
        /* Is the VM being debugged by userspace? */
	...
}

> +		write_sysreg(mdcr_el2, mdcr_el2);
> +		/* Synchronise MDCR_EL2 and HCR_EL2 writes. */

Hmm but there's no HCR_EL2 write here?

> +		isb();
> +	}
>  }

It seems this code is in the wrong place, I think __debug_switch_to_guest()
should stay the same and the guest bit put in
__kvm_spe_restore_guest_state_vhe(), e.g.:

void __kvm_spe_restore_guest_state_vhe(struct kvm_vcpu *vcpu, struct kvm_cpu_context *guest_ctxt)
{
+	u64 mdcr_el2 = vcpu->arch.mdcr_el2;
	u64 pmblimitr, pmbsr;

+	/* Buffer owned by EL1, buffer registers trapped. */
+	mdcr_el2 &= ~MDCR_EL2_E2PB;
+	mdcr_el2 |= FIELD_PREP(MDCR_EL2_E2PB, MDCR_EL2_E2PB_EL1_TRAP);
+	write_sysreg(mdcr_el2, mdcr_el2);
+	isb();

	pmbsr = ctxt_sys_reg(guest_ctxt, PMBSR_EL1);
	...
}

And the host side to the top of __kvm_spe_restore_host_state_vhe() which
already has the ISB and that simplifies that bit too, e.g.:

void __kvm_spe_restore_host_state_vhe(struct kvm_vcpu *vcpu, struct kvm_cpu_context *host_ctxt)
{
	u64 pmbsr, pmblimitr;

-       /* Synchronise MDCR_EL2.{E2PB,TPMS} write. */
+       /* Buffer owned by EL2 again. */
+       write_sysreg(*host_data_ptr(host_debug_state.mdcr_el2), mdcr_el2);
+       /* Synchronise the MDCR_EL2.E2PB write before touching the buffer. */
	isb();

	pmbsr = ctxt_sys_reg(host_ctxt, PMBSR_EL1);
	pmblimitr = ctxt_sys_reg(host_ctxt, PMBLIMITR_EL1);

	write_sysreg_s(pmbsr, SYS_PMBSR_EL1);
	write_sysreg_s(ctxt_sys_reg(host_ctxt, PMBPTR_EL1), SYS_PMBPTR_EL1);
	...
}

With the TPMS stuff in kvm_arm_setup_mdcr_el2() as per the review comment
below on that.

>
>  void __debug_switch_to_host(struct kvm_vcpu *vcpu)
>  {
> +	if (vcpu_has_spe(vcpu)) {
> +		write_sysreg(*host_data_ptr(host_debug_state.mdcr_el2), mdcr_el2);

I wonder whether switching out the entire register is right here? Because
obviously now non-SPE is not doing this.

Perhaps better to only save/restore the relevant fields and leave the
register otherwise as-is?

Otherwise could be a future foot-gun if somebody somewhere changes a field
that then gets overwritten.

Also, I mention it below, but seems inconsistent to have a specific field
for this but to use the general sysreg fields for the other SPE registers.

> +		/* Synchronise MDCR_EL2 and HCR_EL2 writes. */
> +		isb();
> +	}
>  	__debug_switch_to_host_common(vcpu);
>  }
> diff --git a/arch/arm64/kvm/hyp/vhe/spe-sr.c b/arch/arm64/kvm/hyp/vhe/spe-sr.c
> new file mode 100644
> index 000000000000..978620ad99fa
> --- /dev/null
> +++ b/arch/arm64/kvm/hyp/vhe/spe-sr.c
> @@ -0,0 +1,209 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2021 - ARM Ltd
> + */
> +
> +#include <linux/kvm_host.h>
> +
> +#include <asm/kvm_hyp.h>
> +#include <asm/kprobes.h>
> +#include <asm/kvm_spe.h>
> +
> +static void __kvm_spe_save_sampling_regs(struct kvm *kvm, struct kvm_cpu_context *ctxt)
> +{
> +	/*
> +	 * This is dependent on the VM features, and not the hardware features,
> +	 * even for the host, because (a) guest accesses to PMSNEVFR_EL1 and
> +	 * PMSDSFR_EL1 result in an undefined exception in the guest and (b)
> +	 * they don't affect the guest unless the guest explicitly enables them,
> +	 * and a well-behaved guest shouldn't enable them when the corresponding
> +	 * feature is not advertised.
> +	 */
> +	if (kvm_spe_has_feat_spe_fne(kvm))
> +		ctxt_sys_reg(ctxt, PMSNEVFR_EL1) = read_sysreg_s(SYS_PMSNEVFR_EL1);

See my reply to the sashiko thread. TL;DR is to use the PMSIDR_EL1 state
instead, e.g.:

static bool spe_hw_has_fne(struct kvm *kvm)
{
        struct arm_spe_pmu *spe_pmu = kvm->arch.kvm_spe.spe_pmu;

        return FIELD_GET(PMSIDR_EL1_FnE, spe_pmu->pmsidr_el1);
}

...

        if (spe_hw_has_fne(kvm))
                ctxt_sys_reg(ctxt, PMSNEVFR_EL1) = read_sysreg_s(SYS_PMSNEVFR_EL1);

It also allows you to get rid of the big comment :)

> +	ctxt_sys_reg(ctxt, PMSICR_EL1) = read_sysreg_s(SYS_PMSICR_EL1);
> +	ctxt_sys_reg(ctxt, PMSIRR_EL1) = read_sysreg_s(SYS_PMSIRR_EL1);
> +	ctxt_sys_reg(ctxt, PMSFCR_EL1) = read_sysreg_s(SYS_PMSFCR_EL1);
> +	ctxt_sys_reg(ctxt, PMSEVFR_EL1) = read_sysreg_s(SYS_PMSEVFR_EL1);
> +	ctxt_sys_reg(ctxt, PMSLATFR_EL1) = read_sysreg_s(SYS_PMSLATFR_EL1);
> +	if (kvm_spe_has_feat_spe_fds(kvm))
> +		ctxt_sys_reg(ctxt, PMSDSFR_EL1) = read_sysreg_s(SYS_PMSDSFR_EL1);

And as-per above, equivalently:

static bool spe_hw_has_fds(struct kvm *kvm)
{
        struct arm_spe_pmu *spe_pmu = kvm->arch.kvm_spe.spe_pmu;

        return FIELD_GET(PMSIDR_EL1_FDS, spe_pmu->pmsidr_el1);
}

...

        if (spe_hw_has_fds(kvm))
                ctxt_sys_reg(ctxt, PMSDSFR_EL1) = read_sysreg_s(SYS_PMSDSFR_EL1);

I think.

> +}
> +
> +static void __kvm_spe_restore_sampling_regs(struct kvm *kvm, struct kvm_cpu_context *ctxt)
> +{
> +	if (kvm_spe_has_feat_spe_fne(kvm))
> +		write_sysreg_s(ctxt_sys_reg(ctxt, PMSNEVFR_EL1), SYS_PMSNEVFR_EL1);
> +	write_sysreg_s(ctxt_sys_reg(ctxt, PMSICR_EL1), SYS_PMSICR_EL1);
> +	write_sysreg_s(ctxt_sys_reg(ctxt, PMSIRR_EL1), SYS_PMSIRR_EL1);
> +	write_sysreg_s(ctxt_sys_reg(ctxt, PMSFCR_EL1), SYS_PMSFCR_EL1);
> +	write_sysreg_s(ctxt_sys_reg(ctxt, PMSEVFR_EL1), SYS_PMSEVFR_EL1);
> +	write_sysreg_s(ctxt_sys_reg(ctxt, PMSLATFR_EL1), SYS_PMSLATFR_EL1);
> +	if (kvm_spe_has_feat_spe_fds(kvm))
> +		write_sysreg_s(ctxt_sys_reg(ctxt, PMSDSFR_EL1), SYS_PMSDSFR_EL1);
> +}
> +
> +/*
> + * Before
> + *  - PMSCR_EL2.E2SPE = 0 or 1
> + *  - PMBLIMITR_EL1.E = 0 or 1
> + *  - PMBSR_EL1.S = 0 or 1
> + *
> + * After:
> + *  - PMSCR_EL2.E2SPE = 0
> + *  - PMBLIMITR_EL1.E = 0
> + *  - PMBSR_EL1.S = 0

These aren't really accurate, since you're clearing _all_ fields in each
register. And you're essentially describing the code which anybody can see
by just reading it.

So I'd mention the _effects_ of the change, more succinctly like:

/*
 * Save host SPE state - stop sampling (PMSCR_EL2), drain and disable the
 * buffer (PMBLIMITR_EL1), clear buffer status (PMBSR_EL1).
 */

Perhaps?

> + */
> +void __kvm_spe_save_host_state_vhe(struct kvm_vcpu *vcpu, struct kvm_cpu_context *host_ctxt)
> +{
> +	u64 pmblimitr, pmscr_el2, pmbsr;
> +
> +	pmscr_el2 = read_sysreg_el2(SYS_PMSCR);
> +	if (FIELD_GET(PMSCR_EL1_E1SPE, pmscr_el2)) {

Should this be PMSCR_EL2_E2SPE? As this is at EL2?

But actually, __kvm_spe_restore_guest_state_vhe() just does this
unconditionally:

	write_sysreg_el2(0, SYS_PMSCR);

So in general I think:

	if (pmscr_el2) {
		write_sysreg_el2(0, SYS_PMSCR);
		isb();
	}

Works better here.

> +		write_sysreg_el2(0, SYS_PMSCR);
> +		isb();

(Just thinking out loud for my own education :) - barrier to ensure that
the effects of the register write take effect.

> +	}
> +
> +	pmblimitr = read_sysreg_s(SYS_PMBLIMITR_EL1);
> +	if (FIELD_GET(PMBLIMITR_EL1_E, pmblimitr)) {

Similar to above this should be:

	if (pmblimitr) {
		...
	}

> +		psb_csync();
> +		dsb(nsh);

OK so fences to sync + WAIT for both async buffered SPE state across
system PEs (inner-shareable).

> +		write_sysreg_s(0, SYS_PMBLIMITR_EL1);
> +		/* Update PMBPTR_EL1 and PMBSR_EL1. */
> +		isb();

And as above, wait for effects of register write to apply.

> +	}
> +
> +	pmbsr = read_sysreg_s(SYS_PMBSR_EL1);
> +	if (FIELD_GET(PMBSR_EL1_S, pmbsr)) {

Similar to above this should be:

	if (pmbsr) {
		...
	}

> +		write_sysreg_s(0, SYS_PMBSR_EL1);
> +		isb();
> +	}
> +
> +	__kvm_spe_save_sampling_regs(vcpu->kvm, host_ctxt);
> +
> +	ctxt_sys_reg(host_ctxt, PMBLIMITR_EL1) = pmblimitr;
> +	ctxt_sys_reg(host_ctxt, PMBPTR_EL1) = read_sysreg_s(SYS_PMBPTR_EL1);
> +	ctxt_sys_reg(host_ctxt, PMBSR_EL1) = pmbsr;
> +
> +	*host_data_ptr(host_debug_state.pmscr_el2) = pmscr_el2;

Hmm, why do the other registers go into actual sysregs but pmscr_el2 is
treated differently and put in kvm_host_data?

Seems like it'd be more consistent to just do the same thing for
everything? Or is there a special reason this is singled out?

> +}
> +NOKPROBE_SYMBOL(__kvm_spe_save_host_state_vhe);
> +
> +static bool __kvm_spe_profiling_buffer_enabled(u64 pmblimitr, u64 pmbsr)
> +{
> +	return FIELD_GET(PMBLIMITR_EL1_E, pmblimitr) && !FIELD_GET(PMBSR_EL1_S, pmbsr);
> +}
> +
> +/*
> + * Before:
> + *  - PMSCR_EL2.E2PE = 0
> + *  - PMBLIMITR_EL1.E = 0
> + *  - PMBSR_EL1.S = 0
> + *
> + * After:
> + *  - PMSCR_EL2.E2SPE = 0
> + *  - PMBLIMITR_EL1.E = 0 or 1
> + *  - PMBSR_EL1.S = 0
> + */

Similar feedback as to __kvm_spe_save_host_state_vhe() on the comment.

> +void __kvm_spe_restore_guest_state_vhe(struct kvm_vcpu *vcpu, struct kvm_cpu_context *guest_ctxt)
> +{
> +	u64 pmblimitr, pmbsr;
> +
> +	pmbsr = ctxt_sys_reg(guest_ctxt, PMBSR_EL1);
> +	pmblimitr = ctxt_sys_reg(guest_ctxt, PMBLIMITR_EL1);
> +	if (__kvm_spe_profiling_buffer_enabled(pmblimitr, pmbsr)) {
> +		write_sysreg_s(ctxt_sys_reg(guest_ctxt, PMBPTR_EL1), SYS_PMBPTR_EL1);

This seems super inconsistent.

pmbsr and pmblimitr and written to local values, but pmbptr isn't?

I think they should all be.

> +		isb();
> +		write_sysreg_s(pmblimitr, SYS_PMBLIMITR_EL1);
> +		isb();
> +		/* A buffer management event preserves fields in PMBSR_EL1 */

I don't think we need this comment, it seems consistent given none are
provided for the other registers.

> +		write_sysreg_s(pmbsr, SYS_PMBSR_EL1);

Why no ISB here?

I think if there are subtle rules about when/when not to apply these a
comment should explain (really on the why not side).

> +	}
> +
> +	__kvm_spe_restore_sampling_regs(vcpu->kvm, guest_ctxt);
> +
> +	write_sysreg_el1(ctxt_sys_reg(guest_ctxt, PMSCR_EL1), SYS_PMSCR);
> +	write_sysreg_el2(0, SYS_PMSCR);
> +}
> +NOKPROBE_SYMBOL(__kvm_spe_restore_guest_state_vhe);

I see everything here does this so kprobe insertion presumably would
absolutely break this stuff.

> +
> +/*
> + * Before:
> + *  - PMSCR_EL2.E2SPE = 0
> + *  - PMBLIMITR_EL1.E = 0 or 1
> + *  - PMBSR_EL1.S = 0 or 1
> + *
> + * After:
> + *  - PMSCR_EL2.E2SPE = 0
> + *  - PMBLIMITR_EL1.E = 0
> + *  - PMBSR_EL1.S = 0
> + */

Similar feedback as to __kvm_spe_save_host_state_vhe() on the comment.

> +void __kvm_spe_save_guest_state_vhe(struct kvm_vcpu *vcpu, struct kvm_cpu_context *guest_ctxt)
> +{
> +	u64 pmblimitr, pmbsr;
> +
> +	pmblimitr = ctxt_sys_reg(guest_ctxt, PMBLIMITR_EL1);
> +	pmbsr = ctxt_sys_reg(guest_ctxt, PMBSR_EL1);
> +
> +	/*
> +	 * Update PMBPTR_EL1 and PMBSR_EL1 only if profiling was enabled
> +	 * when the guest state was resumed.
> +	 */

Inconsistent that the previous blocks like this have no comment but this
one does. Also is this really describing this correctly?

> +	if (__kvm_spe_profiling_buffer_enabled(pmblimitr, pmbsr)) {
> +		psb_csync();
> +		dsb(nsh);
> +		write_sysreg_s(0, SYS_PMBLIMITR_EL1);

This is duplicated from __kvm_spe_save_host_state_vhe(), can it be put into
a shared function?

> +		/* Advance PMBPTR_EL1. */

I'm not sure I understand this comment?

> +		isb();
> +
> +		/* Hardware updates to PMBSR_EL1 are not handled, yet. */
> +		ctxt_sys_reg(guest_ctxt, PMBPTR_EL1) = read_sysreg_s(SYS_PMBPTR_EL1);
> +	}
> +
> +	__kvm_spe_save_sampling_regs(vcpu->kvm, guest_ctxt);
> +
> +	ctxt_sys_reg(guest_ctxt, PMSCR_EL1) = read_sysreg_el1(SYS_PMSCR);
> +}
> +NOKPROBE_SYMBOL(__kvm_spe_save_guest_state_vhe);
> +
> +/*
> + * Before:
> + *  - PMSCR_EL2.E2SPE = 0
> + *  - PMBLIMITR_EL1.E = 0
> + *  - PMBSR_EL1.S = 0
> + *
> + * After:
> + *  - PMSCR_EL2.E2SPE = 0 or 1
> + *  - PMBLIMITR_EL1.E = 0 or 1
> + *  - PMBSR_EL1.S = 0 or 1
> + */

Similar feedback as to __kvm_spe_save_host_state_vhe() on the comment.

> +void __kvm_spe_restore_host_state_vhe(struct kvm_vcpu *vcpu, struct kvm_cpu_context *host_ctxt)
> +{
> +	u64 pmbsr, pmblimitr;
> +
> +	/* Synchronise MDCR_EL2.{E2PB,TPMS} write. */
> +	isb();


Hmm but __kvm_vcpu_run_vhe() runs __debug_switch_to_host() immediately
before (possibly) calling this function:

	__debug_switch_to_host(vcpu);
	if (vcpu_has_spe(vcpu))
		__kvm_spe_restore_host_state_vhe(vcpu, host_ctxt);

And this already does an ISB there? Is this necessary? E.g.:

void __debug_switch_to_host(struct kvm_vcpu *vcpu)
{
	if (vcpu_has_spe(vcpu)) {
		...
		/* Synchronise MDCR_EL2 and HCR_EL2 writes. */
		isb();
	}
	...
}

> +
> +	pmbsr = ctxt_sys_reg(host_ctxt, PMBSR_EL1);
> +	pmblimitr = ctxt_sys_reg(host_ctxt, PMBLIMITR_EL1);
> +
> +	write_sysreg_s(pmbsr, SYS_PMBSR_EL1);
> +	write_sysreg_s(ctxt_sys_reg(host_ctxt, PMBPTR_EL1), SYS_PMBPTR_EL1);

I have learned about the register read/write conventions btw :) confusing.

> +	/*
> +	 * If the enable bit is set:
> +	 *  - If PMBSR_EL1.S = 0, synchronise the write to PMBPTR_EL1.
> +	 *  - If PMBSR_EL1.S = 1, synchronise the write to PMBSR_EL1, which
> +	 *  disables the buffer.
> +	 */
> +	if (FIELD_GET(PMBLIMITR_EL1_E, pmblimitr))
> +		isb();
> +
> +	write_sysreg_s(pmblimitr, SYS_PMBLIMITR_EL1);
> +	if (__kvm_spe_profiling_buffer_enabled(pmblimitr, pmbsr))
> +		isb();
> +
> +	__kvm_spe_restore_sampling_regs(vcpu->kvm, host_ctxt);
> +
> +	write_sysreg_el2(*host_data_ptr(host_debug_state.pmscr_el2), SYS_PMSCR);
> +}
> +NOKPROBE_SYMBOL(__kvm_spe_restore_host_state_vhe);
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index 7875911c0506..a6817a10ae3b 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -613,6 +613,8 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
>  	fpsimd_lazy_switch_to_guest(vcpu);
>
>  	sysreg_save_host_state_vhe(host_ctxt);
> +	if (vcpu_has_spe(vcpu))
> +		__kvm_spe_save_host_state_vhe(vcpu, host_ctxt);
>
>  	/*
>  	 * Note that ARM erratum 1165522 requires us to configure both stage 1
> @@ -625,7 +627,10 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
>  	__kvm_adjust_pc(vcpu);
>
>  	sysreg_restore_guest_state_vhe(guest_ctxt);
> +
>  	__debug_switch_to_guest(vcpu);
> +	if (vcpu_has_spe(vcpu))
> +		__kvm_spe_restore_guest_state_vhe(vcpu, guest_ctxt);
>
>  	do {
>  		/* Jump in the fire! */
> @@ -635,12 +640,16 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
>  	} while (fixup_guest_exit(vcpu, &exit_code));
>
>  	sysreg_save_guest_state_vhe(guest_ctxt);
> +	if (vcpu_has_spe(vcpu))
> +		__kvm_spe_save_guest_state_vhe(vcpu, guest_ctxt);
>
>  	__deactivate_traps(vcpu);
>
>  	sysreg_restore_host_state_vhe(host_ctxt);
>
>  	__debug_switch_to_host(vcpu);
> +	if (vcpu_has_spe(vcpu))
> +		__kvm_spe_restore_host_state_vhe(vcpu, host_ctxt);
>
>  	/*
>  	 * Ensure that all system register writes above have taken effect
> diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
> index 3b285b45332b..af1e19cb8e9a 100644
> --- a/arch/arm64/kvm/spe.c
> +++ b/arch/arm64/kvm/spe.c
> @@ -100,6 +100,15 @@ int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>
> +void kvm_vcpu_put_spe_vhe(struct kvm_vcpu *vcpu)
> +{
> +	if (!vcpu_has_spe(vcpu) || unlikely(vcpu_on_unsupported_cpu(vcpu)))
> +		return;
> +
> +	/* See kvm_debug_init_vhe() */
> +	write_sysreg_el1(0, SYS_PMSCR);
> +}
> +
>  void kvm_spe_destroy_vm(struct kvm *kvm)
>  {
>  	struct arm_spe_pmu *spe_pmu;
> --
> 2.43.0
>
>

--
Cheers, Lorenzo
