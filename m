Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93494FDA4E;
	Tue, 29 Sep 2026 09:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790675887; cv=none; b=i4y3Fmp0ZoZ33VWrXoJxYv+RIN7vHSojdHKMq5T64xjkIZTVWugfgMzcFJ0plxR/5gBdbyZI6ysBpKStdDAaIxZd7gfdI4Bm5QDCWWVOElz3S9qPbJDrLcsBMKKyMNnWYKj0tsfQds05HEo5pOU27sGZkcz5zmQG7yrfDFEinVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790675887; c=relaxed/simple;
	bh=0/luRpdNvze2pCejIkTcXaz0Po23baj/UwWF7iM1wto=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZbJLH/2cl2HkLRd4KXj63N1uG72OFf5cg9CFu88CcqCXrDX3AHLRuSIztD7LAS+ZmDDFXImpNh3Vhl8BcH7Hr+Oyaiqrfrj7Vv8qHitSrG0rOJYk3xOLGXZUaWUGXLh4h6detNBPKx6l5xFhQsGX12qih52cmo7N4WCZxRhVZZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ogB2QEzt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ogB2QEzt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2DDD1F000FF;
	Tue, 29 Sep 2026 09:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790675883;
	bh=0/luRpdNvze2pCejIkTcXaz0Po23baj/UwWF7iM1wto=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ogB2QEzth7HT0QX3a0wnderNpXhz0ZZOK2dFMZC1T5OFluPQZi3eYJ8VV6xVnSrPU
	 WABAito16faLT92FOh2pAZu6PftBHzwiIDiZptvqT/gi1g7jghoHMUwkkuQs23/ee6
	 CoeM8/Wb5/WEFosWv53Dd56eyEt9ptn1A49iZiI7DCybkykDHJQ7RG/pPIBthL1gar
	 CDdqndKuEj2PUOkywMzI/USEIB5OC3MhaFcQhJa0QP2I3Pm+Dx0HSzfx4/9JAHG26V
	 X06NVBOOO9tor0tnZ9GWGQ1b6Rw7Wdu4Rbn1kmb9czIFKNA6TyS71dWF43UzXGrdI5
	 qWxCAirpFosoQ==
Date: Tue, 29 Sep 2026 10:57:56 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>, 
	Peter Maydell <peter.maydell@linaro.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] KVM: arm64: selftests: Check ID regs are
 immutable after a failed run
Message-ID: <aruLlvDysARBIjSZ@gremlin>
References: <20260901-kvm-arm64-idreg-final-v3-0-a0ffa06fa872@kernel.org>
 <20260901-kvm-arm64-idreg-final-v3-3-a0ffa06fa872@kernel.org>
 <arp7mig_PrD9Jbc7@gremlin>
 <83a389d3-6328-4762-a96f-46f9f7145b0e@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <83a389d3-6328-4762-a96f-46f9f7145b0e@sirena.org.uk>

On Mon, Sep 28, 2026 at 05:31:56PM +0100, Mark Brown wrote:
> On Mon, Sep 28, 2026 at 03:46:51PM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Tue, Sep 01, 2026 at 07:18:50PM +0100, Mark Brown wrote:
> > > From: Fuad Tabba <fuad.tabba@linux.dev>
>
> > > Assisted-by: Antigravity:gemini-3.1-pro
>
> > NIT: we changed the rules for the Assisted-by tag, it only needs to be
> > 'Assisted-by: LLM' now. Not a huge big deal but FYI :>)
>
> > https://docs.kernel.org/process/coding-assistants.html
>
> That's Fuad's tag not mine, I've just picked up his change verbatim.

Ack yeah, understood, and it's not a big deal at alL! :)

--
Cheers, Lorenzo
