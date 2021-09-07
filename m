Return-Path: <SRS0=lhJk=N5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72A1FC433FE
	for <kvmarm@archiver.kernel.org>; Tue,  7 Sep 2021 18:26:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E9941610A3
	for <kvmarm@archiver.kernel.org>; Tue,  7 Sep 2021 18:26:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E9941610A3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FD6C4B0C5;
	Tue,  7 Sep 2021 14:26:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0O4ra6R6qLNf; Tue,  7 Sep 2021 14:26:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 62AEB4B0CD;
	Tue,  7 Sep 2021 14:26:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C522F4B0C5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Sep 2021 14:26:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZhZDB3Y-k0Ul for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Sep 2021 14:26:14 -0400 (EDT)
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com
 [209.85.128.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D265D4B0C3
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Sep 2021 14:26:13 -0400 (EDT)
Received: by mail-wm1-f53.google.com with SMTP id
 u19-20020a7bc053000000b002f8d045b2caso28206wmc.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Sep 2021 11:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=FhXgO4soHUfxUZvgfxgTnbg0Q339mdYzMA/DtCHulwM=;
 b=XujAKCsnSv1SoIEqIFBQX0tSV/UFdURbpRl6b/A2AzaV6EgVVpRy4fvqRJVNkfktOX
 XgjoLQtKKvIP1kxEyMRpoFzl4pPsgCNTm6Maus1bw1cg4j7VovCDgC3FeuTGZa6Q8P6Z
 7rnnb6gVceVdPykWLjsC8x4JFbHsqMK9HqkgsmK1F1AuHUxmTZuOYPrn1iKWo37teFlf
 XyNBkiSk1IDWaMvYWR6D2aoS9EWu25NKX0eSuR1FAqWNn3zM+4SMFeOLiaWQSQcOVheA
 oOlcrn9LQGeM+m4Y2PQ8vztisubnmJ3/mvJFjxngs4HaqH69lQlE3bXs7fb5qn4z7xoq
 7WzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=FhXgO4soHUfxUZvgfxgTnbg0Q339mdYzMA/DtCHulwM=;
 b=Uh24QziJS39WLqJ8id/xGneZVMDsg4DGGQ0IYJMGkCUPAtC/+IqbRKhP2EUpNzFadf
 q463xng76G0SlZtCwy8I9+cTDltStQDaXDzULgB1N5oq8yx9sixVAxprwfs5+dVac2Sa
 qYO1k1xGiINpr7H+8hIHKrEs/vE+RHIdf8TiRiw7dCpo7114u8jM6qEvDz2GBo8PhKit
 LWLqTLTIQGZG7Jj1JWTTV/m39sXdn1N9DmZABsWi5LUb8QojmhSKGmknro2PRu22cX0T
 eIWUFWekn/ILgACPLSRCAkyZ21gX3DL2dWNsCzJKXiqV6CcTlXSxSlBsQH9eA8C0r5ae
 yRWg==
X-Gm-Message-State: AOAM532rMdoDUUeQypmJgMFc4ceTuUv4eWqM/YK2SpjP4nm8CHUeUXdp
 3yH5x429wsm8YgREWO1sqcSt+3kVyhBCRhM8RHehqA==
X-Google-Smtp-Source: ABdhPJwMBtgoNU1DNZ3wjpbNoTr8qYBDuvceJ9eIxrnJpE3hgXpGIxe2N2Hyd1ZrAxjAa2aJTCxvA5d0Q8jsAy15RLE=
X-Received: by 2002:a05:600c:19d0:: with SMTP id
 u16mr5288352wmq.21.1631039172877; 
 Tue, 07 Sep 2021 11:26:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210822144441.1290891-1-maz@kernel.org>
 <20210822144441.1290891-4-maz@kernel.org>
 <CAFEAcA_J5W6kaaZ-oYtcRcQ5=z5nFv6bOVVu5n_ad0N8-NGzpg@mail.gmail.com>
 <87bl54cnx5.wl-maz@kernel.org>
In-Reply-To: <87bl54cnx5.wl-maz@kernel.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 7 Sep 2021 19:25:23 +0100
Message-ID: <CAFEAcA_MRyd2AcgAhvEwJY8LGbHoyz_JgTdMGAEtGegvZB0d7A@mail.gmail.com>
Subject: Re: [PATCH 3/3] docs/system/arm/virt: Fix documentation for the
 'highmem' option
To: Marc Zyngier <maz@kernel.org>
Cc: kvm-devel <kvm@vger.kernel.org>, QEMU Developers <qemu-devel@nongnu.org>,
 Android Kernel Team <kernel-team@android.com>,
 kvmarm <kvmarm@lists.cs.columbia.edu>
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

On Tue, 7 Sept 2021 at 18:10, Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Peter,
>
> On Tue, 07 Sep 2021 13:51:13 +0100,
> Peter Maydell <peter.maydell@linaro.org> wrote:
> >
> > On Sun, 22 Aug 2021 at 15:45, Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > The documentation for the 'highmem' option indicates that it controls
> > > the placement of both devices and RAM. The actual behaviour of QEMU
> > > seems to be that RAM is allowed to go beyond the 4GiB limit, and
> > > that only devices are constraint by this option.
> > >
> > > Align the documentation with the actual behaviour.
> >
> > I think it would be better to align the behaviour with the documentation.
> >
> > The intent of 'highmem' is to allow a configuration for use with guests
> > that can't address more than 32 bits (originally, 32-bit guests without
> > LPAE support compiled in). It seems like a bug that we allow the user
> > to specify more RAM than will fit into that 32-bit range. We should
> > instead make QEMU exit with an error if the user tries to specify
> > both highmem=off and a memory size that's too big to fit.
>
> I'm happy to address this if you are OK with the change in user
> visible behaviour.
>
> However, I am still struggling with my original goal, which is to
> allow QEMU to create a usable KVM_based VM on systems with a small IPA
> space (36 bits on the system I have). What would an acceptable way to
> convey this to the code that deals with the virt memory map so that it
> falls back to something that actually works?

Hmm, so at the moment we can either do "fits in 32 bits" or
"assumes at least 40 bits" but not 36 ?

thanks
-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
