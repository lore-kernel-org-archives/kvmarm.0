Return-Path: <SRS0=81/H=MN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C24A0C636CA
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 12:20:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5A0186120F
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 12:20:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5A0186120F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0AC024B126;
	Wed, 21 Jul 2021 08:20:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JpPbYNncwUZv; Wed, 21 Jul 2021 08:20:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 285F74B142;
	Wed, 21 Jul 2021 08:20:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 26A084B114
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 04:48:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id W+dkx1HXKyru for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Jul 2021 04:47:59 -0400 (EDT)
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com
 [209.85.210.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 361A34B109
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 04:47:59 -0400 (EDT)
Received: by mail-pf1-f181.google.com with SMTP id c1so1676332pfc.13
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 01:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=FQYxugu8t7vqF745nuDd0P6UH3tWWI/YKaDa8xctYR4=;
 b=XU4l682naheW6tuKnH+MytrNWxbdp9Yxn32GC8utg8SR/VPsrXfeSXRbqRr2ldZE4B
 agGAumGKQbhn9UkIWNjFal/Uww+gAiAZu8Z3sjcQXOJaizdwTd05HLwGTXLiYmvvKoEM
 khZ1dzPT0dikZFlNKTmeXUrCafw53Wxs2a5eU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=FQYxugu8t7vqF745nuDd0P6UH3tWWI/YKaDa8xctYR4=;
 b=rlwker7tHSc/EI51aRZ0V8U69isJpUsgJGnK97m0EWuEz0u+pO4DBh1NeY1nBM1ZgK
 K7DOg8xzk1r5abmlfOTP5ouUKLG/NeJ4RbXk6nz5cqQajFSlhVtlNybGsp/qAr1ojz75
 0E+A1LPFVK+GzDFTn+wjMVrQ/4Ai4R1Uu3feOdRhjsxG1b6zC9l5SQBshPQ3FVvlCz/Q
 dAYF3ILXwH9DrXoNdIDqWRFw2AiOM+Dox+I9LYKkqg72sIocn0H8aFzn25F6gN9u6+xY
 b6mJ20xcOUdiYabcXAam368Am+s0uVWR6cp9Df9FtVtClPsVdFc7NX/IHPu+3+bQB478
 ktow==
X-Gm-Message-State: AOAM532UTcCHi3eywnEmSsylVoIsXh6NSNPzlSJtRFREtGlOa80tmwmW
 ta+QjptwDWuTOcmznuCsjQ/rrA==
X-Google-Smtp-Source: ABdhPJx2D4LSvi7V3G0rkeLs5yU/EesBkZYFpPqRMSteyEvOP3OhnjDDojnYkSbfYTT48DGn/kEOHg==
X-Received: by 2002:a63:4f21:: with SMTP id d33mr3274287pgb.144.1626857278147; 
 Wed, 21 Jul 2021 01:47:58 -0700 (PDT)
Received: from google.com ([2409:10:2e40:5100:f1b2:269f:996b:b71a])
 by smtp.gmail.com with ESMTPSA id b10sm25785133pfi.122.2021.07.21.01.47.55
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 21 Jul 2021 01:47:57 -0700 (PDT)
Date: Wed, 21 Jul 2021 17:47:52 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCHv2 2/4] arm64: add guest pvstate support
Message-ID: <YPffONafHdke/O3l@google.com>
References: <20210709043713.887098-1-senozhatsky@chromium.org>
 <20210709043713.887098-3-senozhatsky@chromium.org>
 <877dhv35ea.wl-maz@kernel.org> <YPeA5ReGSwBvWGSa@google.com>
 <87im142i0b.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87im142i0b.wl-maz@kernel.org>
X-Mailman-Approved-At: Wed, 21 Jul 2021 08:20:04 -0400
Cc: Joel Fernandes <joelaf@google.com>, linux-kernel@vger.kernel.org,
 virtualization@lists.linux-foundation.org,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Suleiman Souhlal <suleiman@google.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On (21/07/21 09:22), Marc Zyngier wrote:
> On Wed, 21 Jul 2021 03:05:25 +0100,
> Sergey Senozhatsky <senozhatsky@chromium.org> wrote:
> > 
> > On (21/07/12 16:42), Marc Zyngier wrote:
> > > > 
> > > > PV-vcpu-state is a per-CPU struct, which, for the time being,
> > > > holds boolean `preempted' vCPU state. During the startup,
> > > > given that host supports PV-state, each guest vCPU sends
> > > > a pointer to its per-CPU variable to the host as a payload
> > > 
> > > What is the expected memory type for this memory region? What is its
> > > life cycle? Where is it allocated from?
> > 
> > Guest per-CPU area, which physical addresses is shared with the
> > host.
> 
> Again: what are the memory types you expect this to be used with?

I heard your questions, I'm trying to figure out the answers now.

As of memory type - I presume you are talking about coherent vs
non-coherent memory. Can guest per-CPU memory be non-coherent? Guest
never writes anything to the region of memory it shares with the host,
it only reads what the host writes to it. All reads and writes are
done from CPU (no devices DMA access, etc).

Do we need any cache flushes/syncs in this case?

> When will the hypervisor ever stop accessing this?

KVM always access it for the vcpus that are getting scheduled out or
scheduled in on the host side.

> How does it work across reset?

I need to figure out what happens during reset/migration in the first
place.

> I'm sorry to be that pressing, but these are the gory details that
> actually matter if you want this thing to be maintainable.

Sure, no problem.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
