Return-Path: <SRS0=ROvZ=CM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1F20C433E7
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 04:51:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 82D5C207EA
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 04:51:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NDDNxijQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 82D5C207EA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D91624B386;
	Thu,  3 Sep 2020 00:51:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BAXVBwbCjet4; Thu,  3 Sep 2020 00:51:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B6BEA4B35B;
	Thu,  3 Sep 2020 00:51:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC5E34B35B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 00:51:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DG-GO01mKK2v for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2020 00:51:38 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B29D4B358
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 00:51:38 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1599108697;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Wx7Sf2jiqMwz4nA+ZdJ2baGrDsy8YEPatdEPEvnHUgo=;
 b=NDDNxijQccCZUcQLJWcbhXP+Q/gI7POvJwn0UFQewiRjUs5LciSWogZZKUdIuSI5qClR3e
 0L13dXstkRd99FF030yxwibcL6ByNTstf76jCdQw4gHAUmkOyxamTJcqwDiJttuNRQkF3c
 Uc1QSYOvDogL0rqx3QRmZ3GwIWEPbQ0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-575-W42ZzB2YMkyImn0yMjakcQ-1; Thu, 03 Sep 2020 00:51:35 -0400
X-MC-Unique: W42ZzB2YMkyImn0yMjakcQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 53866425D6;
 Thu,  3 Sep 2020 04:51:34 +0000 (UTC)
Received: from [10.64.54.159] (vpn2-54-159.bne.redhat.com [10.64.54.159])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2829D100EBB8;
 Thu,  3 Sep 2020 04:51:31 +0000 (UTC)
Subject: Re: [PATCH v3 14/21] KVM: arm64: Add support for stage-2 cache
 flushing in generic page-table
To: Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
References: <20200825093953.26493-1-will@kernel.org>
 <20200825093953.26493-15-will@kernel.org>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <4198f2f9-abaa-2755-0113-38384150b595@redhat.com>
Date: Thu, 3 Sep 2020 14:51:30 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200825093953.26493-15-will@kernel.org>
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
> From: Quentin Perret <qperret@google.com>
> 
> Add support for cache flushing a range of the stage-2 address space to
> the generic page-table code.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Quentin Perret <qperret@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---

Reviewed-by: Gavin Shan <gshan@redhat.com>

>   arch/arm64/include/asm/kvm_pgtable.h | 12 ++++++++++++
>   arch/arm64/kvm/hyp/pgtable.c         | 26 ++++++++++++++++++++++++++
>   2 files changed, 38 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 0c96b78d791d..ea823fe31913 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -226,6 +226,18 @@ kvm_pte_t kvm_pgtable_stage2_mkold(struct kvm_pgtable *pgt, u64 addr);
>    */
>   bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr);
>   
> +/**
> + * kvm_pgtable_stage2_flush_range() - Clean and invalidate data cache to Point
> + * 				      of Coherency for guest stage-2 address
> + *				      range.
> + * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
> + * @addr:	Intermediate physical address from which to flush.
> + * @size:	Size of the range.
> + *
> + * Return: 0 on success, negative error code on failure.
> + */
> +int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size);
> +
>   /**
>    * kvm_pgtable_walk() - Walk a page-table.
>    * @pgt:	Page-table structure initialised by kvm_pgtable_*_init().
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index c218651f8eba..75887185f1e2 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -762,6 +762,32 @@ bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr)
>   	return pte & KVM_PTE_LEAF_ATTR_LO_S2_AF;
>   }
>   
> +static int stage2_flush_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> +			       enum kvm_pgtable_walk_flags flag,
> +			       void * const arg)
> +{
> +	kvm_pte_t pte = *ptep;
> +
> +	if (!kvm_pte_valid(pte) || !stage2_pte_cacheable(pte))
> +		return 0;
> +
> +	stage2_flush_dcache(kvm_pte_follow(pte), kvm_granule_size(level));
> +	return 0;
> +}
> +
> +int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
> +{
> +	struct kvm_pgtable_walker walker = {
> +		.cb	= stage2_flush_walker,
> +		.flags	= KVM_PGTABLE_WALK_LEAF,
> +	};
> +
> +	if (cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
> +		return 0;
> +
> +	return kvm_pgtable_walk(pgt, addr, size, &walker);
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
