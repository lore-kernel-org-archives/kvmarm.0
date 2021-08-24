Return-Path: <SRS0=IXmk=NP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AADE2C4320A
	for <kvmarm@archiver.kernel.org>; Tue, 24 Aug 2021 13:27:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 36C3461220
	for <kvmarm@archiver.kernel.org>; Tue, 24 Aug 2021 13:27:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 36C3461220
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FEE44B0CD;
	Tue, 24 Aug 2021 09:27:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ODAgzvOSP825; Tue, 24 Aug 2021 09:27:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B3E364B0F7;
	Tue, 24 Aug 2021 09:27:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6004C4B0E1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Aug 2021 09:27:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id z9YmW1yBsS6F for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Aug 2021 09:27:29 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D9F84B0CD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Aug 2021 09:27:29 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E408A1042;
 Tue, 24 Aug 2021 06:27:28 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 929953F5A1;
 Tue, 24 Aug 2021 06:27:27 -0700 (PDT)
Subject: Re: [PATCH] arm64: Do not trap PMSNEVFR_EL1
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 broonie@kernel.org, Catalin Marinas <Catalin.Marinas@arm.com>,
 Will Deacon <will@kernel.org>
References: <20210824132459.562923-1-alexandru.elisei@arm.com>
Message-ID: <01117fe3-d4fa-a735-36e1-ac9003e7b5cb@arm.com>
Date: Tue, 24 Aug 2021 14:28:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210824132459.562923-1-alexandru.elisei@arm.com>
Content-Language: en-US
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

Errr... somehow I forgot to add the arm64 maintainers. Fixing that.

On 8/24/21 2:24 PM, Alexandru Elisei wrote:
> Commit 31c00d2aeaa2 ("arm64: Disable fine grained traps on boot") zeroed
> the fine grained trap registers to prevent unwanted register traps from
> occuring. However, for the PMSNEVFR_EL1 register, the corresponding
> HDFGRTR_EL2.nPMSNEVFR_EL1 field must be 1 to disable trapping. Set the
> field to 1 if FEAT_SPEv1p2 is detected.
>
> Fixes: 31c00d2aeaa2 ("arm64: Disable fine grained traps on boot")
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
> Based on v5.14-rc7. Also, we could write 1 << 62 to HDFGRTR_EL2 unconditionally
> since the field is RAZ/WI if !FEAT_SPEv1p2. I don't have a strong preference for
> either approaches, but I chose this implementation because it's clearer (even
> though it's more verbose and it's one extra trap on NV).
>
> Tested on the model, using boot-wrapper built from commit 5cd6238ec4ef
> ("aarch32: fix .globl replacement"). Without this patch, in NVHE mode, the model
> freezes when I try to read PMSNEVFR_EL1. With this patch, the model doesn't hang
> when I read the register, but it hangs when I write to it. I've gone throught
> the pseudocode for reading and writing to PMSNEVFR_EL1 and from what I can tell
> nothing should be trapping the accesses. On top of that, this is what I tried on
> the model with this patch applied:
>
> 1. VHE mode, I can read and write to PMSNEVFR_EL1 without any issues, so the
> hang is not caused by an incorrect EL3 configuration.
>
> 2. NVHE mode, I can read and write just fine to *PMSEVFR_EL1*, so the hang is
> not caused by an EL2 trap that affects the rest of the profiling control
> registers. I have tried printing the HDFGRTR_EL2 value in this situation using
> semihosting, the value is what it is programmed by __init_el2_fgt (that is,
> 1 << 62).
>
> At this point, I am inclined to think it's a model bug because reading works,
> but writing causes a hang and that looks very suspicious to me. I'm going to
> open a model bug internally and see what comes of it.
>
>  arch/arm64/include/asm/el2_setup.h | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
> index b83fb24954b7..8a9adb2039fd 100644
> --- a/arch/arm64/include/asm/el2_setup.h
> +++ b/arch/arm64/include/asm/el2_setup.h
> @@ -149,7 +149,16 @@
>  	ubfx	x1, x1, #ID_AA64MMFR0_FGT_SHIFT, #4
>  	cbz	x1, .Lskip_fgt_\@
>  
> -	msr_s	SYS_HDFGRTR_EL2, xzr
> +	mov	x0, xzr
> +	mrs	x1, id_aa64dfr0_el1
> +	ubfx	x1, x1, #ID_AA64DFR0_PMSVER_SHIFT, #4
> +	cmp	x1, #3
> +	b.lt	.Lset_fgt_\@
> +	/* Set HDFGRTR_EL2.nPMSNEVFR_EL1 to disable the register trap */
> +	orr	x0, x0, #(1 << 62)
> +
> +.Lset_fgt_\@:
> +	msr_s	SYS_HDFGRTR_EL2, x0
>  	msr_s	SYS_HDFGWTR_EL2, xzr
>  	msr_s	SYS_HFGRTR_EL2, xzr
>  	msr_s	SYS_HFGWTR_EL2, xzr
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
