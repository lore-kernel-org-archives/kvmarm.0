Return-Path: <SRS0=mEDx=HE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BF22C433DB
	for <kvmarm@archiver.kernel.org>; Tue,  2 Feb 2021 10:15:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DA7A164DD1
	for <kvmarm@archiver.kernel.org>; Tue,  2 Feb 2021 10:15:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DA7A164DD1
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B51E4B16F;
	Tue,  2 Feb 2021 05:15:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id F6qvtXsP7LR0; Tue,  2 Feb 2021 05:15:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 165924B165;
	Tue,  2 Feb 2021 05:15:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D2304B165
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Feb 2021 05:15:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OiuqTI2zjv1e for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Feb 2021 05:14:58 -0500 (EST)
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com
 [209.85.221.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C63AA4B156
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Feb 2021 05:14:58 -0500 (EST)
Received: by mail-wr1-f43.google.com with SMTP id q7so19765428wre.13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Feb 2021 02:14:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=S29qSBxrRMWdoh+uQ0z7xwZGgDdoQsP6bzHB4znO2RQ=;
 b=FOL+mQvxrnrE+2uwaih76cLeFlqKFQeumFQMbn7OQMAIpM3QuVMQbzQWvkXiuNztiU
 y88Fy/y32mILOuYt7wWj/C1cxaz5IxDEkFwRCNP1MWHgQJPqznb5h6i+wags+9DM4eku
 GfhWrhMLbwsnckJdPE1cjf0Fz2e7HQekW1N9ibs/9l5P8htQ+N+9qq0O8DFYqFfjzX+c
 KjwQkTwPz7YqHvii6xM2IYGYLtrFFWmyxlO7g2p4ASRNeb2LuIIY8b8n5ursKJkqtdJK
 iaprLMD4R7i3QzlQcFSuoesvVEd5irADknwJfcm81DsNs+mAmUNkflHqBCX9vMkrI8es
 NvoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=S29qSBxrRMWdoh+uQ0z7xwZGgDdoQsP6bzHB4znO2RQ=;
 b=RkDC7B0dLMz5j450Qn/KbTekuNhxWlCTw2oG9mmDXAIw0hZYfIIsXQOOsm+PA6pG5/
 9RSLKaR2/pDcI7R7nCJ72OWL3w9eEEOEaeZwGRpurnYB39MjIo3aT091g0s5doEYEJzO
 5BMYwfn8AERH5usxSPzPwuxKbfT459A7Hh8ELSSFlenQpTihAt8FGow6CFp4pZVCbWpN
 gRV3euf95MH680Qws9E08jHFYJVm0CU9kEzMWq1dMyJVQIA9nI6A0ovINf7hR4UAd2At
 YvKVsLOPLykmx1HEdFG0M6vlJZo84VfLBOT/Vq0jJbcTepbu2O8U4gr8j3lPdeTlMvBF
 uihg==
X-Gm-Message-State: AOAM531ZFOON1FTbHIDG0DVZrEDFRsBsO1xDF/tNPZA6Yl8LiBOpXAx/
 uwduWCjaP1/fAFYki1ir2Yvjjg==
X-Google-Smtp-Source: ABdhPJyfWn6FsrHijyrJnW/tBTAvhlBZmX+sr4R/GNDwBS+eRgzTj9Ktrdkd2gpILs6BDmypHzVeRw==
X-Received: by 2002:adf:e38d:: with SMTP id e13mr22258466wrm.231.1612260897588; 
 Tue, 02 Feb 2021 02:14:57 -0800 (PST)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id m22sm31890793wrh.66.2021.02.02.02.14.57
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 02 Feb 2021 02:14:57 -0800 (PST)
Date: Tue, 2 Feb 2021 10:14:51 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [RFC PATCH v2 11/26] KVM: arm64: Stub CONFIG_DEBUG_LIST at Hyp
Message-ID: <YBkmGzL10q43pT8i@google.com>
References: <20210108121524.656872-1-qperret@google.com>
 <20210108121524.656872-12-qperret@google.com>
 <20210201190620.GJ15632@willie-the-truck>
 <YBkiEPOYBGqfncwH@google.com>
 <20210202100028.GA16657@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210202100028.GA16657@willie-the-truck>
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

On Tuesday 02 Feb 2021 at 10:00:29 (+0000), Will Deacon wrote:
> On Tue, Feb 02, 2021 at 09:57:36AM +0000, Quentin Perret wrote:
> > On Monday 01 Feb 2021 at 19:06:20 (+0000), Will Deacon wrote:
> > > On Fri, Jan 08, 2021 at 12:15:09PM +0000, Quentin Perret wrote:
> > > > In order to use the kernel list library at EL2, introduce stubs for the
> > > > CONFIG_DEBUG_LIST out-of-lines calls.
> > > > 
> > > > Signed-off-by: Quentin Perret <qperret@google.com>
> > > > ---
> > > >  arch/arm64/kvm/hyp/nvhe/Makefile |  2 +-
> > > >  arch/arm64/kvm/hyp/nvhe/stub.c   | 22 ++++++++++++++++++++++
> > > >  2 files changed, 23 insertions(+), 1 deletion(-)
> > > >  create mode 100644 arch/arm64/kvm/hyp/nvhe/stub.c
> > > > 
> > > > diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
> > > > index 1fc0684a7678..33bd381d8f73 100644
> > > > --- a/arch/arm64/kvm/hyp/nvhe/Makefile
> > > > +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
> > > > @@ -10,7 +10,7 @@ lib-objs := clear_page.o copy_page.o memcpy.o memset.o
> > > >  lib-objs := $(addprefix ../../../lib/, $(lib-objs))
> > > >  
> > > >  obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
> > > > -	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o
> > > > +	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o stub.o
> > > >  obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
> > > >  	 ../fpsimd.o ../hyp-entry.o ../exception.o
> > > >  obj-y += $(lib-objs)
> > > > diff --git a/arch/arm64/kvm/hyp/nvhe/stub.c b/arch/arm64/kvm/hyp/nvhe/stub.c
> > > > new file mode 100644
> > > > index 000000000000..c0aa6bbfd79d
> > > > --- /dev/null
> > > > +++ b/arch/arm64/kvm/hyp/nvhe/stub.c
> > > > @@ -0,0 +1,22 @@
> > > > +// SPDX-License-Identifier: GPL-2.0-only
> > > > +/*
> > > > + * Stubs for out-of-line function calls caused by re-using kernel
> > > > + * infrastructure at EL2.
> > > > + *
> > > > + * Copyright (C) 2020 - Google LLC
> > > > + */
> > > > +
> > > > +#include <linux/list.h>
> > > > +
> > > > +#ifdef CONFIG_DEBUG_LIST
> > > > +bool __list_add_valid(struct list_head *new, struct list_head *prev,
> > > > +		      struct list_head *next)
> > > > +{
> > > > +		return true;
> > > > +}
> > > > +
> > > > +bool __list_del_entry_valid(struct list_head *entry)
> > > > +{
> > > > +		return true;
> > > > +}
> > > > +#endif
> > > 
> > > Can we get away with defining our own CHECK_DATA_CORRUPTION macro instead?
> > 
> > Yes I think eventually it'd be nice to get there, but that has other
> > implications (e.g. how do you report something in dmesg from EL2?) so
> > perhaps we can keep that a separate series?
> 
> We wouldn't necessarily have to report anything, but having the return value
> of these functions be based off the generic checks would be great if we can
> do it (i.e. we'd avoid corrupting the list).

Ah, I see what you mean. Happy to have a go a it, there are a few other
small things that make that it a bit annoying e.g. CHECK_DATA_CORRUPTION
is unconditionally defined in bug.h, and I'll need to stub EXPORT_SYMBOL
as well, which may both require changing core files, but maybe that's
fine. And if that is too painful I think it would make sense to keep
this a separate and self-contained series which would be a nice
incremental improvement over the simple approach I have here :)

Cheers,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
