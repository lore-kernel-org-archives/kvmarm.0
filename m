Return-Path: <SRS0=ROvZ=CM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41CA3C433E7
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 04:52:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 95E3520758
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 04:52:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cNDkH8Vj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 95E3520758
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 215144B38E;
	Thu,  3 Sep 2020 00:52:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Q92Ocv1r9BNt; Thu,  3 Sep 2020 00:52:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC6944B35B;
	Thu,  3 Sep 2020 00:52:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC1624B188
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 00:52:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U7Pv-91dAP8g for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2020 00:52:39 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E78E14B185
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 00:52:39 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1599108759;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=VWOp+tbzrhGchlgmDS2K9OH8i1hhwUvJ5w+LB5PcuWs=;
 b=cNDkH8Vji4jng6P/6qUd4CsyM6scTPXBKIPYsFYLL3782deHlt5fZEYpnvhConiyLzqflf
 wKtp3ESlftKEmim8r1lBhqq8zO5mZ9K7J1Er3WaA1S/BmmDFxG9buOISeyKYJ/ME3OBppd
 Rv7H44O9hlS/wmMkW5f9kKc9v8CefIw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-RQqsrtfFMC6ObPdVPUm_cQ-1; Thu, 03 Sep 2020 00:52:36 -0400
X-MC-Unique: RQqsrtfFMC6ObPdVPUm_cQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6FB201005E66;
 Thu,  3 Sep 2020 04:52:34 +0000 (UTC)
Received: from [10.64.54.159] (vpn2-54-159.bne.redhat.com [10.64.54.159])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 112685D6C4;
 Thu,  3 Sep 2020 04:52:31 +0000 (UTC)
Subject: Re: [PATCH v3 15/21] KVM: arm64: Convert memslot cache-flushing code
 to generic page-table API
To: Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
References: <20200825093953.26493-1-will@kernel.org>
 <20200825093953.26493-16-will@kernel.org>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <48972757-449f-292e-3b56-86a67549dbb9@redhat.com>
Date: Thu, 3 Sep 2020 14:52:30 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200825093953.26493-16-will@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
> Convert stage2_flush_memslot() to call the kvm_pgtable_stage2_flush()
> function of the generic page-table code instead of walking the page-table
> directly.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Quentin Perret <qperret@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>   arch/arm64/kvm/mmu.c | 13 +------------
>   1 file changed, 1 insertion(+), 12 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index ca2c37c91e0b..d4b0716a6ab4 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -455,21 +455,10 @@ static void stage2_flush_p4ds(struct kvm_s2_mmu *mmu, pgd_t *pgd,
>   static void stage2_flush_memslot(struct kvm *kvm,
>   				 struct kvm_memory_slot *memslot)
>   {
> -	struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
>   	phys_addr_t addr = memslot->base_gfn << PAGE_SHIFT;
>   	phys_addr_t end = addr + PAGE_SIZE * memslot->npages;
> -	phys_addr_t next;
> -	pgd_t *pgd;
> -
> -	pgd = mmu->pgd + stage2_pgd_index(kvm, addr);
> -	do {
> -		next = stage2_pgd_addr_end(kvm, addr, end);
> -		if (!stage2_pgd_none(kvm, *pgd))
> -			stage2_flush_p4ds(mmu, pgd, addr, next);
>   
> -		if (next != end)
> -			cond_resched_lock(&kvm->mmu_lock);
> -	} while (pgd++, addr = next, addr != end);
> +	stage2_apply_range_resched(kvm, addr, end, kvm_pgtable_stage2_flush);
>   }
>   
>   /**
> 

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
