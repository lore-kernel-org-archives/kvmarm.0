Return-Path: <SRS0=/m9d=NY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82A7BC433F5
	for <kvmarm@archiver.kernel.org>; Thu,  2 Sep 2021 17:55:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0BCF3610E5
	for <kvmarm@archiver.kernel.org>; Thu,  2 Sep 2021 17:55:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0BCF3610E5
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D8F24B0BF;
	Thu,  2 Sep 2021 13:55:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RUYdpwKpII7v; Thu,  2 Sep 2021 13:55:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 560BA4B0DD;
	Thu,  2 Sep 2021 13:55:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 755964B0BF
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Sep 2021 13:55:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xeDhFdFEXik9 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Sep 2021 13:55:19 -0400 (EDT)
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com
 [209.85.219.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 790864B0BA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Sep 2021 13:55:19 -0400 (EDT)
Received: by mail-yb1-f181.google.com with SMTP id z5so5490915ybj.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Sep 2021 10:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=gqxRE7kir7W0L8sbl3qxABrwWx/ImNi+hvYh+LGW41A=;
 b=cv9zdd1oi04eIr1gf7nRpzyMmnd2MFSg9K1LzVavTuRHOmcg94Y/OCdNFhlu8mz9xI
 oKwwTN71H2su8FeDC+5CjPNWW2dx1NeBB9PbWwtccN50LjfaiAYpRGr0Ktf0ocOj7pEc
 affqCVcuKVaXYBJZjI3dCdsWOzLl3UrUXHbrsmA3LZZ3W/ofMk0Fr8JJhlUL9286/lnE
 XGyK3RURH0w0A4PQaU5s8EqiyDQ9sOy9CTYyYXy5LIIaa5qXylR2Df1Ac854OuYRjUvh
 PoyzOpVUq7CiEfefE0vfqTjSVfZBzMW6vJinsJ9Og1Nw/ERoRneAoNly1w5levpfnQOu
 J1bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=gqxRE7kir7W0L8sbl3qxABrwWx/ImNi+hvYh+LGW41A=;
 b=JGy9fm82MXv3eazkjrcVp3vNujlkiuD1nZl4epV8ikEuog+Gr5EqgbomrscVhL6Aan
 dSetr8ImiMiTglxaesfymVFeOcpUeXki2EUDEj7hik4nZ+p/sSBtLuwXvTkcHmjauTC9
 mbiPDraYj+yAL4Gi6oHBhpIcyP34CdBNPLBUWYhxf71UyG0cBQRzNK8DxXOWXQbHFU6E
 szBKH+tz0GwL0XKXFIQHqH4eLB21QdPSK8AQbAfHbfOlfEIacLMWe0utN2TgRY6afsP6
 nOX4HwtIzt8uxfyHDCO0G7M2Ja0kwYZPK+03vqM/8E3OBErv/mpDALXKBe0HN3dvpnFk
 vfMg==
X-Gm-Message-State: AOAM533SvjY70R27Fnfkx7RWllj/+4tsKCcIxcm+xzTORFMJFSSI1Wgn
 2iHU48RS+eQRSGJYApdO6kJ5NQq+x+xV+RkPEhxJfg==
X-Google-Smtp-Source: ABdhPJwUZwqrwOekpIYyTz0pzYA+LEPg2QXTbJ63dba3PQAQ8pp85mpwvFE+9uO8Y0Cnfe82N+/p5oaHg8isCinoM0E=
X-Received: by 2002:a05:6902:513:: with SMTP id
 x19mr5997339ybs.90.1630605318839; 
 Thu, 02 Sep 2021 10:55:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210901211412.4171835-1-rananta@google.com>
 <20210901211412.4171835-3-rananta@google.com>
 <YS/wfBTnCJWn05Kn@google.com> <YS/53N7LdJOgdzNu@google.com>
 <CAJHc60xU3XvmkBHoB8ihyjy6k4RJ9dhqt31ytHDGjd5xsaJjFA@mail.gmail.com>
 <YTAHYrQslkY12715@google.com> <20210902123110.royrzw4dsykkrcjx@gator>
In-Reply-To: <20210902123110.royrzw4dsykkrcjx@gator>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Thu, 2 Sep 2021 10:55:08 -0700
Message-ID: <CAJHc60xLj77n3pvqQNn_+LoLL=UZtQV+hz3r4VmPpqpZ7SBPVg@mail.gmail.com>
Subject: Re: [PATCH v3 02/12] KVM: arm64: selftests: Add write_sysreg_s and
 read_sysreg_s
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

On Thu, Sep 2, 2021 at 5:31 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Wed, Sep 01, 2021 at 11:06:10PM +0000, Oliver Upton wrote:
> > On Wed, Sep 01, 2021 at 03:48:40PM -0700, Raghavendra Rao Ananta wrote:
> > > On Wed, Sep 1, 2021 at 3:08 PM Oliver Upton <oupton@google.com> wrote:
> > > >
> > > > On Wed, Sep 01, 2021 at 09:28:28PM +0000, Oliver Upton wrote:
> > > > > On Wed, Sep 01, 2021 at 09:14:02PM +0000, Raghavendra Rao Ananta wrote:
> > > > > > For register names that are unsupported by the assembler or the ones
> > > > > > without architectural names, add the macros write_sysreg_s and
> > > > > > read_sysreg_s to support them.
> > > > > >
> > > > > > The functionality is derived from kvm-unit-tests and kernel's
> > > > > > arch/arm64/include/asm/sysreg.h.
> > > > > >
> > > > > > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > > > >
> > > > > Would it be possible to just include <asm/sysreg.h>? See
> > > > > tools/arch/arm64/include/asm/sysreg.h
> > > >
> > > > Geez, sorry for the noise. I mistakenly searched from the root of my
> > > > repository, not the tools/ directory.
> > > >
> > > No worries :)
> > >
> > > > In any case, you could perhaps just drop the kernel header there just to
> > > > use the exact same source for kernel and selftest.
> > > >
> > > You mean just copy/paste the entire header? There's a lot of stuff in
> > > there which we
> > > don't need it (yet).
> >
> > Right. It's mostly register definitions, which I don't think is too high
> > of an overhead. Don't know where others stand, but I would prefer a
> > header that is equivalent between kernel & selftests over a concise
> > header.
> >
>
> Until now we haven't needed the sys_reg(...) type of definitions for
> sysregs in selftests. In case we did, we defined the registers we
> needed for get/set_one_reg by their parts, e.g.
>
>  #define ID_AA64DFR0_EL1 3, 0,  0, 5, 0
>
> allowing us to choose how we use them, ARM64_SYS_REG(...) vs.
> sys_reg(...).
>
> Bringing over sysreg.h is probably a good idea though. If we do, then
> I'd suggest we define a new macro that allows us to convert a SYS_*
> register definition from sysreg.h into an ARM64_SYS_REG definition
> for get/set_one_reg in order to avoid redundant definitions.
>

I agree. Will look into it, and plan to pull the original sysreg.h
into selftests.

Regards,
Raghavendra

> Thanks,
> drew
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
