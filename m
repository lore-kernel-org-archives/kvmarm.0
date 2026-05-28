Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 554AD3B4E80
	for <kvmarm@lists.linux.dev>; Thu, 28 May 2026 09:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779962147; cv=none; b=du9IFjiVwOzI/Gq88b9DjuTgt+eC9MKjHRqQsGNP1Ku7JzFs/i+JIguCwlZqM9jRkFhX1IlfdXVP4C0D2w49d9giLhY2TF3nfdjCZ7Tkq+eR4God5TKqQTF/Thp/ssNvnfnkJ4sXzvhJZkcgv2ewuNcrXEjt5ELeXiYddIu8j6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779962147; c=relaxed/simple;
	bh=+1wVAqRlhKf3c7sqkfh3JBpBe6PeJ2dRxvJY09h7QHQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ex7oVpCzJWB1Iuo3u8Wbe8deOla2U9vggWTcRDjMPe0UPVgOLmYNuitnr/eJjTFltFjZqV00VLA33jjgzBE6f2ncVs82GdsCgCAQxofdJYyxTJF2PteDmRtMEFqHqxhOjUbssGNDf3744dElltoLbDLm8QzurfRAfDfL0V+uEH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TTlk7cJD; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TTlk7cJD"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A7BE443F7;
	Thu, 28 May 2026 02:55:40 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B76AA3F632;
	Thu, 28 May 2026 02:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779962145; bh=+1wVAqRlhKf3c7sqkfh3JBpBe6PeJ2dRxvJY09h7QHQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TTlk7cJDqHd0sZQpXVRVYcD8hxsY6lBkBhBkA+r5F0517v337AbDj6Qob2Uun5d7/
	 +BrBqlc5JPktWsiJejt+fw8ZV98X970/iuDUw9V69xjxreNfvu0kcmuzwTA/e06Py9
	 TMROGBUZVEZn/yeCGvnszzxxS2oR0vLKbNfFjb9s=
Date: Thu, 28 May 2026 10:55:32 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Cc: Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 0/4] KVM: arm64: Handle unsupported guest translation
 granule sizes
Message-ID: <iyfrjjhqej65nrfwmkws7kknpdcqr4uyzdtte3exlgf3ghfhux@pdi2wbnyyzcx>
References: <20260414000334.3947257-1-weilin.chang@arm.com>
 <177996023466.1525303.2108207515102273832.b4-ty@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177996023466.1525303.2108207515102273832.b4-ty@kernel.org>

On Thu, May 28, 2026 at 10:24:01AM +0100, Marc Zyngier wrote:
> On Tue, 14 Apr 2026 01:03:30 +0100, Wei-Lin Chang wrote:
> > This is v2 of fixing the granule size selection for software stage-1
> > and stage-2 walks. Thanks to Marc for the feedback on v1 ([1]).
> > 
> > * Changes from v1:
> > 
> >   - Take the entire (v)tcr value for TGx decode helpers.
> > 
> > [...]
> 
> Applied to next, thanks!
> 
> [1/4] KVM: arm64: nv: Rename vtcr_to_walk_info() to setup_s2_walk()
>       commit: a878096e0e86b44e758aafc6b26af97e8f548673
> [2/4] KVM: arm64: Factor out TG0/1 decoding of VTCR and TCR
>       commit: d7768b4f718503e79e7c626d29e9131b747148ee
> [3/4] KVM: arm64: nv: Use literal granule size in TLBI range calculation
>       commit: b154da8288add1f6fb958797d0b3462800f9fc77
> [4/4] KVM: arm64: Fallback to a supported value for unsupported guest TGx
>       commit: 8853566dfbab1a255ae72676ab5ec43e1631ddb7

Thanks for fixing the small issues!

Wei-Lin Chang

> 
> Cheers,
> 
> 	M.
> -- 
> Without deviation from the norm, progress is not possible.
> 
> 
