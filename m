Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC7832E6BC
	for <kvmarm@lists.linux.dev>; Thu, 22 Jan 2026 17:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769101372; cv=none; b=IPyxTksrEdcZoLGmkKI3YzZy/NMM5U3oWqAnM2z3CDZHJEtaIZsLj/fQcQlKYYrRjqIjfdmx/7F5ttLcOqTlKt2Zpf/j1VXZBiXrUg6Fs2QssIF0TMr2YHQWseAZpXoTR35YPYIXDwyi9gC6H8EXLAWsegqQxzt0F04fh3F96aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769101372; c=relaxed/simple;
	bh=8Di+d5LNGkQeLD8QHMF/2WgXm18OJxzuQn6e5pLoWSo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s0DqGNv3XJtJvcGZXx3mxYl8kLjxlpqZ3fPtzZtuqZw4YnS4EsbIU7TAWp9vSePaMrbrMWBprwjKeqfX/3Qn6bBQGihU3KVcfj+WxCyeK2f6LWrNMh791hE16aldCseRi8SHDCtz73zin4tp95hC5BMVwai4LSDyj89IfafoP2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GGFZUicX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GGFZUicX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C979C2BCC7;
	Thu, 22 Jan 2026 17:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769101370;
	bh=8Di+d5LNGkQeLD8QHMF/2WgXm18OJxzuQn6e5pLoWSo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GGFZUicXfLJgtlq2ZWK19Hli0iSf4cGT7AXDv34CmVl85T4HWXWiRBkrN7He/TQrY
	 JIW8KRgYsXEQCcrDyUgDusbiDPea5gqLbz8wpkje+SKPSY+AkHW7pVZeEBEZbhveF4
	 4olUq5fAwTYeH6iyVcQGOA5tskAeUTwWAKLEFxM0MbTE/P+AzzPrg43snhKnSz19Io
	 cST22gK/10YNjAtUV1X51LnodAjX8Z24Yk1+eLKVf1CJLGtrGLwHBiIssKr922tVrp
	 unoW06EKd94S3n5XFwj+PI5e6vrS/6gAM9bG8IvDh81RdDQsa92lJlcLb/IMGI9wfN
	 l068kEHkUTHIg==
Date: Thu, 22 Jan 2026 17:02:44 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 2/3] arm64: Unconditionally enable PAN support
Message-ID: <aXJYNNmg5ZYdx-5c@willie-the-truck>
References: <20260107180701.2858276-1-maz@kernel.org>
 <20260107180701.2858276-3-maz@kernel.org>
 <86sebxc2qq.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86sebxc2qq.wl-maz@kernel.org>

Hey Marc,

On Thu, Jan 22, 2026 at 11:21:01AM +0000, Marc Zyngier wrote:
> On Wed, 07 Jan 2026 18:07:00 +0000,
> Marc Zyngier <maz@kernel.org> wrote:
> > 
> > FEAT_PAN has been around since ARMv8.1 (over 11 years ago), has no compiler
> > dependency (we have our own accessors), and is a great security benefit.
> > 
> > Drop CONFIG_ARM64_PAN, and make the support unconditionnal.
> 
> Since you mentioned that you were planning to merge this patch, I'd
> like to point out that a related change[1] is on its way to Linus via
> the KVM tree for 6.19. It is also in -next due to dependencies.
> 
> Could you please place these patches on a branch that I can pull in
> the kvmarm tree to resolve the conflict? It really amounts to
> reverting this patch now that we are guaranteed to have PAN on an
> PAN- machine.

You can use for-next/cpufeature. It has these plus the LS64 stuff that
you might also want to pull into the kvm/arm tree.

Please yell if you have any issues.

Cheers,

Will
