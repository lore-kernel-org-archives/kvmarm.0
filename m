Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05491C5F23
	for <kvmarm@lists.linux.dev>; Wed, 17 Sep 2025 05:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758086482; cv=none; b=pxn3t15PlCwaYPDQ/PCX48luNpl46cSmZ20jMxJD+efPF8nNG7rxnyu2F14PD9+60VvgDSJ7czCNpc63mK/cils3ODwLuGj6DtsJi/HnwNUmqG4I4m7Na77pVcA0WyZ1STds2VtR+hLaT1a8hVi3/NWKNuquMxQpBCuh0uNFTw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758086482; c=relaxed/simple;
	bh=QftlpN5pu6WIwTG0pl52OHhs8s/lZYOjw5tZ8sUEXnk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m99jW7ulbgTVTkC0PE3UfxaT+uh1mJfxcxZcQZZ/SJicEpk1FxNq5M2yh0D12FGL7dv+WQUHon2gfFV/iCko9CydupbFP8J9O72ftxSgga4GF7HAv7221XSKYIwZ/LXzG8QZ/1kFNMxaJRLX6T1iLILjoXHC9Y1T2jmESzjR0E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ONlm1N7/; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ONlm1N7/"
Date: Tue, 16 Sep 2025 22:21:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758086477;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SE80BDLp7RGmNryQ1WRS/aK8000n2rtH3W8fQeIL/c4=;
	b=ONlm1N7/v3ZoW6UPF24U6gmqobIOXl4WGiyNax4nAwwivsgr2dSV79bQR6u9ESl43ku3nZ
	53b8dPxD+kQFT7ZZV4ccOemciEY1RJbAohR3/ZnqDL5Ea3GGFYybmHP2DKihpSBQW81qTe
	ss43SrLNC0BFkB6kA8lhxDzWIyWJ0tA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Fix kvm_vcpu_{set,is}_be() to deal with EL2
 state
Message-ID: <aMpFRYarTozl7Q38@linux.dev>
References: <20250916161103.1040727-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250916161103.1040727-1-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Sep 16, 2025 at 05:11:03PM +0100, Marc Zyngier wrote:
> Nobody really cares about BE, but KVM currently only deals with
> SCTLR_EL1 when evaluating or setting the endianness in PSCI,
> meaning that we evaluate whatever the L2 state has been at some point.
> 
> Teach these primitives about SCTLR_EL2, and forget about BE...
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

You know, I was about to say "don't we need to sanitise this?" although
that seems to already be in place. Nice.

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

Thanks,
Oliver
