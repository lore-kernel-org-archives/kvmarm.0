Return-Path: <SRS0=oSDe=EA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 552B4C4363A
	for <kvmarm@archiver.kernel.org>; Sun, 25 Oct 2020 22:23:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AC5C4207C3
	for <kvmarm@archiver.kernel.org>; Sun, 25 Oct 2020 22:23:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J2UH7HSE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AC5C4207C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0118D4BAB9;
	Sun, 25 Oct 2020 18:23:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id s0XXSyNN0fK1; Sun, 25 Oct 2020 18:23:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC1984BAC8;
	Sun, 25 Oct 2020 18:23:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3ABC84BAB9
 for <kvmarm@lists.cs.columbia.edu>; Sun, 25 Oct 2020 18:23:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id C6WVvJcCbwlc for <kvmarm@lists.cs.columbia.edu>;
 Sun, 25 Oct 2020 18:23:40 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AC2B4BA2A
 for <kvmarm@lists.cs.columbia.edu>; Sun, 25 Oct 2020 18:23:40 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1603664619;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Knz5z/9c0D7sKmx0JVXHqKCTNlD5WcWiwXXiyziSRaQ=;
 b=J2UH7HSEIygLlMVjV9e0xSiQb5RrMad+Q33yGXjP4gCl2UvARYn8OxEQ/c5TuqW/iCkmgX
 bGXOGPY/g9lP5JVMvDnCWnPMuGviD6qljXDn9rTY6r1JzYqQeEsEKEYq7wBNhu49xL7DSt
 u/0XQW/1lI+jVPgNncFCWRz5PJECd9o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-246-LWPRSDNYMKuzKqqkToLHPQ-1; Sun, 25 Oct 2020 18:23:37 -0400
X-MC-Unique: LWPRSDNYMKuzKqqkToLHPQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6ECB08049D0;
 Sun, 25 Oct 2020 22:23:36 +0000 (UTC)
Received: from [10.64.54.35] (vpn2-54-35.bne.redhat.com [10.64.54.35])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B2EBE6EF42;
 Sun, 25 Oct 2020 22:23:34 +0000 (UTC)
Subject: Re: [PATCH 1/3] KVM: arm64: Check if 52-bits PA is enabled
To: Marc Zyngier <maz@kernel.org>
References: <20201025002739.5804-1-gshan@redhat.com>
 <20201025002739.5804-2-gshan@redhat.com> <871rhmpr92.wl-maz@kernel.org>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <333451bd-4730-4ebb-f76c-28fa5d0e1f7d@redhat.com>
Date: Mon, 26 Oct 2020 09:23:31 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <871rhmpr92.wl-maz@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Cc: will@kernel.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
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

Hi Marc,

On 10/25/20 8:52 PM, Marc Zyngier wrote:
> On Sun, 25 Oct 2020 01:27:37 +0100,
> Gavin Shan <gshan@redhat.com> wrote:
>>
>> The 52-bits physical address is disabled until CONFIG_ARM64_PA_BITS_52
>> is chosen. This uses option for that check, to avoid the unconditional
>> check on PAGE_SHIFT in the hot path and thus save some CPU cycles.
> 
> PAGE_SHIFT is known at compile time, and this code is dropped by the
> compiler if the selected page size is not 64K. This patch really only
> makes the code slightly less readable and the "CPU cycles" argument
> doesn't hold at all.
> 
> So what are you trying to solve exactly?
> 

There are two points covered by the patch: (1) The 52-bits physical address
is visible only when CONFIG_ARM64_PA_BITS_52 is enabled in arch/arm64 code.
The code looks consistent with this option used here. (2) I had the assumption
that gcc doesn't optimize the code and PAGE_SHIFT is always checked in order
to get higher 4 physical address bits, but you said gcc should optimize the
code accordingly. However, it would be still nice to make the code explicit.

Thanks,
Gavin

>>
>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>> ---
>>   arch/arm64/kvm/hyp/pgtable.c | 10 ++++++----
>>   1 file changed, 6 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
>> index 0cdf6e461cbd..fd850353ee89 100644
>> --- a/arch/arm64/kvm/hyp/pgtable.c
>> +++ b/arch/arm64/kvm/hyp/pgtable.c
>> @@ -132,8 +132,9 @@ static u64 kvm_pte_to_phys(kvm_pte_t pte)
>>   {
>>   	u64 pa = pte & KVM_PTE_ADDR_MASK;
>>   
>> -	if (PAGE_SHIFT == 16)
>> -		pa |= FIELD_GET(KVM_PTE_ADDR_51_48, pte) << 48;
>> +#ifdef CONFIG_ARM64_PA_BITS_52
>> +	pa |= FIELD_GET(KVM_PTE_ADDR_51_48, pte) << 48;
>> +#endif
>>   
>>   	return pa;
>>   }
>> @@ -142,8 +143,9 @@ static kvm_pte_t kvm_phys_to_pte(u64 pa)
>>   {
>>   	kvm_pte_t pte = pa & KVM_PTE_ADDR_MASK;
>>   
>> -	if (PAGE_SHIFT == 16)
>> -		pte |= FIELD_PREP(KVM_PTE_ADDR_51_48, pa >> 48);
>> +#ifdef CONFIG_ARM64_PA_BITS_52
>> +	pte |= FIELD_PREP(KVM_PTE_ADDR_51_48, pa >> 48);
>> +#endif
>>   
>>   	return pte;
>>   }
>> -- 
>> 2.23.0
>>
>>
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
