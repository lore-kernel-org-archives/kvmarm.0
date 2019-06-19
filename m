Return-Path: <SRS0=0dlf=US=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BF27C31E49
	for <kvmarm@archiver.kernel.org>; Wed, 19 Jun 2019 12:18:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E7058214AF
	for <kvmarm@archiver.kernel.org>; Wed, 19 Jun 2019 12:18:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZMiqI8mC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E7058214AF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C035C4A4E5;
	Wed, 19 Jun 2019 08:18:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hZHGmmdZYIlV; Wed, 19 Jun 2019 08:18:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E84D44A4BE;
	Wed, 19 Jun 2019 08:18:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC3D14A4BE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Jun 2019 08:18:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IFC4GQiXbi8L for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Jun 2019 08:18:18 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8CBFF4A3B4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Jun 2019 08:18:18 -0400 (EDT)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com
 [209.85.221.42])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 4B2FF21783
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Jun 2019 12:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1560946697;
 bh=yhxv7AgwzvhlNQSVBLS6wZ1SselhU4cEOOFs1fJpxDY=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=ZMiqI8mCi4evJQcYbolWFw0wyCpQPmy2G+Hb5PKLNhNmRtNecRI+6q89w5OJsc8qc
 0uIZ37uH9jzLWnIN0Amvcwyx6Uh8a3/6gfMVMF3B6gI70L1a/+0tTyniMwP/Zdbra7
 V9JB0No19qxSDpgkuWn3j35uD4TnLbqjkoH21P3E=
Received: by mail-wr1-f42.google.com with SMTP id x4so3142556wrt.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Jun 2019 05:18:17 -0700 (PDT)
X-Gm-Message-State: APjAAAW7/8nGmIpvRP8MUzgrSjV1mXOheIL9eRgHMKJ6J1Wa5Q/iyMGY
 SqstaeoICS2ZnAmOOqXQYYomsTFg+Li3IbHCVfo=
X-Google-Smtp-Source: APXvYqxLToImvuhSDmD1nIS+ES6oreQ4KIoRUvyJ5x3WUN76K0k7xm92MrDOXh+M6q9Y86BgYAoCufZoBHRQw/MmFGQ=
X-Received: by 2002:adf:9bd3:: with SMTP id e19mr8408054wrc.38.1560946695784; 
 Wed, 19 Jun 2019 05:18:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190321163623.20219-1-julien.grall@arm.com>
 <20190321163623.20219-12-julien.grall@arm.com>
 <0dfe120b-066a-2ac8-13bc-3f5a29e2caa3@arm.com>
 <CAJF2gTTXHHgDboaexdHA284y6kNZVSjLis5-Q2rDnXCxr4RSmA@mail.gmail.com>
 <c871a5ae-914f-a8bb-9474-1dcfec5d45bf@arm.com>
 <20190619091219.GB7767@fuggles.cambridge.arm.com>
In-Reply-To: <20190619091219.GB7767@fuggles.cambridge.arm.com>
From: Guo Ren <guoren@kernel.org>
Date: Wed, 19 Jun 2019 20:18:04 +0800
X-Gmail-Original-Message-ID: <CAJF2gTTmFq3yYa9UrdZRAFwJgC=KmKTe2_NFy_UZBUQovqQJPg@mail.gmail.com>
Message-ID: <CAJF2gTTmFq3yYa9UrdZRAFwJgC=KmKTe2_NFy_UZBUQovqQJPg@mail.gmail.com>
Subject: Re: [PATCH RFC 11/14] arm64: Move the ASID allocator code in a
 separate file
To: Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>
Cc: aou@eecs.berkeley.edu, Marc Zyngier <marc.zyngier@arm.com>,
 catalin.marinas@arm.com, Anup Patel <anup.Patel@wdc.com>,
 linux-kernel@vger.kernel.org, rppt@linux.ibm.com, hch@infradead.org,
 Atish.Patra@wdc.com, Julien Grall <julien.grall@arm.com>,
 Palmer Dabbelt <palmer@sifive.com>, gary@garyguo.net, paul.walmsley@sifive.com,
 linux-riscv@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
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

On Wed, Jun 19, 2019 at 5:12 PM Will Deacon <will.deacon@arm.com> wrote:
>
> On Wed, Jun 19, 2019 at 09:54:21AM +0100, Julien Grall wrote:
> > On 6/19/19 9:07 AM, Guo Ren wrote:
> > > You forgot CCing C-SKY folks :P
> >
> > I wasn't aware you could be interested :).
> >
> > > Move arm asid allocator code in a generic one is a agood idea, I've
> > > made a patchset for C-SKY and test is on processing, See:
> > > https://lore.kernel.org/linux-csky/1560930553-26502-1-git-send-email-guoren@kernel.org/
> > >
> > > If you plan to seperate it into generic one, I could co-work with you.
> >
> > Was the ASID allocator work out of box on C-Sky? If so, I can easily move
> > the code in a generic place (maybe lib/asid.c).
>
> This is one place where I'd actually prefer not to go down the route of
> making the code generic. Context-switching and low-level TLB management
> is deeply architecture-specific and I worry that by trying to make this
> code common, we run the real risk of introducing subtle bugs on some
> architecture every time it is changed.
"Add generic asid code" and "move arm's into generic" are two things.
We could do
first and let architecture's maintainer to choose.

> Furthermore, the algorithm we use
> on arm64 is designed to scale to large systems using DVM and may well be
> too complex and/or sub-optimal for architectures with different system
> topologies or TLB invalidation mechanisms.
It's just a asid algorithm not very complex and there is a callback
for architecture to define their
own local hart tlb flush. Seems it has nothing with DVM or tlb
broadcast mechanism.

>
> It's not a lot of code, so I don't see that it's a big deal to keep it
> under arch/arm64.
Yes, I think that's ok for arm64.

Hi Arnd,
What do you think about adding generic asid code for arch selection?

Best Regards
 Guo Ren
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
