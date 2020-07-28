Return-Path: <SRS0=1hyK=BH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B4D3C433DF
	for <kvmarm@archiver.kernel.org>; Tue, 28 Jul 2020 10:16:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D450620829
	for <kvmarm@archiver.kernel.org>; Tue, 28 Jul 2020 10:16:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="VBdHKzom"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D450620829
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 804AD4B9A7;
	Tue, 28 Jul 2020 06:16:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id K5mez4u06fdo; Tue, 28 Jul 2020 06:16:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C4E64B989;
	Tue, 28 Jul 2020 06:16:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E2E984B989
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jul 2020 06:16:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EkMZIAVREe7f for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Jul 2020 06:16:50 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BC6CB4B954
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jul 2020 06:16:50 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 9BFB320714;
 Tue, 28 Jul 2020 10:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1595931409;
 bh=ZfZF4pLvNemxD3En2Fwag4OkbrDfzKVU9SSSrL6fd/A=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=VBdHKzomeWjgG1TMubp9tgrJfSfvIiWmv/K4FkXE5Rs7AJCr+6dTw7JhR+SJdMQYt
 fPlyE+EJ3CP6EqlEzoY0Ft3LE0pMPFyKPhAVwGK3Qo4iqhoODr1mWy8T3OvnA7FuDq
 4MT7WpcnF3emS2LhtbRxOesdw6RmcyTlTn3bQdJM=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1k0Mf9-00FcMr-Ug; Tue, 28 Jul 2020 11:16:48 +0100
MIME-Version: 1.0
Date: Tue, 28 Jul 2020 11:16:47 +0100
From: Marc Zyngier <maz@kernel.org>
To: Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [RESEND PATCH] drivers: arm arch timer: Correct fault programming
 of CNTKCTL_EL1.EVNTI
In-Reply-To: <20200717092104.15428-1-zhukeqian1@huawei.com>
References: <20200717092104.15428-1-zhukeqian1@huawei.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <3a95ec8ce3e34d86c09f9b1b4f17d0ad@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: zhukeqian1@huawei.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org,
 james.morse@arm.com, suzuki.poulose@arm.com, wanghaibin.wang@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On 2020-07-17 10:21, Keqian Zhu wrote:
> ARM virtual counter supports event stream. It can only trigger an event
> when the trigger bit of CNTVCT_EL0 changes from 0 to 1 (or from 1 to 
> 0),
> so the actual period of event stream is 2 ^ (cntkctl_evnti + 1). For
> example, when the trigger bit is 0, then it triggers an event for every
> two cycles.
> 
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> ---
>  drivers/clocksource/arm_arch_timer.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/clocksource/arm_arch_timer.c
> b/drivers/clocksource/arm_arch_timer.c
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

This looks like a very convoluted fix. If the problem you are
trying to fix is that the event frequency is at most half of
that of the counter, why isn't the patch below the most
obvious fix?

Thanks,

         M.

diff --git a/drivers/clocksource/arm_arch_timer.c 
b/drivers/clocksource/arm_arch_timer.c
index 6c3e84180146..0a65414b781f 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -824,8 +824,12 @@ static void arch_timer_configure_evtstream(void)
  {
  	int evt_stream_div, pos;

-	/* Find the closest power of two to the divisor */
-	evt_stream_div = arch_timer_rate / ARCH_TIMER_EVT_STREAM_FREQ;
+	/*
+	 * Find the closest power of two to the divisor. As the event
+	 * stream can at most be generated at half the frequency of the
+	 * counter, use half the frequency when computing the divider.
+	 */
+	evt_stream_div = arch_timer_rate / ARCH_TIMER_EVT_STREAM_FREQ / 2;
  	pos = fls(evt_stream_div);
  	if (pos > 1 && !(evt_stream_div & (1 << (pos - 2))))
  		pos--;

-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
