Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6865E1991B8
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 16:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728578852; cv=none; b=Ad6CyOh/7qzQtnRi+GSB8Gi9aCkXBFD7I17p2MV8uoHzSKlQncLK8lFq2FKSyuu+pa1WcmBUz4BLJ3IkvZjYfGM0kUovmZjg1Zyns6QqaTafLa2WGlpVu3hvoxFaOYtKgoMhvgfKu0jPQgWg6QPCIZ4zvozc2gMww0Evms4hxas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728578852; c=relaxed/simple;
	bh=o7m0JDUgfMN4k/o6jKXlLti0MBTboCqANWeAfCzYLjs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BbfzP0GWRsy/7VlQdNKx9SWu9k2oOVIM+Jmffax0laE0KHYo6T0n6n2kkpTnjTY8o2TckXoKTTZAqEqTf99DtEJjVLO1O+ipvGIzIr1QPvHaaclEb1rFPL0Ipk8vBAmx6bupsGyg1S3w+M9hZBfPEpLWy4filjHY+Qv8A8BFLdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=P0IfaB5S; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="P0IfaB5S"
Date: Thu, 10 Oct 2024 09:47:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728578845;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+8PqfZzymdMmU3xYcHveo3/itEaiA3j24fMS5kH/E4Q=;
	b=P0IfaB5SBVE3gewFVz91R/ZRuruHHvDeAx6+iPQQKzDgwAvtZmngYw0zWz02rpUZzwS26g
	otaMTn5Vig5PFUkCnjkeSaX1ZatfltHL6eyz6G8SAtzWYEdaqdq+lLSbuWDoQ6/o07L18a
	64dT4f6ALANgp2QRjHvy5BIY7v5UD1I=
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
Message-ID: <ZwgFFf4KC-DowMGW@linux.dev>
References: <20241009183603.3221824-1-maz@kernel.org>
 <ZwbYvHJdOqePYjDf@linux.dev>
 <ZwbbQGpZpGQXaNYK@google.com>
 <ZwcRct7VWnW0bObA@linux.dev>
 <875xq0v1do.wl-maz@kernel.org>
 <ZweUiHMC3RNwNXzY@linux.dev>
 <86plo85dme.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86plo85dme.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Thu, Oct 10, 2024 at 01:47:05PM +0100, Marc Zyngier wrote:
> On Thu, 10 Oct 2024 09:47:04 +0100, Oliver Upton <oliver.upton@linux.dev> wrote:
> > A small but stupid window to race with.
> 
> Ah, gotcha. I guess getting rid of the early-out in
> kvm_vgic_map_resources() would plug that one. Want to post a fix for
> that?

Yep, will do.

> > 
> > > > If memory serves, kvm_vgic_map_resources() used to do all of this behind
> > > > the config_lock to cure the race, but that wound up inverting lock
> > > > ordering on srcu.
> > > 
> > > Probably something like that. We also used to hold the kvm lock, which
> > > made everything much simpler, but awfully wrong.
> > > 
> > > > Note to self: Impose strict ordering on GIC initialization v. vCPU
> > > > creation if/when we get a new flavor of irqchip.
> > > 
> > > One of the things we should have done when introducing GICv3 is to
> > > impose that at KVM_DEV_ARM_VGIC_CTRL_INIT, the GIC memory map is
> > > final. I remember some push-back on the QEMU side of things, as they
> > > like to decouple things, but this has proved to be a nightmare.
> > 
> > Pushing more of the initialization complexity into userspace feels like
> > the right thing. Since we clearly have no idea what we're doing :)
> 
> KVM APIv2?

Even better, we can just go straight to v3 and skip all the mistakes we
would've made in v2.

> > 
> > > > The crappy assumption here is kvm_arch_vcpu_run_pid_change() and its
> > > > callees are allowed to destroy VM-scoped structures in error handling.
> > > 
> > > I think this is symptomatic of more general issue: we perform VM-wide
> > > configuration in the context of a vcpu. We have tons of this stuff to
> > > paper over the lack of a "this VM is fully configured" barrier.
> > > 
> > > I wonder whether we could sidestep things by punting the finalisation
> > > of the VM to a different context (workqueue?)  and simply return
> > > -EAGAIN or -EINTR to userspace while we're processing it. That doesn't
> > > solve the "I'm missing parts of the address map and I'm going to die"
> > > part though.
> > 
> > Throwing it back at userspace would be nice, but unfortunately for ABI I
> > think we need to block/spin vCPUs in the kernel til the VM is in fully
> > working condition. A fragile userspace could explode for a 'spurious'
> > EAGAIN/EINTR where there wasn't one before.
> 
> EINTR needs to be handled already, as this is how you report
> preemption by a signal.

Of course, I'm just assuming userspace is mean and will complain if no
signal actually arrives.

-- 
Thanks,
Oliver
