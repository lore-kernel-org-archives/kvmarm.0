Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A454843AA8
	for <kvmarm@lists.linux.dev>; Mon, 12 Feb 2024 20:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707770418; cv=none; b=Ymk1fctUh3yCi/6wKctt5eEOQ1yLPIUoih94WvpTT/XM7B3kEuybbSoJK0krgT/UDwKnsjUSeHprzJs15RcS4aCwkViF68gFdn6Bz0msjdKVXIUz6ox34byTvt8e/9WgFfxDpjY9oL4glHGH7r1WCb3fjTHIQ1MdMh8Dn0Sn2TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707770418; c=relaxed/simple;
	bh=miMuI9wZpwSybczsfBp3fStDaxVi6pe02CNZLYVhiik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O6WWKhgQhFRHcEwFqHCKZRBIeTSS0vLdJO1G7yuHMJ4M6JoMIVxAjzgK0lRkgwxdk1QEyZbpy0ibWClMrNozW5dZZD5rlDIcS9jDR+l4IgzPYHTO3W74ueRSqg8d5TtTBm10jN96zOwzS93p4/WBLDsYaZPUPykxc04NA6bVoNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NhD5yrjG; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NhD5yrjG"
Date: Mon, 12 Feb 2024 20:40:08 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707770414;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7nC0yQEK2ZP/P7RnX3Z3hQsI/3gbnKEFNnLlhsCr13s=;
	b=NhD5yrjGqdHFBA0i1+DDxAyn1d0cRMs2xwQ/2yp0lnHjiy5wbtOucUCJqw3g3+OlWBpi+l
	xutG0C1XjUnuwrfcb4qAnaGp1wPTjryq8EFr5k9/P/gvLNfpuDIBUuhgNPWcAA5kspX4Oo
	pOBVqVF/Uyh8ZC8o+JAPmdWb5XNqTuw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v3 00/26] KVM/arm64: VM configuration enforcement
Message-ID: <ZcqCKJOb2TeujGYV@linux.dev>
References: <20240205103431.1104133-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240205103431.1104133-1-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

Hey Marc,

On Mon, Feb 05, 2024 at 10:34:05AM +0000, Marc Zyngier wrote:
> This is the third version of this configurationm enforcement series
> after some heroic reviewing from Joey (again) and Suzuki. Many thanks
> to both.
> 
> I think I have taken most of the feedback into account, but please
> shout if I have ignored something.

Want to make sure intentions are abundantly clear on this series, as
there's been a decent amount of attention from folks on managing VM
features.

At the very least I plan on taking the first two patches for 6.9 so we
have the groundwork to enable new feature work. I'd like to get more
eyes on the tail end of the series. I'm going to catch up on the work I
need to do for this merge window (including posting my own crap!) then
come back to reviewing this afterwards.

-- 
Thanks,
Oliver
