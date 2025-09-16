Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 374B91AF0C8
	for <kvmarm@lists.linux.dev>; Tue, 16 Sep 2025 14:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758031636; cv=none; b=oEfh/l9lWNIo20rxUwkEhrA3fPThZAzJcQDLISqC0T0D5gRpmbn0zMqKuVuuQSRQAbtDt1Kw0p0AtnkZABpwU7EgE4baftQ0cQ5b258SFvB0mJ6ja4FSxr604mPVTCycaQSxb1R4nVrCHpc0XWWIoIoHlZsDYA5wokbGQIGBJg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758031636; c=relaxed/simple;
	bh=7vrhZPbTy9gLpWWnY7JTBlKr31wIbsl3yl8ZjXJHZrQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DlWc/gbjhh8H8sOL1Jwa4Zrvfu1E7TCo+qMxsSkxXzC4Bel3SCbJlx611Tq85R1xVlRjlCDZyrW7izHAUtsQHNxSaoh3Pn2w//tBOVnUD4brM0XW4V73eDzLkD6LGk/I3SWn5WXTJqAeVShrSrS2e+g03tFAFnP8XtUNPsF+7mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 41CB712FC;
	Tue, 16 Sep 2025 07:07:06 -0700 (PDT)
Received: from J2N7QTR9R3.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DD6B43F673;
	Tue, 16 Sep 2025 07:07:11 -0700 (PDT)
Date: Tue, 16 Sep 2025 15:07:09 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, broonie@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, james.morse@arm.com,
	ardb@kernel.org, scott@os.amperecomputing.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v7 4/6] arm64: futex: refactor futex atomic
 operation
Message-ID: <aMlvDVfeztaVyOnL@J2N7QTR9R3.cambridge.arm.com>
References: <aMRQIeIdyiWVR8a0@arm.com>
 <aMfrR0vserl/hfZ3@e129823.arm.com>
 <aMhrscd1gz_syMtL@arm.com>
 <aMh4q4-xAPHnaOul@willie-the-truck>
 <aMkLb6jPiSbzeRWL@arm.com>
 <aMk1qxS3htyaTgEQ@e129823.arm.com>
 <aMlcf5oUNZU65u_I@J2N7QTR9R3.cambridge.arm.com>
 <aMllyaObyciHEEFX@e129823.arm.com>
 <aMlp_Covl57nnVoe@J2N7QTR9R3.cambridge.arm.com>
 <aMls+MSR33BRrCMA@e129823.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMls+MSR33BRrCMA@e129823.arm.com>

On Tue, Sep 16, 2025 at 02:58:16PM +0100, Yeoreum Yun wrote:
> Hi Mark,
> 
> [...]
> > > I think it's enough to use usafe_get_user() instead of get_user() in here
> > > since when FEAT_LSUI enabled, it doeesn't need to call
> > > uaccess_ttbr0_enable()/disable().
> >
> > Regardless of uaccess_ttbr0_enable() and uaccess_ttbr0_disable()
> > specifically, API-wise unsafe_get_user() is only supposed to be called
> > between user_access_begin() and user_access_end(), and there's some
> > stuff we probably want to add there (e.g. might_fault(), which
> > unsafe_get_user() lacks today).
> >
> > Do we call those?
> 
> Yes when you're available.
> As you mention, the difference seems might_fault(),
> But I'm not sure whether that would be a reason to validate to use
> get_user() instead of unsafe_get_user() taking a increase of instruction
> of "nop" -- uaccess_ttbr0_enable()/disable() in LSUI
> except the reason for DEUBG purpose.

I think the practical impact of those NOPs is going to be neglible, and
not worth optimizing for unless/until we have data demonstrating
otherwise.

If we want to strictly avoid those NOPs, I think that we should do a
more general cleanup, and e.g. have variants of user_access_begin() and
user_access_end() that do not mess with TTBR0. I don't think we need to
do that for this series.

For now, I think that you should either:

* Use get_user().

* Use user_access_begin() .. user_access_end() wrapping both
  unsafe_get_user() and the user cmpxchg.

Thanks,
Mark.
