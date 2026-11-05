Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793894720;
	b=BulRd9OQZgbDQ/s3gNEQDA5cufz5N7EXIDXPrId1tReF5i1q9YfZ9p9zjzb4vOztTTy7
	 fJWYPokrFluX6HldUKjGaX1aQbztal5i+yJvbhZmcfBm6OPmnq+6SnPEGoeP0Q7Qrqau9
	 rUL5yhp3cY3FfA1p/k7JKAvAdZapCQ81MqC1ThR63tO9AouOags7oL2IOn/bs+j2R1FaR
	 iwhYMRTJmQkGSmXdX4kBEeVYN0K+Tyahz+tiZZf6ES+IXyPwIOnXPDY16xWpoRjlsVJlK
	 nM0wv87bI9D7uNl8C23NBfvI54lsXbqbj+tsaW4d9pBvxFe2yDJWGgWG75yJg+g3l+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793894720;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=kSQwVl0bzl7Tln0PGmEk0go1o5F/ayW/Be/XOnzb4zU=;
	b=ZWumTf9A8qz1/smzbTCI3jZf3Mjkue1B/nqQWfPdrfU3lg9BNB51KpCaJF5bA8NaQxBK
	 sRA/KfF519Uqky/LkDAkSQkE/6wSS4d4dT0sxziAz4O5qDqqN3q4nv+pZTtKqy/ORHo10
	 9RnfYUUR0RDAiNiye6TJUURpm7KotXIsYwsedmDtYPq7J4fC5jaL2eiigwPli2r9W6NJ6
	 RK3z/fIBnUkzUVM7C5p9vYs5h7wd9S+2QkbBz0p6gO3Mrz/YiLTNWPLVshS3q9nLeYc8n
	 2UrLFTpfB5OrIszwIiBFVyz43vRAtwhbdQmyAfKNjp3s5LbHrb/CklT7yy9ggNm4yJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EpCAxwm1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E72606A328;
	Thu,  5 Nov 2026 16:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EpCAxwm1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3BF1F00A16;
	Thu,  5 Nov 2026 16:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793894719;
	bh=kSQwVl0bzl7Tln0PGmEk0go1o5F/ayW/Be/XOnzb4zU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EpCAxwm1Ugkh+f1QS1DQDYwYbGZ3zCC5kpRNeNPPMm8UBslb+KsYaHtw/HStHVJeQ
	 2Upvis9iICFpXbvcoguSiAW8S4N79BTQ7NoO+48M/NxJ32LyOdP8nA7FaQsbfoTP2s
	 dWQ9NKE6g8gbBjDemFjlBCyC/rubEDmgNIxtHfRnrt/6i8xMBrPANgYUQoayYIk3o1
	 O/PSsgBi84NkzxV2oo4lHzl8EoOwQx4pmyRQbvoUaT9Gun5JPnHOYcaW0x06KVlwX5
	 K7xSV0sbBBXhT65j8tnNxdJzteN9MJK+De7OLRrmMtbKrDtO7eslQpjJllsO6bFWHp
	 h0Yw/E5nBrMYg==
Date: Thu, 5 Nov 2026 16:05:13 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev, 
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	will@kernel.org, mark.rutland@arm.com, linux-perf-users@vger.kernel.org, 
	catalin.marinas@arm.com, james.clark@linaro.org
Subject: Re: [RFC PATCH v7 21/28] KVM: arm64: Handle SPE maintenance
 interrupts
Message-ID: <auydDmyrP_3oY6MY@gremlin>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-22-alexandru.elisei@arm.com>
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
In-Reply-To: <20260903160623.315525-22-alexandru.elisei@arm.com>

On Thu, Sep 03, 2026 at 05:06:16PM +0100, Alexandru Elisei wrote:
> Inject the maintenance interrupt when the guest writes 1 to PMBSR_EL1.S,
> and deassert the interrupt when the service bit is cleared.
>
> Re-inject all maintenance interrupts raised by the SPE hardware while
> the guest was running.

I think this should talk about why you need to re-inject + how the physical
interrupt is handled, i.e. the guest experiences an IRQ exit -> host PMBSR_EL1
is restored (S cleared) -> host driver never sees it. So it needs to be
re-injected.

This seems key to the patch.

>
> Save the value of the hardware PMBSR_EL1 register in a separate
> variable, instead of updating the VCPU sysreg directly. That's to allow
> kvm_spe_sync_hwstate() to discern when the service bit was set by the
> hardware, and not by the guest.

>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arch/arm64/include/asm/kvm_spe.h | 13 ++++++++++
>  arch/arm64/kvm/arm.c             |  2 ++
>  arch/arm64/kvm/hyp/vhe/spe-sr.c  |  4 +--
>  arch/arm64/kvm/spe.c             | 43 ++++++++++++++++++++++++++++++++
>  arch/arm64/kvm/sys_regs.c        |  7 +++++-
>  5 files changed, 66 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
> index 8a55ea0de4e5..385b1157e578 100644
> --- a/arch/arm64/include/asm/kvm_spe.h
> +++ b/arch/arm64/include/asm/kvm_spe.h
> @@ -19,8 +19,10 @@ struct kvm_spe {
>  };
>
>  struct kvm_vcpu_spe {
> +	u64 hw_pmbsr_el1;	/* Updated on hardware management event */

Not sure we need this.

In __kvm_spe_save_guest_state_vhe() You assign it like:

	vcpu->arch.vcpu_spe.hw_pmbsr_el1 = read_sysreg_s(SYS_PMBSR_EL1);

And keep it separate, but then later reassign the HW register not from
hw_pmbsr_el1 but directly from the register:

                ctxt_sys_reg(guest_ctxt, PMBPTR_EL1) = read_sysreg_s(SYS_PMBPTR_EL1);

So does it have to be kept aside at all?

__kvm_spe_profiling_buffer_enabled() asserts !PMBSR_EL1.S on guest entry. So it
is set on exit, a buffer management event occurred.

That'd let you simplify things significantly (also including dropping of
irq_level field, discussed below):

--- a/arch/arm64/include/asm/kvm_spe.h
+++ b/arch/arm64/include/asm/kvm_spe.h
@@ struct kvm_vcpu_spe {
-       u64 hw_pmbsr_el1;       /* Updated on hardware management event */
        int irq_num;            /* Buffer management interrupt number */
        bool initialized;       /* SPE initialized for the VCPU */
-       bool irq_level;         /* Virtual buffer management interrupt level */
 };

--- a/arch/arm64/kvm/hyp/vhe/spe-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/spe-sr.c
@@ void __kvm_spe_save_guest_state_vhe(struct kvm_vcpu *vcpu, struct kvm_cpu_context *guest_ctxt)
                /* Advance PMBPTR_EL1 and PMBSR_EL1. */
                isb();

-               vcpu->arch.vcpu_spe.hw_pmbsr_el1 = read_sysreg_s(SYS_PMBSR_EL1);
+               ctxt_sys_reg(guest_ctxt, PMBSR_EL1) = read_sysreg_s(SYS_PMBSR_EL1);
                ctxt_sys_reg(guest_ctxt, PMBPTR_EL1) = read_sysreg_s(SYS_PMBPTR_EL1);

--- a/arch/arm64/kvm/spe.c
+++ b/arch/arm64/kvm/spe.c
@@ static void kvm_spe_update_irq_level(struct kvm_vcpu *vcpu, bool level)
 {
        struct kvm_vcpu_spe *vcpu_spe = &vcpu->arch.vcpu_spe;
-       int ret;
-
-       if (vcpu_spe->irq_level == level)
-               return;

-       ret = kvm_vgic_inject_irq(vcpu->kvm, vcpu, vcpu_spe->irq_num, level, vcpu_spe);
-       if (!WARN_ON_ONCE(ret))
-               vcpu_spe->irq_level = level;
+       WARN_ON_ONCE(kvm_vgic_inject_irq(vcpu->kvm, vcpu, vcpu_spe->irq_num,
+                                        level, vcpu_spe));
 }

 void kvm_spe_sync_hwstate(struct kvm_vcpu *vcpu)
 {
-       struct kvm_vcpu_spe *vcpu_spe = &vcpu->arch.vcpu_spe;
+       u64 pmbsr;

        if (!vcpu_has_spe(vcpu))
                return;

-       if (!FIELD_GET(PMBSR_EL1_S, vcpu_spe->hw_pmbsr_el1))
-               return;
-
-       __vcpu_assign_sys_reg(vcpu, PMBSR_EL1, vcpu_spe->hw_pmbsr_el1);
-       vcpu_spe->hw_pmbsr_el1 = 0;
-       kvm_spe_update_irq_level(vcpu, true);
+       pmbsr = __vcpu_sys_reg(vcpu, PMBSR_EL1);
+       kvm_spe_update_irq_level(vcpu, FIELD_GET(PMBSR_EL1_S, pmbsr));
 }


>  	int irq_num;		/* Buffer management interrupt number */
>  	bool initialized;	/* SPE initialized for the VCPU */
> +	bool irq_level;		/* Virtual buffer management interrupt level */

See comment below, I also think we don't need to add this.

>  };
>
>  bool kvm_supports_spe(void);
> @@ -43,11 +45,15 @@ int kvm_spe_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
>  bool kvm_spe_pmu_set(struct kvm *kvm);
>  u8 kvm_spe_get_pmsver(struct kvm *kvm);
>
> +u64 kvm_spe_reset_sysreg(struct kvm_vcpu *vcpu, int reg);
> +
>  bool kvm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val);
>  u64 kvm_spe_read_sysreg(struct kvm_vcpu *vcpu, int reg);
>
>  bool kvm_spe_has_feat_spe_fne(struct kvm *kvm);
>  bool kvm_spe_has_feat_spe_fds(struct kvm *kvm);
> +
> +void kvm_spe_sync_hwstate(struct kvm_vcpu *vcpu);
>  #else
>  struct kvm_spe {
>  };
> @@ -99,6 +105,10 @@ static inline u8 kvm_spe_get_pmsver(struct kvm *kvm)
>  {
>  	return 0;
>  }
> +static inline u64 kvm_spe_reset_sysreg(struct kvm_vcpu *vcpu, int reg)
> +{
> +	return 0;
> +}
>  static inline bool kvm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val)
>  {
>  	return true;
> @@ -115,6 +125,9 @@ static inline bool kvm_spe_has_feat_spe_fds(struct kvm *kvm)
>  {
>  	return false;
>  }
> +static inline void kvm_spe_sync_hwstate(struct kvm_vcpu *vcpu)
> +{
> +}
>  #endif /* CONFIG_KVM_ARM_SPE */
>
>  #endif /* __ARM64_KVM_SPE_H__ */
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 5992efc4f94b..689fa175f5f4 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1421,6 +1421,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>  		if (kvm_vcpu_has_pmu(vcpu))
>  			kvm_pmu_sync_hwstate(vcpu);
>
> +		kvm_spe_sync_hwstate(vcpu);

In the PMU case above, kvm_vcpu_has_pmu() is checked here, but
kvm_spe_sync_hwstate() does its vcpu_has_spe() in the function. I think, for
consistency, this should check here instead.

> +	if (!))
> +		return;

> +
>  		/*
>  		 * Sync the vgic state before syncing the timer state because
>  		 * the timer code needs to know if the virtual timer
> diff --git a/arch/arm64/kvm/hyp/vhe/spe-sr.c b/arch/arm64/kvm/hyp/vhe/spe-sr.c
> index 3c32a1338cc8..df35025db19a 100644
> --- a/arch/arm64/kvm/hyp/vhe/spe-sr.c
> +++ b/arch/arm64/kvm/hyp/vhe/spe-sr.c
> @@ -154,10 +154,10 @@ void __kvm_spe_save_guest_state_vhe(struct kvm_vcpu *vcpu, struct kvm_cpu_contex
>  		psb_csync();
>  		dsb(nsh);
>  		write_sysreg_s(0, SYS_PMBLIMITR_EL1);
> -		/* Advance PMBPTR_EL1. */
> +		/* Advance PMBPTR_EL1 and PMBSR_EL1. */
>  		isb();
>
> -		/* Hardware updates to PMBSR_EL1 are not handled, yet. */
> +		vcpu->arch.vcpu_spe.hw_pmbsr_el1 = read_sysreg_s(SYS_PMBSR_EL1);

On this one, agree with your response to sashiko re: PMBSR_EL1 write order
__kvm_spe_restore_guest_state_vhe(), nothing to fix here.

>  		ctxt_sys_reg(guest_ctxt, PMBPTR_EL1) = read_sysreg_s(SYS_PMBPTR_EL1);
>  	}
>
> diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
> index 68b751bdb384..89ebeef1c223 100644
> --- a/arch/arm64/kvm/spe.c
> +++ b/arch/arm64/kvm/spe.c
> @@ -21,6 +21,8 @@ struct spe_pmu_entry {
>  	struct arm_spe_pmu *spe_pmu;
>  };
>
> +static void kvm_spe_update_irq_level(struct kvm_vcpu *vcpu, bool level);
> +
>  void kvm_spe_add_instance(struct arm_spe_pmu *spe_pmu)
>  {
>  	struct spe_pmu_entry *entry;
> @@ -152,6 +154,14 @@ bool kvm_spe_has_feat_spe_fne(struct kvm *kvm)
>  	       FIELD_GET(PMSIDR_EL1_FnE, spe_pmu->pmsidr_el1);
>  }
>
> +u64 kvm_spe_reset_sysreg(struct kvm_vcpu *vcpu, int reg)
> +{
> +	if (reg == PMBSR_EL1 && kvm_vcpu_spe_initialized(vcpu))
> +		kvm_spe_update_irq_level(vcpu, false);
> +
> +	return 0;
> +}

(I know you are going to fix on respin, just to note :) as per sashiko - other
reset callbacks assign, so registers keep their old values across a reset.

> +
>  bool kvm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val)
>  {
>  	struct kvm_spe *kvm_spe = &vcpu->kvm->arch.kvm_spe;
> @@ -168,6 +178,11 @@ bool kvm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val)
>  		WARN_ON_ONCE("unexpected trap");
>  	}
>
> +	if (reg == PMBSR_EL1) {
> +		val = __vcpu_sys_reg(vcpu, PMBSR_EL1);

Why are you re-reading this? As you simply assign in the switch above via
__vcpu_assign_sys_reg() so it should be the same value?

> +		kvm_spe_update_irq_level(vcpu, FIELD_GET(PMBSR_EL1_S, val));
> +	}
> +

Assuming the -EBUSY check is removed from set_user_spe_sysreg() (as discussed in
review of patch 17), userspace can get here with a KVM_SET_ONE_REG.

This allows a WARN_ON_ONCE() to be trivially triggered from userspace in the
switch statement above:

	switch (reg) {
	...
	default:
		WARN_ON_ONCE("unexpected trap");
	}

But now also trigger kvm_spe_update_irq_level() arbitrarily before the vGIC is
initialised.

I think we should leave the IRQ bit to first-run and let this just be a raw
register write.

Maybe something like the below?

  --- a/arch/arm64/kvm/spe.c
  +++ b/arch/arm64/kvm/spe.c
  @@ bool kvm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val)
          default:
                  WARN_ON_ONCE("unexpected trap");
          }

  -       if (reg == PMBSR_EL1) {
  -               val = __vcpu_sys_reg(vcpu, PMBSR_EL1);
  -               kvm_spe_update_irq_level(vcpu, FIELD_GET(PMBSR_EL1_S, val));
  -       }
  -
          return true;
   }

  +/* Guest-trap only: the vGIC is necessarily initialised at this point. */
  +bool kvm_spe_handle_sysreg_write(struct kvm_vcpu *vcpu, int reg, u64 val)
  +{
  +       kvm_spe_write_sysreg(vcpu, reg, val);
  +
  +       if (reg == PMBSR_EL1)
  +               kvm_spe_update_irq_level(vcpu, FIELD_GET(PMBSR_EL1_S, val));
  +
  +       return true;
  +}
  +
  @@ int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu)
          if (!kvm_spe->pmblimitr_el1_res0_mask)
                  kvm_spe_compute_pmblimitr_el1_res0_mask(kvm);

  +       /* Pick up anything userspace wrote via KVM_SET_ONE_REG. */
  +       kvm_spe_update_irq_level(vcpu,
  +               FIELD_GET(PMBSR_EL1_S, __vcpu_sys_reg(vcpu, PMBSR_EL1)));
  +
          if (kvm_vm_has_ran_once(kvm))
                  return 0;
  --- a/arch/arm64/kvm/sys_regs.c
  +++ b/arch/arm64/kvm/sys_regs.c
  @@ static bool access_spe_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
          if (p->is_write)
  -               return kvm_spe_write_sysreg(vcpu, reg, val);
  +               return kvm_spe_handle_sysreg_write(vcpu, reg, val);

>  	return true;
>  }
>
> @@ -184,6 +199,34 @@ u64 kvm_spe_read_sysreg(struct kvm_vcpu *vcpu, int reg)
>  	}
>  }
>
> +static void kvm_spe_update_irq_level(struct kvm_vcpu *vcpu, bool level)
> +{
> +	struct kvm_vcpu_spe *vcpu_spe = &vcpu->arch.vcpu_spe;
> +	int ret;
> +
> +	if (vcpu_spe->irq_level == level)
> +		return;

This seems redundant, as vgic_validate_injection() called by
kvm_vgic_inject_irq() checks for this already:

static bool vgic_validate_injection(struct vgic_irq *irq, bool level, void *owner)
{
	...
	switch (irq->config) {
	case VGIC_CONFIG_LEVEL:
		return irq->line_level != level;
	...
	}
	...
}


> +
> +	ret = kvm_vgic_inject_irq(vcpu->kvm, vcpu, vcpu_spe->irq_num, level, vcpu_spe);
> +	if (!WARN_ON_ONCE(ret))
> +		vcpu_spe->irq_level = level;
> +}
> +
> +void kvm_spe_sync_hwstate(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_vcpu_spe *vcpu_spe = &vcpu->arch.vcpu_spe;
> +
> +	if (!vcpu_has_spe(vcpu))
> +		return;

As above, should put this outside the function. It's also weird to see this
check here (you'd hope that you'd know it was SPE if calling this function :)

> +
> +	if (!FIELD_GET(PMBSR_EL1_S, vcpu_spe->hw_pmbsr_el1))
> +		return;
> +
> +	__vcpu_assign_sys_reg(vcpu, PMBSR_EL1, vcpu_spe->hw_pmbsr_el1);
> +	vcpu_spe->hw_pmbsr_el1 = 0;
> +	kvm_spe_update_irq_level(vcpu, true);
> +}
> +
>  bool kvm_spe_pmu_set(struct kvm *kvm)
>  {
>  	return !!kvm->arch.kvm_spe.spe_pmu;
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 4c4bf88c9aa5..ebe1c933f8d5 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1595,6 +1595,11 @@ static int get_user_spe_sysreg(struct kvm_vcpu *vcpu, const struct sys_reg_desc
>  	return 0;
>  }
>
> +static u64 reset_spe_sysreg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> +{
> +	return kvm_spe_reset_sysreg(vcpu, r->reg);
> +}
> +
>  static bool access_spe_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  			   const struct sys_reg_desc *r)
>  {
> @@ -1642,7 +1647,7 @@ static bool access_spe_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>
>  #define SPE_SYS_REG(name)						\
>  	SYS_DESC(SYS_##name), .reg = name, .access = access_spe_reg,	\
> -	.reset = reset_val, .val = 0, .visibility = spe_visibility,	\
> +	.reset = reset_spe_sysreg, .visibility = spe_visibility,	\
>  	.set_user = set_user_spe_sysreg, .get_user = get_user_spe_sysreg
>
>  #define SPE_UNTRAPPED_REG(name)						\
> --
> 2.43.0
>
>

--
Cheers, Lorenzo
