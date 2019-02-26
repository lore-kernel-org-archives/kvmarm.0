From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH v5 13/26] KVM: arm64/sve: System register context switch
 and access support
Date: Tue, 26 Feb 2019 16:32:30 +0000
Message-ID: <8a0e6089-b77b-151b-eacd-34ad13f39ac6@arm.com>
References: <1550519559-15915-1-git-send-email-Dave.Martin@arm.com>
 <1550519559-15915-14-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 085684A36B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Feb 2019 11:32:36 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tPFyy71d1Kf7 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Feb 2019 11:32:34 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DAAB4A2F8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Feb 2019 11:32:34 -0500 (EST)
In-Reply-To: <1550519559-15915-14-git-send-email-Dave.Martin@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Dave,

On 18/02/2019 19:52, Dave Martin wrote:
> @@ -1091,6 +1088,95 @@ static int reg_from_user(u64 *val, const void __user *uaddr, u64 id);
>   static int reg_to_user(void __user *uaddr, const u64 *val, u64 id);
>   static u64 sys_reg_to_index(const struct sys_reg_desc *reg);
>   
> +static unsigned int sve_restrictions(const struct kvm_vcpu *vcpu,
> +				     const struct sys_reg_desc *rd)
> +{
> +	return vcpu_has_sve(vcpu) ? 0 : REG_NO_USER | REG_NO_GUEST;
> +}
> +
> +static unsigned int sve_id_restrictions(const struct kvm_vcpu *vcpu,
> +					const struct sys_reg_desc *rd)
> +{
> +	return vcpu_has_sve(vcpu) ? 0 : REG_NO_USER;
> +}
> +
> +static int get_zcr_el1(struct kvm_vcpu *vcpu,
> +		       const struct sys_reg_desc *rd,
> +		       const struct kvm_one_reg *reg, void __user *uaddr)
> +{
> +	if (WARN_ON(!vcpu_has_sve(vcpu)))
> +		return -ENOENT;
> +
> +	return reg_to_user(uaddr, &vcpu->arch.ctxt.sys_regs[ZCR_EL1],
> +			   reg->id);
> +}
> +
> +static int set_zcr_el1(struct kvm_vcpu *vcpu,
> +		       const struct sys_reg_desc *rd,
> +		       const struct kvm_one_reg *reg, void __user *uaddr)
> +{
> +	if (WARN_ON(!vcpu_has_sve(vcpu)))
> +		return -ENOENT;
> +
> +	return reg_from_user(&vcpu->arch.ctxt.sys_regs[ZCR_EL1], uaddr,
> +			     reg->id);
> +}
> +
> +/* Generate the emulated ID_AA64ZFR0_EL1 value exposed to the guest */
> +static u64 guest_id_aa64zfr0_el1(const struct kvm_vcpu *vcpu)
> +{
> +	if (!vcpu_has_sve(vcpu))
> +		return 0;
> +
> +	return read_sanitised_ftr_reg(SYS_ID_AA64ZFR0_EL1);
> +}
> +
> +static bool access_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
> +				   struct sys_reg_params *p,
> +				   const struct sys_reg_desc *rd)
> +{
> +	if (p->is_write)
> +		return write_to_read_only(vcpu, p, rd);
> +
> +	p->regval = guest_id_aa64zfr0_el1(vcpu);
> +	return true;
> +}
> +
> +static int get_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
> +		const struct sys_reg_desc *rd,
> +		const struct kvm_one_reg *reg, void __user *uaddr)
> +{
> +	u64 val;
> +
> +	if (!vcpu_has_sve(vcpu))
> +		return -ENOENT;
> +
> +	val = guest_id_aa64zfr0_el1(vcpu);
> +	return reg_to_user(uaddr, &val, reg->id);
> +}
> +
> +static int set_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
> +		const struct sys_reg_desc *rd,
> +		const struct kvm_one_reg *reg, void __user *uaddr)
> +{
> +	const u64 id = sys_reg_to_index(rd);
> +	int err;
> +	u64 val;
> +
> +	if (!vcpu_has_sve(vcpu))
> +		return -ENOENT;
> +
> +	err = reg_from_user(&val, uaddr, id);
> +	if (err)
> +		return err;
> +
> +	/* This is what we mean by invariant: you can't change it. */
> +	if (val != guest_id_aa64zfr0_el1(vcpu))
> +		return -EINVAL;
> +
> +	return 0;
> +}

We seem to already have code for handling invariant registers as well as reading 
ID register. I guess the only reason you can't use them is because of the check 
the vcpu is using SVE.

However, AFAICT the restrictions callback would prevent you to enter the {get, 
set}_id if the vCPU does not support SVE. So the check should not be reachable.

Did I miss anything?

Cheers,

-- 
Julien Grall
