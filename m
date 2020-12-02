Return-Path: <SRS0=8eDP=FG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54C24C64E7B
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 16:27:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9F22D221E9
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 16:27:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9F22D221E9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C63974B3F8;
	Wed,  2 Dec 2020 11:27:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CzGwP6O5IVEA; Wed,  2 Dec 2020 11:27:48 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 50D9F4B35F;
	Wed,  2 Dec 2020 11:27:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 60B3C4B351
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 11:27:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6S-J3MN6r-es for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Dec 2020 11:27:45 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A9E944B345
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 11:27:45 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3E90D1063;
 Wed,  2 Dec 2020 08:27:45 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 85E383F718;
 Wed,  2 Dec 2020 08:27:44 -0800 (PST)
Subject: Re: [RFC PATCH v3 09/16] KVM: arm64: Use separate function for the
 mapping size in user_mem_abort()
To: Haibo Xu <haibo.xu@linaro.org>
References: <20201027172705.15181-1-alexandru.elisei@arm.com>
 <20201027172705.15181-10-alexandru.elisei@arm.com>
 <CAJc+Z1F1aEU=-qiCdDD8GhS3bhFvuhgPqtqTbBHF3RZgwznHgA@mail.gmail.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <81782b0e-cb7a-3f76-3579-ad0fddf37638@arm.com>
Date: Wed, 2 Dec 2020 16:29:00 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <CAJc+Z1F1aEU=-qiCdDD8GhS3bhFvuhgPqtqTbBHF3RZgwznHgA@mail.gmail.com>
Content-Language: en-US
Cc: maz@kernel.org, will@kernel.org, kvmarm@lists.cs.columbia.edu,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Haibo,

On 11/5/20 10:01 AM, Haibo Xu wrote:
> On Wed, 28 Oct 2020 at 01:26, Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>> user_mem_abort() is already a long and complex function, let's make it
>> slightly easier to understand by abstracting the algorithm for choosing the
>> stage 2 IPA entry size into its own function.
>>
>> This also makes it possible to reuse the code when guest SPE support will
>> be added.
>>
> Better to mention that there is "No functional change"!

That's a good point, I'll add it.

Thanks,

Alex

>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  arch/arm64/kvm/mmu.c | 55 ++++++++++++++++++++++++++------------------
>>  1 file changed, 33 insertions(+), 22 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 19aacc7d64de..c3c43555490d 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -738,12 +738,43 @@ transparent_hugepage_adjust(struct kvm_memory_slot *memslot,
>>         return PAGE_SIZE;
>>  }
>>
>> +static short stage2_max_pageshift(struct kvm_memory_slot *memslot,
>> +                                 struct vm_area_struct *vma, hva_t hva,
>> +                                 bool *force_pte)
>> +{
>> +       short pageshift;
>> +
>> +       *force_pte = false;
>> +
>> +       if (is_vm_hugetlb_page(vma))
>> +               pageshift = huge_page_shift(hstate_vma(vma));
>> +       else
>> +               pageshift = PAGE_SHIFT;
>> +
>> +       if (memslot_is_logging(memslot) || (vma->vm_flags & VM_PFNMAP)) {
>> +               *force_pte = true;
>> +               pageshift = PAGE_SHIFT;
>> +       }
>> +
>> +       if (pageshift == PUD_SHIFT &&
>> +           !fault_supports_stage2_huge_mapping(memslot, hva, PUD_SIZE))
>> +               pageshift = PMD_SHIFT;
>> +
>> +       if (pageshift == PMD_SHIFT &&
>> +           !fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE)) {
>> +               *force_pte = true;
>> +               pageshift = PAGE_SHIFT;
>> +       }
>> +
>> +       return pageshift;
>> +}
>> +
>>  static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>                           struct kvm_memory_slot *memslot, unsigned long hva,
>>                           unsigned long fault_status)
>>  {
>>         int ret = 0;
>> -       bool write_fault, writable, force_pte = false;
>> +       bool write_fault, writable, force_pte;
>>         bool exec_fault;
>>         bool device = false;
>>         unsigned long mmu_seq;
>> @@ -776,27 +807,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>                 return -EFAULT;
>>         }
>>
>> -       if (is_vm_hugetlb_page(vma))
>> -               vma_shift = huge_page_shift(hstate_vma(vma));
>> -       else
>> -               vma_shift = PAGE_SHIFT;
>> -
>> -       if (logging_active ||
>> -           (vma->vm_flags & VM_PFNMAP)) {
>> -               force_pte = true;
>> -               vma_shift = PAGE_SHIFT;
>> -       }
>> -
>> -       if (vma_shift == PUD_SHIFT &&
>> -           !fault_supports_stage2_huge_mapping(memslot, hva, PUD_SIZE))
>> -              vma_shift = PMD_SHIFT;
>> -
>> -       if (vma_shift == PMD_SHIFT &&
>> -           !fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE)) {
>> -               force_pte = true;
>> -               vma_shift = PAGE_SHIFT;
>> -       }
>> -
>> +       vma_shift = stage2_max_pageshift(memslot, vma, hva, &force_pte);
>>         vma_pagesize = 1UL << vma_shift;
>>         if (vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE)
>>                 fault_ipa &= ~(vma_pagesize - 1);
>> --
>> 2.29.1
>>
>> _______________________________________________
>> kvmarm mailing list
>> kvmarm@lists.cs.columbia.edu
>> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
