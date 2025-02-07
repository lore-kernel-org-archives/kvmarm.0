Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388548479
	for <kvmarm@lists.linux.dev>; Fri,  7 Feb 2025 18:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738951444; cv=none; b=JftDWR1RAyCFFr4I19DTAf7en8zHyt8K/qj9q2QPoDHAn69lH+S4Fo5Jbvva7lmdOe+XWOCp9yKz7cUOMUE33TYchdA18eMsrHI/kz+KlyUMAGMnY4vzsuQAiKSSk/1NifulKX6364B+tTOVrS7xCIxTBYVcNaF56UcVm4z72Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738951444; c=relaxed/simple;
	bh=Gs1qh+B0RQCLp6WLhye/L0Za0eB52yBA3wutFjUiy6I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U/D9KxXBBGkLFP7HORq0UsOzF4v7+FFNB1zyRFm5eV8odXkSuxNJYllUGUocYGtjrYGrm++gPJsX1SOn5y+jp5bzO2O9ZKzE3jH98zQJTKSLMw380bGSR5NUwpFjqavuGbijUDVNiENLNLEMIS2rVhcYurt8bVXJAgZ8dr2FJTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Wys31Zvm; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Wys31Zvm"
Date: Fri, 7 Feb 2025 10:03:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738951439;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lP512jh6/P7PyHlGLlEdyRyOeCzvFzG5Z4L3Sl7a2ok=;
	b=Wys31ZvmlScsSgLLqTvRzMIEwOGGNl420jFLRlljNH2OyqIoPgKzp/bVDGhfXO5+6P1FLU
	tYJYlUxSTt3J18jRdITFGrDRc/VmmRb2IMIa73wundFbb9ltI4DgggzCQkbGEJ6L2VqmLG
	DPtbIPrLTciteCxbAsEDClpGQjm7Mh4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Alexander Potapenko <glider@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 0/3] KVM: arm64: Assorted vgic fixes for 6.14
Message-ID: <Z6ZLC1v5KU-zzbQR@linux.dev>
References: <20250206152100.1107909-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250206152100.1107909-1-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Thu, Feb 06, 2025 at 03:20:57PM +0000, Marc Zyngier wrote:
> Alexander, while fuzzing KVM/arm64, found an annoying set of problems,
> all stemming from the fact that the vgic can be destroyed in parallel
> with the rest of the guest still being live.
> 
> Yes, this is annoying.
> 
> Fixing this is not going to happen overnight (though I have some
> ideas), but we can make what we have today a bit more robust.
> 
> This is what patch #2 is doing. Patch #1 is just removing a loud
> WARN_ON() that serves little purpose, and patch #3 fixes the actual
> bug that Alex reported.
> 
> Hopefully, none of that is controversial...

I'm a bit grumbly about slapping bandaids on the problem, but given the
fact that glider reported all of this a while ago and we still haven't
fixed it is enough to justify these patches. So:

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver
