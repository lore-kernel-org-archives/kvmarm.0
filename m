Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BA4835505E
	for <kvmarm@lists.linux.dev>; Mon, 12 Jan 2026 11:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768217190; cv=none; b=Ka/LukIW/GZNr8pZbo3c3mYWoUjAQNnaAAuN8wvFpphp9zGU85WGQIl+mtXo5yUIm41hkxpEJ8tECOYE/vgpib/C9y64BJKVYklu2SQvN58skVMue7aSUtfgWvHuUp9DvRxUFHH61SzLD4RiNoBFZiS8yw1SUKWKRJsiy7WT6oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768217190; c=relaxed/simple;
	bh=mxYgczMoZd1gWVT4OVPn8KIQGpCIPfjrsKoSOFWtEgc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nPyn0xJsC4qGL96iM/3sY271ytzXQqnBDE3cWh2O62cWDI6RiDYdiCCQcggPrDEH9yRmMe0EhH7h3hy31YeYdT6lZE0Mj+qbj8XW2fGmn1AyfvXluEU1jtg1mghYJ8CQpURe11DIh5Y9KDH0+j1myp9qMOk0ZMtkQbvZR9+zhLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3C562497;
	Mon, 12 Jan 2026 03:26:19 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D0FE63F694;
	Mon, 12 Jan 2026 03:26:23 -0800 (PST)
Date: Mon, 12 Jan 2026 11:26:20 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: James Clark <james.clark@linaro.org>
Cc: mark.rutland@arm.com, james.morse@arm.com, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [RFC PATCH v6 03/35] KVM: arm64: Add CONFIG_KVM_ARM_SPE Kconfig
 option
Message-ID: <aWTaXBse_R_LjJE-@raptor>
References: <20251114160717.163230-1-alexandru.elisei@arm.com>
 <20251114160717.163230-4-alexandru.elisei@arm.com>
 <1aaffbcd-ba0c-4371-80d7-ce59ac7f13a9@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1aaffbcd-ba0c-4371-80d7-ce59ac7f13a9@linaro.org>

Hi James,

On Fri, Jan 09, 2026 at 04:29:50PM +0000, James Clark wrote:
> 
> 
> On 14/11/2025 4:06 pm, Alexandru Elisei wrote:
> > Add a new configuration option that will be used for KVM SPE emulation.
> > CONFIG_KVM_ARM_SPE depends on the SPE driver being builtin because:
> > 
> > 1. The SPE driver maintains a cpumask of physical CPUs that support SPE,
> >     and that will be used by KVM to emulate SPE on heterogeneous systems.
> > 
> > 2. KVM will rely on the SPE driver enabling the SPE interrupt at the GIC
> >     level.
> > 
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > ---
> >   arch/arm64/kvm/Kconfig | 8 ++++++++
> >   1 file changed, 8 insertions(+)
> > 
> > diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> > index 4f803fd1c99a..31388b5b2655 100644
> > --- a/arch/arm64/kvm/Kconfig
> > +++ b/arch/arm64/kvm/Kconfig
> > @@ -83,4 +83,12 @@ config PTDUMP_STAGE2_DEBUGFS
> >   	  If in doubt, say N.
> > +config KVM_ARM_SPE
> > +	bool
> > +	depends on KVM && ARM_SPE_PMU=y
> 
> I think the most common configuration is module, so requiring built-in isn't
> great. If there's any way of avoiding it, even if it costs a little bit of
> pain, it would be good for adoption.

I'm not sure how that could be done. You need the buffer maintenance interrupt
to do a VM exit so KVM can inject the virtual interrupt back into the guest,
otherwise there's a possibility of a large blackout window when the buffer is
full.

The code also relies on the SPE driver to probe all the SPUs in the system.

> 
> It was basically the first thing I got stuck on trying to get it to work. Or
> if it really can't be done, maybe some kind of debug message to say why
> enabling failed.

When you search for the symbol in menuconfig you get a list of the symbols it
depends on.

Thanks,
Alex
