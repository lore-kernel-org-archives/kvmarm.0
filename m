Return-Path: <SRS0=oENQ=XT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2933C432C1
	for <kvmarm@archiver.kernel.org>; Tue, 24 Sep 2019 11:18:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 46BD020872
	for <kvmarm@archiver.kernel.org>; Tue, 24 Sep 2019 11:18:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 46BD020872
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B80BE4A679;
	Tue, 24 Sep 2019 07:18:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7gquovb2ls89; Tue, 24 Sep 2019 07:18:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 80F9A4A66F;
	Tue, 24 Sep 2019 07:18:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE04A4A64B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Sep 2019 07:18:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kb1dRec6Cets for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Sep 2019 07:18:20 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC22A4A5BD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Sep 2019 07:18:20 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3A728142F;
 Tue, 24 Sep 2019 04:18:20 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id
 B4A553F67D; Tue, 24 Sep 2019 04:18:18 -0700 (PDT)
Subject: Re: [PATCH 04/35] irqchip/gic-v3: Detect GICv4.1 supporting RVPEID
To: Andrew Murray <andrew.murray@arm.com>
References: <20190923182606.32100-1-maz@kernel.org>
 <20190923182606.32100-5-maz@kernel.org>
 <20190924102413.GN9720@e119886-lin.cambridge.arm.com>
 <a8107ed9-bb95-a648-ea41-597510f35ec8@kernel.org>
 <20190924110019.GP9720@e119886-lin.cambridge.arm.com>
From: Marc Zyngier <maz@kernel.org>
Organization: Approximate
Message-ID: <054befea-ffc7-157d-03b8-5a099c639a57@kernel.org>
Date: Tue, 24 Sep 2019 12:18:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190924110019.GP9720@e119886-lin.cambridge.arm.com>
Content-Language: en-US
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org,
 Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu
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

On 24/09/2019 12:00, Andrew Murray wrote:
> On Tue, Sep 24, 2019 at 11:49:24AM +0100, Marc Zyngier wrote:
>> On 24/09/2019 11:24, Andrew Murray wrote:
>>> On Mon, Sep 23, 2019 at 07:25:35PM +0100, Marc Zyngier wrote:
>>>> GICv4.1 supports the RVPEID ("Residency per vPE ID"), which allows for
>>>> a much efficient way of making virtual CPUs resident (to allow direct
>>>> injection of interrupts).
>>>>
>>>> The functionnality needs to be discovered on each and every redistributor
>>>> in the system, and disabled if the settings are inconsistent.
>>>>
>>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>>> ---
>>>>  drivers/irqchip/irq-gic-v3.c       | 21 ++++++++++++++++++---
>>>>  include/linux/irqchip/arm-gic-v3.h |  2 ++
>>>>  2 files changed, 20 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
>>>> index 422664ac5f53..0b545e2c3498 100644
>>>> --- a/drivers/irqchip/irq-gic-v3.c
>>>> +++ b/drivers/irqchip/irq-gic-v3.c
>>>> @@ -849,8 +849,21 @@ static int __gic_update_rdist_properties(struct redist_region *region,
>>>>  					 void __iomem *ptr)
>>>>  {
>>>>  	u64 typer = gic_read_typer(ptr + GICR_TYPER);
>>>> +
>>>>  	gic_data.rdists.has_vlpis &= !!(typer & GICR_TYPER_VLPIS);
>>>> -	gic_data.rdists.has_direct_lpi &= !!(typer & GICR_TYPER_DirectLPIS);
>>>> +
>>>> +	/* RVPEID implies some form of DirectLPI, no matter what the doc says... :-/ */
>>>
>>> I think the doc says, RVPEID is *always* 1 for GICv4.1 (and presumably beyond)
>>> and when RVPEID==1 then DirectLPI is *always* 0 - but that's OK because for
>>> GICv4.1 support for direct LPIs is mandatory.
>>
>> Well, v4.1 support for DirectLPI is pretty patchy. It has just enough
>> features to make it useful.
>>
>>>
>>>> +	gic_data.rdists.has_rvpeid &= !!(typer & GICR_TYPER_RVPEID);
>>>> +	gic_data.rdists.has_direct_lpi &= (!!(typer & GICR_TYPER_DirectLPIS) |
>>>> +					   gic_data.rdists.has_rvpeid);
>>>> +
>>>> +	/* Detect non-sensical configurations */
>>>> +	if (WARN_ON_ONCE(gic_data.rdists.has_rvpeid && !gic_data.rdists.has_vlpis)) {
>>>
>>> How feasible is the following suitation? All the redistributors in the system has
>>> vlpis=0, and only the first redistributor has rvpeid=1 (with the remaining ones
>>> rvpeid=0).If we evaluate this WARN_ON_ONCE on each call to
>>> __gic_update_rdist_properties we end up without direct LPI support, however if we
>>> evaluated this after iterating through all the redistributors then we'd end up
>>> with direct LPI support and a non-essential WARN.
>>>
>>> Should we do the WARN after iterating through all the redistributors once we
>>> know what the final values of these flags will be, perhaps in
>>> gic_update_rdist_properties?
>>
>> What does it gains us?
> 
> It prevents an unnecessary WARN.
> 
> If the first redistributor has rvpeid=1, vlpis=0, direct_lpi=1, and the others
> have rvpeid=0, vlpis=0, direct_lpi=0. At the end of iteration, without the
> WARN if statement, you end up wth rvpeid=0, vlpis=0, direct_lpi=0. I.e. it's
> done the right thing. In this use-case the WARN doesn't achieve anything other
> than give the user a pointless WARN. If the WARN was moved to after iteration
> then the WARN wouldn't fire.

But it definitely *should* fire. RVPEID+!VLPI is terminally broken.
What's the use of RVPEID if you cannot directly inject anything? To me
blunt: any difference of HW configuration for any redistributor is an
error. They should all be identical (no, I'm not planning to deal with
the GIC equivalent OF BL).

> I have no idea how likely this use-case is.

There is no use case. Such a configuration shouldn't exist. I'm
considering calling panic instead.

	M.
-- 
Jazz is not dead, it just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
