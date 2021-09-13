Return-Path: <SRS0=oqs1=OD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1714BC433F5
	for <kvmarm@archiver.kernel.org>; Mon, 13 Sep 2021 23:38:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 74C3A610A2
	for <kvmarm@archiver.kernel.org>; Mon, 13 Sep 2021 23:38:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 74C3A610A2
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 042414B126;
	Mon, 13 Sep 2021 19:38:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id g4uNjWczL5jY; Mon, 13 Sep 2021 19:38:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1733D4B149;
	Mon, 13 Sep 2021 19:38:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 37CCA4B10C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 19:38:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 666DJbjxBGTu for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Sep 2021 19:38:41 -0400 (EDT)
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com
 [209.85.219.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3D2764B105
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 19:38:41 -0400 (EDT)
Received: by mail-yb1-f175.google.com with SMTP id a93so24073760ybi.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 16:38:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=cI/jeOU5rLR8X7WtxXOWaAngNhFiIOuHbXY1aDDYGos=;
 b=NMKR01fsDjOL/bSL+r00xqJRi+mMiSl6JTC0z4v6w6pafJlzwWUnP9WNprle1mMKN9
 SqkKP2t1CC3hqLN22VyYmhvfvyeQ/qxBgsK11LfqIg5zqIVMWuOlE5MUxuoWgXZTpy75
 iRBbB0FA/hVDjM0PJ+UlOyXWs7eZ+8A69OKeK/yvuqzJaHhr9Y6cSKKsP0w2vbJWVgEM
 kODN4pbGHgOQvBD0z3e1EqPUFVe3dZm5XhkbS+sKKxEjVVyOeJUiOOzetIKdzPA4/wH7
 O/R5G0yjVzvkn4sEUZGCmkl0ghblpGpJcVyQ55ahS529cEpnW5uYibER5FPC2dokxqeC
 O4Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=cI/jeOU5rLR8X7WtxXOWaAngNhFiIOuHbXY1aDDYGos=;
 b=u0lTg/QCcc8uDOS9iw7lVjcQgUQGSdodOpo0waOmZJkkwwi9s0EXSwV2fynpTLOMty
 mEMxgkpfOgdgkrmutImCv1AnkF3AsNHWqDbv7+pvnQy8aqmuAkWFUZn75FBV/2cxUcZP
 Vz7+f9Tt2nA02byYv42LPz97XBegabnmwtK2DgQpBeJo9s1VLR1p3Ri0V0weqgn3T4Wb
 hUhktakgPyvhNBmuic2hhSIHJTDqfVui5MfIn+1XY0EcuEEz7Wfqz5UgiEKYFQFBXsk/
 uOQ6v0ZLok8m4g3Tcumtz5hku73YAvFZHDSdBiiOmtx+myJYQ2YCUnybnCOocdhZJqLn
 YyjQ==
X-Gm-Message-State: AOAM531IG6ie8qsL4BhbGlqwubT0LULHy7NuLbqlp5Z5Q9YuqjVze/VT
 gOLZuiTe3rgifD0GYrthNbl+wZS3FqbrS2O9hyA55w==
X-Google-Smtp-Source: ABdhPJzT+O8be5cYSNBVl8s3QC+2tzsAf4DvhR8OYgF/hCrLtsSWXEIW0OmXr/C1MdplAnMcBhEp35bF6USETxVCWHc=
X-Received: by 2002:a25:ab44:: with SMTP id u62mr18518702ybi.335.1631576320503; 
 Mon, 13 Sep 2021 16:38:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210909013818.1191270-1-rananta@google.com>
 <20210909013818.1191270-3-rananta@google.com>
 <20210909171755.GF5176@sirena.org.uk>
 <CAJHc60yJ6621=TezncgsMR+DdYxzXY1oF-QLeARwq8HowH6sVQ@mail.gmail.com>
 <20210910083011.GA4474@sirena.org.uk>
In-Reply-To: <20210910083011.GA4474@sirena.org.uk>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Mon, 13 Sep 2021 16:38:29 -0700
Message-ID: <CAJHc60z0kLzrA3FfQeD0RFZE-PscnDsxxqkVwzcNFcCkf_FRPw@mail.gmail.com>
Subject: Re: [PATCH v4 02/18] KVM: arm64: selftests: Add sysreg.h
To: Mark Brown <broonie@kernel.org>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Fri, Sep 10, 2021 at 1:30 AM Mark Brown <broonie@kernel.org> wrote:
>
> On Thu, Sep 09, 2021 at 01:06:31PM -0700, Raghavendra Rao Ananta wrote:
> > On Thu, Sep 9, 2021 at 10:18 AM Mark Brown <broonie@kernel.org> wrote:
>
> > > >  create mode 100644 tools/testing/selftests/kvm/include/aarch64/sysreg.h
>
> > > Can we arrange to copy this at build time rather than having a duplicate
> > > copy we need to keep in sync?  We have some stuff to do this for uapi
> > > headers already.
>
> > That's a great idea actually (I wasn't aware of it). But, probably
> > should've mentioned it earlier, I had a hard time compiling the header
> > as is so I modified it a little bit and made the definitions of
> > [write|read]_sysreg_s() similar to the ones in kvm-unit-tests.
> > I'll try my best to get the original format working and try to
> > implement your idea if it works.
>
> One option would be to do something like split out the bits that can be
> shared into a separate header which can be included from both places and
> then have the header with the unsharable bits include that.  Something
> like sysreg.h and sysreg_defs.h for example.

Hi Mark,

Thanks again for your suggestion. As of v6 of the series, the original
header from the kernel seems to be working as is, so there's no need
to split it anymore.
However, I'll plan to incorporate your suggestion as a separate
series, if it's okay :)

I was looking into this though and could only find some utilities such
as tools/iio/, tools/spi/, and so on, which seem to create a symbolic
link to the header present in the kernel (rather than copying). Is
this what you were referring to?

Regards,
Raghavendra
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
