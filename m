Return-Path: <SRS0=WLU+=EB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F582C4363A
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 23:41:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A8CD620872
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 23:41:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NwCjfTbZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A8CD620872
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 05B384B5DB;
	Mon, 26 Oct 2020 19:41:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LLkqJ9ARxzbE; Mon, 26 Oct 2020 19:41:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E63B4B5AE;
	Mon, 26 Oct 2020 19:41:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BBC24B5AE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 19:41:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cxoBxyYsKkah for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Oct 2020 19:41:41 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C6F54B5AC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 19:41:41 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1603755701;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=eqhUzpDgmZzHwVTuBPIMNGx8fot3k7kWpKeE4mXcmAI=;
 b=NwCjfTbZY07irqVBsfpS1qdtZyVCvHTX21iCxNcmQPbDqsqIwqQVGIj72Qiw8BCVzd8ngd
 03/ZAuwf5fw/7GEgMVFHULopGshGTjDUzxuVB4+EoK29PAHrhyzsHBCnRR7b+PhjJ1LaKA
 UhuaO0dx6mWlVGT1AMxEWkuBIMOKWjU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-Ka65l9qJOm6fTvu_PMmsFA-1; Mon, 26 Oct 2020 19:41:39 -0400
X-MC-Unique: Ka65l9qJOm6fTvu_PMmsFA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EFB761009E36;
 Mon, 26 Oct 2020 23:41:37 +0000 (UTC)
Received: from [10.64.54.78] (vpn2-54-78.bne.redhat.com [10.64.54.78])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9276C5D9CA;
 Mon, 26 Oct 2020 23:41:36 +0000 (UTC)
Subject: Re: [PATCH] KVM: arm64: Allocate stage-2 pgd pages with
 GFP_KERNEL_ACCOUNT
To: Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
References: <20201026144423.24683-1-will@kernel.org>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <962c401d-4376-7ecf-1a8b-b6ad91ecfe68@redhat.com>
Date: Tue, 27 Oct 2020 10:41:33 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20201026144423.24683-1-will@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=gshan@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com
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

On 10/27/20 1:44 AM, Will Deacon wrote:
> For consistency with the rest of the stage-2 page-table page allocations
> (performing using a kvm_mmu_memory_cache), ensure that __GFP_ACCOUNT is
> included in the GFP flags for the PGD pages.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Quentin Perret <qperret@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>   arch/arm64/kvm/hyp/pgtable.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 

The patch itself looks good to me:

Reviewed-by: Gavin Shan <gshan@redhat.com>

Another question is why the page-table pages for hyp mode aren't
allocated with __GFP_ACCOUNT in kvm_pgtable_hyp_init and hyp_map_walker()?
The page-table pages for host or guest are allocated with GFP_PGTABLE_USER
in alloc_pte_one().

#define GFP_PGTABLE_USER      (GFP_PGTABLE_KERNEL | __GFP_ACCOUNT)
#define GFP_PGTABLE_KERNEL    (GFP_KERNEL | __GFP_ZERO)

Cheers,
Gavin

> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 0cdf6e461cbd..95141b0d6088 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -846,7 +846,7 @@ int kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm *kvm)
>   	u32 start_level = VTCR_EL2_TGRAN_SL0_BASE - sl0;
>   
>   	pgd_sz = kvm_pgd_pages(ia_bits, start_level) * PAGE_SIZE;
> -	pgt->pgd = alloc_pages_exact(pgd_sz, GFP_KERNEL | __GFP_ZERO);
> +	pgt->pgd = alloc_pages_exact(pgd_sz, GFP_KERNEL_ACCOUNT | __GFP_ZERO);
>   	if (!pgt->pgd)
>   		return -ENOMEM;
>   
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
