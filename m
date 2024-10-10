Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F7A1CB338
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 08:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728550036; cv=none; b=CfhjrBi0cEnUkEIvONN7nvd885XhjAsfJSJ+FK0+3n26+ZmsDiY4CpkbCu3iNnStRFIXjo3ZbK+bLSW8CQ48+4GPzT+BzLLVK0eJzrc2julgpmfSrBMw1iKKuU4YhRtLjtKBuT/jc+0FrqVuDlxBEsj1YQrglbmnYX1fAigLZrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728550036; c=relaxed/simple;
	bh=yFpN9PsYMJaRcfp2ZetlQZQn59BzVzb0QhklM+SsVjM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ASyBDuixsVPH4APSEao9K6Q7Bp7PZUbSpw8tjY58eISQ+nyMJgVqc8ybpnqKxqIh8z1z2cbPZX4IdgISPBID4d5A8F0k6a1DD7kRImi5FE6WC/vovlAH8rE/OydDcVGAQ/RrwtNmwp1O0mnwtc72a3O1IbVcMKLqT/DIlsM/uCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=L+vgr7ra; arc=none smtp.client-ip=91.218.175.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="L+vgr7ra"
Date: Thu, 10 Oct 2024 01:47:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728550032;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mQbSaxO5UfPovZTKeZw/jrifWwdI59Pyel+dtq9m3cM=;
	b=L+vgr7raKGk1rtKYTk+htWEqiz00CdKBCI/966IoE18oEvn/LHQ+psYc3+FtkrLqESrsyk
	Dp2lusikIv3MuCMQ9WUjW2Ki8Y4uJ3aYYgfa0hTgA7QtgmrGN4UwufW4DrIkem4UZ9LGS6
	lRs9QSGUJE3L9I8y86+RxCy15YpY9nQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: Sean Christopherson <seanjc@google.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, stable@vger.kernel.org,
	Alexander Potapenko <glider@google.com>
Subject: Re: [PATCH] KVM: arm64: Don't eagerly teardown the vgic on init error
Message-ID: <ZweUiHMC3RNwNXzY@linux.dev>
References: <20241009183603.3221824-1-maz@kernel.org>
 <ZwbYvHJdOqePYjDf@linux.dev>
 <ZwbbQGpZpGQXaNYK@google.com>
 <ZwcRct7VWnW0bObA@linux.dev>
 <875xq0v1do.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875xq0v1do.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Thu, Oct 10, 2024 at 08:54:43AM +0100, Marc Zyngier wrote:
> On Thu, 10 Oct 2024 00:27:46 +0100, Oliver Upton <oliver.upton@linux.dev> wrote:
> > Then if we can't register the MMIO region for the distributor
> > everything comes crashing down and a vCPU has made it into the KVM_RUN
> > loop w/ the VGIC-shaped rug pulled out from under it. There's definitely
> > another functional bug here where a vCPU's attempts to poke the
> > distributor wind up reaching userspace as MMIO exits. But we can worry
> > about that another day.
> 
> I don't think that one is that bad. Userspace got us here, and they
> now see an MMIO exit for something that it is not prepared to handle.
> Suck it up and die (on a black size M t-shirt, please).

LOL, I'll remember that.

The situation I have in mind is a bit harder to blame on userspace,
though. Supposing that the whole VM was set up correctly, multiple vCPUs
entering KVM_RUN concurrently could cause this race and have 'unexpected'
MMIO exits go out to userspace.

	vcpu-0				vcpu-1
	======				======
	kvm_vgic_map_resources()
	  dist->ready = true
	  mutex_unlock(config_lock)
	  				kvm_vgic_map_resources()
					  if (vgic_ready())
					    return 0

					< enter guest >
					typer = writel(0, GICD_CTLR)

					< data abort >
					kvm_io_bus_write(...)	<= No GICD, out to userspace

       vgic_register_dist_iodev()

A small but stupid window to race with.

> > If memory serves, kvm_vgic_map_resources() used to do all of this behind
> > the config_lock to cure the race, but that wound up inverting lock
> > ordering on srcu.
> 
> Probably something like that. We also used to hold the kvm lock, which
> made everything much simpler, but awfully wrong.
> 
> > Note to self: Impose strict ordering on GIC initialization v. vCPU
> > creation if/when we get a new flavor of irqchip.
> 
> One of the things we should have done when introducing GICv3 is to
> impose that at KVM_DEV_ARM_VGIC_CTRL_INIT, the GIC memory map is
> final. I remember some push-back on the QEMU side of things, as they
> like to decouple things, but this has proved to be a nightmare.

Pushing more of the initialization complexity into userspace feels like
the right thing. Since we clearly have no idea what we're doing :)

> > The crappy assumption here is kvm_arch_vcpu_run_pid_change() and its
> > callees are allowed to destroy VM-scoped structures in error handling.
> 
> I think this is symptomatic of more general issue: we perform VM-wide
> configuration in the context of a vcpu. We have tons of this stuff to
> paper over the lack of a "this VM is fully configured" barrier.
> 
> I wonder whether we could sidestep things by punting the finalisation
> of the VM to a different context (workqueue?)  and simply return
> -EAGAIN or -EINTR to userspace while we're processing it. That doesn't
> solve the "I'm missing parts of the address map and I'm going to die"
> part though.

Throwing it back at userspace would be nice, but unfortunately for ABI I
think we need to block/spin vCPUs in the kernel til the VM is in fully
working condition. A fragile userspace could explode for a 'spurious'
EAGAIN/EINTR where there wasn't one before.

-- 
Thanks,
Oliver
