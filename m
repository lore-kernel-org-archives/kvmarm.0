Return-Path: <SRS0=Cfin=4A=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DCA3C35242
	for <kvmarm@archiver.kernel.org>; Wed, 12 Feb 2020 02:57:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7270E206DB
	for <kvmarm@archiver.kernel.org>; Wed, 12 Feb 2020 02:57:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7270E206DB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF5D04AEB3;
	Tue, 11 Feb 2020 21:57:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xWCh3IbsZY+m; Tue, 11 Feb 2020 21:57:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E27B4A946;
	Tue, 11 Feb 2020 21:57:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8750D4A946
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 21:57:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7O37JFBKiYB5 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Feb 2020 21:57:24 -0500 (EST)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 36F654A5C6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 21:57:24 -0500 (EST)
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id E49F837106B66746F0B0;
 Wed, 12 Feb 2020 10:57:20 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Wed, 12 Feb 2020
 10:57:10 +0800
Subject: Re: [PATCH kvm-unit-tests v2] arm64: timer: Speed up gic-timer-state
 check
To: Andrew Jones <drjones@redhat.com>
References: <20200211133705.1398-1-drjones@redhat.com>
 <60c6c4c7-1d6b-5b64-adc1-8e96f45332c6@huawei.com>
 <20200211154135.vxxkpstt4cpoyqsp@kamzik.brq.redhat.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <a8876667-934d-f617-682d-c488e7276d38@huawei.com>
Date: Wed, 12 Feb 2020 10:57:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200211154135.vxxkpstt4cpoyqsp@kamzik.brq.redhat.com>
Content-Language: en-US
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Cc: andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

Hi Drew,

On 2020/2/11 23:41, Andrew Jones wrote:
> On Tue, Feb 11, 2020 at 10:50:58PM +0800, Zenghui Yu wrote:
>> Hi Drew,
>>
>> On 2020/2/11 21:37, Andrew Jones wrote:
>>> Let's bail out of the wait loop if we see the expected state
>>> to save over six seconds of run time. Make sure we wait a bit
>>> before reading the registers and double check again after,
>>> though, to somewhat mitigate the chance of seeing the expected
>>> state by accident.
>>>
>>> We also take this opportunity to push more IRQ state code to
>>> the library.
>>>
>>> Signed-off-by: Andrew Jones <drjones@redhat.com>
>>
>> [...]
>>
>>> +
>>> +enum gic_irq_state gic_irq_state(int irq)
>>
>> This is a *generic* name while this function only deals with PPI.
>> Maybe we can use something like gic_ppi_state() instead?  Or you
>> will have to take all interrupt types into account in a single
>> function, which is not a easy job I think.
> 
> Very good point.
> 
>>
>>> +{
>>> +	enum gic_irq_state state;
>>> +	bool pending = false, active = false;
>>> +	void *base;
>>> +
>>> +	assert(gic_common_ops);
>>> +
>>> +	switch (gic_version()) {
>>> +	case 2:
>>> +		base = gicv2_dist_base();
>>> +		pending = readl(base + GICD_ISPENDR) & (1 << PPI(irq));
>>> +		active = readl(base + GICD_ISACTIVER) & (1 << PPI(irq));
>>> +		break;
>>> +	case 3:
>>> +		base = gicv3_sgi_base();
>>> +		pending = readl(base + GICR_ISPENDR0) & (1 << PPI(irq));
>>> +		active = readl(base + GICR_ISACTIVER0) & (1 << PPI(irq));
>>
>> And you may also want to ensure that the 'irq' is valid for PPI().
>> Or personally, I'd just use a real PPI number (PPI(info->irq)) as
>> the input parameter of this function.
> 
> Indeed, if we want to make this a general function we should require
> the caller to pass PPI(irq).
> 
>>
>>> +		break;
>>> +	}
>>> +
>>> +	if (!active && !pending)
>>> +		state = GIC_IRQ_STATE_INACTIVE;
>>> +	if (pending)
>>> +		state = GIC_IRQ_STATE_PENDING;
>>> +	if (active)
>>> +		state = GIC_IRQ_STATE_ACTIVE;
>>> +	if (active && pending)
>>> +		state = GIC_IRQ_STATE_ACTIVE_PENDING;
>>> +
>>> +	return state;
>>> +}
>>>
>>
>> Otherwise,
>>
>> Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
>> Tested-by: Zenghui Yu <yuzenghui@huawei.com>
> 
> Thanks, but I guess I should squash in changes to make this function more
> general. My GIC/SPI skills are weak, so I'm not sure this is right,
> especially because the SPI stuff doesn't yet have a user to validate it.

(I guess the PL031 can be another new user.)

> However, if all reviewers think it's correct, then I'll squash it into
> the arm/queue branch. I've added Andre and Eric to help review too.
> 
> Thanks,
> drew
> 
> 
> diff --git a/arm/timer.c b/arm/timer.c
> index ae5fdbf54b35..44621b4f2967 100644
> --- a/arm/timer.c
> +++ b/arm/timer.c
> @@ -189,9 +189,9 @@ static bool gic_timer_check_state(struct timer_info *info,
>   	/* Wait for up to 1s for the GIC to sample the interrupt. */
>   	for (i = 0; i < 10; i++) {
>   		mdelay(100);
> -		if (gic_irq_state(info->irq) == expected_state) {
> +		if (gic_irq_state(PPI(info->irq)) == expected_state) {
>   			mdelay(100);
> -			if (gic_irq_state(info->irq) == expected_state)
> +			if (gic_irq_state(PPI(info->irq)) == expected_state)
>   				return true;
>   		}
>   	}
> diff --git a/lib/arm/gic.c b/lib/arm/gic.c
> index 0563b31132c8..3924dd1d1ee6 100644
> --- a/lib/arm/gic.c
> +++ b/lib/arm/gic.c
> @@ -150,22 +150,37 @@ void gic_ipi_send_mask(int irq, const cpumask_t *dest)
>   enum gic_irq_state gic_irq_state(int irq)
>   {
>   	enum gic_irq_state state;
> -	bool pending = false, active = false;
> -	void *base;
> +	void *ispendr, *isactiver;
> +	bool pending, active;
>   
>   	assert(gic_common_ops);

We can also assert that only interrupts with ID smaller than 1020
will be handled.

>   
>   	switch (gic_version()) {
>   	case 2:
> -		base = gicv2_dist_base();
> -		pending = readl(base + GICD_ISPENDR) & (1 << PPI(irq));
> -		active = readl(base + GICD_ISACTIVER) & (1 << PPI(irq));
> +		ispendr = gicv2_dist_base() + GICD_ISPENDR;
> +		isactiver = gicv2_dist_base() + GICD_ISACTIVER;
>   		break;
>   	case 3:
> -		base = gicv3_sgi_base();
> -		pending = readl(base + GICR_ISPENDR0) & (1 << PPI(irq));
> -		active = readl(base + GICR_ISACTIVER0) & (1 << PPI(irq));
> +		if (irq < GIC_NR_PRIVATE_IRQS) {
> +			ispendr = gicv3_sgi_base() + GICR_ISPENDR0;
> +			isactiver = gicv3_sgi_base() + GICR_ISACTIVER0;
> +		} else {
> +			ispendr = gicv3_dist_base() + GICD_ISPENDR;
> +			isactiver = gicv3_dist_base() + GICD_ISACTIVER;
> +		}
>   		break;
> +	default:
> +		assert(0);
> +	}
> +
> +	if (irq < GIC_NR_PRIVATE_IRQS) {
> +		pending = readl(ispendr) & (1 << irq);
> +		active = readl(isactiver) & (1 << irq);
> +	} else {
> +		int offset = (irq - GIC_FIRST_SPI) / 32;
> +		int mask = 1 << ((irq - GIC_FIRST_SPI) % 32);

No need to minus GIC_FIRST_SPI.  And therefore these two cases
can actually be merged.

> +		pending = readl(ispendr + offset) & mask;
> +		active = readl(isactiver + offset) & mask;
>   	}
>   
>   	if (!active && !pending)

Otherwise this looks good enough (to me) for now, and let's wait
other reviewers to comment.  I've used the following diff to give
the pl031 test a go (roughly written, not dig into PL031 so much),
it just works fine :)


Thanks,
Zenghui

diff --git a/arm/pl031.c b/arm/pl031.c
index 86035fa..2d4160f 100644
--- a/arm/pl031.c
+++ b/arm/pl031.c
@@ -118,11 +118,12 @@ static int check_rtc_freq(void)
  	return 0;
  }

-static bool gic_irq_pending(void)
+static bool gic_pl031_pending(void)
  {
-	uint32_t offset = (pl031_irq / 32) * 4;
+	enum gic_irq_state state = gic_irq_state(pl031_irq);

-	return readl(gic_ispendr + offset) & (1 << (pl031_irq & 31));
+	return state == GIC_IRQ_STATE_PENDING ||
+		state == GIC_IRQ_STATE_ACTIVE_PENDING;
  }

  static void gic_irq_unmask(void)

[...]
/* replace all gic_irq_pending() with gic_pl031_pending() */
[...]

diff --git a/lib/arm/gic.c b/lib/arm/gic.c
index 3924dd1..34d77e3 100644
--- a/lib/arm/gic.c
+++ b/lib/arm/gic.c
@@ -152,6 +152,7 @@ enum gic_irq_state gic_irq_state(int irq)
  	enum gic_irq_state state;
  	void *ispendr, *isactiver;
  	bool pending, active;
+	int offset, mask;

  	assert(gic_common_ops);

@@ -173,15 +174,10 @@ enum gic_irq_state gic_irq_state(int irq)
  		assert(0);
  	}

-	if (irq < GIC_NR_PRIVATE_IRQS) {
-		pending = readl(ispendr) & (1 << irq);
-		active = readl(isactiver) & (1 << irq);
-	} else {
-		int offset = (irq - GIC_FIRST_SPI) / 32;
-		int mask = 1 << ((irq - GIC_FIRST_SPI) % 32);
-		pending = readl(ispendr + offset) & mask;
-		active = readl(isactiver + offset) & mask;
-	}
+	offset = (irq / 32) * 4;
+	mask = 1 << (irq % 32);
+	pending = readl(ispendr + offset) & mask;
+	active = readl(isactiver + offset) & mask;

  	if (!active && !pending)
  		state = GIC_IRQ_STATE_INACTIVE;

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
