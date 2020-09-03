Return-Path: <SRS0=ROvZ=CM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26FFBC433E2
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 04:33:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7206020716
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 04:33:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KnKqAu5E"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7206020716
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D38934B344;
	Thu,  3 Sep 2020 00:33:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JOnkn36eyrTN; Thu,  3 Sep 2020 00:33:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AA894B34E;
	Thu,  3 Sep 2020 00:33:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 995AA4B343
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 00:33:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id THID7vjl1y7u for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2020 00:33:30 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CF5E4B2C6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 00:33:30 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1599107610;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Vt7kfHGkGj9zGg+0//Wby/pFzlHEV7ADUQ2DWJ1V+M0=;
 b=KnKqAu5EkggVKCEzWJRHxNCdE766/O0URlhxVc972Ha6Msml3ME4CzmXxP4WeCgjI1wFDw
 HRlGIA0Sz7je9JOGaZjW54O4tMSUqhYQ3t6AUF9HVOsvKid/2j5hZret9+/HPPar5DI1zY
 29GS5YxnRcu85MHg2VGALjrufvKxJMo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-Qs2VcZiiNQCJnOGmj2DyWg-1; Thu, 03 Sep 2020 00:33:28 -0400
X-MC-Unique: Qs2VcZiiNQCJnOGmj2DyWg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2277618A2256;
 Thu,  3 Sep 2020 04:33:27 +0000 (UTC)
Received: from [10.64.54.159] (vpn2-54-159.bne.redhat.com [10.64.54.159])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8B3587EB72;
 Thu,  3 Sep 2020 04:33:24 +0000 (UTC)
Subject: Re: [PATCH v3 10/21] KVM: arm64: Add support for stage-2 page-aging
 in generic page-table
To: Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
References: <20200825093953.26493-1-will@kernel.org>
 <20200825093953.26493-11-will@kernel.org>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <cbf5a908-9e15-d0bb-459e-b5289d8a3ad8@redhat.com>
Date: Thu, 3 Sep 2020 14:33:22 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200825093953.26493-11-will@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
> Add stage-2 mkyoung(), mkold() and is_young() operations to the generic
> page-table code.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Quentin Perret <qperret@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>   arch/arm64/include/asm/kvm_pgtable.h | 38 ++++++++++++
>   arch/arm64/kvm/hyp/pgtable.c         | 86 ++++++++++++++++++++++++++++
>   2 files changed, 124 insertions(+)
> 

With the following one question resolved:

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 8ab0d5f43817..ae56534f87a0 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -173,6 +173,44 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
>    */
>   int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size);
>   
> +/**
> + * kvm_pgtable_stage2_mkyoung() - Set the access flag in a page-table entry.
> + * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
> + * @addr:	Intermediate physical address to identify the page-table entry.
> + *
> + * If there is a valid, leaf page-table entry used to translate @addr, then
> + * set the access flag in that entry.
> + *
> + * Return: The old page-table entry prior to setting the flag, 0 on failure.
> + */
> +kvm_pte_t kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr);
> +
> +/**
> + * kvm_pgtable_stage2_mkold() - Clear the access flag in a page-table entry.
> + * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
> + * @addr:	Intermediate physical address to identify the page-table entry.
> + *
> + * If there is a valid, leaf page-table entry used to translate @addr, then
> + * clear the access flag in that entry.
> + *
> + * Note that it is the caller's responsibility to invalidate the TLB after
> + * calling this function to ensure that the updated permissions are visible
> + * to the CPUs.
> + *
> + * Return: The old page-table entry prior to clearing the flag, 0 on failure.
> + */
> +kvm_pte_t kvm_pgtable_stage2_mkold(struct kvm_pgtable *pgt, u64 addr);
> +
> +/**
> + * kvm_pgtable_stage2_is_young() - Test whether a page-table entry has the
> + *				   access flag set.
> + * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
> + * @addr:	Intermediate physical address to identify the page-table entry.
> + *
> + * Return: True if the page-table entry has the access flag set, false otherwise.
> + */
> +bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr);
> +
>   /**
>    * kvm_pgtable_walk() - Walk a page-table.
>    * @pgt:	Page-table structure initialised by kvm_pgtable_*_init().
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 6f65d3841ec9..30713eb773e0 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -670,6 +670,92 @@ int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
>   	return kvm_pgtable_walk(pgt, addr, size, &walker);
>   }
>   
> +struct stage2_attr_data {
> +	kvm_pte_t	attr_set;
> +	kvm_pte_t	attr_clr;
> +	kvm_pte_t	pte;
> +};
> +
> +static int stage2_attr_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> +			      enum kvm_pgtable_walk_flags flag,
> +			      void * const arg)
> +{
> +	kvm_pte_t pte = *ptep;
> +	struct stage2_attr_data *data = arg;
> +
> +	if (!kvm_pte_valid(pte))
> +		return 0;
> +
> +	data->pte = pte;
> +	pte &= ~data->attr_clr;
> +	pte |= data->attr_set;
> +
> +	/*
> +	 * We may race with the CPU trying to set the access flag here,
> +	 * but worst-case the access flag update gets lost and will be
> +	 * set on the next access instead.
> +	 */
> +	if (data->pte != pte)
> +		WRITE_ONCE(*ptep, pte);
> +
> +	return 0;
> +}
> +
> +static int stage2_update_leaf_attrs(struct kvm_pgtable *pgt, u64 addr,
> +				    u64 size, kvm_pte_t attr_set,
> +				    kvm_pte_t attr_clr, kvm_pte_t *orig_pte)
> +{
> +	int ret;
> +	kvm_pte_t attr_mask = KVM_PTE_LEAF_ATTR_LO | KVM_PTE_LEAF_ATTR_HI;
> +	struct stage2_attr_data data = {
> +		.attr_set	= attr_set & attr_mask,
> +		.attr_clr	= attr_clr & attr_mask,
> +	};
> +	struct kvm_pgtable_walker walker = {
> +		.cb		= stage2_attr_walker,
> +		.arg		= &data,
> +		.flags		= KVM_PGTABLE_WALK_LEAF,
> +	};
> +
> +	ret = kvm_pgtable_walk(pgt, addr, size, &walker);
> +	if (ret)
> +		return ret;
> +
> +	if (orig_pte)
> +		*orig_pte = data.pte;
> +	return 0;
> +}
> +

The @size is always 1 from the caller, which means the parameter
can be dropped from stage2_update_leaf_attrs(). In the meanwhile,
we don't know the page is mapped by PUD, PMD or PTE. So to have
fixed value ("1") looks meaningless.

> +kvm_pte_t kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr)
> +{
> +	kvm_pte_t pte = 0;
> +	stage2_update_leaf_attrs(pgt, addr, 1, KVM_PTE_LEAF_ATTR_LO_S2_AF, 0,
> +				 &pte);
> +	dsb(ishst);
> +	return pte;
> +}
> +
> +kvm_pte_t kvm_pgtable_stage2_mkold(struct kvm_pgtable *pgt, u64 addr)
> +{
> +	kvm_pte_t pte = 0;
> +	stage2_update_leaf_attrs(pgt, addr, 1, 0, KVM_PTE_LEAF_ATTR_LO_S2_AF,
> +				 &pte);
> +	/*
> +	 * "But where's the TLBI?!", you scream.
> +	 * "Over in the core code", I sigh.
> +	 *
> +	 * See the '->clear_flush_young()' callback on the KVM mmu notifier.
> +	 */
> +	return pte;
> +}
> +
> +bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr)
> +{
> +	kvm_pte_t pte = 0;
> +	stage2_update_leaf_attrs(pgt, addr, 1, 0, 0, &pte);
> +	return pte & KVM_PTE_LEAF_ATTR_LO_S2_AF;
> +}
> +
>   int kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm *kvm)
>   {
>   	size_t pgd_sz;
> 

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
