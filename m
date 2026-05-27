Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD6BF313552
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 13:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779889884; cv=none; b=O+5ael9Hi9GtZFtRp0csskVxQ9pehT6HcqiLjGdW03lmFlqi7u9V2uI2yRU1eG8X0VN2fvyBjMfnewQH0hWFXXFMQLi3egFEajCE3Uz/ZOzWgdm/1Xq5fJGLyKtxYHgVPR+0Gb1TF8UDkEOzqqrIuuDPAPAN9Nc+gx3jFv719As=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779889884; c=relaxed/simple;
	bh=V3HB6iLMVHAA7gn4GBr6f7/tZojBIfmMAzZbcfC/w9g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y8U3yJrYpDAGVDbAuRVuJbcRLSSnc3doE+KR8STR8No/l2B+BJS4aMunV+gMTbMM+9Ndlr9Pm2NWhln3c7x3GMgt5OyfHtsz8yl9BunJXCyqs9OUcBHb1SVjG+ktB2tKq9ptfrQfl4BGeRYZ1kDBs7uPvLm2DaC3c3WAlGXqanw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Vwat4lPY; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Vwat4lPY"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ED6BD1476;
	Wed, 27 May 2026 06:51:16 -0700 (PDT)
Received: from J2N7QTR9R3.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BF79E3F632;
	Wed, 27 May 2026 06:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779889882; bh=V3HB6iLMVHAA7gn4GBr6f7/tZojBIfmMAzZbcfC/w9g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Vwat4lPYs2jzHm7qrJLrAOOcOPT/JD6y2gRKek1AMOL1wD2IajIQ4O+CjkLHy6bbK
	 cg9RbjgvugQ5N7hZZ3ZHH8DOekk/cGr3eqc9eMe97umlJmaU9JxKg2maTZAzcO/lFw
	 A2LgmLjExxkKEq12p7lSSWjpyeYjC9ILi8WGER3Y=
Date: Wed, 27 May 2026 14:51:13 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	catalin.marinas@arm.com, james.morse@arm.com, maz@kernel.org,
	oupton@kernel.org, tabba@google.com, will@kernel.org
Subject: Re: [PATCH 11/18] arm64: fpsimd: Split FPSR/FPCR from SVE
 save/restore
Message-ID: <ahb20fXkdWI7SljE@J2N7QTR9R3.cambridge.arm.com>
References: <20260521132556.584676-1-mark.rutland@arm.com>
 <20260521132556.584676-12-mark.rutland@arm.com>
 <0b72df66-2914-4537-811e-2080e0a7ce6c@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b72df66-2914-4537-811e-2080e0a7ce6c@sirena.org.uk>

On Tue, May 26, 2026 at 05:28:21PM +0100, Mark Brown wrote:
> On Thu, May 21, 2026 at 02:25:49PM +0100, Mark Rutland wrote:
> > Regardless of whether the vector registers are saved in FPSIMD or SVE
> > format, we store FPSR and FPCR in user_fpsimd_state::{fpsr,fpcr}.
> 
> ...
> 
> > Note that the SVE assembly sequence for restoring FPCR uses an
> > unconditional write to FPCR. The plain FPSIMD assembly sequence has used
> > a conditional write to FPCR since 2014 in commit:
> 
> >   5959e25729a5 ("arm64: fpsimd: avoid restoring fpcr if the contents haven't change")
> 
> > ... but this was not followed for the SVE restore assembly implemented
> > in 2017 in commit:
> 
> >   1fc5dce78ad1 ("arm64/sve: Low-level SVE architectural state manipulation functions")
> 
> > ... so I've assumed that this doesn't actually matter in practice, and
> > implemented the C version matching the existing SVE assembly.
> 
> > For the moment, fpsimd_save_state() and fpsimd_load_state() are left
> > as-is with their own logic to save/restore FPSR and FPCR. This will be
> > unified in subsequent patches.
> 
> There is a possibility that it only matters for older, FPSIMD only CPUs
> or just that nobody got round to benchmarking this on physical CPUs with
> SVE and in fact a similar optimisation is also useful there.

All of that might be true, but that doesn't change my assessment that
this doesn't seem to matter in practice, and given that the overall goal
of this series is to *simplify* things, I'd much rather err towards that
than hypothetical performance concerns.

> I'm a bit wary of dropping the optimisation without any verification
> of the performance impact, but equally I'm not aware of a specific
> benchmark that showed the impact or even if there was one in the first
> place.  The changelog sounds like the optimisation might've been
> written based on inspection alone, I don't know if anyone will
> remember more than a decade later.

From what I remember, the changes in commit 5959e25729a5 were made based
on intuition, inspired by a contemporary retrospective change to the
architecture that made FPCR self-synchronizing. Previously the
architecture required a context synchronization event for the write to
take effect, but implementations happened to be stronger.

The conditional write isn't necessarily a win, because the cost of
recovering from a branch mispredict can be much larger than the cost of
micro-architectural mechanisms to ensure that FPCR is
self-synchronizing.

> Having said all that given that a conditional update is simple to
> implement in C it seems safer to add one in the SVE path than to drop
> it from the FPSIMD path.

I agree that if we need to, it would be simple to add this.

For now I'm going to leave this as-is given the rationale I originally
provided. This patch specifically doesn't change the existing behaviour.
I don't think this matters in practice, we haven't consistently applied
this approach to FPCR (or other similar registers), and omitting this
makes the code simpler.

Mark.
