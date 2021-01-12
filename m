Return-Path: <SRS0=ZMJ6=GP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EF36C433E0
	for <kvmarm@archiver.kernel.org>; Tue, 12 Jan 2021 18:34:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 24B632076E
	for <kvmarm@archiver.kernel.org>; Tue, 12 Jan 2021 18:34:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 24B632076E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B12B64B1CE;
	Tue, 12 Jan 2021 13:34:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id athigfZVR-aS; Tue, 12 Jan 2021 13:34:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F2D54B229;
	Tue, 12 Jan 2021 13:34:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B7584B212
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jan 2021 11:46:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XVLrVvihqh3k for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Jan 2021 11:46:12 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CE9A14B1CC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jan 2021 11:46:11 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7539923110
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jan 2021 16:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1610469970;
 bh=G8QgmioLPowngS9PnWyS0qJ4GW5plz/qHFNOJiaPmLM=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=utv8poqFkjEP20anauzkLWewiDee9vsGsy6vyLsmr3EPv7IlXm1g/fNO0INTpvRm1
 v2PgImEiKX8ztyABczzpBOEhbzIyaJpAccHLb8IFEW20WPjtZQFRKzdvQh24GDVYXF
 QuOrbf+4HF22PlWuAsAGgo7uxImKpfLnfNIMp63kcHLBVpAqkMg0JoW9xDlto6ZL4f
 dr9likG3mnT/AFbPWPkR+C/qxNxQ4CLS9lsSaOTfi0RyVGFDEGYp/mFrN3GUXVI+tz
 CVbb5KMFAirL9ETDQiHejG2L/6L62nC5eHgxduPHFT6jesN0HpHTDuzM+nFwhw3rRt
 6dDhJZqR7ju3A==
Received: by mail-ej1-f46.google.com with SMTP id b9so4498024ejy.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jan 2021 08:46:10 -0800 (PST)
X-Gm-Message-State: AOAM532OG7si3KtRR2d+Ys+HVNzRdn9dNZh0YyWxG4+Jsx7xLdJJtTa1
 DKCupEzTSDGonxIBtsK8nrPzxcGPXR4IK4PiUQ==
X-Google-Smtp-Source: ABdhPJwpatqtscFinSdtYUrvRElGEmeizOIFHtAttZVKAEASK6GUt12WCxKJxKuZKsgMiopOcpPvL1kPhiZ1kgVNx0g=
X-Received: by 2002:a17:906:ae43:: with SMTP id
 lf3mr3526825ejb.130.1610469968932; 
 Tue, 12 Jan 2021 08:46:08 -0800 (PST)
MIME-Version: 1.0
References: <20210108121524.656872-1-qperret@google.com>
 <20210108121524.656872-16-qperret@google.com>
 <CAL_JsqLmzFWmTc=6JSRMofSEVRx9GCrwGxEsYog9dC16EMGdvQ@mail.gmail.com>
 <X/1xN2UxiUxkzAiN@google.com>
 <CAL_Jsq+5d+Ox_-m_Rd83R9xoZb6e2cxCNfbL8YPzKdwj=y0M8Q@mail.gmail.com>
 <X/2xlxx9Ucp4UZvL@google.com>
 <CAL_Jsq+o+t4YYXEW_nYqMsT4ubYJWe6Kdhu614RtrCqsHBtfLw@mail.gmail.com>
 <X/3LIGgx83XJ+U0F@google.com>
In-Reply-To: <X/3LIGgx83XJ+U0F@google.com>
From: Rob Herring <robh+dt@kernel.org>
Date: Tue, 12 Jan 2021 10:45:56 -0600
X-Gmail-Original-Message-ID: <CAL_Jsq+SeOrn4qFyFuPUmXdnM1oMNMLWLsDzrYgUt9Ts3hyoNg@mail.gmail.com>
Message-ID: <CAL_Jsq+SeOrn4qFyFuPUmXdnM1oMNMLWLsDzrYgUt9Ts3hyoNg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 15/26] of/fdt: Introduce
 early_init_dt_add_memory_hyp()
To: Quentin Perret <qperret@google.com>
X-Mailman-Approved-At: Tue, 12 Jan 2021 13:34:20 -0500
Cc: devicetree@vger.kernel.org, Android Kernel Team <kernel-team@android.com>,
 Frank Rowand <frowand.list@gmail.com>, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>, Fuad Tabba <tabba@google.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>
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

On Tue, Jan 12, 2021 at 10:15 AM Quentin Perret <qperret@google.com> wrote:
>
> On Tuesday 12 Jan 2021 at 09:53:36 (-0600), Rob Herring wrote:
> > On Tue, Jan 12, 2021 at 8:26 AM Quentin Perret <qperret@google.com> wrote:
> > >
> > > On Tuesday 12 Jan 2021 at 08:10:47 (-0600), Rob Herring wrote:
> > > > On Tue, Jan 12, 2021 at 3:51 AM Quentin Perret <qperret@google.com> wrote:
> > > > >
> > > > > On Monday 11 Jan 2021 at 08:45:10 (-0600), Rob Herring wrote:
> > > > > > On Fri, Jan 8, 2021 at 6:16 AM Quentin Perret <qperret@google.com> wrote:
> > > > > > >
> > > > > > > Introduce early_init_dt_add_memory_hyp() to allow KVM to conserve a copy
> > > > > > > of the memory regions parsed from DT. This will be needed in the context
> > > > > > > of the protected nVHE feature of KVM/arm64 where the code running at EL2
> > > > > > > will be cleanly separated from the host kernel during boot, and will
> > > > > > > need its own representation of memory.
> > > > > >
> > > > > > What happened to doing this with memblock?
> > > > >
> > > > > I gave it a go, but as mentioned in v1, I ran into issues for nomap
> > > > > regions. I want the hypervisor to know about these memory regions (it's
> > > > > possible some of those will be given to protected guests for instance)
> > > > > but these seem to be entirely removed from the memblocks when using DT:
> > > > >
> > > > > https://elixir.bootlin.com/linux/latest/source/drivers/of/fdt.c#L1153
> > > > >
> > > > > EFI appears to do things differently, though, as it 'just' uses
> > > > > memblock_mark_nomap() instead of actively removing the memblock. And that
> > > > > means I could actually use the memblock API for EFI, but I'd rather
> > > > > have a common solution. I tried to understand why things are done
> > > > > differently but couldn't find an answer and kept things simple and
> > > > > working for now.
> > > > >
> > > > > Is there a good reason for not using memblock_mark_nomap() with DT? If
> > > > > not, I'm happy to try that.
> > > >
> > > > There were 2 patches to do that, but it never got resolved. See here[1].
> > >
> > > Thanks. So the DT stuff predates the introduction of memblock_mark_nomap,
> > > that's why...
> > >
> > > By reading the discussions, [1] still looks a sensible patch on its own,
> > > independently from the issue Nicolas tried to solve. Any reason for not
> > > applying it?
> >
> > As I mentioned in the thread, same patch with 2 different reasons. So
> > I just wanted a better commit message covering both.
>
> Sorry if I'm being thick, but I'm not seeing it. How are they the same?
> IIUC, as per Nicolas' last reply, using memblock_mark_nomap() does not
> solve his issue with a broken DT. These 2 patches address two completely
> separate issues no?

Umm, yes you are right. But both are dealing with nomap. So someone
needs to sort out what the right thing to do here is. No one cared
enough to follow up in a year and a half.

Rob
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
