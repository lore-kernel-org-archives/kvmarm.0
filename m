Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BFA016E863
	for <kvmarm@lists.linux.dev>; Wed,  2 Jul 2025 02:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751423776; cv=none; b=Nli/+WmpdYb7qs2yTFtl4m4kXVVOouDIu2AELBtSh2sJTuuFQ2iJZo1wKfASahHJIl7X2UZTSxaFhcFKpLl1O/B2vXSqxXKO8/AU2FEcgfAomggOwRI8SRT9X4MkzX3rDG07L9puyGLe4EGkVajyeNuB0DuQvuOhSPBvh1CjnIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751423776; c=relaxed/simple;
	bh=AsBrLdos1kHFbDNQGHzKxXg2MyIrf8+sLD7bKlJ6DCw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MCr8uT7dXIEotsarHXp9QylTlnMZVd6idHlOALrM6SGTgYNztkecEZ7Uxv2hG4uSFdrs7u6MA9a/Sj8C5e2CFRC7uUOehjJYdVa6/n8tcpM/AlfQMEY8K6NIp4Cr8N5nuHuKmtsFKtncXG0Z9yeB5vosGSr2NWZwKPVsX1wpm/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=q1ImAjnq; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="q1ImAjnq"
Date: Tue, 1 Jul 2025 19:35:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751423767;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=meP0nWxBYtOmbYuZoRiD0xIcdeono4twB9y3cgBno1k=;
	b=q1ImAjnqrDXSFacojUICjv60DaxyxDUF83izasHJJbCfmo5IKh8KIPyPBFQ7+QSCe6s6Ip
	lzeHRTpz8sJyr2JRxJGZT8slerFqn1ndyddS+bN4hBZfPbRhNw7V0T/EMk2rrMEje1wLIp
	WWZ8GTWiSBhcC2NGUrzT36hIiXsaJ2k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Fix handling of FEAT_GTG for unimplemented
 granule sizes
Message-ID: <aGSbABNGiAaOqSo1@linux.dev>
References: <20250701142225.753984-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250701142225.753984-1-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Jul 01, 2025 at 03:22:25PM +0100, Marc Zyngier wrote:
> Booting an EL2 guest on a system only supporting a subset of the
> possible page sizes leads to interesting situations.
> 
> For example, on a system that only supports 4kB and 64kB, and is
> booted with a 4kB kernel, we end-up advertising 16kB support at
> stage-2, which is pretty weird.
> 
> That's because we consider that any S2 bigger than our base granule
> is fair game, irrespective of what the HW actually supports.

While this is ugly as hell, it is _technically_ OK though right? Since
we always shadow the stage-2 MMU we can emulate the otherwise
unsupported page size.

Now, mismatched granularity at S1 and S2 is a massive can of worms we
should not entertain :)

> Add new checks that will verify that this granule size is actually
> supported before publishing it to the guest.
> 
> Fixes: e7ef6ed4583ea ("KVM: arm64: Enforce NV limits on a per-idregs basis")
> Signed-off-by: Marc Zyngier <maz@kernel.org>

It'd be good to clarify the rationale a bit further in the changelog,
but full agreement on disallowing this sort of stupidity.

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

Thanks,
Oliver
