Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A978C433DB
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 09:46:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A933964EAE
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 09:46:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A933964EAE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C4294B4EA;
	Mon, 15 Mar 2021 05:46:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tezjHAfsdAGk; Mon, 15 Mar 2021 05:46:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 18D444B4FE;
	Mon, 15 Mar 2021 05:46:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C6CC4B4EA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 05:46:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xPngR-DoNw8e for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 05:46:39 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EB3A4B421
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 05:46:39 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1615801599;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=WY2MxEFcVlULLMgxUmbdvrWVsJ3NRRAN+UTOLbgUHmA=;
 b=CFP99p2MtmJyNpJHXw4ETP5KUiluhusioIj5c79lOFF2ySqKvjAgqtixJ2lGgmlnKGbZm7
 UC4VaxgFVYDRZq6cxpwmlWtNo4hpELLCu0/RZ6PurMIsUREXALgcjLZGmUx0v2C4SbYTFH
 iEa+uf8rJS7JYHAyVfrUpS0zRkr4NUI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-xbVeZD4HMweo1KXZ7TSTFA-1; Mon, 15 Mar 2021 05:46:37 -0400
X-MC-Unique: xbVeZD4HMweo1KXZ7TSTFA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CCCA51084D68;
 Mon, 15 Mar 2021 09:46:35 +0000 (UTC)
Received: from [10.64.54.175] (vpn2-54-175.bne.redhat.com [10.64.54.175])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BA7A3620DE;
 Mon, 15 Mar 2021 09:46:33 +0000 (UTC)
Subject: Re: [PATCH 3/4] KVM: arm64: Fix address check for memory slot
To: Keqian Zhu <zhukeqian1@huawei.com>, kvmarm@lists.cs.columbia.edu
References: <20210315041844.64915-1-gshan@redhat.com>
 <20210315041844.64915-4-gshan@redhat.com>
 <be57b9fb-89c4-9c32-f273-9f4bbe973b00@huawei.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <b7aaa914-04f7-4560-4a53-393adaccd27d@redhat.com>
Date: Mon, 15 Mar 2021 20:46:30 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <be57b9fb-89c4-9c32-f273-9f4bbe973b00@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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

On 3/15/21 6:33 PM, Keqian Zhu wrote:
> FYI, this has been fixed by Marc in commit 262b003d059c.
> 

Yeah, I didn't check 5.12.rc3 code where the issue has been
fixed. So please ignore this one and sorry for the noise.

Thanks,
Gavin
  
> On 2021/3/15 12:18, Gavin Shan wrote:
>> The last (IPA) page can't be specified when a new memory slot is
>> added. The error -EFAULT is returned when the memory slot is added
>> with the following parameters for the VM, which has 40-bits IPA
>> limit. The host has 4KB base page size. It's not correct because
>> the last (IPA) page is still usable.
>>
>>     struct kvm_userspace_memory_region {
>>        __u32 slot;               /* 1            */
>>        __u32 flags;              /* 0            */
>>        __u64 guest_phys_addr;    /* 0xfffffff000 */
>>        __u64 memory_size;        /* 0x1000       */
>>        __u64 userspace_addr;
>>     };
>>
>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>> ---
>>   arch/arm64/kvm/mmu.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 286b603ed0d3..a5a8ade9fde4 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -1313,7 +1313,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>>   	 * Prevent userspace from creating a memory region outside of the IPA
>>   	 * space addressable by the KVM guest IPA space.
>>   	 */
>> -	if (memslot->base_gfn + memslot->npages >=
>> +	if (memslot->base_gfn + memslot->npages >
>>   	    (kvm_phys_size(kvm) >> PAGE_SHIFT))
>>   		return -EFAULT;
>>   
>>
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
