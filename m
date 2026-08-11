Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBBD13B19A9;
	Tue, 11 Aug 2026 15:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786462956; cv=none; b=ar4EHHn9FDXPU4UU8nwUdT+icFTWI6PNXPkHMx0hjoUA8iDVjWnCoQi92BDXQSFLEl7FJGo+1d2DaDLBtqhEtK0TgYbUj28Q+Xx3aptMzxw6z/+dfrLxOfwSeFWisXfW2J/zlzdgJ6okVjS9owh1vSoXLNupf/gU15ycpT6zpOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786462956; c=relaxed/simple;
	bh=N3qnRTjJztvg5epuOANhnoAI4KJvsaIW+sRapJAXN0U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AF5LNm4XTRUk9rx25Res+M+LD4YrYd39Hdfe2SaxTfBbifjuAfsqULyl8/k5bjtp9BKeO7j4A1LopWGBTf5bbt4d1xaDtsKqgwmUuGxyWBz9cz/LSMH2FsEUSkyVOOKHwnlRJsrPxAGxfI/yw/+RkqnLsOjcWIEcq810NnGXM5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=am/mA1sK; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="am/mA1sK"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 26D1D1516;
	Tue, 11 Aug 2026 08:42:30 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 238EC3F632;
	Tue, 11 Aug 2026 08:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786462954; bh=N3qnRTjJztvg5epuOANhnoAI4KJvsaIW+sRapJAXN0U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=am/mA1sK5zKjfitH7cRbZ87H8alzpMUQI8+jwTsN4PE48jXctVfydgElUScpeO1vs
	 IA80CRzE5RJn8gXG/Utun8MLlkKfIN7KX/969mbtdhU6KQffIXWp+B1Imv4mGyOkfF
	 8epE3AiaUl1z/9uja+Du7UQunHcap01bytZVtlU4=
Date: Tue, 11 Aug 2026 16:42:28 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
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
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: Re: [PATCH v16 29/45] KVM: arm64: CCA: Support runtime faulting of
 memory
Message-ID: <antC5JOxDPs7i876@arm.com>
References: <20260803134403.80630-1-steven.price@arm.com>
 <20260803134403.80630-30-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803134403.80630-30-steven.price@arm.com>

On Mon, Aug 03, 2026 at 02:43:45PM +0100, Steven Price wrote:
> At runtime if the realm guest accesses memory which hasn't yet been
> mapped then KVM needs to either populate the region or fault the guest.
> 
> For memory in the lower (protected) region of IPA a fresh page is
> provided to the RMM which will zero the contents. For memory in the
> upper (shared) region of IPA, the memory from the memslot is mapped
> into the realm VM non secure.

Is this still true with in-place guestmem conversion?

> @@ -1693,7 +1709,14 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
>  	kvm_fault_lock(kvm);
>  	if (mmu_invalidate_retry(kvm, mmu_seq)) {
>  		ret = -EAGAIN;
> -		goto out_unlock;
> +		goto out_release_page;
> +	}
> +
> +	if (kvm_is_realm(kvm)) {
> +		prot &= ~KVM_PGTABLE_PROT_X;
> +		ret = realm_map_ipa(kvm, s2fd->fault_ipa, pfn,
> +				    PAGE_SIZE, prot, memcache);
> +		goto out_release_page;
>  	}

[...]

> +int realm_map_ipa(struct kvm *kvm, phys_addr_t ipa,
> +		  kvm_pfn_t pfn, unsigned long map_size,
> +		  enum kvm_pgtable_prot prot,
> +		  struct kvm_mmu_memory_cache *memcache)
> +{
> +	struct realm *realm = &kvm->arch.realm;
> +
> +	ipa = ALIGN_DOWN(ipa, map_size);
> +	if (!kvm_realm_is_private_address(realm, ipa)) {
> +		return realm_map_non_secure(kvm, ipa, pfn, map_size, prot,
> +					    memcache);
> +	}
> +
> +	/* It's impossible to map protected pages read-only. */
> +	if (WARN_ON(!(prot & KVM_PGTABLE_PROT_W)))
> +		return -EFAULT;
> +	return realm_map_protected(kvm, ipa, pfn, map_size, memcache);
> +}

I was trying to understand (with the help of some LLMs) to understand
whether we can end up on the do_gpf() path as a result of VMM actions.
The above kvm_realm_is_private_address() only checks for the IPA but
does not check against guestmem if the page is truly private. I probably
miss something but the scenario would be something like:

1. VMM creates the gmem region with GUEST_MEMFD_FLAG_MMAP |
   GUEST_MEMFD_FLAG_INIT_SHARED, mmap()able and GUP-pinnable

2. VMM starts an O_DIRECT write() from that mapping; the block layer
   FOLL_PINs the shared folio

3. VMM runs a vCPU so the realm touches the protected-IPA alias of the
   same gfn. gmem_abort() delegates the pinned, still-shared page to
   the RMM

4. The in-flight I/O then reads the now-Realm page from the kernel
   linear map. That access takes a GPF at EL1, so do_gpf() ->
   die_kernel_fault()

x86, IIUC, also checks kvm_gmem_is_private(). They also have
kvm_arch_gmem_make_private() triggered on the kvm_gmem_get_pfn() path
but I got lost in the call sites, not sure whether that's strictly
needed if we check both private IPA and kvm_gmem_is_private().

-- 
Catalin
