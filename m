Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06438483BC5
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 11:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789990221; cv=none; b=iACxwrgDaMU+3XAULVX1F5eDwBSUKc8xvkRIlbR2MzxquxpM/lZ7qECLrD8QJE9wOyxXxoccXly0pBhITZvql23gsaz6u299Q8j8cxrOaWUSiwZGiKZVE0zyg3pG5rzsS47f4sogsnbqgfDX7D+74Kc04zInx/dY4w8mfbBwAb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789990221; c=relaxed/simple;
	bh=Z93kt2xblH1R6Yj/oyJzRbGK+fWlNdRhADVhn5v/1I0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=YfXodNJoBRP+Ap7VvAy9hfdyQ3t21c7lq7xKoO58kJExRxQvxvKiSEUTz0kZqBaixNOn9t+X6lkXlcd8cyt0WFVM0bP6jWR6YdBh2zslji8GLzRv4EZmMgNvhwn3msi69Azu8O+I8nSGmV8GMkv3Ontqwr6/3NDn5It3iMkH1Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=O/atltlR; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="O/atltlR"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DECDB176C;
	Mon, 21 Sep 2026 04:30:15 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 381D33F86F;
	Mon, 21 Sep 2026 04:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789990219; bh=Z93kt2xblH1R6Yj/oyJzRbGK+fWlNdRhADVhn5v/1I0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O/atltlRLEC1kxO+EVB0prG9TzdydjRR08BhevQxaXXyNKFT58h2NJf6+QYFFCDwI
	 DJuUg3AIR0A/1Saheo8xA1aBFZzzN9vphP1l7yBM+ppS+LXwywO9w8VJgvtTSRTWkB
	 mltq31GMpYx7xvhOHoECqaLaL5Dmq0zcLmv4y9pE=
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
Subject: Re: [PATCH 01/22] KVM: arm64: nv: Introduce struct for stage-2 walk step
Date: Mon, 21 Sep 2026 12:30:01 +0100
Message-ID: <arEVOEP6PZI0MxdY@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260623184201.1518871-2-oupton@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org> <20260623184201.1518871-2-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Jun 23, 2026 at 11:41:40AM -0700, Oliver Upton wrote:
> Factoring out helpers from walk_nested_s2_pgd() will require passing the
> context of the current walk step. Prepare by reorganizing the relvant
> information into a struct.
> 
> Signed-off-by: Oliver Upton <oupton@kernel.org>
> ---
>  arch/arm64/kvm/nested.c | 109 +++++++++++++++++++++-------------------
>  1 file changed, 57 insertions(+), 52 deletions(-)
> 
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 94df26de6990..9e60c7c822ae 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -134,6 +134,12 @@ struct s2_walk_info {
>  	bool		ha;
>  };
>  
> +struct s2_walk_step {
> +	u64		desc_pa;
> +	u64		desc;
> +	int		level;
> +};
> +
>  static u32 compute_fsc(int level, u32 fsc)
>  {
>  	return fsc | (level & 0x3);
> @@ -199,13 +205,13 @@ static int check_output_size(struct s2_walk_info *wi, phys_addr_t output)
>  	return 0;
>  }
>  
> -static int read_guest_s2_desc(struct kvm_vcpu *vcpu, phys_addr_t pa, u64 *desc,
> +static int read_guest_s2_desc(struct kvm_vcpu *vcpu, struct s2_walk_step *ws,
>  			      struct s2_walk_info *wi)
>  {
>  	u64 val;
>  	int r;
>  
> -	r = kvm_read_guest(vcpu->kvm, pa, &val, sizeof(val));
> +	r = kvm_read_guest(vcpu->kvm, ws->desc_pa, &val, sizeof(val));
>  	if (r)
>  		return r;
>  
> @@ -214,9 +220,9 @@ static int read_guest_s2_desc(struct kvm_vcpu *vcpu, phys_addr_t pa, u64 *desc,
>  	 * host and the guest hypervisor.
>  	 */
>  	if (wi->be)
> -		*desc = be64_to_cpu((__force __be64)val);
> +		ws->desc = be64_to_cpu((__force __be64)val);
>  	else
> -		*desc = le64_to_cpu((__force __le64)val);
> +		ws->desc = le64_to_cpu((__force __le64)val);
>  
>  	return 0;
>  }
> @@ -245,22 +251,22 @@ static int swap_guest_s2_desc(struct kvm_vcpu *vcpu, phys_addr_t pa, u64 old, u6
>  static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, phys_addr_t ipa,
>  			      struct s2_walk_info *wi, struct kvm_s2_trans *out)
>  {
> -	int first_block_level, level, stride, input_size, base_lower_bound;
> +	int first_block_level, stride, input_size, base_lower_bound;
> +	struct s2_walk_step ws = {};
>  	phys_addr_t base_addr;
>  	unsigned int addr_top, addr_bottom;
> -	u64 desc, new_desc;  /* page table entry */
> +	u64 new_desc;  /* page table entry */
>  	int ret;
> -	phys_addr_t paddr;
>  
>  	switch (BIT(wi->pgshift)) {
>  	default:
>  	case SZ_64K:
>  	case SZ_16K:
> -		level = 3 - wi->sl;
> +		ws.level = 3 - wi->sl;
>  		first_block_level = 2;
>  		break;
>  	case SZ_4K:
> -		level = 2 - wi->sl;
> +		ws.level = 2 - wi->sl;
>  		first_block_level = 1;
>  		break;
>  	}
> @@ -270,13 +276,13 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, phys_addr_t ipa,
>  	if (input_size > 48 || input_size < 25)
>  		return -EFAULT;
>  
> -	ret = check_base_s2_limits(vcpu, wi, level, input_size, stride);
> +	ret = check_base_s2_limits(vcpu, wi, ws.level, input_size, stride);
>  	if (WARN_ON(ret)) {
>  		out->esr = compute_fsc(0, ESR_ELx_FSC_FAULT);
>  		return ret;
>  	}
>  
> -	base_lower_bound = 3 + input_size - ((3 - level) * stride +
> +	base_lower_bound = 3 + input_size - ((3 - ws.level) * stride +
>  			   wi->pgshift);
>  	base_addr = wi->baddr & GENMASK_ULL(47, base_lower_bound);
>  
> @@ -291,96 +297,95 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, phys_addr_t ipa,
>  	while (1) {
>  		phys_addr_t index;
>  
> -		addr_bottom = (3 - level) * stride + wi->pgshift;
> +		addr_bottom = (3 - ws.level) * stride + wi->pgshift;
>  		index = (ipa & GENMASK_ULL(addr_top, addr_bottom))
>  			>> (addr_bottom - 3);
>  
> -		paddr = base_addr | index;
> -		ret = read_guest_s2_desc(vcpu, paddr, &desc, wi);
> +		ws.desc_pa = base_addr | index;
> +		ret = read_guest_s2_desc(vcpu, &ws, wi);
>  		if (ret < 0) {
> -			out->esr = ESR_ELx_FSC_SEA_TTW(level);
> +			out->esr = ESR_ELx_FSC_SEA_TTW(ws.level);
>  			return ret;
>  		}
>  
> -		new_desc = desc;
> +		new_desc = ws.desc;
>  
>  		/* Check for valid descriptor at this point */
> -		if (!(desc & KVM_PTE_VALID)) {
> -			out->esr = compute_fsc(level, ESR_ELx_FSC_FAULT);
> -			out->desc = desc;
> +		if (!(ws.desc & KVM_PTE_VALID)) {
> +			out->esr = compute_fsc(ws.level, ESR_ELx_FSC_FAULT);
> +			out->desc = ws.desc;
>  			return 1;
>  		}
>  
> -		if (FIELD_GET(KVM_PTE_TYPE, desc) == KVM_PTE_TYPE_BLOCK) {
> -			if (level < 3)
> +		if (FIELD_GET(KVM_PTE_TYPE, ws.desc) == KVM_PTE_TYPE_BLOCK) {
> +			if (ws.level < 3)
>  				break;
>  
> -			out->esr = compute_fsc(level, ESR_ELx_FSC_FAULT);
> -			out->desc = desc;
> +			out->esr = compute_fsc(ws.level, ESR_ELx_FSC_FAULT);
> +			out->desc = ws.desc;
>  			return 1;
>  		}
>  
>  		/* We're at the final level */
> -		if (level == 3)
> +		if (ws.level == 3)
>  			break;
>  
> -		if (check_output_size(wi, desc)) {
> -			out->esr = compute_fsc(level, ESR_ELx_FSC_ADDRSZ);
> -			out->desc = desc;
> +		if (check_output_size(wi, ws.desc)) {
> +			out->esr = compute_fsc(ws.level, ESR_ELx_FSC_ADDRSZ);
> +			out->desc = ws.desc;
>  			return 1;
>  		}
>  
> -		base_addr = desc & GENMASK_ULL(47, wi->pgshift);
> +		base_addr = ws.desc & GENMASK_ULL(47, wi->pgshift);
>  
> -		level += 1;
> +		ws.level += 1;
>  		addr_top = addr_bottom - 1;
>  	}
>  
> -	if (level < first_block_level) {
> -		out->esr = compute_fsc(level, ESR_ELx_FSC_FAULT);
> -		out->desc = desc;
> +	if (ws.level < first_block_level) {
> +		out->esr = compute_fsc(ws.level, ESR_ELx_FSC_FAULT);
> +		out->desc = ws.desc;
>  		return 1;
>  	}
>  
> -	if (check_output_size(wi, desc)) {
> -		out->esr = compute_fsc(level, ESR_ELx_FSC_ADDRSZ);
> -		out->desc = desc;
> +	if (check_output_size(wi, ws.desc)) {
> +		out->esr = compute_fsc(ws.level, ESR_ELx_FSC_ADDRSZ);
> +		out->desc = ws.desc;
>  		return 1;
>  	}
>  
>  	if (wi->ha)
>  		new_desc |= KVM_PTE_LEAF_ATTR_LO_S2_AF;
>  
> -	if (new_desc != desc) {
> -		ret = swap_guest_s2_desc(vcpu, paddr, desc, new_desc, wi);
> +	if (new_desc != ws.desc) {
> +		ret = swap_guest_s2_desc(vcpu, ws.desc_pa, ws.desc, new_desc, wi);
>  		if (ret == -EAGAIN)
>  			return ret;
>  		if (ret) {
> -			out->esr = ESR_ELx_FSC_SEA_TTW(level);
> -			out->desc = desc;
> +			out->esr = ESR_ELx_FSC_SEA_TTW(ws.level);
> +			out->desc = ws.desc;
>  			return 1;
>  		}
>  
> -		desc = new_desc;
> +		ws.desc = new_desc;
>  	}
>  
> -	if (!(desc & KVM_PTE_LEAF_ATTR_LO_S2_AF)) {
> -		out->esr = compute_fsc(level, ESR_ELx_FSC_ACCESS);
> -		out->desc = desc;
> +	if (!(ws.desc & KVM_PTE_LEAF_ATTR_LO_S2_AF)) {
> +		out->esr = compute_fsc(ws.level, ESR_ELx_FSC_ACCESS);
> +		out->desc = ws.desc;
>  		return 1;
>  	}
>  
> -	addr_bottom += contiguous_bit_shift(desc, wi, level);
> +	addr_bottom += contiguous_bit_shift(ws.desc, wi, ws.level);
>  
>  	/* Calculate and return the result */
> -	paddr = (desc & GENMASK_ULL(47, addr_bottom)) |
> -		(ipa & GENMASK_ULL(addr_bottom - 1, 0));
> -	out->output = paddr;
> -	out->block_size = 1UL << ((3 - level) * stride + wi->pgshift);
> -	out->readable = desc & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
> -	out->writable = desc & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> -	out->level = level;
> -	out->desc = desc;
> +	out->output = (ws.desc & GENMASK_ULL(47, addr_bottom)) |
> +		      (ipa & GENMASK_ULL(addr_bottom - 1, 0));
> +	out->block_size = 1UL << ((3 - ws.level) * stride + wi->pgshift);
> +	out->readable = ws.desc & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
> +	out->writable = ws.desc & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> +	out->level = ws.level;
> +	out->desc = ws.desc;
>  	return 0;
>  }
>  
> -- 
> 2.47.3
> 


Seems pretty straightforward, I could not find any issue.
FWIW:

Reviewed-by: Leonardo Bras <leo.bras@arm.com>

Thanks!
Leo
