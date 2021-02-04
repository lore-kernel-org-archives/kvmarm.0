Return-Path: <SRS0=ioR1=HG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC41AC433E0
	for <kvmarm@archiver.kernel.org>; Thu,  4 Feb 2021 14:53:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 76ADF64F4D
	for <kvmarm@archiver.kernel.org>; Thu,  4 Feb 2021 14:53:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 76ADF64F4D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C9FBF4B235;
	Thu,  4 Feb 2021 09:53:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2M66JhM2swJl; Thu,  4 Feb 2021 09:52:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D29744B23E;
	Thu,  4 Feb 2021 09:52:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 330F54B235
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2021 09:52:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 05+dCyppEeXn for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Feb 2021 09:52:57 -0500 (EST)
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com
 [209.85.128.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 162464B229
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2021 09:52:57 -0500 (EST)
Received: by mail-wm1-f43.google.com with SMTP id c127so3218026wmf.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Feb 2021 06:52:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=GmzDwYCwB3ACF6L8pkrzfaM1KU2/zTHOCAwwjAAIW1c=;
 b=T4n7B/HDfO8GLn9RDv5a9Mnd7w6QzC1CmmDAy2dGrwaoMO/jJ9ye68xPKJXV0LUP0g
 HMI9KaeCJNVypsn0VcgiXF0nahQXoHOgDKN4FwRWRycbYlkqaH9q1rmG+kRJ8FGQJ1TS
 KQOwwrHclrlRKXj4BjzWTg9Tds6QLnXBGQlVYn2K5UHD2lSJLkgLXYfczlptpwyjMoni
 lRVSC4FnURwvgkpAlTUnIrGGVyJXCmGFRKRzLAt1vP7qj8FHDEynp0phez5v1FcB62jo
 bg9FLizdXkt4a8l65wUYQQXLTkD0GdTnUAlZekz6904IYqEVSUDgLLvEPRXk+a/P6Ta/
 bNSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=GmzDwYCwB3ACF6L8pkrzfaM1KU2/zTHOCAwwjAAIW1c=;
 b=ZTGsD0PgFoKoR9dzO/BtNpTAiMyF937tMbnwRq5WOP0EwqyoueuZKgG4WrPfysqFbG
 D0iDvfoFqA6h5yi/VHNnADlYQcE+mTYrf5DGSxK+sY1wnCLBvmrPkC37ZeZOv2UVY0JO
 jfX1lZ91X7kC/1J6/lJvCPSYcfgoRkYHtCw6CjbrNtfS7k1nqlXp2fm/bRrv82i4n6HY
 /C9FAx9jKELXnSz5JdzHAM7oZvnCIMM4tBYSq7wh2hXaZjCe7HuZZgBDHF9n4Agdkqfu
 RMF0pGVXVaV5Qw17Pz84Ou9Fk7ijJDQ6+hQydj/S08vwXB0ultzYxFosIgo3nAKpbQNm
 1e3A==
X-Gm-Message-State: AOAM531xSkIHqElIV0VYkOFgJIAG9gy0VVnXxTGS+tGXXFRrTIOihKMQ
 2Ih1RHOzPljSnImysz+W4eu7FA==
X-Google-Smtp-Source: ABdhPJytkpleb2goc1M1MLDTsD+ny4hCYPN6kmBxFpTwEmpJaqq+R5jrD51y1ejkMwjS5CKoxfmVRw==
X-Received: by 2002:a05:600c:ce:: with SMTP id
 u14mr7866356wmm.10.1612450375861; 
 Thu, 04 Feb 2021 06:52:55 -0800 (PST)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id y63sm6195028wmd.21.2021.02.04.06.52.55
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 04 Feb 2021 06:52:55 -0800 (PST)
Date: Thu, 4 Feb 2021 14:52:52 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [RFC PATCH v2 12/26] KVM: arm64: Introduce a Hyp buddy page
 allocator
Message-ID: <YBwKRM3uHDMC9S0U@google.com>
References: <20210108121524.656872-1-qperret@google.com>
 <20210108121524.656872-13-qperret@google.com>
 <20210202181307.GA17311@willie-the-truck>
 <YBrsep4xK1F4YRWb@google.com>
 <20210204143106.GA20792@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210204143106.GA20792@willie-the-truck>
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

On Thursday 04 Feb 2021 at 14:31:08 (+0000), Will Deacon wrote:
> On Wed, Feb 03, 2021 at 06:33:30PM +0000, Quentin Perret wrote:
> > On Tuesday 02 Feb 2021 at 18:13:08 (+0000), Will Deacon wrote:
> > > On Fri, Jan 08, 2021 at 12:15:10PM +0000, Quentin Perret wrote:
> > > > + *   __find_buddy(pool, page 0, order 0) => page 1
> > > > + *   __find_buddy(pool, page 0, order 1) => page 2
> > > > + *   __find_buddy(pool, page 1, order 0) => page 0
> > > > + *   __find_buddy(pool, page 2, order 0) => page 3
> > > > + */
> > > > +static struct hyp_page *__find_buddy(struct hyp_pool *pool, struct hyp_page *p,
> > > > +				     unsigned int order)
> > > > +{
> > > > +	phys_addr_t addr = hyp_page_to_phys(p);
> > > > +
> > > > +	addr ^= (PAGE_SIZE << order);
> > > > +	if (addr < pool->range_start || addr >= pool->range_end)
> > > > +		return NULL;
> > > 
> > > Are these range checks only needed because the pool isn't required to be
> > > an exact power-of-2 pages in size? If so, maybe it would be more
> > > straightforward to limit the max order on a per-pool basis depending upon
> > > its size?
> > 
> > More importantly, it is because pages outside of the pool are not
> > guaranteed to be covered by the hyp_vmemmap, so I really need to make
> > sure I don't dereference them.
> 
> Wouldn't having a per-pool max order help with that?

The issue is, I have no alignment guarantees for the pools, so I may end
up with max_order = 0 ...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
