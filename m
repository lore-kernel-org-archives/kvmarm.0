Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEAB54A093F
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 13:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789998388; cv=none; b=CxIVevnZS8VcmLL58PKenr+MwFrpSJZZqMP/Cs7QNvE8ti5eaNj8KKP4jDLvDfxXE6lfjJ2feq2DAzLxg2ItBFgJ7mzTWiIHrKww7eSwGBfcKPjjadsbldKo7HxuWy20ayvARse+WD5OxuQ5t2ldpD9/t86AIazN2fKa1/IDvmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789998388; c=relaxed/simple;
	bh=wMdzK8rFj97jPE2w31SymkCoy9SINsDjqzF9PxMDqWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=Ljjld7m++t2UA2a4VXOzCoSIQMXK7FxTCE6XqJLhcWVWSdUoU13Dh9aHUrt5A8LJWB5vev+AtC2YBhwes22xtOxTHlj2VeACqQ5dbMZ0S14mdiq+qyJAaTex+tknuFs7s2g4KEpxpArtIFPe2Wji/vSKlzkCizWjbsBZpUSCNpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WoUL8L7v; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WoUL8L7v"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EB06219F6;
	Mon, 21 Sep 2026 06:46:21 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0E46E3F528;
	Mon, 21 Sep 2026 06:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789998385; bh=wMdzK8rFj97jPE2w31SymkCoy9SINsDjqzF9PxMDqWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WoUL8L7vnzhiuBxrGEaJyv0g+JZEptUbs7iPmzkY1SU08KcheC70/c/YzFCZcwIbU
	 DehGaLgqHTgbANblo6lKY+gBSXs9WEitlP1RjXlpH7vPHDj+vwWH+ANFxmD4hIi7u5
	 3A+eNuRYvwlWaEVpFM9RD7vb2cfjzygvnw19nMYU=
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
Subject: Re: [PATCH 02/22] KVM: arm64: nv: Consolidate computation of stage-2 permissions
Date: Mon, 21 Sep 2026 14:46:17 +0100
Message-ID: <arE1KVBNtkEWJDvN@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260623184201.1518871-3-oupton@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org> <20260623184201.1518871-3-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Jun 23, 2026 at 11:41:41AM -0700, Oliver Upton wrote:
> Computing the output permissions from a translation requires
> contextualization, as fields in the descriptors may change depending on
> the MMU context. Centralize the computation of stage-2 permissions
> within the table walk rather as opposed to inspecting the descriptor in
> the case of pX and uX permissions.
> 
> Signed-off-by: Oliver Upton <oupton@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_nested.h  | 42 ++++++++--------------------
>  arch/arm64/include/asm/kvm_pgtable.h |  5 ++--
>  arch/arm64/kvm/nested.c              | 33 ++++++++++++++++++++--
>  3 files changed, 45 insertions(+), 35 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> index cbdaaa2a2903..aa27f12cf2d4 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -87,13 +87,15 @@ extern void kvm_nested_sync_hwstate(struct kvm_vcpu *vcpu);
>  extern void kvm_nested_setup_mdcr_el2(struct kvm_vcpu *vcpu);
>  
>  struct kvm_s2_trans {
> -	phys_addr_t output;
> -	unsigned long block_size;
> -	bool writable;
> -	bool readable;
> -	int level;
> -	u32 esr;
> -	u64 desc;
> +	u64		desc;
> +	phys_addr_t	output;
> +	unsigned long	block_size;
> +	int		level;
> +	u32		esr;
> +	bool		writable;
> +	bool		readable;
> +	bool		px;
> +	bool		ux;
>  };
>  
>  static inline phys_addr_t kvm_s2_trans_output(struct kvm_s2_trans *trans)
> @@ -129,34 +131,12 @@ static inline bool kvm_has_xnx(struct kvm *kvm)
>  
>  static inline bool kvm_s2_trans_exec_el0(struct kvm *kvm, struct kvm_s2_trans *trans)
>  {
> -	u8 xn = FIELD_GET(KVM_PTE_LEAF_ATTR_HI_S2_XN, trans->desc);
> -
> -	if (!kvm_has_xnx(kvm))
> -		xn &= FIELD_PREP(KVM_PTE_LEAF_ATTR_HI_S2_XN, 0b10);
> -
> -	switch (xn) {
> -	case 0b00:
> -	case 0b01:
> -		return true;
> -	default:
> -		return false;
> -	}
> +	return trans->ux;
>  }
>  
>  static inline bool kvm_s2_trans_exec_el1(struct kvm *kvm, struct kvm_s2_trans *trans)
>  {
> -	u8 xn = FIELD_GET(KVM_PTE_LEAF_ATTR_HI_S2_XN, trans->desc);
> -
> -	if (!kvm_has_xnx(kvm))
> -		xn &= FIELD_PREP(KVM_PTE_LEAF_ATTR_HI_S2_XN, 0b10);
> -
> -	switch (xn) {
> -	case 0b00:
> -	case 0b11:
> -		return true;
> -	default:
> -		return false;
> -	}
> +	return trans->px;
>  }
>  
>  extern int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 41a8687938eb..22aeb2ed18d1 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -79,6 +79,8 @@ typedef u64 kvm_pte_t;
>  #define KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR	GENMASK(5, 2)
>  #define KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R	BIT(6)
>  #define KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W	BIT(7)
> +#define KVM_PTE_LEAF_ATTR_LO_S2_S2AP	(KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R |	\
> +					 KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W)
>  #define KVM_PTE_LEAF_ATTR_LO_S2_SH	GENMASK(9, 8)
>  #define KVM_PTE_LEAF_ATTR_LO_S2_SH_IS	3
>  #define KVM_PTE_LEAF_ATTR_LO_S2_AF	BIT(10)
> @@ -95,8 +97,7 @@ typedef u64 kvm_pte_t;
>  
>  #define KVM_PTE_LEAF_ATTR_HI_S1_GP	BIT(50)
>  
> -#define KVM_PTE_LEAF_ATTR_S2_PERMS	(KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | \
> -					 KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | \
> +#define KVM_PTE_LEAF_ATTR_S2_PERMS	(KVM_PTE_LEAF_ATTR_LO_S2_S2AP |	\
>  					 KVM_PTE_LEAF_ATTR_HI_S2_XN)
>  
>  /* pKVM invalid pte encodings */
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 9e60c7c822ae..c9300703bd0d 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -241,6 +241,36 @@ static int swap_guest_s2_desc(struct kvm_vcpu *vcpu, phys_addr_t pa, u64 old, u6
>  	return __kvm_qat_swap_desc(vcpu->kvm, pa, old, new);
>  }
>  
> +static void compute_s2_permissions(struct kvm_vcpu *vcpu, struct s2_walk_info *wi,
> +				   struct s2_walk_step *ws, struct kvm_s2_trans *trans)
> +{
> +	u8 s2ap = FIELD_GET(KVM_PTE_LEAF_ATTR_LO_S2_S2AP, ws->desc);
> +	u8 xn = FIELD_GET(KVM_PTE_LEAF_ATTR_HI_S2_XN, ws->desc);
> +
> +	if (!kvm_has_xnx(vcpu->kvm))
> +		xn &= 0b10;
> +
> +	switch (xn) {
> +	case 0b00:
> +		trans->px = trans->ux = true;
> +		break;
> +	case 0b01:
> +		trans->px = false;
> +		trans->ux = true;
> +		break;
> +	case 0b10:
> +		trans->px = trans->ux = false;
> +		break;
> +	case 0b11:
> +		trans->px = true;
> +		trans->ux = false;
> +		break;
> +	}
> +

Nit: couldn't the above be summarized as below?

	trans->ux = !(xn & BIT(1));

	if (kvm_has_xnx(vcpu->kvm) && xn & BIT(0)) 
		trans->px = !trans->ux;
	else
		trans->px = trans->ux;
					

or maybe even skip the FIELD_GET and do:

	trans->ux = !(ws->desc & KVM_PTE_LEAF_ATTR_HI_S1_UXN);

	if (kvm_has_xnx(vcpu->kvm) &&
	    ws->desc & KVM_PTE_LEAF_ATTR_HI_S1_PXN) 
		trans->px = !trans->ux;
	else
		trans->px = trans->ux;


Maybe it's just me, but that looks easier to understand what each bit does 
based on the feature.

In any case, LGTM.

FWIW:
Reviewed-by: Leonardo Bras <leo.bras@arm.com>

Thanks!
Leo
