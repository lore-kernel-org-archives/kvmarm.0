Return-Path: <SRS0=kEaE=LR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2C3EC48BC2
	for <kvmarm@archiver.kernel.org>; Wed, 23 Jun 2021 14:14:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2DAF86112D
	for <kvmarm@archiver.kernel.org>; Wed, 23 Jun 2021 14:14:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2DAF86112D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A66ED4B08C;
	Wed, 23 Jun 2021 10:14:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lEOPd8ILl3hn; Wed, 23 Jun 2021 10:14:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 315D74B08D;
	Wed, 23 Jun 2021 10:14:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FC804B088
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Jun 2021 10:14:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hjVhgH3OEBF7 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Jun 2021 10:14:14 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C03984A3B4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Jun 2021 10:14:14 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3AB99ED1;
 Wed, 23 Jun 2021 07:14:14 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B21C73F718;
 Wed, 23 Jun 2021 07:14:12 -0700 (PDT)
Subject: Re: [PATCH v4 6/9] KVM: arm64: vgic: Implement SW-driven deactivation
To: Marc Zyngier <maz@kernel.org>
References: <20210601104005.81332-1-maz@kernel.org>
 <20210601104005.81332-7-maz@kernel.org>
 <b87fb2e9-a3f9-accc-86d9-64dc2ee90dea@arm.com> <87y2b1c208.wl-maz@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <0e490a98-dca3-cbf9-204b-da77688057d0@arm.com>
Date: Wed, 23 Jun 2021 15:15:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <87y2b1c208.wl-maz@kernel.org>
Content-Language: en-US
Cc: kvm@vger.kernel.org, Hector Martin <marcan@marcan.st>,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

On 6/22/21 5:12 PM, Marc Zyngier wrote:
> On Thu, 17 Jun 2021 15:58:31 +0100,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>> Hi Marc,
>>
>> On 6/1/21 11:40 AM, Marc Zyngier wrote:
>>> In order to deal with these systems that do not offer HW-based
>>> deactivation of interrupts, let implement a SW-based approach:
>> Nitpick, but shouldn't that be "let's"?
> "Let it be...". ;-) Yup.
>
>>> - When the irq is queued into a LR, treat it as a pure virtual
>>>   interrupt and set the EOI flag in the LR.
>>>
>>> - When the interrupt state is read back from the LR, force a
>>>   deactivation when the state is invalid (neither active nor
>>>   pending)
>>>
>>> Interrupts requiring such treatment get the VGIC_SW_RESAMPLE flag.
>>>
>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>> ---
>>>  arch/arm64/kvm/vgic/vgic-v2.c | 19 +++++++++++++++----
>>>  arch/arm64/kvm/vgic/vgic-v3.c | 19 +++++++++++++++----
>>>  include/kvm/arm_vgic.h        | 10 ++++++++++
>>>  3 files changed, 40 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
>>> index 11934c2af2f4..2c580204f1dc 100644
>>> --- a/arch/arm64/kvm/vgic/vgic-v2.c
>>> +++ b/arch/arm64/kvm/vgic/vgic-v2.c
>>> @@ -108,11 +108,22 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
>>>  		 * If this causes us to lower the level, we have to also clear
>>>  		 * the physical active state, since we will otherwise never be
>>>  		 * told when the interrupt becomes asserted again.
>>> +		 *
>>> +		 * Another case is when the interrupt requires a helping hand
>>> +		 * on deactivation (no HW deactivation, for example).
>>>  		 */
>>> -		if (vgic_irq_is_mapped_level(irq) && (val & GICH_LR_PENDING_BIT)) {
>>> -			irq->line_level = vgic_get_phys_line_level(irq);
>>> +		if (vgic_irq_is_mapped_level(irq)) {
>>> +			bool resample = false;
>>> +
>>> +			if (val & GICH_LR_PENDING_BIT) {
>>> +				irq->line_level = vgic_get_phys_line_level(irq);
>>> +				resample = !irq->line_level;
>>> +			} else if (vgic_irq_needs_resampling(irq) &&
>>> +				   !(irq->active || irq->pending_latch)) {
>> I'm having a hard time figuring out when and why a level sensitive
>> can have pending_latch = true.
>>
>> I looked kvm_vgic_inject_irq(), and that function sets pending_latch
>> only for edge triggered interrupts (it sets line_level for level
>> sensitive ones). But irq_is_pending() looks at **both**
>> pending_latch and line_level for level sensitive interrupts.
> Yes, and that's what an implementation requires.
>
>> The only place that I've found that sets pending_latch regardless of
>> the  interrupt type  is in  vgic_mmio_write_spending() (called  on a
>> trapped  write  to   GICD_ISENABLER).
> Are you sure? It really should be GICD_ISPENDR. I'll assume that this
> is what you mean below.

Yes, that's what I meant, sorry for the confusion.

>
>> vgic_v2_populate_lr()  clears
>> pending_latch  only for  edge triggered  interrupts, so  that leaves
>> vgic_v2_fold_lr_state()  as  the   only  function  pending_latch  is
>> cleared for level sensitive interrupts,  when the interrupt has been
>> handled by the guest.  Are we doing all of this  to emulate the fact
>> that level sensitive interrupts (either purely virtual or hw mapped)
>> made pending by a write  to GICD_ISENABLER remain pending until they
>> are handled by the guest?
> Yes, or cleared by a write to GICD_ICPENDR. You really need to think
> of the input into the GIC as some sort of OR gate combining both the
> line level and the PEND register. With a latch for edge interrupts.
>
> Have a look at Figure 4-10 ("Logic of the pending status of a
> level-sensitive interrupt") in the GICv2 arch spec (ARM IHI 0048B.b)
> to see what I actually mean.
>
>> If that is the case, then I think this is what the code is doing:
>>
>> - There's no functional change when the irqchip has HW deactivation
>>
>> - For level sensitive, hw mapped interrupts made pending by a write
>> to GICD_ISENABLER and not yet handled by the guest (pending_latch ==
>> true) we don't clear the pending state of the interrupt.
>>
>> - For level sensitive, hw mapped interrupts we clear the pending
>> state in the GIC and the device will assert the interrupt again if
>> it's still pending at the device 1level. I have a question about
>> this. Why don't we sample the interrupt state by calling
>> vgic_get_phys_line_level()? Because that would be slower than the
>> alternative that you are proposing here?
> Yes. It is *much* faster to read the timer status register (for
> example) than going via an MMIO access to read the (re)distributor
> that will return the same value.

Thank you for the explanation, much appreciated. The patch looks to me like it's
doing the right thing.

Thanks,

Alex

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
