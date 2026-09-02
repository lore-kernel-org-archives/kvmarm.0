Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 908AA4A3F26
	for <kvmarm@lists.linux.dev>; Wed,  2 Sep 2026 15:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788362064; cv=none; b=ugOCH5nTf3Ya69YOi8cDmA/kSUBUlWxbDooXFhYsJbo9aUOcraDjqMv+aQUlgzHWqH3msHbLCfoedO2KKunYiaBHiUVtmoGFO6KPRIfVgWBSooEBqKBanwGGMipcTALN8tUUj3Lyqv774ZkkxtWzvqHrngxAD2fN6WYDBrY4Na4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788362064; c=relaxed/simple;
	bh=y4B/SQDOmNkxR1qfLIKrprB9f36rbOHaf5xuFFxp5qQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U14DScROBLFsAVx+t5yUTRR1GK5gl5y2MCciUdlty4pP52qEGvXzYQx2BkxHwzm/uh6wMHbwySQup41khVzuxowU4Z4G4navFkQuV+t8Yxr+YrmDIK6fdUia9/sNxCe3AjBMSUNuA73BjW+Af2F1iH9gcKau/1oyn9A72z8/lcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Y0GSWUWM; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Y0GSWUWM"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 399E0165C;
	Wed,  2 Sep 2026 08:14:16 -0700 (PDT)
Received: from e143914.arm.com (e143914.arm.com [10.2.213.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 303293F673;
	Wed,  2 Sep 2026 08:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788362059; bh=y4B/SQDOmNkxR1qfLIKrprB9f36rbOHaf5xuFFxp5qQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y0GSWUWMMO3XuEb5pAZL0op63Efncbv5GKYstMiCAJYtFElHUoiyuOsqqcMQdp2dS
	 OA8ctS+O3SBFUCgHBDGe/ISLIDiaVm03khPOPcNkoRKXcqo62DU7V5HaODgnAg+4TA
	 DmT5XSsfNa9ltqbzU8PROzgYiq9XP+uogAicbJ+M=
Date: Wed, 2 Sep 2026 16:14:15 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH 07/17] KVM: arm64: Add system register reset framework
 for protected VMs
Message-ID: <apg9R_QsE1cckIgJ@e143914.arm.com>
References: <20260831163421.272420-1-fuad.tabba@linux.dev>
 <20260831163421.272420-8-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831163421.272420-8-fuad.tabba@linux.dev>

On Mon, Aug 31, 2026 at 05:34:11PM +0100, Fuad Tabba wrote:
> Reset a protected VM's system registers at EL2 rather than taking the
> host's values: add kvm_reset_pvm_sys_regs() and the
> pvm_sys_reg_reset_vals[] table that drives it, and call it from
> init_pkvm_hyp_vcpu() for protected vCPUs. The values follow the
> host-side reset in sys_regs.c, with a poison value where it resets to
> UNKNOWN, and for VBAR_EL1 and CONTEXTIDR_EL1 in place of the 0 it
> resets them to. MPIDR_EL1 is derived from vcpu_id, as for any KVM
> guest.
> 
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>

The commit message says "rather than taking the host's values", but if I
understand correctly, at this point in the series, they still take the
hosts values because this is still present:

	hyp_vcpu->vcpu.arch.ctxt = host_vcpu->arch.ctxt;

Not necessarily saying anything needs to change, just to write down what
I noticed while reviewing / reading this code!

The only other thing I was a bit unsure of was the actual list of
registers pvm_sys_reg_reset_vals. It's the EL1 registers, minus
unsupported FEATs (MTE, debug(?), GCS, etc)

Otherwise:
Acked-by: Joey Gouly <joey.gouly@arm.com>

Thanks,
Joey

> ---
>  arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  1 +
>  arch/arm64/kvm/hyp/nvhe/pkvm.c         |  5 ++
>  arch/arm64/kvm/hyp/nvhe/sys_regs.c     | 91 ++++++++++++++++++++++++--
>  3 files changed, 93 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> index 49a0a992047ba..a04b7c04d5135 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> @@ -95,6 +95,7 @@ bool kvm_handle_pvm_hvc64(struct kvm_vcpu *vcpu, u64 *exit_code);
>  bool kvm_handle_pvm_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code);
>  bool kvm_handle_pvm_restricted(struct kvm_vcpu *vcpu, u64 *exit_code);
>  void kvm_init_pvm_id_regs(struct kvm_vcpu *vcpu);
> +void kvm_reset_pvm_sys_regs(struct kvm_vcpu *vcpu);
>  int kvm_check_pvm_sysreg_table(void);
>  
>  #endif /* __ARM64_KVM_NVHE_PKVM_H__ */
> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> index e85f13233da08..af334318d0a03 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> @@ -551,6 +551,11 @@ static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
>  		goto done;
>  
>  	ret = pkvm_vcpu_init_sve(hyp_vcpu, host_vcpu);
> +	if (ret)
> +		goto done;
> +
> +	if (pkvm_hyp_vcpu_is_protected(hyp_vcpu))
> +		kvm_reset_pvm_sys_regs(&hyp_vcpu->vcpu);
>  done:
>  	if (ret)
>  		unpin_host_vcpu(host_vcpu);
> diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> index 8758c68017765..ebfd48aa15b56 100644
> --- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> +++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> @@ -525,6 +525,84 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
>  	/* Performance Monitoring Registers are restricted. */
>  };
>  
> +struct sys_reg_desc_reset {
> +	int reg;
> +	void (*reset)(struct kvm_vcpu *vcpu, const struct sys_reg_desc_reset *rd);
> +	u64 value;
> +};
> +
> +/* Hardware value, as sys_regs.c's reset_actlr()/reset_amair_el1(). */
> +static void reset_actlr(struct kvm_vcpu *vcpu, const struct sys_reg_desc_reset *r)
> +{
> +	__vcpu_assign_sys_reg(vcpu, r->reg, read_sysreg(actlr_el1));
> +}
> +
> +static void reset_amair_el1(struct kvm_vcpu *vcpu, const struct sys_reg_desc_reset *r)
> +{
> +	__vcpu_assign_sys_reg(vcpu, r->reg, read_sysreg(amair_el1));
> +}
> +
> +static void reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc_reset *r)
> +{
> +	__vcpu_assign_sys_reg(vcpu, r->reg, kvm_calculate_mpidr(vcpu));
> +}
> +
> +static void reset_value(struct kvm_vcpu *vcpu, const struct sys_reg_desc_reset *r)
> +{
> +	__vcpu_assign_sys_reg(vcpu, r->reg, r->value);
> +}
> +
> +#define RESET_VAL(REG, RESET_VAL) {  REG, reset_value, RESET_VAL }
> +
> +#define RESET_ZERO(REG) RESET_VAL(REG, 0)
> +
> +#define RESET_UNKNOWN(REG) RESET_VAL(REG, 0x1de7ec7edbadc0deULL)
> +
> +#define RESET_FUNC(REG, RESET_FUNC) {  REG, RESET_FUNC, 0 }
> +
> +/* Sorted ascending by reg; kvm_check_pvm_sysreg_table() enforces it. */
> +static const struct sys_reg_desc_reset pvm_sys_reg_reset_vals[] = {
> +	RESET_FUNC(MPIDR_EL1, reset_mpidr),
> +	RESET_UNKNOWN(TPIDR_EL0),
> +	RESET_UNKNOWN(TPIDRRO_EL0),
> +	RESET_UNKNOWN(TPIDR_EL1),
> +	RESET_ZERO(CNTKCTL_EL1),
> +	RESET_UNKNOWN(PAR_EL1),
> +	RESET_ZERO(MDCCINT_EL1),
> +	RESET_ZERO(DISR_EL1),
> +	RESET_ZERO(PMCCFILTR_EL0),
> +	RESET_ZERO(PMUSERENR_EL0),
> +	RESET_ZERO(CPACR_EL1),
> +	RESET_VAL(CONTEXTIDR_EL1, 0x00000000dbadc0deULL),
> +	RESET_VAL(SCTLR_EL1, 0x00C50078ULL),
> +	RESET_FUNC(ACTLR_EL1, reset_actlr),
> +	RESET_ZERO(TCR_EL1),
> +	RESET_UNKNOWN(AFSR0_EL1),
> +	RESET_UNKNOWN(AFSR1_EL1),
> +	RESET_UNKNOWN(ESR_EL1),
> +	RESET_UNKNOWN(MAIR_EL1),
> +	RESET_FUNC(AMAIR_EL1, reset_amair_el1),
> +	RESET_ZERO(MDSCR_EL1),
> +	RESET_ZERO(ZCR_EL1),
> +	RESET_UNKNOWN(TTBR0_EL1),
> +	RESET_UNKNOWN(TTBR1_EL1),
> +	RESET_UNKNOWN(FAR_EL1),
> +	RESET_VAL(VBAR_EL1, 0x1de7ec7edbadc000ULL),
> +	RESET_UNKNOWN(PIRE0_EL1),
> +	RESET_UNKNOWN(PIR_EL1),
> +};
> +
> +void kvm_reset_pvm_sys_regs(struct kvm_vcpu *vcpu)
> +{
> +	unsigned long i;
> +
> +	for (i = 0; i < ARRAY_SIZE(pvm_sys_reg_reset_vals); i++) {
> +		const struct sys_reg_desc_reset *r = &pvm_sys_reg_reset_vals[i];
> +
> +		r->reset(vcpu, r);
> +	}
> +}
> +
>  /*
>   * Initializes feature registers for protected vms.
>   */
> @@ -550,16 +628,21 @@ void kvm_init_pvm_id_regs(struct kvm_vcpu *vcpu)
>  }
>  
>  /*
> - * Checks that the sysreg table is unique and in-order.
> - *
> - * Returns 0 if the table is consistent, or 1 otherwise.
> + * Both tables must be unique and sorted ascending. pvm_sys_reg_descs.reg is the
> + * sys_reg() encoding, pvm_sys_reg_reset_vals.reg the vcpu_sysreg index, so they
> + * compare differently. BUG_ON() at __pkvm_init: fatal at boot.
>   */
>  int kvm_check_pvm_sysreg_table(void)
>  {
>  	unsigned int i;
>  
>  	for (i = 1; i < ARRAY_SIZE(pvm_sys_reg_descs); i++) {
> -		if (cmp_sys_reg(&pvm_sys_reg_descs[i-1], &pvm_sys_reg_descs[i]) >= 0)
> +		if (cmp_sys_reg(&pvm_sys_reg_descs[i - 1], &pvm_sys_reg_descs[i]) >= 0)
> +			return 1;
> +	}
> +
> +	for (i = 1; i < ARRAY_SIZE(pvm_sys_reg_reset_vals); i++) {
> +		if (pvm_sys_reg_reset_vals[i - 1].reg >= pvm_sys_reg_reset_vals[i].reg)
>  			return 1;
>  	}
>  
> -- 
> 2.39.5
> 
