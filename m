Return-Path: <SRS0=SHPB=CL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.4 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C0B0C433E6
	for <kvmarm@archiver.kernel.org>; Wed,  2 Sep 2020 00:57:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 704FE206EF
	for <kvmarm@archiver.kernel.org>; Wed,  2 Sep 2020 00:57:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AV+gKTSr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 704FE206EF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D94D4B186;
	Tue,  1 Sep 2020 20:57:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ySTVPokU6nVP; Tue,  1 Sep 2020 20:57:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 907664B178;
	Tue,  1 Sep 2020 20:57:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EB054B141
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Sep 2020 20:57:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iGIxRdRBY6iE for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Sep 2020 20:57:28 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 204634B140
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Sep 2020 20:57:28 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1599008247;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=0AV/T2u1f98roGh/3/tKuFH1AKZXTucTwPPAsuYXRGI=;
 b=AV+gKTSr8ZAj9GbARGQM4LvBUSpBLGTagoHI2OZzp92/W2qbFFnfsNRYmJ9j02Dp5FeRmu
 Q5Mxa3niRuBS0x79i0palbeAD3/7QuzFiRiaJAfW6fYEjbWYnRNiacZyMnzMRquzbR4stE
 oodO2SKqcxyz9mgYzcm/vnCBjwzfyLo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-PDF6Y4MkNFm5No1CK3cYyw-1; Tue, 01 Sep 2020 20:57:26 -0400
X-MC-Unique: PDF6Y4MkNFm5No1CK3cYyw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0B41110059A7;
 Wed,  2 Sep 2020 00:57:25 +0000 (UTC)
Received: from [10.64.54.147] (vpn2-54-147.bne.redhat.com [10.64.54.147])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 914207A4D0;
 Wed,  2 Sep 2020 00:57:23 +0000 (UTC)
Subject: Re: [PATCH 1/2] KVM: arm64: Update page shift if stage 2 block
 mapping not supported
To: Alexandru Elisei <alexandru.elisei@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
References: <20200901133357.52640-1-alexandru.elisei@arm.com>
 <20200901133357.52640-2-alexandru.elisei@arm.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <99cba8bb-65bf-ee95-5bb9-fb084491acdb@redhat.com>
Date: Wed, 2 Sep 2020 10:57:20 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200901133357.52640-2-alexandru.elisei@arm.com>
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

On 9/1/20 11:33 PM, Alexandru Elisei wrote:
> Commit 196f878a7ac2e (" KVM: arm/arm64: Signal SIGBUS when stage2 discovers
> hwpoison memory") modifies user_mem_abort() to send a SIGBUS signal when
> the fault IPA maps to a hwpoisoned page. Commit 1559b7583ff6 ("KVM:
> arm/arm64: Re-check VMA on detecting a poisoned page") changed
> kvm_send_hwpoison_signal() to use the page shift instead of the VMA because
> at that point the code had already released the mmap lock, which means
> userspace could have modified the VMA.
> 
> If userspace uses hugetlbfs for the VM memory, user_mem_abort() tries to
> map the guest fault IPA using block mappings in stage 2. That is not always
> possible, if, for example, userspace uses dirty page logging for the VM.
> Update the page shift appropriately in those cases when we downgrade the
> stage 2 entry from a block mapping to a page.
> 
> Fixes: 1559b7583ff6 ("KVM: arm/arm64: Re-check VMA on detecting a poisoned page")
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---

Reviewed-by: Gavin Shan <gshan@redhat.com>

>   arch/arm64/kvm/mmu.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index ba00bcc0c884..25e7dc52c086 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1877,6 +1877,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   	    !fault_supports_stage2_huge_mapping(memslot, hva, vma_pagesize)) {
>   		force_pte = true;
>   		vma_pagesize = PAGE_SIZE;
> +		vma_shift = PAGE_SHIFT;
>   	}
>   
>   	/*
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
