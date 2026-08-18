Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6875F45FFC7
	for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 13:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787061534; cv=none; b=r38n/Y4LO+2F1DRX41Fu4nGg4jAqED9vZN6KAOVZowr9h/WtGtScG1Q4Xbfe4ZpoHgtRMAFUtGdKv9rCmaDv/iUblR21h1J6t0SGeytoOJiBk9OhUVSEgEfAXsO34TpxMuXfRGUR1GaJLXmGDW8boEc979iEaa+5OzZ/JmnW3xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787061534; c=relaxed/simple;
	bh=RJwhCjqrCbt9M0yo9Rvdr5CE4QC1Jf39rkJUI4Tj/mc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Sz7Brcy4+b8usy5rY5RrDaq8bOkJgj8qAJzVzGJplio6+7SRYTAOHQuLnujF2LiH94PNmkTlzVSCUd1Pi+T8kyjTdgCaz4lHLDwNWSEUkamxTUnbzhsPfCIm+R/tCrUqNKt36oGbmARmE65k+vgUO7dY1pYmA/NXPgiWAiO09yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VZ/me3C5; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VZ/me3C5"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D574C1516;
	Tue, 18 Aug 2026 06:58:47 -0700 (PDT)
Received: from [10.1.39.73] (Suzukis-MBP.cambridge.arm.com [10.1.39.73])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B8FF73F763;
	Tue, 18 Aug 2026 06:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787061531; bh=RJwhCjqrCbt9M0yo9Rvdr5CE4QC1Jf39rkJUI4Tj/mc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VZ/me3C5HsiMSi4IcYdR6wkzPzScuNdM0BiwGpFpx7oYr20/dwUmFPQyK0L5zpBa1
	 uS87Q7ewcgQLHL0ctRGHiMdPWVFCmz5aTKuFFTiqaHgmclYMrt4P2017WEy0mPfmon
	 N/FEFkz4nk/kFB7OqodaQ3dil+5vcHsMGWWRoTgM=
Message-ID: <cb84c8ed-4279-478e-b9f3-ec137083d839@arm.com>
Date: Tue, 18 Aug 2026 14:58:46 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] KVM: guest_memfd: Stop returning struct page from
 PFN lookup
Content-Language: en-GB
To: Ackerley Tng <ackerleytng@google.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Ashish Kalra <ashish.kalra@amd.com>,
 Michael Roth <michael.roth@amd.com>, Brijesh Singh <brijesh.singh@amd.com>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
 Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 David Hildenbrand <david@kernel.org>, Fuad Tabba <tabba@google.com>,
 Yan Zhao <yan.y.zhao@intel.com>,
 "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 Vishal Annapurve <vannapurve@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
References: <20260818-gmem-no-return-page-v2-0-5298f42d49bb@google.com>
 <20260818-gmem-no-return-page-v2-4-5298f42d49bb@google.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260818-gmem-no-return-page-v2-4-5298f42d49bb@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18/08/2026 10:15, Ackerley Tng wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> KVM currently expects guest_memfd PFN lookups to return a refcounted
> struct page, which callers hold across fault handling.
> 
> Holding a page reference across fault handling is problematic for
> guest_memfd. In-place memory conversions between confidential
> computing shared and private states inspect folio refcounts to ensure
> exclusive ownership by guest_memfd. A concurrent guest page fault
> taking a reference on the folio causes conversions to fail due to an
> elevated refcount.
> 
> guest_memfd already notifies KVM of page invalidations, so callers
> within KVM only need to respect the MMU invalidation protocol to safely
> rely on guest_memfd for page presence.
> 
> Furthermore, removing struct page from the guest_memfd PFN lookup moves
> KVM closer toward supporting memory backends that are not backed by
> struct page.
> 
> Drop the folio reference immediately before returning from the
> guest_memfd PFN lookup, and stop returning the struct page pointer.
> 
> For ARM, initialize the local page pointer to NULL so that the shared
> cleanup path that releases fault-in pages safely no-ops for guest_memfd.
> 
> For x86, no additional changes are required in the MMU fault path
> because the page fault tracking structure is zero-initialized at the
> start of page fault handling, ensuring the refcounted page pointer is
> already NULL.
> 
> Reported-by: Yan Zhao <yan.y.zhao@intel.com>
> Closes: https://lore.kernel.org/all/anZ4W9o5pTWIEgMY@yzhao56-desk.sh.intel.com/
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
>   arch/arm64/kvm/mmu.c     | 4 ++--
>   arch/arm64/kvm/nested.c  | 4 ++--
>   arch/x86/kvm/mmu/mmu.c   | 2 +-
>   arch/x86/kvm/svm/sev.c   | 8 ++------
>   include/linux/kvm_host.h | 6 ++----
>   virt/kvm/guest_memfd.c   | 9 ++-------
>   6 files changed, 11 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 6c941aaa10c63..e5d637a5ec558 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1613,7 +1613,7 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
>   	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
>   	struct kvm_pgtable *pgt = s2fd->vcpu->arch.hw_mmu->pgt;
>   	unsigned long mmu_seq;
> -	struct page *page;
> +	struct page *page = NULL;
>   	struct kvm *kvm = s2fd->vcpu->kvm;
>   	void *memcache = NULL;
>   	kvm_pfn_t pfn;
> @@ -1641,7 +1641,7 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
>   	/* Pairs with the smp_wmb() in kvm_mmu_invalidate_end(). */
>   	smp_rmb();
>   
> -	ret = kvm_gmem_get_pfn(kvm, s2fd->memslot, gfn, &pfn, &page, NULL);
> +	ret = kvm_gmem_get_pfn(kvm, s2fd->memslot, gfn, &pfn, NULL);
>   	if (ret) {
>   		kvm_prepare_memory_fault_exit(s2fd->vcpu, s2fd->fault_ipa, PAGE_SIZE,
>   					      write_fault, exec_fault, false);

Since this function only deals with the gmem backed aborts, you could 
remove the variable and the call to kvm_release_faultin_page() below.


> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index fb54f6dad995c..43523bb17621a 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1360,7 +1360,7 @@ static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *is_gmem)
>   	bool write_fault, writable;
>   	unsigned long mmu_seq;
>   	struct vncr_tlb *vt;
> -	struct page *page;
> +	struct page *page = NULL;
>   	u64 va, pfn, gfn;
>   	int ret;
>   
> @@ -1411,7 +1411,7 @@ static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *is_gmem)
>   		if (is_error_noslot_pfn(pfn) || (write_fault && !writable))
>   			return -EFAULT;
>   	} else {
> -		ret = kvm_gmem_get_pfn(vcpu->kvm, memslot, gfn, &pfn, &page, NULL);
> +		ret = kvm_gmem_get_pfn(vcpu->kvm, memslot, gfn, &pfn, NULL);
>   		if (ret) {
>   			kvm_prepare_memory_fault_exit(vcpu, vt->wr.pa, PAGE_SIZE,
>   					      write_fault, false, false);

This is safe too, as we only use the page for 
kvm_release_faultin_page(), and it can tolerate a NULL page. So, this
looks fine to me.

With the cleanup above,

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

