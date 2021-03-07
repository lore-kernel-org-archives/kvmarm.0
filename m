Return-Path: <SRS0=mzoY=IG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEE14C433DB
	for <kvmarm@archiver.kernel.org>; Mon,  8 Mar 2021 20:08:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6453165266
	for <kvmarm@archiver.kernel.org>; Mon,  8 Mar 2021 20:08:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6453165266
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC4C84B643;
	Mon,  8 Mar 2021 15:08:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qTO-AuKtlj-l; Mon,  8 Mar 2021 15:08:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 48FB14B5B7;
	Mon,  8 Mar 2021 15:08:54 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EB45A4B2A7
 for <kvmarm@lists.cs.columbia.edu>; Sat,  6 Mar 2021 23:35:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mM06e+vE-w8r for <kvmarm@lists.cs.columbia.edu>;
 Sat,  6 Mar 2021 23:35:52 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 21AE34B2A2
 for <kvmarm@lists.cs.columbia.edu>; Sat,  6 Mar 2021 23:35:52 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56F4A650B1;
 Sun,  7 Mar 2021 04:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1615091750;
 bh=bGnLAzbseG7Hvf7WtaKuqW98AvCQaRA0f3+tjl5et9E=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=sFwb35J2J3JEUCV2LRfNrkdeFOfSy4v9lut+kKnrsezWVzqi7r4QweZekd8H9ONh5
 Cn6vKiY2baFCmc18EBSCXD1sfuitp7kpTY5IOMdDQ449mxPdO6OrOemiSREy0cQT7f
 11MkmSdeLdGyO5WiAv/NBsolD6PLwg8fm4DVlzmHwQtQ3ZlyOk2K2O7LYuf5QpYRP0
 9DAA2Kahj0yKcN+hCBl81TFzC6qgWmyqe/8qgYooCNNtSRw/jOetQXT/LbzSzNpuSh
 0TIvkSblicdnSpUtsr4ZYqfBiuMfd8P4Wmh+he7JxvDHNL5YxWfy6NY8zKWtuLTc13
 oO7CIDNN2otAg==
Date: Sat, 6 Mar 2021 21:35:45 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH] KVM: arm64: Don't use cbz/adr with external symbols
Message-ID: <20210307043545.pyxy22z3rktgof4m@archlinux-ax161>
References: <20210305202124.3768527-1-samitolvanen@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210305202124.3768527-1-samitolvanen@google.com>
X-Mailman-Approved-At: Mon, 08 Mar 2021 15:08:53 -0500
Cc: Kees Cook <keescook@chromium.org>, Marc Zyngier <maz@kernel.org>,
 Nick Desaulniers <ndesaulniers@google.com>, linux-kernel@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
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

On Fri, Mar 05, 2021 at 12:21:24PM -0800, Sami Tolvanen wrote:
> allmodconfig + CONFIG_LTO_CLANG_THIN=y fails to build due to following
> linker errors:
> 
>   ld.lld: error: irqbypass.c:(function __guest_enter: .text+0x21CC):
>   relocation R_AARCH64_CONDBR19 out of range: 2031220 is not in
>   [-1048576, 1048575]; references hyp_panic
>   >>> defined in vmlinux.o
> 
>   ld.lld: error: irqbypass.c:(function __guest_enter: .text+0x21E0):
>   relocation R_AARCH64_ADR_PREL_LO21 out of range: 2031200 is not in
>   [-1048576, 1048575]; references hyp_panic
>   >>> defined in vmlinux.o
> 
> This is because with LTO, the compiler ends up placing hyp_panic()
> more than 1MB away from __guest_enter(). Use an unconditional branch
> and adr_l instead to fix the issue.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/1317
> Reported-by: Nathan Chancellor <nathan@kernel.org>
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Suggested-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

I booted an kernel with this patch in it on my Raspberry Pi 4 and booted
a kernel under KVM without any issues.

Tested-by: Nathan Chancellor <nathan@kernel.org>

> ---
>  arch/arm64/kvm/hyp/entry.S | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
> index b0afad7a99c6..c62265951467 100644
> --- a/arch/arm64/kvm/hyp/entry.S
> +++ b/arch/arm64/kvm/hyp/entry.S
> @@ -85,8 +85,10 @@ SYM_INNER_LABEL(__guest_exit_panic, SYM_L_GLOBAL)
>  
>  	// If the hyp context is loaded, go straight to hyp_panic
>  	get_loaded_vcpu x0, x1
> -	cbz	x0, hyp_panic
> +	cbnz	x0, 1f
> +	b	hyp_panic
>  
> +1:
>  	// The hyp context is saved so make sure it is restored to allow
>  	// hyp_panic to run at hyp and, subsequently, panic to run in the host.
>  	// This makes use of __guest_exit to avoid duplication but sets the
> @@ -94,7 +96,7 @@ SYM_INNER_LABEL(__guest_exit_panic, SYM_L_GLOBAL)
>  	// current state is saved to the guest context but it will only be
>  	// accurate if the guest had been completely restored.
>  	adr_this_cpu x0, kvm_hyp_ctxt, x1
> -	adr	x1, hyp_panic
> +	adr_l	x1, hyp_panic
>  	str	x1, [x0, #CPU_XREG_OFFSET(30)]
>  
>  	get_vcpu_ptr	x1, x0
> 
> base-commit: 280d542f6ffac0e6d65dc267f92191d509b13b64
> -- 
> 2.30.1.766.gb4fecdf3b7-goog
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
