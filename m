Return-Path: <SRS0=Ht+8=K5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34C29C47082
	for <kvmarm@archiver.kernel.org>; Thu,  3 Jun 2021 12:52:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B6B32613DE
	for <kvmarm@archiver.kernel.org>; Thu,  3 Jun 2021 12:52:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B6B32613DE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 16FC94B0C1;
	Thu,  3 Jun 2021 08:52:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 51C1aldk3UGk; Thu,  3 Jun 2021 08:52:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E4C3C4B0D0;
	Thu,  3 Jun 2021 08:52:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A7CAE4B0D0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Jun 2021 08:52:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7ApHeoMUtcwx for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Jun 2021 08:52:43 -0400 (EDT)
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 264714B0C1
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Jun 2021 08:52:43 -0400 (EDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
 by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Fwlzt02B3z1BH07;
 Thu,  3 Jun 2021 20:47:54 +0800 (CST)
Received: from dggpemm500023.china.huawei.com (7.185.36.83) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 3 Jun 2021 20:52:38 +0800
Received: from [10.174.187.128] (10.174.187.128) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 3 Jun 2021 20:52:37 +0800
Subject: Re: [PATCH v5 6/6] KVM: arm64: Distinguish cases of memcache
 allocations completely
To: Quentin Perret <qperret@google.com>
References: <20210415115032.35760-1-wangyanan55@huawei.com>
 <20210415115032.35760-7-wangyanan55@huawei.com> <YLdmiTfgz1EqBsJd@google.com>
From: "wangyanan (Y)" <wangyanan55@huawei.com>
Message-ID: <7412ce3d-1144-e2ba-d897-79b0059be453@huawei.com>
Date: Thu, 3 Jun 2021 20:52:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <YLdmiTfgz1EqBsJd@google.com>
Content-Language: en-US
X-Originating-IP: [10.174.187.128]
X-ClientProxiedBy: dggeme702-chm.china.huawei.com (10.1.199.98) To
 dggpemm500023.china.huawei.com (7.185.36.83)
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Hi Quentin,

On 2021/6/2 19:07, Quentin Perret wrote:
> On Thursday 15 Apr 2021 at 19:50:32 (+0800), Yanan Wang wrote:
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
>> index aa536392b308..9e35aa5d29f2 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -895,19 +895,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
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
>> @@ -970,6 +957,18 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
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
> You're now doing the top-up in the kvm->mmu_lock critical section. Isn't
> this more or less what we try to avoid by using a memory cache?
Oh, right!

This patch intended to clean up the code and avoid the unnecessary top-ups,
but it's a bad idea to do the top-up when holding mmu_lock. I will rearrange
this part and keep it where it should be.

Thanks,
Yanan
> Thanks,
> Quentin
> .

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
