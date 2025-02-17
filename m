Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC38225A32
	for <kvmarm@lists.linux.dev>; Mon, 17 Feb 2025 18:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739818443; cv=none; b=n4Vc8YuYgTzTRRXCpfkpaoPRpI2StIdZbjUAIsCR+2SJuGlktY4xC8iVbH3OLoFt0OIjnMBbySiSzVjm5vGeCI3G2Wnk6PWPAGU8yokvoLH9FWlYrqv8ABAnrazhHwCpCc3rxqjWzgWCrJN6tLR3yBioDk02hq/Vsjvhg9YmDvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739818443; c=relaxed/simple;
	bh=ZZfN5HmPh5iB+XYElnFfCLdGJmQKpyPYrWe9zwcheEY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UHKB/NacewPrD8JdzfRFOTN5tazSrTaiNVUlwOoX6nmKlWIAQ8unhiJNQXq7KEH3L39QWcyE/Ve1ZlWY+jytpfCT4LsUjD0kAUG9UA+Tsupfl95dEkF9x4NWOl3ILRgqXaSMmYteryxncNk8yJ1qG/RVpQ+LS+1gdXmnIkjajow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pUXy+3/0; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pUXy+3/0"
Date: Mon, 17 Feb 2025 10:53:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739818439;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zDUFYgrQHlOsuHovpn0q3hLRymzSiYzbhHx/U+nBNRU=;
	b=pUXy+3/023qBomJERxYkElWuMKOVJ+hx7Uql6gAweLqFA2l+elvxPCy1FMiMLHDfHTdFQZ
	5RxN0P8SzXalwCN9i/ZUpFAtxWHbp4ZkvsYCZ1ZOQEli490Aw4zztX2YSMazUUPDJxf/8L
	0TMcBx39t1hY2vqAV534p1K+ENzVuUw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 1/2] KVM: arm64: Fix MDCR_EL2.HPMN reset value
Message-ID: <Z7OFvp7LMcOvWziA@linux.dev>
References: <20250217112412.3963324-1-maz@kernel.org>
 <20250217112412.3963324-2-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250217112412.3963324-2-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

Hey,

On Mon, Feb 17, 2025 at 11:24:11AM +0000, Marc Zyngier wrote:
> The MDCR_EL2 documentation indicates that the HPMN field has
> the following behaviour:
> 
> "On a Warm reset, this field resets to the expression NUM_PMU_COUNTERS."
> 
> However, it appears we reset it to zero, which is not very useful.
> 
> Add a reset helper for MDCR_EL2, and handle the case where userspace
> changes the target PMU, which may force us to change HPMN again.
> 
> Reported-by: Joey Gouly <joey.gouly@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

The existing ABI expectations are that writes to PMCR_EL0.N constrain
the number of counters, so that should have a similar effect on
MDCR_EL2.HPMN.

At the same time, I get the feeling that we should throw out this whole
behavior of writing N to change the shape of the PMU, because it
complete breaks down for NV. PMCR_EL0.N is another one of those fields
that change behavior based on EL and isn't a global source of truth on
the shape of the PMU.

What do you think about adding a new vCPU attribute for selecting the
number of counters for a VM? We can allow non-nested VMs to use the
'old' method of writing PMCR_EL0.N and force nested VMs to use the
attribute.

We can then enforce ordering on the attribute and prevent it from being
used after vCPU reset.

Thanks,
Oliver
