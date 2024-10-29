Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C59720696B
	for <kvmarm@lists.linux.dev>; Tue, 29 Oct 2024 13:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730210287; cv=none; b=dtbbRI4lt8g5cJwyUDSIqgAmBKxqM5BB/PBZgDWC671Sy284OVXnPQjSdcDCIIH1eDXjHEnv1ArAS81CQ+NzFH7ky0HAiuE1pkgmliVEodqN/w5f6AaVyqxfULSOY7XGZptRWurPPCJfhbEEZ5gnpzl++6t7EEV4iT8wOqemdMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730210287; c=relaxed/simple;
	bh=7l7OAS/gfLeXOoXnCS2Ihlqh5IvcknHDzkD+UUIFsRk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EHbiHj0C/8M50eEhqoe85Gd29REhHKY9hBiFwYXlQhAfV6pRnGYJXFFx/3GVGBe41YcvthPC9tlV7aq8GluSNXYiSXetNRukIN9r2m/Pjx6Up+8jrpqgEEylsLU6m+uxxGcoQx7Q7dOi/h48HqEYFq5P8ex/bv6mhGrP2b5Su1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1AB39113E;
	Tue, 29 Oct 2024 06:58:34 -0700 (PDT)
Received: from J2N7QTR9R3.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3A4E13F528;
	Tue, 29 Oct 2024 06:58:02 -0700 (PDT)
Date: Tue, 29 Oct 2024 13:57:53 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, puranjay@kernel.org,
	Arnd Bergmann <arnd@arndb.de>, Arnd Bergmann <arnd@kernel.org>,
	Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Sumit Garg <sumit.garg@linaro.org>, puranjay12@gmail.com,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Joey Gouly <joey.gouly@arm.com>, Zenghui Yu <zenghui.yu@linux.dev>
Subject: Re: Supporting KVM_GUESTDBG_BLOCKIRQ or something similar on ARM64
Message-ID: <ZyDp2VLqjjzm47S3@J2N7QTR9R3.cambridge.arm.com>
References: <mb61p4j4wwlap.fsf@kernel.org>
 <86ed4031zh.wl-maz@kernel.org>
 <CAMj1kXEX2TLdYCn3C-AXhfhjOe6cuzOmd0h5MbgXnzi7Q94T3w@mail.gmail.com>
 <86bjz32q2q.wl-maz@kernel.org>
 <CAMj1kXFLRruq1gv+oiSz_LrfCt3j5ftv78prkxKV62tCXe0KVg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXFLRruq1gv+oiSz_LrfCt3j5ftv78prkxKV62tCXe0KVg@mail.gmail.com>

On Tue, Oct 29, 2024 at 11:00:24AM +0100, Ard Biesheuvel wrote:
> On Tue, 29 Oct 2024 at 10:53, Marc Zyngier <maz@kernel.org> wrote:
> >
> > On Tue, 29 Oct 2024 08:52:41 +0000,
> > Ard Biesheuvel <ardb@kernel.org> wrote:
> > >
> > > On Mon, 28 Oct 2024 at 12:23, Marc Zyngier <maz@kernel.org> wrote:
> > > >
> > > > > Let's start a discussion about what needs to be done to support this on
> > > > > arm64.
> > > >
> > > > A good start would be to define the semantics of such a flag:
> > > >
> > > > - what should it affect? the vcpu you are single-stepping? all vcpu?
> > > >
> > > > - should userspace to know that interrupts are pending?
> > > >
> > > > - should this result in any effect on the guest's view of time?
> > > >
> > > > - what of interactions on the rest of the system (such as devices)?
> > > >
> > >
> > > Sorry to give a handwavy answer here, but approaching this from a
> > > usability PoV (like what Puranjay is doing), it is really about
> > > adhering to the principle of least surprise for the user.
> > >
> > > So in that sense, it is not really about blocking IRQs at all, as long
> > > as we step over them rather than into them. How that is achieved is
> > > not that relevant from the user PoV, and maybe KVM_GUESTDBG_BLOCKIRQ
> > > is not the right solution for ARM at all.
> >
> > I definitely sympathise with the goal, but there is no simple way to
> > let interrupts through while stepping (which is what your "step over"
> > implies):
> >
> > - the hypervisor (in general) doesn't interact with the guest delivery
> >   and handling of interrupts -- this is either very opaque (list
> >   registers) or completely invisible (direct injection)
> >
> > - replacing the step with a breakpoint after the stepped instruction
> >   requires us to decode the guest instructions to handle branching
> >   effects
> >
> 
> Yeah, and we still want to take non-IRQ/FIQ exceptions, so this does
> not seem feasible to me.
> 
> > One possible mechanism would be to:
> >
> > - while stepping, add breakpoints to the interrupt vectors for the EL
> >   we are stepping (3 breakpoints for any of the 4 possible exception
> >   groups),
> >
> > - when any interrupt breakpoint hits, clear all 3, place a breakpoint
> >   on the instruction that was about to be single-stepped (pointed to
> >   by SPSR)
> >
> > - run to completion, until the breakpoint hits
> >
> > - disable the breakpoint, reinstall the previous 3 interrupt
> >   breakpoints
> >
> > - single-step, rinse, repeat
> >
> > But then I'm asking myself the question: why is this KVM's job? It
> > seems to me that this is what an external debugger would do when
> > interacting with HW on bare metal.
> >
> > So can we implement this as part of the debugger's state machine?
> >
> 
> Which debugger is that? The GDB stub in QEMU?
> 
> Setting a one-shot breakpoint on the address in SPSR when taking an
> IRQ exception seems like a reasonable approach to me.

That doesn't work; an IRQ could be taken in the middle of a common
helper that's also used in IRQ context, so you'd take the breakpoint
within the IRQ. You could try to match a bunch of things like the SP and
so on, but that boils to do a bunch of heuristics rather than something
that's guarnateed to work...

More generally, the IRQ can preempt the running thread anyway, so:

* The user cannot use this to trace a kernel thread reliabl , since that
  can be switched out behind their back.

* The user cannot use this to trace a CPU regardless of the running
  thread, since they lose anything that happens under an IRQ.

Mark.
