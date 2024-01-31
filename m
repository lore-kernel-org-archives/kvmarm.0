Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C51B7135403
	for <kvmarm@lists.linux.dev>; Wed, 31 Jan 2024 14:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706713081; cv=none; b=LOp2OG0N/ejLeJS5QzVax2TdDcPWQsjPC9NcPf+CA63a4xn9P4J/n1gTdQRTNguxdNeA7hVhetDkh3wWZpTq0eQOCBsBPikJ88Maq78BIZ7hKE+jjxPsaT0jWJ7JMj6tIbTLVsS9X7f+P2Mz7/OZ7JYien8erXoh8BcjTIrlHtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706713081; c=relaxed/simple;
	bh=BZa/ahLGkk08b+xnQxlZSNSS4/OSvZFbfYtcadIrVBI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fU7JElsnO0kbupnLHOndX5iA6V538aQQ34YLlDRPwIJhtvrj7v6N0KlgumfkM3adfiCQ1uHuoNTUJBuddZOkiw212iz/MOpZsMla0mlL+pNai+ehRmS1UVaMkzAG8Mlxij4UUAutu6/wCih1spUIUh3tkohMDAB1aRLlGdrWy9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 74148DA7;
	Wed, 31 Jan 2024 06:58:42 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D20183F762;
	Wed, 31 Jan 2024 06:57:57 -0800 (PST)
Date: Wed, 31 Jan 2024 14:57:55 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v2 10/25] KVM: arm64: nv: Turn encoding ranges into
 discrete XArray stores
Message-ID: <20240131145755.GC2284078@e124191.cambridge.arm.com>
References: <20240130204533.693853-1-maz@kernel.org>
 <20240130204533.693853-11-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240130204533.693853-11-maz@kernel.org>

On Tue, Jan 30, 2024 at 08:45:17PM +0000, Marc Zyngier wrote:
> In order to be able to store different values for member of an
> encoding range, replace xa_store_range() calls with discrete
> xa_store() calls and an encoding iterator.
> 
> We end-up using a bit more memory, but we gain some flexibility
> that we will make use of shortly.
> 
> Take this opportunity to tidy up the error handling path.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/emulate-nested.c | 49 ++++++++++++++++++++++++---------
>  1 file changed, 36 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index ef46c2e45307..42f5b4483c80 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -1757,6 +1757,28 @@ static __init void print_nv_trap_error(const struct encoding_to_trap_config *tc,
>  		err);
>  }
>  
> +static u32 encoding_next(u32 encoding)
> +{
> +	u8 op0, op1, crn, crm, op2;
> +
> +	op0 = sys_reg_Op0(encoding);
> +	op1 = sys_reg_Op1(encoding);
> +	crn = sys_reg_CRn(encoding);
> +	crm = sys_reg_CRm(encoding);
> +	op2 = sys_reg_Op2(encoding);
> +
> +	if (op2 < Op2_mask)
> +		return sys_reg(op0, op1, crn, crm, op2 + 1);
> +	if (crm < CRm_mask)
> +		return sys_reg(op0, op1, crn, crm + 1, 0);
> +	if (crn < CRn_mask)
> +		return sys_reg(op0, op1, crn + 1, 0, 0);
> +	if (op1 < Op1_mask)
> +		return sys_reg(op0, op1 + 1, 0, 0, 0);
> +
> +	return sys_reg(op0 + 1, 0, 0, 0, 0);
> +}
> +
>  int __init populate_nv_trap_config(void)
>  {
>  	int ret = 0;
> @@ -1775,23 +1797,18 @@ int __init populate_nv_trap_config(void)
>  			ret = -EINVAL;
>  		}
>  
> -		if (cgt->encoding != cgt->end) {
> -			prev = xa_store_range(&sr_forward_xa,
> -					      cgt->encoding, cgt->end,
> -					      xa_mk_value(cgt->tc.val),
> -					      GFP_KERNEL);
> -		} else {
> -			prev = xa_store(&sr_forward_xa, cgt->encoding,
> +		for (u32 enc = cgt->encoding; enc <= cgt->end; enc = encoding_next(enc)) {
> +			prev = xa_store(&sr_forward_xa, enc,
>  					xa_mk_value(cgt->tc.val), GFP_KERNEL);
>  			if (prev && !xa_is_err(prev)) {
>  				ret = -EINVAL;
>  				print_nv_trap_error(cgt, "Duplicate CGT", ret);
>  			}
> -		}
>  
> -		if (xa_is_err(prev)) {
> -			ret = xa_err(prev);
> -			print_nv_trap_error(cgt, "Failed CGT insertion", ret);
> +			if (xa_is_err(prev)) {
> +				ret = xa_err(prev);
> +				print_nv_trap_error(cgt, "Failed CGT insertion", ret);
> +			}
>  		}
>  	}
>  
> @@ -1804,6 +1821,7 @@ int __init populate_nv_trap_config(void)
>  	for (int i = 0; i < ARRAY_SIZE(encoding_to_fgt); i++) {
>  		const struct encoding_to_trap_config *fgt = &encoding_to_fgt[i];
>  		union trap_config tc;
> +		void *prev;
>  
>  		if (fgt->tc.fgt >= __NR_FGT_GROUP_IDS__) {
>  			ret = -EINVAL;
> @@ -1818,8 +1836,13 @@ int __init populate_nv_trap_config(void)
>  		}
>  
>  		tc.val |= fgt->tc.val;
> -		xa_store(&sr_forward_xa, fgt->encoding,
> -			 xa_mk_value(tc.val), GFP_KERNEL);
> +		prev = xa_store(&sr_forward_xa, fgt->encoding,
> +				xa_mk_value(tc.val), GFP_KERNEL);
> +
> +		if (xa_is_err(prev)) {
> +			ret = xa_err(prev);
> +			print_nv_trap_error(fgt, "Failed FGT insertion", ret);
> +		}
>  	}
>  
>  	kvm_info("nv: %ld fine grained trap handlers\n",

Tidied up error handling from v1.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

Thanks,
Joey
