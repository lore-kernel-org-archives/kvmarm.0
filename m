Return-Path: <SRS0=ROvZ=CM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA5F6C433E7
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 04:48:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8F94420758
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 04:48:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TRAsi6j3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8F94420758
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 47E944B375;
	Thu,  3 Sep 2020 00:48:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eKrHWSH7725w; Thu,  3 Sep 2020 00:48:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 31C0C4B377;
	Thu,  3 Sep 2020 00:48:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CC1E4B375
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 00:48:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6Q9YBVq2ouz1 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2020 00:48:20 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 406484B373
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 00:48:20 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1599108500;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=RaRK6IoNigCyUTE6ipvVMWhIBIxjySekjs53LtKvKeY=;
 b=TRAsi6j3H+HNbimFHcrBcMojjinvN49UX17pA0jjFNrpCcDF85JrlNCyJuUHzU9RcrW6py
 ZxThdMYAU5Ixa6GwqnNm/eRY09rkcDOotpSebaiFauwGsV4PY9LEl7I4LyBUW0ZCjGYOaz
 m40J7QhjQ8s0VGYYkms86mBjExk4aCw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-551-nqzRkKVkNsmjEtXa8HuwTw-1; Thu, 03 Sep 2020 00:48:16 -0400
X-MC-Unique: nqzRkKVkNsmjEtXa8HuwTw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 88FD3393B1;
 Thu,  3 Sep 2020 04:48:14 +0000 (UTC)
Received: from [10.64.54.159] (vpn2-54-159.bne.redhat.com [10.64.54.159])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 76BE25C1D7;
 Thu,  3 Sep 2020 04:48:12 +0000 (UTC)
Subject: Re: [PATCH v3 13/21] KVM: arm64: Convert write-protect operation to
 generic page-table API
To: Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
References: <20200825093953.26493-1-will@kernel.org>
 <20200825093953.26493-14-will@kernel.org>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <ab66870d-47b0-8c35-5c5c-fe25a90f37e6@redhat.com>
Date: Thu, 3 Sep 2020 14:48:10 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200825093953.26493-14-will@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
> Convert stage2_wp_range() to call the kvm_pgtable_stage2_wrprotect()
> function of the generic page-table code instead of walking the page-table
> directly.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Quentin Perret <qperret@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>   arch/arm64/kvm/mmu.c | 25 ++++---------------------
>   1 file changed, 4 insertions(+), 21 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index d3db8e00ce0a..ca2c37c91e0b 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -66,6 +66,9 @@ static bool is_iomap(unsigned long flags)
>   	ret;								\
>   })
>   
> +#define stage2_apply_range_resched(kvm, addr, end, fn)			\
> +	stage2_apply_range(kvm, addr, end, fn, true)
> +
>   static bool memslot_is_logging(struct kvm_memory_slot *memslot)
>   {
>   	return memslot->dirty_bitmap && !(memslot->flags & KVM_MEM_READONLY);
> @@ -1294,27 +1297,7 @@ static void  stage2_wp_p4ds(struct kvm_s2_mmu *mmu, pgd_t *pgd,
>   static void stage2_wp_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end)
>   {
>   	struct kvm *kvm = mmu->kvm;
> -	pgd_t *pgd;
> -	phys_addr_t next;
> -
> -	pgd = mmu->pgd + stage2_pgd_index(kvm, addr);
> -	do {
> -		/*
> -		 * Release kvm_mmu_lock periodically if the memory region is
> -		 * large. Otherwise, we may see kernel panics with
> -		 * CONFIG_DETECT_HUNG_TASK, CONFIG_LOCKUP_DETECTOR,
> -		 * CONFIG_LOCKDEP. Additionally, holding the lock too long
> -		 * will also starve other vCPUs. We have to also make sure
> -		 * that the page tables are not freed while we released
> -		 * the lock.
> -		 */
> -		cond_resched_lock(&kvm->mmu_lock);
> -		if (!READ_ONCE(mmu->pgd))
> -			break;
> -		next = stage2_pgd_addr_end(kvm, addr, end);
> -		if (stage2_pgd_present(kvm, *pgd))
> -			stage2_wp_p4ds(mmu, pgd, addr, next);
> -	} while (pgd++, addr = next, addr != end);
> +	stage2_apply_range_resched(kvm, addr, end, kvm_pgtable_stage2_wrprotect);
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
