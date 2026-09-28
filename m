Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C14614DA9AF
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 14:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790606027; cv=none; b=ntbYHRs8EG0aGApRA8RjckqMY1QmYqicm3NPkqbHuntG2dfUG7E9+4hz9nwabfJw64MjBx5Sx9H+TvcO4i/QvyswfAzRM2dtSlDMnnDBIhy9M1VkL/My82qnu9der4ibWx+u4TtNLH0JpG6LLzW45wPXhzmnvL/BBTHBe5r8hJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790606027; c=relaxed/simple;
	bh=XC6HFt0tb5L+4UeZfQQh8FgYKXKhYcLG7uqzy72ksiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=B0VTm26C3802h0fERj4lQPIbA67mK035EomRFJOsmH4KCMHTS7ANznGnjkdbrUrikDuorCrZEU0IIw6KrMFEaXUFfinra66dWZjq7oT8eUh+hZXWrggZ8+UFbbsS2wh06ZQZ7SecmkUdlnu2IrzkzNvhx4cnx9W1UIWsAEk9slQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=lWq+advh; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="lWq+advh"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6C8081758;
	Mon, 28 Sep 2026 07:33:33 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6C3E23FA1F;
	Mon, 28 Sep 2026 07:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790606016; bh=XC6HFt0tb5L+4UeZfQQh8FgYKXKhYcLG7uqzy72ksiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lWq+advhQFekRwy7FBxnDjKQs/djOrGjau0cEcKqatmM1RNIeOUJwScuygLv4vaxK
	 sIWUmJm2wNVB1h8o12TS1XqQr6XOsfxDotxr8by30OptLsoo5yqSvnXODf2mN9yYwq
	 4CmkHJVNjsIooul3dnaJ1LKcNpugc1WUZvqX4I1I=
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
Subject: Re: [PATCH 17/22] KVM: arm64: Set Access flag on table descriptors at stage-1
Date: Mon, 28 Sep 2026 15:33:21 +0100
Message-ID: <arp6sUI422jJSaxB@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260623184201.1518871-18-oupton@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org> <20260623184201.1518871-18-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Jun 23, 2026 at 11:41:56AM -0700, Oliver Upton wrote:
> Implement access flag updates on table descriptors as required by
> FEAT_HAFT. Note that unlike leaf descriptors, access flags on table
> descriptors never generate a fault.
> 
> Signed-off-by: Oliver Upton <oupton@kernel.org>
> ---
> 
> Same comment as TCR_ELx.HD, will fix in v2.
> 
>  arch/arm64/include/asm/kvm_nested.h  |  1 +
>  arch/arm64/include/asm/kvm_pgtable.h | 11 +++++++++++
>  arch/arm64/kvm/at.c                  | 11 ++++++++++-
>  arch/arm64/kvm/hyp/pgtable.c         | 11 -----------
>  4 files changed, 22 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> index 1bb070328b1c..b52cf869333c 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -317,6 +317,7 @@ struct s1_walk_info {
>  	bool			pa52bit;
>  	bool			ha;
>  	bool			hd;
> +	bool			haft;
>  };
>  
>  struct s1_walk_result {
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 6ae36973686c..67601ed6370d 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -131,6 +131,17 @@ static inline bool kvm_pte_valid(kvm_pte_t pte)
>  	return pte & KVM_PTE_VALID;
>  }
>  
> +static inline bool kvm_pte_table(kvm_pte_t pte, s8 level)
> +{
> +	if (level == KVM_PGTABLE_LAST_LEVEL)
> +		return false;
> +
> +	if (!kvm_pte_valid(pte))
> +		return false;
> +
> +	return FIELD_GET(KVM_PTE_TYPE, pte) == KVM_PTE_TYPE_TABLE;
> +}
> +

Moved here for availability.

>  static inline u64 kvm_pte_to_phys(kvm_pte_t pte)
>  {
>  	u64 pa;
> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index 8d76eaf463c9..31a55b9d3385 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -416,6 +416,8 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
>  	wi->hd &= (wi->regime == TR_EL2 ?
>  		  FIELD_GET(TCR_EL2_HD, tcr) :
>  		  FIELD_GET(TCR_HD, tcr));
> +	wi->haft  = kvm_has_feat(vcpu->kvm, ID_AA64MMFR1_EL1, HAFDBS, HAFT) &&
> +		    FIELD_GET(TCR2_EL1_HAFT, effective_tcr2(vcpu, wi->regime));
>  
>  	return 0;
>  
> @@ -465,7 +467,7 @@ static bool should_set_access_flag(struct s1_walk_info *wi, struct s1_walk_step
>  	if (access->type == WALK_ACCESS_NONARCH)
>  		return false;
>  
> -	return wi->ha;
> +	return kvm_pte_table(ws->desc, ws->level) ? wi->haft : wi->ha;
>  }
>  

Right, adding support for tables' Access flag.


>  static bool should_set_dirty_state(struct s1_walk_info *wi, struct s1_walk_step *ws,
> @@ -473,6 +475,9 @@ static bool should_set_dirty_state(struct s1_walk_info *wi, struct s1_walk_step
>  {
>  	bool perm = wi->as_el0 ? wr->uw : wr->pw;
>  
> +	if (kvm_pte_table(ws->desc, ws->level))
> +		return false;
> +

Right, tables don't get dirty/writable.


>  	switch (access->type) {
>  	/* R_RKMHW */
>  	case WALK_ACCESS_CMO:
> @@ -620,6 +625,10 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
>  		if (ws.level == 3)
>  			break;
>  
> +		ret = handle_desc_update(vcpu, wi, &ws, wr, access);
> +		if (ret)
> +			return ret;
> +

And this is to update the table descriptor, IIUC.

If I got that right, then FWIW:
Reviewed-by: Leonardo Bras <leo.bras@arm.com>

Thanks!
Leo
