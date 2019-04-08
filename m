Return-Path: <SRS0=T7i1=SK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44B69C10F14
	for <kvmarm@archiver.kernel.org>; Mon,  8 Apr 2019 13:06:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C1CF2213F2
	for <kvmarm@archiver.kernel.org>; Mon,  8 Apr 2019 13:06:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C1CF2213F2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4006C4A47B;
	Mon,  8 Apr 2019 09:06:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JYr5-un2VVQ1; Mon,  8 Apr 2019 09:06:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD4424A3EF;
	Mon,  8 Apr 2019 09:06:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 759FA4A389
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Apr 2019 09:06:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sUxFdVu3vzUC for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Apr 2019 09:06:00 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B644B4A32E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Apr 2019 09:06:00 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0DB0815BF;
 Mon,  8 Apr 2019 06:06:00 -0700 (PDT)
Received: from [10.162.0.144] (a075553-lin.blr.arm.com [10.162.0.144])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 919783F68F;
 Mon,  8 Apr 2019 06:05:55 -0700 (PDT)
Subject: Re: [PATCH v8 4/9] KVM: arm/arm64: preserve host HCR_EL2 value
To: James Morse <james.morse@arm.com>, linux-arm-kernel@lists.infradead.org
References: <1554172037-4516-1-git-send-email-amit.kachhap@arm.com>
 <1554172037-4516-5-git-send-email-amit.kachhap@arm.com>
 <f27a3e70-2099-45a6-48e6-481a67e360eb@arm.com>
From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Message-ID: <6131d2cb-1062-6331-c2c3-7026081c458a@arm.com>
Date: Mon, 8 Apr 2019 18:35:52 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <f27a3e70-2099-45a6-48e6-481a67e360eb@arm.com>
Content-Language: en-US
Cc: Marc Zyngier <marc.zyngier@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>,
 Kristina Martsenko <kristina.martsenko@arm.com>, kvmarm@lists.cs.columbia.edu,
 Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>,
 Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org
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
Content-Type: text/plain; charset="UTF-8"; format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190408130552.sctmNmegcnjScNJHlkCOzxmUaU1RXac--xw2LBbRjNE@z>

Hi James,

On 4/6/19 4:07 PM, James Morse wrote:
> Hi Amit,
> 
> On 02/04/2019 03:27, Amit Daniel Kachhap wrote:
>> From: Mark Rutland <mark.rutland@arm.com>
>>
>> When restoring HCR_EL2 for the host, KVM uses HCR_HOST_VHE_FLAGS, which
>> is a constant value. This works today, as the host HCR_EL2 value is
>> always the same, but this will get in the way of supporting extensions
>> that require HCR_EL2 bits to be set conditionally for the host.
>>
>> To allow such features to work without KVM having to explicitly handle
>> every possible host feature combination, this patch has KVM save/restore
>> for the host HCR when switching to/from a guest HCR. The saving of the
>> register is done once during cpu hypervisor initialization state and is
>> just restored after switch from guest.
>>
>> For fetching HCR_EL2 during kvm initialisation, a hyp call is made using
>> kvm_call_hyp and is helpful in non-VHE case.
>>
>> For the hyp TLB maintenance code, __tlb_switch_to_host_vhe() is updated
>> to toggle the TGE bit with a RMW sequence, as we already do in
>> __tlb_switch_to_guest_vhe().
>>
>> The value of hcr_el2 is now stored in struct kvm_cpu_context as both host
>> and guest can now use this field in a common way.
> 
> These HCR_EL2 flags have had me confused for quite a while.
> I thought this was preserving the value that head.S or cpufeature.c had set, and with
> ptrauth we couldn't know what this register should be anymore, the host flags has to vary.
> 
> Kristina's explanation of it[0], clarified things, and with a bit more digging it appears
> we always set API/APK, even if the hardware doesn't support the feature (as its harmless).
> So we don't need to vary the host flags...

API/APK is always set for NVHE host mode.
> 
> My question is, what breaks if this patch isn't merged? (the MDCR change is cleanup we can
> do because of this HCR change), is this HCR change just cleanup too? If so, can we merge
> ptrauth without either, so we only make the change when its needed? (it will cause some
> changes in your patch 7, but I can't see where you depend on the host flags).

Yes you are right that this patch does not directly effect pointer 
authentication functionality but contains several optimizations and 
cleanups such as,

* Removes assigning static flags HCR_HOST_VHE_FLAGS/HCR_HOST_NVHE_FLAGS 
from switch.c so switching functions now are more generic in nature.
* Currently the variation in hcr_el2 flags is across modes (VHE/NVHE). 
Any future conditional change within those modes in host HCR_EL2 may not 
effect code changes in switch.c
* Save of hcr_el2 done at hyp init time so not expensive switching wise.

I am fine on posting it separately also.
> 
> I recall Christoffer wanting to keep the restored DAIF register value on guest-exit static
> to avoid extra loads/stores when we know what the value would be. I think the same logic
> applies here.
Yes the saving of host registers once was suggested by Christoffer.

Thanks,
Amit D
> 
> You mentioned in the cover letter the series has some history to it!
> 
> 
> Thanks,
> 
> James
> 
> [0] http://lore.kernel.org/r/7ec2f950-7587-5ecd-6caa-c2fd091ad22c@arm.com
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
