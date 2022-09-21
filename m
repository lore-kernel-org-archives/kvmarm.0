Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94C1DC6FA8B
	for <kvmarm@archiver.kernel.org>; Wed, 21 Sep 2022 03:53:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F0064B79B;
	Tue, 20 Sep 2022 23:53:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Z61bVWPZQvEC; Tue, 20 Sep 2022 23:53:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F82A40FAA;
	Tue, 20 Sep 2022 23:53:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E0004B269
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 23:53:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JfE6VRnDZQb2 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 23:53:28 -0400 (EDT)
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com
 [209.85.128.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E90894B630
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 23:53:27 -0400 (EDT)
Received: by mail-wm1-f45.google.com with SMTP id
 n35-20020a05600c502300b003b4924c6868so1677267wmr.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 20:53:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date;
 bh=YjNJwrSGGsmqwkos7/v8yu+we95EXK5+N0CYYMWfM9Q=;
 b=VN/89PxJc45yG4lc8yqdX46Pa4D79Mh+lXq0MdwtCoqk6H+vPb0LYEGHxXxS0OAM1+
 7RmnF/LUaYOBG1W3DFvw8Lkn5MpRYPZwJLvhEs7ruA2GSOv3b2YvH7hUZOHrdR2zbEiA
 yTfU1+O3beASWzV4c0GeNLj05YiKbgIKYNkV+PJcuPE4wxVo2TXv9YZLiaatDHLgtpmQ
 GON/Vu3+5/D77WWTrzPWPFcpgy4Ornyxr7/HX/qmrufG41d4inNUeDdtVhrlLoQr110w
 hcvpstlAuApR4OeGLmxuVIaGhkDR6bTDnFFtUPIHaLmqLZtxkutVbKpmn2u0NjMB7wPB
 vOug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date;
 bh=YjNJwrSGGsmqwkos7/v8yu+we95EXK5+N0CYYMWfM9Q=;
 b=UyaPVn06G3/DAssFqp6tteGsgg6HPiSXx9Hx2tKW8jDXYVsSEoAO2yS1wBtRgBBS+B
 BJX+5pA0iheKKjmKkcXrujAzPDNWnwgomZkIpUtNf27wSgoC2fX/oRIs2r/NG9L69lp9
 GycJlyMi6Py/CIIvo1W7NkLXRcoehwhzknnMljtOHV0HRK5ZBf1wdv3D0aLAzwI6coFY
 3pN+OhmCxMgbvCxikTQQwfikFlsFoMWE+r++WI0qm6MwDvGddsfiU+9vOm6cASZQ+/4e
 RzWH+XhRjUgJjDxPUWk74gWtQmvO6+bPi/wGMK0HkGiPMC3G6iiUBN6ICf8vy/JEJNrK
 LkzQ==
X-Gm-Message-State: ACrzQf0TNVtMlfq8vhTodNjnkD58e89UN9gIaveQ9jmlqUwAmMz0EGY/
 4pJoH4dJHvC4YrWOgu/Tand1ian3RmxoXVSmlwQDYQ==
X-Google-Smtp-Source: AMsMyM4SOMzNPoEP4Br6h1r2CJRQYNKipv9r9MWilIR/DuJ8W+mBmmO97KOemPkCF+KRZPoaDKwtz/8KvAWwatKO7qo=
X-Received: by 2002:a05:600c:2202:b0:3b4:6189:fc6a with SMTP id
 z2-20020a05600c220200b003b46189fc6amr4451007wml.171.1663732406891; Tue, 20
 Sep 2022 20:53:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220810193033.1090251-4-pcc@google.com>
 <202208111500.62e0Bl2l-lkp@intel.com>
 <YxDy+zFasbAP7Yrq@arm.com> <YxYrgyybBMUqFswq@arm.com>
 <878rmfkzbu.wl-maz@kernel.org>
 <Yynewxzc6Zy8ls0N@arm.com> <871qs6kntl.wl-maz@kernel.org>
 <YynxJYrd15aUJsmp@arm.com>
In-Reply-To: <YynxJYrd15aUJsmp@arm.com>
From: Peter Collingbourne <pcc@google.com>
Date: Tue, 20 Sep 2022 20:53:15 -0700
Message-ID: <CAMn1gO6vhf=xaHreysfwrunAAmV8OwxxtA9qOP0Bq+TkjrJQJg@mail.gmail.com>
Subject: Re: [PATCH v3 3/7] mm: Add PG_arch_3 page flag
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: kbuild-all@lists.01.org, kernel test robot <lkp@intel.com>,
 kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Cornelia Huck <cohuck@redhat.com>, Steven Price <steven.price@arm.com>,
 Evgenii Stepanov <eugenis@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Linux ARM <linux-arm-kernel@lists.infradead.org>
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

On Tue, Sep 20, 2022 at 9:58 AM Catalin Marinas <catalin.marinas@arm.com> wrote:
>
> On Tue, Sep 20, 2022 at 05:33:42PM +0100, Marc Zyngier wrote:
> > On Tue, 20 Sep 2022 16:39:47 +0100,
> > Catalin Marinas <catalin.marinas@arm.com> wrote:
> > > On Mon, Sep 19, 2022 at 07:12:53PM +0100, Marc Zyngier wrote:
> > > > On Mon, 05 Sep 2022 18:01:55 +0100,
> > > > Catalin Marinas <catalin.marinas@arm.com> wrote:
> > > > > Peter, please let me know if you want to pick this series up together
> > > > > with your other KVM patches. Otherwise I can post it separately, it's
> > > > > worth merging it on its own as it clarifies the page flag vs tag setting
> > > > > ordering.
> > > >
> > > > I'm looking at queuing this, but I'm confused by this comment. Do I
> > > > need to pick this as part of the series? Or is this an independent
> > > > thing (my hunch is that it is actually required not to break other
> > > > architectures...).
> > >
> > > This series series (at least the first patches) won't apply cleanly on
> > > top of 6.0-rc1 and, of course, we shouldn't break other architectures. I
> > > can repost the whole series but I don't have the setup to test the
> > > MAP_SHARED KVM option (unless Peter plans to post it soon).
> >
> > I don't feel brave enough to take a series affecting all architectures
>
> It shouldn't affect the others, the only change is that PG_arch_2 is now
> only defined for arm64 but no other architecture is using it. The
> problem with loongarch is that it doesn't have enough spare bits in
> page->flags and even without any patches I think it's broken with the
> right value for NR_CPUS.
>
> > so late in the game, and the whole thing had very little arm64
> > exposure. The latest QEMU doesn't seem to work anymore, so I don't
> > have any MTE-capable emulation (and using the FVP remotely is a pain
> > in the proverbial neck).
> >
> > I'll come back to this after the merge window, should Peter decide to
> > respin the series.
>
> It makes sense.

Apologies for the delay, I've now sent out v4 of this series which
includes the patches on your branch.

Peter
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
