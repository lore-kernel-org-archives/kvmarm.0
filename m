Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B83028FFFB
	for <kvmarm@lists.linux.dev>; Thu,  9 Apr 2026 15:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775747633; cv=none; b=Bzn0dZpyt5F8/hasDQk9K8BNob9QDLJXzaA+N6SFOWq5cu8qOVrZpZ6wkKkqzJ+DntPxJ4TsZxOQ0Gk4EsxEzzQlI8CqZN7T+0q4pHhVqYYTqA+5N9mhp9S02vRdWNLhwv+hKuidjspVL+vBnY/uzE3qY8ZbMNncuucXMywdNDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775747633; c=relaxed/simple;
	bh=aUbgZw7dA8jv4vpUf4Nf8KyWibYIl9xbNH07Y9ty3mM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O4TR33LaeAL/lP1X4aATq549wFwHj0FKnPcw1vEEkXuADanfwNgm6la0AC+IuSPaRcg59qg4xGE4is4yMIGiBjIVdfNsOLRwETZX4/2cYGxyMcKkFPcLYasoBIYIlweejI0AO64zChuJWHPl4IbM2pjCXqF0ZXp07+Iu9Nec4XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hef8DwhP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hef8DwhP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23C35C4CEF7;
	Thu,  9 Apr 2026 15:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775747633;
	bh=aUbgZw7dA8jv4vpUf4Nf8KyWibYIl9xbNH07Y9ty3mM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Hef8DwhPQrLV1ZVZMGuUv+BMom2DjWCDE2uJwGGjz4NKv9Boe6tK+mwSr6FRdApqq
	 18+LSH0uCuMniZAbNXx/11hkQiMzezSYzRJLp8K56+WKolcds+CzzwwdVo+2rrL4eY
	 SU/zUWVJ093xblL6mOFVVGM9H05WOM+ECzvycjdBwzK17vdMRRp9nH49+sSWYQ3toe
	 VI/ZcUkzwCg/2pWY3Rzq9gK7phUhWFxzqFY+xSZyj1Y9CqBFBTs3LVXodCtrDP4APo
	 Dwqs2rIge8ZmJm57vCv4ogsjf/oEP+gpZ/24HdOr5+IXEjtQqAEdEgeRlZCCMaN4dO
	 7gezgodKo4uCA==
Date: Thu, 9 Apr 2026 16:13:47 +0100
From: Will Deacon <will@kernel.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: catalin.marinas@arm.com, joey.gouly@arm.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com,
	maz@kernel.org, oliver.upton@linux.dev, suzuki.poulose@arm.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH 0/4] arm64: mitigate CVE-2024-7881 in the absence of
 firmware mitigation
Message-ID: <adfCKyzq_R5OSBaY@willie-the-truck>
References: <20250317212611.GA12724@willie-the-truck>
 <3c9c567f7a6e926e8ec24913d564ec55e8f450d2.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c9c567f7a6e926e8ec24913d564ec55e8f450d2.camel@infradead.org>

On Wed, Apr 08, 2026 at 10:26:10PM +0100, David Woodhouse wrote:
> On Mon, 17 Mar 2025 at 21:26:12 +0000, Will Deacon wrote:
> > I'm really not comfortable with this series and would prefer to see it
> > dropped while we continue the discussion, especially as it's causing
> > minor conflicts with the KVM/arm64 tree in -next.
> > 
> > ...
> > 
> > To be clear: I'm not at all against mitigating this problem and
> > advertising the status of that mitigation. I *am* against quietly
> > handling it like a CPU erratum whilst simultaneously telling userspace
> > that meltdown is not a problem regardless of the mitigation state.
> 
> Was there a conclusion? KVM still isn't even exposing
> SMCCC_ARCH_WORKAROUND_4 to guests...

I didn't see another version, so I think my comments (from a year ago!)
still stand.

Will
