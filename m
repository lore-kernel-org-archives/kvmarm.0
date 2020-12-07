Return-Path: <SRS0=wPN+=FL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DFC3C4361B
	for <kvmarm@archiver.kernel.org>; Mon,  7 Dec 2020 11:58:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E344C23372
	for <kvmarm@archiver.kernel.org>; Mon,  7 Dec 2020 11:58:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E344C23372
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 113A14B273;
	Mon,  7 Dec 2020 06:58:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xmiySPpaHLPh; Mon,  7 Dec 2020 06:58:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB10F4B29F;
	Mon,  7 Dec 2020 06:58:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 94DF54B26B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2020 06:58:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XtmQJTmlUdhQ for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Dec 2020 06:58:16 -0500 (EST)
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com
 [209.85.128.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 85B524B265
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2020 06:58:16 -0500 (EST)
Received: by mail-wm1-f67.google.com with SMTP id k10so11238946wmi.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Dec 2020 03:58:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=QXhe9B9BJ7USSO3oeUBj7EmOBzDk/2v+2B7jxK6gtbg=;
 b=iG24RCKl+ygINMY1nAhD2uNc0qaaBKZsFX4Z6upKoDJg/x3GJI96vsDzaMEFbfuZf0
 RaTxdFpfJr4kAP+kSAXP6Hg0yTMoOYnEHeQi5akZjbVsdYl9ibGfpOcHF6hyfP6xE8jH
 CJFt7ZcPKyrT7z/9Ex7CR5+ExOVXAHf3DjZLIHCDWefWBzFiCrJ2Zfn5TzK1e3SroR9i
 M7R1jgzQvggjuPkSRMjMrwr8NXriK+ITjyd11nJMWqGln9M4L9U5Q3pTJ1f+6Pk+4gad
 s1xZ6Mej5NQI2e6fN1kNAmVQrYMIn4gvKSxbeFIrznGNlGAaVeDl+dEWZT44ZzqVD985
 EUyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=QXhe9B9BJ7USSO3oeUBj7EmOBzDk/2v+2B7jxK6gtbg=;
 b=KGbkQHIiXUYMeb3QYdatsGduw8OfM46TMEVYD2clperloKL4gytH7gYxsztEqENrXY
 pWYvNzF1kqZ9mPPgnrHHq8DAXMWkt+RLkaL3ISR6Dh0R/l7m8DS6K1kTOan/E3ETu1JN
 nngas5XwWeMuyMx9J7XLkf/ujy7S3ClVN1aNojB1MGM6lVBkz2XJZIQhitEiYhNxYXSu
 y3gjLczR7r+tluhCrL13fhEoc+st0kBmzRhDV0fmz3i1YgPyPXp8Ofa1BdBnxAyq/0Ic
 kojndEGeHd43QPV7NrYRkU8kMvAbSjbgruZ5E85Zj3Nyg5vmi9Adpw0pPLCbFU8nQtgL
 bmvg==
X-Gm-Message-State: AOAM530jc3AkY7Oal9+Sw+ARpXi5N7HJTbEGawwlnyRtJyQz/H29QUS6
 /RokkoCDUh3zi5OewgbJnNA1Pw==
X-Google-Smtp-Source: ABdhPJwUzWSoIPl5fmIEWseyZa8uAixbFQ83VDcWjXlOYrOt9eUmIZlDTJNHwBtOScO5fPv4OfgRrw==
X-Received: by 2002:a1c:49c2:: with SMTP id
 w185mr10925592wma.184.1607342295377; 
 Mon, 07 Dec 2020 03:58:15 -0800 (PST)
Received: from google.com ([2a00:79e0:d:210:f693:9fff:fef4:a7ef])
 by smtp.gmail.com with ESMTPSA id m21sm13730406wml.13.2020.12.07.03.58.14
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 07 Dec 2020 03:58:14 -0800 (PST)
Date: Mon, 7 Dec 2020 11:58:11 +0000
From: Quentin Perret <qperret@google.com>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [RFC PATCH 16/27] KVM: arm64: Prepare Hyp memory protection
Message-ID: <X84Y07kbeSL4xcNJ@google.com>
References: <20201117181607.1761516-1-qperret@google.com>
 <20201117181607.1761516-17-qperret@google.com>
 <CA+EHjTyJnZ8e=AN7H_k+oZb0VTWAgMicMY8Rqe2Di_3A87hm0A@mail.gmail.com>
 <X8p5kLSIq2MoQZ24@google.com>
 <CA+EHjTxW_z-P8bK7gCjGv2eBCAHFsvE873Gr2KyVq5-+_Mdv=g@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+EHjTxW_z-P8bK7gCjGv2eBCAHFsvE873Gr2KyVq5-+_Mdv=g@mail.gmail.com>
Cc: "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE"
 <devicetree@vger.kernel.org>, kernel-team@android.com,
 Frank Rowand <frowand.list@gmail.com>, Android KVM <android-kvm@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 open list <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>
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

On Monday 07 Dec 2020 at 11:16:05 (+0000), Fuad Tabba wrote:
> On Fri, Dec 4, 2020 at 6:01 PM Quentin Perret <qperret@google.com> wrote:
> >
> > On Thursday 03 Dec 2020 at 12:57:33 (+0000), Fuad Tabba wrote:
> > <snip>
> > > > +int hyp_create_idmap(void);
> > > > +int hyp_map_vectors(void);
> > > > +int hyp_back_vmemmap(phys_addr_t phys, unsigned long size, phys_addr_t back);
> > > > +int hyp_cpu_set_vector(enum arm64_hyp_spectre_vector slot);
> > > > +int hyp_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot);
> > > > +int __hyp_create_mappings(unsigned long start, unsigned long size,
> > > > +                         unsigned long phys, unsigned long prot);
> > > > +unsigned long __hyp_create_private_mapping(phys_addr_t phys, size_t size,
> > > > +                                          unsigned long prot);
> > > > +
> > >
> > > nit: I also thought that the hyp_create_mappings function names are a
> > > bit confusing, since there's the create_hyp_mappings functions which
> > > use the aforementioned *hyp_pgtable.
> >
> > Sure, happy to re-name those (and hyp_pgtable above). Any suggestions?
> 
> Perhaps something to indicate that these are temporary, tmp_ or
> bootstrap_ maybe?

Hmm, the thing is these are temporary only in protected mode, they're
permanent otherwise :/

Perhaps I could prefix the protected pgtable (and associated functions)
with 'pkvm_' or so? Marc, any preferences?

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
