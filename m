Return-Path: <SRS0=xhzu=LJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0210AC48BDF
	for <kvmarm@archiver.kernel.org>; Tue, 15 Jun 2021 10:08:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5501461446
	for <kvmarm@archiver.kernel.org>; Tue, 15 Jun 2021 10:08:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5501461446
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B457B4B0F3;
	Tue, 15 Jun 2021 06:08:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AxuZ-wTPMpwH; Tue, 15 Jun 2021 06:08:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DC934B0E9;
	Tue, 15 Jun 2021 06:08:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 71C184B0E2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 06:08:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jVKaIqQn4hKD for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Jun 2021 06:08:54 -0400 (EDT)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A54124B0CD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 06:08:53 -0400 (EDT)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
 by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4G43pC3n99z63ZS;
 Tue, 15 Jun 2021 18:04:51 +0800 (CST)
Received: from dggpemm500023.china.huawei.com (7.185.36.83) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 15 Jun 2021 18:08:43 +0800
Received: from [10.174.187.128] (10.174.187.128) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 15 Jun 2021 18:08:43 +0800
Subject: Re: [PATCH] KVM: arm64: Fix inconsistency from function comment of
 __unmap_stage2_range
To: Marc Zyngier <maz@kernel.org>
References: <20210615090436.13916-1-wangyanan55@huawei.com>
 <87mtrrihgl.wl-maz@kernel.org>
From: "wangyanan (Y)" <wangyanan55@huawei.com>
Message-ID: <d10107ec-6448-e69c-ecad-6d24c3dd42ae@huawei.com>
Date: Tue, 15 Jun 2021 18:08:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <87mtrrihgl.wl-maz@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.174.187.128]
X-ClientProxiedBy: dggeme702-chm.china.huawei.com (10.1.199.98) To
 dggpemm500023.china.huawei.com (7.185.36.83)
X-CFilter-Loop: Reflected
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
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



On 2021/6/15 17:51, Marc Zyngier wrote:
> On Tue, 15 Jun 2021 10:04:36 +0100,
> Yanan Wang <wangyanan55@huawei.com> wrote:
>> Commit 'b5331379bc626'
>> (KVM: arm64: Only reschedule if MMU_NOTIFIER_RANGE_BLOCKABLE is not set)
>> has converted the original function name 'unmap_stage2_range' to
>> '__unmap_stage2_range', but leaving the corresponding function comment
>> unadjusted. So fix it for code readability.
>>
>> Incidentally, we also tewak some comment identation by using tabs instead
>> of spaces to be consistent with the other functions.
>>
>> Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
> Same as the previous patch. The first hunk is OK, as it fixes an
> actual defect (wrong documentation), and adjusting the alignment is OK
> as your changing the context.
>
> However, the last 3 are just noise. Please drop them.
Ok, will drop them.

Thanks,
Yanan
> Thanks,
>
> 	M.
>
>> ---
>>   arch/arm64/kvm/mmu.c | 18 +++++++++---------
>>   1 file changed, 9 insertions(+), 9 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 5742ba765ff9..80040af147a2 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -151,11 +151,11 @@ static void *kvm_host_va(phys_addr_t phys)
>>    * does.
>>    */
>>   /**
>> - * unmap_stage2_range -- Clear stage2 page table entries to unmap a range
>> - * @mmu:   The KVM stage-2 MMU pointer
>> - * @start: The intermediate physical base address of the range to unmap
>> - * @size:  The size of the area to unmap
>> - * @may_block: Whether or not we are permitted to block
>> + * __unmap_stage2_range -- Clear stage2 page table entries to unmap a range
>> + * @mmu:	The KVM stage-2 MMU pointer
>> + * @start:	The intermediate physical base address of the range to unmap
>> + * @size:	The size of the area to unmap
>> + * @may_block:	Whether or not we are permitted to block
>>    *
>>    * Clear a range of stage-2 mappings, lowering the various ref-counts.  Must
>>    * be called while holding mmu_lock (unless for freeing the stage2 pgd before
>> @@ -190,7 +190,7 @@ static void stage2_flush_memslot(struct kvm *kvm,
>>   
>>   /**
>>    * stage2_flush_vm - Invalidate cache for pages mapped in stage 2
>> - * @kvm: The struct kvm pointer
>> + * @kvm:	The struct kvm pointer
>>    *
>>    * Go through the stage 2 page tables and invalidate any cache lines
>>    * backing memory already mapped to the VM.
>> @@ -527,7 +527,7 @@ static void stage2_unmap_memslot(struct kvm *kvm,
>>   
>>   /**
>>    * stage2_unmap_vm - Unmap Stage-2 RAM mappings
>> - * @kvm: The struct kvm pointer
>> + * @kvm:	The struct kvm pointer
>>    *
>>    * Go through the memregions and unmap any regular RAM
>>    * backing memory already mapped to the VM.
>> @@ -578,7 +578,7 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>>    * @guest_ipa:	The IPA at which to insert the mapping
>>    * @pa:		The physical address of the device
>>    * @size:	The size of the mapping
>> - * @writable:   Whether or not to create a writable mapping
>> + * @writable:	Whether or not to create a writable mapping
>>    */
>>   int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>>   			  phys_addr_t pa, unsigned long size, bool writable)
>> @@ -616,7 +616,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>>   
>>   /**
>>    * stage2_wp_range() - write protect stage2 memory region range
>> - * @mmu:        The KVM stage-2 MMU pointer
>> + * @mmu:	The KVM stage-2 MMU pointer
>>    * @addr:	Start address of range
>>    * @end:	End address of range
>>    */
>> -- 
>> 2.23.0
>>
>>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
