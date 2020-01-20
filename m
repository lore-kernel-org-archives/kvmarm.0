Return-Path: <SRS0=lFwt=3J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6F88C2D0DB
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jan 2020 10:46:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 43FFB20674
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jan 2020 10:46:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 43FFB20674
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9197D4AEEC;
	Mon, 20 Jan 2020 05:46:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wAEo1UavcssE; Mon, 20 Jan 2020 05:46:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 644924AEEE;
	Mon, 20 Jan 2020 05:46:16 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B7FD74AEEB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jan 2020 05:46:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Y+ZdI2KgrNhW for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Jan 2020 05:46:07 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 902A24AEDB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jan 2020 05:46:07 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0685330E;
 Mon, 20 Jan 2020 02:46:07 -0800 (PST)
Received: from [10.2.69.39] (unknown [10.2.69.39])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 81BAA3F68E;
 Mon, 20 Jan 2020 02:46:06 -0800 (PST)
Subject: Re: [PATCH] ARM: virt: Relax arch timer version check during early
 boot
To: linux-arm-kernel@lists.infradead.org
References: <1579097798-106243-1-git-send-email-vladimir.murzin@arm.com>
From: Vladimir Murzin <vladimir.murzin@arm.com>
Message-ID: <eb889279-87f2-d674-9299-169794c285eb@arm.com>
Date: Mon, 20 Jan 2020 10:46:05 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1579097798-106243-1-git-send-email-vladimir.murzin@arm.com>
Content-Language: en-US
Cc: maz@kernel.org, kvmarm@lists.cs.columbia.edu
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

+ Marc
+ kvmarm@lists.cs.columbia.edu

On 1/15/20 2:16 PM, Vladimir Murzin wrote:
> Updates to the Generic Timer architecture allow ID_PFR1.GenTimer to
> have values other than 0 or 1. At the moment, Linux is quite strict in
> the way it handles this field at early boot and will not configure
> arch timer if it doesn't find the value 1.
> 
> Since here use ubfx for arch timer version extraction (hyb-stub build
> with -march=armv7-a, so it is safe)
> 
> To help backports (even though the code was correct at the time of writing)
> Fixes: 8ec58be9f3ff ("ARM: virt: arch_timers: enable access to physical timers")
> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
> ---
>  arch/arm/kernel/hyp-stub.S | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/kernel/hyp-stub.S b/arch/arm/kernel/hyp-stub.S
> index ae50203..6607fa8 100644
> --- a/arch/arm/kernel/hyp-stub.S
> +++ b/arch/arm/kernel/hyp-stub.S
> @@ -146,10 +146,9 @@ ARM_BE8(orr	r7, r7, #(1 << 25))     @ HSCTLR.EE
>  #if !defined(ZIMAGE) && defined(CONFIG_ARM_ARCH_TIMER)
>  	@ make CNTP_* and CNTPCT accessible from PL1
>  	mrc	p15, 0, r7, c0, c1, 1	@ ID_PFR1
> -	lsr	r7, #16
> -	and	r7, #0xf
> -	cmp	r7, #1
> -	bne	1f
> +	ubfx	r7, r7, #16, #4
> +	teq	r7, #0
> +	beq	1f
>  	mrc	p15, 4, r7, c14, c1, 0	@ CNTHCTL
>  	orr	r7, r7, #3		@ PL1PCEN | PL1PCTEN
>  	mcr	p15, 4, r7, c14, c1, 0	@ CNTHCTL
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
