Return-Path: <SRS0=n0cH=C3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 158BDC43464
	for <kvmarm@archiver.kernel.org>; Fri, 18 Sep 2020 08:51:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 42883208B8
	for <kvmarm@archiver.kernel.org>; Fri, 18 Sep 2020 08:51:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="RNh/kppb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 42883208B8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D33D4B3E8;
	Fri, 18 Sep 2020 04:51:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BLtgh2T3PLTG; Fri, 18 Sep 2020 04:51:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CDFB4B3C8;
	Fri, 18 Sep 2020 04:51:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E5C24B3B3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Sep 2020 04:51:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id riY7Sxo7+ucM for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Sep 2020 04:51:25 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 13C8E4B3B1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Sep 2020 04:51:25 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 97F6D208B8;
 Fri, 18 Sep 2020 08:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1600419083;
 bh=xSuljIaVzLXu/fP2mE0aGU32cBoHqrhtfIi4pwf6ku0=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=RNh/kppbBRNafdG5SxQjmgKu6lqLfCQO68yvGZ2XZ0suKr94KuMwIOD6RSsQFvnKI
 U+4FYyhlZN9nx3UowWA8v4x4ZWdHVqoC6dPHOwb405yYU93zomqj0i4XFen2uxOpKC
 fkimNUzViQv7Z0sKBHoDStVpoTLvWQ417k2DNin0=
Date: Fri, 18 Sep 2020 09:51:17 +0100
From: Will Deacon <will@kernel.org>
To: David Brazdil <dbrazdil@google.com>
Subject: Re: [PATCH v3 01/11] kvm: arm64: Partially link nVHE hyp code,
 simplify HYPCOPY
Message-ID: <20200918085116.GA30834@willie-the-truck>
References: <20200916173439.32265-1-dbrazdil@google.com>
 <20200916173439.32265-2-dbrazdil@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200916173439.32265-2-dbrazdil@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Christoph Lameter <cl@linux.com>, kernel-team@android.com,
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

On Wed, Sep 16, 2020 at 06:34:29PM +0100, David Brazdil wrote:
> Relying on objcopy to prefix the ELF section names of the nVHE hyp code
> is brittle and prevents us from using wildcards to match specific
> section names.
> 
> Improve the build rules by partially linking all '.nvhe.o' files and
> prefixing their ELF section names using a linker script. Continue using
> objcopy for prefixing ELF symbol names.
> 
> One immediate advantage of this approach is that all subsections
> matching a pattern can be merged into a single prefixed section, eg.
> .text and .text.* can be linked into a single '.hyp.text'. This removes
> the need for -fno-reorder-functions on GCC and will be useful in the
> future too: LTO builds use .text subsections, compilers routinely
> generate .rodata subsections, etc.
> 
> Partially linking all hyp code into a single object file also makes it
> easier to analyze.
> 
> Signed-off-by: David Brazdil <dbrazdil@google.com>
> ---
>  arch/arm64/include/asm/hyp_image.h | 24 ++++++++++++
>  arch/arm64/kvm/hyp/nvhe/Makefile   | 60 ++++++++++++++++--------------
>  arch/arm64/kvm/hyp/nvhe/hyp.lds.S  | 13 +++++++
>  3 files changed, 70 insertions(+), 27 deletions(-)
>  create mode 100644 arch/arm64/include/asm/hyp_image.h
>  create mode 100644 arch/arm64/kvm/hyp/nvhe/hyp.lds.S
> 
> diff --git a/arch/arm64/include/asm/hyp_image.h b/arch/arm64/include/asm/hyp_image.h
> new file mode 100644
> index 000000000000..5b1e3b9ef376
> --- /dev/null
> +++ b/arch/arm64/include/asm/hyp_image.h
> @@ -0,0 +1,24 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2020 Google LLC.
> + * Written by David Brazdil <dbrazdil@google.com>
> + */
> +
> +#ifndef __ARM64_HYP_IMAGE_H__
> +#define __ARM64_HYP_IMAGE_H__
> +
> +#ifdef LINKER_SCRIPT
> +
> +/*
> + * KVM nVHE ELF section names are prefixed with .hyp, to separate them
> + * from the kernel proper.
> + */
> +#define HYP_SECTION_NAME(NAME)	.hyp##NAME
> +
> +/* Defines an ELF hyp section from input section @NAME and its subsections. */
> +#define HYP_SECTION(NAME) \
> +	HYP_SECTION_NAME(NAME) : { *(NAME NAME##.[0-9a-zA-Z_]*) }

I still don't get why we can't just use NAME ## .* for the regex here. That
matches what we do elsewhere for linker script wildcarding, e.g. .rodata.*,
.init.text.* ...  in asm-generic/vmlinux.lds.h. Why is it different for
these sections?

> +
> +#endif /* LINKER_SCRIPT */
> +
> +#endif /* __ARM64_HYP_IMAGE_H__ */
> diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
> index aef76487edc2..2b27b60182f9 100644
> --- a/arch/arm64/kvm/hyp/nvhe/Makefile
> +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
> @@ -10,40 +10,46 @@ obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o
>  obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
>  	 ../fpsimd.o ../hyp-entry.o
>  
> -obj-y := $(patsubst %.o,%.hyp.o,$(obj-y))
> -extra-y := $(patsubst %.hyp.o,%.hyp.tmp.o,$(obj-y))
> +##
> +## Build rules for compiling nVHE hyp code
> +## Output of this folder is `kvm_nvhe.o`, a partially linked object
> +## file containing all nVHE hyp code and data.
> +##
>  
> -$(obj)/%.hyp.tmp.o: $(src)/%.c FORCE
> +hyp-obj := $(patsubst %.o,%.nvhe.o,$(obj-y))
> +obj-y := kvm_nvhe.o
> +extra-y := $(hyp-obj) kvm_nvhe.tmp.o hyp.lds
> +
> +# 1) Compile all source files to `.nvhe.o` object files. The file extension
> +#    avoids file name clashes for files shared with VHE.
> +$(obj)/%.nvhe.o: $(src)/%.c FORCE
>  	$(call if_changed_rule,cc_o_c)
> -$(obj)/%.hyp.tmp.o: $(src)/%.S FORCE
> +$(obj)/%.nvhe.o: $(src)/%.S FORCE
>  	$(call if_changed_rule,as_o_S)
> -$(obj)/%.hyp.o: $(obj)/%.hyp.tmp.o FORCE
> -	$(call if_changed,hypcopy)
>  
> -# Disable reordering functions by GCC (enabled at -O2).
> -# This pass puts functions into '.text.*' sections to aid the linker
> -# in optimizing ELF layout. See HYPCOPY comment below for more info.
> -ccflags-y += $(call cc-option,-fno-reorder-functions)
> +# 2) Compile linker script.
> +$(obj)/hyp.lds: $(src)/hyp.lds.S FORCE
> +	$(call if_changed_dep,cpp_lds_S)

You need a .gitignore file listing hyp.lds, otherwise some idiot will end
up committing it. I definitely didn't do that when playing around with this
series. Nope. Not at all.

With that, and the regex resolved:

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
