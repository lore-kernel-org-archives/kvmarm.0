Return-Path: <SRS0=MITk=7J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00955C433E2
	for <kvmarm@archiver.kernel.org>; Wed, 27 May 2020 07:18:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AF14F208FE
	for <kvmarm@archiver.kernel.org>; Wed, 27 May 2020 07:18:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JZ19YhfL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AF14F208FE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C82A4B1E3;
	Wed, 27 May 2020 03:18:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QX0N89efelEC; Wed, 27 May 2020 03:18:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C92404B214;
	Wed, 27 May 2020 03:18:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3927C4B1BA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 May 2020 23:01:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bKUVfiVJJHvc for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 May 2020 23:01:43 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C60E4B1A7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 May 2020 23:01:43 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1590548503;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Cpbim3FlbcrNy7gJlhAHb6/Vs/A9UAxM9oWCouCSNuc=;
 b=JZ19YhfL4pmGfiioBsWXM15cgmwRgaOMPxhssGfaD7mhBxMzv3qkYiVfXbMkH/DvQRvUY4
 W1qasf8zoQCE7h9zRDdXIyQXP2CrbkfDUfOpGKWsBbwMCE3noglLHL1BxTgTN0g9iIEK3b
 oAQpcUo5hBX4wLRe/Jn810C0hTfAdzc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-262-Q6siw2vvNzC2MrlGNtVjmw-1; Tue, 26 May 2020 23:01:40 -0400
X-MC-Unique: Q6siw2vvNzC2MrlGNtVjmw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2DA15801503;
 Wed, 27 May 2020 03:01:39 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-130.bne.redhat.com
 [10.64.54.130])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 476AE5D9E5;
 Wed, 27 May 2020 03:01:32 +0000 (UTC)
Subject: Re: [PATCH RFCv2 6/9] kvm/arm64: Export kvm_handle_user_mem_abort()
 with prefault mode
To: Mark Rutland <mark.rutland@arm.com>
References: <20200508032919.52147-1-gshan@redhat.com>
 <20200508032919.52147-7-gshan@redhat.com>
 <20200526105807.GE1363@C02TD0UTHF1T.local>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <8d758b47-3fb0-ee70-700f-fa8af407c115@redhat.com>
Date: Wed, 27 May 2020 13:01:29 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200526105807.GE1363@C02TD0UTHF1T.local>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Mailman-Approved-At: Wed, 27 May 2020 03:18:39 -0400
Cc: catalin.marinas@arm.com, linux-kernel@vger.kernel.org, shan.gavin@gmail.com,
 maz@kernel.org, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Hi Mark,

On 5/26/20 8:58 PM, Mark Rutland wrote:
> On Fri, May 08, 2020 at 01:29:16PM +1000, Gavin Shan wrote:
>> This renames user_mem_abort() to kvm_handle_user_mem_abort(), and
>> then export it. The function will be used in asynchronous page fault
>> to populate a page table entry once the corresponding page is populated
>> from the backup device (e.g. swap partition):
>>
>>     * Parameter @fault_status is replace by @esr.
>>     * The parameters are reorder based on their importance.
> 
> It seems like multiple changes are going on here, and it would be
> clearer with separate patches.
> 
> Passing the ESR rather than the extracted fault status seems fine, but
> for clarirty it's be nicer to do this in its own patch.
> 

Ok. I'll have a separate patch to do this.

> Why is it necessary to re-order the function parameters? Does that align
> with other function prototypes?
> 

There are no explicit reasons for it. I can restore the order to what we
had previously if you like.

> What exactly is the `prefault` parameter meant to do? It doesn't do
> anything currently, so it'd be better to introduce it later when logic
> using it is instroduced, or where callers will pass distinct values.
> 

Yes, fair enough. I will merge the logic with PATCH[7] then.

> Thanks,
> Mark.
> 

Thanks,
Gavin

>>
>> This shouldn't cause any functional changes.
>>
>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>> ---
>>   arch/arm64/include/asm/kvm_host.h |  4 ++++
>>   virt/kvm/arm/mmu.c                | 14 ++++++++------
>>   2 files changed, 12 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 32c8a675e5a4..f77c706777ec 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -437,6 +437,10 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
>>   			      struct kvm_vcpu_events *events);
>>   
>>   #define KVM_ARCH_WANT_MMU_NOTIFIER
>> +int kvm_handle_user_mem_abort(struct kvm_vcpu *vcpu, unsigned int esr,
>> +			      struct kvm_memory_slot *memslot,
>> +			      phys_addr_t fault_ipa, unsigned long hva,
>> +			      bool prefault);
>>   int kvm_unmap_hva_range(struct kvm *kvm,
>>   			unsigned long start, unsigned long end);
>>   int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
>> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
>> index e462e0368fd9..95aaabb2b1fc 100644
>> --- a/virt/kvm/arm/mmu.c
>> +++ b/virt/kvm/arm/mmu.c
>> @@ -1656,12 +1656,12 @@ static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
>>   	       (hva & ~(map_size - 1)) + map_size <= uaddr_end;
>>   }
>>   
>> -static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>> -			  struct kvm_memory_slot *memslot, unsigned long hva,
>> -			  unsigned long fault_status)
>> +int kvm_handle_user_mem_abort(struct kvm_vcpu *vcpu, unsigned int esr,
>> +			      struct kvm_memory_slot *memslot,
>> +			      phys_addr_t fault_ipa, unsigned long hva,
>> +			      bool prefault)
>>   {
>> -	int ret;
>> -	u32 esr = kvm_vcpu_get_esr(vcpu);
>> +	unsigned int fault_status = kvm_vcpu_trap_get_fault_type(esr);
>>   	bool write_fault, writable, force_pte = false;
>>   	bool exec_fault, needs_exec;
>>   	unsigned long mmu_seq;
>> @@ -1674,6 +1674,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>   	pgprot_t mem_type = PAGE_S2;
>>   	bool logging_active = memslot_is_logging(memslot);
>>   	unsigned long vma_pagesize, flags = 0;
>> +	int ret;
>>   
>>   	write_fault = kvm_is_write_fault(esr);
>>   	exec_fault = kvm_vcpu_trap_is_iabt(esr);
>> @@ -1995,7 +1996,8 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
>>   		goto out_unlock;
>>   	}
>>   
>> -	ret = user_mem_abort(vcpu, fault_ipa, memslot, hva, fault_status);
>> +	ret = kvm_handle_user_mem_abort(vcpu, esr, memslot,
>> +					fault_ipa, hva, false);
>>   	if (ret == 0)
>>   		ret = 1;
>>   out:
>> -- 
>> 2.23.0
>>
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
