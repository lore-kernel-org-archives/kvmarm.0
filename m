Return-Path: <SRS0=saMt=KH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69E24C433B4
	for <kvmarm@archiver.kernel.org>; Wed, 12 May 2021 21:39:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 93DDD613E9
	for <kvmarm@archiver.kernel.org>; Wed, 12 May 2021 21:39:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 93DDD613E9
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E1CA44B688;
	Wed, 12 May 2021 17:39:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id N1dHBBpGlR7B; Wed, 12 May 2021 17:39:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C9C2A4B473;
	Wed, 12 May 2021 17:39:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D11D4B473
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 17:39:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7MtH9f-U288M for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 May 2021 17:39:22 -0400 (EDT)
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com
 [209.85.214.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E82FC4B35B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 17:39:21 -0400 (EDT)
Received: by mail-pl1-f182.google.com with SMTP id h7so13263847plt.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 14:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=BNg4kTd5SLAMSl9nUrWUBRKEh5HkNeMUwgmskhslRNs=;
 b=U7AmCspc+NKI4McHAH1rudSMGLwK+I02SzQrYxMWAiD03kvkdOAM1bjgn46KPxtIAy
 zD7hDrzZZvhAJWgQnKTmLPLVtak7IjPvtS0dtSNfpCzPWYaBmlvoMKGNqgC2NIzOV7J4
 T/iXWp8YypJBLv+lM3ZvTrEFzhX7af77Sa/MZcuESFw6bRBb1wvxGJoRVEmqt6i/nh0n
 sWqBktxferE45AyQkNN77OTD69q4sgAmd33+wLp/7xDravzm26OJFh/6D/Q1/kgc6LXN
 gJnp+zatdO3UNrDnnJiXj7guH7XLt4Z7Q1ws3lJdxSpmHi06VhnjXzWCVspfXrNdd+Xj
 +QzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=BNg4kTd5SLAMSl9nUrWUBRKEh5HkNeMUwgmskhslRNs=;
 b=W6gyw2JVvg+N7Wy/85zyt9WpGEMJF4tWNQM7rzeK0vm1lKlVUfKJAbaPIVurEAePiW
 k3HlvWc2T5dGYGIE9hBBefVgoCwP8QYrxkCeV+QVUKZoi5saK3203xPKULfhdI/FoBmx
 xrEPYwgI/EgcJBw5O/rJTgPXa/6cjAeVxQpTHnWyM2SH3zL0cdh9orjFYvCzfv/ncbrs
 LiFHJ2NAnoKwdRSrPcedvBV5UMpp4T0R6KLnvGY3shS6GLHXMWyIVnR9m0NkrH3OhMNS
 Ndp3Yp2WjexC8X4baLraRhpyTK5ONeS2ph91xzTKDKgqt19mflyjIDmrqmXQZDQX8mv+
 e8xA==
X-Gm-Message-State: AOAM530FfR8k0P8pb8IF3LMmr/q30N1kaScIqfuDBftBEytZwHMM+Kmi
 zwwGB8x2WDRoQ9HvP+s0dUjDbA==
X-Google-Smtp-Source: ABdhPJxFIvIxMHoGwfDJlIWjrv0SaQjaHREE+5/7TMqB3FC4NhsGO+4TuRNCVHV6IB8C75ArwyXUNQ==
X-Received: by 2002:a17:902:32b:b029:ee:fa93:9551 with SMTP id
 40-20020a170902032bb02900eefa939551mr37200846pld.47.1620855560729; 
 Wed, 12 May 2021 14:39:20 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id ga1sm596064pjb.5.2021.05.12.14.39.19
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 12 May 2021 14:39:20 -0700 (PDT)
Date: Wed, 12 May 2021 14:39:16 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 4/5] KVM: selftests: Add exception handling support
 for aarch64
Message-ID: <YJxLBFBgM29hjtYN@google.com>
References: <20210430232408.2707420-1-ricarkol@google.com>
 <20210430232408.2707420-5-ricarkol@google.com>
 <87a6pcumyg.wl-maz@kernel.org> <YJBLFVoRmsehRJ1N@google.com>
 <20915a2f-d07c-2e61-3cce-ff385e98e796@redhat.com>
 <4f7f81f9-8da0-b4ef-49e2-7d87b5c23b15@huawei.com>
 <a5ad32abf4ff6f80764ee31f16a5e3fc@kernel.org>
 <YJv8NUtKilXPDYpY@google.com>
 <ad3fd18571983a08952f523ad5091360@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <ad3fd18571983a08952f523ad5091360@kernel.org>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
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

On Wed, May 12, 2021 at 05:18:42PM +0100, Marc Zyngier wrote:
> On 2021-05-12 17:03, Ricardo Koller wrote:
> > On Wed, May 12, 2021 at 02:43:28PM +0100, Marc Zyngier wrote:
> > > On 2021-05-12 13:59, Zenghui Yu wrote:
> > > > Hi Eric,
> > > >
> > > > On 2021/5/6 20:30, Auger Eric wrote:
> > > > > running the test on 5.12 I get
> > > > >
> > > > > ==== Test Assertion Failure ====
> > > > >   aarch64/debug-exceptions.c:232: false
> > > > >   pid=6477 tid=6477 errno=4 - Interrupted system call
> > > > >      1	0x000000000040147b: main at debug-exceptions.c:230
> > > > >      2	0x000003ff8aa60de3: ?? ??:0
> > > > >      3	0x0000000000401517: _start at :?
> > > > >   Failed guest assert: hw_bp_addr == PC(hw_bp) at
> > > > > aarch64/debug-exceptions.c:105
> > > > > 	values: 0, 0x401794
> > > >
> > > > FYI I can also reproduce it on my VHE box. And Drew's suggestion [*]
> > > > seemed to work for me. Is the ISB a requirement of architecture?
> > > 
> > > Very much so. Given that there is no context synchronisation (such as
> > > ERET or an interrupt) in this code, the CPU is perfectly allowed to
> > > delay the system register effect as long as it can.
> > > 
> > >         M.
> > > --
> > > Jazz is not dead. It just smells funny...
> > 
> > Thank you very much Eric, Zenghui, Marc, and Andrew (for the ISB
> > suggestion)!
> > 
> > As per Zenghui test, will send a V3 that includes the missing ISBs.
> > Hopefully that will fix the issue for Eric as well. It's very
> > interesting that the CPU seems to _always_ reorder those instructions.
> 
> I suspect that because hitting the debug registers can be a costly
> operation (it mobilises a lot of resources in the CPU), there is
> a strong incentive to let it slide until there is an actual mandate
> to commit the resource.
> 
> It also means that SW can issue a bunch of these without too much
> overhead, and only pay the cost *once*.
> 
> Your N1 CPU seems to be less aggressive on this. Implement choice,
> I'd say (it probably is more aggressive than TX2 on other things).
> Also, QEMU will almost always hide these problems, due to the nature
> of TCG.
> 
> Thanks,
> 
>          M.
> -- 
> Jazz is not dead. It just smells funny...

Thank you, this is very informative.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
