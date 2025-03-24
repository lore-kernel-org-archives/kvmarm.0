Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93FF1CD1E4
	for <kvmarm@lists.linux.dev>; Mon, 24 Mar 2025 13:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742822003; cv=none; b=W0b61rl0ztFXRM34HfUeXKlVA2Ep4wRxHwIuDoJTYIPo0y4trT27LIYCJlL7kwp597AX3o1XrLOGL1EKYUIJof34BXz+Uh1mUn8Ek7vwrjsId4ckUk7YzIrZ8Gdb7GC3OIA0AO8i7jF0ZHOS/m2l1KeZgcNzWsxZLnDAlqtDD8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742822003; c=relaxed/simple;
	bh=cFQjfndprJ1cFN+ao/KGhan0LlEH0OfM4e91hq0Y/XE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O411aELjkTMY3jl9fDRlpUVe5nDm7H2IsUbtOu3pRaICvH/bN6cKp8ZbPD5KVWee18yCWpmYsK/cRX2Qxa4ZGE2fx1hIZz4BY8IAJ4Zt2KvIT9Cox/ak+OHVOBPb5FSVNNJJJFIg4e64CkPSeuMraE3TztGo1liz6Uyw5lZWhOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KmVRmpHV; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KmVRmpHV"
Date: Mon, 24 Mar 2025 14:13:13 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742821996;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W+lo7ZJTmaQcIg4xRXI3NSrRPyI/Hr06T/3WGXyDV+w=;
	b=KmVRmpHVdghjXdxP6nw9wJnCjjJist9dS8Mtziz78U1YauSna9vS2diH/pXsb0nMtVSouo
	aNBLSRtOh1q8v/oWPFaaZa38BjYVADDytc5LKHYceYXnS7JxzhDr0yhm+INt/05rFtV1m0
	yS3otZzwOlpo5gpYVrtgEPNon62Q3gM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>, 
	eric.auger@redhat.com, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, vladimir.murzin@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 4/5] configure: Add --qemu-cpu option
Message-ID: <20250324-37628351a72ca339819b528d@orel>
References: <20250314154904.3946484-2-jean-philippe@linaro.org>
 <20250314154904.3946484-6-jean-philippe@linaro.org>
 <20250322-91a8125ad8651b24246e5799@orel>
 <Z9_tg6WhKvIJtBai@raptor>
 <20250324-5d22d8ad79a9db37b1cf6961@orel>
 <Z-E2v1sKiPG_pt9x@raptor>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z-E2v1sKiPG_pt9x@raptor>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 24, 2025 at 10:41:03AM +0000, Alexandru Elisei wrote:
> Hi Drew,
> 
> On Mon, Mar 24, 2025 at 09:19:27AM +0100, Andrew Jones wrote:
> > On Sun, Mar 23, 2025 at 11:16:19AM +0000, Alexandru Elisei wrote:
> > ...
> > > > > +if [ -z "$qemu_cpu" ]; then
> > > > > +	if ( [ "$ACCEL" = "kvm" ] || [ "$ACCEL" = "hvf" ] ) &&
> > > > > +	   ( [ "$HOST" = "aarch64" ] || [ "$HOST" = "arm" ] ); then
> > > > > +		qemu_cpu="host"
> > > > >  		if [ "$ARCH" = "arm" ] && [ "$HOST" = "aarch64" ]; then
> > > > > -			processor+=",aarch64=off"
> > > > > +			qemu_cpu+=",aarch64=off"
> > > > >  		fi
> > > > > +	elif [ "$ARCH" = "arm64" ]; then
> > > > > +		qemu_cpu="cortex-a57"
> > > > > +	else
> > > > > +		qemu_cpu="cortex-a15"
> > > > 
> > > > configure could set this in config.mak as DEFAULT_PROCESSOR, avoiding the
> > > > need to duplicate it here.
> > > 
> > > That was my first instinct too, having the default value in config.mak seemed
> > > like the correct solution.
> > > 
> > > But the problem with this is that the default -cpu type depends on -accel (set
> > > via unittests.cfg or as an environment variable), host and test architecture
> > > combination. All of these variables are known only at runtime.
> > > 
> > > Let's say we have DEFAULT_QEMU_CPU=cortex-a57 in config.mak. If we keep the
> > > above heuristic, arm/run will override it with host,aarch64=off. IMO, having it
> > > in config.mak, but arm/run using it only under certain conditions is worse than
> > > not having it at all. arm/run choosing the default value **all the time** is at
> > > least consistent.
> > 
> > I think having 'DEFAULT' in the name implies that it will only be used if
> > there's nothing better, and we don't require everything in config.mak to
> > be used (there's even some s390x-specific stuff in there for all
> > architectures...)
> 
> I'm still leaning towards having the default value and the heuristics for
> when to pick it in one place ($ARCH/run) as being more convenient, but I
> can certainly see your point of view.

I wouldn't mind it only being in $ARCH/run, but this series adds the same
logic to $ARCH/run and to ./configure. I think an additional, potentially
unused, variable in config.mak is better than code duplication.

Thanks,
drew
