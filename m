Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29356364EB6;
	Mon, 28 Sep 2026 14:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790606217; cv=none; b=Lk6ni2xRpImHS5BKUNRhaqLOb0EJsY8921rSWcQf2pVOMvkNzdotZgIrrLPhSikkbud+KUtyEvsE3btPgijEpY9VVtXZAVtWt3YGTGSihUpxBBG0YGFYe/wYLzWqKbApXgYXJ10tDPk1FSTZA3hCh537d3x6RaX489qkooB88tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790606217; c=relaxed/simple;
	bh=56J6u6SBLSc78Y5Pd6wxwnPy9vYYhfL7uKPZi//SS8g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tpLCDsPQXFo9ylckTbUigrPrCBStoZ7EFY36dbyHQJWj3GOTsOVmaRN5NWMId5wFXjLoMUtpLuZFQDxO87ASVbuQVODOCHT/XPvMMV/trXCx8GAWqxlydYPH0dG6GLs67hJTm2IscYaj/XhDIVInDVThAFQErPYV6f8I+wHletA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JE/yzGbu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JE/yzGbu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EE6A1F000FF;
	Mon, 28 Sep 2026 14:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790606210;
	bh=/5itlcJu9srLLzT4QHX7WOkX7hh4MpPTH6x/emVYksg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JE/yzGbuzqBngwQWRR7pX+rNXVbom7QiV7DYqnEYiAhZWrEIfO1c1B65ffbcXnGST
	 P4dQwgShY1Hhs5lfk7W8uKgzu5LTzla3YhEE296sRP3ZG6T2ngzXzxDanRA/zrbpg5
	 e9yIsFanS4M7JFHjAf7slcL3aV+aI2XxSooQ33IzpsS6eXEeA3f8SnHh0V7t1BJU+q
	 78/5BZfGBTUjvK4Pmk0oKeeLiDql2UYgX5f98mffzlq0HcGF9F11/OUbZmhN0Vnr3m
	 zxic0mpOekQ3/1e65WOTbuvkpk0R6yEI7Ih/Sp7duEmJnoBzAnj+iToRlQQ/HGFOQz
	 OUPp3JXR3SjwA==
Date: Mon, 28 Sep 2026 15:36:36 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>, 
	Peter Maydell <peter.maydell@linaro.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] KVM: arm64: Block ID register changes after we
 rely on the values
Message-ID: <arpsY1oqmhvxRVpj@gremlin>
References: <20260901-kvm-arm64-idreg-final-v3-0-a0ffa06fa872@kernel.org>
 <20260901-kvm-arm64-idreg-final-v3-2-a0ffa06fa872@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901-kvm-arm64-idreg-final-v3-2-a0ffa06fa872@kernel.org>

On Tue, Sep 01, 2026 at 07:18:49PM +0100, Mark Brown wrote:
> In commit c5bac1ef7df6b ("KVM: arm64: Move existing feature disabling
> over to FGU infrastructure") a check was added to suppress duplicate
> recalculation of FGUs based on a flag KVM_ARCH_FLAG_FGU_INITIALIZED. This

Just for my understanding:

FGU = Fine-Grained UNDEF -> if feature not present really act as if it's not
present, don't just not advertise it.

And that's about ensuring RES0, RES1 handled correctly?

Also (just noting for myself here) - it's a bit in the arch.flags bitmask:

kvm_calculate_traps() ->

	if (test_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags))
		goto out;

	...

	set_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags);

> flag is set when we complete kvm_calculate_traps(), which is called from
> kvm_arch_vcpu_run_pid_change(). There are several points where that
> function could fail after we have calculated FGUs (eg, due to an invalid
> timer configuration). If this happens then userspace will still be able
> to write to the ID registers, writes to which are gated on
> KVM_ARCH_FLAG_HAS_RAN_ONCE being set. This in turn means that the FGU

OK so the issue is that the writes to registers are permitted while
KVM_ARCH_FLAG_HAS_RAN_ONCE is cleared, but there's a dependency:

	reg config -> what features enabled -> what FGU sets RES0/1 for

So you can finalise FGU state on incorrect information.

And RES0/RES1 matters meaningfully for NV because VNCR backs registers
with... memory :) Whereas the actual sysregs will just do what they do.

> configuration for a running guest may not match the ID register
> configuration.

Ack yeah.

>
> This will result in issues based on the hypervisor assuming a consistent
> configuration, for example it allows the creation of guests which have
> untrapped access to system registers which are not context switched for
> the guest.
>
> A similar issue exists in kvm_init_nv_sysregs() where once sysreg_masks
> is allocated the RES0/RES1 masks for registers are fixed based on the ID
> register values at the time the function ran, and also for copying the
> implementation ID registers to the hypervisor for pKVM.
>
> There is a further issue with vGIC setup, creating a vGIC includes
> updating the ID registers to reflect the GIC configuration. We refuse
> to create a vGIC after the first vCPU has run but if a vCPU fails its
> first run we may already have finalized the ID register values.

It seems like all are similar to 1/3 in that there are dependencies that
are not correctly expressed atm.

>
> Avoid these issues by adding a new flag that we set when we finalize the
> system registers, blocking ID register changes after that has been set
> even if something fails later on. Do this in kvm_vm_finalize_sys_regs(),
> this is where we finalize the GIC fields in the ID registers and happens
> before we do the FGU and RES0/1 setup. A VMM which tries to create an

OK so resolve things by tracking when the regs _should_ actually be set up
by, rather than just gating on KVM_ARCH_FLAG_HAS_RAN_ONCE once.

> irqchip after failing to run a vCPU will now get -EBUSY rather than a
> likely misconfigured guest. Userspace is not expected to try to run a
> guest that fails to start, never mind try to repair the guest
> configuration after doing so, so this is not expected to have any impact
> on practical users.

Sounds reasonable.

>
> There is a preexisting flag KVM_ARCH_FLAG_ID_REGS_INITIALIZED, this was
> added as part of the series that originally enabled writable ID
> registers[1].  That is set when the vCPU feature flags are finalized in
> KVM_ARM_VCPU_INIT when we initiailise the ID registers, we need to be
> able to write to the ID registers after that point since the features
> can influence ID registers (eg, ID_AA64ZFR0_EL1).  Given this and the
> fact that the flag was introduced as part of making the ID registers
> writable it appears to be a deliberate and desired ABI design decision
> to not use this flag to block writes to the ID registers.  Introducing
> the new flag preserves the existing behaviour.

Also sounds reasonable.

>
> [1] https://lore.kernel.org/r/20230609190054.1542113-7-oliver.upton@linux.dev
>
> Fixes: c5bac1ef7df6b ("KVM: arm64: Move existing feature disabling over to FGU infrastructure")
> Fixes: 888f088070229 ("KVM: arm64: nv: Add sanitising to VNCR-backed sysregs")
> Fixes: 03e1b89d051f ("KVM: arm64: Copy MIDR_EL1 into hyp VM when it is writable")
> Fixes: 8a9866ff8600 ("KVM: arm64: Set ID_{AA64PFR0,PFR1}_EL1.GIC when GICv3 is configured")
> Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
> Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
> Signed-off-by: Mark Brown <broonie@kernel.org>

All LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  arch/arm64/include/asm/kvm_host.h |  8 ++++++++
>  arch/arm64/kvm/sys_regs.c         | 17 ++++++++++-------
>  arch/arm64/kvm/vgic/vgic-init.c   |  6 ++----
>  3 files changed, 20 insertions(+), 11 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 27fe0cd5b2d7..777c46b34bb5 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -367,6 +367,8 @@ struct kvm_arch {
>  #define KVM_ARCH_FLAG_WRITABLE_IMP_ID_REGS		10
>  	/* Unhandled SEAs are taken to userspace */
>  #define KVM_ARCH_FLAG_EXIT_SEA				11
> +	/* No further ID register changes possible */
> +#define KVM_ARCH_FLAG_ID_REGS_FINAL			12
>  	unsigned long flags;
>
>  	/* VM-wide vCPU feature set */
> @@ -1149,6 +1151,12 @@ struct kvm_vcpu_arch {
>  #define vcpu_has_ptrauth(vcpu)		false
>  #endif
>
> +#define kvm_id_regs_final(kvm)						\
> +	test_bit(KVM_ARCH_FLAG_ID_REGS_FINAL, &(kvm)->arch.flags)
> +
> +#define vcpu_id_regs_final(vcpu)					\
> +	kvm_id_regs_final((vcpu)->kvm)
> +
>  #define vcpu_on_unsupported_cpu(vcpu)					\
>  	vcpu_get_flag(vcpu, ON_UNSUPPORTED_CPU)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 880f84248427..df0c3831094d 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2511,9 +2511,10 @@ static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>
>  	/*
>  	 * Once the VM has started the ID registers are immutable. Reject any
> -	 * write that does not match the final register value.
> +	 * write that does not match the final register value once we have
> +	 * got far enough into first running the VM to use the values.
>  	 */
> -	if (kvm_vm_has_ran_once(vcpu->kvm)) {
> +	if (vcpu_id_regs_final(vcpu)) {
>  		if (val != read_id_reg(vcpu, rd))
>  			ret = -EBUSY;
>  		else
> @@ -2547,7 +2548,7 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val)
>
>  	lockdep_assert_held(&kvm->arch.config_lock);
>
> -	if (KVM_BUG_ON(kvm_vm_has_ran_once(kvm) || !p, kvm))
> +	if (KVM_BUG_ON(kvm_id_regs_final(kvm) || !p, kvm))
>  		return;
>
>  	*p = val;
> @@ -3243,10 +3244,10 @@ static int set_imp_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
>  		return -EINVAL;
>
>  	/*
> -	 * Once the VM has started the ID registers are immutable. Reject the
> -	 * write if userspace tries to change it.
> +	 * Once we have been far enough into starting the VM the ID registers
> +	 * are immutable. Reject the write if userspace tries to change it.
>  	 */
> -	if (kvm_vm_has_ran_once(kvm))
> +	if (kvm_id_regs_final(kvm))
>  		return -EBUSY;
>
>  	/*
> @@ -5869,7 +5870,7 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
>   */
>  static int kvm_vm_finalize_sys_regs(struct kvm *kvm)
>  {
> -	if (kvm_vm_has_ran_once(kvm))
> +	if (kvm_id_regs_final(kvm))
>  		return 0;
>
>  	/*
> @@ -5917,6 +5918,8 @@ static int kvm_vm_finalize_sys_regs(struct kvm *kvm)
>  		kvm_vgic_finalize_idregs(kvm);
>  	}
>
> +	set_bit(KVM_ARCH_FLAG_ID_REGS_FINAL, &kvm->arch.flags);
> +
>  	return 0;
>  }
>
> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> index 4012df6002ea..247c211bd68b 100644
> --- a/arch/arm64/kvm/vgic/vgic-init.c
> +++ b/arch/arm64/kvm/vgic/vgic-init.c
> @@ -123,10 +123,8 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
>  		goto out_unlock;
>  	}
>
> -	kvm_for_each_vcpu(i, vcpu, kvm) {
> -		if (vcpu_has_run_once(vcpu))
> -			goto out_unlock;
> -	}
> +	if (kvm_id_regs_final(kvm))
> +		goto out_unlock;

This is a nice improvement! :)

>  	ret = 0;
>
>  	if (type == KVM_DEV_TYPE_ARM_VGIC_V2)
>
> --
> 2.47.3
>
>

--
Cheers, Lorenzo
