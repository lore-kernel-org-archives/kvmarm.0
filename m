Return-Path: <SRS0=mzwA=FH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36C27C433FE
	for <kvmarm@archiver.kernel.org>; Thu,  3 Dec 2020 14:57:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 63619206EC
	for <kvmarm@archiver.kernel.org>; Thu,  3 Dec 2020 14:57:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 63619206EC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF0994B1D0;
	Thu,  3 Dec 2020 09:57:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GVjG4c8Uakaf; Thu,  3 Dec 2020 09:57:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B8F14B198;
	Thu,  3 Dec 2020 09:57:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 82C864B198
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2020 09:57:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OKfP3Nt01TNb for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Dec 2020 09:57:25 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 741DA4B15D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2020 09:57:25 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id CA2E4206D6;
 Thu,  3 Dec 2020 14:57:23 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kkq2r-00FhLT-G9; Thu, 03 Dec 2020 14:57:21 +0000
MIME-Version: 1.0
Date: Thu, 03 Dec 2020 14:57:21 +0000
From: Marc Zyngier <maz@kernel.org>
To: Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH v2 2/2] clocksource: arm_arch_timer: Correct fault
 programming of CNTKCTL_EL1.EVNTI
In-Reply-To: <20200818032814.15968-3-zhukeqian1@huawei.com>
References: <20200818032814.15968-1-zhukeqian1@huawei.com>
 <20200818032814.15968-3-zhukeqian1@huawei.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <b232d02b2d9c3e29898914bd9bbb8dc5@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: zhukeqian1@huawei.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, steven.price@arm.com, drjones@redhat.com,
 catalin.marinas@arm.com, will@kernel.org, james.morse@arm.com,
 suzuki.poulose@arm.com, wanghaibin.wang@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, Steven Price <steven.price@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2020-08-18 04:28, Keqian Zhu wrote:
> ARM virtual counter supports event stream, it can only trigger an event
> when the trigger bit (the value of CNTKCTL_EL1.EVNTI) of CNTVCT_EL0 
> changes,
> so the actual period of event stream is 2^(cntkctl_evnti + 1). For 
> example,
> when the trigger bit is 0, then virtual counter trigger an event for 
> every
> two cycles.
> 
> Fixes: 037f637767a8 ("drivers: clocksource: add support for
>        ARM architected timer event stream")

Fixes: tags should on a single line.

> Suggested-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> ---
>  drivers/clocksource/arm_arch_timer.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/clocksource/arm_arch_timer.c
> b/drivers/clocksource/arm_arch_timer.c
> index 777d38c..e3b2ee0 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -824,10 +824,14 @@ static void arch_timer_configure_evtstream(void)
>  {
>  	int evt_stream_div, pos;
> 
> -	/* Find the closest power of two to the divisor */
> -	evt_stream_div = arch_timer_rate / ARCH_TIMER_EVT_STREAM_FREQ;
> +	/*
> +	 * Find the closest power of two to the divisor. As the event
> +	 * stream can at most be generated at half the frequency of the
> +	 * counter, use half the frequency when computing the divider.
> +	 */
> +	evt_stream_div = arch_timer_rate / ARCH_TIMER_EVT_STREAM_FREQ / 2;
>  	pos = fls(evt_stream_div);
> -	if (pos > 1 && !(evt_stream_div & (1 << (pos - 2))))
> +	if ((pos == 1) || (pos > 1 && !(evt_stream_div & (1 << (pos - 2)))))
>  		pos--;

You don't explain why you are special-casing pos == 1.

>  	/* enable event stream */
>  	arch_timer_evtstrm_enable(min(pos, 15));

Also, please Cc the subsystem maintainers:

CLOCKSOURCE, CLOCKEVENT DRIVERS
M:      Daniel Lezcano <daniel.lezcano@linaro.org>
M:      Thomas Gleixner <tglx@linutronix.de>
L:      linux-kernel@vger.kernel.org
S:      Supported
T:      git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git 
timers/core
F:      Documentation/devicetree/bindings/timer/
F:      drivers/clocksource/

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
