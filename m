Return-Path: <SRS0=WvL8=E7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 469E4C5519F
	for <kvmarm@archiver.kernel.org>; Wed, 25 Nov 2020 13:26:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7BF7320789
	for <kvmarm@archiver.kernel.org>; Wed, 25 Nov 2020 13:26:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="BTfJiOV5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7BF7320789
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A5EDF4B917;
	Wed, 25 Nov 2020 08:26:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9h8kCYHZwxOD; Wed, 25 Nov 2020 08:26:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E4AF4B8EF;
	Wed, 25 Nov 2020 08:26:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0498B4B8E9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Nov 2020 08:26:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wBYOLua21rOi for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Nov 2020 08:26:21 -0500 (EST)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D64444B8E4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Nov 2020 08:26:20 -0500 (EST)
Received: by mail-wr1-f66.google.com with SMTP id u12so1932310wrt.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Nov 2020 05:26:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=AlYFyy65mMJrzPAF8ZbtQbw2MzAGfUKKDzhurYImYTg=;
 b=BTfJiOV5Qs1kwbPh75cNnFXtGarY+41MnAH0XZ7Mmi0dqbPtd7shBqFXYDymd3GNkm
 lkdahn66M2LPzI/Td7gXSvJfiKph5rGOimnUJgajkNXfkGkhhnIPA4RRxMk2LTmgHb2Q
 mbfd5dzmX33uNWJIDA46LqcFUM6xlfPDAVQeq/+zCLfloZMl84wadxqfD6mgdQKXCrlr
 eGZ2McF9rUgTkshK/YzShcNErO8yEsGhUGj12eZkY5cV2c8xFalXfd5xEWQbClJkdz0P
 G41tzHEcWP3iwW4szgurd8J3PnWzv6UR7faQVwqid6zeIaZATYdS3BwjRTDbasQ+w/uK
 72DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=AlYFyy65mMJrzPAF8ZbtQbw2MzAGfUKKDzhurYImYTg=;
 b=GlE/zwviuEJssH3ro0bSF9C3uEY+6/ccUCrYQzjVJ2kL0IweSW+y126twGFH4KzPSx
 UHmzia+SdGLUj7G40kvi33sJXav60ud33qnowfi7DycN5GGRwv+wPWs/2F4dfo3VcPin
 x3JCLVmI8MiIefd9w9wUs68aQ7eKp5o3697hftCOldGlrAmI5dqGy/YrxobI4CHqGHOA
 SQFxbkvsgKmYp6a4EqiPCmARFmXqxi5FzpIcXwQ82xoqspfKtYqJAIpFKUToG9Zen6P3
 ybovCD8D9FWuBcSnW2dV0jjSxM/yJG/NVsbFy40FYayQIwaR1yfo7SaesPmgdu3VOANH
 ITEQ==
X-Gm-Message-State: AOAM5311/ZqVn9Aw8qIYYqyd3jmkbyoZa+9K95GxC+Z6JxYWMBcK6Pr+
 YzcdqwtUgW7K0s1jVitdlSH6sw==
X-Google-Smtp-Source: ABdhPJy2QWZ+aTIexoqvjYkDzVR7TA/T3I3OJCD/3ABMXhMh9WhgGwr7tT6EW53IiAEKwTAmTr5PnA==
X-Received: by 2002:adf:dd52:: with SMTP id u18mr4022419wrm.44.1606310779648; 
 Wed, 25 Nov 2020 05:26:19 -0800 (PST)
Received: from google.com ([2a01:4b00:8523:2d03:38bf:5817:e665:9b9b])
 by smtp.gmail.com with ESMTPSA id 90sm5059825wra.95.2020.11.25.05.26.18
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 25 Nov 2020 05:26:18 -0800 (PST)
Date: Wed, 25 Nov 2020 13:26:17 +0000
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 04/24] arm64: Move MAIR_EL1_SET to asm/memory.h
Message-ID: <20201125132617.qf6vd752dtfasyi7@google.com>
References: <20201116204318.63987-1-dbrazdil@google.com>
 <20201116204318.63987-5-dbrazdil@google.com>
 <87mtz85geh.wl-maz@kernel.org>
 <20201125103137.iml7mqpzhylldvqy@google.com>
 <e6c9184c6ee986d134625932b4fa8e89@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <e6c9184c6ee986d134625932b4fa8e89@kernel.org>
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

> > > > +/*
> > > > + * Memory types available.
> > > > + *
> > > > + * IMPORTANT: MT_NORMAL must be index 0 since vm_get_page_prot() may 'or' in
> > > > + *	      the MT_NORMAL_TAGGED memory type for PROT_MTE mappings. Note
> > > > + *	      that protection_map[] only contains MT_NORMAL attributes.
> > > > + */
> > > > +#define MT_NORMAL		0
> > > > +#define MT_NORMAL_TAGGED	1
> > > > +#define MT_NORMAL_NC		2
> > > > +#define MT_NORMAL_WT		3
> > > > +#define MT_DEVICE_nGnRnE	4
> > > > +#define MT_DEVICE_nGnRE		5
> > > > +#define MT_DEVICE_GRE		6
> > > > +
> > > > +/*
> > > > + * Default MAIR_ELx. MT_NORMAL_TAGGED is initially mapped as Normal memory and
> > > > + * changed during __cpu_setup to Normal Tagged if the system supports MTE.
> > > > + */
> > > > +#define MAIR_ELx_SET							\
> > > > +	(MAIR_ATTRIDX(MAIR_ATTR_DEVICE_nGnRnE, MT_DEVICE_nGnRnE) |	\
> > > > +	 MAIR_ATTRIDX(MAIR_ATTR_DEVICE_nGnRE, MT_DEVICE_nGnRE) |	\
> > > > +	 MAIR_ATTRIDX(MAIR_ATTR_DEVICE_GRE, MT_DEVICE_GRE) |		\
> > > > +	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL_NC, MT_NORMAL_NC) |		\
> > > > +	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL, MT_NORMAL) |			\
> > > > +	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL_WT, MT_NORMAL_WT) |		\
> > > > +	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL, MT_NORMAL_TAGGED))
> > > > +
> 
> Wait: You now have MAIR_ELx_SET defined at two locations. Surely that's
> one too many.
> 

Oops, told you I tried different things...

> > > >  /* id_aa64isar0 */
> > > >  #define ID_AA64ISAR0_RNDR_SHIFT		60
> > > >  #define ID_AA64ISAR0_TLB_SHIFT		56
> > > > @@ -992,6 +1020,7 @@
> > > >  /* Safe value for MPIDR_EL1: Bit31:RES1, Bit30:U:0, Bit24:MT:0 */
> > > >  #define SYS_MPIDR_SAFE_VAL	(BIT(31))
> > > >
> > > > +#ifndef LINKER_SCRIPT
> > > 
> > > This is terribly ugly. Why is this included by the linker script? Does
> > > it actually define __ASSEMBLY__?
> > 
> > vmlinux.lds.S includes memory.h for PAGE_SIZE. And yes, linker scripts
> > are
> > built with this rule:
> > 
> >       cmd_cpp_lds_S = $(CPP) $(cpp_flags) -P -U$(ARCH) \
> > 	                     -D__ASSEMBLY__ -DLINKER_SCRIPT -o $@ $<
> > 
> > I tried a few things and wasn't completely happy with any of them. I
> > think in
> > the previous spin you suggested moving this constant to sysreg.h. That
> > works
> > too but sysreg.h seems to have only architecture constants, memory.h
> > about a
> > Linux-specific configuration, so I wanted to keep it here.
> 
> MAIR_ELx_SET isn't really Linux specific. Or rather, not more specific than
> any of the other configurations we have. On the other hand, the S1 MT_*
> stuff
> is totally arbitrary, and does fit in memory.h, together with the rest of
> the indexes for the memory types.
> 
> I came up with the following patch on top of this series that seems to
> compile without issue.

That seems to have an implicit dependency of sysreg.h on memory.h, doesn't it?
I had it the other way round initially. I also tried including memory.h in
sysreg.h. That creates a circular dependency mmdebug.h -> bug.h -> ... ->
sysreg.h -> memory.h -> mmdebug.h. Pretty annoying. I could try to fix that,
or create a new header file... :(

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
