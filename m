Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F45238B121;
	Tue, 31 Mar 2026 22:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774997884; cv=none; b=DftIsm3PnhsIfJLAEZwSXdfKeUZZ11FVaUnGuZOXlzeEhn7VGJyrgrwig76+2Y5tmcKH66p503YA8g0ykIsD8/pX2fKLHQzyK9sMawsqD7AZxtfuIga6h43inaoa0zY/X471NNi3SWPgqNMHtwrUQ3R++ADfpaXc+k8DbtCgUEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774997884; c=relaxed/simple;
	bh=zczIin7kZzmVriuWwA6IdqbGkFkkypZCtXzWVA/npWU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C9yvl0LO4MKOXOSCxHfh5am+zPwfPEyFbCeMhGTVrTfBBdZmdVQ0jog/XozJlY0snqcj/zcfyg2GiJHgm9RV5bAzt27Zmc1EU4846LhIleGxa8DC1KldEi+6UWeENjRIZf0u4yF5upY8ZdXTHZ9Ky0wfvN3EXVk3kmpEBYSpkNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CeeIgrB4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CeeIgrB4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12BFC19423;
	Tue, 31 Mar 2026 22:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774997884;
	bh=zczIin7kZzmVriuWwA6IdqbGkFkkypZCtXzWVA/npWU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CeeIgrB4xmGZH95EhehNb/l8nsUBcjNBci24DKZtaw0m1Hux87XEd5qrssWqOgBnA
	 TU0fBlIXEuzTE9k3PtkbuvAVGJPdFAvF42aQSibna6ggb1BuR8nkV4Hr7/65JbVuWw
	 vCGn2WsT6+FV4hh9UlwGeqcqAaV+JVeu2+Hivq5Ga3B4AOCWbD19eYbNpnD5/Mygm9
	 /RQpYsd4N4af7L7kfahfitFdGAZFoLEnNSWmPKUgcpY961PnjzYAMCLYJMhPWAG4KZ
	 Lh4kuuvvMiY4fpWhDWTdPaVRDEyFYOfMiv0oCHWRojXlgRosCKOIMxfA//Sv2OYPj0
	 RrxJId4dk1KUw==
Date: Tue, 31 Mar 2026 17:58:00 -0500
From: Rob Herring <robh@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
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
Message-ID: <20260331225800.GA2082670-robh@kernel.org>
References: <20241216040831.2448257-1-anshuman.khandual@arm.com>
 <20241216040831.2448257-8-anshuman.khandual@arm.com>
 <Z2AH1SN5CipWkkE4@J2N7QTR9R3>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z2AH1SN5CipWkkE4@J2N7QTR9R3>

On Mon, Dec 16, 2024 at 10:58:29AM +0000, Mark Rutland wrote:
> On Mon, Dec 16, 2024 at 09:38:31AM +0530, Anshuman Khandual wrote:
> > Currently there can be maximum 16 breakpoints, and 16 watchpoints available
> > on a given platform - as detected from ID_AA64DFR0_EL1.[BRPs|WRPs] register
> > fields. But these breakpoint, and watchpoints can be extended further up to
> > 64 via a new arch feature FEAT_Debugv8p9.
> > 
> > This first enables banked access for the breakpoint and watchpoint register
> > set via MDSELR_EL1, extended exceptions via MDSCR_EL1.EMBWE and determining
> > available breakpoints and watchpoints in the platform from ID_AA64DFR1_EL1,
> > when FEAT_Debugv8p9 is enabled.
> 
> [...]

Well, this series has landed on my plate...


> > +static u64 read_wb_reg(int reg, int n)
> > +{
> > +	unsigned long flags;
> > +	u64 val;
> > +
> > +	if (!is_debug_v8p9_enabled())
> > +		return __read_wb_reg(reg, n);
> > +
> > +	/*
> > +	 * Bank selection in MDSELR_EL1, followed by an indexed read from
> > +	 * breakpoint (or watchpoint) registers cannot be interrupted, as
> > +	 * that might cause misread from the wrong targets instead. Hence
> > +	 * this requires mutual exclusion.
> > +	 */
> > +	local_irq_save(flags);
> > +	write_sysreg_s(SYS_FIELD_PREP(MDSELR_EL1, BANK, n / MAX_PER_BANK), SYS_MDSELR_EL1);
> > +	isb();
> > +	val = __read_wb_reg(reg, n % MAX_PER_BANK);
> > +	local_irq_restore(flags);
> > +	return val;
> > +}
> >  NOKPROBE_SYMBOL(read_wb_reg);
> 
> I don't believe that disabling interrupts here is sufficient. On the
> last version I asked about the case of racing with a watchpoint handler:
> 
> | For example, what prevents watchpoint_handler() from firing in the
> | middle of arch_install_hw_breakpoint() or
> | arch_uninstall_hw_breakpoint()?
> 
> ... and disabling interrupts cannot prevent that, because
> local_irq_{save,restore}() do not affect the behaviour of watchpoints or
> breakpoints.

I think the answer is we just need NOKPROBE_SYMBOL() annotation on 
hw_breakpoint_control() (what arch_install_hw_breakpoint() and 
arch_uninstall_hw_breakpoint() wrap). We also need that on __read_wb_reg 
and __read_wb_reg though I would think those are folded into the calling 
functions by the compiler. Interestly, the x86 code doesn't use the 
annotation at all.

I initially thought the IRQ disabling is also still needed as IRQ 
handlers can trigger breakpoints. However, the x86 version of 
arch_install_hw_breakpoint() contains a lockdep_assert_irqs_disabled(), 
so it seems for that case interrupts are already disabled. And in debug 
exceptions, we disable interrupts. So I think the interrupt disabling 
can be dropped.


> Please can you try to answer the questions I asked last time, i.e.
> 
> | What prevents a race with an exception handler? e.g. 
> | 
> | * Does the structure of the code prevent that somehow?

If you can't set a breakpoint/watchpoint in NOKPROBE_SYMBOL() annotated 
code, you can't race.

However, there's no such annotation for data. It looks like the kernel 
policy is "don't do that" or disable all breakpoints/watchpoints.

> | 
> | * What context(s) does this code execute in?
> |   - Are debug exceptions always masked?

No.

> |   - Do we disable breakpoints/watchpoints around (some) manipulation of
> |     the relevant registers?

Yes, with NOKPROBE_SYMBOL().

Rob
