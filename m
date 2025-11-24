Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A9EB2F90DC
	for <kvmarm@lists.linux.dev>; Mon, 24 Nov 2025 10:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763980922; cv=none; b=q8uCZZt6sqLQ0aAtOo08xJXVeXDpKz4Y8eWmA2FBfVOUUc67iI9txZpuYXj+r8BEsduJ/3n9xe6aNdxIgYnqaOfoysloohpkLMyj2kC03hlYTO0EwLSjbFUThDCjRwvbfjatmJwE5G6m9pkMGD8JNZycZu12qTKbXYsJXMMzoZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763980922; c=relaxed/simple;
	bh=QTAyOk3PHcd/woJOR7zn+/qpCoKijJfRmeOljShnA3s=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=BxH5K1/pRL2Amw7RRWGSnQunNCt90or+MLI8VHvHRPn4VBJGBhQ+V0io2bOB483QI9YVNPVCmqyGgISRT9llzfPkKvKKSx8OqgWuC3Wj+QQ0Z8PqUIDpnVgSYEruTAOQ725smuNTfZ3hipOfZTyOrVeY7V6R/my04KJ6PNnddtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 612D21477;
	Mon, 24 Nov 2025 02:41:51 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BA8CB3F6A8;
	Mon, 24 Nov 2025 02:41:57 -0800 (PST)
Message-ID: <576d088c-0176-41e5-a66c-8713f5cb09b7@arm.com>
Date: Mon, 24 Nov 2025 10:41:56 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Ben Horgan <ben.horgan@arm.com>
Subject: Re: [PATCH 4/5] KVM: arm64: Report optional ID register traps with a
 0x18 syndrome
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>,
 Zenghui Yu <yuzenghui@huawei.com>
References: <20251120133202.2037803-1-maz@kernel.org>
 <20251120133202.2037803-5-maz@kernel.org>
Content-Language: en-US
In-Reply-To: <20251120133202.2037803-5-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Marc,

On 11/20/25 13:32, Marc Zyngier wrote:
> With FEAT_IDST, unimplemented system registers must be reported using
> EC=0x18 at the closest handling EL, rather than with an UNDEF.

I think this needs 'in the feature ID space' adding. Something like:

With FEAT_IDST, unimplemented system registers in the feature ID space
must be reported using EC=0x18 at the closest handling EL, rather than
with an UNDEF.

> 
> Most system registers are always implemented thanks to their dependency

'Most of these system registers...'

> on FEAT_AA64, except for a set of (currently) three registers:
> GMID_EL1 (depending on MTE2), CCSIDR2_EL1 (depending on FEAT_CCIDX),
> and SMIDR_EL1 (depending on SME).
I agree that these 3 are currently the only optional system registers in
the feature ID space.

> 
> For these three registers, report their trap as EC=0x18 if they
> end-up trapping into KVM and that FEAT_IDST is not implemented in the
> guest. Otherwise, just make them UNDEF.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 40f32b017f107..992137822dcf9 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -82,6 +82,16 @@ static bool write_to_read_only(struct kvm_vcpu *vcpu,
>  			"sys_reg write to read-only register");
>  }
>  
> +static bool idst_access(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> +			const struct sys_reg_desc *r)
> +{
> +	if (kvm_has_feat_enum(vcpu->kvm, ID_AA64MMFR2_EL1, IDS, 0x0))
> +		return undef_access(vcpu, p, r);
> +
> +	kvm_inject_sync(vcpu, kvm_vcpu_get_esr(vcpu));
> +	return false;
> +}
> +
>  enum sr_loc_attr {
>  	SR_LOC_MEMORY	= 0,	  /* Register definitely in memory */
>  	SR_LOC_LOADED	= BIT(0), /* Register on CPU, unless it cannot */
> @@ -3396,9 +3406,9 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	{ SYS_DESC(SYS_CCSIDR_EL1), access_ccsidr },
>  	{ SYS_DESC(SYS_CLIDR_EL1), access_clidr, reset_clidr, CLIDR_EL1,
>  	  .set_user = set_clidr, .val = ~CLIDR_EL1_RES0 },
> -	{ SYS_DESC(SYS_CCSIDR2_EL1), undef_access },
> -	{ SYS_DESC(SYS_GMID_EL1), undef_access },
> -	{ SYS_DESC(SYS_SMIDR_EL1), undef_access },
> +	{ SYS_DESC(SYS_CCSIDR2_EL1), idst_access },
> +	{ SYS_DESC(SYS_GMID_EL1), idst_access },
> +	{ SYS_DESC(SYS_SMIDR_EL1), idst_access },
>  	IMPLEMENTATION_ID(AIDR_EL1, GENMASK_ULL(63, 0)),
>  	{ SYS_DESC(SYS_CSSELR_EL1), access_csselr, reset_unknown, CSSELR_EL1 },
>  	ID_FILTERED(CTR_EL0, ctr_el0,


Thanks,

Ben

