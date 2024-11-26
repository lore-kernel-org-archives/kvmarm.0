Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308571D63D6
	for <kvmarm@lists.linux.dev>; Tue, 26 Nov 2024 16:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732638232; cv=none; b=uZsem4phBnvt/DCxex8dd7otX2qJMu6lJTiSfrZUVcl0cYXviMyX9DuaeeNYUjg+/bZ9eph4S/ZRZCYOCA+rwqtsK8fDcjWMXXxiyhIABdRiipCyRGIQjvgaTh4l84ZaMDm8vzdyHtApW8Zu2Xp1bey821XoMtys7S0YTS2hVd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732638232; c=relaxed/simple;
	bh=pdn3dCVWJQI01kBevDNp+o2Jfyg9Xrkue9L/rOGJPNc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ghmoP0lnKtzK2/JXoikJ7XnAzEYDds6N+EmPBbXACB8wOEJ9veCg4QeBe9W+3VXmOez2Xz44Usvivlm43aWd1irdpU7Q4Yay4uIsZqyUHOmPJQL+xo7KEFs4OYKEBUCfDihJbJan9Rjz53cM8+HLaNjs/K/IQlVzf49PWeG2ObQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fri7R9nF; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fri7R9nF"
Date: Tue, 26 Nov 2024 08:23:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732638228;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ktkZP1TSM5O+zshk14R/JTKvbWeVU6I7FikTokHf+NY=;
	b=fri7R9nF5gcARbgDooMqc2jGmEtlLuIBMa4n4Ih2zWgLKiu6Pw1kDhVs5mZTc6/0tKnP7F
	DkqycMW+TIz69cMh7xP1ngCKed5fXxO0nlSsd+RzkreovFRHVJz9h1oTQMPXsmbI7IFGAg
	LU/zSULINIm1hEoxLR9LxNaBEzStJBk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: James Clark <james.clark@linaro.org>
Cc: suzuki.poulose@arm.com, coresight@lists.linaro.org,
	kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mike Leach <mike.leach@linaro.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Shiqi Liu <shiqiliu@hust.edu.cn>, Fuad Tabba <tabba@google.com>,
	James Morse <james.morse@arm.com>, Mark Brown <broonie@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 11/12] KVM: arm64: Swap TRFCR on guest switch
Message-ID: <Z0X2BBBaDejFfATp@linux.dev>
References: <20241112103717.589952-1-james.clark@linaro.org>
 <20241112103717.589952-12-james.clark@linaro.org>
 <Zz4c5LmQnK2SD5HO@linux.dev>
 <5f2eb0fa-c7ca-4e25-b713-6a9bf3d355b9@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f2eb0fa-c7ca-4e25-b713-6a9bf3d355b9@linaro.org>
X-Migadu-Flow: FLOW_OUT

On Thu, Nov 21, 2024 at 12:50:10PM +0000, James Clark wrote:
> 
> 
> On 20/11/2024 5:31 pm, Oliver Upton wrote:
> > On Tue, Nov 12, 2024 at 10:37:10AM +0000, James Clark wrote:
> > > +void kvm_set_trfcr(u64 host_trfcr, u64 guest_trfcr)
> > > +{
> > > +	if (kvm_arm_skip_trace_state())
> > > +		return;
> > > +
> > > +	if (has_vhe())
> > > +		write_sysreg_s(guest_trfcr, SYS_TRFCR_EL12);
> > > +	else
> > > +		if (host_trfcr != guest_trfcr) {
> > > +			*host_data_ptr(host_debug_state.trfcr_el1) = guest_trfcr;
> > 
> > Huh? That's going into host_debug_state, which is the dumping grounds
> > for *host* context when entering a guest.
> > 
> > Not sure why we'd stick a *guest* value in there...
> > 
> 
> Only to save a 3rd storage place for trfcr when just the register and one
> place is technically enough. But yes if it's more readable to have
> guest_trfcr_el1 separately then that makes sense.

Yeah, since this is all per-cpu data at this point rather than per-vCPU,
it isn't the end of the world to use a few extra bytes.

> That works, it would be nice to have it consistent and have it that way for
> filtering, like kvm_set_guest_trace_filters(bool kernel, bool user). But I
> suppose we can justify not doing it there because we're not really
> interpreting the TRFCR value just writing it whole.

Agreed, the biggest thing I'd want to see in the exported interfaces
like this is to have enable/disable helpers to tell KVM when a driver
wants KVM to start/stop managing a piece of state while in a guest.

Then the hypervisor code can blindly save/restore some opaque values to
whatever registers it needs to update.

> > What if trace is disabled in the guest or in the host? Do we need to
> > synchronize when transitioning from an enabled -> disabled state like we
> > do today?
> > 
> 
> By synchronize do you mean the tsb_csync()? I can only see it being
> necessary for the TRBE case because then writing to the buffer is fatal.
> Without TRBE the trace sinks still work and the boundary of when exactly
> tracing is disabled in the kernel isn't critical.

Ack, I had the blinders on that we cared only about TRBE here.

> > I took a stab at this, completely untested of course && punts on
> > protected mode. But this is _generally_ how I'd like to see everything
> > fit together.
> > 
> 
> Would you expect to see the protected mode stuff ignored if I sent another
> version more like yours below? Or was that just skipped to keep the example
> shorter?

Skipped since I slapped this together in a hurry.

> I think I'm a bit uncertain on that one because removing HAS_TRBE means you
> can't check if TRBE is enabled or not in protected mode and it will go wrong
> if it is.

The protected mode hypervisor will need two bits of information.
Detecting that the feature is present can be done in the kernel so long
as the corresponding static key / cpucap is toggled before we drop
privileges.

Whether or not it is programmable + enabled is a decision that must be
made by observing hardware state from the hypervisor before entering a
guest.

[...]

> > +void kvm_enable_trbe(u64 guest_trfcr)
> > +{
> > +	if (WARN_ON_ONCE(preemptible()))
> > +		return;
> > +
> > +	if (has_vhe()) {
> > +		write_sysreg_s(guest_trfcr, SYS_TRFCR_EL12);
> > +		return;
> > +	}
> > +
> > +	*host_data_ptr(guest_trfcr_el1) = guest_trfcr;
> > +	host_data_set_flag(HOST_TRBE_ENABLED);
> 
> FWIW TRBE and TRF are separate features, so this wouldn't do the filtering
> correctly if TRBE wasn't in use, but I can split it out into
> separate kvm_enable_trbe(void) and kvm_set_guest_filters(u64 guest_trfcr).

KVM manages the same piece of state (TRFCR_EL1) either way though right?

The expectation I had is that KVM is informed any time a trace session
(TRBE or otherwise) is enabled/disabled on a CPU, likely with a TRFCR_EL1
of 0 if guest mode is excluded.

The function names might need massaging, but I was hoping to have a
single set of enable/disable knobs to cover all bases here.

-- 
Thanks,
Oliver
