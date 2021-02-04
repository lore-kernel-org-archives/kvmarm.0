Return-Path: <SRS0=ioR1=HG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1B57C433DB
	for <kvmarm@archiver.kernel.org>; Thu,  4 Feb 2021 18:01:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EA4E064F4D
	for <kvmarm@archiver.kernel.org>; Thu,  4 Feb 2021 18:01:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EA4E064F4D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 488F34B346;
	Thu,  4 Feb 2021 13:01:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2dOrHbKfURw7; Thu,  4 Feb 2021 13:01:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 337E14B338;
	Thu,  4 Feb 2021 13:01:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CD184B338
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2021 13:01:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eszHYpx4TGtG for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Feb 2021 13:01:17 -0500 (EST)
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com
 [209.85.221.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3A6EA4B32C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2021 13:01:17 -0500 (EST)
Received: by mail-wr1-f45.google.com with SMTP id z6so4577463wrq.10
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Feb 2021 10:01:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=sgNBgGYoMlIjzXJS7k+uTJr90AGrN8C+0QKMchqVgEw=;
 b=Sge4JAbgrFLOizl11w9D9oQSAmAxwysJJW+ccrQVWH3ezom8wIwM6z9XWUlzOfNRhC
 Jiz/Z0fwGZlSo+kWjB2iV8VlRI25x/wqVzkaVWFrDTrJLatKYfuN8jzaHg7RCdkDaqE5
 VKKxtZNvMbU6xv1PrGxNgfs24F1XOAtvlS9QjdUgxxt0D6WrAVj8qoUhNoxMQ0JIEGRi
 jm32ZYSURfxm7Bbxf95Qa4KEt5B3gzPag9r32O6cMQusXyCbiODFioaUjENYLWWWP+Tb
 YbDAdDPDq8CFjHTGCe1PVUYpFrmKe/cvt2yMg6pVlCCnPTMOFH/igkbptVPNcYEO4OqS
 OrGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=sgNBgGYoMlIjzXJS7k+uTJr90AGrN8C+0QKMchqVgEw=;
 b=qUNtJ1lWAvjVvlsf2MsMDXDjYzGyETjYQuA0p2FNdv8B5oaMESePLYZJke+1jrJTyi
 PmDnPJvstNducsIE9aN6DfHVTXZmVuwb2h1PchJbRzE6EkCv2pK/LkECJ0gHU3akGPFk
 EFUeKCu7isDXmndW+b4tKgvvolxxvvKeSadsr0q5hzAlQU1uHz2kJhqKEugTS3ZOrkb/
 IUTyUdotHjYiVllErcVLgrcCcrQMTN2yWL3la54AvNd6AwgDi9Br3sV6vXlsEC44WgLe
 CuI1VikYG0g7Czn6VSL+bnk0q3HpKYlVIQb/oOE6dT3oKHEQjvNYCb6KRU7K1cdoSA6b
 /oqw==
X-Gm-Message-State: AOAM531m7gkTPNmtRhXnZXgF3W0/PZqi3Iqfzj0a8uBMnWRtEHAYogiR
 wA3+f87s5bhWm/PzTCuv1K7Gqg==
X-Google-Smtp-Source: ABdhPJxzVwJVmeoEOZDZT5PwvHVmhUwJ0gSawClAAnwU0xD6ZtCQJxYDI7bHVG6gBHJ0ToO7Ntu4zQ==
X-Received: by 2002:adf:b749:: with SMTP id n9mr534156wre.267.1612461676095;
 Thu, 04 Feb 2021 10:01:16 -0800 (PST)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id t18sm8959891wrr.56.2021.02.04.10.01.15
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 04 Feb 2021 10:01:15 -0800 (PST)
Date: Thu, 4 Feb 2021 18:01:12 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [RFC PATCH v2 12/26] KVM: arm64: Introduce a Hyp buddy page
 allocator
Message-ID: <YBw2aIr/Ktx1dsOT@google.com>
References: <20210108121524.656872-1-qperret@google.com>
 <20210108121524.656872-13-qperret@google.com>
 <20210202181307.GA17311@willie-the-truck>
 <YBrsep4xK1F4YRWb@google.com>
 <20210204143106.GA20792@willie-the-truck>
 <YBwKRM3uHDMC9S0U@google.com>
 <20210204174849.GA21303@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210204174849.GA21303@willie-the-truck>
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

On Thursday 04 Feb 2021 at 17:48:49 (+0000), Will Deacon wrote:
> On Thu, Feb 04, 2021 at 02:52:52PM +0000, Quentin Perret wrote:
> > On Thursday 04 Feb 2021 at 14:31:08 (+0000), Will Deacon wrote:
> > > On Wed, Feb 03, 2021 at 06:33:30PM +0000, Quentin Perret wrote:
> > > > On Tuesday 02 Feb 2021 at 18:13:08 (+0000), Will Deacon wrote:
> > > > > On Fri, Jan 08, 2021 at 12:15:10PM +0000, Quentin Perret wrote:
> > > > > > + *   __find_buddy(pool, page 0, order 0) => page 1
> > > > > > + *   __find_buddy(pool, page 0, order 1) => page 2
> > > > > > + *   __find_buddy(pool, page 1, order 0) => page 0
> > > > > > + *   __find_buddy(pool, page 2, order 0) => page 3
> > > > > > + */
> > > > > > +static struct hyp_page *__find_buddy(struct hyp_pool *pool, struct hyp_page *p,
> > > > > > +				     unsigned int order)
> > > > > > +{
> > > > > > +	phys_addr_t addr = hyp_page_to_phys(p);
> > > > > > +
> > > > > > +	addr ^= (PAGE_SIZE << order);
> > > > > > +	if (addr < pool->range_start || addr >= pool->range_end)
> > > > > > +		return NULL;
> > > > > 
> > > > > Are these range checks only needed because the pool isn't required to be
> > > > > an exact power-of-2 pages in size? If so, maybe it would be more
> > > > > straightforward to limit the max order on a per-pool basis depending upon
> > > > > its size?
> > > > 
> > > > More importantly, it is because pages outside of the pool are not
> > > > guaranteed to be covered by the hyp_vmemmap, so I really need to make
> > > > sure I don't dereference them.
> > > 
> > > Wouldn't having a per-pool max order help with that?
> > 
> > The issue is, I have no alignment guarantees for the pools, so I may end
> > up with max_order = 0 ...
> 
> Yeah, so you would still need the range tracking,

Hmm actually I don't think I would, but that would essentially mean the
'buddy' allocator is now turned into a free list of single pages
(because we cannot create pages of order 1).

> but it would at least help
> to reduce HYP_MAX_ORDER failed searches each time. Still, we can always do
> that later.

Sorry but I am not following. In which case do we have HYP_MAX_ORDER
failed searches?

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
