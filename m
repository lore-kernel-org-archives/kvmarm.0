Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC4742DF132
	for <kvmarm@lists.linux.dev>; Wed,  8 Apr 2026 15:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775660636; cv=none; b=F9MzUk5tGvYX730Hiq5iH1PiZMXasGIKzPsRxJTYkWTrg2xWm5VsWpvrtee7uvFgGNXxFtKzMkZwn41VtdQxeQqD8wxPzsayoMSRpuxWQwhepy/nBmsp0d672rBt5J7OnAijP+WhX/FcQZ1OLZCfKTTacG8HvCLayWCg1Xeuys4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775660636; c=relaxed/simple;
	bh=EGlj1BPEhtMUGytA0o2KFuAClFgXoP8MOx9WWQPnaSM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IL8XpJg6tE5WTRAGoZJ7fIbfj27eW63Kbth9p/YMKzqaafY0bQ7J5XIsbj7gBqXDt4BF+ef8eJDheWm6eJptcKfnS46BtswKP+WQuw6J7//OOIZkURnHSShmCaty9PakJgFlp91hkT2EC0qMHpdgOgZXZlqOl1c5WLBoO5+aGtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=SsmuUK1b; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="SsmuUK1b"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 665542BC4;
	Wed,  8 Apr 2026 08:03:47 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F00073F641;
	Wed,  8 Apr 2026 08:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775660633; bh=EGlj1BPEhtMUGytA0o2KFuAClFgXoP8MOx9WWQPnaSM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SsmuUK1bUr2gKodHu5F5yl4cPgqqRVx4vc57dDsmM9MuIrnZWGyBBS+6q/0ZUb8yd
	 dfJXzAUV3Jz9i4824j83KB7/GHm6ANDFTvL9P7zOXUu47ZnQGutGYBfdlLV8vcuKgB
	 1Ul9cIsHQq1UrQgFOi/HaqkJ1NLTPoNiUUVAKEDA=
Date: Wed, 8 Apr 2026 16:03:45 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Jing Zhang <jingzhangos@google.com>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Andrew Jones <andrew.jones@linux.dev>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [kvm-unit-tests PATCH v1 0/3] arm64: Add Stage-2 MMU and Nested
 Guest Framework
Message-ID: <20260408150345.GA2316230@e124191.cambridge.arm.com>
References: <20260316224349.2360482-1-jingzhangos@google.com>
 <20260324114312.GA438107@e124191.cambridge.arm.com>
 <CAAdAUtjeYJ5sOQVB-t7U=KJ9JuCCmO9b2dwJsas7mkzNLu8WqA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAdAUtjeYJ5sOQVB-t7U=KJ9JuCCmO9b2dwJsas7mkzNLu8WqA@mail.gmail.com>

On Tue, Apr 07, 2026 at 11:16:15AM -0700, Jing Zhang wrote:
> On Tue, Mar 24, 2026 at 4:43 AM Joey Gouly <joey.gouly@arm.com> wrote:
> >
> > On Mon, Mar 16, 2026 at 03:43:46PM -0700, Jing Zhang wrote:
> > > This patch series introduces a lightweight infrastructure for managing ARM64
> > > Stage-2 translation tables and executing nested guests. These components are
> > > essential for testing advanced virtualization features such as nested
> > > virtualization (NV) and GICv4 direct interrupt injection.
> > >
> > > The series provides a generic Stage-2 MMU library supporting multiple
> > > translation granules (4K, 16K, 64K) and dynamic page table management.
> > > Building on this, it adds a guest execution framework that handles guest
> > > lifecycle management, context switching and guest exit routing. A new test
> > > case for Stage-2 MMU demand paging to verify fault handling.
> > >
> > > Please note that this is a very preliminary implementation intended as a
> > > startup baseline for future work in virtualization testing. Users should be
> > > aware that because this is an early-stage baseline, some portions of the code
> > > may just happen to work in its current state. There might be critical
> > > architectural elements or edge-case handling missing that will need to be
> > > addressed as the framework matures.
> > >
> >
> > Hi,
> >
> > I'm interested in this, I had a much more barebones (aka no stage2) guest
> > framework thing that I sent out [1], but it seems more useful to try get this
> > series merged.
> >
> > I will try get my tests working with this new framework, one thing missing for
> > me is support for executing at EL0.
> >
> > Thanks,
> > Joey
> >
> > [1] https://lore.kernel.org/kvmarm/20260306142656.2775185-1-joey.gouly@arm.com/#t
> >
> 
> Hi Joey,

Hi Jing,

I had a bit of a play with the code and ended up with a few questions/thoughts
about the guest/EL1/EL0 model.

Two major things EL1 needs are allocating memory and eventually page tables.

For EL1 isolation, I can see a few possible approaches (maybe there's others?):
1. EL1 reuses the usual kvm-unit-tests infrastructure (allocators, helpers, etc.).
2. EL1 is treated more like a real guest/VM, and has to provide its own
   allocators and other basic support.
3. The host (EL2) provides all memory up front and can create EL1 page tables,
   like kselftest.
4. A small hyp-service interface is provided for things like page donation,
   printing, etc.

Option 1 feels like the best pragmatically, the tests will look like a normal C
file, just that parts of it are run at different ELs. However sharing
functionality could be complex. For example, I tried calling printf() from EL1
and then also from the EL2 abort handler, and hit a deadlock because both paths
ended up taking the same spinlock.

Option 2 feels the least hacky, but maybe has the most complexity since EL1
needs its own alloactors and general support functionality. It's also not
obvious how to map in the EL1 code. Perhaps there would need to be a separate
test_foo_el1.c file that was built and bundled into test_foo.c

Option 3 looks to be the most simple, is quite flexible, but less dynamic.

Option 4 might be quite simple to have a small hyp interface, a bit like option
3 but more dynamic.

> Will you add support for executing at EL0?

I tried to enter EL0 using `start_usr()` from the EL1 guest. I tried to
allocate a stack using alloc_page(). However this leads to some issues due to
the following code:

    phys_addr_t __virt_to_phys(unsigned long addr)
    {
            if (mmu_enabled()) {
                    pgd_t *pgtable = current_thread_info()->pgtable;
                    return virt_to_pte_phys(pgtable, (void *)addr);
            }
            return addr;
    }

In this series, EL1 is not set up as a "thread" (see new_thread() [1]), so
current_thread_info()->pgtable ends up being NULL.  That is what led me to
think about the options above.

Thanks,
Joey

[1] https://lore.kernel.org/kvmarm/20260306142656.2775185-5-joey.gouly@arm.com/

> 
> Thanks,
> Jing
> 
> > > ---
> > >
> > > Jing Zhang (3):
> > >   lib: arm64: Add stage2 page table management library
> > >   lib: arm64: Add bare-metal guest execution framework
> > >   arm64: Add Stage-2 MMU demand paging test
> > >
> > >  arm/Makefile.arm64         |   4 +
> > >  arm/stage2-mmu-test.c      | 100 +++++++++
> > >  lib/arm64/asm/guest.h      | 156 ++++++++++++++
> > >  lib/arm64/asm/stage2_mmu.h |  74 +++++++
> > >  lib/arm64/guest.c          | 197 ++++++++++++++++++
> > >  lib/arm64/guest_arch.S     | 263 ++++++++++++++++++++++++
> > >  lib/arm64/stage2_mmu.c     | 402 +++++++++++++++++++++++++++++++++++++
> > >  7 files changed, 1196 insertions(+)
> > >  create mode 100644 arm/stage2-mmu-test.c
> > >  create mode 100644 lib/arm64/asm/guest.h
> > >  create mode 100644 lib/arm64/asm/stage2_mmu.h
> > >  create mode 100644 lib/arm64/guest.c
> > >  create mode 100644 lib/arm64/guest_arch.S
> > >  create mode 100644 lib/arm64/stage2_mmu.c
> > >
> > >
> > > base-commit: 86e53277ac80dabb04f4fa5fa6a6cc7649392bdc
> > > --
> > > 2.53.0.851.ga537e3e6e9-goog
> > >
