Return-Path: <SRS0=mEDx=HE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65949C433E0
	for <kvmarm@archiver.kernel.org>; Tue,  2 Feb 2021 09:57:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8A69464F50
	for <kvmarm@archiver.kernel.org>; Tue,  2 Feb 2021 09:57:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8A69464F50
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D829F4B0CA;
	Tue,  2 Feb 2021 04:57:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5VRatQ+dBsat; Tue,  2 Feb 2021 04:57:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D4E354B130;
	Tue,  2 Feb 2021 04:57:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E9644B0CA
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Feb 2021 04:57:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ofmAmWRiIv8K for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Feb 2021 04:57:41 -0500 (EST)
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com
 [209.85.221.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E6AB14B0C3
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Feb 2021 04:57:40 -0500 (EST)
Received: by mail-wr1-f48.google.com with SMTP id c12so19727071wrc.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Feb 2021 01:57:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=gUWdfryl2mEIDffgox1qZc46SxaAuEEaX9wvFDWySJY=;
 b=MYX4UAGuAYG76uxw79nQw0VTiLAi14nGvrvL7reS74PX07uV59kkx9lJ22e1nHUwDJ
 URKRfdZqic8BS89CRZewCvictCOw4RtZ/dFHHTvgiJIaSCwWqbFp3wNH7Iha9+WhIvkq
 ygVPMdbx/NfE1NhpjpHjwODDJEfjmxZAKotDKFcBC0CpXaruSyt7+kl1bUpMbpbHXuc5
 JtkW/ibDvryn+3Lu8RUMbzSetzUPyqjVs1oq17BUsA3yRhRbO/cegw9D6cguZheCi6tg
 xfDRuukrHmS3OjuOvl5TYSZCV+wXr2zalvRUxWhcEwAxLHAQzhjXGL7EgVCAcfvDRvB/
 G41Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=gUWdfryl2mEIDffgox1qZc46SxaAuEEaX9wvFDWySJY=;
 b=IMWUbw7qYn6V5U5sKnxjeSUnaz8YjstrdNvx70wvyiuqHYBeDNF0CjFCMs85b71ffQ
 SCew/I/U5GJOAiA1GeIEsQOIbEUEw1gVTJbAI/IjB2oJjEZX/KhxBkfAquhvObhqTTvh
 +ZaItmG5xTC22AJvthdZcwBJNsFUQsfOniapJAbB+6Z1jCF8JPvkrW5ljnKNdv/kkucl
 CUapwVXaFT/UcViayxbLfT07lVY0TYq2Voq/NmcYtJ0cIr6tDxG3BfHkqdrlYpvtHGE4
 ItX9ERsY2WiWBNjB2peG25KCUijwdtpH5Qv89sre17oxj9sWrJ2IrMoi/PWdBYDo5+3n
 wuJg==
X-Gm-Message-State: AOAM5311HdHBvODoxgO3nBB/+5X8Imfm/AzYQubwLU/79doXUlog4Z9D
 Yk5DDmJqB5Vxkjy/uPx3hv220g==
X-Google-Smtp-Source: ABdhPJxE29ho4puVHuCIAx7AJHJgY3z3K/SPPM510lIEf5EY47+l9wT2D6bJXl5uysLvLX0dzdUNMA==
X-Received: by 2002:a5d:4e4c:: with SMTP id r12mr22738411wrt.354.1612259859803; 
 Tue, 02 Feb 2021 01:57:39 -0800 (PST)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id s23sm2133774wmc.35.2021.02.02.01.57.39
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 02 Feb 2021 01:57:39 -0800 (PST)
Date: Tue, 2 Feb 2021 09:57:36 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [RFC PATCH v2 11/26] KVM: arm64: Stub CONFIG_DEBUG_LIST at Hyp
Message-ID: <YBkiEPOYBGqfncwH@google.com>
References: <20210108121524.656872-1-qperret@google.com>
 <20210108121524.656872-12-qperret@google.com>
 <20210201190620.GJ15632@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210201190620.GJ15632@willie-the-truck>
Cc: devicetree@vger.kernel.org, kernel-team@android.com, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Frank Rowand <frowand.list@gmail.com>, kvmarm@lists.cs.columbia.edu
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

On Monday 01 Feb 2021 at 19:06:20 (+0000), Will Deacon wrote:
> On Fri, Jan 08, 2021 at 12:15:09PM +0000, Quentin Perret wrote:
> > In order to use the kernel list library at EL2, introduce stubs for the
> > CONFIG_DEBUG_LIST out-of-lines calls.
> > 
> > Signed-off-by: Quentin Perret <qperret@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/Makefile |  2 +-
> >  arch/arm64/kvm/hyp/nvhe/stub.c   | 22 ++++++++++++++++++++++
> >  2 files changed, 23 insertions(+), 1 deletion(-)
> >  create mode 100644 arch/arm64/kvm/hyp/nvhe/stub.c
> > 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
> > index 1fc0684a7678..33bd381d8f73 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/Makefile
> > +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
> > @@ -10,7 +10,7 @@ lib-objs := clear_page.o copy_page.o memcpy.o memset.o
> >  lib-objs := $(addprefix ../../../lib/, $(lib-objs))
> >  
> >  obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
> > -	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o
> > +	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o stub.o
> >  obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
> >  	 ../fpsimd.o ../hyp-entry.o ../exception.o
> >  obj-y += $(lib-objs)
> > diff --git a/arch/arm64/kvm/hyp/nvhe/stub.c b/arch/arm64/kvm/hyp/nvhe/stub.c
> > new file mode 100644
> > index 000000000000..c0aa6bbfd79d
> > --- /dev/null
> > +++ b/arch/arm64/kvm/hyp/nvhe/stub.c
> > @@ -0,0 +1,22 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * Stubs for out-of-line function calls caused by re-using kernel
> > + * infrastructure at EL2.
> > + *
> > + * Copyright (C) 2020 - Google LLC
> > + */
> > +
> > +#include <linux/list.h>
> > +
> > +#ifdef CONFIG_DEBUG_LIST
> > +bool __list_add_valid(struct list_head *new, struct list_head *prev,
> > +		      struct list_head *next)
> > +{
> > +		return true;
> > +}
> > +
> > +bool __list_del_entry_valid(struct list_head *entry)
> > +{
> > +		return true;
> > +}
> > +#endif
> 
> Can we get away with defining our own CHECK_DATA_CORRUPTION macro instead?

Yes I think eventually it'd be nice to get there, but that has other
implications (e.g. how do you report something in dmesg from EL2?) so
perhaps we can keep that a separate series?

Cheers,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
