Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75E2835E1AE
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 15:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784906184; cv=none; b=NA96Lyw/Ps7XbszMSdbeCMVCcV8wRVB8raEPZEIey/PSH98jxAYGDzlVvxSH+nFP5/LBFY/+5nAjzyfmOoM/HtvW2OhijdD4sekC+/EgYJJ7Lx43Y/vsJsj00gyu0pJ481A9G5TvWSoPo/WY6bwtGMpGhwM7SqVpa1OjRPuisw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784906184; c=relaxed/simple;
	bh=rKKnjZ1tIKtzJ6HBpjgLc0Ck9asCrea4HP6d5oTMlaE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uhXTBd7rlSgbdtfgWojWXBuHS1cXHtXKHsnihrfHBxDnTwYV+2tVbvmZx1jZqH2gswAgPoqnmm4pt0yULlqKiqoEml+xVeQ16JeASC2Q/BXKfKjvNfx/qRPzQDixLJFCiBESoFAXhS4+VxddkLdapB7HwZlEXRmUsI5xd5qsipY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=gf3AIoOd; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="gf3AIoOd"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0FF661477;
	Fri, 24 Jul 2026 08:16:17 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 575F73F59E;
	Fri, 24 Jul 2026 08:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784906181; bh=rKKnjZ1tIKtzJ6HBpjgLc0Ck9asCrea4HP6d5oTMlaE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gf3AIoOdSgamjrSz8hHhDZKsUxu/dPE6rojytFhMlLNhMsaKk9o5MxNShE2E6XIxI
	 tcbXXxM6RsEEIQxsdv0tHTlswHgO3YdYm3jnFrpON/Cb0/Iqgu7obS+gT/ysP/ay/7
	 FlJmYEC+lZ9Cbn2OxpdtuBok6Nn9BerpTCPKwdzA=
Date: Fri, 24 Jul 2026 16:16:11 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>,
	Fuad Tabba <tabba@google.com>, Ben Horgan <ben.horgan@arm.com>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v13 02/32] arm64/fpsimd: Ensure all of ZCR_EL1 is
 initialised from idle
Message-ID: <amOBu-SfzZM7M5Oh@J2N7QTR9R3>
References: <20260720-kvm-arm64-sme-v13-0-d9abd3ffa245@kernel.org>
 <20260720-kvm-arm64-sme-v13-2-d9abd3ffa245@kernel.org>
 <amIP42yILYNsNk0e@J2N7QTR9R3.cambridge.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amIP42yILYNsNk0e@J2N7QTR9R3.cambridge.arm.com>

On Thu, Jul 23, 2026 at 01:58:11PM +0100, Mark Rutland wrote:
> On Mon, Jul 20, 2026 at 12:07:29AM +0100, Mark Brown wrote:
> > At present when exiting from idle we do not fully reinitialise ZCR_EL1,
> > we update ZCR_EL1.LEN with a read/modify/write cycle when loading task
> > state but never set any of the other bits to an explicit value.  Since
> > currently they are all architecturally RES0 or RAZ/WI this is not a
> > practical issue but it may become one if further fields are defined in
> > the register so we should explicitly configure the whole register.
> >
> > Rename the existing sme_suspend_exit() (which handles this for SME) to
> > fpsimd_suspend_exit() and add set ZCR_EL1 to 0 there, if needed LEN will
> > be updated when loading task state.
> >
> > Signed-off-by: Mark Brown <broonie@kernel.org>
> 
> While this happens to work today, this is a more general architecture
> problem, and I think we should cc stable such that kernels will work
> reliably on future hardware.
> 
> All stable kernels support SVE, so this needs to go as far back as
> v5.10.y.
> 
> One minor comment below, but with that fixed up (and a CC stable):
> 
> Acked-by: Mark Rutland <mark.rutland@arm.com>

Sorry, having looked at some of the later patches I think this isn't
quite right even with those changes, as we wouldn't have necessary
context synchronization in all cases.

I'll need to dig a bit more to come up with a more concrete solution.

Mark.

> > +void fpsimd_suspend_exit(void)
> >  {
> >  	u64 smcr = 0;
> >  
> > -	if (!system_supports_sme())
> > -		return;
> > +	if (system_supports_sve())
> > +		write_sysreg_s(0, SYS_ZCR_EL1);
> >  
> > -	if (system_supports_fa64())
> > -		smcr |= SMCR_ELx_FA64;
> > -	if (system_supports_sme2())
> > -		smcr |= SMCR_ELx_EZT0;
> > +	if (system_supports_sme()) {
> 
> We should move the 'smcr' variable into this block. That way it's scoped
> to where it matters.
> 
> > +		if (system_supports_fa64())
> > +			smcr |= SMCR_ELx_FA64;
> > +		if (system_supports_sme2())
> > +			smcr |= SMCR_ELx_EZT0;
> >  
> > -	write_sysreg_s(smcr, SYS_SMCR_EL1);
> > -	write_sysreg_s(0, SYS_SMPRI_EL1);
> > +		write_sysreg_s(smcr, SYS_SMCR_EL1);
> > +		write_sysreg_s(0, SYS_SMPRI_EL1);
> > +	}
> >  }
> 
> Mark.
> 
