Return-Path: <SRS0=mEDx=HE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65F86C433DB
	for <kvmarm@archiver.kernel.org>; Tue,  2 Feb 2021 09:44:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BDC9664DA8
	for <kvmarm@archiver.kernel.org>; Tue,  2 Feb 2021 09:44:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BDC9664DA8
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A6714B193;
	Tue,  2 Feb 2021 04:44:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eNermH8rd-VM; Tue,  2 Feb 2021 04:44:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B3A64B175;
	Tue,  2 Feb 2021 04:44:40 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 44B384B175
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Feb 2021 04:44:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uprJXaQTmCP4 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Feb 2021 04:44:38 -0500 (EST)
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com
 [209.85.128.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 12A004B134
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Feb 2021 04:44:38 -0500 (EST)
Received: by mail-wm1-f52.google.com with SMTP id i9so1670519wmq.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Feb 2021 01:44:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=VSSaPfRwvDGbQxdeByNUZ9wyHZguwKJIHB4orZkRX1U=;
 b=icnf8IsQd9Q4RXyrczWdoSkwbyXLaEO6875Us6xORHCs9Jiwot3EFoxuqn8jHAGlqJ
 WC9WKxlkoKRuzYW5lQfPyf4X37E2NgGZDBulxh+ddu/9JSwp7kTe2nPHMnMwFxfB+YhR
 7c1qWY/YfsE22reCcr1x+CsicRskIT1cq/Bh9JrQ3TPma5wZyf9A53G78pmr9m62vImQ
 6gIsG+A2mm3O1Ic7fDPm1buPDEDNp0MEFD3zZx1FYOsCutARFZKGY4yA1Umv41CoszTH
 /FUg8mWpEJuh2GWVvmFLwAv7tvSIGUo4oSD0BvbjJXwUDW/SYj1Q2/JACFpZ/hiIf/u8
 SkfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=VSSaPfRwvDGbQxdeByNUZ9wyHZguwKJIHB4orZkRX1U=;
 b=PZeG/sIkT2kMKUuSPP2BAuiZGP0iptH69m1alEvpgtODr5/G1rol5O/NpBsc2w/XWG
 HXbhH/CLRn2iAlWJJj3O9zFI1/RmfTfO4+fGoqkgZt0ECauthfcb5qjW05GIx0OmzOki
 cJllQg0ySQKgzh0RuRLY0wAFcigSsl763G1c5KiLpCw4/3hAShUZLtl/04BwwjiuOHnt
 ue8xdEpsXOZgaK6PJtmIKZBlmgCXpj/MGZF5BIXZHHeAwpBhnpW3m6I7t3WKRPGDDd88
 k4cJfFCPcIoyyFb3eEi1/+0ZK76f+TE+XuUJ1xCyIapibk6iAHQYw9+HYIuV2R0L9wwa
 oEeA==
X-Gm-Message-State: AOAM530YyElKrJSq3yhR3oWp8Ih+jwhPyRlUYqNEoxL8FGdf9cV0sLSE
 mrlWCWuE6iTLruEv8qB39Ogebg==
X-Google-Smtp-Source: ABdhPJyFiDDkIMMluTAJ82TQKsuEQkfwk62lc0hmMunFauchGHnGuIDHT9S1UODUlL2ZopO0LOlhTQ==
X-Received: by 2002:a05:600c:24e:: with SMTP id
 14mr2705390wmj.87.1612259076914; 
 Tue, 02 Feb 2021 01:44:36 -0800 (PST)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id u1sm2169128wml.11.2021.02.02.01.44.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 02 Feb 2021 01:44:36 -0800 (PST)
Date: Tue, 2 Feb 2021 09:44:33 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [RFC PATCH v2 10/26] KVM: arm64: Introduce an early Hyp page
 allocator
Message-ID: <YBkfAVC4KWPUnvI4@google.com>
References: <20210108121524.656872-1-qperret@google.com>
 <20210108121524.656872-11-qperret@google.com>
 <20210201190008.GI15632@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210201190008.GI15632@willie-the-truck>
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

On Monday 01 Feb 2021 at 19:00:08 (+0000), Will Deacon wrote:
> On Fri, Jan 08, 2021 at 12:15:08PM +0000, Quentin Perret wrote:
> > diff --git a/arch/arm64/kvm/hyp/nvhe/early_alloc.c b/arch/arm64/kvm/hyp/nvhe/early_alloc.c
> > new file mode 100644
> > index 000000000000..de4c45662970
> > --- /dev/null
> > +++ b/arch/arm64/kvm/hyp/nvhe/early_alloc.c
> > @@ -0,0 +1,60 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * Copyright (C) 2020 Google LLC
> > + * Author: Quentin Perret <qperret@google.com>
> > + */
> > +
> > +#include <asm/kvm_pgtable.h>
> > +
> > +#include <nvhe/memory.h>
> > +
> > +struct kvm_pgtable_mm_ops hyp_early_alloc_mm_ops;
> > +s64 __ro_after_init hyp_physvirt_offset;
> > +
> > +static unsigned long base;
> > +static unsigned long end;
> > +static unsigned long cur;
> > +
> > +unsigned long hyp_early_alloc_nr_pages(void)
> > +{
> > +	return (cur - base) >> PAGE_SHIFT;
> > +}
> 
> nit: but I find this function name confusing (it's returning the number of
> _allocated_ pages, not the number of _free_ pages!). How about something
> like hyp_early_alloc_size() to match hyp_s1_pgtable_size() which you add
> later? [and move the shift out to the caller]?

Works for me.

> > +extern void clear_page(void *to);
> 
> Stick this in a header?

Right, that, or perhaps just use asm/page.h directly -- I _think_ that
should work fine assuming with have the correct symbol aliasing in
place.

> > +
> > +void *hyp_early_alloc_contig(unsigned int nr_pages)
> 
> I think order might make more sense, or do you need to allocate
> non-power-of-2 batches of pages?

Indeed, I allocate page-aligned blobs of arbitrary size (e.g.
divide_memory_pool() in patch 16), so I prefer it that way.

> > +{
> > +	unsigned long ret = cur, i, p;
> > +
> > +	if (!nr_pages)
> > +		return NULL;
> > +
> > +	cur += nr_pages << PAGE_SHIFT;
> > +	if (cur > end) {
> 
> This would mean that concurrent hyp_early_alloc_nr_pages() would transiently
> give the wrong answer. Might be worth sticking the locking expectations with
> the function prototypes.

This is only called from a single CPU from a non-preemptible section, so
that is not a problem. But yes, I'll stick a comment.

> That said, maybe it would be better to write this check as:
> 
> 	if (end - cur < (nr_pages << PAGE_SHIFT))
> 
> as that also removes the need to worry about overflow if nr_pages is huge
> (which would be a bug in the hypervisor, which we would then catch here).

Sounds good.

> > +		cur = ret;
> > +		return NULL;
> > +	}
> > +
> > +	for (i = 0; i < nr_pages; i++) {
> > +		p = ret + (i << PAGE_SHIFT);
> > +		clear_page((void *)(p));
> > +	}
> > +
> > +	return (void *)ret;
> > +}
> > +
> > +void *hyp_early_alloc_page(void *arg)
> > +{
> > +	return hyp_early_alloc_contig(1);
> > +}
> > +
> > +void hyp_early_alloc_init(unsigned long virt, unsigned long size)
> > +{
> > +	base = virt;
> > +	end = virt + size;
> > +	cur = virt;
> 
> nit: base = cur = virt;

Ack.

Thanks for the review,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
