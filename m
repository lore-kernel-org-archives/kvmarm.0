Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF5B222587
	for <kvmarm@lists.linux.dev>; Mon, 13 Oct 2025 11:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760354277; cv=none; b=S81Qr/TVw56G4JwVtZFq12TzBOlsH2yZCvq90V7s+v8Rw8XdP4MwDcNre6z2y5jhE8MtznfSGA1j2vKJiEQetnSfHr4kh795eKh07uCEGhWhtzlAIB+d5C7vkaMIFC8QeB1PcugmeXpIONfXZ6RNpAu2j3UbZ1AUbr6elRW6030=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760354277; c=relaxed/simple;
	bh=sY89/6Dacq1qFYsIHAuhpoIT/fPwZiv/ml+mZ4Z1CH8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X3XMhT4TPjBY9U5XZl49STnWF55yRJR8/K9+3DW4ltTPREXnQ31Bbup8wujGkp/uZAE7UR0OW0amc+b+pfmSnex7fvkc5jilP3PpbaFaZIB9JLEo+TMQoFo67WlBlkPgFIG4HkQHDddIHoLOQfWGKwL8iSH/ogZS2ec79iZ+7mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC4CC4CEE7;
	Mon, 13 Oct 2025 11:17:54 +0000 (UTC)
Date: Mon, 13 Oct 2025 12:17:52 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, Jan Kotas <jank@cadence.com>
Subject: Re: [PATCH] arm64: Revamp HCR_EL2.E2H RES1 detection
Message-ID: <aOzf4A6nVZhnLvka@arm.com>
References: <20251009121239.29370-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251009121239.29370-1-maz@kernel.org>

On Thu, Oct 09, 2025 at 01:12:39PM +0100, Marc Zyngier wrote:
> We currently have two ways to identify CPUs that only implement FEAT_VHE
> and not FEAT_E2H0:
> 
> - either they advertise it via ID_AA64MMFR4_EL1.E2H0,
> - or the HCR_EL2.E2H bit is RAO/WI
> 
> However, there is a third category of "cpus" that fall between these
> two cases: on CPUs that do not implement FEAT_FGT, it is IMPDEF whether
> an access to ID_AA64MMFR4_EL1 can trap to EL2 when the register value
> is zero.
> 
> A consequence of this is that on systems such as Neoverse V2, a NV
> guest cannot reliably detect that it is in a VHE-only configuration
> (E2H is writable, and ID_AA64MMFR0_EL1 is 0), despite the hypervisor's
> best effort to repaint the id register.
> 
> Replace the RAO/WI test by a sequence that makes use of the VHE
> register remnapping between EL1 and EL2 to detect this situation,
> and work out whether we get the VHE behaviour even after having
> set HCR_EL2.E2H to 0.
> 
> This solves the NV problem, and provides a more reliable acid test
> for CPUs that do not completely follow the letter of the architecture
> while providing a RES1 behaviour for HCR_EL2.E2H.
> 
> Suggested-by: Marc Rutland <mark.rutland@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/15A85F2B-1A0C-4FA7-9FE4-EEC2203CC09E@global.cadence.com

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
