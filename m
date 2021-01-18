Return-Path: <SRS0=ax30=GV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E280EC433DB
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jan 2021 11:25:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 422BE222B3
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jan 2021 11:25:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 422BE222B3
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B704D4B253;
	Mon, 18 Jan 2021 06:25:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zPyOvowAObwz; Mon, 18 Jan 2021 06:25:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 77CB04B279;
	Mon, 18 Jan 2021 06:25:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E4434B272
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 06:25:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iiMxNKyQF1+F for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jan 2021 06:25:20 -0500 (EST)
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com
 [209.85.221.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D406F4B253
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 06:25:19 -0500 (EST)
Received: by mail-wr1-f54.google.com with SMTP id d13so16047299wrc.13
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 03:25:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=XYCl/7LEBptqBylZzqxKLPCyZs5+nBXkfq6fYhltRm0=;
 b=nShMz5jN5vJE2BGQ9VJ9TjIZF4htJVLD4cX2LUoWMIjfMUrrCteI+U6K6+De/YUcaQ
 qju3PMamZnZO4wzdRl5neqqXMAchPPvyszz780zvOgvjoQfEVloS9pgx3nvflUf6Eqik
 OxNmeToQISyMeu7FGHHKjjM+kWRilooyIqNUDdUYIICAZaH0OJViPmkwgoGYypg5LZN6
 rQi9q4Qq6FQxNoWIhTvM532m3z96QwpV8akhCPQuvfD4zLCuTsuJ4WAfECoq6lNhpEuA
 WQVX0l5viz7FroSzF5PsZLhzSgLsJteYZtm0t3dBSblFencKZCIkmRlAnyWcmPJfBDUd
 +35Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=XYCl/7LEBptqBylZzqxKLPCyZs5+nBXkfq6fYhltRm0=;
 b=Nwlk6ttbWZRMoBSKvioGaPaYz472WC5kAC4ZGROQQn8q9YzN8RiWDfQCGCvy1xvJr5
 XmWZ6fI9A20+t83Ynbl8YWZx618bMxpUi9rdCIk07gdef/TJeA1afKKx++1W1vcKb1Wt
 LZ5UlVQBH1ALjBNBClc1CUIJqOchIx5443JQAFHl5yL03puLkGH2aVH8EYIHErVnoGtj
 TMLRAC0mxD+h/gifsP5iu0wN2dfxSrIaxBHFC3wGXl7t2IGjfNbcFXE+qwx5nkXvIQqa
 11jLFI+ZHtcP6Ks4p4PIgA7sLDusrm9Tnw1eGXD0d6sDJZtphKSAMrfkdXwvlMIwcG92
 rd/Q==
X-Gm-Message-State: AOAM531r5NV57mKHM28FS/XDDN97qgO4ddD3t8PocAohxXM/mnHPKFcQ
 feFZCYsCcaVHUn55hO0+KH53DQ==
X-Google-Smtp-Source: ABdhPJwJwPpnZuDApRSlME2GxkH9HCddnQ1/MxIWxbrkWuSlN59LquzRy2Ly9w2y5hLE1ChWeNwdRw==
X-Received: by 2002:adf:decb:: with SMTP id i11mr25457327wrn.26.1610969118728; 
 Mon, 18 Jan 2021 03:25:18 -0800 (PST)
Received: from google.com ([2a01:4b00:8523:2d03:3d4d:985d:87b7:4d55])
 by smtp.gmail.com with ESMTPSA id o14sm25505406wmc.28.2021.01.18.03.25.17
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 18 Jan 2021 03:25:17 -0800 (PST)
Date: Mon, 18 Jan 2021 11:25:16 +0000
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v4 04/21] arm64: Provide an 'upgrade to VHE' stub hypercall
Message-ID: <20210118112516.6a7lnrtbjvey4iiv@google.com>
References: <20210118094533.2874082-1-maz@kernel.org>
 <20210118094533.2874082-5-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210118094533.2874082-5-maz@kernel.org>
Cc: kernel-team@android.com, Srinivas Ramana <sramana@codeaurora.org>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Ard Biesheuvel <ardb@kernel.org>, Ajay Patil <pajay@qti.qualcomm.com>,
 Prasad Sodagudi <psodagud@codeaurora.org>, Will Deacon <will@kernel.org>,
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

On Mon, Jan 18, 2021 at 09:45:16AM +0000, Marc Zyngier wrote:
> As we are about to change the way a VHE system boots, let's
> provide the core helper, in the form of a stub hypercall that
> enables VHE and replicates the full EL1 context at EL2, thanks
> to EL1 and VHE-EL2 being extremely similar.
> 
> On exception return, the kernel carries on at EL2. Fancy!
> 
> Nothing calls this new hypercall yet, so no functional change.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/virt.h |  7 +++-
>  arch/arm64/kernel/hyp-stub.S  | 67 +++++++++++++++++++++++++++++++++--
>  2 files changed, 71 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
> index ee6a48df89d9..7379f35ae2c6 100644
> --- a/arch/arm64/include/asm/virt.h
> +++ b/arch/arm64/include/asm/virt.h
> @@ -35,8 +35,13 @@
>   */
>  #define HVC_RESET_VECTORS 2
>  
> +/*
> + * HVC_VHE_RESTART - Upgrade the CPU from EL1 to EL2, if possible
> + */
> +#define HVC_VHE_RESTART	3
> +
>  /* Max number of HYP stub hypercalls */
> -#define HVC_STUB_HCALL_NR 3
> +#define HVC_STUB_HCALL_NR 4
>  
>  /* Error returned when an invalid stub number is passed into x0 */
>  #define HVC_STUB_ERR	0xbadca11
> diff --git a/arch/arm64/kernel/hyp-stub.S b/arch/arm64/kernel/hyp-stub.S
> index 160f5881a0b7..fb12398b5c28 100644
> --- a/arch/arm64/kernel/hyp-stub.S
> +++ b/arch/arm64/kernel/hyp-stub.S
> @@ -8,9 +8,9 @@
>  
>  #include <linux/init.h>
>  #include <linux/linkage.h>
> -#include <linux/irqchip/arm-gic-v3.h>
>  
>  #include <asm/assembler.h>
> +#include <asm/el2_setup.h>
>  #include <asm/kvm_arm.h>
>  #include <asm/kvm_asm.h>
>  #include <asm/ptrace.h>
> @@ -47,10 +47,13 @@ SYM_CODE_END(__hyp_stub_vectors)
>  
>  SYM_CODE_START_LOCAL(el1_sync)
>  	cmp	x0, #HVC_SET_VECTORS
> -	b.ne	2f
> +	b.ne	1f
>  	msr	vbar_el2, x1
>  	b	9f
>  
> +1:	cmp	x0, #HVC_VHE_RESTART
> +	b.eq	mutate_to_vhe
> +
>  2:	cmp	x0, #HVC_SOFT_RESTART
>  	b.ne	3f
>  	mov	x0, x2
> @@ -70,6 +73,66 @@ SYM_CODE_START_LOCAL(el1_sync)
>  	eret
>  SYM_CODE_END(el1_sync)
>  
> +// nVHE? No way! Give me the real thing!
> +SYM_CODE_START_LOCAL(mutate_to_vhe)
> +	// Sanity check: MMU *must* be off
> +	mrs	x0, sctlr_el2
> +	tbnz	x0, #0, 1f
> +
> +	// Needs to be VHE capable, obviously
> +	mrs	x0, id_aa64mmfr1_el1
> +	ubfx	x0, x0, #ID_AA64MMFR1_VHE_SHIFT, #4
> +	cbz	x0, 1f

nit: There is a HVC_STUB_ERR that you could return if these sanity checks fail.
The documentation also states that it should be returned on error.

> +
> +	// Engage the VHE magic!
> +	mov_q	x0, HCR_HOST_VHE_FLAGS
> +	msr	hcr_el2, x0
> +	isb
> +
> +	// Doesn't do much on VHE, but still, worth a shot
> +	init_el2_state vhe
> +
> +	// Use the EL1 allocated stack, per-cpu offset
> +	mrs	x0, sp_el1
> +	mov	sp, x0
> +	mrs	x0, tpidr_el1
> +	msr	tpidr_el2, x0
> +
> +	// FP configuration, vectors
> +	mrs_s	x0, SYS_CPACR_EL12
> +	msr	cpacr_el1, x0
> +	mrs_s	x0, SYS_VBAR_EL12
> +	msr	vbar_el1, x0
> +
> +	// Transfer the MM state from EL1 to EL2
> +	mrs_s	x0, SYS_TCR_EL12
> +	msr	tcr_el1, x0
> +	mrs_s	x0, SYS_TTBR0_EL12
> +	msr	ttbr0_el1, x0
> +	mrs_s	x0, SYS_TTBR1_EL12
> +	msr	ttbr1_el1, x0
> +	mrs_s	x0, SYS_MAIR_EL12
> +	msr	mair_el1, x0
> +	isb
> +
> +	// Invalidate TLBs before enabling the MMU
> +	tlbi	vmalle1
> +	dsb	nsh
> +
> +	// Enable the EL2 S1 MMU, as set up from EL1
> +	mrs_s	x0, SYS_SCTLR_EL12
> +	set_sctlr_el1	x0
> +
> +	// Hack the exception return to stay at EL2
> +	mrs	x0, spsr_el1
> +	and	x0, x0, #~PSR_MODE_MASK
> +	mov	x1, #PSR_MODE_EL2h
> +	orr	x0, x0, x1
> +	msr	spsr_el1, x0
> +
> +1:	eret
> +SYM_CODE_END(mutate_to_vhe)
> +
>  .macro invalid_vector	label
>  SYM_CODE_START_LOCAL(\label)
>  	b \label
> -- 
> 2.29.2
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
