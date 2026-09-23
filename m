Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9BB0486402
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 15:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790178480; cv=none; b=ULrT1Sq/ZsIcD2/PC61lOzGOIPumA00n4NWg9JumH0vrz6u/AS/9tTfMro6jlbH4IquSvGEDeJeeQrqh2CL+TWTnQ870eGlPrkcEOmKHhpI8w0luHJrELkN1CE48LPzPleLd190MSkP2OLLooFBsurMHe6B4FSan4TvZ/ZqoCQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790178480; c=relaxed/simple;
	bh=gvz6l43Mi62JVl44l3v8h6z20+ZQ+frZU+NjV8Okg5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=WFDceq4w4zPkaXbAc3Ndb7NRVAym1y2HsBDLzYni24KoOvpy/rEBxqDGV/xJ9zupE2P1t0oojFf9a/6c6HWX+yXDSQod48uRhhGcAMtwyUbZcVVmhSjLxoZbAoYl95rX0eftJB1sVgJ1GzMpP1oISBQOWT4058JdJ0ezVM84Y8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=IjW6c7JQ; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="IjW6c7JQ"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0966A1570;
	Wed, 23 Sep 2026 08:47:54 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5629B3F86F;
	Wed, 23 Sep 2026 08:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790178477; bh=gvz6l43Mi62JVl44l3v8h6z20+ZQ+frZU+NjV8Okg5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IjW6c7JQy+PV3W+wBTHVMe9Lpl937nsNtN9/9V7tdqFPCpaxBZGtOtYBYS9FJsvcR
	 DZ4CJeP7SyULbpDNOxB0WJcw6WsgYeyOeO08i7vmTve3zgNXh5xFmkvmkAdYi/Jrhq
	 WUWZ/Ooz6GuWQBnVrp2/bTP8tB6J/BFyzA57HntM=
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
Subject: Re: [PATCH 09/22] KVM: arm64: Compute S1 permissions as part of s1_walk()
Date: Wed, 23 Sep 2026 16:47:50 +0100
Message-ID: <arP0pquAK8KvnAR8@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260623184201.1518871-10-oupton@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org> <20260623184201.1518871-10-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Jun 23, 2026 at 11:41:48AM -0700, Oliver Upton wrote:
> Implementing support for hardware dirty state means that the table
> walker needs to have visibility into the permissions on the final
> translation.
> 
> Compute the S1 permissions as part of s1_walk() and initialize
> s1_walk_result before checking all fault conditions. The appropriate
> fields will be reinitialized if the walk happens to fail at a later
> point.
> 
> Signed-off-by: Oliver Upton <oupton@kernel.org>
> ---
>  arch/arm64/kvm/at.c | 41 ++++++++++++++++++++---------------------
>  1 file changed, 20 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index 083014e9d86a..6930bc3bc86b 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -461,6 +461,10 @@ static int kvm_swap_s1_desc(struct kvm_vcpu *vcpu, u64 pa, u64 old, u64 new,
>  	return __kvm_at_swap_desc(vcpu->kvm, pa, old, new);
>  }
>  
> +static void compute_s1_permissions(struct kvm_vcpu *vcpu,
> +				   struct s1_walk_info *wi,
> +				   struct s1_walk_result *wr);
> +
>  static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
>  		   struct s1_walk_result *wr, u64 va)
>  {
> @@ -590,6 +594,20 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
>  	if (check_output_size(baddr & GENMASK(52, va_bottom), wi))
>  		goto addrsz;
>  
> +	va_bottom += contiguous_bit_shift(desc, wi, level);
> +
> +	wr->failed = false;
> +	wr->level = level;
> +	wr->desc = desc;
> +	wr->pa = baddr & GENMASK(52, va_bottom);
> +	wr->pa |= va & GENMASK_ULL(va_bottom - 1, 0);
> +
> +	wr->nG = (wi->regime != TR_EL2) && (desc & PTE_NG);
> +	if (wr->nG)
> +		wr->asid = get_asid_by_regime(vcpu, wi->regime);
> +
> +	compute_s1_permissions(vcpu, wi, wr);
> +
>  	if (wi->ha)
>  		new_desc |= PTE_AF;
>  
> @@ -615,18 +633,6 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
>  		return -EACCES;
>  	}
>  
> -	va_bottom += contiguous_bit_shift(desc, wi, level);
> -
> -	wr->failed = false;
> -	wr->level = level;
> -	wr->desc = desc;
> -	wr->pa = baddr & GENMASK(52, va_bottom);
> -	wr->pa |= va & GENMASK_ULL(va_bottom - 1, 0);
> -
> -	wr->nG = (wi->regime != TR_EL2) && (desc & PTE_NG);
> -	if (wr->nG)
> -		wr->asid = get_asid_by_regime(vcpu, wi->regime);
> -
>  	return 0;
>  
>  addrsz:
> @@ -1365,8 +1371,6 @@ static int handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr, u64 *par)
>  	if (ret)
>  		goto compute_par;
>  
> -	compute_s1_permissions(vcpu, &wi, &wr);
> -
>  	switch (op) {
>  	case OP_AT_S1E1RP:
>  	case OP_AT_S1E1R:


Up to this point, everything seems straightforward with the commit message:
wr setting is moved up in walk_s1(), and compute_s1_permissions() is moved 
to inside walk_s1(), from it's place in handle_at_slow() where it was 
called after walk_s1() so it should be fine for any other user that needed 
it before. 

> @@ -1690,15 +1694,10 @@ int __kvm_translate_va(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
>  	if (wr->level == S1_MMU_DISABLED) {
>  		wr->ur = wr->uw = wr->ux = true;
>  		wr->pr = wr->pw = wr->px = true;
> -	} else {
> -		ret = walk_s1(vcpu, wi, wr, va);
> -		if (ret)
> -			return ret;
> -
> -		compute_s1_permissions(vcpu, wi, wr);
> +		return 0;
>  	}
>  
> -	return 0;
> +	return walk_s1(vcpu, wi, wr, va);
>  }

Here the else clause is optimized-out, as the if returns in the end.
Since you run compute_s1_permissions() inside walk_s1() now, there is no 
need to test walk_s1() return value anymore. Good improvement.

FWIW:
Reviewed-by: Leonardo Bras <leo.bras@arm.com>

Thanks!
Leo
