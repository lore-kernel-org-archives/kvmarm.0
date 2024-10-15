Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914FF1C8767
	for <kvmarm@lists.linux.dev>; Tue, 15 Oct 2024 08:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728980567; cv=none; b=TqwHU+s6wtuxKp58KT7SwatpsA6t7OFxhYY4qNJ84zxxyslG7MEcpCrDEmtzjug3nFF8FQpy2t5nA8KLh70ieobZLAz38phnOidLmlD9+waasVEzYzNbaXKO+NxKpeJDGGeOydyQ6mIA3EE5YgUvvDjUl5Pgne+OLAP8Whnguj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728980567; c=relaxed/simple;
	bh=eZdx1jAAODeu5sanwg7ad8Vb7x5oNubQznK7AgAorI8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dtqkj4ljzVE2s6jw5JB9GY8VaMSGvUEiVwqzG5j22i9iX9b+qzh0Ze9L2u7HsQ4eE0o7D5YZtRuLbM1QFdCJ0S7pcv4xf4R1O5p+WOxI1T+xPCPyNhbsMwe3z555yKfGWpQSdi3T2CkvTtBUk+9JUhF1CyogPIpdg9WYonRcUAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GrCE0rH9; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GrCE0rH9"
Date: Tue, 15 Oct 2024 01:22:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728980563;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vxQXPN1x2Le/F5ULGaosSsqoOOwZADxme/8Z4rOQk1U=;
	b=GrCE0rH9iT0gCXpRmnx1encUOnsNBJlWaPhEevNHfpr0p/PVoPyZRrlURAVxe53ubobPTm
	WQyxzw3YCuk7wdZDi6BTtvpNOoNVsuGci6Bl26w5B975sW+u6py0zG5WXgNS1tFTwp/He2
	d6wxKvGqNxSxkTHmiydoETpNG9bCaew=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, catalin.marinas@arm.com,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	will@kernel.org
Subject: Re: [PATCH v1 4/4] KVM: arm64: Initialize trap register values in
 hyp in pKVM
Message-ID: <Zw4mSmoI84thN-4X@linux.dev>
References: <20241014102413.4092725-1-tabba@google.com>
 <20241014102413.4092725-5-tabba@google.com>
 <Zw4gUsF-j8H-x2CZ@linux.dev>
 <CA+EHjTzyAypPSXqrCxbc1oF5AH5P33GhtLruZfbFwY8GvnnSbg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTzyAypPSXqrCxbc1oF5AH5P33GhtLruZfbFwY8GvnnSbg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Oct 15, 2024 at 09:19:03AM +0100, Fuad Tabba wrote:
> Hi Oliver,
> 
> On Tue, 15 Oct 2024 at 08:57, Oliver Upton <oliver.upton@linux.dev> wrote:
> >
> > On Mon, Oct 14, 2024 at 11:24:12AM +0100, Fuad Tabba wrote:
> > > Handle the initialization of trap registers at the hypervisor in
> > > pKVM, even for non-protected guests. The host is not trusted with
> > > the values of the trap registers, regardless of the VM type.
> > > Therefore, when switching between the host and the guests, only
> > > flush the required bits of the trap registers from the host's
> > > view that are required for hyp-host communication.
> >
> > It'd be a bit more precise to just mention that the host is allowed to
> > configure TWI and TWE still for opportunistic scheduling, as neither
> > affects the protection of VMs or the hypervisor.
> 
> Sure, will do.
> 
> >
> > >       pvm_init_trap_regs(vcpu);
> > >       pvm_init_traps_aa64pfr0(vcpu);
> > >       pvm_init_traps_aa64pfr1(vcpu);
> >
> > aside: it'd be great to reorganize all of these traps in terms of the
> > affected trap register and not the feature register.
> >
> > But that can happen later.
> 
> I do have patches for that, but I thought I'll start with these first
> since they pave the way to those.

Entirely reasonable, as you're fixing a legitimate issue here.

-- 
Thanks,
Oliver
