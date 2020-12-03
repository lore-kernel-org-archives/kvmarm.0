Return-Path: <SRS0=mzwA=FH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE9ACC433FE
	for <kvmarm@archiver.kernel.org>; Thu,  3 Dec 2020 14:58:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2CF05206EC
	for <kvmarm@archiver.kernel.org>; Thu,  3 Dec 2020 14:58:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2CF05206EC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9639F4B1D0;
	Thu,  3 Dec 2020 09:58:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DM4X8vWTgv50; Thu,  3 Dec 2020 09:58:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A80C4B1E8;
	Thu,  3 Dec 2020 09:58:34 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D22254B1D4
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2020 09:58:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 24dTpDMs8uoa for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Dec 2020 09:58:33 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E38044B1D0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2020 09:58:32 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 9AEF2206D6;
 Thu,  3 Dec 2020 14:58:31 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kkq3v-00FhMk-F6; Thu, 03 Dec 2020 14:58:27 +0000
MIME-Version: 1.0
Date: Thu, 03 Dec 2020 14:58:27 +0000
From: Marc Zyngier <maz@kernel.org>
To: Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH v2 1/2] clocksource: arm_arch_timer: Use stable count
 reader in erratum sne
In-Reply-To: <20200818032814.15968-2-zhukeqian1@huawei.com>
References: <20200818032814.15968-1-zhukeqian1@huawei.com>
 <20200818032814.15968-2-zhukeqian1@huawei.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <c8e0506a7976deef0427a30b0d10e35b@kernel.org>
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
> In commit 0ea415390cd3 ("clocksource/arm_arch_timer: Use 
> arch_timer_read_counter
> to access stable counters"), we separate stable and normal count reader 
> to omit
> unnecessary overhead on systems that have no timer erratum.
> 
> However, in erratum_set_next_event_tval_generic(), count reader becomes 
> normal
> reader. This converts it to stable reader.
> 
> Fixes: 0ea415390cd3 ("clocksource/arm_arch_timer: Use
>        arch_timer_read_counter to access stable counters")

On a single line.

> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> ---
>  drivers/clocksource/arm_arch_timer.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/clocksource/arm_arch_timer.c
> b/drivers/clocksource/arm_arch_timer.c
> index 6c3e841..777d38c 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -396,10 +396,10 @@ static void
> erratum_set_next_event_tval_generic(const int access, unsigned long
>  	ctrl &= ~ARCH_TIMER_CTRL_IT_MASK;
> 
>  	if (access == ARCH_TIMER_PHYS_ACCESS) {
> -		cval = evt + arch_counter_get_cntpct();
> +		cval = evt + arch_counter_get_cntpct_stable();
>  		write_sysreg(cval, cntp_cval_el0);
>  	} else {
> -		cval = evt + arch_counter_get_cntvct();
> +		cval = evt + arch_counter_get_cntvct_stable();
>  		write_sysreg(cval, cntv_cval_el0);
>  	}

With that fixed:

Acked-by: Marc Zyngier <maz@kernel.org>

This should go via the clocksource tree.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
