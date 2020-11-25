Return-Path: <SRS0=WvL8=E7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EDC1C5519F
	for <kvmarm@archiver.kernel.org>; Wed, 25 Nov 2020 10:31:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 856B1206E0
	for <kvmarm@archiver.kernel.org>; Wed, 25 Nov 2020 10:31:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="j/qDLWHb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 856B1206E0
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B7B64B8D5;
	Wed, 25 Nov 2020 05:31:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2T26L1dztEh2; Wed, 25 Nov 2020 05:31:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F4574B916;
	Wed, 25 Nov 2020 05:31:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C1B3D4B8D5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Nov 2020 05:31:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B6Gm6piYLlob for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Nov 2020 05:31:40 -0500 (EST)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6AD234B8D3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Nov 2020 05:31:40 -0500 (EST)
Received: by mail-wr1-f67.google.com with SMTP id t4so1349354wrr.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Nov 2020 02:31:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=zh3V+1i6uSPWkNWJHyHSCAf9tka9NARqYpg6Ee1m2YQ=;
 b=j/qDLWHb/zpEgS4pLOSQN4BElGYwswDtuA6l8deiUGiABCBKzd2j1yTyFGFJmgdy+R
 HNPe4Mr8GrIhiwGJhDryWF+slOBmw04NBlWN3RL1HSTpmVwP0MXdGd/NLZ3y/r2UX3VY
 G+DgTAfhQn8S/wjZnHmN6dUwSsE+lbhFArcTA8IzFkcIH06K3JDw01przKfIDBJmOyPa
 lhvGa6i+7qXYaQxErCIoWnPSQWd5ZFr7nqvQ2U4j1hAx500Flg2nrQbcIFzahCg0nSZQ
 rhZB02sRdDC1NG5rjkM6YSLggoemP7xCLV8GzhsN5/JDXWTIGnOAYe3C4Mv2NWMIc2mL
 Cwdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=zh3V+1i6uSPWkNWJHyHSCAf9tka9NARqYpg6Ee1m2YQ=;
 b=FegymljOToziSpGQDcIm5zF1FroboexG7Bj9VX7Yei2U08umqjGF9In9lMy9y6gsvn
 Q4aPiW/NVAl+GvQpAihqlx+J4zFGB0aFZgGjffrKSz2yLMJID9hNg/XKME+pQIpRVmsS
 SJBHvGOUIclk2T1yoJ6l1KFr6YCVytBQI/W33cwC2B9I3PeD5UO71BqPD1fzV14fjQXk
 /6Wri0rgMNBrmy7D8lkfZzjzvCrmNAt3b0YAO9APW7pmhoKOKOAhXkSIuz3cwDZ0I3fT
 RNVaBScbuUAf+JSZPBpa2/HuyP0BAb5wgVaPYwRGTIETMTWct2TMMTgAI06qGm93FiUd
 HGdg==
X-Gm-Message-State: AOAM533d7w7nDXV33KJuL9tUs/dPiifJeeNbxKObH2o+sQdqCR6stXpE
 b5WMtduoldnSwyVTn58aenIGWg==
X-Google-Smtp-Source: ABdhPJyY8RKpx8wQYYYX6vLZI3Qw2W7ac4/mkkzfKNrNDKkpW7MVrqAgoHDpbeJyJoR2AG8dYD0z6w==
X-Received: by 2002:adf:f08e:: with SMTP id n14mr3200137wro.136.1606300299126; 
 Wed, 25 Nov 2020 02:31:39 -0800 (PST)
Received: from google.com ([2a01:4b00:8523:2d03:38bf:5817:e665:9b9b])
 by smtp.gmail.com with ESMTPSA id 8sm3651496wmg.28.2020.11.25.02.31.37
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 25 Nov 2020 02:31:38 -0800 (PST)
Date: Wed, 25 Nov 2020 10:31:37 +0000
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 04/24] arm64: Move MAIR_EL1_SET to asm/memory.h
Message-ID: <20201125103137.iml7mqpzhylldvqy@google.com>
References: <20201116204318.63987-1-dbrazdil@google.com>
 <20201116204318.63987-5-dbrazdil@google.com>
 <87mtz85geh.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87mtz85geh.wl-maz@kernel.org>
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

On Mon, Nov 23, 2020 at 01:52:54PM +0000, Marc Zyngier wrote:
> On Mon, 16 Nov 2020 20:42:58 +0000,
> David Brazdil <dbrazdil@google.com> wrote:
> > 
> > KVM currently initializes MAIR_EL2 to the value of MAIR_EL1. In
> > preparation for initializing MAIR_EL2 before MAIR_EL1, move the constant
> > into a shared header file. Since it is used for EL1 and EL2, rename to
> > MAIR_ELx_SET.
> > 
> > Signed-off-by: David Brazdil <dbrazdil@google.com>
> > ---
> >  arch/arm64/include/asm/memory.h | 29 ++++++++++++++---------------
> >  arch/arm64/include/asm/sysreg.h | 30 ++++++++++++++++++++++++++++++
> >  arch/arm64/mm/proc.S            | 15 +--------------
> >  3 files changed, 45 insertions(+), 29 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
> > index cd61239bae8c..8ae8fd883a0c 100644
> > --- a/arch/arm64/include/asm/memory.h
> > +++ b/arch/arm64/include/asm/memory.h
> > @@ -13,6 +13,7 @@
> >  #include <linux/const.h>
> >  #include <linux/sizes.h>
> >  #include <asm/page-def.h>
> > +#include <asm/sysreg.h>
> >  
> >  /*
> >   * Size of the PCI I/O space. This must remain a power of two so that
> > @@ -124,21 +125,6 @@
> >   */
> >  #define SEGMENT_ALIGN		SZ_64K
> >  
> > -/*
> > - * Memory types available.
> > - *
> > - * IMPORTANT: MT_NORMAL must be index 0 since vm_get_page_prot() may 'or' in
> > - *	      the MT_NORMAL_TAGGED memory type for PROT_MTE mappings. Note
> > - *	      that protection_map[] only contains MT_NORMAL attributes.
> > - */
> > -#define MT_NORMAL		0
> > -#define MT_NORMAL_TAGGED	1
> > -#define MT_NORMAL_NC		2
> > -#define MT_NORMAL_WT		3
> > -#define MT_DEVICE_nGnRnE	4
> > -#define MT_DEVICE_nGnRE		5
> > -#define MT_DEVICE_GRE		6
> > -
> >  /*
> >   * Memory types for Stage-2 translation
> >   */
> > @@ -152,6 +138,19 @@
> >  #define MT_S2_FWB_NORMAL	6
> >  #define MT_S2_FWB_DEVICE_nGnRE	1
> >  
> > +/*
> > + * Default MAIR_EL1. MT_NORMAL_TAGGED is initially mapped as Normal memory and
> > + * changed during __cpu_setup to Normal Tagged if the system supports MTE.
> > + */
> > +#define MAIR_ELx_SET							\
> > +	(MAIR_ATTRIDX(MAIR_ATTR_DEVICE_nGnRnE, MT_DEVICE_nGnRnE) |	\
> > +	 MAIR_ATTRIDX(MAIR_ATTR_DEVICE_nGnRE, MT_DEVICE_nGnRE) |	\
> > +	 MAIR_ATTRIDX(MAIR_ATTR_DEVICE_GRE, MT_DEVICE_GRE) |		\
> > +	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL_NC, MT_NORMAL_NC) |		\
> > +	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL, MT_NORMAL) |			\
> > +	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL_WT, MT_NORMAL_WT) |		\
> > +	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL, MT_NORMAL_TAGGED))
> > +
> >  #ifdef CONFIG_ARM64_4K_PAGES
> >  #define IOREMAP_MAX_ORDER	(PUD_SHIFT)
> >  #else
> > diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> > index e2ef4c2edf06..24e773414cb4 100644
> > --- a/arch/arm64/include/asm/sysreg.h
> > +++ b/arch/arm64/include/asm/sysreg.h
> > @@ -635,6 +635,34 @@
> >  /* Position the attr at the correct index */
> >  #define MAIR_ATTRIDX(attr, idx)		((attr) << ((idx) * 8))
> >  
> > +/*
> > + * Memory types available.
> > + *
> > + * IMPORTANT: MT_NORMAL must be index 0 since vm_get_page_prot() may 'or' in
> > + *	      the MT_NORMAL_TAGGED memory type for PROT_MTE mappings. Note
> > + *	      that protection_map[] only contains MT_NORMAL attributes.
> > + */
> > +#define MT_NORMAL		0
> > +#define MT_NORMAL_TAGGED	1
> > +#define MT_NORMAL_NC		2
> > +#define MT_NORMAL_WT		3
> > +#define MT_DEVICE_nGnRnE	4
> > +#define MT_DEVICE_nGnRE		5
> > +#define MT_DEVICE_GRE		6
> > +
> > +/*
> > + * Default MAIR_ELx. MT_NORMAL_TAGGED is initially mapped as Normal memory and
> > + * changed during __cpu_setup to Normal Tagged if the system supports MTE.
> > + */
> > +#define MAIR_ELx_SET							\
> > +	(MAIR_ATTRIDX(MAIR_ATTR_DEVICE_nGnRnE, MT_DEVICE_nGnRnE) |	\
> > +	 MAIR_ATTRIDX(MAIR_ATTR_DEVICE_nGnRE, MT_DEVICE_nGnRE) |	\
> > +	 MAIR_ATTRIDX(MAIR_ATTR_DEVICE_GRE, MT_DEVICE_GRE) |		\
> > +	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL_NC, MT_NORMAL_NC) |		\
> > +	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL, MT_NORMAL) |			\
> > +	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL_WT, MT_NORMAL_WT) |		\
> > +	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL, MT_NORMAL_TAGGED))
> > +
> >  /* id_aa64isar0 */
> >  #define ID_AA64ISAR0_RNDR_SHIFT		60
> >  #define ID_AA64ISAR0_TLB_SHIFT		56
> > @@ -992,6 +1020,7 @@
> >  /* Safe value for MPIDR_EL1: Bit31:RES1, Bit30:U:0, Bit24:MT:0 */
> >  #define SYS_MPIDR_SAFE_VAL	(BIT(31))
> >  
> > +#ifndef LINKER_SCRIPT
> 
> This is terribly ugly. Why is this included by the linker script? Does
> it actually define __ASSEMBLY__?

vmlinux.lds.S includes memory.h for PAGE_SIZE. And yes, linker scripts are
built with this rule:

      cmd_cpp_lds_S = $(CPP) $(cpp_flags) -P -U$(ARCH) \
	                     -D__ASSEMBLY__ -DLINKER_SCRIPT -o $@ $<

I tried a few things and wasn't completely happy with any of them. I think in
the previous spin you suggested moving this constant to sysreg.h. That works
too but sysreg.h seems to have only architecture constants, memory.h about a
Linux-specific configuration, so I wanted to keep it here.

> 
> >  #ifdef __ASSEMBLY__
> >  
> >  	.irp	num,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30
> > @@ -1109,5 +1138,6 @@
> >  })
> >  
> >  #endif
> > +#endif	/* LINKER_SCRIPT */
> >  
> >  #endif	/* __ASM_SYSREG_H */
> > diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
> > index 23c326a06b2d..e3b9aa372b96 100644
> > --- a/arch/arm64/mm/proc.S
> > +++ b/arch/arm64/mm/proc.S
> > @@ -45,19 +45,6 @@
> >  #define TCR_KASAN_FLAGS 0
> >  #endif
> >  
> > -/*
> > - * Default MAIR_EL1. MT_NORMAL_TAGGED is initially mapped as Normal memory and
> > - * changed during __cpu_setup to Normal Tagged if the system supports MTE.
> > - */
> > -#define MAIR_EL1_SET							\
> > -	(MAIR_ATTRIDX(MAIR_ATTR_DEVICE_nGnRnE, MT_DEVICE_nGnRnE) |	\
> > -	 MAIR_ATTRIDX(MAIR_ATTR_DEVICE_nGnRE, MT_DEVICE_nGnRE) |	\
> > -	 MAIR_ATTRIDX(MAIR_ATTR_DEVICE_GRE, MT_DEVICE_GRE) |		\
> > -	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL_NC, MT_NORMAL_NC) |		\
> > -	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL, MT_NORMAL) |			\
> > -	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL_WT, MT_NORMAL_WT) |		\
> > -	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL, MT_NORMAL_TAGGED))
> > -
> >  #ifdef CONFIG_CPU_PM
> >  /**
> >   * cpu_do_suspend - save CPU registers context
> > @@ -425,7 +412,7 @@ SYM_FUNC_START(__cpu_setup)
> >  	/*
> >  	 * Memory region attributes
> >  	 */
> > -	mov_q	x5, MAIR_EL1_SET
> > +	mov_q	x5, MAIR_ELx_SET
> >  #ifdef CONFIG_ARM64_MTE
> >  	/*
> >  	 * Update MAIR_EL1, GCR_EL1 and TFSR*_EL1 if MTE is supported
> > -- 
> > 2.29.2.299.gdc1121823c-goog
> > 
> > 
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
