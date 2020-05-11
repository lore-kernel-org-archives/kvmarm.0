Return-Path: <SRS0=e6Jp=6Z=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53CD4C54E4B
	for <kvmarm@archiver.kernel.org>; Mon, 11 May 2020 10:05:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CB8512082E
	for <kvmarm@archiver.kernel.org>; Mon, 11 May 2020 10:05:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="1S0hrvTO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CB8512082E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FD384B0B3;
	Mon, 11 May 2020 06:05:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AVnAxpsqEbwW; Mon, 11 May 2020 06:05:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 87FDB4B0A1;
	Mon, 11 May 2020 06:05:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 808504B0A1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 May 2020 06:05:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4t7LHmiYF+QB for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 May 2020 06:05:08 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 678004B0A0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 May 2020 06:05:08 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 3830A20720;
 Mon, 11 May 2020 10:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1589191507;
 bh=E+mKJuj4Us4haykExfdIq1d4iuKiBTncDiuwyBJJnZc=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=1S0hrvTORHavnYfk4jkXveWVsUk0xbGEJVQZsRkrry5xEex0cvkimVVGxCe0Hmt5B
 0n/tbrjMbMdVgy7z8oRCBt+p+SbF7wUN+GjxzAl1KbzbHl3iI5242omiq7ruIyZERe
 G15b9BhKyOWEW2AWn57vy8AkaZGqD2jSPLN6iTPQ=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jY5J3-00BFK0-KQ; Mon, 11 May 2020 11:05:05 +0100
Date: Mon, 11 May 2020 11:04:59 +0100
From: Marc Zyngier <maz@kernel.org>
To: David Brazdil <dbrazdil@google.com>
Subject: Re: [PATCH 06/15] arm64: kvm: Move __smccc_workaround_1_smc to .rodata
Message-ID: <20200511110459.1fcf4db7@why>
In-Reply-To: <20200430144831.59194-7-dbrazdil@google.com>
References: <20200430144831.59194-1-dbrazdil@google.com>
 <20200430144831.59194-7-dbrazdil@google.com>
Organization: Approximate
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: dbrazdil@google.com, catalin.marinas@arm.com,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Thu, 30 Apr 2020 15:48:22 +0100
David Brazdil <dbrazdil@google.com> wrote:

> This snippet of assembly is used by cpu_errata.c to overwrite parts of KVM hyp
> vector. It is never directly executed, so move it from .text to .rodata.
> 
> Signed-off-by: David Brazdil <dbrazdil@google.com>
> ---
>  arch/arm64/kvm/hyp/hyp-entry.S | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
> index 5986e1d78d3f..7e5f386c5c2d 100644
> --- a/arch/arm64/kvm/hyp/hyp-entry.S
> +++ b/arch/arm64/kvm/hyp/hyp-entry.S
> @@ -364,6 +364,11 @@ SYM_CODE_END(__bp_harden_hyp_vecs)
>  	.popsection
>  
>  #ifndef __HYPERVISOR__
> +	/*
> +	 * This is not executed directly and is instead copied into the vectors
> +	 * by install_bp_hardening_cb().
> +	 */
> +	.pushsection	.rodata
>  SYM_CODE_START(__smccc_workaround_1_smc)

I wonder whether we should keep the SYM_CODE_START() annotation or not.
It feels weird to say "code" in a rodata section, and the alignment
doesn't matter as we copy it in place, as you noticed.

>  	esb
>  	sub	sp, sp, #(8 * 4)
> @@ -377,5 +382,6 @@ SYM_CODE_START(__smccc_workaround_1_smc)
>  1:	.org __smccc_workaround_1_smc + __SMCCC_WORKAROUND_1_SMC_SZ
>  	.org 1b
>  SYM_CODE_END(__smccc_workaround_1_smc)
> +	.popsection
>  #endif /* __HYPERVISOR__ */
>  #endif /* CONFIG_KVM_INDIRECT_VECTORS */

Otherwise, looks good.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
