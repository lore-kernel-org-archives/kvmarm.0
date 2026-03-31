Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B0EE3C5529
	for <kvmarm@lists.linux.dev>; Tue, 31 Mar 2026 07:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774942099; cv=none; b=BxCIuepvAUZQqd+a1UwHAlfbEC5z03fQ4nltMIzVcdHF4M5AwxOT0LW72OmOfL+tsZyIpTbQ7/hXc/PXwcgtR0++7e3JhrIpYSlLcuEOQ+Dzu9RY79SUj4MCcM7xhMzltxnx4qvcHU9/YANbaAXj7gUbuEd8iMSIA2gP7pUcemM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774942099; c=relaxed/simple;
	bh=kdsJ3g2eaTU1MECoZPvu7qbxM61nRqIBwKT0qvl9+ss=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XupHxgys96fJWXgO7JvzV+FX7JtbmdmUAnCWg3kj+n8DV7xiq9ev+iyRqdaoWBLbkWuxX24OAk+9tuR/vp186l3vtil56mQ36DvhqYJoDtzsdJFBKgYoHZV6kWKZB1j9qknKMtnZwCiQj3REBzvlZV5fyGfKA8OuuC+zCQDwL4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=cGVNBoiP; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="cGVNBoiP"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0802A495B;
	Tue, 31 Mar 2026 00:28:12 -0700 (PDT)
Received: from [10.57.18.211] (unknown [10.57.18.211])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8AED53F641;
	Tue, 31 Mar 2026 00:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774942097; bh=kdsJ3g2eaTU1MECoZPvu7qbxM61nRqIBwKT0qvl9+ss=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cGVNBoiPOj2/VMnLTabPEgViojzmPo93OiL/bnktpqu9ikVoEnTLDlnE+CS2qsq3G
	 5xySVo0MjOdfU81Qs7NPVclPT+EEHn5v/ayPXJKWuiwvdITGmqRG90JWKH10y1wYzr
	 ehLh2htBIOVdb3UWpT9KB1eOZSCSJ1D8k5wOYPdY=
Message-ID: <2f4e1c85-b124-4b4c-a3b6-c8d8784e6418@arm.com>
Date: Tue, 31 Mar 2026 12:58:11 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 14/30] KVM: arm64: Kill fault->ipa
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>,
 Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <tabba@google.com>,
 Will Deacon <will@kernel.org>, Quentin Perret <qperret@google.com>
References: <20260327113618.4051534-1-maz@kernel.org>
 <20260327113618.4051534-15-maz@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20260327113618.4051534-15-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 27/03/26 5:06 PM, Marc Zyngier wrote:
> fault->ipa, in a nested contest, represents the output of the guest's
> S2 translation for the fault->fault_ipa input, and is equal to
> fault->fault_ipa otherwise,
> 
> Given that this is readily available from kvm_s2_trans_output(),
> drop fault->ipa and directly compute fault->gfn instead, which
> is really what we want.
> 
> Tested-by: Fuad Tabba <tabba@google.com>
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
>  arch/arm64/kvm/mmu.c | 14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index c6cd6ce5254be..67e5e867e01dc 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1643,7 +1643,7 @@ static short kvm_s2_resolve_vma_size(struct vm_area_struct *vma,
>  				     unsigned long hva,
>  				     struct kvm_memory_slot *memslot,
>  				     struct kvm_s2_trans *nested,
> -				     bool *force_pte, phys_addr_t *ipa)
> +				     bool *force_pte)
>  {
>  	short vma_shift;
>  
> @@ -1681,8 +1681,6 @@ static short kvm_s2_resolve_vma_size(struct vm_area_struct *vma,
>  
>  		max_map_size = *force_pte ? PAGE_SIZE : PUD_SIZE;
>  
> -		*ipa = kvm_s2_trans_output(nested);
> -
>  		/*
>  		 * If we're about to create a shadow stage 2 entry, then we
>  		 * can only create a block mapping if the guest stage 2 page
> @@ -1722,7 +1720,6 @@ struct kvm_s2_fault {
>  	bool is_vma_cacheable;
>  	bool s2_force_noncacheable;
>  	unsigned long mmu_seq;
> -	phys_addr_t ipa;
>  	gfn_t gfn;
>  	kvm_pfn_t pfn;
>  	bool logging_active;
> @@ -1738,6 +1735,7 @@ static int kvm_s2_fault_get_vma_info(struct kvm_s2_fault *fault)
>  {
>  	struct vm_area_struct *vma;
>  	struct kvm *kvm = fault->vcpu->kvm;
> +	phys_addr_t ipa;
>  
>  	mmap_read_lock(current->mm);
>  	vma = vma_lookup(current->mm, fault->hva);
> @@ -1748,8 +1746,7 @@ static int kvm_s2_fault_get_vma_info(struct kvm_s2_fault *fault)
>  	}
>  
>  	fault->vma_pagesize = 1UL << kvm_s2_resolve_vma_size(vma, fault->hva, fault->memslot,
> -							     fault->nested, &fault->force_pte,
> -							     &fault->ipa);
> +							     fault->nested, &fault->force_pte);
>  
>  	/*
>  	 * Both the canonical IPA and fault IPA must be aligned to the
> @@ -1757,9 +1754,9 @@ static int kvm_s2_fault_get_vma_info(struct kvm_s2_fault *fault)
>  	 * mapping in the right place.
>  	 */
>  	fault->fault_ipa = ALIGN_DOWN(fault->fault_ipa, fault->vma_pagesize);
> -	fault->ipa = ALIGN_DOWN(fault->ipa, fault->vma_pagesize);
> +	ipa = fault->nested ? kvm_s2_trans_output(fault->nested) : fault->fault_ipa;
> +	fault->gfn = ALIGN_DOWN(ipa, fault->vma_pagesize) >> PAGE_SHIFT;
>  
> -	fault->gfn = fault->ipa >> PAGE_SHIFT;
>  	fault->mte_allowed = kvm_vma_mte_allowed(vma);
>  
>  	fault->vm_flags = vma->vm_flags;
> @@ -1970,7 +1967,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  		.memslot = memslot,
>  		.hva = hva,
>  		.fault_is_perm = fault_is_perm,
> -		.ipa = fault_ipa,
>  		.logging_active = logging_active,
>  		.force_pte = logging_active,
>  		.prot = KVM_PGTABLE_PROT_R,

