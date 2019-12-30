Return-Path: <SRS0=uzGy=2U=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F16C9C2D0C3
	for <kvmarm@archiver.kernel.org>; Mon, 30 Dec 2019 03:51:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 74EC6206E4
	for <kvmarm@archiver.kernel.org>; Mon, 30 Dec 2019 03:51:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 74EC6206E4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C4D344A5A3;
	Sun, 29 Dec 2019 22:51:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Tb3xvzKJwcWQ; Sun, 29 Dec 2019 22:50:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A8B14A578;
	Sun, 29 Dec 2019 22:50:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2347A4A52C
 for <kvmarm@lists.cs.columbia.edu>; Sun, 29 Dec 2019 22:50:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1kfiNVYSROrd for <kvmarm@lists.cs.columbia.edu>;
 Sun, 29 Dec 2019 22:50:56 -0500 (EST)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E61B04A369
 for <kvmarm@lists.cs.columbia.edu>; Sun, 29 Dec 2019 22:50:55 -0500 (EST)
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id 7697ED891D40BB4DF227;
 Mon, 30 Dec 2019 11:50:52 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Mon, 30 Dec 2019
 11:50:45 +0800
Subject: Re: [PATCH v3 04/32] irqchip/gic-v3: Use SGIs without active state if
 offered
To: Marc Zyngier <maz@kernel.org>
References: <20191224111055.11836-1-maz@kernel.org>
 <20191224111055.11836-5-maz@kernel.org>
 <83459bef-49bb-8203-1631-0b02bb9efe17@huawei.com>
 <20191228103301.147f541c@why>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <33df30e8-8ce8-fde1-2e9f-9ef4eda4f563@huawei.com>
Date: Mon, 30 Dec 2019 11:50:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191228103301.147f541c@why>
Content-Language: en-US
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org,
 Robert Richter <rrichter@marvell.com>, Thomas Gleixner <tglx@linutronix.de>,
 kvmarm@lists.cs.columbia.edu
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

Hi Marc,

On 2019/12/28 18:36, Marc Zyngier wrote:
> On Sat, 28 Dec 2019 16:56:54 +0800
> Zenghui Yu <yuzenghui@huawei.com> wrote:
> 
> Hi Zenghui,
> 
>> Hi Marc,
>>
>> On 2019/12/24 19:10, Marc Zyngier wrote:
>>> If running under control of a hypervisor that implements GICv4.1
>>> SGIs, allow the hypervisor to use them at the expense of loosing
>>> the Active state (which we don't care about for SGIs).
>>>
>>> This is trivially done by checking for GICD_TYPER2.nASSGIcap, and
>>> setting GICD_CTLR.nASSGIreq when enabling Group-1 interrupts.
>>>
>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>> ---
>>>    drivers/irqchip/irq-gic-v3.c       | 10 ++++++++--
>>>    include/linux/irqchip/arm-gic-v3.h |  2 ++
>>>    2 files changed, 10 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
>>> index 640d4db65b78..624f351c0362 100644
>>> --- a/drivers/irqchip/irq-gic-v3.c
>>> +++ b/drivers/irqchip/irq-gic-v3.c
>>> @@ -724,6 +724,7 @@ static void __init gic_dist_init(void)
>>>    	unsigned int i;
>>>    	u64 affinity;
>>>    	void __iomem *base = gic_data.dist_base;
>>> +	u32 val;
>>>    >   	/* Disable the distributor */
>>>    	writel_relaxed(0, base + GICD_CTLR);
>>> @@ -756,9 +757,14 @@ static void __init gic_dist_init(void)
>>>    	/* Now do the common stuff, and wait for the distributor to drain */
>>>    	gic_dist_config(base, GIC_LINE_NR, gic_dist_wait_for_rwp);
>>>    > +	val = GICD_CTLR_ARE_NS | GICD_CTLR_ENABLE_G1A | GICD_CTLR_ENABLE_G1;
>>> +	if (gic_data.rdists.gicd_typer2 & GICD_TYPER2_nASSGIcap) {
>>> +		pr_info("Enabling SGIs without active state\n");
>>> +		val |= GICD_CTLR_nASSGIreq;
>>> +	}
>>> +
>>>    	/* Enable distributor with ARE, Group1 */
>>> -	writel_relaxed(GICD_CTLR_ARE_NS | GICD_CTLR_ENABLE_G1A | GICD_CTLR_ENABLE_G1,
>>> -		       base + GICD_CTLR);
>>> +	writel_relaxed(val, base + GICD_CTLR);
>>>    >   	/*
>>>    	 * Set all global interrupts to the boot CPU only. ARE must be
>>> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
>>> index 9dfe64189d99..72b69f4e6c7b 100644
>>> --- a/include/linux/irqchip/arm-gic-v3.h
>>> +++ b/include/linux/irqchip/arm-gic-v3.h
>>> +#define GICD_CTLR_nASSGIreq		(1U << 8)
>>
>>> +#define GICD_TYPER2_nASSGIcap		(1U << 8)
>>
>> I thought these two bits are newly added in the specification, which is
>> not available yet... until I've reached patch 29 and 30.
>>
>> So they are actually some "kvm-implemented" bits and can only be used by
>> the KVM guests. I have two questions now:
>>
>> 1) As per the latest GIC specification, these two bits are Reserved
>>      (RAZ/WI) from host's perspective, which is good for now. But will
>>      they be (unexpectedly) used one day by the future architecture?
> 
> These bits are now assigned by the latest revision of the GICv4.1 spec,
> and are roughly defined as you reversed engineered them below.

(Ah, so all what I'm having in the hand is a GICv4.0.5 ;-).

> The idea is that unmodified SW expects SGIs to have an active state,
> because that's the way it has always been so far. Any architecturally
> compliant hypervisor must implement an active state for SGIs.
> 
> Now, there are obvious benefits in having HW-accelerated SGI delivery,
> which for GICv4.1 comes at the expense of loosing the active state.
> 
> So we need a way to expose the fact that the hypervisor *can* support
> non-active-state SGIs (hence the GICD_TYPER2.nASSGIcap bit), and a way
> for the guest to say "I'm OK with losing the active state for SGIs",
> which corresponds to the GICD_CTLR.nASSGIreq bit.

Thanks for the explanation!

> Note that this isn't a property that ever needs to be exposed by the
> HW, but one that has been architected for the sole benefit of
> hypervisors and guests (a HW implementation would keep them as RAZ/WI).

Yeah, I can understand this point.

>> 2) Only Linux guest will check and make use of these bits now. What if
>>      some non-Linux guests wants to run with KVM and use the GICv4.1 based
>>      vSGIs?  Their developers might have no interests reading at the KVM
>>      code... so what about plumbing some descriptions about these bits
>>      into somewhere in the documentation (or code)?  Like below, mostly
>>      copied from your commit messages:
>>
>> ---8<---
>>
>> // Roughly writing, for the ease of reviewing the later patches.
>>
>> No-Active-State SGIs (?) Related Field Descriptions
>> 	--From Guest's Perspective
>>
>> With GICv4.1, KVM exposes two single bit (in GICD_TYPER2 and GICD_CTLR
>> respectively) for guests, which can be used to probe the GICv4.1 based
>> SGIs support on hypervisor and choose whether guests want the good old
>> SGIs with an active state, or the new, HW-based ones that do not have
>> one.
>>
>> GICD_TYPER2.nASSGIcap, bit [8]
>>
>>       Indicates whether guests are running under control of a hypervisor
>>       that implements GICv4.1 SGIs, allow the hypervisor to use them at
>>       the expense of loosing the Active state.
>>
>>       0b0    GICv4.1 SGIs capability is not offered by hypervisor.
>>
>>       0b1    GICv4.1 SGIs capability is offered by hypervisor.
>>
>>       This field is RO.
>>
>>
>> GICD_CTLR.nASSGIreq, bit [8]
>>
>>       Indicates whether guests wants to use HW-based SGIs without Active
>>       state if the GICv4.1 SGI capability is offered by hypervisor.
>>       Hypervisor will then try to satisfy the request and switch between
>>       HW/SW delivered SGIs.
>>
>>       0b0    If read, indicated that guest is using the old SW-emulated
>>              SGIs.
>>              If write, indicates that guest requests to use the old
>>              SW-emulated SGIs.
>>
>>       0b1    If read, indicates that guest is using the new HW-based SGIs.
>>              If write, indicates that guest requests to use the new
>>              HW-based SGIs. If GICD_TYPER2.nASSGIcap is 0, the write has
>>              no effect.
>>
>>       Changing this bit is UNPREDICTABLE if the Distributor is enabled.
>>       KVM may just treat this bit as RO when Distributor stays enabled.
>>
>>
>> See gic_dist_init() in drivers/irqchip/irq-gic-v3.c for an example that
>> how Linux guest (since 5.6?) makes use of these bits and benefits from
>> the GICv4.1 based vSGIs.
>>
>> These two bits are Reserved (RAZ/WI) from host's perspective, which is
>> good for now.
> 
> This write-up is sensible, but it would be a duplication of the
> architecture spec once it is publicly available. As much as possible,
> I'd like not to duplicate information, as the are bound to diverge as
> the architecture spec gets amended. How about we add this to the commit
> message instead, as a placeholder until the GICv4.1 doc is available
> (hopefully some time next year)?

Good idea, I'm all for it.

It will (at least) help other reviewers to easily realize what is going
on between guests and the hypervisor.


Thanks,
Zenghui

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
