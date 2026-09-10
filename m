Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C509A38D400;
	Thu, 10 Sep 2026 15:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789054377; cv=none; b=U3wbrccGTrGePNiEQiqusq4ImDsO38Lcl1ZfLXi2HcuQMHSK2tur3AVKuCiEWpOme5GtJsEyyZLsThQ+vUr2Yf1fjC1rjzDGuBKqgQW1eoONk1mj/FhDdEl7hceE95qNf2um15DDSPkAnc/gU7XXBB/oVW93ce3Lxe8yU4v7ZCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789054377; c=relaxed/simple;
	bh=zOLjl9CIXZFNlY3XjUzPlJfvjtqZ6beBwCb9UF8DTDY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VgR0gxpXsK3k5hgNzva0HJblNFvEFGm5uK+8HbCdcBs4AjBl3wJftkbGbFRHgP8yu2+CzgrX0pXRQlV3HEEwb4a0tik3kcjFHbsM79KmBkpxNPTV+4NWriLsjnKyBxeFlH0gAj1MhmuLaOytuT/PLZ6eWn0nQL01Lq9x0gLqdd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K/XiHLTI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K/XiHLTI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3471C1F000FF;
	Thu, 10 Sep 2026 15:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789054375;
	bh=6vb5ChOERdgx+BfNfpa3QgHVpj5eLttfujUZfrMna5s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=K/XiHLTIGjYcJXwlFdJ51anQzZSheOkgRMqYU8HMSQHz+BCJp0urGfihbbJFLmy17
	 AxvPfn5mUoceuDnoDYamM+UBVl725kLAkP7I9aMJhH5Mpq44f5QElf6uHXpCv/CxLs
	 vS0Q7COG6stHDxSmFhv5IQbidpbKIfysa7Rqdt26kBecRrAA+ygiLb7c7bHzl8DcZ5
	 CRDMPX7THU7joN6POZ9m6aeUODQd5+wJQHJrGwhjR/8tYT5Wl0DsAntof8AYcu6OYz
	 YWBNY7Yg6wSUZDU7orJu57n3W7McSfnZuf2GIjIk0vqf8Vl9Gu2gGOUrrNAP1hgA13
	 WvAbNhL1QTRRg==
Date: Thu, 10 Sep 2026 16:32:46 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Oliver Upton <oupton@kernel.org>, Fuad Tabba <tabba@google.com>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Jack Thomson <jackabt@amazon.com>, Jack Thomson <jackabt.amazon@gmail.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Vincent Donnefort <vdonnefort@google.com>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Leo Soares Passos <Leo.Bras@arm.com>
Subject: Re: [PATCH 5/8] KVM: arm64: Implement KVM_PRE_FAULT_MEMORY
Message-ID: <aqLFfbxa26ZGpJDh@gremlin>
References: <20260825-kvm-arm-prefault-v1-0-befe8947702e@kernel.org>
 <20260825-kvm-arm-prefault-v1-5-befe8947702e@kernel.org>
 <86tsnx77c1.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86tsnx77c1.wl-maz@kernel.org>

On Thu, Sep 10, 2026 at 11:02:06AM +0100, Marc Zyngier wrote:
> On Tue, 25 Aug 2026 17:00:39 +0100,
> "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
> >
> > Implement KVM stage 2 page table pre-faulting for the arm64 architecture.
> >
> > Do the trivial plumbing by selecting CONFIG_KVM_GENERIC_PRE_FAULT_MEMORY in
> > Kconfig, returning 1 in kvm_vm_ioctl_check_extension() for
> > KVM_CAP_PRE_FAULT_MEMORY but false in kvm_pkvm_ext_allowed() to disallow
> > its use for pKVM.
> >
> > Add kvm_arch_vcpu_pre_fault_memory() to actually implement the feature by
> > pre-faulting stage 2 page tables for a specific GPA.
> >
> > Previous commits added the required foundations - gmem_abort() and
> > user_mem_abort() determine esr and mmu from s2fd->esr and s2fd->mmu
> > respectively, the granule size is returned by them in kvm_s2_fault_result
> > and kvm_pgtable_get_leaf() accepts a walk flags parameter.
> >
> > Additionally, kvm_pgtable_get_leaf() now accepts a walk flag, meaning its
> > page table walk can be performed with KVM_PGTABLE_WALK_SHARED set and thus
> > can be performed under a read mmu_lock.
>
> We really don't need a recap of the previous episodes... ;-)

Haha fair enough ;) will drop.

>
> >
> > With these changes in place, implement pre-faulting by first trying a page
> > table walk under the MMU read lock then, if it fails, injecting a
> > synthetic data abort at the page table level at which the page table walk
> > failed.
> >
> > This is necessarily racey as reclaim might happen at any time. Successfully
> > pre-faulting can therefore only guarantee that each GPA was observed to be
> > mapped at least once.
> >
> > Protected KVM (pKVM) is not supported at all because pKVM creates VMs and
> > vCPUs when first run, meaning any attempt to pre-fault prior to this cannot
> > succeed.
> >
> > Since the sensible use case for pre-faulting is doing so prior to vCPU run,
> > and supporting only online pKVM vCPUs is confusing and inconsistent, simply
> > don't support this at all.
> >
> > There is a subtlety when retrieving the hva: it seems natural to use
> > gfn_to_hva_memslot(), but this errors out for read-only memslots.
> >
> > Since pre-faulting should fault in both read-only and read/write hvas, this
> > isn't the correct API to use here.
> >
> > gfn_to_hva_memslot_prot() allows retrieval of read-only hvas, but has
> > unclear semantics, so introduce gfn_to_hva_memslot_read() to wrap it.
> >
> > A retry mechanic is implemented when user_mem_abort() or gmem_abort() fail
> > to map memory due to a benign failure where a hardware abort would not
> > result in an error.
> >
> > These occur when the abort handler was raced by either an invalidation MMU
> > notifier or a racing abort path.
> >
> > Since these faults are highly likely to succeed on immediate retry, retry
> > up to MAX_PRE_FAULT_RETRIES times, after which -EAGAIN is ultimately
> > returned to the caller.
> >
> > An invalid memslot (i.e. a memslot with the KVM_MEMSLOT_INVALID flag set)
> > also results in the operation returning -EAGAIN without a retry mechanic.
> >
> > This is because an invalid memslot means the pre-fault operation raced with
> > memslot reclaim, and since the SRCU lock is held, progress cannot be made.
> >
> > Therefore, when this happens, -EAGAIN indicates that userland should retry
> > the ioctl, which will bounce the SRCU lock and permit forward progress.
> >
> > Finally, update the KVM API documentation to describe the changes,
> > providing arm64-specific implementation details.
> >
> > This work is based with gratitude on Jack Thomson's original series, its
> > previous revisions and the feedback they received.
>
> Honestly, this whole commit message reads like a cover letter.
> Consider writing something more succinct, which would be helped by
> splitting the patch: if you have so much to say for a single patch,
> that's probably that the patch is doing too many things.

Ack,

>
> >
> > Link: https://patch.msgid.link/20260612162354.73378-1-jackabt.amazon@gmail.com/
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  Documentation/virt/kvm/api.rst    |  17 +++-
> >  arch/arm64/include/asm/kvm_pkvm.h |   2 +-
> >  arch/arm64/kvm/Kconfig            |   1 +
> >  arch/arm64/kvm/arm.c              |   1 +
> >  arch/arm64/kvm/mmu.c              | 192 +++++++++++++++++++++++++++++++++++---
> >  5 files changed, 198 insertions(+), 15 deletions(-)
> >
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index 4988c32df4bf..6246f4a56bb9 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -6485,7 +6485,7 @@ See KVM_SET_USER_MEMORY_REGION2 for additional details.
> >  ---------------------------
> >
> >  :Capability: KVM_CAP_PRE_FAULT_MEMORY
> > -:Architectures: none
> > +:Architectures: x86, s390, arm64
> >  :Type: vcpu ioctl
> >  :Parameters: struct kvm_pre_fault_memory (in/out)
> >  :Returns: 0 if at least one page is processed, < 0 on error
> > @@ -6493,12 +6493,14 @@ See KVM_SET_USER_MEMORY_REGION2 for additional details.
> >  Errors:
> >
> >    ========== ===============================================================
> > +  EAGAIN     A race occurred before progress was made, but a retry may succeed.
> >    EINVAL     The specified `gpa` and `size` were invalid (e.g. not
> >               page aligned, causes an overflow, or size is zero), or the VM
> >               is UCONTROL (s390).
> >    ENOENT     The specified `gpa` is outside defined memslots.
> >    EINTR      An unmasked signal is pending and no page was processed.
> >    EFAULT     The parameter address was invalid.
> > +  EHWPOISON  A poisoned host page was encountered.
> >    EOPNOTSUPP Mapping memory for a GPA is unsupported by the
> >               hypervisor, and/or for the current vCPU state/mode.
> >    EIO        unexpected error conditions (also causes a WARN)
> > @@ -6518,7 +6520,16 @@ Errors:
> >  KVM_PRE_FAULT_MEMORY populates KVM's stage-2 page tables used to map memory
> >  for the current vCPU state.  KVM maps memory as if the vCPU generated a
> >  stage-2 read page fault, e.g. faults in memory as needed, but doesn't break
> > -CoW.  On x86, KVM does not mark any newly created stage-2 PTE as Accessed.
> > +CoW.  On arm64, KVM marks both existing and newly created stage-2 PTEs as
> > +Accessed, on x86 it does not and for s390 it is not applicable.
>
> Meh. See below.
>
> > +
> > +On arm64, a GPA is interpreted as an IPA, and never interpreted as the IPA
> > +of a nested guest. Pre-faulting only populates canonical stage 2 page
> > +tables.
> > +
> > +The feature is not supported on arm64 if the protected KVM (pKVM) feature
> > +is enabled, as that results in vCPUs being instantiated on first run, which
> > +renders pre-faulting useless.
>
> I don't think we need to justify why this is not available with pKVM.
> I expect pKVM to eventually support this through a slightly different
> mechanism anyway.

OK, can just end the sentence at 'is enabled'.

>
> >
> >  In the case of confidential VM types where there is an initial set up of
> >  private guest memory before the guest is 'finalized'/measured, this ioctl
> > @@ -6533,7 +6544,7 @@ When the ioctl returns, the input values are updated to point to the
> >  remaining range.  If `size` > 0 on return, the caller can just issue
> >  the ioctl again with the same `struct kvm_map_memory` argument.
> >
> > -Shadow page tables cannot support this ioctl because they
> > +On x86, Shadow page tables cannot support this ioctl because they
>
> shadow

Oops yup!

>
> >  are indexed by virtual address or nested guest physical address.
> >  Calling this ioctl when the guest is using shadow page tables (for
> >  example because it is running a nested guest with nested page tables)
>
> Documentation updates in a separate patch, please.

Ack!

>
> > diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
> > index beea00e693a0..4d6e5765e9e5 100644
> > --- a/arch/arm64/include/asm/kvm_pkvm.h
> > +++ b/arch/arm64/include/asm/kvm_pkvm.h
> > @@ -44,9 +44,9 @@ static inline bool kvm_pkvm_ext_allowed(struct kvm *kvm, long ext)
> >  	case KVM_CAP_ARM_PTRAUTH_GENERIC:
> >  		return true;
> >  	case KVM_CAP_ARM_MTE:
> > -		return false;
> >  	case KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE:
> >  	case KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES:
> > +	case KVM_CAP_PRE_FAULT_MEMORY:
> >  		return false;
> >  	default:
> >  		return !kvm || !kvm_vm_is_protected(kvm);
> > diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> > index 449154f9a485..71233068b7cb 100644
> > --- a/arch/arm64/kvm/Kconfig
> > +++ b/arch/arm64/kvm/Kconfig
> > @@ -37,6 +37,7 @@ menuconfig KVM
> >  	select SCHED_INFO
> >  	select GUEST_PERF_EVENTS if PERF_EVENTS
> >  	select KVM_GUEST_MEMFD
> > +	select KVM_GENERIC_PRE_FAULT_MEMORY
> >  	help
> >  	  Support hosting virtualized guest machines.
> >
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index ccae82c1242b..58ac70f31d84 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -393,6 +393,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> >  	case KVM_CAP_COUNTER_OFFSET:
> >  	case KVM_CAP_ARM_WRITABLE_IMP_ID_REGS:
> >  	case KVM_CAP_ARM_SEA_TO_USER:
> > +	case KVM_CAP_PRE_FAULT_MEMORY:
> >  		r = 1;
> >  		break;
> >  	case KVM_CAP_SET_GUEST_DEBUG2:
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 16299004f229..401ae538ae75 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -5,6 +5,7 @@
> >   */
> >
> >  #include <linux/acpi.h>
> > +#include <linux/cleanup.h>
> >  #include <linux/mman.h>
> >  #include <linux/kvm_host.h>
> >  #include <linux/io.h>
> > @@ -1554,9 +1555,9 @@ static void *get_mmu_memcache(struct kvm_vcpu *vcpu)
> >  		return &vcpu->arch.pkvm_memcache;
> >  }
> >
> > -static int topup_mmu_memcache(struct kvm_vcpu *vcpu, void *memcache)
> > +static int topup_mmu_memcache(struct kvm_s2_mmu *mmu, void *memcache)
> >  {
> > -	int min_pages = kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu);
> > +	const int min_pages = kvm_mmu_cache_min_pages(mmu);
>
> Changes to the memcache interface in a separate patch, please.

Ack!

>
> >
> >  	if (!is_protected_kvm_enabled())
> >  		return kvm_mmu_topup_memory_cache(memcache, min_pages);
> > @@ -1605,6 +1606,7 @@ struct kvm_s2_fault_desc {
> >  	unsigned long		hva;
> >  	unsigned long		esr;
> >  	struct kvm_s2_mmu	*mmu;
> > +	bool			pre_fault;
>
> No, please, that's horrible. See below.

Yeah, I think this was a carry-through from the original series. Will drop!

>
> >  };
> >
> >  struct kvm_s2_fault_result {
> > @@ -1664,7 +1666,7 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd,
> >
> >  	if (!perm_fault) {
> >  		memcache = get_mmu_memcache(s2fd->vcpu);
> > -		ret = topup_mmu_memcache(s2fd->vcpu, memcache);
> > +		ret = topup_mmu_memcache(s2fd->mmu, memcache);
> >  		if (ret)
> >  			return ret;
> >  	}
> > @@ -1761,7 +1763,7 @@ static int pkvm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
> >  	int ret;
> >
> >  	hyp_memcache = get_mmu_memcache(vcpu);
> > -	ret = topup_mmu_memcache(vcpu, hyp_memcache);
> > +	ret = topup_mmu_memcache(s2fd->mmu, hyp_memcache);
> >  	if (ret)
> >  		return -ENOMEM;
> >
> > @@ -1953,6 +1955,8 @@ static int kvm_s2_fault_pin_pfn(const struct kvm_s2_fault_desc *s2fd,
> >  				      &s2vi->map_writable, &s2vi->page);
> >  	if (unlikely(is_error_noslot_pfn(s2vi->pfn))) {
> >  		if (s2vi->pfn == KVM_PFN_ERR_HWPOISON) {
> > +			if (s2fd->pre_fault)
> > +				return -EHWPOISON;
>
> I'd rather *always* return -EHWPOISON here, and move the signal
> injection into the callers. That would much more consistent.

OK that is nicer :) Will do that instead.

>
> >  			kvm_send_hwpoison_signal(s2fd->hva, __ffs(s2vi->vma_pagesize));
> >  			return 0;
> >  		}
> > @@ -2163,7 +2167,7 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd,
> >  	memcache = get_mmu_memcache(s2fd->vcpu);
> >  	if (!perm_fault || memslot_is_logging(s2fd->memslot) ||
> >  	    is_protected_kvm_enabled()) {
> > -		ret = topup_mmu_memcache(s2fd->vcpu, memcache);
> > +		ret = topup_mmu_memcache(s2fd->mmu, memcache);
> >  		if (ret)
> >  			return ret;
> >  	}
> > @@ -2185,18 +2189,22 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd,
> >  	return kvm_s2_fault_map(s2fd, &s2vi, prot, memcache, result);
> >  }
> >
> > -/* Resolve the access fault by making the page young again. */
> > -static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
> > +static void __handle_access_fault(struct kvm_pgtable *pgt, phys_addr_t fault_ipa)
> >  {
> >  	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
> > -	struct kvm_s2_mmu *mmu;
> >
> >  	trace_kvm_access_fault(fault_ipa);
> > +	KVM_PGT_FN(kvm_pgtable_stage2_mkyoung)(pgt, fault_ipa, flags);
> > +}
> > +
> > +/* Resolve the access fault by making the page young again. */
> > +static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
> > +{
> > +	struct kvm_s2_mmu *mmu;
> >
> > -	read_lock(&vcpu->kvm->mmu_lock);
> > +	guard(read_lock)(&vcpu->kvm->mmu_lock);
> >  	mmu = vcpu->arch.hw_mmu;
> > -	KVM_PGT_FN(kvm_pgtable_stage2_mkyoung)(mmu->pgt, fault_ipa, flags);
> > -	read_unlock(&vcpu->kvm->mmu_lock);
> > +	__handle_access_fault(mmu->pgt, fault_ipa);
> >  }
> >
> >  /*
> > @@ -2834,3 +2842,165 @@ void kvm_toggle_cache(struct kvm_vcpu *vcpu, bool was_enabled)
> >
> >  	trace_kvm_toggle_cache(*vcpu_pc(vcpu), was_enabled, now_enabled);
> >  }
> > +
> > +static bool kvm_pte_young_s2(kvm_pte_t pte)
> > +{
> > +	return pte & KVM_PTE_LEAF_ATTR_LO_S2_AF;
> > +}
> > +
> > +static void kvm_pte_mkyoung_s2(struct kvm_pgtable *pgt, gpa_t gpa)
> > +{
> > +	struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
> > +
> > +	lockdep_assert_held(&kvm->mmu_lock);
> > +	/* Despite its name, doesn't fault here. */
> > +	__handle_access_fault(pgt, gpa);
> > +}
> > +
> > +/*
> > + * Try to walk to the specified GPA in canonical mmu - if unmapped returns 0, if
> > + * mapped returns the granule size, otherwise returns an error.
> > + */
> > +static long kvm_walk_s2(struct kvm_pgtable *pgt,
> > +			gpa_t gpa, s8 *level)
> > +{
> > +	struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
> > +	kvm_pte_t pte;
> > +	long ret;
> > +
> > +	guard(read_lock)(&kvm->mmu_lock);
> > +
> > +	ret = kvm_pgtable_get_leaf(pgt, gpa, &pte, level,
> > +				   KVM_PGTABLE_WALK_SHARED);
> > +	if (ret)
> > +		return ret;
> > +	/* Unpopulated, must fault. */
> > +	if (!kvm_pte_valid(pte))
> > +		return 0;
> > +	/* Walked the entry so mark young. */
> > +	if (!kvm_pte_young_s2(pte))
> > +		kvm_pte_mkyoung_s2(pgt, gpa);
>
> I'm not sold on this either. The contract with userspace is to map the
> page at S2, not to pretend it has been accessed by the vcpu. I don't
> see why we should do that, as this is a departure from an established
> behaviour.

Ack, yeah, that's fair enough.

Thinking was it's the 'equivalent of touching the pages', but for existing pages
that's not the case at all.

New pages will be born young, but that makes sense since you did actually do
something (fault them in).

>
> > +	return kvm_granule_size(*level);
> > +}
> > +
> > +/* Synthesised data abort at specified page table level. */
> > +#define PRE_FAULT_ESR(level)				\
> > +	 ((ESR_ELx_EC_DABT_LOW << ESR_ELx_EC_SHIFT) |	\
> > +	  ESR_ELx_IL | ESR_ELx_FSC_FAULT_L(level))
> > +
> > +/* Retrieve either a read-only or a read/write hva. */
> > +static hva_t gfn_to_hva_memslot_read(struct kvm_memory_slot *slot, gfn_t gfn)
> > +{
> > +	return gfn_to_hva_memslot_prot(slot, gfn, /*writable=*/NULL);
> > +}
> > +
> > +static long __pre_fault_s2(struct kvm_s2_mmu *mmu, struct kvm_vcpu *vcpu,
> > +			   gpa_t gpa, struct kvm_memory_slot *memslot, s8 level)
> > +{
> > +	const bool is_gmem  = kvm_slot_has_gmem(memslot);
> > +	const gfn_t gfn = gpa_to_gfn(gpa);
> > +	const hva_t hva = is_gmem ? 0 : gfn_to_hva_memslot_read(memslot, gfn);
> > +	const struct kvm_s2_fault_desc s2fd = {
> > +		.vcpu		= vcpu,
> > +		.fault_ipa	= gpa,
> > +		.nested		= NULL,
> > +		.memslot	= memslot,
> > +		.hva		= hva,
> > +		.esr		= PRE_FAULT_ESR(level),
> > +		.mmu		= mmu,
> > +		.pre_fault	= true,
> > +	};
> > +	struct kvm_s2_fault_result result = {};
> > +	long ret;
> > +
> > +	if (kvm_is_error_hva(hva))
> > +		return -EFAULT;
> > +
> > +	if (is_gmem)
> > +		ret = gmem_abort(&s2fd, &result);
> > +	else
> > +		ret = user_mem_abort(&s2fd, &result);
> > +	if (IS_ERR_VALUE(ret))
> > +		return ret;
> > +	if (!result.mapped)
> > +		return -EAGAIN;
> > +	return result.mapping_size;
> > +}
> > +
> > +static long pre_fault_s2(struct kvm_s2_mmu *mmu, struct kvm_vcpu *vcpu,
> > +			 gpa_t gpa, struct kvm_memory_slot *memslot)
> > +{
> > +	s8 level = KVM_PGTABLE_LAST_LEVEL;
>
> level is the result of a successful walk. Why do we need to initialise
> this to anything here? We don't seem to do that anywhere else.

I feared that level wouldn't get assigned, but looking through the code, if
kvm_walk_s2() returns 0 then it's always assigned so will update -> s8 level;

>
> > +	long ret;
> > +
> > +	/* Try a walk first. */
> > +	ret = kvm_walk_s2(mmu->pgt, gpa, &level);
> > +	if (ret)
> > +		return ret;
> > +	/* OK, have to fault page in. */
> > +	return __pre_fault_s2(mmu, vcpu, gpa, memslot, level);
> > +}
> > +
> > +static unsigned long
> > +pre_fault_bytes_consumed(gpa_t gpa, unsigned long granule_size,
> > +			 unsigned long bytes_remaining)
> > +{
> > +	/* Granules are always a power-of-2. */
> > +	const unsigned long granule_bytes_remaining =
> > +		granule_size - (gpa % granule_size);
> > +
> > +	return min(granule_bytes_remaining, bytes_remaining);
> > +}
> > +
> > +/* If you lose the race this many times, time to give up. */
> > +#define MAX_PRE_FAULT_RETRIES 3
> > +
> > +/**
> > + * kvm_arch_vcpu_pre_fault_memory - pre-fault stage-2 page tables for the
> > + * specified GPA.
> > + * @vcpu:	The VCPU pointer
> > + * @range:	{gpa, size, flags} tuple
> > + *
> > + * The mapping performed is always best-effort - faulting in is necessarily
> > + * racey. The ranges faulted in are canonical, nested page tables are ignored.
> > + *
> > + * If the GPA is already mapped, the page table entry is marked young.
> > + *
> > + * @range->gpa specifies the GPA to pre-fault, @range->size specifies how many
> > + * bytes remain to be pre-faulted and @range->flags is reserved and must be 0.
> > + *
> > + * Returns: the number of bytes the pre-fault consumed, or an error.
> > + */
> > +long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
> > +				    struct kvm_pre_fault_memory *range)
> > +{
> > +	struct kvm *kvm = vcpu->kvm;
> > +	const u64 bytes_remaining = range->size;
> > +	struct kvm_s2_mmu *mmu = &kvm->arch.mmu; /* Canonical. */
> > +	struct kvm_memory_slot *memslot;
> > +	const gpa_t gpa = range->gpa;
> > +	int num_retries = 0;
> > +	long ret;
> > +
> > +	/*
> > +	 * pKVM is unsupported as their vCPUs are instantiated on first run and
> > +	 * pre-faulting only running vCPUs would be inconsistent and confusing.
> > +	 */
> > +	if (is_protected_kvm_enabled())
> > +		return -EOPNOTSUPP;
> > +
> > +	memslot = gfn_to_memslot(kvm, gpa_to_gfn(gpa));
> > +	if (!memslot)
> > +		return -ENOENT;
> > +	/* SRCU must be released for progress and only userland can do that. */
> > +	if (memslot->flags & KVM_MEMSLOT_INVALID)
> > +		return -EAGAIN;
> > +
> > +	do {
> > +		ret = pre_fault_s2(mmu, vcpu, gpa, memslot);
> > +	} while (ret == -EAGAIN && num_retries++ < MAX_PRE_FAULT_RETRIES);
> > +
> > +	if (IS_ERR_VALUE(ret))
> > +		return ret;
> > +	return pre_fault_bytes_consumed(gpa, ret, bytes_remaining);
> > +}
> >
>
> Thanks,
>
> 	M.
>
> --
> Without deviation from the norm, progress is not possible.

--
Cheers, Lorenzo
