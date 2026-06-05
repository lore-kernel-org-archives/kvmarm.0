Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83EFF3B8119;
	Fri,  5 Jun 2026 14:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780670146; cv=none; b=eJJnMj1apYLbak+PXbI9RqIlsUMYTpQGJxRHS3k7pEyOoqzABT3QaWkHVPSGcPmIy7NX5BxFcqcsdAk8dyjqlBPGymUwAxq7yesbLupjmPc1D3dL1PNAyBo6ZYThMpXZfEPc0YobTwMdT0Ua7cWS2HHvJwf2dlzlSvXZssqV1K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780670146; c=relaxed/simple;
	bh=RpqLn+mo0fdihzWHI1yaYLEVweRCF0fZT2hScv0UAAA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rdc/V4fQhTu7Y94awDXptW44X1bYb9cKs9cbONo0pDYFT9AnA6lwLWu/zhzTcvORC0oW9bJuoliagYh3fK29plUhCc3g5aG6yemCduyaiuVAJdc6vu9j448sT/N8KrKS9NzHpa+H03a41Gy7JQNTuB1XFlMUMdw/RY8kLix6Usk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ee8SzohD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ee8SzohD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F25BF1F00893;
	Fri,  5 Jun 2026 14:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780670139;
	bh=yEx3jn8EH2nUkiUH0oQQoZUXhkR9d/gANYk1jIgt7bc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ee8SzohDxWGVNrqYsDDg3u4sezSziVxoHrPN31J7HSiTNHyitOKLaBjUZ4BvZS6cI
	 xuOWZvadYfYHEq6uB4zC0B12cGfSv0ECqDSkpEAud9OvCTIEFDfRQaTalIXyX/1TOq
	 2d/EZ+8v3tsCJRLzLYap5cVZxtrCikdpUDueNkUbi67BExP+ceH4ApCG3waSzQZmZj
	 zXljrOPQOu9RK+RLG7AfxNg9H3DSnW1i5A46B7o740y8M8bCZ3ucy3usk8Ehbld7SB
	 4Q/PzdsiZ/qMLaOCUM3Gj99GcnxpXu90BKp84F391xNET1k1TJzV2HWBNLoHUWgudm
	 EVKP/b+OS3u3Q==
Date: Fri, 5 Jun 2026 16:35:31 +0200
From: Lorenzo Pieralisi <lpieralisi@kernel.org>
To: Gavin Shan <gshan@redhat.com>
Cc: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
	Lorenzo.Pieralisi2@arm.com
Subject: Re: [PATCH v14 29/44] arm64: RMI: Runtime faulting of memory
Message-ID: <aiLes2ecZSr17UwZ@lpieralisi>
References: <20260513131757.116630-1-steven.price@arm.com>
 <20260513131757.116630-30-steven.price@arm.com>
 <3359f788-07fa-41a1-9ac7-45c58577c1fa@redhat.com>
 <aiJ6u83O0nVUtPyv@lpieralisi>
 <ecef952b-e8c6-4102-933b-c99c46f14431@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ecef952b-e8c6-4102-933b-c99c46f14431@redhat.com>

On Fri, Jun 05, 2026 at 06:11:11PM +1000, Gavin Shan wrote:
> On 6/5/26 5:28 PM, Lorenzo Pieralisi wrote:
> > On Fri, Jun 05, 2026 at 04:23:15PM +1000, Gavin Shan wrote:
> > 
> > [...]
> > 
> > > > +static int realm_map_ipa(struct kvm *kvm, phys_addr_t ipa,
> > > > +			 kvm_pfn_t pfn, unsigned long map_size,
> > > > +			 enum kvm_pgtable_prot prot,
> > > > +			 struct kvm_mmu_memory_cache *memcache)
> > > > +{
> > > > +	struct realm *realm = &kvm->arch.realm;
> > > > +
> > > > +	/*
> > > > +	 * Write permission is required for now even though it's possible to
> > > > +	 * map unprotected pages (granules) as read-only. It's impossible to
> > > > +	 * map protected pages (granules) as read-only.
> > > > +	 */
> > > > +	if (WARN_ON(!(prot & KVM_PGTABLE_PROT_W)))
> > > > +		return -EFAULT;
> > > > +
> > > 
> > > I'm a bit concerned with this. We don't have KVM_PGTABLE_PROT_W set in @prot
> > > if the stage2 fault is raised due to memory read. With -EFAULT returned to VMM
> > > (e.g. QEMU), the vCPU continuous execution is stopped and system won't be
> > > working any more.
> > > 
> > > > +	ipa = ALIGN_DOWN(ipa, PAGE_SIZE);
> > > > +	if (!kvm_realm_is_private_address(realm, ipa))
> > > > +		return realm_map_non_secure(realm, ipa, pfn, map_size, prot,
> > > > +					    memcache);
> > > > +
> > > > +	return realm_map_protected(kvm, ipa, pfn, map_size, memcache);
> > > > +}
> > > > +
> > > >    static bool kvm_vma_is_cacheable(struct vm_area_struct *vma)
> > > >    {
> > > >    	switch (FIELD_GET(PTE_ATTRINDX_MASK, pgprot_val(vma->vm_page_prot))) {
> > > > @@ -1604,27 +1641,52 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
> > > >    	bool write_fault, exec_fault;
> > > >    	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
> > > >    	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
> > > > -	struct kvm_pgtable *pgt = s2fd->vcpu->arch.hw_mmu->pgt;
> > > > +	struct kvm_vcpu *vcpu = s2fd->vcpu;
> > > > +	struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
> > > > +	gpa_t gpa = kvm_gpa_from_fault(vcpu->kvm, s2fd->fault_ipa);
> > > >    	unsigned long mmu_seq;
> > > >    	struct page *page;
> > > > -	struct kvm *kvm = s2fd->vcpu->kvm;
> > > > +	struct kvm *kvm = vcpu->kvm;
> > > >    	void *memcache;
> > > >    	kvm_pfn_t pfn;
> > > >    	gfn_t gfn;
> > > >    	int ret;
> > > > -	memcache = get_mmu_memcache(s2fd->vcpu);
> > > > -	ret = topup_mmu_memcache(s2fd->vcpu, memcache);
> > > > +	if (kvm_is_realm(vcpu->kvm)) {
> > > > +		/* check for memory attribute mismatch */
> > > > +		bool is_priv_gfn = kvm_mem_is_private(kvm, gpa >> PAGE_SHIFT);
> > > > +		/*
> > > > +		 * For Realms, the shared address is an alias of the private
> > > > +		 * PA with the top bit set. Thus if the fault address matches
> > > > +		 * the GPA then it is the private alias.
> > > > +		 */
> > > > +		bool is_priv_fault = (gpa == s2fd->fault_ipa);
> > > > +
> > > > +		if (is_priv_gfn != is_priv_fault) {
> > > > +			kvm_prepare_memory_fault_exit(vcpu, gpa, PAGE_SIZE,
> > > > +						      kvm_is_write_fault(vcpu),
> > > > +						      false,
> > > > +						      is_priv_fault);
> > > > +			/*
> > > > +			 * KVM_EXIT_MEMORY_FAULT requires an return code of
> > > > +			 * -EFAULT, see the API documentation
> > > > +			 */
> > > > +			return -EFAULT;
> > > > +		}
> > > > +	}
> > > > +
> > > > +	memcache = get_mmu_memcache(vcpu);
> > > > +	ret = topup_mmu_memcache(vcpu, memcache);
> > > >    	if (ret)
> > > >    		return ret;
> > > >    	if (s2fd->nested)
> > > >    		gfn = kvm_s2_trans_output(s2fd->nested) >> PAGE_SHIFT;
> > > >    	else
> > > > -		gfn = s2fd->fault_ipa >> PAGE_SHIFT;
> > > > +		gfn = gpa >> PAGE_SHIFT;
> > > > -	write_fault = kvm_is_write_fault(s2fd->vcpu);
> > > > -	exec_fault = kvm_vcpu_trap_is_exec_fault(s2fd->vcpu);
> > > > +	write_fault = kvm_is_write_fault(vcpu);
> > > > +	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
> > > >    	VM_WARN_ON_ONCE(write_fault && exec_fault);
> > > > @@ -1634,7 +1696,7 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
> > > >    	ret = kvm_gmem_get_pfn(kvm, s2fd->memslot, gfn, &pfn, &page, NULL);
> > > >    	if (ret) {
> > > > -		kvm_prepare_memory_fault_exit(s2fd->vcpu, s2fd->fault_ipa, PAGE_SIZE,
> > > > +		kvm_prepare_memory_fault_exit(vcpu, gpa, PAGE_SIZE,
> > > >    					      write_fault, exec_fault, false);
> > > >    		return ret;
> > > >    	}
> > > > @@ -1654,14 +1716,20 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
> > > >    	kvm_fault_lock(kvm);
> > > >    	if (mmu_invalidate_retry(kvm, mmu_seq)) {
> > > >    		ret = -EAGAIN;
> > > > -		goto out_unlock;
> > > > +		goto out_release_page;
> > > > +	}
> > > > +
> > > > +	if (kvm_is_realm(kvm)) {
> > > > +		ret = realm_map_ipa(kvm, s2fd->fault_ipa, pfn,
> > > > +				    PAGE_SIZE, KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W, memcache);
> > > > +		goto out_release_page;
> > > >    	}
> > > >    	ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, s2fd->fault_ipa, PAGE_SIZE,
> > > >    						 __pfn_to_phys(pfn), prot,
> > > >    						 memcache, flags);
> > > > -out_unlock:
> > > > +out_release_page:
> > > >    	kvm_release_faultin_page(kvm, page, !!ret, prot & KVM_PGTABLE_PROT_W);
> > > >    	kvm_fault_unlock(kvm);
> > > > @@ -1847,7 +1915,7 @@ static int kvm_s2_fault_get_vma_info(const struct kvm_s2_fault_desc *s2fd,
> > > >    	 * mapping size to ensure we find the right PFN and lay down the
> > > >    	 * mapping in the right place.
> > > >    	 */
> > > > -	s2vi->gfn = ALIGN_DOWN(s2fd->fault_ipa, s2vi->vma_pagesize) >> PAGE_SHIFT;
> > > > +	s2vi->gfn = kvm_gpa_from_fault(kvm, ALIGN_DOWN(s2fd->fault_ipa, s2vi->vma_pagesize)) >> PAGE_SHIFT;
> > > >    	s2vi->mte_allowed = kvm_vma_mte_allowed(vma);
> > > > @@ -2056,6 +2124,9 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
> > > >    		prot &= ~KVM_NV_GUEST_MAP_SZ;
> > > >    		ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, gfn_to_gpa(gfn),
> > > >    								 prot, flags);
> > > > +	} else if (kvm_is_realm(kvm)) {
> > > > +		ret = realm_map_ipa(kvm, s2fd->fault_ipa, pfn, mapping_size,
> > > > +				    prot, memcache);
> > > >    	} else {
> > > >    		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, gfn_to_gpa(gfn), mapping_size,
> > > >    							 __pfn_to_phys(pfn), prot,
> > > 
> > > For the case kvm_is_realm(), need we adjust 's2fd->fault_ipa' for the sake of
> > > huge pages. In kvm_s2_fault_map(), @gfn and @pfn may have been adjusted by
> > > transparent_hugepage_adjust() to be aligned with huge page size. If the
> > > adjustment happened in transparent_hugepage_adjust(), we need to align
> > > s2fd->fault_ipa down to the huge page size either.
> > 
> > All of the above + some RMM changes are needed to get QEmu VMM going
> > with anon pages guest memory backing - currently testing various
> > configurations in the background.
> > 
> 
> I tried to rebase Jean's latest QEMU series [1] to upstream QEMU, and found
> that memory slots backed by THP are broken. With THP disabled on the host and
> other fixes (mentioned in my prevous replies) applied on the top of this (v14)
> series, I'm able to boot a realm guest with rebased QEMU series [2], plus more
> fxies on the top.
> 
> [1] https://git.codelinaro.org/linaro/dcap/qemu.git  (branch: cca/latest)
> [2] https://git.qemu.org/git/qemu.git                (branch: cca/gavin)
> 
> Lorenzo, You may be saying there is someone making QEMU to support ARM/CCA?

Mathieu and I are working on that yes and with Steven/Suzuki to fix the THP
issues you pointed out above.

> If so, I'm not sure if there is a QEMU repository for me to try?

We should be able to submit patches by end of June - we shall let you know
whether we can make something available earlier.

Thanks,
Lorenzo

> 
> Thanks,
> Gavin
> 
> > Thanks,
> > Lorenzo
> > 
> > > > @@ -2214,6 +2285,13 @@ int kvm_handle_guest_sea(struct kvm_vcpu *vcpu)
> > > >    	return 0;
> > > >    }
> > > > +static bool shared_ipa_fault(struct kvm *kvm, phys_addr_t fault_ipa)
> > > > +{
> > > > +	gpa_t gpa = kvm_gpa_from_fault(kvm, fault_ipa);
> > > > +
> > > > +	return (gpa != fault_ipa);
> > > > +}
> > > > +
> > > >    /**
> > > >     * kvm_handle_guest_abort - handles all 2nd stage aborts
> > > >     * @vcpu:	the VCPU pointer
> > > > @@ -2324,8 +2402,9 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
> > > >    		nested = &nested_trans;
> > > >    	}
> > > > -	gfn = ipa >> PAGE_SHIFT;
> > > > +	gfn = kvm_gpa_from_fault(vcpu->kvm, ipa) >> PAGE_SHIFT;
> > > >    	memslot = gfn_to_memslot(vcpu->kvm, gfn);
> > > > +
> > > >    	hva = gfn_to_hva_memslot_prot(memslot, gfn, &writable);
> > > >    	write_fault = kvm_is_write_fault(vcpu);
> > > >    	if (kvm_is_error_hva(hva) || (write_fault && !writable)) {
> > > > @@ -2368,7 +2447,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
> > > >    		 * of the page size.
> > > >    		 */
> > > >    		ipa |= FAR_TO_FIPA_OFFSET(kvm_vcpu_get_hfar(vcpu));
> > > > -		ret = io_mem_abort(vcpu, ipa);
> > > > +		ret = io_mem_abort(vcpu, kvm_gpa_from_fault(vcpu->kvm, ipa));
> > > >    		goto out_unlock;
> > > >    	}
> > > > @@ -2396,7 +2475,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
> > > >    				!write_fault &&
> > > >    				!kvm_vcpu_trap_is_exec_fault(vcpu));
> > > > -		if (kvm_slot_has_gmem(memslot))
> > > > +		if (kvm_slot_has_gmem(memslot) && !shared_ipa_fault(vcpu->kvm, fault_ipa))
> > > >    			ret = gmem_abort(&s2fd);
> > > >    		else
> > > >    			ret = user_mem_abort(&s2fd);
> > > > @@ -2433,6 +2512,10 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
> > > >    	if (!kvm->arch.mmu.pgt || kvm_vm_is_protected(kvm))
> > > >    		return false;
> > > > +	/* We don't support aging for Realms */
> > > > +	if (kvm_is_realm(kvm))
> > > > +		return true;
> > > > +
> > > >    	return KVM_PGT_FN(kvm_pgtable_stage2_test_clear_young)(kvm->arch.mmu.pgt,
> > > >    						   range->start << PAGE_SHIFT,
> > > >    						   size, true);
> > > > @@ -2449,6 +2532,10 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
> > > >    	if (!kvm->arch.mmu.pgt || kvm_vm_is_protected(kvm))
> > > >    		return false;
> > > > +	/* We don't support aging for Realms */
> > > > +	if (kvm_is_realm(kvm))
> > > > +		return true;
> > > > +
> > > >    	return KVM_PGT_FN(kvm_pgtable_stage2_test_clear_young)(kvm->arch.mmu.pgt,
> > > >    						   range->start << PAGE_SHIFT,
> > > >    						   size, false);
> > > > @@ -2628,10 +2715,11 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
> > > >    		return -EFAULT;
> > > >    	/*
> > > > -	 * Only support guest_memfd backed memslots with mappable memory, since
> > > > -	 * there aren't any CoCo VMs that support only private memory on arm64.
> > > > +	 * Only support guest_memfd backed memslots with mappable memory,
> > > > +	 * unless the guest is a CCA realm guest.
> > > >    	 */
> > > > -	if (kvm_slot_has_gmem(new) && !kvm_memslot_is_gmem_only(new))
> > > > +	if (kvm_slot_has_gmem(new) && !kvm_memslot_is_gmem_only(new) &&
> > > > +	    !kvm_is_realm(kvm))
> > > >    		return -EINVAL;
> > > >    	hva = new->userspace_addr;
> > > > diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
> > > > index cae29fd3353c..761b38a4071c 100644
> > > > --- a/arch/arm64/kvm/rmi.c
> > > > +++ b/arch/arm64/kvm/rmi.c
> > > > @@ -597,6 +597,179 @@ static int realm_data_map_init(struct kvm *kvm, unsigned long ipa,
> > > >    	return ret;
> > > >    }
> > > > +static unsigned long addr_range_desc(unsigned long phys, unsigned long size)
> > > > +{
> > > > +	unsigned long out = 0;
> > > > +
> > > > +	switch (size) {
> > > > +	case P4D_SIZE:
> > > > +		out = 3 | (1 << 2);
> > > > +		break;
> > > > +	case PUD_SIZE:
> > > > +		out = 2 | (1 << 2);
> > > > +		break;
> > > > +	case PMD_SIZE:
> > > > +		out = 1 | (1 << 2);
> > > > +		break;
> > > > +	case PAGE_SIZE:
> > > > +		out = 0 | (1 << 2);
> > > > +		break;
> > > > +	default:
> > > > +		/*
> > > > +		 * Only support mapping at the page level granulatity when
> > > > +		 * it's an unusual length. This should get us back onto a larger
> > > > +		 * block size for the subsequent mappings.
> > > > +		 */
> > > > +		out = 0 | ((MIN(size >> PAGE_SHIFT, PTRS_PER_PTE - 1)) << 2);
> > > > +		break;
> > > > +	}
> > > > +
> > > > +	WARN_ON(phys & ~PAGE_MASK);
> > > > +
> > > > +	out |= phys & PAGE_MASK;
> > > > +
> > > > +	return out;
> > > > +}
> > > > +
> > > > +int realm_map_protected(struct kvm *kvm,
> > > > +			unsigned long ipa,
> > > > +			kvm_pfn_t pfn,
> > > > +			unsigned long map_size,
> > > > +			struct kvm_mmu_memory_cache *memcache)
> > > > +{
> > > > +	struct realm *realm = &kvm->arch.realm;
> > > > +	phys_addr_t phys = __pfn_to_phys(pfn);
> > > > +	phys_addr_t base_phys = phys;
> > > > +	phys_addr_t rd = virt_to_phys(realm->rd);
> > > > +	unsigned long base_ipa = ipa;
> > > > +	unsigned long ipa_top = ipa + map_size;
> > > > +	int ret = 0;
> > > > +
> > > > +	if (WARN_ON(!IS_ALIGNED(map_size, PAGE_SIZE) ||
> > > > +		    !IS_ALIGNED(ipa, map_size)))
> > > > +		return -EINVAL;
> > > > +
> > > > +	if (rmi_delegate_range(phys, map_size)) {
> > > > +		/*
> > > > +		 * It's likely we raced with another VCPU on the same
> > > > +		 * fault. Assume the other VCPU has handled the fault
> > > > +		 * and return to the guest.
> > > > +		 */
> > > > +		return 0;
> > > > +	}
> > > > +
> > > > +	while (ipa < ipa_top) {
> > > > +		unsigned long flags = RMI_ADDR_TYPE_SINGLE;
> > > > +		unsigned long range_desc = addr_range_desc(phys, ipa_top - ipa);
> > > > +		unsigned long out_top;
> > > > +
> > > > +		ret = rmi_rtt_data_map(rd, ipa, ipa_top, flags, range_desc,
> > > > +				       &out_top);
> > > > +
> > > > +		if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
> > > > +			/* Create missing RTTs and retry */
> > > > +			int level = RMI_RETURN_INDEX(ret);
> > > > +
> > > > +			WARN_ON(level == KVM_PGTABLE_LAST_LEVEL);
> > > > +			ret = realm_create_rtt_levels(realm, ipa, level,
> > > > +						      KVM_PGTABLE_LAST_LEVEL,
> > > > +						      memcache);
> > > > +			if (ret)
> > > > +				goto err_undelegate;
> > > > +
> > > > +			ret = rmi_rtt_data_map(rd, ipa, ipa_top, flags,
> > > > +					       range_desc, &out_top);
> > > > +		}
> > > > +
> > > > +		if (WARN_ON(ret))
> > > > +			goto err_undelegate;
> > > > +
> > > > +		phys += out_top - ipa;
> > > > +		ipa = out_top;
> > > > +	}
> > > > +
> > > > +	return 0;
> > > > +
> > > > +err_undelegate:
> > > > +	realm_unmap_private_range(kvm, base_ipa, ipa, true);
> > > > +	if (WARN_ON(rmi_undelegate_range(base_phys, map_size))) {
> > > > +		/* Page can't be returned to NS world so is lost */
> > > > +		get_page(phys_to_page(base_phys));
> > > > +	}
> > > > +	return -ENXIO;
> > > > +}
> > > > +
> > > > +int realm_map_non_secure(struct realm *realm,
> > > > +			 unsigned long ipa,
> > > > +			 kvm_pfn_t pfn,
> > > > +			 unsigned long size,
> > > > +			 enum kvm_pgtable_prot prot,
> > > > +			 struct kvm_mmu_memory_cache *memcache)
> > > > +{
> > > > +	unsigned long attr, flags = 0;
> > > > +	phys_addr_t rd = virt_to_phys(realm->rd);
> > > > +	phys_addr_t phys = __pfn_to_phys(pfn);
> > > > +	unsigned long ipa_top = ipa + size;
> > > > +	int ret;
> > > > +
> > > > +	if (WARN_ON(!IS_ALIGNED(size, PAGE_SIZE) ||
> > > > +		    !IS_ALIGNED(ipa, size)))
> > > > +		return -EINVAL;
> > > > +
> > > > +	switch (prot & (KVM_PGTABLE_PROT_DEVICE | KVM_PGTABLE_PROT_NORMAL_NC)) {
> > > > +	case KVM_PGTABLE_PROT_DEVICE | KVM_PGTABLE_PROT_NORMAL_NC:
> > > > +		return -EINVAL;
> > > > +	case KVM_PGTABLE_PROT_DEVICE:
> > > > +		attr = MT_S2_FWB_DEVICE_nGnRE;
> > > > +		break;
> > > > +	case KVM_PGTABLE_PROT_NORMAL_NC:
> > > > +		attr = MT_S2_FWB_NORMAL_NC;
> > > > +		break;
> > > > +	default:
> > > > +		attr = MT_S2_FWB_NORMAL;
> > > > +	}
> > > > +
> > > > +	flags |= FIELD_PREP(RMI_RTT_UNPROT_MAP_FLAGS_MEMATTR, attr);
> > > > +
> > > > +	if (prot & KVM_PGTABLE_PROT_R)
> > > > +		flags |= FIELD_PREP(RMI_RTT_UNPROT_MAP_FLAGS_S2AP, RMI_S2AP_DIRECT_READ);
> > > > +	if (prot & KVM_PGTABLE_PROT_W)
> > > > +		flags |= FIELD_PREP(RMI_RTT_UNPROT_MAP_FLAGS_S2AP, RMI_S2AP_DIRECT_WRITE);
> > > > +
> > > > +	flags |= RMI_ADDR_TYPE_SINGLE;
> > > > +
> > > > +	while (ipa < ipa_top) {
> > > > +		unsigned long range_desc = addr_range_desc(phys, ipa_top - ipa);
> > > > +		unsigned long out_top;
> > > > +
> > > > +		ret = rmi_rtt_unprot_map(rd, ipa, ipa_top, flags, range_desc,
> > > > +					 &out_top);
> > > > +
> > > > +		if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
> > > > +			/* Create missing RTTs and retry */
> > > > +			int level = RMI_RETURN_INDEX(ret);
> > > > +
> > > > +			WARN_ON(level == KVM_PGTABLE_LAST_LEVEL);
> > > > +			ret = realm_create_rtt_levels(realm, ipa, level,
> > > > +						      KVM_PGTABLE_LAST_LEVEL,
> > > > +						      memcache);
> > > > +			if (ret)
> > > > +				return ret;
> > > > +
> > > > +			ret = rmi_rtt_unprot_map(rd, ipa, ipa_top, flags,
> > > > +						 range_desc, &out_top);
> > > > +		}
> > > > +
> > > > +		if (WARN_ON(ret))
> > > > +			return ret;
> > > > +
> > > > +		phys += out_top - ipa;
> > > > +		ipa = out_top;
> > > > +	}
> > > > +
> > > > +	return 0;
> > > > +}
> > > > +
> > > >    static int populate_region_cb(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> > > >    			      struct page *src_page, void *opaque)
> > > >    {
> > > 
> > > Thanks,
> > > Gavin
> > > 
> > 
> 
