Return-Path: <SRS0=VUvZ=62=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89567C54E8B
	for <kvmarm@archiver.kernel.org>; Tue, 12 May 2020 12:04:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0E5FE20674
	for <kvmarm@archiver.kernel.org>; Tue, 12 May 2020 12:04:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0E5FE20674
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 78D234B0F8;
	Tue, 12 May 2020 08:04:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LIOj6CuxkazH; Tue, 12 May 2020 08:04:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 47B084B115;
	Tue, 12 May 2020 08:04:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B2B294B0F8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 May 2020 08:04:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 95n-sMhp6IZA for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 May 2020 08:04:38 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A323C4B0EB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 May 2020 08:04:38 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 073B130E;
 Tue, 12 May 2020 05:04:38 -0700 (PDT)
Received: from [192.168.0.14] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9F7063F71E;
 Tue, 12 May 2020 05:04:36 -0700 (PDT)
Subject: Re: [PATCH 08/26] KVM: arm64: Use TTL hint in when invalidating
 stage-2 translations
To: Andrew Scull <ascull@google.com>
References: <20200422120050.3693593-1-maz@kernel.org>
 <20200422120050.3693593-9-maz@kernel.org>
 <20200507151321.GH237572@google.com>
From: James Morse <james.morse@arm.com>
Message-ID: <63e16fdd-fe1b-07d3-23b7-cd99170fdd59@arm.com>
Date: Tue, 12 May 2020 13:04:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200507151321.GH237572@google.com>
Content-Language: en-GB
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Dave Martin <Dave.Martin@arm.com>,
 George Cherian <gcherian@marvell.com>,
 "Zengtao \(B\)" <prime.zeng@hisilicon.com>,
 Andre Przywara <andre.przywara@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hi Andrew,

On 07/05/2020 16:13, Andrew Scull wrote:
>> @@ -176,7 +177,7 @@ static void clear_stage2_pud_entry(struct kvm_s2_mmu *mmu, pud_t *pud, phys_addr
>>  	pmd_t *pmd_table __maybe_unused = stage2_pmd_offset(kvm, pud, 0);
>>  	VM_BUG_ON(stage2_pud_huge(kvm, *pud));
>>  	stage2_pud_clear(kvm, pud);
>> -	kvm_tlb_flush_vmid_ipa(mmu, addr);
>> +	kvm_tlb_flush_vmid_ipa(mmu, addr, S2_NO_LEVEL_HINT);
>>  	stage2_pmd_free(kvm, pmd_table);
>>  	put_page(virt_to_page(pud));
>>  }
>> @@ -186,7 +187,7 @@ static void clear_stage2_pmd_entry(struct kvm_s2_mmu *mmu, pmd_t *pmd, phys_addr
>>  	pte_t *pte_table = pte_offset_kernel(pmd, 0);
>>  	VM_BUG_ON(pmd_thp_or_huge(*pmd));
>>  	pmd_clear(pmd);
>> -	kvm_tlb_flush_vmid_ipa(mmu, addr);
>> +	kvm_tlb_flush_vmid_ipa(mmu, addr, S2_NO_LEVEL_HINT);
>>  	free_page((unsigned long)pte_table);
>>  	put_page(virt_to_page(pmd));
>>  }
> 
> Going by the names, is it possible to give a better level hint for these
> cases?

There is no leaf entry being invalidated here. After clearing the range, we found we'd
emptied (and invalidated) a whole page of mappings:
|	if (stage2_pmd_table_empty(kvm, start_pmd))
|		clear_stage2_pud_entry(mmu, pud, start_addr);

Now we want to remove the link to the empty page so we can free it. We are changing the
structure of the tables, not what gets mapped.

I think this is why we need the un-hinted behaviour, to invalidate "any level of the
translation table walk required to translate the specified IPA". Otherwise the hardware
can look for a leaf at the indicated level, find none, and do nothing.


This is sufficiently horrible, its possible I've got it completely wrong! (does it make
sense?)


Thanks,

James
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
