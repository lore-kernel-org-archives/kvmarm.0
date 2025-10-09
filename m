Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F611F09A5
	for <kvmarm@lists.linux.dev>; Thu,  9 Oct 2025 21:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760045447; cv=none; b=RDesmccQ0zpt+5yjmW0gXyT35h0XWeASvazRezcWHWdhF4IjQ8FH1pW7JkRTbFHZnL1TUUOWp/xiBD6NcTZF21ilm33IKacwHi39OgTJoPSaQ6a0dSxXK1mEQ+PIkK3PKXbpe6Ydf47oNXcifk/K8kgy7kTDaViRFLWRNGzH1xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760045447; c=relaxed/simple;
	bh=++/quOYLjEw95EfHjyvc4Cm2aEvAnz8aluCCkeJN3ko=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y9vqyGW2V+rkFqXNNeNCFfciiUlNtG9xJ3T/UlYM3KBu846dI0a3//PWkej0mrVFjoOEV7t/7Dx//mc+bvgEfnEtp+OSsLLkwgbXQboX7LomC01e6gGhPOdYkv7cAmuAY1MrWtU0HJzRCAyunaBUuPerYMI2tQzfoqImOcMfm6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LYBnXVhr; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LYBnXVhr"
Date: Thu, 9 Oct 2025 14:30:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760045442;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hklQ8tRKwaKYDErRF1YB8TiLgUmmzMXzG7ufFj2s09M=;
	b=LYBnXVhr7HKEZhFK/rpCBX05+lNJQbAeLcyG6znaqW322vOApbiJ11HbXmcSeloGn6inU+
	UB1sdWNkpE26QkRLpsDh/SOvJmV4p+EiO5/sLHOdOeCTgGWpbLAYXLOH3hoyqFaxjMlG6T
	9DVXB3nksCyhIe04RrgnTvECZjxrSlY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>, Jan Kotas <jank@cadence.com>
Subject: Re: [PATCH] arm64: Revamp HCR_EL2.E2H RES1 detection
Message-ID: <aOgpesxEKsnbKGs3@linux.dev>
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
X-Migadu-Flow: FLOW_OUT

Hey,

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
		^~~~

Thank you *Mark* for the suggestion here, neat trick :)

I'd be in favor of this patch being sent to stable, happy to handle the
backports if you don't have the time for it. VMs mysteriously dying
isn't a very good experience on NV and I'd like to not scare folks away.

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

Thanks,
Oliver
