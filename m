Return-Path: <SRS0=ROvZ=CM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B6ADC433E2
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 06:05:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6350C20758
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 06:05:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GdX1gJOt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6350C20758
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C07C54B180;
	Thu,  3 Sep 2020 02:05:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FIZ9r0KF2I2K; Thu,  3 Sep 2020 02:05:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 75D714B134;
	Thu,  3 Sep 2020 02:05:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B27E74B112
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 02:05:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1IXsZnAsYbWz for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2020 02:05:21 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A4D8F4B0BA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 02:05:21 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1599113121;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=0zmRK1VDBtKihvK7EFCYUI69rIgn2xm0JRbgclboctE=;
 b=GdX1gJOt3z5Pht2vMLTrDdfkwTkC1/ZE66pKYB2dQ9T62ZmXkk7VM9Ws4rm8/3EhrM8+QS
 TqczV2Wj3SORZ+LSA0kMsx7CzxXOaV/E3b+nPDWMYY7jRvk98V3hAAUFXjLyDhmB1He14s
 hi/uvOurA7A+89K6g4+V3bfbvS3MbcM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-66-j0eppuLlM12MXrx-rR9n3A-1; Thu, 03 Sep 2020 02:05:19 -0400
X-MC-Unique: j0eppuLlM12MXrx-rR9n3A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E73B1393B1;
 Thu,  3 Sep 2020 06:05:17 +0000 (UTC)
Received: from [10.64.54.159] (vpn2-54-159.bne.redhat.com [10.64.54.159])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 265FF19C71;
 Thu,  3 Sep 2020 06:05:14 +0000 (UTC)
Subject: Re: [PATCH v3 17/21] KVM: arm64: Convert user_mem_abort() to generic
 page-table API
To: Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
References: <20200825093953.26493-1-will@kernel.org>
 <20200825093953.26493-18-will@kernel.org>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <1dd58be7-75d8-1b7f-0eb2-d93b57bdcecd@redhat.com>
Date: Thu, 3 Sep 2020 16:05:12 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200825093953.26493-18-will@kernel.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=gshan@redhat.com
X-Mimecast-Spam-Score: 0.002
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 kernel-team@android.com, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Gavin Shan <gshan@redhat.com>
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Will,

On 8/25/20 7:39 PM, Will Deacon wrote:
> Convert user_mem_abort() to call kvm_pgtable_stage2_relax_perms() when
> handling a stage-2 permission fault and kvm_pgtable_stage2_map() when
> handling a stage-2 translation fault, rather than walking the page-table
> manually.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Quentin Perret <qperret@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>   arch/arm64/kvm/mmu.c | 112 +++++++++++++------------------------------
>   1 file changed, 34 insertions(+), 78 deletions(-)
> 

I looks good to me. As it's changing the stage2 page table management
mechanism completely. I will test this series with various configuration
on different machines. I will update the result when it's finished.

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index d4b0716a6ab4..cfbf32cae3a5 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1491,7 +1491,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   {
>   	int ret;
>   	bool write_fault, writable, force_pte = false;
> -	bool exec_fault, needs_exec;
> +	bool exec_fault;
> +	bool device = false;
>   	unsigned long mmu_seq;
>   	gfn_t gfn = fault_ipa >> PAGE_SHIFT;
>   	struct kvm *kvm = vcpu->kvm;
> @@ -1499,10 +1500,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   	struct vm_area_struct *vma;
>   	short vma_shift;
>   	kvm_pfn_t pfn;
> -	pgprot_t mem_type = PAGE_S2;
>   	bool logging_active = memslot_is_logging(memslot);
> -	unsigned long vma_pagesize, flags = 0;
> -	struct kvm_s2_mmu *mmu = vcpu->arch.hw_mmu;
> +	unsigned long vma_pagesize;
> +	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
> +	struct kvm_pgtable *pgt;
>   
>   	write_fault = kvm_is_write_fault(vcpu);
>   	exec_fault = kvm_vcpu_trap_is_iabt(vcpu);
> @@ -1535,22 +1536,16 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   		vma_pagesize = PAGE_SIZE;
>   	}
>   
> -	/*
> -	 * The stage2 has a minimum of 2 level table (For arm64 see
> -	 * kvm_arm_setup_stage2()). Hence, we are guaranteed that we can
> -	 * use PMD_SIZE huge mappings (even when the PMD is folded into PGD).
> -	 * As for PUD huge maps, we must make sure that we have at least
> -	 * 3 levels, i.e, PMD is not folded.
> -	 */
> -	if (vma_pagesize == PMD_SIZE ||
> -	    (vma_pagesize == PUD_SIZE && kvm_stage2_has_pmd(kvm)))
> +	if (vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE)
>   		gfn = (fault_ipa & huge_page_mask(hstate_vma(vma))) >> PAGE_SHIFT;
>   	mmap_read_unlock(current->mm);
>   
> -	/* We need minimum second+third level pages */
> -	ret = kvm_mmu_topup_memory_cache(memcache, kvm_mmu_cache_min_pages(kvm));
> -	if (ret)
> -		return ret;
> +	if (fault_status != FSC_PERM) {
> +		ret = kvm_mmu_topup_memory_cache(memcache,
> +						 kvm_mmu_cache_min_pages(kvm));
> +		if (ret)
> +			return ret;
> +	}
>   
>   	mmu_seq = vcpu->kvm->mmu_notifier_seq;
>   	/*
> @@ -1573,28 +1568,20 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   		return -EFAULT;
>   
>   	if (kvm_is_device_pfn(pfn)) {
> -		mem_type = PAGE_S2_DEVICE;
> -		flags |= KVM_S2PTE_FLAG_IS_IOMAP;
> -	} else if (logging_active) {
> -		/*
> -		 * Faults on pages in a memslot with logging enabled
> -		 * should not be mapped with huge pages (it introduces churn
> -		 * and performance degradation), so force a pte mapping.
> -		 */
> -		flags |= KVM_S2_FLAG_LOGGING_ACTIVE;
> -
> +		device = true;
> +	} else if (logging_active && !write_fault) {
>   		/*
>   		 * Only actually map the page as writable if this was a write
>   		 * fault.
>   		 */
> -		if (!write_fault)
> -			writable = false;
> +		writable = false;
>   	}
>   
> -	if (exec_fault && is_iomap(flags))
> +	if (exec_fault && device)
>   		return -ENOEXEC;
>   
>   	spin_lock(&kvm->mmu_lock);
> +	pgt = vcpu->arch.hw_mmu->pgt;
>   	if (mmu_notifier_retry(kvm, mmu_seq))
>   		goto out_unlock;
>   
> @@ -1605,62 +1592,31 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   	if (vma_pagesize == PAGE_SIZE && !force_pte)
>   		vma_pagesize = transparent_hugepage_adjust(memslot, hva,
>   							   &pfn, &fault_ipa);
> -	if (writable)
> +	if (writable) {
> +		prot |= KVM_PGTABLE_PROT_W;
>   		kvm_set_pfn_dirty(pfn);
> +		mark_page_dirty(kvm, gfn);
> +	}
>   
> -	if (fault_status != FSC_PERM && !is_iomap(flags))
> +	if (fault_status != FSC_PERM && !device)
>   		clean_dcache_guest_page(pfn, vma_pagesize);
>   
> -	if (exec_fault)
> +	if (exec_fault) {
> +		prot |= KVM_PGTABLE_PROT_X;
>   		invalidate_icache_guest_page(pfn, vma_pagesize);
> +	}
>   
> -	/*
> -	 * If we took an execution fault we have made the
> -	 * icache/dcache coherent above and should now let the s2
> -	 * mapping be executable.
> -	 *
> -	 * Write faults (!exec_fault && FSC_PERM) are orthogonal to
> -	 * execute permissions, and we preserve whatever we have.
> -	 */
> -	needs_exec = exec_fault ||
> -		(fault_status == FSC_PERM &&
> -		 stage2_is_exec(mmu, fault_ipa, vma_pagesize));
> -
> -	if (vma_pagesize == PUD_SIZE) {
> -		pud_t new_pud = kvm_pfn_pud(pfn, mem_type);
> -
> -		new_pud = kvm_pud_mkhuge(new_pud);
> -		if (writable)
> -			new_pud = kvm_s2pud_mkwrite(new_pud);
> -
> -		if (needs_exec)
> -			new_pud = kvm_s2pud_mkexec(new_pud);
> -
> -		ret = stage2_set_pud_huge(mmu, memcache, fault_ipa, &new_pud);
> -	} else if (vma_pagesize == PMD_SIZE) {
> -		pmd_t new_pmd = kvm_pfn_pmd(pfn, mem_type);
> -
> -		new_pmd = kvm_pmd_mkhuge(new_pmd);
> -
> -		if (writable)
> -			new_pmd = kvm_s2pmd_mkwrite(new_pmd);
> -
> -		if (needs_exec)
> -			new_pmd = kvm_s2pmd_mkexec(new_pmd);
> +	if (device)
> +		prot |= KVM_PGTABLE_PROT_DEVICE;
> +	else if (cpus_have_const_cap(ARM64_HAS_CACHE_DIC))
> +		prot |= KVM_PGTABLE_PROT_X;
>   
> -		ret = stage2_set_pmd_huge(mmu, memcache, fault_ipa, &new_pmd);
> +	if (fault_status == FSC_PERM) {
> +		ret = kvm_pgtable_stage2_relax_perms(pgt, fault_ipa, prot);
>   	} else {
> -		pte_t new_pte = kvm_pfn_pte(pfn, mem_type);
> -
> -		if (writable) {
> -			new_pte = kvm_s2pte_mkwrite(new_pte);
> -			mark_page_dirty(kvm, gfn);
> -		}
> -
> -		if (needs_exec)
> -			new_pte = kvm_s2pte_mkexec(new_pte);
> -
> -		ret = stage2_set_pte(mmu, memcache, fault_ipa, &new_pte, flags);
> +		ret = kvm_pgtable_stage2_map(pgt, fault_ipa, vma_pagesize,
> +					     __pfn_to_phys(pfn), prot,
> +					     memcache);
>   	}
>   
>   out_unlock:
> 

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
