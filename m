Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4367F19A
	for <kvmarm@lists.linux.dev>; Thu,  1 May 2025 11:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746099169; cv=none; b=Cend611yWo+rU7py7pgGaZrhR20vaK9US5uYQEyb89D09eGBBst5xEC5BGVF9MlMNbtZ2Mx2hHV9QXZIqCYVjFnI6H07j2nHxBB/3G8n3nWW1egNuBDuFM7DIRTTB3ZLscBY9en2HxoprZZ2df4e3yQmRe8OVYpb0iydZzUtL4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746099169; c=relaxed/simple;
	bh=X72ts72r1U0mJbX6SCdjLaQCT+Y3Tfbmyl2f2/VsB5Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ty+u+7K4wEiumbCDc/sHK4/u8XKMMiaOtXjas7Uvq40aEaXOj3K5cwi/Ir7X1VpKx8J8oPkbfYh6RwjDqa7Hwdu9MwSIKwFWAx5wkze+mmdWuCKHl4482PYCTOPfdd9kzMDeLPTiZcACkATYqH0TmO+E7yMWm0Dt7BPK4LyIcTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 09FBF106F;
	Thu,  1 May 2025 04:32:39 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 977E63F5A1;
	Thu,  1 May 2025 04:32:44 -0700 (PDT)
Date: Thu, 1 May 2025 12:32:41 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>, Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 21/42] KVM: arm64: Compute FGT masks from KVM's own
 FGT tables
Message-ID: <20250501113241.GI1859293@e124191.cambridge.arm.com>
References: <20250426122836.3341523-1-maz@kernel.org>
 <20250426122836.3341523-22-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250426122836.3341523-22-maz@kernel.org>

On Sat, Apr 26, 2025 at 01:28:15PM +0100, Marc Zyngier wrote:
> In the process of decoupling KVM's view of the FGT bits from the
> wider architectural state, use KVM's own FGT tables to build
> a synthetic view of what is actually known.
> 
> This allows for some checking along the way.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

> ---
>  arch/arm64/include/asm/kvm_host.h |  14 ++++
>  arch/arm64/kvm/emulate-nested.c   | 106 ++++++++++++++++++++++++++++++
>  2 files changed, 120 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 7a1ef5be7efb2..95fedd27f4bb8 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -607,6 +607,20 @@ struct kvm_sysreg_masks {
>  	} mask[NR_SYS_REGS - __SANITISED_REG_START__];
>  };
>  
> +struct fgt_masks {
> +	const char	*str;
> +	u64		mask;
> +	u64		nmask;
> +	u64		res0;
> +};
> +
> +extern struct fgt_masks hfgrtr_masks;
> +extern struct fgt_masks hfgwtr_masks;
> +extern struct fgt_masks hfgitr_masks;
> +extern struct fgt_masks hdfgrtr_masks;
> +extern struct fgt_masks hdfgwtr_masks;
> +extern struct fgt_masks hafgrtr_masks;
> +
>  struct kvm_cpu_context {
>  	struct user_pt_regs regs;	/* sp = sp_el0 */
>  
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index 52a2d63a667c9..528b33fcfcfd6 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -2033,6 +2033,105 @@ static u32 encoding_next(u32 encoding)
>  	return sys_reg(op0 + 1, 0, 0, 0, 0);
>  }
>  
> +#define FGT_MASKS(__n, __m)						\
> +	struct fgt_masks __n = { .str = #__m, .res0 = __m, }
> +
> +FGT_MASKS(hfgrtr_masks, HFGRTR_EL2_RES0);
> +FGT_MASKS(hfgwtr_masks, HFGWTR_EL2_RES0);
> +FGT_MASKS(hfgitr_masks, HFGITR_EL2_RES0);
> +FGT_MASKS(hdfgrtr_masks, HDFGRTR_EL2_RES0);
> +FGT_MASKS(hdfgwtr_masks, HDFGWTR_EL2_RES0);
> +FGT_MASKS(hafgrtr_masks, HAFGRTR_EL2_RES0);
> +
> +static __init bool aggregate_fgt(union trap_config tc)
> +{
> +	struct fgt_masks *rmasks, *wmasks;
> +
> +	switch (tc.fgt) {
> +	case HFGRTR_GROUP:
> +		rmasks = &hfgrtr_masks;
> +		wmasks = &hfgwtr_masks;
> +		break;
> +	case HDFGRTR_GROUP:
> +		rmasks = &hdfgrtr_masks;
> +		wmasks = &hdfgwtr_masks;
> +		break;
> +	case HAFGRTR_GROUP:
> +		rmasks = &hafgrtr_masks;
> +		wmasks = NULL;
> +		break;
> +	case HFGITR_GROUP:
> +		rmasks = &hfgitr_masks;
> +		wmasks = NULL;
> +		break;
> +	}
> +
> +	/*
> +	 * A bit can be reserved in either the R or W register, but
> +	 * not both.
> +	 */
> +	if ((BIT(tc.bit) & rmasks->res0) &&
> +	    (!wmasks || (BIT(tc.bit) & wmasks->res0)))
> +		return false;
> +
> +	if (tc.pol)
> +		rmasks->mask |= BIT(tc.bit) & ~rmasks->res0;
> +	else
> +		rmasks->nmask |= BIT(tc.bit) & ~rmasks->res0;
> +
> +	if (wmasks) {
> +		if (tc.pol)
> +			wmasks->mask |= BIT(tc.bit) & ~wmasks->res0;
> +		else
> +			wmasks->nmask |= BIT(tc.bit) & ~wmasks->res0;
> +	}
> +
> +	return true;
> +}
> +
> +static __init int check_fgt_masks(struct fgt_masks *masks)
> +{
> +	unsigned long duplicate = masks->mask & masks->nmask;
> +	u64 res0 = masks->res0;
> +	int ret = 0;
> +
> +	if (duplicate) {
> +		int i;
> +
> +		for_each_set_bit(i, &duplicate, 64) {
> +			kvm_err("%s[%d] bit has both polarities\n",
> +				masks->str, i);
> +		}
> +
> +		ret = -EINVAL;
> +	}
> +
> +	masks->res0 = ~(masks->mask | masks->nmask);
> +	if (masks->res0 != res0)
> +		kvm_info("Implicit %s = %016llx, expecting %016llx\n",
> +			 masks->str, masks->res0, res0);
> +
> +	return ret;
> +}
> +
> +static __init int check_all_fgt_masks(int ret)
> +{
> +	static struct fgt_masks * const masks[] __initconst = {
> +		&hfgrtr_masks,
> +		&hfgwtr_masks,
> +		&hfgitr_masks,
> +		&hdfgrtr_masks,
> +		&hdfgwtr_masks,
> +		&hafgrtr_masks,
> +	};
> +	int err = 0;
> +
> +	for (int i = 0; i < ARRAY_SIZE(masks); i++)
> +		err |= check_fgt_masks(masks[i]);
> +
> +	return ret ?: err;
> +}
> +
>  int __init populate_nv_trap_config(void)
>  {
>  	int ret = 0;
> @@ -2097,8 +2196,15 @@ int __init populate_nv_trap_config(void)
>  			ret = xa_err(prev);
>  			print_nv_trap_error(fgt, "Failed FGT insertion", ret);
>  		}
> +
> +		if (!aggregate_fgt(tc)) {
> +			ret = -EINVAL;
> +			print_nv_trap_error(fgt, "FGT bit is reserved", ret);
> +		}
>  	}
>  
> +	ret = check_all_fgt_masks(ret);
> +
>  	kvm_info("nv: %ld fine grained trap handlers\n",
>  		 ARRAY_SIZE(encoding_to_fgt));
>  
> -- 
> 2.39.2
> 
