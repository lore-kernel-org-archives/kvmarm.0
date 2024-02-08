Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EEC774E27
	for <kvmarm@lists.linux.dev>; Thu,  8 Feb 2024 12:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707395426; cv=none; b=ksGw7C2Nx7LRXJFBMU066e+xctNlnl2zU1ScCDXdMkkl5DsHwyRuKtdB/Fdth8vPoZvRtZZif3UUIL7qflHgovNkvuDzKqSEDwjASxbJRC2I1JBelyt01NjgJkNjsTOU4GkgVtWnqeBk5niZwZKys3sRa9GNR9IeGIwjJ0vhUaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707395426; c=relaxed/simple;
	bh=2vTN5YIeZ0RSvrSF6C0aE4zMxwHMEO4V6PIx/f0tzVk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Em6sstOQ/5BWJpgrcUBiIfgMO5K0uGUE+hcoo31ALVHdtnGWcE++DmZZq6SD8kNYxkGPWcwVWPd3tKAIL2gAIWjvpgV2mIAA7xWjii5ZHyf+PyAJQZI9eLih+5UPjK5do6z4ZohAVXnEdo4LCHgKA63B3uscO8JfIuYdKnj7b00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F19371FB;
	Thu,  8 Feb 2024 04:31:05 -0800 (PST)
Received: from arm.com (RQ4T19M611.cambridge.arm.com [10.1.31.53])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7D9233F5A1;
	Thu,  8 Feb 2024 04:30:22 -0800 (PST)
Date: Thu, 8 Feb 2024 12:30:20 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>, James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v4 00/10] arm64: Add support for FEAT_E2H0, or lack
 thereof
Message-ID: <ZcTJXBThmtRmNbG8@arm.com>
References: <20240122181344.258974-1-maz@kernel.org>
 <Zb08fXz23JUiF4hD@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zb08fXz23JUiF4hD@linux.dev>

On Fri, Feb 02, 2024 at 07:03:25PM +0000, Oliver Upton wrote:
> On Mon, Jan 22, 2024 at 06:13:34PM +0000, Marc Zyngier wrote:
> > Since ARMv8.1, the architecture has grown the VHE feature, which makes
> > EL2 a superset of EL1. With ARMv9.5 (and retroactively allowed from
> > ARMv8.1), the architecture allows implementations to have VHE as the
> > *only* implemented behaviour, meaning that HCR_EL2.E2H can be
> > implemented as RES1. As a follow-up, HCR_EL2.NV1 can also be
> > implemented as RES0, making the VHE-ness of the architecture
> > recursive.
> > 
> > This has a number of consequences, both at boot time and for KVM,
> > though the changes at that level are pretty minor.
> > 
> > The real meat of this series is on the cpufeature front, as FEAT_E2H0
> > is a *negative* feature, where 0b1111 (-1) represents E2H being RES1
> > and 0b1110 (-2) additionally indicates that NV1 is RES0. Fun, isn't
> > it?
> 
> This looks good to me. Catalin + Will, are you comfortable with the
> cpufeature changes at this point?

Yes, I acked those touching the arm64 files.

> No strong opinions on which tree these patches get applied to. Most of
> the series is non-KVM code, so I'd understand if y'all wanted it to go
> through arm64. OTOH, there are some other KVM features that might appear
> in 6.9 that build on top of this, so at minimum I'd probably need a
> shared branch.

Please take it through the arm64 kvm tree but keep it on a separate
stable branch in case I need to pull it.

-- 
Catalin
