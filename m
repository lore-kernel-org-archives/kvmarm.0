Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCFF926038A
	for <kvmarm@lists.linux.dev>; Fri, 28 Feb 2025 11:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740741226; cv=none; b=n3cQ9yKkFQsINliQnFTkqHF4tHMMoFNjbHQULwfVkutvfa7DR+Ev4UAcekvFejaTfs5X3Kkg5nQz9zl1XF8/EWHsi4JZ/5H7o5lfWwRlZ7n6Ob7dxiXCGoB2EzinQ+tnZbaKVVlSQb2vtWbVVfq27MdVcTeXbaVzIeIhlCApF4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740741226; c=relaxed/simple;
	bh=C+bFAX9Hnl45H59JCOnqO1Z/jZyvQba19dWb2z8U5b4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FIY9Ft/McIt6CA2rzJgcY6DIgNmRIL/fRuH4+2Rzxe0mNGeL6lu1SU/A4kYt44kck/u+BhMePFvqOXfPgoWB61z0ta5cbpyHrZ/iI4U1Wv/D7Yl2Qi6q5AnvKBBtDd8AHDTo0P+JHdXwMcy1zY1MtsCgzqUeQR69VJvcWaw3rIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 597C41692;
	Fri, 28 Feb 2025 03:13:59 -0800 (PST)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7C5973F673;
	Fri, 28 Feb 2025 03:13:42 -0800 (PST)
Date: Fri, 28 Feb 2025 11:13:39 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Leo Yan <leo.yan@arm.com>, linux-arm-kernel@lists.infradead.org,
	ahmed.genidi@arm.com, ben.horgan@arm.com, catalin.marinas@arm.com,
	kvmarm@lists.linux.dev, oliver.upton@linux.dev, will@kernel.org
Subject: Re: [PATCH 1/2] KVM: arm64: Initialize HCR_EL2.E2H early
Message-ID: <Z8GaY09Ly2-qVRM1@J2N7QTR9R3>
References: <20250227180526.1204723-1-mark.rutland@arm.com>
 <20250227180526.1204723-2-mark.rutland@arm.com>
 <20250228092955.GC2157064@e132581.arm.com>
 <86y0xqpfpj.wl-maz@kernel.org>
 <Z8GHclusYN3CX5m2@J2N7QTR9R3>
 <86v7supdzd.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86v7supdzd.wl-maz@kernel.org>

On Fri, Feb 28, 2025 at 10:20:38AM +0000, Marc Zyngier wrote:
> On Fri, 28 Feb 2025 09:52:50 +0000,
> Mark Rutland <mark.rutland@arm.com> wrote:
> > 
> > On Fri, Feb 28, 2025 at 09:43:20AM +0000, Marc Zyngier wrote:
> > > On Fri, 28 Feb 2025 09:29:55 +0000,
> > > Leo Yan <leo.yan@arm.com> wrote:
> > > > 
> > > > Hi Mark,
> > > > 
> > > > On Thu, Feb 27, 2025 at 06:05:25PM +0000, Mark Rutland wrote:
> > > > 
> > > > [...]
> > > > 
> > > > > +.macro init_el2_hcr	val
> > > > > +	mov_q	x0, \val
> > > > > +
> > > > > +	/*
> > > > > +	 * Compliant CPUs advertise their VHE-onlyness with
> > > > > +	 * ID_AA64MMFR4_EL1.E2H0 < 0. On such CPUs HCR_EL2.E2H is RES1, but it
> > > > > +	 * can reset into an UNKNOWN state and might not read as 1 until it has
> > > > > +	 * been initialized explicitly.
> > > > 
> > > > For ID_AA64MMFR4_EL1.E2H0 < 0 case, the code actually clears the
> > > > HCR_EL2.E2H bit.
> > > >
> > > > Hence, the comment should be corrected as: "... it can reset into an
> > > > UNKNOWN state and might not read as 0 until it has been initialized
> > > > explicitly".
> > > 
> > > The comment is just fine. It is the code that is wrong, as it avoids
> > > setting E2H when E2H0 < 0 while we want the exact opposite behaviour.
> > > 
> > > As a result, 'b.lt' really should be a 'b.ge'. Or the original code
> > > kept as is.
> > 
> > Ugh, yes. I got confused and got the condition backwards.
> > 
> > Either works. Using 'b.ge' is closer to my intention -- I found the
> > 'tbz' of the sign bit somewhat surprising and that needed a longer line
> > after the lable name changed.
> > 
> > Would you like me to respin, or would you be hapy to fix up when
> > applying?
> 
> I can fix it on the fly, but it needs retesting, as I don't understand
> how things could work in this state.

This happened to work by virtue of coincidence :/

Critically, I have not tested this on a CPU where HCR_EL2.E2H is
writeable but one polarity has no effect, as I don't have such a CPU to
hand. IIUC you tested that with hVHE under NV per commit:

  b3320142f3db9b3f ("arm64: Fix early handling of FEAT_E2H0 not being implemented")

... but I don't currently have a good setup to test that configuration.

In other cases, this largely falls out in the wash, e.g.

* On a CPU without E2H, where the HCR_EL2.E2H bit is implemented as
  RAZ/WI, the bit always reads as 0. Trying to set the bit has no
  effect. Later reads see 0.

  Hence this case happens to work.

* On a CPU with E2H and without FEAT_E2H0, where the HCR_EL2.E2H bit is
  implemented as RAO/WI, the bit always reads as 1. Trying to clear the
  bit has no effect. Later reads see 1.

  Hence this case happens to work.

* On a CPU with E2H and with FEAT_E2H0, there the HCR_EL2.E2H bit is
  implemented and has an effect, writing to the bit moves the CPU into
  E2H mode.

  The early boot code handles this the same as FEAT_E2H0 being absent,
  and so that happens to work. I haven't dug into how HCR_EL2 gets
  properly initialized later by KVM, but testing seems to indicate that
  this works.

Mark.
