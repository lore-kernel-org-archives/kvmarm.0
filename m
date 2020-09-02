Return-Path: <SRS0=SHPB=CL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23ED0C433E6
	for <kvmarm@archiver.kernel.org>; Wed,  2 Sep 2020 06:40:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 97B4620758
	for <kvmarm@archiver.kernel.org>; Wed,  2 Sep 2020 06:40:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R4u7OgY+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 97B4620758
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 236974B210;
	Wed,  2 Sep 2020 02:40:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KgMZ6nJVex3m; Wed,  2 Sep 2020 02:40:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C06FD4B1F4;
	Wed,  2 Sep 2020 02:40:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 611374B1E4
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2020 02:40:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id djZs9OU7tze3 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Sep 2020 02:40:12 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 32B6A4B1E2
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2020 02:40:12 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1599028812;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=tgrlGxdrvM8uJv8i/HBzwz3RVf5rBosWTxZvDHQbaCs=;
 b=R4u7OgY+kPdIxLjlAplr+TXRVzhh+rEUoC6kNv8G3P2n1k92DGYH89oQdtusacN0R8FYgi
 i9ZwNLA0CBsr4o/hqiQc46UkpLSX1Gn7JplQ+bx9M3SFfJXmAn+CI2pzv1IYkmvC91mN0w
 p3dpDqqfWjTegpZr3RPCULCrP+haBKM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-K4Z35uSrNimFcl2HQuMqfw-1; Wed, 02 Sep 2020 02:40:10 -0400
X-MC-Unique: K4Z35uSrNimFcl2HQuMqfw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 95EB61084C84;
 Wed,  2 Sep 2020 06:40:08 +0000 (UTC)
Received: from [10.64.54.147] (vpn2-54-147.bne.redhat.com [10.64.54.147])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B4F9710098AC;
 Wed,  2 Sep 2020 06:40:05 +0000 (UTC)
Subject: Re: [PATCH v3 05/21] KVM: arm64: Add support for creating
 kernel-agnostic stage-2 page tables
To: Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
References: <20200825093953.26493-1-will@kernel.org>
 <20200825093953.26493-6-will@kernel.org>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <e0b07673-bc32-95e4-be7a-382c80240000@redhat.com>
Date: Wed, 2 Sep 2020 16:40:03 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200825093953.26493-6-will@kernel.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
> Introduce alloc() and free() functions to the generic page-table code
> for guest stage-2 page-tables and plumb these into the existing KVM
> page-table allocator. Subsequent patches will convert other operations
> within the KVM allocator over to the generic code.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Quentin Perret <qperret@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>   arch/arm64/include/asm/kvm_host.h    |  1 +
>   arch/arm64/include/asm/kvm_pgtable.h | 18 +++++++++
>   arch/arm64/kvm/hyp/pgtable.c         | 51 ++++++++++++++++++++++++++
>   arch/arm64/kvm/mmu.c                 | 55 +++++++++++++++-------------
>   4 files changed, 99 insertions(+), 26 deletions(-)
> 

With the following one question resolved:

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index e52c927aade5..0b7c702b2151 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -81,6 +81,7 @@ struct kvm_s2_mmu {
>   	 */
>   	pgd_t		*pgd;
>   	phys_addr_t	pgd_phys;
> +	struct kvm_pgtable *pgt;
>   
>   	/* The last vcpu id that ran on each physical CPU */
>   	int __percpu *last_vcpu_ran;
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 2af84ab78cb8..3389f978d573 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -116,6 +116,24 @@ void kvm_pgtable_hyp_destroy(struct kvm_pgtable *pgt);
>   int kvm_pgtable_hyp_map(struct kvm_pgtable *pgt, u64 addr, u64 size, u64 phys,
>   			enum kvm_pgtable_prot prot);
>   
> +/**
> + * kvm_pgtable_stage2_init() - Initialise a guest stage-2 page-table.
> + * @pgt:	Uninitialised page-table structure to initialise.
> + * @kvm:	KVM structure representing the guest virtual machine.
> + *
> + * Return: 0 on success, negative error code on failure.
> + */
> +int kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm *kvm);
> +
> +/**
> + * kvm_pgtable_stage2_destroy() - Destroy an unused guest stage-2 page-table.
> + * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
> + *
> + * The page-table is assumed to be unreachable by any hardware walkers prior
> + * to freeing and therefore no TLB invalidation is performed.
> + */
> +void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
> +
>   /**
>    * kvm_pgtable_walk() - Walk a page-table.
>    * @pgt:	Page-table structure initialised by kvm_pgtable_*_init().
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index d75166823ad9..b8550ccaef4d 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -419,3 +419,54 @@ void kvm_pgtable_hyp_destroy(struct kvm_pgtable *pgt)
>   	free_page((unsigned long)pgt->pgd);
>   	pgt->pgd = NULL;
>   }
> +
> +int kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm *kvm)
> +{
> +	size_t pgd_sz;
> +	u64 vtcr = kvm->arch.vtcr;
> +	u32 ia_bits = VTCR_EL2_IPA(vtcr);
> +	u32 sl0 = FIELD_GET(VTCR_EL2_SL0_MASK, vtcr);
> +	u32 start_level = VTCR_EL2_TGRAN_SL0_BASE - sl0;
> +
> +	pgd_sz = kvm_pgd_pages(ia_bits, start_level) * PAGE_SIZE;
> +	pgt->pgd = alloc_pages_exact(pgd_sz, GFP_KERNEL | __GFP_ZERO);
> +	if (!pgt->pgd)
> +		return -ENOMEM;
> +
> +	pgt->ia_bits		= ia_bits;
> +	pgt->start_level	= start_level;
> +	pgt->mmu		= &kvm->arch.mmu;
> +	return 0;
> +}
> +
> +static int stage2_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> +			      enum kvm_pgtable_walk_flags flag,
> +			      void * const arg)
> +{
> +	kvm_pte_t pte = *ptep;
> +
> +	if (!kvm_pte_valid(pte))
> +		return 0;
> +
> +	put_page(virt_to_page(ptep));
> +
> +	if (kvm_pte_table(pte, level))
> +		free_page((unsigned long)kvm_pte_follow(pte));
> +
> +	return 0;
> +}
> +
> +void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
> +{
> +	size_t pgd_sz;
> +	struct kvm_pgtable_walker walker = {
> +		.cb	= stage2_free_walker,
> +		.flags	= KVM_PGTABLE_WALK_LEAF |
> +			  KVM_PGTABLE_WALK_TABLE_POST,
> +	};
> +
> +	WARN_ON(kvm_pgtable_walk(pgt, 0, BIT(pgt->ia_bits), &walker));
> +	pgd_sz = kvm_pgd_pages(pgt->ia_bits, pgt->start_level) * PAGE_SIZE;
> +	free_pages_exact(pgt->pgd, pgd_sz);
> +	pgt->pgd = NULL;
> +}
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index fabd72b0c8a4..4607e9ca60a2 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -668,47 +668,49 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
>    * @kvm:	The pointer to the KVM structure
>    * @mmu:	The pointer to the s2 MMU structure
>    *
> - * Allocates only the stage-2 HW PGD level table(s) of size defined by
> - * stage2_pgd_size(mmu->kvm).
> - *
> + * Allocates only the stage-2 HW PGD level table(s).
>    * Note we don't need locking here as this is only called when the VM is
>    * created, which can only be done once.
>    */
>   int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
>   {
> -	phys_addr_t pgd_phys;
> -	pgd_t *pgd;
> -	int cpu;
> +	int cpu, err;
> +	struct kvm_pgtable *pgt;
>   
> -	if (mmu->pgd != NULL) {
> +	if (mmu->pgt != NULL) {
>   		kvm_err("kvm_arch already initialized?\n");
>   		return -EINVAL;
>   	}
>   
> -	/* Allocate the HW PGD, making sure that each page gets its own refcount */
> -	pgd = alloc_pages_exact(stage2_pgd_size(kvm), GFP_KERNEL | __GFP_ZERO);
> -	if (!pgd)
> +	pgt = kzalloc(sizeof(*pgt), GFP_KERNEL);
> +	if (!pgt)
>   		return -ENOMEM;
>   
> -	pgd_phys = virt_to_phys(pgd);
> -	if (WARN_ON(pgd_phys & ~kvm_vttbr_baddr_mask(kvm)))
> -		return -EINVAL;
> +	err = kvm_pgtable_stage2_init(pgt, kvm);
> +	if (err)
> +		goto out_free_pgtable;
>   
>   	mmu->last_vcpu_ran = alloc_percpu(typeof(*mmu->last_vcpu_ran));
>   	if (!mmu->last_vcpu_ran) {
> -		free_pages_exact(pgd, stage2_pgd_size(kvm));
> -		return -ENOMEM;
> +		err = -ENOMEM;
> +		goto out_destroy_pgtable;
>   	}
>   
>   	for_each_possible_cpu(cpu)
>   		*per_cpu_ptr(mmu->last_vcpu_ran, cpu) = -1;
>   
>   	mmu->kvm = kvm;
> -	mmu->pgd = pgd;
> -	mmu->pgd_phys = pgd_phys;
> +	mmu->pgt = pgt;
> +	mmu->pgd_phys = __pa(pgt->pgd);
> +	mmu->pgd = (void *)pgt->pgd;
>   	mmu->vmid.vmid_gen = 0;
> -
>   	return 0;
> +
> +out_destroy_pgtable:
> +	kvm_pgtable_stage2_destroy(pgt);
> +out_free_pgtable:
> +	kfree(pgt);
> +	return err;
>   }
>

kvm_pgtable_stage2_destroy() might not needed here because
the stage2 page pgtable is empty so far. However, it should
be rare to hit the case. If I'm correct, what we need to do
is just freeing the PGDs.

    
>   static void stage2_unmap_memslot(struct kvm *kvm,
> @@ -781,20 +783,21 @@ void stage2_unmap_vm(struct kvm *kvm)
>   void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>   {
>   	struct kvm *kvm = mmu->kvm;
> -	void *pgd = NULL;
> +	struct kvm_pgtable *pgt = NULL;
>   
>   	spin_lock(&kvm->mmu_lock);
> -	if (mmu->pgd) {
> -		unmap_stage2_range(mmu, 0, kvm_phys_size(kvm));
> -		pgd = READ_ONCE(mmu->pgd);
> +	pgt = mmu->pgt;
> +	if (pgt) {
>   		mmu->pgd = NULL;
> +		mmu->pgd_phys = 0;
> +		mmu->pgt = NULL;
> +		free_percpu(mmu->last_vcpu_ran);
>   	}
>   	spin_unlock(&kvm->mmu_lock);
>   
> -	/* Free the HW pgd, one page at a time */
> -	if (pgd) {
> -		free_pages_exact(pgd, stage2_pgd_size(kvm));
> -		free_percpu(mmu->last_vcpu_ran);
> +	if (pgt) {
> +		kvm_pgtable_stage2_destroy(pgt);
> +		kfree(pgt);
>   	}
>   }
>   

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
