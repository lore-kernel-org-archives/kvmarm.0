Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0C7B77620
	for <kvmarm@lists.linux.dev>; Wed, 24 Jan 2024 16:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706114072; cv=none; b=BQ3M9AaLg3oT9EanCgckpESXj9wIn48klelJiGqMxH9x4Qd4BEcFKsDe45na+/1dvqvd/12x5cgdePadxzdzGp0uMBtlGIEuVKE8259aksJYMf09JA9cTtSjynPUaoaNhQt/VvqdSaAZtBoiwhIhwusGGcxsE0EmXuc0IiA02kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706114072; c=relaxed/simple;
	bh=WNGcN+1lN4qK/CUD+uHIktzU9q1B6QDJzX3rG20IXOs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l3LYEv4qbel/8b00aEcce1bWsEMB/kx5OBoXM016YBBVsSPccp/Q4aOyZdwRkPjtnV4wkTLRtHYn1Pw7XWDJediQU/Nl4QDjv/HbFq42YFTj/dipxxUjwwhiUIZ3WuRrnW0dIwEIZlp/Sh8585L9Y8nqE5MhGeBayBhCI8pmsEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 248021FB;
	Wed, 24 Jan 2024 08:35:14 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D2F5C3F762;
	Wed, 24 Jan 2024 08:34:27 -0800 (PST)
Date: Wed, 24 Jan 2024 16:34:25 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 14/25] KVM: arm64: Register AArch64 system register
 entries with the sysreg xarray
Message-ID: <20240124163425.GJ1283334@e124191.cambridge.arm.com>
References: <20240122201852.262057-1-maz@kernel.org>
 <20240122201852.262057-15-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240122201852.262057-15-maz@kernel.org>

On Mon, Jan 22, 2024 at 08:18:41PM +0000, Marc Zyngier wrote:
> In order to reduce the number of lookups that we have to perform
> when handling a sysreg, register each AArch64 sysreg descriptor
> with the global xarray. The index of the descriptor is stored
> as a 10 bit field in the data word.
> 
> Subsequent patches will retrieve and use the stored index.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h |  3 +++
>  arch/arm64/kvm/emulate-nested.c   | 39 +++++++++++++++++++++++++++++--
>  arch/arm64/kvm/sys_regs.c         | 11 ++++++++-
>  3 files changed, 50 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index fe35c59214ad..e7a6219f2929 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1083,6 +1083,9 @@ int kvm_handle_cp10_id(struct kvm_vcpu *vcpu);
>  void kvm_reset_sys_regs(struct kvm_vcpu *vcpu);
>  
>  int __init kvm_sys_reg_table_init(void);
> +struct sys_reg_desc;
> +int __init populate_sysreg_config(const struct sys_reg_desc *sr,
> +				  unsigned int idx);
>  int __init populate_nv_trap_config(void);
>  
>  bool lock_all_vcpus(struct kvm *kvm);
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index 59622636b723..342d43b66fda 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -427,12 +427,14 @@ static const complex_condition_check ccc[] = {
>   * [19:14]	bit number in the FGT register (6 bits)
>   * [20]		trap polarity (1 bit)
>   * [25:21]	FG filter (5 bits)
> - * [62:26]	Unused (37 bits)
> + * [35:26]	Main SysReg table index (10 bits)
> + * [62:36]	Unused (27 bits)
>   * [63]		RES0 - Must be zero, as lost on insertion in the xarray
>   */
>  #define TC_CGT_BITS	10
>  #define TC_FGT_BITS	4
>  #define TC_FGF_BITS	5
> +#define TC_MSR_BITS	10
>  
>  union trap_config {
>  	u64	val;
> @@ -442,7 +444,8 @@ union trap_config {
>  		unsigned long	bit:6;		 /* Bit number */
>  		unsigned long	pol:1;		 /* Polarity */
>  		unsigned long	fgf:TC_FGF_BITS; /* Fine Grained Filter */
> -		unsigned long	unused:37;	 /* Unused, should be zero */
> +		unsigned long	msr:TC_MSR_BITS; /* Main SysReg index */
> +		unsigned long	unused:27;	 /* Unused, should be zero */
>  		unsigned long	mbz:1;		 /* Must Be Zero */
>  	};
>  };
> @@ -1862,6 +1865,38 @@ int __init populate_nv_trap_config(void)
>  	return ret;
>  }
>  
> +int __init populate_sysreg_config(const struct sys_reg_desc *sr,
> +				  unsigned int idx)
> +{
> +	union trap_config tc;
> +	u32 encoding;
> +	void *ret;
> +
> +	/*
> +	 * 0 is a valid value for the index, but not for the storage.
> +	 * We'll store (idx+1), so check against an offset'd limit.
> +	 */
> +	if (idx >= (BIT(TC_MSR_BITS) - 1)) {
> +		kvm_err("sysreg %s (%d) out of range\n", sr->name, idx);
> +		return -EINVAL;
> +	}
> +
> +	encoding = sys_reg(sr->Op0, sr->Op1, sr->CRn, sr->CRm, sr->Op2);
> +	tc = get_trap_config(encoding);
> +
> +	if (tc.msr) {
> +		kvm_err("sysreg %s (%d) duplicate entry (%d)\n",
> +			sr->name, idx - 1, tc.msr);
> +		return -EINVAL;
> +	}
> +
> +	tc.msr = idx + 1;
> +	ret = xa_store(&sr_forward_xa, encoding,
> +		       xa_mk_value(tc.val), GFP_KERNEL);
> +
> +	return xa_err(ret);
> +}
> +
>  static enum trap_behaviour get_behaviour(struct kvm_vcpu *vcpu,
>  					 const struct trap_bits *tb)
>  {
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 77cd818c23b0..65319193e443 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -3974,6 +3974,7 @@ int __init kvm_sys_reg_table_init(void)
>  	struct sys_reg_params params;
>  	bool valid = true;
>  	unsigned int i;
> +	int ret = 0;
>  
>  	/* Make sure tables are unique and in order. */
>  	valid &= check_sysreg_table(sys_reg_descs, ARRAY_SIZE(sys_reg_descs), false);
> @@ -3997,5 +3998,13 @@ int __init kvm_sys_reg_table_init(void)
>  	if (!first_idreg)
>  		return -EINVAL;
>  
> -	return populate_nv_trap_config();
> +	ret = populate_nv_trap_config();
> +
> +	for (i = 0; !ret && i < ARRAY_SIZE(sys_reg_descs); i++)
> +		ret = populate_sysreg_config(sys_reg_descs + i, i);
> +
> +	for (i = 0; !ret && i < ARRAY_SIZE(sys_insn_descs); i++)
> +		ret = populate_sysreg_config(sys_insn_descs + i, i);
> +
> +	return ret;
>  }

The choice of `msr` was a tiny bit confusing due to the conflict with the asm
instruction `msr`, but not enough to warrant renaming.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

Thanks,
Joey
