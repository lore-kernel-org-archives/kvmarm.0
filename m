Return-Path: <SRS0=CSPl=AN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AFCAC433DF
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 11:28:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F383E20675
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 11:28:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F383E20675
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5675D4B5CE;
	Thu,  2 Jul 2020 07:28:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yKOQidqrAC7m; Thu,  2 Jul 2020 07:28:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2971D4B5B1;
	Thu,  2 Jul 2020 07:28:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 426994B5B1
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 07:28:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YyC9IQBNtaSu for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2020 07:28:48 -0400 (EDT)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1E8144B376
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 07:28:48 -0400 (EDT)
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id 7AFE2180E2AE9E80C0B8;
 Thu,  2 Jul 2020 19:28:44 +0800 (CST)
Received: from [10.174.187.22] (10.174.187.22) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Thu, 2 Jul 2020 19:28:34 +0800
Subject: Re: [PATCH 03/12] KVM: arm64: Report hardware dirty status of stage2
 PTE if coverred
To: Steven Price <steven.price@arm.com>, <linux-kernel@vger.kernel.org>,
 <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.cs.columbia.edu>,
 <kvm@vger.kernel.org>
References: <20200616093553.27512-1-zhukeqian1@huawei.com>
 <20200616093553.27512-4-zhukeqian1@huawei.com>
 <a73952ac-5e81-6c05-9b21-734e25250845@arm.com>
From: zhukeqian <zhukeqian1@huawei.com>
Message-ID: <d994811b-ca95-236e-b2b0-461ab4f1f065@huawei.com>
Date: Thu, 2 Jul 2020 19:28:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <a73952ac-5e81-6c05-9b21-734e25250845@arm.com>
X-Originating-IP: [10.174.187.22]
X-CFilter-Loop: Reflected
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>, liangpeng10@huawei.com,
 Alexios Zavras <alexios.zavras@intel.com>, Mark Brown <broonie@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Will Deacon <will@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Steven,

On 2020/7/1 19:28, Steven Price wrote:
> Hi,
> 
> On 16/06/2020 10:35, Keqian Zhu wrote:
>> kvm_set_pte is called to replace a target PTE with a desired one.
>> We always do this without changing the desired one, but if dirty
>> status set by hardware is coverred, let caller know it.
>>
>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
>> ---
>>   arch/arm64/kvm/mmu.c | 36 +++++++++++++++++++++++++++++++++++-
>>   1 file changed, 35 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 5ad87bce23c0..27407153121b 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -194,11 +194,45 @@ static void clear_stage2_pmd_entry(struct kvm *kvm, pmd_t *pmd, phys_addr_t addr
>>       put_page(virt_to_page(pmd));
>>   }
>>   -static inline void kvm_set_pte(pte_t *ptep, pte_t new_pte)
>> +#ifdef CONFIG_ARM64_HW_AFDBM
>> +/**
>> + * @ret: true if dirty status set by hardware is coverred.
> 
> NIT: s/coverred/covered/, this is in several places.
> 
OK.
>> + */
>> +static bool kvm_set_pte(pte_t *ptep, pte_t new_pte)
>> +{
>> +    pteval_t old_pteval, new_pteval, pteval;
>> +    bool old_logging, new_no_write;
>> +
>> +    old_logging = kvm_hw_dbm_enabled() && !pte_none(*ptep) &&
>> +              kvm_s2pte_dbm(ptep);
>> +    new_no_write = pte_none(new_pte) || kvm_s2pte_readonly(&new_pte);
>> +
>> +    if (!old_logging || !new_no_write) {
>> +        WRITE_ONCE(*ptep, new_pte);
>> +        dsb(ishst);
>> +        return false;
>> +    }
>> +
>> +    new_pteval = pte_val(new_pte);
>> +    pteval = READ_ONCE(pte_val(*ptep));
> 
> This usage of *ptep looks wrong - it's read twice using READ_ONCE (once in kvm_s2pte_dbm()) and once without any decoration (in the pte_none() call). Which looks a bit dodgy and at the very least needs some justification. AFAICT you would be better taking a local copy and using that rather than reading from memory repeatedly.
> 
oh yes. Here we can use a local copy to get higher performance.

I am not sure here has problem about correctness. I *think* we should always acquire corresponding lock before manipulate PTs,
so there is no other agent will update PTs during our several PTs access (except MMU, but it just modifies AF and [S2]AP) .
But do I miss something?

>> +    do {
>> +        old_pteval = pteval;
>> +        pteval = cmpxchg_relaxed(&pte_val(*ptep), old_pteval, new_pteval);
>> +    } while (pteval != old_pteval);
> This look appears to be reinventing xchg_relaxed(). Any reason we can't just use xchg_relaxed()? Also we had a dsb() after the WRITE_ONCE but you are using the _relaxed variant here. What is the justification for not having a barrier?
> 
Aha, I have changed the code for several times and it is equal to xchg_relaxed now, thanks.

I use _relaxd here because I am not clear about the reason that we use _relaxed in kvm_set_s2XXX_XXX and use dsb() in kvm_set_pte.
But I will correct this in patch v2.
>> +
>> +    return !kvm_s2pte_readonly(&__pte(pteval));
>> +}
>> +#else
>> +/**
>> + * @ret: true if dirty status set by hardware is coverred.
>> + */
>> +static inline bool kvm_set_pte(pte_t *ptep, pte_t new_pte)
>>   {
>>       WRITE_ONCE(*ptep, new_pte);
>>       dsb(ishst);
>> +    return false;
>>   }
>> +#endif /* CONFIG_ARM64_HW_AFDBM */
> 
> You might be able to avoid this #ifdef by redefining old_logging as:
> 
>   old_logging = IS_ENABLED(CONFIG_ARM64_HW_AFDBM) && ...
> 
> I *think* the compiler should be able to kill the dead code and leave you with just the above when the config symbol is off.
> 
After my test, you are right ;-) .


Thanks,
Keqian
> Steve
> 
>>     static inline void kvm_set_pmd(pmd_t *pmdp, pmd_t new_pmd)
>>   {
>>
> 
> .
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
