Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794248960;
	b=Fte2opDjj4L5F6mhycp8Tfq+LRQ+LaSKZCnCYyqdRfmlcLd+bHaLmeYA3B/21eznFCWk
	 m2Hm1vidnkcbwkbvvtT5nPxGE+9eaiBUpDMhDOq5bnk+R40MOBMq5GAh3vuAkAdJ0JvPV
	 B91DefLpYR7VXlRiARJhx7ePdhM79Jga+LnsUy2IBLbL2P7Su6HKJNrxuXaoHBHmzsO9o
	 MlJEO2kCR8qnbOoH2i2DHWGNnc0HR6LEigyETw2iWuW9QgPg2ME34YKIfToIl/wptCbX2
	 OhXQN7HDKSrbc0KbP7u0yuBBFDy81TR0ntrK0SbeeoeZyGIXMzEqqhZdlO+FqSy4smA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794248960;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=y8eN0GK435q2Un97OGxt5dXZuOb4TnOp5cvqQUFzdrw=;
	b=5Bk/YAUmGLllOGUYGmjgeGnbWtIpAWG1wjszW9lj2w2AMkcyfeFveMvo6x40M1flEteZ
	 +ZmWr9MiJZNHalLyt33jEeSOBG2mHIXi+s+3aV+i2O9v3iuX2qYBnPOyK5i6yzraSJ6mj
	 yWvMhATUOeKzxfYJac3WRak6jJpqMPY+tYJb+wMen15yxx8rY8gD15ZKUGHaDlZ0Fpbse
	 iqTvclHFJxBWYcDslN45b+2l6fVlF1rQCsfjGF9UfrH66E8ChwlREqQJfMfXykfHMcXSX
	 S9cubpEN9HdoBK7Nrg4aDreWC29z4s/GpyDti3EpzN+MF6eeTiyak5aR1OWf4+0Q7jQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=F9KUHFAH;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64AAF6070EC2
	for <kvmarm@lists.linux.dev>; Mon,  9 Nov 2026 18:29:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 64AAF6070EC2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=F9KUHFAH
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B1DD31477;
	Mon,  9 Nov 2026 10:29:15 -0800 (PST)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4B92B3F85F;
	Mon,  9 Nov 2026 10:29:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794248958; bh=KSMQYKux9BADIyFVBtSr2WXTaJK7hn9/8bZMU8uMW7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F9KUHFAHANH8Rol6erCBF6CRD7SOCJ4EX83mnPU23nJ8fx6CBvYXlrAQ9b+VQuLjZ
	 wN7BZHq0i+IjKWIAeIiGSQTbpj/SpeLYfo4CVDJFOhToVmaTVKgsS/iNMcruWiGs0V
	 Lt7ze26p1PnWUh9JzHZxpPeF7954HzqEG1OdOcS4=
From: Leonardo Bras <leo.bras@arm.com>
To: Tian Zheng <zhengtian10@huawei.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Marc Zyngier <maz@kernel.org>,
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
	liuyonglong <liuyonglong@huawei.com>,
	"tangchengchang@huawei.com" <tangchengchang@huawei.com>,
	Zhou Wang <wangzhou1@hisilicon.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/5] KVM: arm64: Add KVM_PGTABLE_PROT_DIRTY
Date: Mon,  9 Nov 2026 18:29:14 +0000
Message-ID: <avIQ-ZeVJWyETEb_@LeoBrasDK>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <1f27bca8-5277-457e-87a9-784e130e53a1@huawei.com>
References: <20260901171558.2674031-1-leo.bras@arm.com> <20260901171558.2674031-3-leo.bras@arm.com> <1f27bca8-5277-457e-87a9-784e130e53a1@huawei.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Nov 09, 2026 at 10:27:36AM +0800, Tian Zheng wrote:
> 
> 
> On 9/2/2026 1:15 AM, Leonardo Bras wrote:
> > Second step of changing the encoding for the Stage2 PTE descriptor,
> > introduce the concept of dirty page, so we can have a writable but not
> > dirty (WC) page, and a writable and dirty (WD) page.
> > 
> > In order to do so, evaluate uses in a per-case basis, and figure what
> > concept was important in each case (being dirty, or writable).
> > 
> > Signed-off-by: Leonardo Bras <leo.bras@arm.com>
> > ---
> >   arch/arm64/include/asm/kvm_pgtable.h |  9 ++++++---
> >   arch/arm64/kvm/hyp/pgtable.c         | 23 +++++++++++++++++------
> >   arch/arm64/kvm/mmu.c                 | 27 ++++++++++++++++-----------
> >   arch/arm64/kvm/ptdump.c              |  6 ++++++
> >   4 files changed, 45 insertions(+), 20 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index 37baa86d6fd8..379031c74cbc 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -258,45 +258,48 @@ enum kvm_pgtable_stage2_flags {
> >   	KVM_PGTABLE_S2_AS_S1			= BIT(1),
> >   };
> >   /**
> >    * enum kvm_pgtable_prot - Page-table permissions and attributes.
> >    * @KVM_PGTABLE_PROT_UX:	Unprivileged execute permission.
> >    * @KVM_PGTABLE_PROT_PX:	Privileged execute permission.
> >    * @KVM_PGTABLE_PROT_X:		Privileged and unprivileged execute permission.
> >    * @KVM_PGTABLE_PROT_W:		Write permission.
> >    * @KVM_PGTABLE_PROT_R:		Read permission.
> > + * @KVM_PGTABLE_PROT_DIRTY:	Dirty attribute.
> >    * @KVM_PGTABLE_PROT_DEVICE:	Device attributes.
> >    * @KVM_PGTABLE_PROT_NORMAL_NC:	Normal noncacheable attributes.
> >    * @KVM_PGTABLE_PROT_SW0:	Software bit 0.
> >    * @KVM_PGTABLE_PROT_SW1:	Software bit 1.
> >    * @KVM_PGTABLE_PROT_SW2:	Software bit 2.
> >    * @KVM_PGTABLE_PROT_SW3:	Software bit 3.
> >    */
> >   enum kvm_pgtable_prot {
> >   	KVM_PGTABLE_PROT_PX			= BIT(0),
> >   	KVM_PGTABLE_PROT_UX			= BIT(1),
> >   	KVM_PGTABLE_PROT_X			= KVM_PGTABLE_PROT_PX	|
> >   						  KVM_PGTABLE_PROT_UX,
> >   	KVM_PGTABLE_PROT_W			= BIT(2),
> >   	KVM_PGTABLE_PROT_R			= BIT(3),
> > +	KVM_PGTABLE_PROT_DIRTY			= BIT(4),
> > -	KVM_PGTABLE_PROT_DEVICE			= BIT(4),
> > -	KVM_PGTABLE_PROT_NORMAL_NC		= BIT(5),
> > +	KVM_PGTABLE_PROT_DEVICE			= BIT(5),
> > +	KVM_PGTABLE_PROT_NORMAL_NC		= BIT(6),
> >   	KVM_PGTABLE_PROT_SW0			= BIT(55),
> >   	KVM_PGTABLE_PROT_SW1			= BIT(56),
> >   	KVM_PGTABLE_PROT_SW2			= BIT(57),
> >   	KVM_PGTABLE_PROT_SW3			= BIT(58),
> >   };
> > -#define KVM_PGTABLE_PROT_RW	(KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W)
> > +#define KVM_PGTABLE_PROT_RW	(KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W | \
> > +				 KVM_PGTABLE_PROT_DIRTY)
> >   #define KVM_PGTABLE_PROT_RWX	(KVM_PGTABLE_PROT_RW | KVM_PGTABLE_PROT_X)
> >   #define PKVM_HOST_MEM_PROT	KVM_PGTABLE_PROT_RWX
> >   #define PKVM_HOST_MMIO_PROT	KVM_PGTABLE_PROT_RW
> >   #define PAGE_HYP		KVM_PGTABLE_PROT_RW
> >   #define PAGE_HYP_EXEC		(KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_X)
> >   #define PAGE_HYP_RO		(KVM_PGTABLE_PROT_R)
> >   #define PAGE_HYP_DEVICE		(PAGE_HYP | KVM_PGTABLE_PROT_DEVICE)
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index ca49f1bd7c34..2ff33d3e371e 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -724,22 +724,26 @@ static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot p
> >   		attr = KVM_S2_MEMATTR(pgt, NORMAL);
> >   	}
> >   	r = stage2_set_xn_attr(prot, &attr);
> >   	if (r)
> >   		return r;
> >   	if (prot & KVM_PGTABLE_PROT_R)
> >   		attr |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
> > -	if (prot & KVM_PGTABLE_PROT_W)
> > -		attr |= KVM_PTE_LEAF_ATTR_HI_S2_DBM | KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> > +	if (prot & KVM_PGTABLE_PROT_W) {
> > +		attr |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
> > +
> > +		if (prot & KVM_PGTABLE_PROT_DIRTY)
> > +			attr |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> > +	}
> >   	if (!kvm_lpa2_is_enabled())
> >   		attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S2_SH, sh);
> >   	attr |= KVM_PTE_LEAF_ATTR_LO_S2_AF;
> >   	attr |= prot & KVM_PTE_LEAF_ATTR_HI_SW;
> >   	*ptep = attr;
> >   	return 0;
> > @@ -747,23 +751,27 @@ static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot p
> >   enum kvm_pgtable_prot kvm_pgtable_stage2_pte_prot(kvm_pte_t pte)
> >   {
> >   	enum kvm_pgtable_prot prot = pte & KVM_PTE_LEAF_ATTR_HI_SW;
> >   	if (!kvm_pte_valid(pte))
> >   		return prot;
> >   	if (pte & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R)
> >   		prot |= KVM_PGTABLE_PROT_R;
> > -	if (pte & KVM_PTE_LEAF_ATTR_HI_S2_DBM)
> > +	if (pte & KVM_PTE_LEAF_ATTR_HI_S2_DBM) {
> >   		prot |= KVM_PGTABLE_PROT_W;
> > +		if (pte & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W)
> > +			prot |= KVM_PGTABLE_PROT_DIRTY;
> > +	}
> > +
> >   	switch (FIELD_GET(KVM_PTE_LEAF_ATTR_HI_S2_XN, pte)) {
> >   	case 0b00:
> >   		prot |= KVM_PGTABLE_PROT_PX | KVM_PGTABLE_PROT_UX;
> >   		break;
> >   	case 0b01:
> >   		prot |= KVM_PGTABLE_PROT_UX;
> >   		break;
> >   	case 0b11:
> >   		prot |= KVM_PGTABLE_PROT_PX;
> >   		break;
> > @@ -1282,21 +1290,20 @@ static int stage2_update_leaf_attrs(struct kvm_pgtable *pgt, u64 addr,
> >   		*orig_pte = data.pte;
> >   	if (level)
> >   		*level = data.level;
> >   	return 0;
> >   }
> >   int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
> >   {
> >   	return stage2_update_leaf_attrs(pgt, addr, size, 0,
> > -					KVM_PTE_LEAF_ATTR_HI_S2_DBM |
> >   					KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W,
> >   					NULL, NULL,
> >   					KVM_PGTABLE_WALK_IGNORE_EAGAIN);
> >   }
> >   void kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr,
> >   				enum kvm_pgtable_walk_flags flags)
> >   {
> >   	int ret;
> > @@ -1362,22 +1369,26 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
> >   	kvm_pte_t xn = 0, set = 0, clr = 0;
> >   	s8 level;
> >   	int ret;
> >   	if (prot & KVM_PTE_LEAF_ATTR_HI_SW)
> >   		return -EINVAL;
> >   	if (prot & KVM_PGTABLE_PROT_R)
> >   		set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
> > -	if (prot & KVM_PGTABLE_PROT_W)
> > -		set |= KVM_PTE_LEAF_ATTR_HI_S2_DBM | KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> > +	if (prot & KVM_PGTABLE_PROT_W) {
> > +		set |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
> > +
> > +		if (prot & KVM_PGTABLE_PROT_DIRTY)
> > +			set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> > +	}
> > 
> >   	if (prot & KVM_PGTABLE_PROT_X) {
> >   		ret = stage2_set_xn_attr(prot, &xn);
> >   		if (ret)
> >   			return ret;
> >   		set |= xn & KVM_PTE_LEAF_ATTR_HI_S2_XN;
> >   		clr |= ~xn & KVM_PTE_LEAF_ATTR_HI_S2_XN;
> >   	}
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 9ba86450fe4a..9d4f70430bbe 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1205,21 +1205,23 @@ int topup_hyp_memcache(struct kvm_hyp_memcache *mc, unsigned long min_pages)
> >   int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
> >   			  phys_addr_t pa, unsigned long size, bool writable)
> >   {
> >   	phys_addr_t addr;
> >   	int ret = 0;
> >   	struct kvm_mmu_memory_cache cache = { .gfp_zero = __GFP_ZERO };
> >   	struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
> >   	struct kvm_pgtable *pgt = mmu->pgt;
> >   	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_DEVICE |
> >   				     KVM_PGTABLE_PROT_R |
> > -				     (writable ? KVM_PGTABLE_PROT_W : 0);
> > +				     (writable ?
> > +				      (KVM_PGTABLE_PROT_W | KVM_PGTABLE_PROT_DIRTY) :
> > +				      0);
> >   	if (is_protected_kvm_enabled())
> >   		return -EPERM;
> >   	size += offset_in_page(guest_ipa);
> >   	guest_ipa &= PAGE_MASK;
> >   	for (addr = guest_ipa; addr < guest_ipa + size; addr += PAGE_SIZE) {
> >   		ret = kvm_mmu_topup_memory_cache(&cache,
> >   						 kvm_mmu_cache_min_pages(mmu));
> > @@ -1571,21 +1573,21 @@ static int topup_mmu_memcache(struct kvm_vcpu *vcpu, void *memcache)
> >    *
> >    * Also encode the level of the original translation in the SW bits of the leaf
> >    * entry as a proxy for the span of that translation. This will be retrieved on
> >    * TLB invalidation from the guest and used to limit the invalidation scope if a
> >    * TTL hint or a range isn't provided.
> >    */
> >   static enum kvm_pgtable_prot adjust_nested_fault_perms(struct kvm_s2_trans *nested,
> >   						       enum kvm_pgtable_prot prot)
> >   {
> >   	if (!kvm_s2_trans_writable(nested))
> > -		prot &= ~KVM_PGTABLE_PROT_W;
> > +		prot &= ~(KVM_PGTABLE_PROT_W | KVM_PGTABLE_PROT_DIRTY);
> >   	if (!kvm_s2_trans_readable(nested))
> >   		prot &= ~KVM_PGTABLE_PROT_R;
> >   	return prot | kvm_encode_nested_level(nested);
> >   }
> >   static enum kvm_pgtable_prot adjust_nested_exec_perms(struct kvm *kvm,
> >   						      struct kvm_s2_trans *nested,
> >   						      enum kvm_pgtable_prot prot)
> >   {
> > @@ -1642,21 +1644,21 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
> >   	smp_rmb();
> >   	ret = kvm_gmem_get_pfn(kvm, s2fd->memslot, gfn, &pfn, &page, NULL);
> >   	if (ret) {
> >   		kvm_prepare_memory_fault_exit(s2fd->vcpu, s2fd->fault_ipa, PAGE_SIZE,
> >   					      write_fault, exec_fault, false);
> >   		return ret;
> >   	}
> >   	if (!(s2fd->memslot->flags & KVM_MEM_READONLY))
> > -		prot |= KVM_PGTABLE_PROT_W;
> > +		prot |= KVM_PGTABLE_PROT_W | KVM_PGTABLE_PROT_DIRTY;
> >   	if (s2fd->nested)
> >   		prot = adjust_nested_fault_perms(s2fd->nested, prot);
> >   	if (exec_fault || cpus_have_final_cap(ARM64_HAS_CACHE_DIC))
> >   		prot |= KVM_PGTABLE_PROT_X;
> >   	if (s2fd->nested)
> >   		prot = adjust_nested_exec_perms(kvm, s2fd->nested, prot);
> > @@ -1674,24 +1676,24 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
> >   		prot &= ~KVM_NV_GUEST_MAP_SZ;
> >   		ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, s2fd->fault_ipa,
> >   								 prot, flags);
> >   	} else {
> >   		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, s2fd->fault_ipa, PAGE_SIZE,
> >   							 __pfn_to_phys(pfn), prot,
> >   							 memcache, flags);
> >   	}
> >   out_unlock:
> > -	kvm_release_faultin_page(kvm, page, !!ret, prot & KVM_PGTABLE_PROT_W);
> > +	kvm_release_faultin_page(kvm, page, !!ret, prot & KVM_PGTABLE_PROT_DIRTY);
> >   	kvm_fault_unlock(kvm);
> > -	if ((prot & KVM_PGTABLE_PROT_W) && !ret)
> > +	if ((prot & KVM_PGTABLE_PROT_DIRTY) && !ret)
> >   		mark_page_dirty_in_slot(kvm, s2fd->memslot, gfn);
> >   	return ret != -EAGAIN ? ret : 0;
> >   }
> >   struct kvm_s2_fault_vma_info {
> >   	unsigned long	mmu_seq;
> >   	long		vma_pagesize;
> >   	vm_flags_t	vm_flags;
> >   	unsigned long	max_map_size;
> > @@ -1977,25 +1979,28 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
> >   	 * and trigger the exception here. Since the memslot is valid, inject
> >   	 * the fault back to the guest.
> >   	 */
> >   	if (esr_fsc_is_excl_atomic_fault(kvm_vcpu_get_esr(s2fd->vcpu))) {
> >   		kvm_inject_dabt_excl_atomic(s2fd->vcpu, kvm_vcpu_get_hfar(s2fd->vcpu));
> >   		return 1;
> >   	}
> >   	*prot = KVM_PGTABLE_PROT_R;
> > -	if (s2vi->map_writable && (s2vi->device ||
> > -				   !memslot_is_logging(s2fd->memslot) ||
> > -				   kvm_is_write_fault(s2fd->vcpu)))
> > +	if (s2vi->map_writable) {
> >   		*prot |= KVM_PGTABLE_PROT_W;
> > +		if (s2vi->device || !memslot_is_logging(s2fd->memslot) ||
> > +		    kvm_is_write_fault(s2fd->vcpu))
> > +			*prot |= KVM_PGTABLE_PROT_DIRTY;
> > +	}
> > +
> 
> 
> Hi Leo,
> 
> After reviewing this patch again, I found an issue with the current
> scheme: for a read fault in a logging memslot, we deliberately install
> the page writable-clean so hardware can promote it later. That breaks
> MAP_PRIVATE (COW) memory, which requires a write fault -> FOLL_WRITE ->
> host COW copy, so a read fault must map RO. Otherwise the guest's later
> write no longer faults and COW is skipped.
> 
> In our sandbox tests, the re-fault storm caused concurrent_resume to
> trigger about 1.57x more faults (784K vs 500K) and about 8x longer wall
> time (~688ms vs 85ms).
> 
> To fix it, we should restore the writable gate:
> 
> ```c
> if (s2vi->map_writable && (s2vi->device ||
>                            !memslot_is_logging(s2fd->memslot) ||
>                            kvm_is_write_fault(s2fd->vcpu))) {
> 	*prot |= KVM_PGTABLE_PROT_W;
> 
> 	if (... keep DIRTY logic ...)
> 		*prot |= KVM_PGTABLE_PROT_DIRTY;
> }
> ```
> 
> Read faults in a logging memslot stay RO; only the first write fault
> installs writable, so COW breaks normally.
> 
> What do you think?

The page has to be !dirty at S2 on a read at dirty_tracking, so we don't 
miss a write. That being said,we can have a read-only (or WC) S2 mapping on 
a writable host page.

So on this scenario of marking a page WC on a read fault while 
dirty-tracking, we can just mark the host page writable.

What do you think?

(Also, keep in mind a lot of this will change with the next versions of the 
PTE encoding patchset, maybe we should worry on refactoring that later)


Thanks!
Leo
