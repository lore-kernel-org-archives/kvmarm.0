Return-Path: <SRS0=87+N=UX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA262C4646C
	for <kvmarm@archiver.kernel.org>; Mon, 24 Jun 2019 11:20:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 95F3C2133F
	for <kvmarm@archiver.kernel.org>; Mon, 24 Jun 2019 11:20:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="p4PZ9wV2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 95F3C2133F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D3E04A4A3;
	Mon, 24 Jun 2019 07:20:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LQQ7SubIwZ7O; Mon, 24 Jun 2019 07:20:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 04CDE4A509;
	Mon, 24 Jun 2019 07:20:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A338C4A409
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Jun 2019 06:40:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6NMqzyzVae-w for <kvmarm@lists.cs.columbia.edu>;
 Mon, 24 Jun 2019 06:40:15 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1FB154A379
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Jun 2019 06:40:15 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 95F05208E4;
 Mon, 24 Jun 2019 10:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1561372814;
 bh=HxUEH3z4leC4dJ5SSdD+Hrod9xxZtdkXEJIvmvfkDls=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=p4PZ9wV2TnMIZpxRJidZl+RtPVe+FUZBi7moRglIiodLBtKwmf1oEV4xqb5V+mh/L
 Ugv88bzt/3W9tu/LDyR9Ve1JBjk3ghhMOMhvuEYNmO1szy9MNLn7zjJIf9MKdbIT/h
 Y4mOVdujWbYLgUJb5+1Frs1BuqhFX3eWJC3Rsdvc=
Date: Mon, 24 Jun 2019 11:40:07 +0100
From: Will Deacon <will@kernel.org>
To: Guo Ren <guoren@kernel.org>
Subject: Re: [PATCH RFC 11/14] arm64: Move the ASID allocator code in a
 separate file
Message-ID: <20190624104006.lvm32nahemaqklxc@willie-the-truck>
References: <20190321163623.20219-1-julien.grall@arm.com>
 <20190321163623.20219-12-julien.grall@arm.com>
 <0dfe120b-066a-2ac8-13bc-3f5a29e2caa3@arm.com>
 <CAJF2gTTXHHgDboaexdHA284y6kNZVSjLis5-Q2rDnXCxr4RSmA@mail.gmail.com>
 <c871a5ae-914f-a8bb-9474-1dcfec5d45bf@arm.com>
 <20190619091219.GB7767@fuggles.cambridge.arm.com>
 <CAJF2gTTmFq3yYa9UrdZRAFwJgC=KmKTe2_NFy_UZBUQovqQJPg@mail.gmail.com>
 <20190619123939.GF7767@fuggles.cambridge.arm.com>
 <CAJF2gTSiiiewTLwVAXvPLO7rTSUw1rg8VtFLzANdP2S2EEbTjg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJF2gTSiiiewTLwVAXvPLO7rTSUw1rg8VtFLzANdP2S2EEbTjg@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Mailman-Approved-At: Mon, 24 Jun 2019 07:20:08 -0400
Cc: Julien Grall <julien.grall@arm.com>, aou@eecs.berkeley.edu,
 Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <marc.zyngier@arm.com>,
 catalin.marinas@arm.com, Will Deacon <will.deacon@arm.com>,
 linux-kernel@vger.kernel.org, rppt@linux.ibm.com, hch@infradead.org,
 Atish.Patra@wdc.com, Anup Patel <anup.Patel@wdc.com>, gary@garyguo.net,
 Palmer Dabbelt <palmer@sifive.com>, paul.walmsley@sifive.com,
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

On Thu, Jun 20, 2019 at 05:33:03PM +0800, Guo Ren wrote:
> On Wed, Jun 19, 2019 at 8:39 PM Will Deacon <will.deacon@arm.com> wrote:
> >
> > On Wed, Jun 19, 2019 at 08:18:04PM +0800, Guo Ren wrote:
> > > On Wed, Jun 19, 2019 at 5:12 PM Will Deacon <will.deacon@arm.com> wrote:
> > > > This is one place where I'd actually prefer not to go down the route of
> > > > making the code generic. Context-switching and low-level TLB management
> > > > is deeply architecture-specific and I worry that by trying to make this
> > > > code common, we run the real risk of introducing subtle bugs on some
> > > > architecture every time it is changed.
> > > "Add generic asid code" and "move arm's into generic" are two things.
> > > We could do
> > > first and let architecture's maintainer to choose.
> >
> > If I understand the proposal being discussed, it involves basing that
> > generic ASID allocation code around the arm64 implementation which I don't
> > necessarily think is a good starting point.
> ...
> >
> > > > Furthermore, the algorithm we use
> > > > on arm64 is designed to scale to large systems using DVM and may well be
> > > > too complex and/or sub-optimal for architectures with different system
> > > > topologies or TLB invalidation mechanisms.
> > > It's just a asid algorithm not very complex and there is a callback
> > > for architecture to define their
> > > own local hart tlb flush. Seems it has nothing with DVM or tlb
> > > broadcast mechanism.
> >
> > I'm pleased that you think the algorithm is not very complex, but I'm also
> > worried that you might not have fully understood some of its finer details.
> I understand your concern about my less understanding of asid
> technology. Here is
> my short-description of arm64 asid allocator: (If you find anything
> wrong, please
> correct me directly, thx :)

The complexity mainly comes from the fact that this thing runs concurrently
with itself without synchronization on the fast-path. Coupled with the
need to use the same ASID for all threads of a task, you end up in fiddly
situations where rollover can occur on one CPU whilst another CPU is trying
to schedule a thread of a task that already has threads running in
userspace.

However, it's architecture-specific whether or not you care about that
scenario.

> > The reason I mention DVM and TLB broadcasting is because, depending on
> > the mechanisms in your architecture relating to those, it may be strictly
> > required that all concurrently running threads of a process have the same
> > ASID at any given point in time, or it may be that you really don't care.
> >
> > If you don't care, then the arm64 allocator is over-engineered and likely
> > inefficient for your system. If you do care, then it's worth considering
> > whether a lock is sufficient around the allocator if you don't expect high
> > core counts. Another possibility is that you end up using only one ASID and
> > invalidating the local TLB on every context switch. Yet another design
> > would be to manage per-cpu ASID pools.
> I'll keep my system use the same ASID for SMP + IOMMU :P

You will want a separate allocator for that:

https://lkml.kernel.org/r/20190610184714.6786-2-jean-philippe.brucker@arm.com

> Yes, there are two styles of asid allocator: per-cpu ASID (MIPS) or
> same ASID (ARM).
> If the CPU couldn't support cache/tlb coherency maintian in hardware,
> it should use
> per-cpu ASID style because IPI is expensive and per-cpu ASID style
> need more software
> mechanism to improve performance (eg: delay cache flush). From software view the
> same ASID is clearer and easier to build bigger system with more TLB caches.
> 
> I think the same ASID style is a more sensible choice for modern
> processor and let it be
> one of generic is reasonable.

I'm not sure I agree. x86, for example, is better off using a different
algorithm for allocating its PCIDs.

> > So rather than blindly copying the arm64 code, I suggest sitting down and
> > designing something that fits to your architecture instead. You may end up
> > with something that is both simpler and more efficient.
> In fact, riscv folks have discussed a lot about arm's asid allocator
> and I learned
> a lot from the discussion:
> https://lore.kernel.org/linux-riscv/20190327100201.32220-1-anup.patel@wdc.com/

If you require all threads of the same process to have the same ASID, then
that patch looks broken to me.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
