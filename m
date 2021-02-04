Return-Path: <SRS0=ioR1=HG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14732C433DB
	for <kvmarm@archiver.kernel.org>; Thu,  4 Feb 2021 18:32:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 51C1E64E49
	for <kvmarm@archiver.kernel.org>; Thu,  4 Feb 2021 18:32:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 51C1E64E49
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD4D44B2FC;
	Thu,  4 Feb 2021 13:32:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 49FFcQzkYY+B; Thu,  4 Feb 2021 13:32:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AB3BB4B2A5;
	Thu,  4 Feb 2021 13:32:40 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C1754B2A5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2021 13:32:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X3ZlgM0Rt064 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Feb 2021 13:32:38 -0500 (EST)
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com
 [209.85.221.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E33304B283
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2021 13:32:37 -0500 (EST)
Received: by mail-wr1-f45.google.com with SMTP id g10so4764712wrx.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Feb 2021 10:32:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=i5OkDpHRHvhiXPZMMrrT7zhfgAaMhV3SLJ8BwwytR0s=;
 b=NzENSC2sGUAf6yMy4ybJ293aeKFlUOzRFqVDwa74QP6UwZ/5IB3S3LIPQlwbp8bt+o
 my5F6ZY9nh5di/2C5uBrcKhs1fQfE4OjUXJxheN1wZ1ovB0osI0wHXutPiHAY6pkY928
 OR/S/0A2mA0gjFJH/vBiR0uoQi938QDkKsHzUCcRVEycYypV02mCwH+ckuhX0Clxw+2v
 McHwgjv6KG1P3zyyXs7Bt3u5wlGAn4NA54GuwScW05yezBwR9v5ja/FCqYiw2uJ6WrWA
 XhnTVy2FmSfpuLX/NciEWonqr0lJprKj2D3hDkRr4Fs5NcqZ2QedkbgZMh7JLQPgylbK
 e7oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=i5OkDpHRHvhiXPZMMrrT7zhfgAaMhV3SLJ8BwwytR0s=;
 b=l3rYhemieIQGEJ3qiyEkmfKjjBum9twHPgh1OC78cpUuyg5lE+ZLtWTesJzsbIXalV
 6CTTTjAYDkfHqjTpLmLhpPVWTszB4QM0J1zFO3qhZdgrLrAGdWRsv2/NR+rlbntvoqmD
 5oZ77PtsDFBQwCwYFq2EXOV9R4d8djk2P0NM5zOarKnxSRrBk2jGEyO8KXoWc4FI1OAZ
 mk9gmqevuD5TfTGsOpL0mfXpXkkv6dep3e8p0bUZxdtqVuEyMMXC8k6dZnXl6G1M4k0U
 YU4E2JfNHki0oQilmKeR6ffOvb5V4K+id6BTlb9HcIc3bMvzBfJopRiPOxuNRc9cLrm7
 8pVg==
X-Gm-Message-State: AOAM5302xvwAPXF0dZtb94Qg7UtOD2qP6Q2OExVlSn6PDK8HJrD1BI0D
 rfZeP4Q8IwCteqqCRH5En8qluw==
X-Google-Smtp-Source: ABdhPJy3jMGnpK1oKMDwo50uDDpX8aOtqGavw98z6Rfz/JgQr0QwNihP4xXGA7II1oRyQsQB6m2lqg==
X-Received: by 2002:a5d:560c:: with SMTP id l12mr675373wrv.417.1612463555851; 
 Thu, 04 Feb 2021 10:32:35 -0800 (PST)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id c20sm6618034wmb.38.2021.02.04.10.32.35
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 04 Feb 2021 10:32:35 -0800 (PST)
Date: Thu, 4 Feb 2021 18:32:32 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [RFC PATCH v2 12/26] KVM: arm64: Introduce a Hyp buddy page
 allocator
Message-ID: <YBw9wCvkAXLUpgw7@google.com>
References: <20210108121524.656872-1-qperret@google.com>
 <20210108121524.656872-13-qperret@google.com>
 <20210202181307.GA17311@willie-the-truck>
 <YBrsep4xK1F4YRWb@google.com>
 <20210204143106.GA20792@willie-the-truck>
 <YBw6uInyY+AlE7D3@google.com>
 <20210204182404.GB21526@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210204182404.GB21526@willie-the-truck>
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

On Thursday 04 Feb 2021 at 18:24:05 (+0000), Will Deacon wrote:
> On Thu, Feb 04, 2021 at 06:19:36PM +0000, Quentin Perret wrote:
> > On Thursday 04 Feb 2021 at 14:31:08 (+0000), Will Deacon wrote:
> > > Just feels a bit backwards having __find_buddy() take an order parameter,
> > > yet then return a page of the wrong order! __hyp_extract_page() always
> > > passes the p->order as the order,
> > 
> > Gotcha, so maybe this is just a naming problem. __find_buddy() is simply
> > a helper to lookup/index the vmemmap, but it's perfectly possible that
> > the 'destination' page that is being indexed has already been allocated,
> > and split up multiple time (and so at a different order), etc ... And
> > that is the caller's job to decide.
> > 
> > How about __lookup_potential_buddy() ? Any suggestion?
> 
> Hey, my job here is to waffle incoherently and hope that you find bugs in
> your own code. Now you want me to _name_ something! Jeez...

Hey, that's my special -- I already got Marc to make a suggestion on v1
and it's been my favorite function name so far, so why not try again?

https://lore.kernel.org/kvmarm/d6a674a0e8e259161ab741d78924c756@kernel.org/

> Ok, how about __find_buddy() does what it does today but doesn't take an
> order argument, whereas __find_buddy_of_order() takes the order argument
> and checks the page order before returning?

Sounds like a plan!

Cheers,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
