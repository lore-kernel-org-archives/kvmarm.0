Return-Path: <SRS0=6Z91=G2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A437BC433DB
	for <kvmarm@archiver.kernel.org>; Sat, 23 Jan 2021 14:08:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 091E722C7B
	for <kvmarm@archiver.kernel.org>; Sat, 23 Jan 2021 14:08:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 091E722C7B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DDB44B153;
	Sat, 23 Jan 2021 09:08:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Q4vtSRaWa4dP; Sat, 23 Jan 2021 09:08:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A63C4B154;
	Sat, 23 Jan 2021 09:08:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E3AAB4B14A
 for <kvmarm@lists.cs.columbia.edu>; Sat, 23 Jan 2021 09:08:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id S+bTcf1Xp9Tl for <kvmarm@lists.cs.columbia.edu>;
 Sat, 23 Jan 2021 09:07:59 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DE9394B0E9
 for <kvmarm@lists.cs.columbia.edu>; Sat, 23 Jan 2021 09:07:59 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2961022B51;
 Sat, 23 Jan 2021 14:07:56 +0000 (UTC)
Date: Sat, 23 Jan 2021 14:07:53 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v4 14/21] arm64: Honor VHE being disabled from the
 command-line
Message-ID: <YAwtuZZpTwwoMqrk@Catalins-MacBook-Air.local>
References: <20210118094533.2874082-1-maz@kernel.org>
 <20210118094533.2874082-15-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210118094533.2874082-15-maz@kernel.org>
Cc: Prasad Sodagudi <psodagud@codeaurora.org>,
 Srinivas Ramana <sramana@codeaurora.org>, linux-kernel@vger.kernel.org,
 Ard Biesheuvel <ardb@kernel.org>, Ajay Patil <pajay@qti.qualcomm.com>,
 kernel-team@android.com, Will Deacon <will@kernel.org>,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Mon, Jan 18, 2021 at 09:45:26AM +0000, Marc Zyngier wrote:
> diff --git a/arch/arm64/kernel/hyp-stub.S b/arch/arm64/kernel/hyp-stub.S
> index 59820f9b8522..bbab2148a2a2 100644
> --- a/arch/arm64/kernel/hyp-stub.S
> +++ b/arch/arm64/kernel/hyp-stub.S
> @@ -77,13 +77,24 @@ SYM_CODE_END(el1_sync)
>  SYM_CODE_START_LOCAL(mutate_to_vhe)
>  	// Sanity check: MMU *must* be off
>  	mrs	x0, sctlr_el2
> -	tbnz	x0, #0, 1f
> +	tbnz	x0, #0, 2f
>  
>  	// Needs to be VHE capable, obviously
>  	mrs	x0, id_aa64mmfr1_el1
>  	ubfx	x0, x0, #ID_AA64MMFR1_VHE_SHIFT, #4
> -	cbz	x0, 1f
> +	cbz	x0, 2f
>  
> +	// Check whether VHE is disabled from the command line
> +	adr_l	x1, id_aa64mmfr1_val
> +	ldr	x0, [x1]
> +	adr_l	x1, id_aa64mmfr1_mask
> +	ldr	x1, [x1]
> +	ubfx	x0, x0, #ID_AA64MMFR1_VHE_SHIFT, #4
> +	ubfx	x1, x1, #ID_AA64MMFR1_VHE_SHIFT, #4
> +	cbz	x1, 1f
> +	and	x0, x0, x1
> +	cbz	x0, 2f
> +1:

I can see the advantage here in separate id_aa64mmfr1_val/mask but we
could use some asm offsets here and keep the pointer indirection simpler
in C code. You'd just need something like 'adr_l mmfr1_ovrd + VAL_OFFSET'.

Anyway, if you have a strong preference for the current approach, leave
it as is.

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
