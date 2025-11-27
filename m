Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1BFC25DB1C
	for <kvmarm@lists.linux.dev>; Thu, 27 Nov 2025 06:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764223636; cv=none; b=bwJgb1Dl5l5SLEgh6WQO7i0OJ+4qFA+2hlxkpAK5xDmr8HQOu6lyWzV8rNflC8A3yjQ+g9rNPDo+Ist/rRrixBYuKWb2oQ2QYnI8oSlbErriK7Q/KSlkUUjGkjNudaClwfhho+TnS3QzZMRaHxg6AZnilF+271qMIMBMRw7qK/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764223636; c=relaxed/simple;
	bh=QmExrOtXLUZqYy1VERKnLIHcvsFDA4kZp9t4eD9XhsM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TSXTUz+NbvoVsEBkcjlcEN+Y343FfhgN9VC3NSuiFkbq0k4/VOAZrOpFGfrSYXJa3Z2LptYegCz4rUVggmnx0+5o0uZQ8xoNpIT5e5OHDmLMCJhCmtvoqPJbC/Ll/G8XTN4XjsbaOhLEEstjkoRAzM5DnkNf3EftM0VPeQbuPQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=NyGaNEAx; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="NyGaNEAx"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1764223629; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=68ao8jnY/7hrInorg0kQFScLwkWgUiyORrqNpknEw0Q=;
	b=NyGaNEAxW3I7+Z6mDTrn4z/mpbh9mjGjAVyR0HbL6chU+xG5Yu0ODBi/mOGUDWoYNwDqmxa9Wna9QqC3e5kFp3K5CCkobmHgPlDGXfj/oNnextrgABMS1o5DjrfM7k4xFan8dYB2+kRU0oSXmhXNroV8Fo4l5cNQopWgFEWH4Vs=
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0WtVv285_1764223628 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 27 Nov 2025 14:07:08 +0800
Date: Thu, 27 Nov 2025 14:07:08 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Ben Horgan <ben.horgan@arm.com>
Subject: Re: [PATCH v2 4/5] KVM: arm64: Report optional ID register traps
 with a 0x18 syndrome
Message-ID: <dk6bwi72nwfty6qpbh2eaeubznqt74gjffas2rclrrwjn5tr6j@mjitrla3p3d7>
References: <20251126155951.1146317-1-maz@kernel.org>
 <20251126155951.1146317-5-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251126155951.1146317-5-maz@kernel.org>

On Wed, Nov 26, 2025 at 03:59:50PM +0800, Marc Zyngier wrote:
> With FEAT_IDST, unimplemented system registers in the feature ID space
> must be reported using EC=0x18 at the closest handling EL, rather than
> with an UNDEF.
>
> Most of these system registers are always implemented thanks to their
> dependency on FEAT_AA64, except for a set of (currently) three registers:
> GMID_EL1 (depending on MTE2), CCSIDR2_EL1 (depending on FEAT_CCIDX),
> and SMIDR_EL1 (depending on SME).
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
> index 2ca6862e935b5..7705f703e7c6d 100644
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

Hi Marc,

Minor: maybe beter readability if use NI instead of 0x0, just like
things in feat_nv2() below, but depends on you.

static bool feat_nv2(struct kvm *kvm)
{
	return ((kvm_has_feat(kvm, ID_AA64MMFR4_EL1, NV_frac, NV2_ONLY) &&
		 kvm_has_feat_enum(kvm, ID_AA64MMFR2_EL1, NV, NI)) ||
		kvm_has_feat(kvm, ID_AA64MMFR2_EL1, NV, NV2));
}


For others(except the "not" mentioned by Ben):

Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>

> +		return undef_access(vcpu, p, r);
> +
> +	kvm_inject_sync(vcpu, kvm_vcpu_get_esr(vcpu));
> +	return false;
> +}
> +
>  enum sr_loc_attr {
>  	SR_LOC_MEMORY	= 0,	  /* Register definitely in memory */
>  	SR_LOC_LOADED	= BIT(0), /* Register on CPU, unless it cannot */
> @@ -3399,9 +3409,9 @@ static const struct sys_reg_desc sys_reg_descs[] = {
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
> --
> 2.47.3
>
