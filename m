Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 410ACECAAA1
	for <kvmarm@archiver.kernel.org>; Mon, 19 Sep 2022 18:28:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B8FA94B643;
	Mon, 19 Sep 2022 14:28:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XvYUnGemSEbi; Mon, 19 Sep 2022 14:28:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E91F4B293;
	Mon, 19 Sep 2022 14:28:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 99C4A4B293
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2022 14:28:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xwJDpRqweiiE for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Sep 2022 14:28:51 -0400 (EDT)
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com
 [209.85.210.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 624584B1B7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2022 14:28:51 -0400 (EDT)
Received: by mail-pf1-f169.google.com with SMTP id a29so430825pfk.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2022 11:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date;
 bh=NP7EhhZKx6H5sIn1a9SU4sRt+0XSuyZNqZ/tN3b2mo0=;
 b=jXBI8o3TsWG0aeZB6YDRFBwVIn2+bkbanClZGXAK3gKwjce6PN/5CiAPzC8hppZb2E
 k5+4wDbeV2SXkZRrTsiqv39kAhwbYJcynVrLHkRjumETUAsiiU/2qZCyN7R2wvMgKm+z
 QmwSoRuWq8AATZZy+zdFmST/WRG8N6QfJmcsbDqmeeLUF05RfBCeEiIgiQ2lak13JBNG
 Qqax5rANikeuGVWAuQMkTVxVl7OiiEAEBW1HJuicnOfOGKMa18DrGIdENoi7zg1VKy31
 NU97yMvgIh2kSNPDELRCC8K0CKmO2LwNnTbdjHXCSh1eililGxSky2gJvX86lqNvDfvk
 RH0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=NP7EhhZKx6H5sIn1a9SU4sRt+0XSuyZNqZ/tN3b2mo0=;
 b=VgLsRUBRnlwgrQTs+YPSWv+KG694ZurhT/D5Zw3JplbGM8AeRMvlSyc3KSRnQA4BtU
 0hIa2ds2wPQ+a4QIuEe7t8LVG7+kvCaSgPZH6tVWHU1XTrrFLnBt77ZCUx3U+wt4pgy+
 hpue9aQrY3k82sqATy5qR0ACcv5UpV7mWDdnR67JBc+xBGKWTqCrU4MEAEJWqot36jWJ
 H9iAsuvDDXEsga625yyK3xB7Ze3np1ObLZcT07oaUw07RjJdltE2n1Tdjr5DXeweIbV4
 1fbesxO5G8FUEVyIt2mvDRohr1/P6YVkSqKvI2LO2nYcJ2yGY6QNeZXUw4nYlleNh8Gj
 a3wQ==
X-Gm-Message-State: ACrzQf1lXzxJq3P76j/kPs2W+uPF6PuU93Gnrl2hAioTYfe0oPn5TpMq
 WXwIhbmBIBKydtyUCelK9gDmXg==
X-Google-Smtp-Source: AMsMyM4y6jxi9TY5TDIe4MF85ZLkZAr49dOv4HR1xbZ3wrfq+XU/0AsskfnyiUEg4RGco/eBsSsnGA==
X-Received: by 2002:a05:6a00:1ac6:b0:548:962b:4c50 with SMTP id
 f6-20020a056a001ac600b00548962b4c50mr19845246pfv.76.1663612130099; 
 Mon, 19 Sep 2022 11:28:50 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com.
 [34.82.181.220]) by smtp.gmail.com with ESMTPSA id
 t3-20020a17090b018300b002030d596ff7sm6970253pjs.37.2022.09.19.11.28.49
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 19 Sep 2022 11:28:49 -0700 (PDT)
Date: Mon, 19 Sep 2022 11:28:46 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v6 00/13] KVM: selftests: Add aarch64/page_fault_test
Message-ID: <Yyi03sX5hx36M/Zr@google.com>
References: <20220906180930.230218-1-ricarkol@google.com>
 <166358370892.2832387.8903539023908338224.b4-ty@kernel.org>
 <Yyia9uqpaIm4JyH+@google.com> <87a66vl2tv.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87a66vl2tv.wl-maz@kernel.org>
Cc: kvm@vger.kernel.org, bgardon@google.com, andrew.jones@linux.dev,
 axelrasmussen@google.com, dmatlack@google.com, pbonzini@redhat.com,
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

On Mon, Sep 19, 2022 at 05:57:16PM +0100, Marc Zyngier wrote:
> On Mon, 19 Sep 2022 17:38:14 +0100,
> Sean Christopherson <seanjc@google.com> wrote:
> > 
> > On Mon, Sep 19, 2022, Marc Zyngier wrote:
> > > On Tue, 6 Sep 2022 18:09:17 +0000, Ricardo Koller wrote:
> > > > This series adds a new aarch64 selftest for testing stage 2 fault handling for
> > > > various combinations of guest accesses (e.g., write, S1PTW), backing sources
> > > > (e.g., anon), and types of faults (e.g., read on hugetlbfs with a hole, write
> > > > on a readonly memslot). Each test tries a different combination and then checks
> > > > that the access results in the right behavior (e.g., uffd faults with the right
> > > > address and write/read flag). Some interesting combinations are:
> > > > 
> > > > [...]
> > > 
> > > Given how long this has been around, I've picked this series up, applying
> > > Oliver's fixes in the process.
> > 
> > Any chance this can be undone?  A big reason why this is at v6 is
> > because of the common API changes, and due to KVM Forum I've
> > effectively had three working days since this was posted, and others
> > have probably had even less, i.e. lack of reviews on v6 isn't
> > because no one cares.
> 
> Hey, I'm still not back at work, and won't be for another week! But
> fair enough, if there is going to be a respin, I'd rather see that
> (and I'm less hung up on tests having been in -next for some time
> before sending out a PR that eventually reaches Linus).
> 
> > It's not the end of the world if we have to fix things up on top,
> > but we'd avoid a decent amount of churn if we can instead unwind and
> > do a v7.
> 
> No skin off my nose, as this leaves on its own topic branch. Now
> dropped.

Thank you both. Yes, this will make our lives easier (including getting
the changes internally).

Ricardo

> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
