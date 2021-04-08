Return-Path: <SRS0=McpZ=JF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D314EC433ED
	for <kvmarm@archiver.kernel.org>; Thu,  8 Apr 2021 09:31:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4CFF06113C
	for <kvmarm@archiver.kernel.org>; Thu,  8 Apr 2021 09:31:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4CFF06113C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB7D94B8A1;
	Thu,  8 Apr 2021 05:31:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id op8vGg7IyEkF; Thu,  8 Apr 2021 05:31:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9335B4B8A4;
	Thu,  8 Apr 2021 05:31:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 33EFB4B99F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Apr 2021 05:31:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id msOxi434IvpH for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Apr 2021 05:31:25 -0400 (EDT)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 375BD4B7E5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Apr 2021 05:31:25 -0400 (EDT)
Received: from DGGEML404-HUB.china.huawei.com (unknown [172.30.72.57])
 by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FGGBt1gFkzWVRR;
 Thu,  8 Apr 2021 17:27:50 +0800 (CST)
Received: from dggpemm500023.china.huawei.com (7.185.36.83) by
 DGGEML404-HUB.china.huawei.com (10.3.17.39) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Thu, 8 Apr 2021 17:31:19 +0800
Received: from [10.174.187.128] (10.174.187.128) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2106.2; Thu, 8 Apr 2021 17:31:18 +0800
Subject: Re: [RFC PATCH v3 2/2] KVM: arm64: Distinguish cases of memcache
 allocations completely
To: Alexandru Elisei <alexandru.elisei@arm.com>, Marc Zyngier
 <maz@kernel.org>, Will Deacon <will@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, <kvmarm@lists.cs.columbia.edu>,
 <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
References: <20210326031654.3716-1-wangyanan55@huawei.com>
 <20210326031654.3716-3-wangyanan55@huawei.com>
 <4348b555-2a38-6f00-8ef0-0d5fd801d753@arm.com>
From: "wangyanan (Y)" <wangyanan55@huawei.com>
Message-ID: <2f7872af-b5dc-9e81-574d-928849ad473c@huawei.com>
Date: Thu, 8 Apr 2021 17:31:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <4348b555-2a38-6f00-8ef0-0d5fd801d753@arm.com>
Content-Language: en-US
X-Originating-IP: [10.174.187.128]
X-ClientProxiedBy: dggeme704-chm.china.huawei.com (10.1.199.100) To
 dggpemm500023.china.huawei.com (7.185.36.83)
X-CFilter-Loop: Reflected
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
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


On 2021/4/7 23:35, Alexandru Elisei wrote:
> Hi Yanan,
>
> On 3/26/21 3:16 AM, Yanan Wang wrote:
>> With a guest translation fault, the memcache pages are not needed if KVM
>> is only about to install a new leaf entry into the existing page table.
>> And with a guest permission fault, the memcache pages are also not needed
>> for a write_fault in dirty-logging time if KVM is only about to update
>> the existing leaf entry instead of collapsing a block entry into a table.
>>
>> By comparing fault_granule and vma_pagesize, cases that require allocations
>> from memcache and cases that don't can be distinguished completely.
>>
>> Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
>> ---
>>   arch/arm64/kvm/mmu.c | 25 ++++++++++++-------------
>>   1 file changed, 12 insertions(+), 13 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 1eec9f63bc6f..05af40dc60c1 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -810,19 +810,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>   	gfn = fault_ipa >> PAGE_SHIFT;
>>   	mmap_read_unlock(current->mm);
>>   
>> -	/*
>> -	 * Permission faults just need to update the existing leaf entry,
>> -	 * and so normally don't require allocations from the memcache. The
>> -	 * only exception to this is when dirty logging is enabled at runtime
>> -	 * and a write fault needs to collapse a block entry into a table.
>> -	 */
>> -	if (fault_status != FSC_PERM || (logging_active && write_fault)) {
>> -		ret = kvm_mmu_topup_memory_cache(memcache,
>> -						 kvm_mmu_cache_min_pages(kvm));
>> -		if (ret)
>> -			return ret;
>> -	}
>> -
>>   	mmu_seq = vcpu->kvm->mmu_notifier_seq;
>>   	/*
>>   	 * Ensure the read of mmu_notifier_seq happens before we call
>> @@ -880,6 +867,18 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>   	else if (cpus_have_const_cap(ARM64_HAS_CACHE_DIC))
>>   		prot |= KVM_PGTABLE_PROT_X;
>>   
>> +	/*
>> +	 * Allocations from the memcache are required only when granule of the
>> +	 * lookup level where the guest fault happened exceeds vma_pagesize,
>> +	 * which means new page tables will be created in the fault handlers.
>> +	 */
>> +	if (fault_granule > vma_pagesize) {
>> +		ret = kvm_mmu_topup_memory_cache(memcache,
>> +						 kvm_mmu_cache_min_pages(kvm));
>> +		if (ret)
>> +			return ret;
>> +	}
> As I explained in v1 [1], this looks correct to me. I still think that someone
> else should have a look, but if Marc decides to pick up this patch as-is, he can
> add my Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>.
Thanks again for this, Alex!

Hi Marc, Will,
Any thoughts about this patch?

Thanks,
Yanan
> [1] https://lore.kernel.org/lkml/2c65bff2-be7f-b20c-9265-939bc73185b6@arm.com/
>
> Thanks,
>
> Alex
>
>> +
>>   	/*
>>   	 * Under the premise of getting a FSC_PERM fault, we just need to relax
>>   	 * permissions only if vma_pagesize equals fault_granule. Otherwise,
> .
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
