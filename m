Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1630A1741EF
	for <kvmarm@lists.linux.dev>; Tue, 15 Oct 2024 07:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728979043; cv=none; b=UVZLvVFXb1lqpbnzd0YgqnCF4eOyjd3O45jcYz0WHtsb2B71CcQ1FJIbdKvYxTZAfZrtp4R9ZfxSR7o3ZrJl5iXsoxLDEe+XhX4VUx5vH7CyJKnOchjsjamwLpHdU6wKGWKk7qVnWzRUFgLT96FplyFevWRBfOhOhBYvpiLcdpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728979043; c=relaxed/simple;
	bh=8EQbjx8CglxXwS2ozLLM7opISK5fyNCJpaUsXkayYt0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OXKdri9flaC4cok77ZVLBZ0qg5nPpFcWgctW4/yuBqtytcdySZEcWbdw4BXAHWXkPu/6Bx8IGsaWW19RzX/gnCNIzL6IJVz78ZtHa0Nw/uVhlpWE9ewIMJJ23UvJM9SUlec28+nM+apdrbSr5+yRD+HfkMD+yXDpVIy6UXUghDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=seP4VcPP; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="seP4VcPP"
Date: Tue, 15 Oct 2024 00:57:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728979036;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XiK4OzVnNO+nxDgf2Gm5jO3zPGKOMgVPURvMpYDpXEw=;
	b=seP4VcPPYcvF69qkThW/pc/NOyiD/oA0k2uYOlDhwJbiMdL6/Nbq+eyoiDQrSoCKGs2Dze
	qSsUmkWyJeTJ1ggpG6DyFyv10rlGRxdgpV7JvQbbqLZO7FYx6pTkONCmMdiQmRC3rZj8D7
	rfqraP0vEHc58P90icCCrZDnZzVk908=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, catalin.marinas@arm.com,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	will@kernel.org
Subject: Re: [PATCH v1 4/4] KVM: arm64: Initialize trap register values in
 hyp in pKVM
Message-ID: <Zw4gUsF-j8H-x2CZ@linux.dev>
References: <20241014102413.4092725-1-tabba@google.com>
 <20241014102413.4092725-5-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241014102413.4092725-5-tabba@google.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Oct 14, 2024 at 11:24:12AM +0100, Fuad Tabba wrote:
> Handle the initialization of trap registers at the hypervisor in
> pKVM, even for non-protected guests. The host is not trusted with
> the values of the trap registers, regardless of the VM type.
> Therefore, when switching between the host and the guests, only
> flush the required bits of the trap registers from the host's
> view that are required for hyp-host communication.

It'd be a bit more precise to just mention that the host is allowed to
configure TWI and TWE still for opportunistic scheduling, as neither
affects the protection of VMs or the hypervisor.

>  	pvm_init_trap_regs(vcpu);
>  	pvm_init_traps_aa64pfr0(vcpu);
>  	pvm_init_traps_aa64pfr1(vcpu);

aside: it'd be great to reorganize all of these traps in terms of the
affected trap register and not the feature register.

But that can happen later.

-- 
Thanks,
Oliver
