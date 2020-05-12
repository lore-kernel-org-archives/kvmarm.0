Return-Path: <SRS0=VUvZ=62=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17979CA90AF
	for <kvmarm@archiver.kernel.org>; Tue, 12 May 2020 16:53:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7BAF1206B9
	for <kvmarm@archiver.kernel.org>; Tue, 12 May 2020 16:53:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7BAF1206B9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BDE4E4B0D2;
	Tue, 12 May 2020 12:53:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OzLmqWLsKUDd; Tue, 12 May 2020 12:53:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 122F64B081;
	Tue, 12 May 2020 12:53:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 413B64B081
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 May 2020 12:53:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yzTWlDl5obcv for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 May 2020 12:53:22 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 070624A32E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 May 2020 12:53:22 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5104B1FB;
 Tue, 12 May 2020 09:53:21 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5A5E93F305;
 Tue, 12 May 2020 09:53:19 -0700 (PDT)
Subject: Re: [PATCH 03/26] KVM: arm64: Factor out stage 2 page table data from
 struct kvm
To: James Morse <james.morse@arm.com>, Marc Zyngier <maz@kernel.org>
References: <20200422120050.3693593-1-maz@kernel.org>
 <20200422120050.3693593-4-maz@kernel.org>
 <a7c8207c-9061-ad0e-c9f8-64c995e928b6@arm.com>
 <76d811eb-b304-c49f-1f21-fe9d95112a28@arm.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <6518439c-65b7-1e87-a21d-a053d75c0514@arm.com>
Date: Tue, 12 May 2020 17:53:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <76d811eb-b304-c49f-1f21-fe9d95112a28@arm.com>
Content-Language: en-US
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
 kvmarm@lists.cs.columbia.edu, George Cherian <gcherian@marvell.com>,
 "Zengtao \(B\)" <prime.zeng@hisilicon.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org
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

Hi,

On 5/12/20 12:17 PM, James Morse wrote:
> Hi Alex, Marc,
>
> (just on this last_vcpu_ran thing...)
>
> On 11/05/2020 17:38, Alexandru Elisei wrote:
>> On 4/22/20 1:00 PM, Marc Zyngier wrote:
>>> From: Christoffer Dall <christoffer.dall@arm.com>
>>>
>>> As we are about to reuse our stage 2 page table manipulation code for
>>> shadow stage 2 page tables in the context of nested virtualization, we
>>> are going to manage multiple stage 2 page tables for a single VM.
>>>
>>> This requires some pretty invasive changes to our data structures,
>>> which moves the vmid and pgd pointers into a separate structure and
>>> change pretty much all of our mmu code to operate on this structure
>>> instead.
>>>
>>> The new structure is called struct kvm_s2_mmu.
>>>
>>> There is no intended functional change by this patch alone.
>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>>> index 7dd8fefa6aecd..664a5d92ae9b8 100644
>>> --- a/arch/arm64/include/asm/kvm_host.h
>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>> @@ -63,19 +63,32 @@ struct kvm_vmid {
>>>  	u32    vmid;
>>>  };
>>>  
>>> -struct kvm_arch {
>>> +struct kvm_s2_mmu {
>>>  	struct kvm_vmid vmid;
>>>  
>>> -	/* stage2 entry level table */
>>> -	pgd_t *pgd;
>>> -	phys_addr_t pgd_phys;
>>> -
>>> -	/* VTCR_EL2 value for this VM */
>>> -	u64    vtcr;
>>> +	/*
>>> +	 * stage2 entry level table
>>> +	 *
>>> +	 * Two kvm_s2_mmu structures in the same VM can point to the same pgd
>>> +	 * here.  This happens when running a non-VHE guest hypervisor which
>>> +	 * uses the canonical stage 2 page table for both vEL2 and for vEL1/0
>>> +	 * with vHCR_EL2.VM == 0.
>> It makes more sense to me to say that a non-VHE guest hypervisor will use the
>> canonical stage *1* page table when running at EL2
> Can KVM say anything about stage1? Its totally under the the guests control even at vEL2...

It just occurred to me that "canonical stage 2 page table" refers to the L0
hypervisor stage 2, not to the L1 hypervisor stage 2. If you don't mind my
suggestion, perhaps the comment can be slightly improved to avoid any confusion?
Maybe something along the lines of "[..] This happens when running a non-VHE guest
hypervisor, in which case we use the canonical stage 2 page table for both vEL2
and for vEL1/0 with vHCR_EL2.VM == 0".

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
