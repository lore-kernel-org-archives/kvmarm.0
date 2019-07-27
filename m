Return-Path: <SRS0=tpUV=VY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C806BC7618B
	for <kvmarm@archiver.kernel.org>; Sat, 27 Jul 2019 13:37:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 66CA92084C
	for <kvmarm@archiver.kernel.org>; Sat, 27 Jul 2019 13:37:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 66CA92084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BFE304A528;
	Sat, 27 Jul 2019 09:37:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bbAIVUXSDzPN; Sat, 27 Jul 2019 09:37:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 898934A535;
	Sat, 27 Jul 2019 09:37:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 04A7C4A528
 for <kvmarm@lists.cs.columbia.edu>; Sat, 27 Jul 2019 09:37:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6jlX8ldfE5L1 for <kvmarm@lists.cs.columbia.edu>;
 Sat, 27 Jul 2019 09:37:15 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F7004A51D
 for <kvmarm@lists.cs.columbia.edu>; Sat, 27 Jul 2019 09:37:15 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0541628;
 Sat, 27 Jul 2019 06:37:15 -0700 (PDT)
Received: from [10.37.8.139] (unknown [10.37.8.139])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 08FF83F71F;
 Sat, 27 Jul 2019 06:37:12 -0700 (PDT)
Subject: Re: KVM Arm64 and Linux-RT issues
To: Marc Zyngier <maz@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
References: <b9867c43-7fe3-5d64-9939-b1a7ab7f1061@arm.com>
 <cd310858-2c0f-6af1-bf82-ee1e01a2cfb8@arm.com>
 <alpine.DEB.2.21.1907270053360.1791@nanos.tec.linutronix.de>
 <86zhkzn319.wl-maz@kernel.org>
From: Julien Grall <julien.grall@arm.com>
Message-ID: <960b5ed1-6d0f-3cee-da37-6061b4946c1a@arm.com>
Date: Sat, 27 Jul 2019 14:37:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <86zhkzn319.wl-maz@kernel.org>
Content-Language: en-US
Cc: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
 "bigeasy@linutronix.de" <bigeasy@linutronix.de>, anna-maria@linutronix.de,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
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

Hi,

On 7/27/19 12:13 PM, Marc Zyngier wrote:
> On Fri, 26 Jul 2019 23:58:38 +0100,
> Thomas Gleixner <tglx@linutronix.de> wrote:
>>
>> On Wed, 24 Jul 2019, Marc Zyngier wrote:
>>> On 23/07/2019 18:58, Julien Grall wrote:
>>> It really feels like a change in hrtimer_cancel semantics. From what I
>>> understand, this is used to avoid racing against the softirq, but boy it
>>> breaks things.
>>>
>>> If this cannot be avoided, this means we can't cancel the background
>>> timer (which is used to emulate the vcpu timer while it is blocked
>>> waiting for an interrupt), then we must move this canceling to the point
>>> where the vcpu is unblocked (instead of scheduled), which may have some
>>> side effects -- I'll have a look.
>>>
>>> But that's not the only problem: We also have hrtimers used to emulate
>>> timers while the vcpu is running, and these timers are canceled in
>>> kvm_timer_vcpu_put(), which is also called from a preempt notifier.
>>> Unfortunately, I don't have a reasonable solution for that (other than
>>> putting this hrtimer_cancel in a workqueue and start chasing the
>>> resulting races).
>>
>> The fix is simple. See below. We'll add that to the next RT release. That
>> will take a while as I'm busy with posting RT stuff for upstream :)
> 
> Ah, thanks for that! And yes, looking forward to RT upstream, it's
> just about time! ;-)
> 
>>
>> Thanks,
>>
>> 	tglx
>>
>> 8<------------
>> --- a/virt/kvm/arm/arch_timer.c
>> +++ b/virt/kvm/arm/arch_timer.c
>> @@ -80,7 +80,7 @@ static inline bool userspace_irqchip(str
>>   static void soft_timer_start(struct hrtimer *hrt, u64 ns)
>>   {
>>   	hrtimer_start(hrt, ktime_add_ns(ktime_get(), ns),
>> -		      HRTIMER_MODE_ABS);
>> +		      HRTIMER_MODE_ABS_HARD);
>>   }
>>   
> 
> That's pretty neat, and matches the patch you already have for
> x86. Feel free to add my
> 
> Acked-by: Marc Zyngier <maz@kernel.org>

I can confirm the warning now disappeared. Feel free to added my tested-by:

Tested-by: Julien Grall <julien.grall@arm.com>

Thank you both for the help!

Cheers,

-- 
Julien Grall
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
