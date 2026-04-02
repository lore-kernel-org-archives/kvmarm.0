Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4DE325D527
	for <kvmarm@lists.linux.dev>; Thu,  2 Apr 2026 10:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775126266; cv=none; b=F9pRpQr5bRpMFjSblR4vjyQdVwjHxODBLQz1RjUvZ/vUw/03iRP7+d3fohxsi+cpxz39UtelEwbWVgc5VlArJrxi5UsmGX+GAEgqSFO9YbNZX3f8d9GDPgxI/xWHk8kbr3gW7czRq+bchC826e/tvxLWL6niBi4ymZS5uWf6b+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775126266; c=relaxed/simple;
	bh=GQzaBMwghl8XYidHwNNmgxTe21K2DfaqjQnm40MyiGg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ty/j05cDf/UXRgsVK3Jm9qIDasl5sVC7nNF5rMbdsRPnuIrVHDCpCHTRlwVntzMXGF2JxLmUUxN9Yb0GjnmkLnJ/+k1LaL0XltBz3ACA7HH5or8aYFb2Y9uVz9zQoqHB5rWNnmXyrxgfwsj/dTGqsdi0+tT9y9UEPWmTq2YcEhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HveKKtNG; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HveKKtNG"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2C8EB2C43;
	Thu,  2 Apr 2026 03:37:38 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2EA953F915;
	Thu,  2 Apr 2026 03:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775126263; bh=GQzaBMwghl8XYidHwNNmgxTe21K2DfaqjQnm40MyiGg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HveKKtNGZYStMde8mysfVmmrzu0eDZAc6sG/X6uBcJ/WIJ/j2pEF54jrBgaiecdcx
	 W2c7UBqIdHhbXUqRnU0lrHh4npDO0UiZDDUENxFTq7rLHlbk+bLeTRJvawN2WrPq7M
	 gg60OtPpvOXkdBvisy3B/dvw6XgHomN2sEGqWukE=
Date: Thu, 2 Apr 2026 11:37:37 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Rob Herring <robh@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH V3 7/7] arm64/hw_breakpoint: Enable FEAT_Debugv8p9
Message-ID: <ac5G8e4zWTdicDBs@J2N7QTR9R3>
References: <20241216040831.2448257-1-anshuman.khandual@arm.com>
 <20241216040831.2448257-8-anshuman.khandual@arm.com>
 <Z2AH1SN5CipWkkE4@J2N7QTR9R3>
 <20260331225800.GA2082670-robh@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331225800.GA2082670-robh@kernel.org>

On Tue, Mar 31, 2026 at 05:58:00PM -0500, Rob Herring wrote:
> On Mon, Dec 16, 2024 at 10:58:29AM +0000, Mark Rutland wrote:
> > On Mon, Dec 16, 2024 at 09:38:31AM +0530, Anshuman Khandual wrote:
> > > Currently there can be maximum 16 breakpoints, and 16 watchpoints available
> > > on a given platform - as detected from ID_AA64DFR0_EL1.[BRPs|WRPs] register
> > > fields. But these breakpoint, and watchpoints can be extended further up to
> > > 64 via a new arch feature FEAT_Debugv8p9.
> > > 
> > > This first enables banked access for the breakpoint and watchpoint register
> > > set via MDSELR_EL1, extended exceptions via MDSCR_EL1.EMBWE and determining
> > > available breakpoints and watchpoints in the platform from ID_AA64DFR1_EL1,
> > > when FEAT_Debugv8p9 is enabled.
> > 
> > [...]
> 
> Well, this series has landed on my plate...

Sorry about that; thanks for taking a look!

> > > +static u64 read_wb_reg(int reg, int n)
> > > +{
> > > +	unsigned long flags;
> > > +	u64 val;
> > > +
> > > +	if (!is_debug_v8p9_enabled())
> > > +		return __read_wb_reg(reg, n);
> > > +
> > > +	/*
> > > +	 * Bank selection in MDSELR_EL1, followed by an indexed read from
> > > +	 * breakpoint (or watchpoint) registers cannot be interrupted, as
> > > +	 * that might cause misread from the wrong targets instead. Hence
> > > +	 * this requires mutual exclusion.
> > > +	 */
> > > +	local_irq_save(flags);
> > > +	write_sysreg_s(SYS_FIELD_PREP(MDSELR_EL1, BANK, n / MAX_PER_BANK), SYS_MDSELR_EL1);
> > > +	isb();
> > > +	val = __read_wb_reg(reg, n % MAX_PER_BANK);
> > > +	local_irq_restore(flags);
> > > +	return val;
> > > +}
> > >  NOKPROBE_SYMBOL(read_wb_reg);
> > 
> > I don't believe that disabling interrupts here is sufficient. On the
> > last version I asked about the case of racing with a watchpoint handler:
> > 
> > | For example, what prevents watchpoint_handler() from firing in the
> > | middle of arch_install_hw_breakpoint() or
> > | arch_uninstall_hw_breakpoint()?
> > 
> > ... and disabling interrupts cannot prevent that, because
> > local_irq_{save,restore}() do not affect the behaviour of watchpoints or
> > breakpoints.
> 
> I think the answer is we just need NOKPROBE_SYMBOL() annotation on 
> hw_breakpoint_control() (what arch_install_hw_breakpoint() and 
> arch_uninstall_hw_breakpoint() wrap).

Ok. I couldn'y spot where we prevent placing HW breakpoints on
NOKPROBE_SYMBOL() functions, but if we do enforce that, something like
that sounds ok.

I suspect we'd need to make that noinstr to also prevent ftrace
instrumentation, unless ftrace also inhibits itself for
NOKPROBE_SYMBOL() functions.

> We also need that on __read_wb_reg 
> and __read_wb_reg though I would think those are folded into the calling 
> functions by the compiler. Interestly, the x86 code doesn't use the 
> annotation at all.

IIUC, it looks like they *can* take debug NMIs during
arch_install_hw_breakpoint() and arch_uninstall_hw_breakpoint(), which
is why they have ordering constraints for modifying the percpu 'cpu_dr7'
variable, and their actual DR7 register (which IIUC has the enable
controls for each HW breakpoint).

That said, the use of 'bp_per_reg' looks suspect given their
arch_install_hw_breakpoint() and arch_uninstall_hw_breakpoint() modify
that non-atomically.

We could consider allowing breakpoints on those functions, but I'm not
sure whether that's possible for us, and (as noted below) it might be
better to transiently disable breakpoints/watchpoints.

IIRC on x86, breakpoint exceptions are taken *after* execution of the
instruction that triggered them, so the handler doesn't have to
manipulate single-step, and can safely ignore a breakpoint exception
without the risk of getting stuck taking the breakpoint repeatedly.

> I initially thought the IRQ disabling is also still needed as IRQ 
> handlers can trigger breakpoints. However, the x86 version of 
> arch_install_hw_breakpoint() contains a lockdep_assert_irqs_disabled(), 
> so it seems for that case interrupts are already disabled. And in debug 
> exceptions, we disable interrupts. So I think the interrupt disabling 
> can be dropped.

I'd expect that the core perf code disables interrupts before calling
arch_install_hw_breakpoint() or arch_uninstall_hw_breakpoint(), and this
would be necessary for perf to serialise against IPIs that manipulate
the perf_event_context.

I agree that when we actually take the breakpoint, we'll mask all
exceptions, and so it's not necessary to mask IRQs there.

So a first step is probably to add that lockdep assert.

> > Please can you try to answer the questions I asked last time, i.e.
> > 
> > | What prevents a race with an exception handler? e.g. 
> > | 
> > | * Does the structure of the code prevent that somehow?
> 
> If you can't set a breakpoint/watchpoint in NOKPROBE_SYMBOL() annotated 
> code, you can't race.

As above, I agree (with caveats), but I couldn't spot where this is
enforced.

> However, there's no such annotation for data. It looks like the kernel 
> policy is "don't do that" or disable all breakpoints/watchpoints.

If we have to transiently disable watchpoints/breakpoints when
manipulating the relevant HW registers, that sounds fine to me.

> > | 
> > | * What context(s) does this code execute in?
> > |   - Are debug exceptions always masked?
> 
> No.
> 
> > |   - Do we disable breakpoints/watchpoints around (some) manipulation of
> > |     the relevant registers?
> 
> Yes, with NOKPROBE_SYMBOL().

Thanks for digging into this; much appreciated!

Mark.
