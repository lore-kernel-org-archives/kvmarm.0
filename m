Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2EF9C433E0
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 09:42:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1505764EB1
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 09:42:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1505764EB1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 853984B4AD;
	Mon, 15 Mar 2021 05:42:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6e3B9XIFRk9U; Mon, 15 Mar 2021 05:42:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E3164B51F;
	Mon, 15 Mar 2021 05:42:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 544D74B4BD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 05:42:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id usD1ASDthjs2 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 05:42:14 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F7844B4AD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 05:42:14 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1615801334;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=J9jrtmDC/sgF925/5dmbQo+IJ37BsuIDvNzAC14K3Bc=;
 b=NVgZ/rapGKVURSwGoRX7Yqd0oYBf4/eHSh//nMVamO2T0iA+0bS/VQVDiq/Uc+XQhG27F0
 6uDCG5dfz4CR4ny7UYLwDFkM4z2sxhEW0Us/BIqIEfHhrbLcV2ZXCmCRnQxjJHRhZ7IiKu
 u4oQplBdTrd9DOApQxz65DNi2IfbMrA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-MKfbU30gPv6a6bW-bwiwbw-1; Mon, 15 Mar 2021 05:42:12 -0400
X-MC-Unique: MKfbU30gPv6a6bW-bwiwbw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B1C7B64AD5;
 Mon, 15 Mar 2021 09:42:10 +0000 (UTC)
Received: from [10.64.54.175] (vpn2-54-175.bne.redhat.com [10.64.54.175])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6DCC92B162;
 Mon, 15 Mar 2021 09:42:08 +0000 (UTC)
Subject: Re: [PATCH 2/4] KVM: arm64: Use find_vma_intersection()
To: Keqian Zhu <zhukeqian1@huawei.com>, kvmarm@lists.cs.columbia.edu
References: <20210315041844.64915-1-gshan@redhat.com>
 <20210315041844.64915-3-gshan@redhat.com>
 <65dfdca3-af94-7d5a-86fe-24825301655b@huawei.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <2eef2b42-13bd-2414-f748-551039677bf5@redhat.com>
Date: Mon, 15 Mar 2021 20:42:06 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <65dfdca3-af94-7d5a-86fe-24825301655b@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Cc: maz@kernel.org, will@kernel.org, linux-kernel@vger.kernel.org,
 shan.gavin@gmail.com
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

Hi Keqian,

On 3/15/21 7:04 PM, Keqian Zhu wrote:
> On 2021/3/15 12:18, Gavin Shan wrote:
>> find_vma_intersection() has been existing to search the intersected
>> vma. This uses the function where it's applicable, to simplify the
>> code.
>>
>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>> ---
>>   arch/arm64/kvm/mmu.c | 10 ++++++----
>>   1 file changed, 6 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 84e70f953de6..286b603ed0d3 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -421,10 +421,11 @@ static void stage2_unmap_memslot(struct kvm *kvm,
>>   	 *     +--------------------------------------------+
>>   	 */
>>   	do {
>> -		struct vm_area_struct *vma = find_vma(current->mm, hva);
>> +		struct vm_area_struct *vma;
>>   		hva_t vm_start, vm_end;
>>   
>> -		if (!vma || vma->vm_start >= reg_end)
>> +		vma = find_vma_intersection(current->mm, hva, reg_end);
> Nit: Keep a same style may be better(Assign vma when declare it).
> Other looks good to me.
> 

Yeah, I agree. I will adjust the code in v2 and included your r-b.
Thanks for your time to review.

Thanks,
Gavin

  
>> +		if (!vma)
>>   			break;
>>   
>>   		/*
>> @@ -1330,10 +1331,11 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>>   	 *     +--------------------------------------------+
>>   	 */
>>   	do {
>> -		struct vm_area_struct *vma = find_vma(current->mm, hva);
>> +		struct vm_area_struct *vma;
>>   		hva_t vm_start, vm_end;
>>   
>> -		if (!vma || vma->vm_start >= reg_end)
>> +		vma = find_vma_intersection(current->mm, hva, reg_end);
>> +		if (!vma)
>>   			break;
>>   
>>   		/*
>>
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
