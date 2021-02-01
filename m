Return-Path: <SRS0=CHPd=HD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A805C433E0
	for <kvmarm@archiver.kernel.org>; Mon,  1 Feb 2021 17:41:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 66CA064E9E
	for <kvmarm@archiver.kernel.org>; Mon,  1 Feb 2021 17:41:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 66CA064E9E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D69154B334;
	Mon,  1 Feb 2021 12:41:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jmv7dGZugWrC; Mon,  1 Feb 2021 12:41:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BDEC74B36D;
	Mon,  1 Feb 2021 12:41:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A61E4B2B1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Feb 2021 12:41:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uo121tx1emIt for <kvmarm@lists.cs.columbia.edu>;
 Mon,  1 Feb 2021 12:41:01 -0500 (EST)
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com
 [209.85.221.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D79154B321
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Feb 2021 12:41:00 -0500 (EST)
Received: by mail-wr1-f47.google.com with SMTP id z6so17487804wrq.10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 01 Feb 2021 09:41:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=NecD4Lj2Pit6+zWdziXlW+Wn9lKyelFLyjZNsi277Ko=;
 b=saZ8e5FdXuzKn/wEQOBBdHmpMeHPCpDbAv/xRAxSPOf23fsZYMdk8Yk22lsNT8n+FL
 svRxqoOqTKJjnuSSRyZ+qRx+Efu4w8zHaWLl+bSl/ojmyvBk5bvUIkcHW+jPkaRxjPKN
 AuYSYNzxd18rPUOdsf6Txex3i+Vh3AtUKjJGo1Ow2zHCOx3wA+tdweA4Y3kmSV52XQ2a
 F1I0mbphY6MnUwjZH6PqH8XWbY3tOU4tPce17NCIV/4I7dwNeuNs39OD0g/CRKmBMrJI
 gGZ/tUgRP+6B/DdP59LjGHj87qRLEduw7FMO7hwxvY088FTQz9Qdt46slGB/Tx6BSOG9
 YIDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=NecD4Lj2Pit6+zWdziXlW+Wn9lKyelFLyjZNsi277Ko=;
 b=BJci9KHF7LxIrUngchdVDop/l+EK+/1/Rg6WPUgLicP1IpnicwXHO6rqKbhfBoCu1q
 T993ELtsMw6fLTED0E3y3ZhD/B0k3hD8l0nvqgIxRwOX56IPb/O+4nYbTcmBL4hkEVjy
 WWcakVxfC1leJ6Ja1AQGgY8cWVBbf9XCfSAHD6h0OC/al4kP4ZywsAeeHfYC0dawNceJ
 XexbbY15RLypv6VJsixDXtrPS8AZEmNqDLC1fF5BPXfNFr5VQg7GL02oz2GlXQXfgnbo
 RBIVlaqM/5pidQoWUTA0QOJel+v7ptmw+sUER09nMT4GvgFHx+sT2KTgAUiWQb+8nKkF
 Ypsw==
X-Gm-Message-State: AOAM530XvxuXWNNSTlqMUiNz0aOo4tRbiQCGEgKaa6SU99RAvXzsQWTR
 8kJELwXjn0mygXiKMunapsvCqg==
X-Google-Smtp-Source: ABdhPJyVjTMobOwpzGXZWG3t6ZHVDL2R31hio+NCbOHokYHgLSzOJpH3gDsceNyauEudNIluLfZ9+g==
X-Received: by 2002:a5d:458a:: with SMTP id p10mr19485759wrq.168.1612201259731; 
 Mon, 01 Feb 2021 09:40:59 -0800 (PST)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id r25sm29850479wrr.64.2021.02.01.09.40.59
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 01 Feb 2021 09:40:59 -0800 (PST)
Date: Mon, 1 Feb 2021 17:40:56 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [RFC PATCH v2 03/26] arm64: kvm: Add standalone ticket spinlock
 implementation for use at hyp
Message-ID: <YBg9KPnKfJzraTBO@google.com>
References: <20210108121524.656872-1-qperret@google.com>
 <20210108121524.656872-4-qperret@google.com>
 <20210201172833.GA15632@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210201172833.GA15632@willie-the-truck>
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

On Monday 01 Feb 2021 at 17:28:34 (+0000), Will Deacon wrote:
> On Fri, Jan 08, 2021 at 12:15:01PM +0000, Quentin Perret wrote:
> > From: Will Deacon <will@kernel.org>
> > 
> > We will soon need to synchronise multiple CPUs in the hyp text at EL2.
> > The qspinlock-based locking used by the host is overkill for this purpose
> > and relies on the kernel's "percpu" implementation for the MCS nodes.
> > 
> > Implement a simple ticket locking scheme based heavily on the code removed
> > by commit c11090474d70 ("arm64: locking: Replace ticket lock implementation
> > with qspinlock").
> > 
> > Signed-off-by: Will Deacon <will@kernel.org>
> > Signed-off-by: Quentin Perret <qperret@google.com>
> > ---
> >  arch/arm64/kvm/hyp/include/nvhe/spinlock.h | 92 ++++++++++++++++++++++
> >  1 file changed, 92 insertions(+)
> >  create mode 100644 arch/arm64/kvm/hyp/include/nvhe/spinlock.h
> > 
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/spinlock.h b/arch/arm64/kvm/hyp/include/nvhe/spinlock.h
> > new file mode 100644
> > index 000000000000..7584c397bbac
> > --- /dev/null
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/spinlock.h
> > @@ -0,0 +1,92 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + * A stand-alone ticket spinlock implementation for use by the non-VHE
> > + * KVM hypervisor code running at EL2.
> > + *
> > + * Copyright (C) 2020 Google LLC
> > + * Author: Will Deacon <will@kernel.org>
> > + *
> > + * Heavily based on the implementation removed by c11090474d70 which was:
> > + * Copyright (C) 2012 ARM Ltd.
> > + */
> > +
> > +#ifndef __ARM64_KVM_NVHE_SPINLOCK_H__
> > +#define __ARM64_KVM_NVHE_SPINLOCK_H__
> > +
> > +#include <asm/alternative.h>
> > +#include <asm/lse.h>
> > +
> > +typedef union hyp_spinlock {
> > +	u32	__val;
> > +	struct {
> > +#ifdef __AARCH64EB__
> > +		u16 next, owner;
> > +#else
> > +		u16 owner, next;
> > +	};
> > +#endif
> 
> Looks like I put this #endif in the wrong place; probably needs to be a line
> higher.

Uh oh, missed that too. Fix now merged locally, thanks.

Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
