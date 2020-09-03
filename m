Return-Path: <SRS0=ROvZ=CM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44DF7C433E7
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 04:47:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C49842086A
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 04:47:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AmI/ayh8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C49842086A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1487B4B37D;
	Thu,  3 Sep 2020 00:47:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SsesynmL3LIk; Thu,  3 Sep 2020 00:47:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EE5E14B376;
	Thu,  3 Sep 2020 00:47:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C79004B374
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 00:47:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DYTNjxFUGnC2 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2020 00:47:36 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC2D54B373
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 00:47:36 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1599108456;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=3Ii4iCvgxDZT75qhYiW/32ZMtqw1Jk0DnTURd8h9mAE=;
 b=AmI/ayh8wONk6iCMKed0VI8e8OBw/eA7TuFhDw6o+pIL0AvXA2vSzjX09myzXAKIeug6ZS
 OoXGVa7AUDblbj0hUkV/pbLWmdsGxXFttg5or0AmdLm6j1gcqlugeXOngOOp4jrzwFysio
 b1xlqruzOgboZEikt0s4ZqouHMitv0Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-495-HBghU85tO7ewevn4Bdy59g-1; Thu, 03 Sep 2020 00:47:33 -0400
X-MC-Unique: HBghU85tO7ewevn4Bdy59g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E54932FD01;
 Thu,  3 Sep 2020 04:47:30 +0000 (UTC)
Received: from [10.64.54.159] (vpn2-54-159.bne.redhat.com [10.64.54.159])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 86FA85D9CC;
 Thu,  3 Sep 2020 04:47:28 +0000 (UTC)
Subject: Re: [PATCH v3 12/21] KVM: arm64: Add support for stage-2
 write-protect in generic page-table
To: Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
References: <20200825093953.26493-1-will@kernel.org>
 <20200825093953.26493-13-will@kernel.org>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <6808aab5-3d50-6233-6077-6813ab3abdab@redhat.com>
Date: Thu, 3 Sep 2020 14:47:25 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200825093953.26493-13-will@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
> Add a stage-2 wrprotect() operation to the generic page-table code.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Quentin Perret <qperret@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---

Reviewed-by: Gavin Shan <gshan@redhat.com>

>   arch/arm64/include/asm/kvm_pgtable.h | 15 +++++++++++++++
>   arch/arm64/kvm/hyp/pgtable.c         |  6 ++++++
>   2 files changed, 21 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index ae56534f87a0..0c96b78d791d 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -173,6 +173,21 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
>    */
>   int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size);
>   
> +/**
> + * kvm_pgtable_stage2_wrprotect() - Write-protect guest stage-2 address range
> + *                                  without TLB invalidation.
> + * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
> + * @addr:	Intermediate physical address from which to write-protect,
> + * @size:	Size of the range.
> + *
> + * Note that it is the caller's responsibility to invalidate the TLB after
> + * calling this function to ensure that the updated permissions are visible
> + * to the CPUs.
> + *
> + * Return: 0 on success, negative error code on failure.
> + */
> +int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size);
> +
>   /**
>    * kvm_pgtable_stage2_mkyoung() - Set the access flag in a page-table entry.
>    * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 30713eb773e0..c218651f8eba 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -726,6 +726,12 @@ static int stage2_update_leaf_attrs(struct kvm_pgtable *pgt, u64 addr,
>   	return 0;
>   }
>   
> +int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
> +{
> +	return stage2_update_leaf_attrs(pgt, addr, size, 0,
> +					KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W, NULL);
> +}
> +
>   kvm_pte_t kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr)
>   {
>   	kvm_pte_t pte = 0;
> 

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
