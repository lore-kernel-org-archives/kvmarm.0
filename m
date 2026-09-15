Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EF83438473
	for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 17:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789492388; cv=none; b=o0DcA1DFL9T2rIMJ8bphK7fWyuu668Y9PiTla4qKxWu9olY2M3zNiWIQ0ckQnvojQynccHz+OEcyiay+YcAHqaYvK9Gn3jhX7NtAGAh5dT47rSE7JEPtBAg/izhcSqrspfDCiSE8DjL4JEjhN/zB/MS36+5Jtlotsz6qBPo+qb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789492388; c=relaxed/simple;
	bh=BMNCXnidTpeka8q3dT25YVOhSkz2hWst7Qm/Kj9ribs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=BL/WlJPtQozEhQ2/rj2dBT9fAIZhxeWQhFbyOrWYPIEsaz5VhlC0Et7sMKxZrMWMBYYDJFRc9wNf2+WTquyYGPAe7SNzlSXRnllRKsrgU2JZEl1P8j04tHibYGA762IuZK5xMDrS0LtXraBGWg1sFrVIYcRIOlgK+KY1yJ/ARa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=BaZcsrcJ; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="BaZcsrcJ"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 82299153B;
	Tue, 15 Sep 2026 10:13:01 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (unknown [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C33153F7B4;
	Tue, 15 Sep 2026 10:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789492385; bh=BMNCXnidTpeka8q3dT25YVOhSkz2hWst7Qm/Kj9ribs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BaZcsrcJl8hj8fmRPiJ9+La/vWcCUfRrkIxk4Zi17F1nfELXkn/kheNdmgqLFVB8J
	 hvAlQqh+ydjHWspW+I1AKGaJIxuVRlXDzm1wDUrR9lCsci3sot2UVuBKnMwkz2EQLq
	 8xe/aA1A6Fbit9xN8bvOAnZTE+WSoFurx+0OIpqg=
From: Leonardo Bras <leo.bras@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Tian Zheng <zhengtian10@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/5] KVM: arm64: pgtables: Change write bit from S2AP_W to DBM
Date: Tue, 15 Sep 2026 18:12:45 +0100
Message-ID: <aql8jY4o8SzjJuFU@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <86bja17cg7.wl-maz@kernel.org>
References: <20260901171558.2674031-1-leo.bras@arm.com> <20260901171558.2674031-2-leo.bras@arm.com> <86bja17cg7.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Sun, Sep 13, 2026 at 10:00:40AM +0100, Marc Zyngier wrote:
> On Tue, 01 Sep 2026 18:15:52 +0100,
> Leonardo Bras <leo.bras@arm.com> wrote:
> > 
> > As a first step of changing the encoding for the Stage2 PTE descriptor,
> > introduce the DBM bit, and adapt every usage of writable to use the DBM bit
> > (51) instead of S2AP[1]/Dirty bit (7).
> > 
> > For this step, we convert usages of RW(Dirty) -> WD(DBM|Dirty).
> > 
> > Signed-off-by: Leonardo Bras <leo.bras@arm.com>
> > ---
> >  arch/arm64/include/asm/kvm_pgtable.h | 3 +++
> >  arch/arm64/kvm/hyp/pgtable.c         | 8 +++++---
> >  arch/arm64/kvm/nested.c              | 4 +++-
> >  arch/arm64/kvm/ptdump.c              | 4 ++--
> >  4 files changed, 13 insertions(+), 6 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index 41a8687938eb..37baa86d6fd8 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -86,24 +86,27 @@ typedef u64 kvm_pte_t;
> >  #define KVM_PTE_LEAF_ATTR_HI		GENMASK(63, 50)
> >  
> >  #define KVM_PTE_LEAF_ATTR_HI_SW		GENMASK(58, 55)
> >  
> >  #define KVM_PTE_LEAF_ATTR_HI_S1_XN	BIT(54)
> >  #define KVM_PTE_LEAF_ATTR_HI_S1_UXN	BIT(54)
> >  #define KVM_PTE_LEAF_ATTR_HI_S1_PXN	BIT(53)
> >  
> >  #define KVM_PTE_LEAF_ATTR_HI_S2_XN	GENMASK(54, 53)
> >  
> > +#define KVM_PTE_LEAF_ATTR_HI_S2_DBM	BIT(51)
> > +
> >  #define KVM_PTE_LEAF_ATTR_HI_S1_GP	BIT(50)
> >  
> >  #define KVM_PTE_LEAF_ATTR_S2_PERMS	(KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | \
> >  					 KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | \
> > +					 KVM_PTE_LEAF_ATTR_HI_S2_DBM | \
> >  					 KVM_PTE_LEAF_ATTR_HI_S2_XN)
> >  
> >  /* pKVM invalid pte encodings */
> >  #define KVM_INVALID_PTE_TYPE_MASK	GENMASK(63, 60)
> >  #define KVM_INVALID_PTE_ANNOT_MASK	~(KVM_PTE_VALID | \
> >  					  KVM_INVALID_PTE_TYPE_MASK)
> >  
> >  enum kvm_invalid_pte_type {
> >  	/*
> >  	 * Used to indicate a pte for which a 'break-before-make'
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index b74dd5ce1efd..ca49f1bd7c34 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -725,42 +725,43 @@ static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot p
> >  	}
> >  
> >  	r = stage2_set_xn_attr(prot, &attr);
> >  	if (r)
> >  		return r;
> >  
> >  	if (prot & KVM_PGTABLE_PROT_R)
> >  		attr |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
> >  
> >  	if (prot & KVM_PGTABLE_PROT_W)
> > -		attr |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> > +		attr |= KVM_PTE_LEAF_ATTR_HI_S2_DBM | KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> 
> What makes it acceptable to always set DBM? This is an optional
> feature, and I'm not exactly comfortable setting bits that are
> supposed to be RES0. 

The alternative would be to introduce WC/WD as an alternative encoding
infrastructure, and keep making decisions based on having HAFDBS available 
or in the system. My intention was to adapt things in a way to avoid 
multiple behaviors if we could avoid.

My rationale is, based on our possibility of setting DBM=1:
If HAFDBS/HDBSS/HACDBS are not available, or available but disabled, 
then the DBM bit is just ignored:
RO -> RO
WC -> RO
WD -> RW

(for reference:
- Read-Only (RO):      DBM=0, S2AP[1]=0
- Writable-Clean (WC): DBM=1, S2AP[1]=0
- Writable-Dirty (WD): DBM=1, S2AP[1]=1
)

And the behavior should just the same as what we have today.


> Yes, the HW should ignore it. But we have also
> seen quite a few broken designs in this area...
> 

I lack experience on what bad thing could happen. So I will expand on what 
I belive to understand up to here:

- The PTE is in memory, so the DBM bit can be set regardless of being RES0
- For SW pagetable walking, I don't think 'bit 51 == 0' is checked
- For HW pagetable walking, maybe some faulty implementation may rely on 
  bit51 being RES0, and fault otherwise.

If that's the case, then we would have to actually support both encodings, 
and only enable the new one if HAFDBS is available in the system. 

I just wonder how high are the chances to have such a broken design, 
or other broken designs did not come to my mind, and if we have to start 
with that multiple-encoding option.

> > +
> >
> 
> Spurious newline.
> 

Oh, ok, will get rid of it.

> >  	if (!kvm_lpa2_is_enabled())
> >  		attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S2_SH, sh);
> >  
> >  	attr |= KVM_PTE_LEAF_ATTR_LO_S2_AF;
> >  	attr |= prot & KVM_PTE_LEAF_ATTR_HI_SW;
> >  	*ptep = attr;
> >  
> >  	return 0;
> >  }
> 
> I don't know how you have configured git on your end, but there is *a
> lot* of context...
> 

diff.context=10, i.e. 10 lines before and after a change.
To me it looks helpful to get more context around the change. 

I can change it back to 5 if it bothers you.

> >  
> >  enum kvm_pgtable_prot kvm_pgtable_stage2_pte_prot(kvm_pte_t pte)
> >  {
> >  	enum kvm_pgtable_prot prot = pte & KVM_PTE_LEAF_ATTR_HI_SW;
> >  
> >  	if (!kvm_pte_valid(pte))
> >  		return prot;
> >  
> >  	if (pte & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R)
> >  		prot |= KVM_PGTABLE_PROT_R;
> > -	if (pte & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W)
> > +	if (pte & KVM_PTE_LEAF_ATTR_HI_S2_DBM)
> >  		prot |= KVM_PGTABLE_PROT_W;
> >  
> >  	switch (FIELD_GET(KVM_PTE_LEAF_ATTR_HI_S2_XN, pte)) {
> >  	case 0b00:
> >  		prot |= KVM_PGTABLE_PROT_PX | KVM_PGTABLE_PROT_UX;
> >  		break;
> >  	case 0b01:
> >  		prot |= KVM_PGTABLE_PROT_UX;
> >  		break;
> >  	case 0b11:
> > @@ -1281,20 +1282,21 @@ static int stage2_update_leaf_attrs(struct kvm_pgtable *pgt, u64 addr,
> >  		*orig_pte = data.pte;
> >  
> >  	if (level)
> >  		*level = data.level;
> >  	return 0;
> >  }
> >  
> >  int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
> >  {
> >  	return stage2_update_leaf_attrs(pgt, addr, size, 0,
> > +					KVM_PTE_LEAF_ATTR_HI_S2_DBM |
> >  					KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W,
> >  					NULL, NULL,
> >  					KVM_PGTABLE_WALK_IGNORE_EAGAIN);
> >  }
> >  
> >  void kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr,
> >  				enum kvm_pgtable_walk_flags flags)
> >  {
> >  	int ret;
> >  
> > @@ -1361,21 +1363,21 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
> >  	s8 level;
> >  	int ret;
> >  
> >  	if (prot & KVM_PTE_LEAF_ATTR_HI_SW)
> >  		return -EINVAL;
> >  
> >  	if (prot & KVM_PGTABLE_PROT_R)
> >  		set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
> >  
> >  	if (prot & KVM_PGTABLE_PROT_W)
> > -		set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> > +		set |= KVM_PTE_LEAF_ATTR_HI_S2_DBM | KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> >  
> >  	if (prot & KVM_PGTABLE_PROT_X) {
> >  		ret = stage2_set_xn_attr(prot, &xn);
> >  		if (ret)
> >  			return ret;
> >  
> >  		set |= xn & KVM_PTE_LEAF_ATTR_HI_S2_XN;
> >  		clr |= ~xn & KVM_PTE_LEAF_ATTR_HI_S2_XN;
> >  	}
> >  
> > diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> > index 17123f0b6dab..eb8dfffc32c7 100644
> > --- a/arch/arm64/kvm/nested.c
> > +++ b/arch/arm64/kvm/nested.c
> > @@ -379,21 +379,23 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, phys_addr_t ipa,
> >  	}
> >  
> >  	addr_bottom += contiguous_bit_shift(desc, wi, level);
> >  
> >  	/* Calculate and return the result */
> >  	paddr = (desc & GENMASK_ULL(47, addr_bottom)) |
> >  		(ipa & GENMASK_ULL(addr_bottom - 1, 0));
> >  	out->output = paddr;
> >  	out->block_size = 1UL << ((3 - level) * stride + wi->pgshift);
> >  	out->readable = desc & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
> > -	out->writable = desc & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> > +	/* Takes care of both RO/RW and RO/WC/WD encodings */
> > +	out->writable = desc & (KVM_PTE_LEAF_ATTR_HI_S2_DBM |
> > +				KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W);
> 
> Absolutely NOT. For a start, NV doesn't support FEAT_HAFDBS. But even
> if it did, you are now actively corrupting memory by turning a RO
> mapping with a spurious DBM bit set into a writable mapping.
> VTCR_EL2.HD exists for a reason.
> 
> Do you see why your blanket approach of equating DBM with writable is
> plain wrong?

Sorry, not really... please help me understand it.

When you say a spurious DBM bit, what does it mean?

All I can think is something like a buggy HW implementation setting DBM in 
a HAFDBS-disabled machine, which has been unnoticed up to now, and now 
could cause problems. 

If that's what you mean, then yes, that would be a problem. But that would 
also violate the architecture, and become a errata, right?

On DBM=writable, that's basically what the Arm ARM says now:

R_LRMSH
For the purpose of FEAT_HAFDBS dirty state management, a Block descriptor 
or Page descriptor can be described as having one of the following states:
    Non-writable.
    Writable-clean.
    Writable-dirty.

R_XSTDV

    If a Block descriptor or Page descriptor is not writable-clean and not 
    writable-dirty, then it is described as non-writable.

And since both RBRFGY and RXZFQH define Writable-Clean and Writable-Dirty 
as seting DBM=1, Writable <=> DBM=1


I am _not_ trying to say I am right here, as I really value your experience 
over whatever I could understand of the documentation, I am honestly 
confused right now on what I have done wrong.

Thanks for your patience, 
Leo
