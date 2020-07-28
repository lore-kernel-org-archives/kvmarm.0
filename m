Return-Path: <SRS0=1hyK=BH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 438D1C433E4
	for <kvmarm@archiver.kernel.org>; Tue, 28 Jul 2020 07:40:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BAB6A2250E
	for <kvmarm@archiver.kernel.org>; Tue, 28 Jul 2020 07:40:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BAB6A2250E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 266214B8DB;
	Tue, 28 Jul 2020 03:40:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WHfelUAs--ya; Tue, 28 Jul 2020 03:40:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0458D4B8DD;
	Tue, 28 Jul 2020 03:40:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C2CE84B8DA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jul 2020 03:39:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kisK0nZUGKoR for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Jul 2020 03:39:57 -0400 (EDT)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3374A4B8D9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jul 2020 03:39:57 -0400 (EDT)
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id 7A34D52C142BC77B2F15;
 Tue, 28 Jul 2020 15:39:51 +0800 (CST)
Received: from [10.174.187.22] (10.174.187.22) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Tue, 28 Jul 2020 15:39:40 +0800
Subject: Re: [RESEND PATCH] drivers: arm arch timer: Correct fault programming
 of CNTKCTL_EL1.EVNTI
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>
References: <20200717092104.15428-1-zhukeqian1@huawei.com>
From: zhukeqian <zhukeqian1@huawei.com>
Message-ID: <b3d2fe2f-a64b-af37-dea0-fa76a14ac2bc@huawei.com>
Date: Tue, 28 Jul 2020 15:39:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20200717092104.15428-1-zhukeqian1@huawei.com>
X-Originating-IP: [10.174.187.22]
X-CFilter-Loop: Reflected
Cc: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>
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

Friendly ping.
Is this an effective bugfix?

On 2020/7/17 17:21, Keqian Zhu wrote:
> ARM virtual counter supports event stream. It can only trigger an event
> when the trigger bit of CNTVCT_EL0 changes from 0 to 1 (or from 1 to 0),
> so the actual period of event stream is 2 ^ (cntkctl_evnti + 1). For
> example, when the trigger bit is 0, then it triggers an event for every
> two cycles.
> 
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> ---
>  drivers/clocksource/arm_arch_timer.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
> index ecf7b7db2d05..06d99a4b1b9b 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -799,10 +799,20 @@ static void __arch_timer_setup(unsigned type,
>  static void arch_timer_evtstrm_enable(int divider)
>  {
>  	u32 cntkctl = arch_timer_get_cntkctl();
> +	int cntkctl_evnti;
> +
> +	/*
> +	 * Note that it can only trigger an event when the trigger bit
> +	 * of CNTVCT_EL0 changes from 1 to 0 (or from 0 to 1), so the
> +	 * actual period of event stream is 2 ^ (cntkctl_evnti + 1).
> +	 */
> +	cntkctl_evnti = divider - 1;
> +	cntkctl_evnti = min(cntkctl_evnti, 15);
> +	cntkctl_evnti = max(cntkctl_evnti, 0);
>  
>  	cntkctl &= ~ARCH_TIMER_EVT_TRIGGER_MASK;
>  	/* Set the divider and enable virtual event stream */
> -	cntkctl |= (divider << ARCH_TIMER_EVT_TRIGGER_SHIFT)
> +	cntkctl |= (cntkctl_evnti << ARCH_TIMER_EVT_TRIGGER_SHIFT)
>  			| ARCH_TIMER_VIRT_EVT_EN;
>  	arch_timer_set_cntkctl(cntkctl);
>  	arch_timer_set_evtstrm_feature();
> @@ -816,10 +826,11 @@ static void arch_timer_configure_evtstream(void)
>  	/* Find the closest power of two to the divisor */
>  	evt_stream_div = arch_timer_rate / ARCH_TIMER_EVT_STREAM_FREQ;
>  	pos = fls(evt_stream_div);
> -	if (pos > 1 && !(evt_stream_div & (1 << (pos - 2))))
> +	if ((pos == 1) || (pos > 1 && !(evt_stream_div & (1 << (pos - 2)))))
>  		pos--;
> +
>  	/* enable event stream */
> -	arch_timer_evtstrm_enable(min(pos, 15));
> +	arch_timer_evtstrm_enable(pos);
>  }
>  
>  static void arch_counter_set_user_access(void)
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
