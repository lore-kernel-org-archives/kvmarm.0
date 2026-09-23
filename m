Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E381737DAB3
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 17:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790183025; cv=none; b=p+oZmn273O8fW3XtMcmPqQkwFvmxFMnNUmfbaqOIRCzH4o22pfdzbOl+MGAPi0UWA667XsKAIaLWljn4uPH3gExm7zZGPPXuVuLLIFhAvAcDI1w/NoP7SF/xGSWhx8m9nIBrqoULAVZIRo0oF7udwZWZ6hE3Ayi9t/47y8ncht4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790183025; c=relaxed/simple;
	bh=lp4Qgzhfhd5M4M0XVAZvaUjXAZlasBTkdkl8t5Iniq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=OmEknliXuZO5E9RW0sifAjUQWVgdzTglwtKr4OFq8WFZgdpEVl08Rm2LWD+a5TTHvPSi9g/fggMp5RLagILCVgDaulfjjZZv5p5ebe36/YgqKb1eN7JMjzzvfYB2U7Z/gw1Og66WjNFF+eukIjRgeWU7xV06M7JO5yjkkqrnMfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Pxclbg6T; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Pxclbg6T"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B6D291516;
	Wed, 23 Sep 2026 10:03:39 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C904B3F86F;
	Wed, 23 Sep 2026 10:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790183023; bh=lp4Qgzhfhd5M4M0XVAZvaUjXAZlasBTkdkl8t5Iniq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pxclbg6TCzRSiTLFiyKpToZqx1eq9x8SRUHSCFCaTshNYMkuQu4rwB83ezcGRD74j
	 FAJoThAhlT/1ae04n83wSDS+wm9eHj1BrIyc7EtD0ICwynnMIg7aKVS2V+BegK4pEZ
	 762f5CFK6AMI44cExJ4NELlY6QnjKhpEPuU7GP8o=
From: Leonardo Bras <leo.bras@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>
Subject: Re: [PATCH 11/22] KVM: arm64: Use a struct for stage-1 walk context
Date: Wed, 23 Sep 2026 18:03:39 +0100
Message-ID: <arQGa54nNYBokQ8F@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260623184201.1518871-12-oupton@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org> <20260623184201.1518871-12-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Jun 23, 2026 at 11:41:50AM -0700, Oliver Upton wrote:
> Consolidate the current walk step in a struct such that helpers can be
> spun off from the core implementation.
> 
> Signed-off-by: Oliver Upton <oupton@kernel.org>
> ---
>  arch/arm64/kvm/at.c | 94 ++++++++++++++++++++++++---------------------
>  1 file changed, 51 insertions(+), 43 deletions(-)
> 
> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index 597e9cddfc7e..816d23e7752d 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -429,6 +429,14 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
>  	return -EFAULT;
>  }
>  
> +struct s1_walk_step {
> +	u64			desc;
> +	u64			desc_ipa;
> +	u64			desc_pa;
> +	struct kvm_s2_trans	s2_trans;
> +	int			level;
> +};
> +
>  static int kvm_read_s1_desc(struct kvm_vcpu *vcpu, u64 pa, u64 *desc,
>  			    struct s1_walk_info *wi)
>  {
> @@ -468,12 +476,12 @@ static void compute_s1_permissions(struct kvm_vcpu *vcpu,
>  static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
>  		   struct s1_walk_result *wr, struct kvm_walk_access *access)
>  {
> -	u64 va_top, va_bottom, baddr, desc, new_desc, ipa, va;
> -	struct kvm_s2_trans s2_trans = {};
> -	int level, stride, ret;
> +	u64 va_top, va_bottom, baddr, new_desc, va;
> +	struct s1_walk_step ws = {};
> +	int stride, ret;
>  
>  	va = access->ia;
> -	level = wi->sl;
> +	ws.level = wi->sl;
>  	stride = wi->pgshift - 3;
>  	baddr = wi->baddr;
>  
> @@ -482,15 +490,15 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
>  	while (1) {
>  		u64 index;
>  
> -		va_bottom = (3 - level) * stride + wi->pgshift;
> +		va_bottom = (3 - ws.level) * stride + wi->pgshift;
>  		index = (va & GENMASK_ULL(va_top, va_bottom)) >> (va_bottom - 3);
>  
> -		ipa = baddr | index;
> +		ws.desc_ipa = ws.desc_pa = baddr | index;
>  
>  		if (wi->s2) {
>  			struct kvm_walk_access s2_access = {
>  				.type	= WALK_ACCESS_S1PTW,
> -				.ia	= ipa,
> +				.ia	= ws.desc_ipa,

I only see desc_ipa being used here, and at this point, desc_ipa is the 
same as desc_pa, and we are copying it's value to this new struct.

Maybe we should postpone it's introduction to when it's actually needed?

All the rest seems just converting walk_s1() to use the new struct instead 
of the previously existing variables. So it should be ok.

If there is a good reason for desc_ipa being needed here, or if it can be 
removed on the next version, then FWIW:

Reviewed-by: Leonardo Bras <leo.bras@arm.com>

Thanks!
Leo 

