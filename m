Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B17FF33EB1A
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 13:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788527805; cv=none; b=iMO+6lm5qVfdm1TjQ/bXkBA99KS8lDX6uKqeA3Sh8/jqCGIOiXRY9/+2YDaMeUhnrQdDPcukof5xs7NqLuk01PHZ5aomPqSDI/nHx2CvK4FgsAtni515xvHyOm0iqjs5DjtXrVfh7xzZB9NKfATE+wQ2q8mJqRF0/S5yt7ntu+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788527805; c=relaxed/simple;
	bh=jGO6N6C9dHP5Vlqz2T7loYjP445aFxsAjEvjgUvOSyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=qPNiMJmX7ZEaO/0oGbu0yQLw84eM8ESprBqNYe1d5Y9YXQv+PcUxBhDIdi50S1IXz/AQqY3mLvZ2dUzVfwX/3eudbIsKJ9AnLWvM6RBAyQG61r2dcxOvq29mvOg2BcNb8MVBgid3FOBbwApvioC1F3NlNG1vQltL5yUP/ZdPPJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=oQNKfnKw; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="oQNKfnKw"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 37080143D;
	Fri,  4 Sep 2026 06:16:39 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A8C783F7D8;
	Fri,  4 Sep 2026 06:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788527802; bh=jGO6N6C9dHP5Vlqz2T7loYjP445aFxsAjEvjgUvOSyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oQNKfnKwxRaaYoQL4lGr18lijYfEXLNJOiDyN8WLlo3ZT1dhN6UD2girIrq0ZkKCp
	 8x7NcoIkjKNUYSYPu0DN0aH2aF4Sr0JwoBF5dVZ3Djy/Xe+4dkGmvDGHSCGcpGUyiy
	 JS0mUsgBPhVldtu6okwQyRSMxfhNb0H5W4A7YDpQ=
From: Leonardo Bras <leo.bras@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Peter Maydell <peter.maydell@linaro.org>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v20 06/14] KVM: arm64: Validate GCS exception lock when emulating ERET
Date: Fri,  4 Sep 2026 14:16:34 +0100
Message-ID: <aprEsh-xogu8zFnK@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <2dfd8a6c-42c2-466c-b3d6-2313466fc3d5@sirena.org.uk>
References: <20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org> <20260901-arm64-gcs-v20-6-f31750bdfadb@kernel.org> <apmUQETDlhTIuJIY@LeoBrasDK> <2dfd8a6c-42c2-466c-b3d6-2313466fc3d5@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Sep 03, 2026 at 08:22:44PM +0100, Mark Brown wrote:
> On Thu, Sep 03, 2026 at 04:37:37PM +0100, Leonardo Bras wrote:
> > On Tue, Sep 01, 2026 at 10:47:04PM +0100, Mark Brown wrote:
> 
> > > +	return vcpu_read_sys_reg(vcpu, GCSCR_EL2) & GCSCR_ELx_EXLOCKEN;
> > > +}
> 
> > The above perfectly translates the GCS part of IllegalExceptionReturn().
> 
> > It's a nit, as I suppose there should be no compiler warning on that, but
> > the function should return a bool, and the last return line returns an u64.
> 
> > Maybe adding a "return !!()" would be better?
> 
> There's no need to manually do translations like that in C, the
> conversion of 0 to false and any non-zero value to true when an
> integer is used in a boolean context is in the standard.
> 

Yeah, I am aware the conversion will happen anyway, but I remember someone 
complaining about something like this in the past, that's why I sent as a 
nit. 

> > >  	 * - trying to return to EL1 with HCR_EL2.TGE set
> > > +	 * - GCSCR_ELx.EXLOCKEN is 1 and PSTATE.EXLOCK is 0 when attempting
> > > +	 *   to return from ELx the same EL.
> > >  	 */
> > >  	if (mode == PSR_MODE_EL3t   || mode == PSR_MODE_EL3h ||
> > >  	    mode == 0b00001         || (mode & BIT(1))       ||
> > >  	    (spsr & PSR_MODE32_BIT) ||
> > > +	    kvm_check_illegal_exlock_return(vcpu, spsr) ||
> > >  	    (vcpu_el2_tge_is_set(vcpu) && (mode == PSR_MODE_EL1t ||
> > >  					   mode == PSR_MODE_EL1h))) {
> > >  		u64 mask;
> > 
> > In IllegalExceptionReturn(), the GCS-related clause happens at the end, and 
> > here it happens before the TGE one. Could this cause any weird behavior in 
> > the future?
> > 
> > I get that by doing like this you don't change the last line of the "if", 
> > but I wonder if that could change anything.
> 
> Given that we take the same action regardless of which or clause
> triggers I can't see how it would matter.

I see... well, as long as neither test ever have any collateral effect, I 
think it should not matter, then.

> 
> > > --- a/arch/arm64/kvm/hyp/vhe/switch.c
> > > +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> > > @@ -383,6 +383,10 @@ static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
> > >  		return false;
> > >  	}
> 
> > > +	/* Push GCS exception lock failures into the slow path */
> > > +	if (kvm_check_illegal_exlock_return(vcpu, spsr))
> > > +		return false;
> 
> > >  	/* If ERETAx fails, take the slow path */
> > >  	if (esr_iss_is_eretax(esr)) {
> > >  		if (!(vcpu_has_ptrauth(vcpu) && kvm_auth_eretax(vcpu, &elr)))
> 
> > IIUC, this function will be called on the __kvm_vcpu_run_vhe() inner loop, 
> > in the cases where the guest exited due to a eret. 
> 
> > What you change here is that in case of an illegal exlock return, it goes 
> > out of the loop and return to host kernel, probably to deal with it in the 
> > mentioned slowpath, the same way the ERETAx entry does.
> 
> > I don't question on this being needed. 
> > I would just like to understand why this is needed here. 
> 
> > This does not seem to be related to nested, as this is called in 
> > __fixup_guest_exit() and not in fixup_nv_guest_exit(). But would not 
> > hardware be responsible for cheking this, then?
> 
> The code is here because it's part of the ERET handling, this should
> only happen for NV as we're not trapping ERET instructions otherwise.

Oh, makes sense!

> We need this because ERETs from vEL2 are handled in software, modulo the
> NV3 fast path mentioned at the top of the function.

Oh, and this is done in __fixup_guest_exit() because vEL2 is not a 
nested guest. It would be it's guests' exit that would be dealt in 
fixup_nv_guest_exit().

Is this correct?

Thanks!
Leo
