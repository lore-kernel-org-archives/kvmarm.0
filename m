Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B210F18FDA5
	for <kvmarm@lists.linux.dev>; Mon, 24 Mar 2025 08:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742804385; cv=none; b=leEfAXHl6Yh8MaOKFZS7Iz3zzO/JsUry/FHfIa6HmPKh/HVl5W4jybi11fUSfQxJzmRdxa6Pva+7gN2tdHudBvk6yjOK+fCoLh8LQOD7AT6l3EzIUeKQnKKPcrfMn++IBo5IWob4GiL76vs+jwT4ww8rww7q+dXc+YoxrbQRyHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742804385; c=relaxed/simple;
	bh=HpC2xZP6pHOQg4gFKaI13BrMJ2BTkRXT+0OmjqNcfyM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LfFBH07BCCr37JIdVmhvn6oCoudcj/Wt0q8F9Fz6jfKERax/t21r0DKe9P1/p2mTEPjxp0qRkEQ/IskUZW7kHKJ4uIq/EQrRxSjND6XktWkXc5sTyIAmfu5fkcOLa4O2ua8v5abC5GfowHxY7X8cu8GiMpB+nQk02Cx1CYODDVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ahUaKnIr; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ahUaKnIr"
Date: Mon, 24 Mar 2025 09:19:27 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742804371;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+nT01jyxPvL4ghruc69ok3n46Axe+IpSGm70ZkWQJRI=;
	b=ahUaKnIrSBCACk4IdyabSmxr/6vgjA5fyJuHRCIrOS/aVRhrf/Z6vuFiwWaQgPFaaMzNnS
	w0DJsBqj0pJ6a8PjUN5c86WdRA+19FNRqeh7CLwbO623X7su18G8g9fU3jsJbnBCf6JRQg
	/9jvvbsrvd279KUaiZ4OVIbV6r76tbg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>, 
	eric.auger@redhat.com, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, vladimir.murzin@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 4/5] configure: Add --qemu-cpu option
Message-ID: <20250324-5d22d8ad79a9db37b1cf6961@orel>
References: <20250314154904.3946484-2-jean-philippe@linaro.org>
 <20250314154904.3946484-6-jean-philippe@linaro.org>
 <20250322-91a8125ad8651b24246e5799@orel>
 <Z9_tg6WhKvIJtBai@raptor>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9_tg6WhKvIJtBai@raptor>
X-Migadu-Flow: FLOW_OUT

On Sun, Mar 23, 2025 at 11:16:19AM +0000, Alexandru Elisei wrote:
...
> > > +if [ -z "$qemu_cpu" ]; then
> > > +	if ( [ "$ACCEL" = "kvm" ] || [ "$ACCEL" = "hvf" ] ) &&
> > > +	   ( [ "$HOST" = "aarch64" ] || [ "$HOST" = "arm" ] ); then
> > > +		qemu_cpu="host"
> > >  		if [ "$ARCH" = "arm" ] && [ "$HOST" = "aarch64" ]; then
> > > -			processor+=",aarch64=off"
> > > +			qemu_cpu+=",aarch64=off"
> > >  		fi
> > > +	elif [ "$ARCH" = "arm64" ]; then
> > > +		qemu_cpu="cortex-a57"
> > > +	else
> > > +		qemu_cpu="cortex-a15"
> > 
> > configure could set this in config.mak as DEFAULT_PROCESSOR, avoiding the
> > need to duplicate it here.
> 
> That was my first instinct too, having the default value in config.mak seemed
> like the correct solution.
> 
> But the problem with this is that the default -cpu type depends on -accel (set
> via unittests.cfg or as an environment variable), host and test architecture
> combination. All of these variables are known only at runtime.
> 
> Let's say we have DEFAULT_QEMU_CPU=cortex-a57 in config.mak. If we keep the
> above heuristic, arm/run will override it with host,aarch64=off. IMO, having it
> in config.mak, but arm/run using it only under certain conditions is worse than
> not having it at all. arm/run choosing the default value **all the time** is at
> least consistent.

I think having 'DEFAULT' in the name implies that it will only be used if
there's nothing better, and we don't require everything in config.mak to
be used (there's even some s390x-specific stuff in there for all
architectures...)

> 
> We could modify the help text for --qemu-cpu to say something like "If left
> unset, the $ARCH/run script will choose a best value based on the host system
> and test configuration."

This is helpful, so we should add it regardless.

Thanks,
drew
