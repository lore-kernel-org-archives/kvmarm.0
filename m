Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6E2176AB5
	for <kvmarm@lists.linux.dev>; Fri,  7 Feb 2025 18:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738954246; cv=none; b=efTyEhobKq4z1dVMTy6dWC2UfToVED07bd/yu3pT1w6dFNJHzLZVUfMHRzhu9IkCzeol+dkn7ZoyGUzg/3WzFjMYa7scS5dJXoZ4bWmA+1mevuNo21FxeJLJMIy5uv1gH4HrUyeasjUwPIbKbha/c9UqL6Q8YFCQxGJsJTmzQbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738954246; c=relaxed/simple;
	bh=HJrNq5ZDpmE/brXLYF1AcZwsWgQKv0GgtHvHFZtMUg4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nTyZz4bfhr0O41yVJFSvP7zntyoUHIDWJ5M5bb02/SFRHVwGG8NXgIQYSIkM+GDhcHugdK6+LyTKRUMv4rVrPWKG1FR1A/UJ1IZ6RTPF/8xefePMKR9u27QuJBXwSWcqtez1N+Pdif+Qd08zW0cmYU6RwoPkiy+Z1LIZUBVZbA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=f4vkChq3; arc=none smtp.client-ip=91.218.175.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="f4vkChq3"
Date: Fri, 7 Feb 2025 10:50:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738954237;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y7P+yYtf68Gk6mgQu7mjcsgZLRWdPZQqVrYW8WznHBc=;
	b=f4vkChq3DUW264PV6AWlXBKla/NT5UPoE776+UIsFt4xAAEHXIES8pJzCkXhTHNLgJ78s+
	8D/yHdHnNXS2O0Kto6B/PbxadeSzPfpWz4QSJFZ2zP3qPX6Ztcc3gxyjhJbNT2Q8ctuJvI
	34dwwTbutZIc45JabbJMkJt9RJPartc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Alexander Potapenko <glider@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 0/3] KVM: arm64: Assorted vgic fixes for 6.14
Message-ID: <Z6ZV-JHDSSLKEah-@linux.dev>
References: <20250206152100.1107909-1-maz@kernel.org>
 <Z6ZLC1v5KU-zzbQR@linux.dev>
 <86ed09tyl2.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86ed09tyl2.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Fri, Feb 07, 2025 at 06:10:49PM +0000, Marc Zyngier wrote:
> On Fri, 07 Feb 2025 18:03:55 +0000,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > On Thu, Feb 06, 2025 at 03:20:57PM +0000, Marc Zyngier wrote:
> > > Alexander, while fuzzing KVM/arm64, found an annoying set of problems,
> > > all stemming from the fact that the vgic can be destroyed in parallel
> > > with the rest of the guest still being live.
> > > 
> > > Yes, this is annoying.
> > > 
> > > Fixing this is not going to happen overnight (though I have some
> > > ideas), but we can make what we have today a bit more robust.
> > > 
> > > This is what patch #2 is doing. Patch #1 is just removing a loud
> > > WARN_ON() that serves little purpose, and patch #3 fixes the actual
> > > bug that Alex reported.
> > > 
> > > Hopefully, none of that is controversial...
> > 
> > I'm a bit grumbly about slapping bandaids on the problem, but given the
> > fact that glider reported all of this a while ago and we still haven't
> > fixed it is enough to justify these patches. So:
> 
> Yeah, same here. I'm starting to think that we need to either prevent
> the vgic from being asynchronously destroyed, or start refcounting all
> IRQs just like LPIs. Which is very annoying since we don't have a
> global namespace for SGIs and PPIs.
> 
> But maybe simply refcounting the vgic itself would be enough.
> Thoughts?

So would we refcount on the owning structure for a particular IRQ? i.e.
private IRQs are counted against the owning vCPU and SPIs against the
distributor?

Adding a vgic_put_vcpu_irq() could help disambiguate private IRQs too.

-- 
Thanks,
Oliver
