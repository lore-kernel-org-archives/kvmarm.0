Return-Path: <SRS0=LaKu=5Z=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17CE9C2BB85
	for <kvmarm@archiver.kernel.org>; Thu,  9 Apr 2020 16:53:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A15A520769
	for <kvmarm@archiver.kernel.org>; Thu,  9 Apr 2020 16:53:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A15A520769
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 27A534B089;
	Thu,  9 Apr 2020 12:53:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4cz-62zpn5vy; Thu,  9 Apr 2020 12:53:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D5E074B0D7;
	Thu,  9 Apr 2020 12:53:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE24A4B0C4
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Apr 2020 12:53:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p4XtIulv+b79 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Apr 2020 12:53:30 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA9AD4B0BF
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Apr 2020 12:53:30 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4BC8931B;
 Thu,  9 Apr 2020 09:53:30 -0700 (PDT)
Received: from [192.168.0.14] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5264F3F73D;
 Thu,  9 Apr 2020 09:53:29 -0700 (PDT)
Subject: Re: [PATCH] KVM: arm64: arch_timer shouldn't assume the vcpu is loaded
To: Marc Zyngier <maz@kernel.org>
References: <20200406150355.4859-1-james.morse@arm.com>
 <20200408110726.4d81bc3b@why> <cc6bed09-33dd-027a-126f-ed22389c1624@arm.com>
 <20200409092706.74e6bd1d@why>
From: James Morse <james.morse@arm.com>
Message-ID: <20498855-352b-ed7a-c851-8ecf8b77e503@arm.com>
Date: Thu, 9 Apr 2020 17:53:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200409092706.74e6bd1d@why>
Content-Language: en-GB
Cc: Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu,
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

Hi Marc,

On 09/04/2020 09:27, Marc Zyngier wrote:
> On Wed, 8 Apr 2020 12:16:01 +0100
> James Morse <james.morse@arm.com> wrote:
>> On 08/04/2020 11:07, Marc Zyngier wrote:
>>> I don't fully agree with the analysis, Remember we are looking at the
>>> state of the physical interrupt associated with a virtual interrupt, so
>>> the vcpu doesn't quite make sense here if it isn't loaded.
>>>
>>> What does it mean to look at the HW timer when we are not in the right
>>> context? For all we know, it is completely random (the only guarantee
>>> we have is that it is disabled, actually).  
>>
>>> My gut feeling is that this is another instance where we should provide
>>> specific userspace accessors that would only deal with the virtual
>>> state, and leave anything that deals with the physical state of the
>>> interrupt to be exercised only by the guest.  
>>
>>> Does it make sense?  
>>
>> Broadly, yes. Specifically ... I'm not familiar enough with this code to work out where
>> such a change should go!
>>
>> ~20 mins of grepping later~
>>
>> Remove REGISTER_DESC_WITH_LENGTH() so that uaccess helpers have to be provided, and forbid
>> NULL for the ur/uw values in REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED()...?
> 
> I'd suggest something like this (untested, of course):

[...]

>> Or if that is too invasive, something like, (totally, untested):
>> ----------------%<----------------
>> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
>> index 97fb2a40e6ba..30ae5f29e429 100644
>> --- a/virt/kvm/arm/vgic/vgic-mmio.c
>> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
>> @@ -113,10 +113,11 @@ void vgic_mmio_write_senable(struct kvm_vcpu *vcpu,
>>                 struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
>>
>>                 raw_spin_lock_irqsave(&irq->irq_lock, flags);
>> -               if (vgic_irq_is_mapped_level(irq)) {
>> +               if (kvm_running_vcpu() && vgic_irq_is_mapped_level(irq)) {
>>                         bool was_high = irq->line_level;
>>
>>                         /*
>> +                        * Unless we are running due to a user-space access,
>>                          * We need to update the state of the interrupt because
>>                          * the guest might have changed the state of the device
>>                          * while the interrupt was disabled at the VGIC level.
>> ----------------%<----------------
> 
> Huh, nice try! ;-) Unfortunately, I think there is more than the enable
> register that suffers from a similar problem (see how the pending
> register write is also accessing the HW state, even if accessed from
> userspace).

Yeah, I'd expect to play wack-a-mole if I actually tested it. It was just the smallest,
er, hack I could get my head round given your explanation.


I've blindly tested your version, it works for me on a gicv2 machine:
Tested-by: James Morse <james.morse@arm.com>

I'll test on the gicv3 espressobin that I originally saw this on with rc1 on Tuesday.

Do you want me to post it back to you as a tested patch? You can judge whether I
understand it from the commit message... (I'd need your Signed-off-by...)

Have a good extended weekend!
Thanks,

James
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
