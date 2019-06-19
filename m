Return-Path: <SRS0=0dlf=US=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1712C31E49
	for <kvmarm@archiver.kernel.org>; Wed, 19 Jun 2019 12:39:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8AB05206E0
	for <kvmarm@archiver.kernel.org>; Wed, 19 Jun 2019 12:39:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8AB05206E0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B64D4A3B4;
	Wed, 19 Jun 2019 08:39:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IjJSe+Fzk70b; Wed, 19 Jun 2019 08:39:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D61034A4C0;
	Wed, 19 Jun 2019 08:39:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 78AC74A3B4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Jun 2019 08:39:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ry99uuNjnH0P for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Jun 2019 08:39:45 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED9274A379
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Jun 2019 08:39:44 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 945BC360;
 Wed, 19 Jun 2019 05:39:44 -0700 (PDT)
Received: from fuggles.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 092A33F738;
 Wed, 19 Jun 2019 05:39:41 -0700 (PDT)
Date: Wed, 19 Jun 2019 13:39:39 +0100
From: Will Deacon <will.deacon@arm.com>
To: Guo Ren <guoren@kernel.org>
Subject: Re: [PATCH RFC 11/14] arm64: Move the ASID allocator code in a
 separate file
Message-ID: <20190619123939.GF7767@fuggles.cambridge.arm.com>
References: <20190321163623.20219-1-julien.grall@arm.com>
 <20190321163623.20219-12-julien.grall@arm.com>
 <0dfe120b-066a-2ac8-13bc-3f5a29e2caa3@arm.com>
 <CAJF2gTTXHHgDboaexdHA284y6kNZVSjLis5-Q2rDnXCxr4RSmA@mail.gmail.com>
 <c871a5ae-914f-a8bb-9474-1dcfec5d45bf@arm.com>
 <20190619091219.GB7767@fuggles.cambridge.arm.com>
 <CAJF2gTTmFq3yYa9UrdZRAFwJgC=KmKTe2_NFy_UZBUQovqQJPg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJF2gTTmFq3yYa9UrdZRAFwJgC=KmKTe2_NFy_UZBUQovqQJPg@mail.gmail.com>
User-Agent: Mutt/1.11.1+86 (6f28e57d73f2) ()
Cc: aou@eecs.berkeley.edu, Arnd Bergmann <arnd@arndb.de>,
 Marc Zyngier <marc.zyngier@arm.com>, catalin.marinas@arm.com,
 Anup Patel <anup.Patel@wdc.com>, linux-kernel@vger.kernel.org,
 rppt@linux.ibm.com, hch@infradead.org, Atish.Patra@wdc.com,
 Julien Grall <julien.grall@arm.com>, Palmer Dabbelt <palmer@sifive.com>,
 gary@garyguo.net, paul.walmsley@sifive.com, linux-riscv@lists.infradead.org,
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

On Wed, Jun 19, 2019 at 08:18:04PM +0800, Guo Ren wrote:
> On Wed, Jun 19, 2019 at 5:12 PM Will Deacon <will.deacon@arm.com> wrote:
> > This is one place where I'd actually prefer not to go down the route of
> > making the code generic. Context-switching and low-level TLB management
> > is deeply architecture-specific and I worry that by trying to make this
> > code common, we run the real risk of introducing subtle bugs on some
> > architecture every time it is changed.
> "Add generic asid code" and "move arm's into generic" are two things.
> We could do
> first and let architecture's maintainer to choose.

If I understand the proposal being discussed, it involves basing that
generic ASID allocation code around the arm64 implementation which I don't
necessarily think is a good starting point.

> > Furthermore, the algorithm we use
> > on arm64 is designed to scale to large systems using DVM and may well be
> > too complex and/or sub-optimal for architectures with different system
> > topologies or TLB invalidation mechanisms.
> It's just a asid algorithm not very complex and there is a callback
> for architecture to define their
> own local hart tlb flush. Seems it has nothing with DVM or tlb
> broadcast mechanism.

I'm pleased that you think the algorithm is not very complex, but I'm also
worried that you might not have fully understood some of its finer details.

The reason I mention DVM and TLB broadcasting is because, depending on
the mechanisms in your architecture relating to those, it may be strictly
required that all concurrently running threads of a process have the same
ASID at any given point in time, or it may be that you really don't care.

If you don't care, then the arm64 allocator is over-engineered and likely
inefficient for your system. If you do care, then it's worth considering
whether a lock is sufficient around the allocator if you don't expect high
core counts. Another possibility is that you end up using only one ASID and
invalidating the local TLB on every context switch. Yet another design
would be to manage per-cpu ASID pools.

So rather than blindly copying the arm64 code, I suggest sitting down and
designing something that fits to your architecture instead. You may end up
with something that is both simpler and more efficient.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
