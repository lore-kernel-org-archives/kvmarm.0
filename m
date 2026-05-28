Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90B6B2475F7
	for <kvmarm@lists.linux.dev>; Thu, 28 May 2026 16:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779984922; cv=none; b=ME8ziw/nVmUQ64l92zoyvtWjNhoyKp4InfWtnEoq7z3jVq6AFX5JkoptF2OB9nght4KCcrEKwrfBFXqbizYuJofPgi5w9SXELyVnRmQewmRBku/Qox4ddcT1tbcA2KlHRbEuYI99+dq6notyd02NaZCAJ5nRl0yV89LLIKQAVyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779984922; c=relaxed/simple;
	bh=OyK3X5e+Jhr/rucK+64U5W5SFILTwa7dTGV6a4I+o/s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EKDO5BFEWjOAEwh1Jl9VMCsMWSF7Fq71GJTAp0cU7QGj+IzJqRxmTfOLmTjysqXwGM00l5aksT8GJzv2Ge3soV8ktSUfJ4gOCng/OTK9hCy3yq3G9rhYuZtlG9zDMpJKld5gUVLLRNrzyWL1kngiQmawN9zXLOcFTWKM1/pT1lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XguVli3r; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XguVli3r"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EC59922EE;
	Thu, 28 May 2026 09:15:15 -0700 (PDT)
Received: from J2N7QTR9R3.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B71573F905;
	Thu, 28 May 2026 09:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779984921; bh=OyK3X5e+Jhr/rucK+64U5W5SFILTwa7dTGV6a4I+o/s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XguVli3rvLsVZObkksEwKLQr02pz/cMuUFg9r1ZA9V0cnJB3PmSaT1RNe/gKuyFgQ
	 p329VRvop7Hpl+R3GmJzoXO0jbHAWMSoLtm/pbTbVEwzCYLPSW5QNz+Kv+JN4B3J1D
	 seMMN7903aclPs8IRFc8OpcGRWDCZMkC/4RWr8p8=
Date: Thu, 28 May 2026 17:15:14 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	catalin.marinas@arm.com, james.morse@arm.com, maz@kernel.org,
	oupton@kernel.org, tabba@google.com, will@kernel.org
Subject: Re: [PATCH 12/18] arm64: fpsimd: Move fpsimd save/restore inline
Message-ID: <ahhqEs1DhShRpgXF@J2N7QTR9R3.cambridge.arm.com>
References: <20260521132556.584676-1-mark.rutland@arm.com>
 <20260521132556.584676-13-mark.rutland@arm.com>
 <0f666889-fabe-4cdd-9fd2-d87808329dbd@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f666889-fabe-4cdd-9fd2-d87808329dbd@sirena.org.uk>

On Tue, May 26, 2026 at 05:44:26PM +0100, Mark Brown wrote:
> On Thu, May 21, 2026 at 02:25:50PM +0100, Mark Rutland wrote:
> 
> > Note that I've used the SVE sequence for restoring FPCR, which uses an
> > unconditional write to FPCR. The plain FPSIMD assembly sequence used a
> > conditional write to FPCR since 2014 in commit:
> 
> >   5959e25729a5 ("arm64: fpsimd: avoid restoring fpcr if the contents haven't change")
> 
> > ... but this was not followed for the SVE assembly implemented in 2017
> > in commit:
> 
> >   1fc5dce78ad1 ("arm64/sve: Low-level SVE architectural state manipulation functions")
> 
> > ... so I've assumed that this doesn't actually matter in practice, and
> > I've erred in favour of the simpler sequence.
> 
> As I said on the earlier patch I'm a bit nervous about assuming this
> doesn't matter for anyone without verifying (though I wouldn't be
> surprised if that turned out to be the case) but that's internal to that
> patch and this is obviously a great improvement so:
> 
> Reviewed-by: Mark Brown <broonie@kernel.org>

Based on that discussion on the last patch, I've updated the commit
message for this patch say:

  I've used the SVE sequence for restoring FPCR, which uses an
  unconditional write to FPCR, rather than the conditional write used by
  the FPSIMD assembly sequence. I believe that in practice, this doesn't
  matter to a real workload, and given it's possible for the
  mis-predicted branch to cost more than the necessary
  micro-architectural synchronization, I strongly suspect any
  performance impact is within the noise. 
  
  Looking at the history, the FPSIMD assembly sequence was changed to
  use a conditional write to FPCR since 2014 in commit:
  
    5959e25729a5 ("arm64: fpsimd: avoid restoring fpcr if the contents haven't change")
  
  ... as described in the commit message, this was based on an
  expectation of implementation style, and was not based on
  benchmarking.

Mark.
