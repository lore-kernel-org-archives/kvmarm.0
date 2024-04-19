Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5CA2837B
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 20:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713560084; cv=none; b=OziYkKLi+YoCbvc8eKkQiqoIRnlnwslAVoPiDKYJn4UInUHUYJdOGmh68Gfyv/VZhwHITanbDTuKbCjaJ5L/ob+2SdUwTiK+fwWDgiBlUStrj5T+kt7tE3CxLqIfssVy+1ExpySOXYPBwOu+Y4pWPKi8uWmYKc13mlKB/i9hIO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713560084; c=relaxed/simple;
	bh=9koETq/9rLFOYlOJKP5IWZdleX22IPjmf7dehIz9//E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qFBBQ9h4pkdK4qhGxJpmBonWDSkA9B1MV3Kjs7PFATtFnP67NrwNb+ALFEsActBwW9HEb2la8OX0jXdvcFeV4D3ezb8PVYf3O9j68RlKU2mMoesDRSDcTZ7qfx/PSS5YeX+k7FMRTY3BKfo2j5zD3NIQDGTysMWE9nhniYoJIV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Jvi9YHJU; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Jvi9YHJU"
Date: Fri, 19 Apr 2024 20:54:35 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713560081;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b+RsVYsv17yWQFfHKKYHzduHhKry3q+OxTSMtzdrpU8=;
	b=Jvi9YHJUv4QMqodVKJdGfxKgnwci1aus6i8hUr/CS4K6r/xyIu4+QO81w9PmhOel9JueYt
	YQrReRTNUJFqnXZljCgyG11uB4TQGEJBPNwNfVFsBj+RSFnQC3iOCLcXjOym9N2lxv0NJW
	wi00rmSiDNjvIDbo+5Rw3kPjqVE6Q3g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, will@kernel.org,
	qperret@google.com, seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, mark.rutland@arm.com, broonie@kernel.org,
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Subject: Re: [PATCH v3 09/31] KVM: arm64: Support TLB invalidation in guest
 context
Message-ID: <ZiLaC8nrfcp9lDTD@linux.dev>
References: <20240419075941.4085061-1-tabba@google.com>
 <20240419075941.4085061-10-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240419075941.4085061-10-tabba@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Apr 19, 2024 at 08:59:19AM +0100, Fuad Tabba wrote:
> From: Will Deacon <will@kernel.org>
> 
> Typically, TLB invalidation of guest stage-2 mappings using nVHE is
> performed by a hypercall originating from the host. For the invalidation
> instruction to be effective, therefore, __tlb_switch_to_{guest,host}()
> swizzle the active stage-2 context around the TLBI instruction.
> 
> With guest-to-host memory sharing and unsharing hypercalls
> originating from the guest under pKVM, there is need to support
> both guest and host VMID invalidations issued from guest context.
> 
> Replace the __tlb_switch_to_{guest,host}() functions with a more general
> {enter,exit}_vmid_context() implementation which supports being invoked
> from guest context and acts as a no-op if the target context matches the
> running context.

I'd rather not introduce unnecessary asymmetry between the nVHE and VHE
TLB invalidations, the code duplication is annoying enough as is. Can
you rename to {enter,exit}_vmid_context() on the VHE side as well?

-- 
Thanks,
Oliver
