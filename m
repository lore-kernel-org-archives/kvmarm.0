Return-Path: <SRS0=JeL3=EW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.4 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD003C4742C
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 11:50:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1CBD52227F
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 11:50:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="nTUfK2Ei"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1CBD52227F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 56A854C139;
	Mon, 16 Nov 2020 06:50:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id E5H8C8r8-eCe; Mon, 16 Nov 2020 06:49:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 262964C0B2;
	Mon, 16 Nov 2020 06:49:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C3754C063
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 06:49:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VotRpJUh-ecY for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Nov 2020 06:49:56 -0500 (EST)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 704A34BA69
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 06:49:56 -0500 (EST)
Received: by mail-wm1-f68.google.com with SMTP id a3so23340107wmb.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 03:49:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=CFJEkUj6StvnCLf3zA4XSa8BJ3U9++NnIiul0HVC8DY=;
 b=nTUfK2EitnQ5Q0QZZIJ6UfQATrjdCE4F3RuhLemICZ+FIa4eNeZj1jdUP59xrVtnyE
 wsRGi8ju0E8yAAhUqKqi4ygMnWHUbuQeVqoTv1FkbIukrUqFbNGApXG4mxG5JFLAiEes
 GEDmXKhmDHxx1AY5P4OHGfXHY307Dk63qu25+pSXuIsykolgBbqrylbhVDfRKQxutLfZ
 FbbwuqINVrnNdiE4btGAzPw9SBXpMYboa6sAmb6xKaSLydR9dXJbLV8ZSGCj4vHlY5E4
 GZC0xSP1mOsVLHma5ulVWJt6la+8lzkyh6mP1/A4UmV0RE8v56gUookImTFJyFIuvTMK
 wFVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=CFJEkUj6StvnCLf3zA4XSa8BJ3U9++NnIiul0HVC8DY=;
 b=Vll3j7Lo4YRtR8H8ClVQGmYJEWoTZMFArGghhvgGE5H1NeUoZD+BiUo/VKde8+RVgk
 20SMIC/x2DgJC2bePhyumkLBXqoNgfmnnNpfdO2MSTa/mZFNn9R13R5n25lkVXu8JdpT
 i1OHQYKfftRDqxg4y3k0PWTXRlnFUtJWEDLdqFsE7vEgf5qOHHu0LMuhl5sHwaoe6JKy
 QCbTXRwaYLCYzfURWlSl722YvcpWsHZszRx2d5lpmX6XKxxPb7iudruPFs7oH4adDhmr
 12bczyA/uSQ7f1WLLm8O97N10hhr9obN+yXoUQaoHySCFJQmPJT6Vv6vgfYjrMihYYTE
 N7ng==
X-Gm-Message-State: AOAM531wiquLW5yVeiILG3H2+dopaiCKG5u/jJj+rQz2GF1zHjqUXiuG
 5uXZs9uw2s0Xo4ifjMu9Kcc9hA==
X-Google-Smtp-Source: ABdhPJw4YkJYmgRylLEqTzHlY0X6lACb5edwRo2U/kN+S0kiJOP4jgTMcfO+OOMCh+jui7yGQnaCsw==
X-Received: by 2002:a1c:3b87:: with SMTP id
 i129mr15591490wma.134.1605527395152; 
 Mon, 16 Nov 2020 03:49:55 -0800 (PST)
Received: from google.com ([2a01:4b00:8523:2d03:58a8:7836:6672:a072])
 by smtp.gmail.com with ESMTPSA id c17sm19262018wml.14.2020.11.16.03.49.53
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 16 Nov 2020 03:49:54 -0800 (PST)
Date: Mon, 16 Nov 2020 11:49:52 +0000
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v1 13/24] kvm: arm64: Add CPU entry point in nVHE hyp
Message-ID: <20201116114952.ybj24wx44lofqs25@google.com>
References: <20201109113233.9012-1-dbrazdil@google.com>
 <20201109113233.9012-14-dbrazdil@google.com>
 <7b8f9dec846f172c2919e1d3f3c65245@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <7b8f9dec846f172c2919e1d3f3c65245@kernel.org>
Cc: kernel-team@android.com, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Andrew Walbran <qwandor@google.com>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Christoph Lameter <cl@linux.com>, Will Deacon <will@kernel.org>,
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

> >  #ifdef CONFIG_CPU_PM
> >    DEFINE(CPU_CTX_SP,		offsetof(struct cpu_suspend_ctx, sp));
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> > b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> > index 1697d25756e9..f999a35b2c8c 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> > @@ -6,6 +6,7 @@
> > 
> >  #include <linux/arm-smccc.h>
> >  #include <linux/linkage.h>
> > +#include <linux/irqchip/arm-gic-v3.h>
> 
> This should probably be included from the file that provides init_el2_state.

Agreed. This is a workaround for the fact that the arm-gic* headers don't play
nice with each other (define the same constants). Including arm-gic-v3.h in
kvm_asm.h will trigger macro redefine warnings in vgic*-v2.c because they
include arm-gic.h.

Another option is to create a header just for el2 init. Would that be
preferable? Other ideas?

> 
> > 
> >  #include <asm/alternative.h>
> >  #include <asm/assembler.h>
> > @@ -159,6 +160,35 @@ alternative_else_nop_endif
> >  	ret
> >  SYM_CODE_END(___kvm_hyp_init)
> > 
> > +SYM_CODE_START(__kvm_hyp_cpu_entry)
> > +	msr	SPsel, #1			// We want to use SP_EL{1,2}
> > +
> > +	/*
> > +	 * Check that the core was booted in EL2. Loop indefinitely if not
> > +	 * because it cannot be safely given to the host without installing
> > KVM.
> > +	 */
> > +	mrs	x1, CurrentEL
> > +	cmp	x1, #CurrentEL_EL2
> > +	b.ne	.
> 
> This is a bit brutal. Consider using a WFE/WFI loop as we have in other
> places already (see __secondary_too_slow for example).

Ack

> > +
> > +	/* Initialize EL2 CPU state to sane values. */
> > +	mov	x29, x0
> > +	init_el2_state nvhe
> > +	mov	x0, x29
> > +
> > +	/*
> > +	 * Load hyp VA of C entry function. Must do so before switching on the
> > +	 * MMU because the struct pointer is PA and not identity-mapped in
> > hyp.
> > +	 */
> > +	ldr	x29, [x0, #NVHE_INIT_PSCI_CPU_ENTRY_FN]
> > +
> > +	/* Enable MMU, set vectors and stack. */
> > +	bl	___kvm_hyp_init
> > +
> > +	/* Leave idmap. */
> > +	br	x29
> 
> To a point I made against an earlier patch: psci_cpu_entry_fn seems to be a
> HYP
> VA, and really needs to be documented as such, because this is pretty hard
> to
> follow otherwise.
> 
> > +SYM_CODE_END(__kvm_hyp_cpu_entry)
> > +
> >  SYM_CODE_START(__kvm_handle_stub_hvc)
> >  	cmp	x0, #HVC_SOFT_RESTART
> >  	b.ne	1f
> 
> Thanks,
> 
>         M.
> -- 
> Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
