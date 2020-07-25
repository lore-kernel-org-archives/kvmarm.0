Return-Path: <SRS0=8k27=BE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F253C433E0
	for <kvmarm@archiver.kernel.org>; Sat, 25 Jul 2020 04:51:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F0B132064C
	for <kvmarm@archiver.kernel.org>; Sat, 25 Jul 2020 04:51:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F0B132064C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AF714B51A;
	Sat, 25 Jul 2020 00:51:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fnvqQOZnfVwf; Sat, 25 Jul 2020 00:51:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DAB14B588;
	Sat, 25 Jul 2020 00:51:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 52ECD4B57B
 for <kvmarm@lists.cs.columbia.edu>; Sat, 25 Jul 2020 00:51:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cRKUzRboGjJv for <kvmarm@lists.cs.columbia.edu>;
 Sat, 25 Jul 2020 00:50:59 -0400 (EDT)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C32804B55A
 for <kvmarm@lists.cs.columbia.edu>; Sat, 25 Jul 2020 00:50:58 -0400 (EDT)
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id C9D95D6D6869A077BC63;
 Sat, 25 Jul 2020 12:50:54 +0800 (CST)
Received: from [10.174.185.226] (10.174.185.226) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.487.0; Sat, 25 Jul 2020 12:50:47 +0800
Subject: Re: kvm-unit-tests: Question about the "no interrupt when timer is
 disabled" case
To: Alexandru Elisei <alexandru.elisei@arm.com>
References: <fd421647-6526-41dd-ef3a-c714f9d513d6@huawei.com>
 <195f5f7b-b1a4-8c82-c5e3-aac950737ff5@arm.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <fea5457f-379d-4077-6b1d-022f13e16891@huawei.com>
Date: Sat, 25 Jul 2020 12:50:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <195f5f7b-b1a4-8c82-c5e3-aac950737ff5@arm.com>
Content-Language: en-US
X-Originating-IP: [10.174.185.226]
X-CFilter-Loop: Reflected
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
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

Hi Alex,

[+cc Nianyao]

On 2020/7/24 19:08, Alexandru Elisei wrote:
> Hi Zenghui,
> 
> I don't believe this issue can be triggered by a Linux guest. Details below.
> 
> On 7/23/20 9:56 AM, Zenghui Yu wrote:
>> Hi Alexandru,
>>
>> I've noticed that the timer case will fail in the -stable 4.19 kernel.
>> The log is as follows:
>>
>> FAIL: vtimer-busy-loop: no interrupt when timer is disabled
>> FAIL: vtimer-busy-loop: interrupt signal no longer pending
>>
>> And it's because the related fix [16e604a437c8, "KVM: arm/arm64: vgic:
>> Reevaluate level sensitive interrupts on enable"] hasn't been backported
>> to the stable tree.
> 
> This is not an actual fix (hence no "Fixes" tag), this is more like an improvement
> of the behaviour of the GIC. Like the patch description says, this can happen even
> on hardware if the GIC hasn't sampled the device interrupt state (or the device
> itself hasn't updated it) before the CPU re-enables the interrupt.

Fair enough.

>>
>> Just out of curiosity, _without_ this fix, had you actually seen the
>> guest getting into trouble due to an un-retired level-sensitive
>> interrupt and your patch fixed it? Or this was found by code inspection?
> 
> This issue was found when running kvm-unit-tests on the model.
> 
>>
>> Take the exact vtimer case as an example, is it possible that the Linux
>> guest would disable the vtimer (the input interrupt line is driven to 0
>> but the old KVM doesn't take this into account) and potentially hit this
>> issue? I'm not familiar with it.
> 
> To trigger this, a guest has to do the following steps:
> 
> 1. Disable the timer interrupt at the Redistributor level.
> 2. Trigger the timer interrupt in the timer.
> 3. Disable the timer entirely (CNT{P,V}_CTL_EL0.ENABLE = 0), which also disables
> the timer interrupt.
> 4. Enable the timer interrupt at the Redistributor level.
> 
> I believe there are two reasons why this will never happen for a Linux guest:
> 
> - This isn't the way Linux handles interrupts. Furthermore, I don't believe Linux
> will ever disable a specific interrupt at the irqchip level.

This can at least happen in arch_timer_stop() [arm_arch_timer.c], where
the disable_percpu_irq() API will disable the interrupt (via irq_mask()
callback which will in turn disable the interrupt at GIC level by
programming the ICENABLER0).

What I'm worried is something like:

1. Disable the timer interrupt (at RDist level by poking the ICENABLER0,
    or at CPU level by masking PSTATE.I)

   [ timer interrupt is made pending, and remains pending in (v)GIC. ]

2. Disable the timer
3. Enable the timer interrupt (at RDist level by poking the ISENABLER0,
    or at CPU level by unmasking PSTATE.I)

   [ The interrupt is forwarded to (v)CPU, and we end-up re-enabling the
     timer inside the timer IRQ handler, which may not be as expected. ]

I'm just not sure if this will be a possible scenario in the Linux, and
is it harmful if this would happen.

> - The timer IRQ handler checks the ISTATUS flag in the timer control register
> before handling the interrupt. The flag is unset if the timer is disabled.

This actually doesn't match the spec. Arm ARM D13.8.25 has a description
about the ISTATUS field as below,

"When the value of the ENABLE bit is 0, the ISTATUS field is UNKNOWN."

I guess what Nianyao had posted [*] may address the concern above...

[*] 
http://lore.kernel.org/r/1595584037-6877-1-git-send-email-zhangshaokun@hisilicon.com/

> 
> I hope my explanation made sense, please chime in if I missed something or you
> want more details.

Thanks Alex,
Zenghui
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
