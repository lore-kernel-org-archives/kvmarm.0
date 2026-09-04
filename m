Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38C2E3F1AB7;
	Fri,  4 Sep 2026 14:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788530983; cv=none; b=hAbPi9FAtedG0CKf37JQdH0b9ErCmuXZYADSunGMsOCKsr8wGmBvSYi+t9CaAuIVH6tGh+xrrmPRdbTMjRbwDVUxG7tZ+L8Gh5G8u6AgsSzm1GP8iAwrKnLmwEAWx2yukYfA3j4gFKxNeaJUR2JTIR8LuVFv1ivbLjshL9c/3FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788530983; c=relaxed/simple;
	bh=xL4I0S3mL/X6beKCto/ctHnwnQCOKF64QzQVs0JG5Dw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EkFvOxxspiYS0NDppV1F+XgCnypRwxzAl7j6Nj9YpBxz36J3JQNTzY6SxKpFFOFDNY6xK4zS5OCZDv7HVERGW6r32kWN9JSHuydCxbbXH7MRs3AW/sXzNKWyUezVWgsDmnJXB/TocsgKLIkBx2NfVvPFFfl3t0DfXpHKIkJOR0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=pKjysfkh; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="pKjysfkh"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E4F0F152B;
	Fri,  4 Sep 2026 07:09:37 -0700 (PDT)
Received: from e140010.arm.com (unknown [10.57.70.12])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8E69A3F673;
	Fri,  4 Sep 2026 07:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788530981; bh=xL4I0S3mL/X6beKCto/ctHnwnQCOKF64QzQVs0JG5Dw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pKjysfkhC6ANFjeYEGxYb3oG44S+dSlQumnNkOPGPMiZbv7xozn4rPFO79g4g+rp7
	 P6uSQKp9hXpR7cG31M2Z8zbBnZy6BwtNzVbhKpzh59olOu0HWnSlPATHjboO9wtpwU
	 e7WsoH0Uqbnnx1Z6izVseG/h2HVNHVn6tbiaZ6go=
Date: Fri, 4 Sep 2026 15:09:28 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>, linux-perf-users@vger.kernel.org
Subject: Re: [RFC PATCH v7 28/28] KVM: arm64: Allow the creation of a SPE
 enabled VM
Message-ID: <aprRGLAtoDpAXWCk@e140010.arm.com>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-29-alexandru.elisei@arm.com>
 <20260903165930.234811F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260903165930.234811F00A3D@smtp.kernel.org>

Hi Sashiko,

On Thu, Sep 03, 2026 at 04:59:29PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] The Kconfig dependency for `KVM_ARM_SPE` restricts it to 'n' when the `ARM_SPE_PMU` driver is built as a module, preventing users from enabling SPE virtualization.
> --
> 
> commit 9bb804f4572dd230ad3b5db909bd2001b3ee3186
> Author: Alexandru Elisei <alexandru.elisei@arm.com>
> 
> KVM: arm64: Allow the creation of a SPE enabled VM
> 
> This commit introduces the Kconfig option KVM_ARM_SPE to allow userspace
> to enable the Statistical Profiling Extension (SPE) for virtual machines.
> 
> [ ... ]
> 
> > diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> > --- a/arch/arm64/kvm/Kconfig
> > +++ b/arch/arm64/kvm/Kconfig
> > @@ -106,9 +106,9 @@ endif # NVHE_EL2_DEBUG
> >  
> >  
> >  config KVM_ARM_SPE
> > -	bool
> > +	bool "Support SPE in guest"
> >  	depends on KVM && ARM_SPE_PMU
> 
> [Severity: Medium]
> Does this Kconfig dependency unintentionally disable KVM_ARM_SPE when the
> host driver ARM_SPE_PMU is built as a module?

That contradicts my experience. Setting CONFIG_ARM_SPE_PMU=m makes
CONFIG_KVM_ARM_SPE selectable, and building Linux with CONFIG_ARM_SPE_PMU=m and
CONFIG_KVM_ARM_SPE=y enables the SPE KVM capability when the SPE module is
loaded, and disables the capability when the module is removed.

Thanks,
Alex

> 
> Because KVM_ARM_SPE is a boolean, if ARM_SPE_PMU is configured as a
> loadable module (=m), the Kconfig dependency evaluates to m. For a boolean
> config, this restricts its maximum value to n, effectively disabling the
> feature in the build configuration.
> 
> Since the implementation in arch/arm64/kvm/spe.c supports being built
> against a modular driver (using try_module_get()), should this dependency
> be relaxed or handled differently so the feature can still be selected?
> 
> > -	default n
> > +	default y
> >  	help
> >  	  Adds support for Statistical Profiling Extension (SPE) in virtual
> >  	  machines.
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260903160623.315525-1-alexandru.elisei@arm.com?part=28
