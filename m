Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B49221E86F
	for <kvmarm@lists.linux.dev>; Mon,  8 Jul 2024 15:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720452640; cv=none; b=JmrYUnFK2Py8Y38FzVcfAnWyJI/5qDo40mCthwjtMlAhD7bTEW/sSToULs47dwg5acCvl79dK00bMOPRd99ult8QkS35A/Jc7ihw4laJo3HflZGZ0P+vk0I6pANUFphimmElb6DyeO3U4dbC3eSK2J76+EpVZs5tknWyj9L031g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720452640; c=relaxed/simple;
	bh=dQTtY3SoxZiiFNuasIQ2nT+tyAbwIFDezaf6yGDD4RA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dcMqoNlmYohaZ2yKE5LeskbWNSTpQ1TItIbSZRRhzCuflaDv68oYcZRWKB6aAjrhf/gjYOUSjtD/lZO9R220cFaSbx4ejXba2Wy77t4tatBI771y/4N5e/tCNIOojdciiv/f7GzqilldjovfA1OXKykb/4Oje6Pr5VR41+hPrSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EABE21042;
	Mon,  8 Jul 2024 08:31:02 -0700 (PDT)
Received: from e133380.arm.com (e133380.arm.com [10.1.197.55])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0ABAF3F641;
	Mon,  8 Jul 2024 08:30:35 -0700 (PDT)
Date: Mon, 8 Jul 2024 16:30:30 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v4 0/4] KVM: arm64: Fix underallocation of storage for
 SVE state
Message-ID: <ZowGFl/1AEuevh96@e133380.arm.com>
References: <20240704-kvm-arm64-fix-pkvm-sve-vl-v4-0-b6898ab23dc4@kernel.org>
 <86a5iw3ri2.wl-maz@kernel.org>
 <fec60c7f-0cc3-44e2-8be1-09c120e8523e@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fec60c7f-0cc3-44e2-8be1-09c120e8523e@sirena.org.uk>

Hi all,

On Fri, Jul 05, 2024 at 06:18:50PM +0100, Mark Brown wrote:
> On Fri, Jul 05, 2024 at 02:20:05PM +0100, Marc Zyngier wrote:
> > Mark Brown <broonie@kernel.org> wrote:
> 
> > > As observed during review the pKVM support for saving host SVE state is
> > > broken if an asymmetric system has VLs larger than the maximum shared
> > > VL, fix this by discovering then using the maximum VL for allocations
> > > and using RDVL during the save/restore process.
> 
> > I really don't see why we need such complexity here.

The first patch is orthogonal cleanup, and the rest doesn't really add
complexity IIUC.

> > Fuad did post something[1] that did the trick with a far less invasive
> > change, and it really feels like we are putting the complexity at the
> > wrong place.
> 
> > So what's wrong with that approach? I get that you want to shout about
> > secondary CPUs, but that's an orthogonal problem.
> 
> As I've said from a clarity/fragility point of view I'm not happy with
> configuring the vector length to one value then immediately doing things
> that assume another value, even if everything is actually lined up
> in a way that works.  Having uncommented code where you have to go and
> check correctness when you see it isn't great, seeing an inconsistency
> just raises alarm bells.  It is much clearer to write the code in a way
> that makes it obvious that the VL we are using is the one the hardware
> is using, for the host save/restore reading the actual VL back seemed
> like the most straightforward way to do that.
> 
> A similar thing applies with the enumeration code - like I said in reply
> to one of Fuad's postings I originally wrote something that's basically
> the same as the patch Faud posted but because it is not consistent with
> the surrounding code in how it approaches things it was just raising
> questions about if the new code was missing something, or if there was
> some problem that should be addressed in the existing code.  Rather than
> write an extensive changelog and/or comments covering these
> considerations it seemed more better to just write the code in a
> consistent manner so the questions aren't prompted.  Keeping the
> approach consistent is a bit more code right now but makes the result
> much easier to reason about.
> 
> The late CPUs thing is really just an answer to the initial "why is this
> different, what might we have missed?" question rather than a particular
> goal itself.  Adding a warning is as much about documenting the handling
> of late CPUs as it is about highlighting any unfortunate implementation
> choices we run into.
> 
> Basically it's maintainability concerns, especially with the enumeration
> code.

I tend to agree here.

It's probably best to stick to one convention everywhere about how the
SVE regs are laid out for a given VL.  There's nothing wrong with Fuad's
fixed sve_ffr_offset(), but it's different from the VL-dependent offset
already used elsewhere and so risks causing confusion further down the
line.


One thing confuses me:

The host could never use over-max VLs except in non-preemptible kernel
code, since code doing that would be non-migratable to other physical
CPUs.  This is done to probe SVE only, and the extra bits in the vector
registers are never used at all.

Can't pKVM just hide the non symmetrically supported VLs using ZCR_EL2,
just as regular KVM does for the guest?

(I may be making bad assumptions about pKVM's relationship with the host
kernel.)

Cheers
---Dave
