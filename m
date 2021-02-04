Return-Path: <SRS0=ioR1=HG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A97B4C433DB
	for <kvmarm@archiver.kernel.org>; Thu,  4 Feb 2021 18:19:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1FD4764F44
	for <kvmarm@archiver.kernel.org>; Thu,  4 Feb 2021 18:19:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1FD4764F44
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 896AB4B353;
	Thu,  4 Feb 2021 13:19:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id W0gICiOTd8vU; Thu,  4 Feb 2021 13:19:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 94D164B342;
	Thu,  4 Feb 2021 13:19:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB7214B2B7
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2021 13:19:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aeglxoH7lkZc for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Feb 2021 13:19:40 -0500 (EST)
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com
 [209.85.221.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C1D644B174
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2021 13:19:40 -0500 (EST)
Received: by mail-wr1-f43.google.com with SMTP id q7so4622787wre.13
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Feb 2021 10:19:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=+VEh3ULnEt2qMyxdjl7CY1dmR0Zg7cCNlHAqS2EOLUo=;
 b=MXWcvoo4nhSdplykTRWPmiY+lgTSgacIqYsHHWflzCSAGN45dFMwmmeGPdFWM0o0Su
 Nj9W75DVVfG3D46KMKtSGn5HnZ2UoVQhQgiFQJQZUFzUeFUyEMnc2CsGRDpucqBvcMd0
 +0l7Rje5TWh9GAoP1NjPlEU7MMqq8PGfYM03YZjqM9YHw9PfKe5SWuGVBPg6CxV/D1R+
 agkGzZVfdUavL8OPnLPd4MAUl4gb/RlUoGRth61cB6K33KNsou9OqbtV2Xg0+5bfxFUa
 bSINjTR2QzLDOvdZVWB/Lw1HvT6VVlze/kXtPCb8uS8XN+kD8cpIitGGayzWUidVTnQI
 7x3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=+VEh3ULnEt2qMyxdjl7CY1dmR0Zg7cCNlHAqS2EOLUo=;
 b=aKYsFZv0DrG4UDR+QtQTyiT0myNfNfSiX7JREEyQhLuzX1BaLrXHE/R73cHTDr/DNo
 2YKTUiE5lGdVTgK2+KM/lzIJqlHUup+t6mRWIM5k7Mz5/dkp4zIhJ2ZNR8iVNPdqHPS3
 pKg25+y3RA0X6E0gV2YttH2NxGwGZNqsRyMeX/c7tZGrOUJdwtnGQIOtI8k7FBmrKRwk
 Nhr2mGb48iW9vX0r1et0Vf6okeNIXeLiS1Oy/i10IGhRh611wkb9K7nFyqMsXJR9CuNp
 L9jegeBpHoHtF80tTHUJmiWzwSpPAzYGjcQypHXVUJTP+xJdmDS1WRwywRpuEYgWQkoD
 op9A==
X-Gm-Message-State: AOAM530VmTfGGiZH68M8hWxLTmmaEl1NKva14sGuCpoMvmRdDu53nJB7
 GYyO4GNpq/mJb4Ts10maNjuLYQ==
X-Google-Smtp-Source: ABdhPJwI7COPYaGqW+HyuZdtThqGjwA0hFBDsun4GR8de9VIqRa1Cn0OZYfTCDQr1uARFtBcTkppXQ==
X-Received: by 2002:adf:eed0:: with SMTP id a16mr652059wrp.107.1612462779704; 
 Thu, 04 Feb 2021 10:19:39 -0800 (PST)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id u70sm5368278wmu.20.2021.02.04.10.19.39
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 04 Feb 2021 10:19:39 -0800 (PST)
Date: Thu, 4 Feb 2021 18:19:36 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [RFC PATCH v2 12/26] KVM: arm64: Introduce a Hyp buddy page
 allocator
Message-ID: <YBw6uInyY+AlE7D3@google.com>
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
> Just feels a bit backwards having __find_buddy() take an order parameter,
> yet then return a page of the wrong order! __hyp_extract_page() always
> passes the p->order as the order,

Gotcha, so maybe this is just a naming problem. __find_buddy() is simply
a helper to lookup/index the vmemmap, but it's perfectly possible that
the 'destination' page that is being indexed has already been allocated,
and split up multiple time (and so at a different order), etc ... And
that is the caller's job to decide.

How about __lookup_potential_buddy() ? Any suggestion?
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
