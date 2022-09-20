Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D0FBC54EE9
	for <kvmarm@archiver.kernel.org>; Tue, 20 Sep 2022 16:58:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DC0874B20F;
	Tue, 20 Sep 2022 12:58:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bMXfQ+vPmyPY; Tue, 20 Sep 2022 12:58:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9694C4B2A5;
	Tue, 20 Sep 2022 12:58:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 20FC14B15C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 12:58:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PXRgzQVi5Sg6 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 12:58:21 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D8CF44B0F4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 12:58:21 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 86CF5B82B57;
 Tue, 20 Sep 2022 16:58:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0860C433C1;
 Tue, 20 Sep 2022 16:58:16 +0000 (UTC)
Date: Tue, 20 Sep 2022 17:58:13 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 3/7] mm: Add PG_arch_3 page flag
Message-ID: <YynxJYrd15aUJsmp@arm.com>
References: <20220810193033.1090251-4-pcc@google.com>
 <202208111500.62e0Bl2l-lkp@intel.com> <YxDy+zFasbAP7Yrq@arm.com>
 <YxYrgyybBMUqFswq@arm.com> <878rmfkzbu.wl-maz@kernel.org>
 <Yynewxzc6Zy8ls0N@arm.com> <871qs6kntl.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <871qs6kntl.wl-maz@kernel.org>
Cc: kbuild-all@lists.01.org, kernel test robot <lkp@intel.com>,
 kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Cornelia Huck <cohuck@redhat.com>, Steven Price <steven.price@arm.com>,
 Evgenii Stepanov <eugenis@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Peter Collingbourne <pcc@google.com>, kvmarm@lists.cs.columbia.edu,
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

On Tue, Sep 20, 2022 at 05:33:42PM +0100, Marc Zyngier wrote:
> On Tue, 20 Sep 2022 16:39:47 +0100,
> Catalin Marinas <catalin.marinas@arm.com> wrote:
> > On Mon, Sep 19, 2022 at 07:12:53PM +0100, Marc Zyngier wrote:
> > > On Mon, 05 Sep 2022 18:01:55 +0100,
> > > Catalin Marinas <catalin.marinas@arm.com> wrote:
> > > > Peter, please let me know if you want to pick this series up together
> > > > with your other KVM patches. Otherwise I can post it separately, it's
> > > > worth merging it on its own as it clarifies the page flag vs tag setting
> > > > ordering.
> > > 
> > > I'm looking at queuing this, but I'm confused by this comment. Do I
> > > need to pick this as part of the series? Or is this an independent
> > > thing (my hunch is that it is actually required not to break other
> > > architectures...).
> > 
> > This series series (at least the first patches) won't apply cleanly on
> > top of 6.0-rc1 and, of course, we shouldn't break other architectures. I
> > can repost the whole series but I don't have the setup to test the
> > MAP_SHARED KVM option (unless Peter plans to post it soon).
> 
> I don't feel brave enough to take a series affecting all architectures

It shouldn't affect the others, the only change is that PG_arch_2 is now
only defined for arm64 but no other architecture is using it. The
problem with loongarch is that it doesn't have enough spare bits in
page->flags and even without any patches I think it's broken with the
right value for NR_CPUS.

> so late in the game, and the whole thing had very little arm64
> exposure. The latest QEMU doesn't seem to work anymore, so I don't
> have any MTE-capable emulation (and using the FVP remotely is a pain
> in the proverbial neck).
> 
> I'll come back to this after the merge window, should Peter decide to
> respin the series.

It makes sense.

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
