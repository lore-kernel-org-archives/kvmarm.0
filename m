Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B372B1DED69
	for <kvmarm@lists.linux.dev>; Thu, 17 Oct 2024 16:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729181251; cv=none; b=leAkQ37csiC/U1fQqP5GWrWzDk3y/G5qOKJ3+QhLfgUGk6xbM+1ONIfSzOp6hNYUeHOyJ/edaFAgx4GF6UJVGCWZOPDOjQvnw6JvsA9nQCACqDyfBFdSUM/4eJg/jr8hqbPn+evzdLFxvsDr6Ax7hF0Z0rVs314nJjIVJD9Gyu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729181251; c=relaxed/simple;
	bh=XDdUddAkKb5XVd6NnUPrVMhSMOOjyD1y4TEDjBT27EA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GVDWY2f18zZrBKnnJuGqUdTa9/S7lrtR8Rw1F+zEjmtONoU2w6i8cs8uiqVZhFJGJinZNAmwkPIiK6x/PlAJ5pambDFWHHx3Yqbs29RfPc4sIMY4pzKvJp9zCTHvvIbutFs9vsGJVCxLrR0qjiuZf3+mitBs+sWVSWKRYbmyOKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OVbSznl9; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OVbSznl9"
Date: Thu, 17 Oct 2024 09:07:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729181247;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ThcQZ+3MkB/qEGEryCJ5ch1E9+cfwJrVZEp4ttPHAbk=;
	b=OVbSznl9WOtfSERnBHqz3YTNw5ip6JQrrtPtfWPJom7vJEcbDnxdssKOFNBorWQev7dweX
	cwwXpyxNq9+rN/cZENy9KLxxOT7tVn38vOYYVTJlK/Dc5nG4/hXVMmohFCeh4UipvgiMg6
	KDGf7Bb+5VE3+3GqiQlqtqo9Gu2cKGs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Joey Gouly <joey.gouly@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	anshuman.khandual@arm.com, james.morse@arm.com,
	Marc Zyngier <maz@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jing Zhang <jingzhangos@google.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v5 4/7] KVM: arm64: Fix missing traps of guest accesses
 to the MPAM registers
Message-ID: <ZxE2NUNKSWuzVow2@linux.dev>
References: <20241015133923.3910916-1-joey.gouly@arm.com>
 <20241015133923.3910916-5-joey.gouly@arm.com>
 <ZxBV6c4Z_GlyDoBr@linux.dev>
 <20241017105849.GA122054@e124191.cambridge.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241017105849.GA122054@e124191.cambridge.arm.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Oct 17, 2024 at 11:58:49AM +0100, Joey Gouly wrote:
> On Wed, Oct 16, 2024 at 05:10:17PM -0700, Oliver Upton wrote:
> > Hi Joey,
> > 
> > On Tue, Oct 15, 2024 at 02:39:20PM +0100, Joey Gouly wrote:
> > > +static inline void  __activate_traps_mpam(struct kvm_vcpu *vcpu)
> > > +{
> > > +	u64 r = MPAM2_EL2_TRAPMPAM0EL1 | MPAM2_EL2_TRAPMPAM1EL1;
> > > +
> > > +	if (!cpus_support_mpam())
> > > +		return;
> > > +
> > > +	/* trap guest access to MPAMIDR_EL1 */
> > > +	if (mpam_cpus_have_mpam_hcr()) {
> > > +		write_sysreg_s(MPAMHCR_EL2_TRAP_MPAMIDR_EL1, SYS_MPAMHCR_EL2);
> > > +	} else {
> > > +		/* From v1.1 TIDR can trap MPAMIDR, set it unconditionally */
> > > +		r |= MPAM2_EL2_TIDR;
> > > +	}
> > > +
> > > +	write_sysreg_s(r, SYS_MPAM2_EL2);
> > > +}
> > > +
> > > +static inline void __deactivate_traps_mpam(void)
> > > +{
> > > +	if (!cpus_support_mpam())
> > > +		return;
> > > +
> > > +	write_sysreg_s(0, SYS_MPAM2_EL2);
> > > +
> > > +	if (mpam_cpus_have_mpam_hcr())
> > > +		write_sysreg_s(MPAMHCR_HOST_FLAGS, SYS_MPAMHCR_EL2);
> > > +}
> > 
> > TBH, I think our trap configuration should *not* be conditioned on
> > CONFIG_ARM64_MPAM. Otherwise we're silently allowing the guest to change
> > things under the nose of KVM/host kernel, assuming an unkind firmware
> > that left the EL2 trap configuration in a permissive state.
> > 
> > WDYT about detecting the feature && enforcing traps regardless of the Kconfig?
> 
> I had actually thought about the same thing. I spoke with James and he agrees,
> so I will look into removing that.
> 
> I will probably end up removing the Kconfig entirely, it can be added back in
> later, when actual support for MPAM is added.

Sounds good, thanks Joey!

If we go down this route, I'm guessing we can also skip the boot
time EL2 setup portion of it (for now). That'd constrain the fossilized
EL3 issue to *just* failures to run KVM VMs as opposed to kernels not
booting at all.

-- 
Thanks,
Oliver
