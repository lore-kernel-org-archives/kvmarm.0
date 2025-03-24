Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28B0D25D544
	for <kvmarm@lists.linux.dev>; Mon, 24 Mar 2025 10:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742812870; cv=none; b=Vsw1zJa/dw320BsSsDuZad5P6s1s4dUOq2ufAyvqzSBvnOUkT3u/pwX5YbzAL1t5TeMvtqdy84pUyawlOIzCx9oiwiJdRzOaB+D1Uh2i9BVRoRIL+3eEKcp8K4DrSUYu0VqSj7e8hB/spzNO8eS14GEkCl1Kye518ILJjutyOI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742812870; c=relaxed/simple;
	bh=/MFeqRbqXL6Mtpk9Gu9vEDBTbz5bwSMdZbaYMuOk/qo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tww9sJgHY9Cu+paAc/pVzf4804l7ZEscgj6aDgd0dsQ57Pg2+2IqwEOpGf5W9m1iaOa9y28cyhpvPdL4gIDs7F3MSetKhPndgFcetSj22eXV/b4pee9knxAdBX8zQc0uLlIWJjnrx2H93mwERDJmLzQ7N5dOL9RjIdipe9fL+bM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 72C5F1A2D;
	Mon, 24 Mar 2025 03:41:13 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DEBAA3F63F;
	Mon, 24 Mar 2025 03:41:05 -0700 (PDT)
Date: Mon, 24 Mar 2025 10:41:03 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>, eric.auger@redhat.com,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org, vladimir.murzin@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 4/5] configure: Add --qemu-cpu option
Message-ID: <Z-E2v1sKiPG_pt9x@raptor>
References: <20250314154904.3946484-2-jean-philippe@linaro.org>
 <20250314154904.3946484-6-jean-philippe@linaro.org>
 <20250322-91a8125ad8651b24246e5799@orel>
 <Z9_tg6WhKvIJtBai@raptor>
 <20250324-5d22d8ad79a9db37b1cf6961@orel>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250324-5d22d8ad79a9db37b1cf6961@orel>

Hi Drew,

On Mon, Mar 24, 2025 at 09:19:27AM +0100, Andrew Jones wrote:
> On Sun, Mar 23, 2025 at 11:16:19AM +0000, Alexandru Elisei wrote:
> ...
> > > > +if [ -z "$qemu_cpu" ]; then
> > > > +	if ( [ "$ACCEL" = "kvm" ] || [ "$ACCEL" = "hvf" ] ) &&
> > > > +	   ( [ "$HOST" = "aarch64" ] || [ "$HOST" = "arm" ] ); then
> > > > +		qemu_cpu="host"
> > > >  		if [ "$ARCH" = "arm" ] && [ "$HOST" = "aarch64" ]; then
> > > > -			processor+=",aarch64=off"
> > > > +			qemu_cpu+=",aarch64=off"
> > > >  		fi
> > > > +	elif [ "$ARCH" = "arm64" ]; then
> > > > +		qemu_cpu="cortex-a57"
> > > > +	else
> > > > +		qemu_cpu="cortex-a15"
> > > 
> > > configure could set this in config.mak as DEFAULT_PROCESSOR, avoiding the
> > > need to duplicate it here.
> > 
> > That was my first instinct too, having the default value in config.mak seemed
> > like the correct solution.
> > 
> > But the problem with this is that the default -cpu type depends on -accel (set
> > via unittests.cfg or as an environment variable), host and test architecture
> > combination. All of these variables are known only at runtime.
> > 
> > Let's say we have DEFAULT_QEMU_CPU=cortex-a57 in config.mak. If we keep the
> > above heuristic, arm/run will override it with host,aarch64=off. IMO, having it
> > in config.mak, but arm/run using it only under certain conditions is worse than
> > not having it at all. arm/run choosing the default value **all the time** is at
> > least consistent.
> 
> I think having 'DEFAULT' in the name implies that it will only be used if
> there's nothing better, and we don't require everything in config.mak to
> be used (there's even some s390x-specific stuff in there for all
> architectures...)

I'm still leaning towards having the default value and the heuristics for
when to pick it in one place ($ARCH/run) as being more convenient, but I
can certainly see your point of view.

So yeah, up to you :)

> 
> > 
> > We could modify the help text for --qemu-cpu to say something like "If left
> > unset, the $ARCH/run script will choose a best value based on the host system
> > and test configuration."
> 
> This is helpful, so we should add it regardless.

Thanks,
Alex
