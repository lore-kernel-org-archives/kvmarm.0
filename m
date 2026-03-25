Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04AAC30594E
	for <kvmarm@lists.linux.dev>; Wed, 25 Mar 2026 17:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774461106; cv=none; b=aKDaKil8X/d9Ip0a7YnIzJ2QKRlDwh19sLxK4wWy+hpCzheAzLKcUNIvOnk7CcQl0QEiOU4lx/LkxwYTnOS1JcaneY6hrAoXe9NV/nRZIhZaUrk+eJ/nPXkLUE5yv7KvEp/qQDFVIkFPkHdBx+R041j7pL5aU8YZlgHMfmKJyoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774461106; c=relaxed/simple;
	bh=eyHFdRn6lnnq6+lCvCionMA4Nb++tb101R0MsbqPO8w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WASCu0BnTkqVcXpVj+aMc1yNRiDOeDdHy14HstEBTz5pvTsMbqO+UdxbRE3WNizJPSV/PYLC4b1S6zEz+OXvkB6aWiFukCQVPJEYzEesF7tSaFxEjB4PjzTfAm+ttNEBOi/Lwx21wvxYhJ9rOqTKIYsNGLBgAzc8DROi12ZMcuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=uzw9nsMr; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="uzw9nsMr"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2E0E92444;
	Wed, 25 Mar 2026 10:51:38 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CC8033F836;
	Wed, 25 Mar 2026 10:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774461104; bh=eyHFdRn6lnnq6+lCvCionMA4Nb++tb101R0MsbqPO8w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uzw9nsMrAWynoJtFLpCa/TUcYX/0f9tskJXQBeSJ+HaO/oOxxij0klbRy1ONBXGnE
	 Ewv0m9zqd7e9lcNBYGd7L/pESkasEwZrYk4zx68dv4N/cY5upC/HsEvFU218WccCqq
	 qWtbgxCz292RMALQFQs+nea5dMsRCAVoRbn8pbBo=
Date: Wed, 25 Mar 2026 17:51:39 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Joey Gouly <joey.gouly@arm.com>, Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 01/11] arm64: Skip update of an idreg field affected
 by an override
Message-ID: <acQgq4oNWP__3qvV@arm.com>
References: <20260302115653.1517326-1-maz@kernel.org>
 <20260302115653.1517326-2-maz@kernel.org>
 <abwXl35xQ2ze1XwJ@arm.com>
 <a35839df-74a0-46b3-b5e8-7e0a066b210d@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a35839df-74a0-46b3-b5e8-7e0a066b210d@arm.com>

On Wed, Mar 25, 2026 at 02:54:28PM +0000, Suzuki K Poulose wrote:
> On 19/03/2026 15:34, Catalin Marinas wrote:
> > On Mon, Mar 02, 2026 at 11:56:42AM +0000, Marc Zyngier wrote:
> > > When computing the new value od an idreg that contains a field
> > > affected by an override, do not update that particular field.
> > > 
> > > The value computed at init-time must be kept as-is, as that's
> > > what the user has asked for, for better or worse.
> > > 
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >   arch/arm64/kernel/cpufeature.c | 7 +++++++
> > >   1 file changed, 7 insertions(+)
> > > 
> > > diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> > > index c31f8e17732a3..28fc77443ccd3 100644
> > > --- a/arch/arm64/kernel/cpufeature.c
> > > +++ b/arch/arm64/kernel/cpufeature.c
> > > @@ -1224,6 +1224,13 @@ static void update_cpu_ftr_reg(struct arm64_ftr_reg *reg, u64 new)
> > >   		s64 ftr_cur = arm64_ftr_value(ftrp, reg->sys_val);
> > >   		s64 ftr_new = arm64_ftr_value(ftrp, new);
> > > +		/*
> > > +		 * Don't alter the initial value that has been forced
> > > +		 * by an override.
> > > +		 */
> > > +		if ((reg->override->mask & arm64_ftr_mask(ftrp)) == arm64_ftr_mask(ftrp))
> > > +			continue;
> > 
> > I got lost in the in the cpufeature framework, so I may be missing
> > something.
> > 
> > Let's say the primary CPU has a feature field with value 2 and we want
> > to override it to value 1. For e.g. a LOWER_SAFE feature, boot_cpu_data
> > will stored the overridden value of 1.
> > 
> > A secondary CPU comes online with the same feature missing, so value 0.
> > With the above change, we no longer update the system-wide feature
> > value, leave it as 1. Later on, for a system feature we may turn it on
> > even though the secondary CPU does not support it.
> > 
> > In summary, this makes the overridden field sticky for secondary CPUs
> > even if they don't support it.
> 
> That is true. I think we should let the secondary CPUs alter the values,
> with initial CPU feature value with the override value set, the system
> could then choose the safest among the override and the others.

It works for me. We should add a comment somewhere that the override is
not expected to work for features where we allow differences (some
FTR_NONSTRICT).

> > Unrelated to your patch, I think we can similarly fail to reject
> > secondary CPUs in check_early_cpu_features() -> verify_local_cpu_caps()
> > because of __read_sysreg_by_encoding() which uses the override value
> > unconditionally. From this perspective, we are now consistent with your
> > patch above.
> 
> This is true as well and the override takes the priority and with the
> wrong level of override value the system could be made to think that
> some features are available even when it is unsafe to do so.
> We should sanitise the values read by __read_sysreg_by_encoding() with
> the "overrides". I can cook something up.

Or remove this check if we expect the override to only work on the
resulting sanitised value, not individual checks.

-- 
Catalin
