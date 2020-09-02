Return-Path: <SRS0=SHPB=CL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.4 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 625C6C433E2
	for <kvmarm@archiver.kernel.org>; Wed,  2 Sep 2020 01:24:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BD52D20707
	for <kvmarm@archiver.kernel.org>; Wed,  2 Sep 2020 01:24:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EouGRqXF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BD52D20707
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DB0E4B113;
	Tue,  1 Sep 2020 21:24:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id d0kYQyNkaaJf; Tue,  1 Sep 2020 21:24:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D96B14B11A;
	Tue,  1 Sep 2020 21:24:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B04224B10B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Sep 2020 21:24:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3UsbPRVWDVXP for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Sep 2020 21:24:05 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D4D334B0F1
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Sep 2020 21:24:05 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1599009845;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Yyza65aQQadNjB0mPRwqYahaocEtubRJRsZxRQPWgwM=;
 b=EouGRqXF70ZHb785IOdZFpAh8M5K7k2Vgi85LMUORjFgJ1ghFaTijxwsNSOd6Em6nTqaA3
 fvg5lHNz9oBPUT2gjixhDeZ0mtcbEkJtftoCY0SMq2qOkWGrzE8VMvmgkVs8Lxf+//E4GE
 HBxqFaOpIHdS4lfn7QFu1D8Yex6lNac=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-vEwa94KrMGyZ1T6tctRvtg-1; Tue, 01 Sep 2020 21:24:03 -0400
X-MC-Unique: vEwa94KrMGyZ1T6tctRvtg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EE5641074644;
 Wed,  2 Sep 2020 01:24:01 +0000 (UTC)
Received: from [10.64.54.147] (vpn2-54-147.bne.redhat.com [10.64.54.147])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B053A78B40;
 Wed,  2 Sep 2020 01:24:00 +0000 (UTC)
Subject: Re: [PATCH 2/2] KVM: arm64: Try PMD block mappings if PUD mappings
 are not supported
To: Alexandru Elisei <alexandru.elisei@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
References: <20200901133357.52640-1-alexandru.elisei@arm.com>
 <20200901133357.52640-3-alexandru.elisei@arm.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <583211e4-b997-8539-6147-d86cc0cbdbb2@redhat.com>
Date: Wed, 2 Sep 2020 11:23:58 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200901133357.52640-3-alexandru.elisei@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=gshan@redhat.com
X-Mimecast-Spam-Score: 0.002
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: maz@kernel.org
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

Hi Alexandru,

On 9/1/20 11:33 PM, Alexandru Elisei wrote:
> When userspace uses hugetlbfs for the VM memory, user_mem_abort() tries to
> use the same block size to map the faulting IPA in stage 2. If stage 2
> cannot use the same size mapping because the block size doesn't fit in the
> memslot or the memslot is not properly aligned, user_mem_abort() will fall
> back to a page mapping, regardless of the block size. We can do better for
> PUD backed hugetlbfs by checking if a PMD block mapping is possible before
> deciding to use a page.
> 
> vma_pagesize is an unsigned long, use 1UL instead of 1ULL when assigning
> its value.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>   arch/arm64/kvm/mmu.c | 19 ++++++++++++++-----
>   1 file changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 25e7dc52c086..f590f7355cda 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1871,15 +1871,24 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   	else
>   		vma_shift = PAGE_SHIFT;
>   
> -	vma_pagesize = 1ULL << vma_shift;
>   	if (logging_active ||
> -	    (vma->vm_flags & VM_PFNMAP) ||
> -	    !fault_supports_stage2_huge_mapping(memslot, hva, vma_pagesize)) {
> +	    (vma->vm_flags & VM_PFNMAP)) {
>   		force_pte = true;
> -		vma_pagesize = PAGE_SIZE;
>   		vma_shift = PAGE_SHIFT;
>   	}
>  

It looks incorrect because @vma_pagesize wasn't initialized when
it's passed to fault_supports_stage2_huge_mapping() for the checking.
It's assumed you missed the following changes according to the commit
log:

    fault_supports_stage2_huge_mapping(memslot, hva, (1UL << vma_shift))
  
> +	if (vma_shift == PUD_SHIFT &&
> +	    !fault_supports_stage2_huge_mapping(memslot, hva, PUD_SIZE))
> +		vma_shift = PMD_SHIFT;
> +
> +	if (vma_shift == PMD_SHIFT &&
> +	    !fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE)) {
> +		force_pte = true;
> +		vma_shift = PAGE_SHIFT;
> +	}
> +
> +	vma_pagesize = 1UL << vma_shift;
> +>   	/*
>   	 * The stage2 has a minimum of 2 level table (For arm64 see
>   	 * kvm_arm_setup_stage2()). Hence, we are guaranteed that we can
> @@ -1889,7 +1898,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   	 */
>   	if (vma_pagesize == PMD_SIZE ||
>   	    (vma_pagesize == PUD_SIZE && kvm_stage2_has_pmd(kvm)))
> -		gfn = (fault_ipa & huge_page_mask(hstate_vma(vma))) >> PAGE_SHIFT;
> +		gfn = (fault_ipa & ~(vma_pagesize - 1)) >> PAGE_SHIFT;
>   	mmap_read_unlock(current->mm);
>   
>   	/* We need minimum second+third level pages */
> 

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
