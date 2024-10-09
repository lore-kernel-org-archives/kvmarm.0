Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8FEE1E376D
	for <kvmarm@lists.linux.dev>; Wed,  9 Oct 2024 23:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728516477; cv=none; b=n5/wuMYAC+3oca/B3Hcsf+hqgPbxE4jvlC5RuWjkKUbZX2JQvtFD3D6hcCXlyBSnuFSJ9AL8MOocRWt0/0GkEuRLpT7O5FGWEleG7Bb9de9UxFrgxpNbY/n8sernU9epNQ5Ka7tzJCEQHOYQ6rpAwhBs9xccP26znil61pDywwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728516477; c=relaxed/simple;
	bh=ydfVLP0BdOskPbhpr40z4OF5B6f3E+tOviVfgl6hQQA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jTyWnHinPYyIbi97n61k9c5uOqINAHUFgs66y2b9VQeEP6h5mTxlCqztJhw249NC3GiczVf0EQoqGwKPjpmfUCiTCyT0v4NN8hfF9xMTfJCQ+vTVdvGLfuVc7HvvAQB6XyYw+4zNtFjiU18aDfdOQeBwtjltWj+GjfB74Y5BwuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=n1YGSMKS; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="n1YGSMKS"
Date: Wed, 9 Oct 2024 23:27:46 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728516472;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4KeD7odlayOig02YQl1SAcJz/3EmFxKkRZSthX1RFFI=;
	b=n1YGSMKSZkKbdoTgJGyOQUk+EF5Uki4rP4D9/svYrOjZGnykH9HqdEGNaQQQkh+Qg+BXDv
	ZMmGJRpuQTWLgyV2Z1Z1yO3vwuBePwqSqNfON8aWVqfsJexQcZ2U27CJDG7Fs/gdDQfRfO
	B48TmkB6/8vpCiqo+1WwBCUR7+V7abs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, stable@vger.kernel.org,
	Alexander Potapenko <glider@google.com>
Subject: Re: [PATCH] KVM: arm64: Don't eagerly teardown the vgic on init error
Message-ID: <ZwcRct7VWnW0bObA@linux.dev>
References: <20241009183603.3221824-1-maz@kernel.org>
 <ZwbYvHJdOqePYjDf@linux.dev>
 <ZwbbQGpZpGQXaNYK@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZwbbQGpZpGQXaNYK@google.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Oct 09, 2024 at 12:36:32PM -0700, Sean Christopherson wrote:
> On Wed, Oct 09, 2024, Oliver Upton wrote:
> > On Wed, Oct 09, 2024 at 07:36:03PM +0100, Marc Zyngier wrote:
> > > As there is very little ordering in the KVM API, userspace can
> > > instanciate a half-baked GIC (missing its memory map, for example)
> > > at almost any time.
> > > 
> > > This means that, with the right timing, a thread running vcpu-0
> > > can enter the kernel without a GIC configured and get a GIC created
> > > behind its back by another thread. Amusingly, it will pick up
> > > that GIC and start messing with the data structures without the
> > > GIC having been fully initialised.
> > 
> > Huh, I'm definitely missing something. Could you remind me where we open
> > up this race between KVM_RUN && kvm_vgic_create()?

Ah, duh, I see it now. kvm_arch_vcpu_run_pid_change() doesn't serialize
on a VM lock, and kvm_vgic_map_resources() has an early return for
vgic_ready() letting it blow straight past the config_lock.

Then if we can't register the MMIO region for the distributor
everything comes crashing down and a vCPU has made it into the KVM_RUN
loop w/ the VGIC-shaped rug pulled out from under it. There's definitely
another functional bug here where a vCPU's attempts to poke the
distributor wind up reaching userspace as MMIO exits. But we can worry
about that another day.

If memory serves, kvm_vgic_map_resources() used to do all of this behind
the config_lock to cure the race, but that wound up inverting lock
ordering on srcu.

Note to self: Impose strict ordering on GIC initialization v. vCPU
creation if/when we get a new flavor of irqchip.

> > I'd thought the fact that the latter takes all the vCPU mutexes and
> > checks if any vCPU in the VM has run would be enough to guard against
> > such a race, but clearly not...
> 
> Any chance that fixing bugs where vCPU0 can be accessed (and run!) before its
> fully online help?

That's an equally gross bug, but kvm_vgic_create() should still be safe
w.r.t. vCPU creation since both hold the kvm->lock in the right spot.
That is, since kvm_vgic_create() is called under the lock any vCPUs
visible to userspace should exist in the vCPU xarray.

The crappy assumption here is kvm_arch_vcpu_run_pid_change() and its
callees are allowed to destroy VM-scoped structures in error handling.

> E.g. if that closes the vCPU0 hole, maybe the vCPU1 case can
> be handled a bit more gracefully?

I think this is about as graceful as we can be. The sorts of screw-ups
that precipitate this error handling may involve stupidity across
several KVM ioctls, meaning it is highly unlikely to be attributable /
recoverable.

-- 
Thanks,
Oliver
