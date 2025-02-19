Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346D722ACD1
	for <kvmarm@lists.linux.dev>; Wed, 19 Feb 2025 19:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739993116; cv=none; b=aBisbZumimso8aGpQhiN5st1kLjmSiK7FgPSmVF+0/dpHh1YmlYapM39on7g+19U6oAhLXQcusrjYjUajH+mMT3dmODqcHvsTw+qUx4hGxqIbrkWKKm74GGPpDMnleqczK/bucRjMLRBPLYMsuEfJuk/dlmzMyp+N5AaYE2WaAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739993116; c=relaxed/simple;
	bh=SykixatIZerodgATAwVcTB8LToqqQLkJFQdVB2OSm9Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bi/xlr/Y0jvwllcBcMVL6aB/Vlw+kmRR/MJ7IbP07c4tJBrIPOJWa5v21Wzl/WVL3SXS4L3+4WrNb6z72e3krIZVImA0qn9yLmacnnIumcp6nIXc8myQmZDxD+XD/xqvZEwasx3OGK/ISusF91bDfQKI3xga5YCqBXI8m3OMVwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HAo43khA; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HAo43khA"
Date: Wed, 19 Feb 2025 11:25:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739993112;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YWbTsmkFNVzUKGQASgjUS1od0uhjMSBLNuVdbUo2uHQ=;
	b=HAo43khA9DU1uLsdSMUg9nTVrQVQR5iWPGhSRHK2Wp8bg/ugmPa8asiQlOuuhyqh54C2El
	P0Ec3ptzNRyg2MaUQjrQu3nWUclL3MWyd0WopanhROR742V2qiKu4g9fHcKmpvzW/7fYJq
	QFG4ENuIdGD3oxElJek7m3LHNJSXlG0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Janne Grunau <j@jannau.net>
Subject: Re: [PATCH v2 06/14] KVM: arm64: Remap PMUv3 events onto hardware
Message-ID: <Z7YwEptbRnX5s9Fw@linux.dev>
References: <20250203183111.191519-1-oliver.upton@linux.dev>
 <20250203183111.191519-7-oliver.upton@linux.dev>
 <865xl5sx20.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <865xl5sx20.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 19, 2025 at 04:45:27PM +0000, Marc Zyngier wrote:
> On Mon, 03 Feb 2025 18:31:03 +0000,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > Use the provided helper to map PMUv3 event IDs onto hardware, if the
> > driver exposes such a helper. This is expected to be quite rare, and
> > only useful for non-PMUv3 hardware.
> > 
> > Tested-by: Janne Grunau <j@jannau.net>
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  arch/arm64/kvm/pmu-emul.c | 14 +++++++++++++-
> >  1 file changed, 13 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> > index 62349b670cf9..60cf973e2af9 100644
> > --- a/arch/arm64/kvm/pmu-emul.c
> > +++ b/arch/arm64/kvm/pmu-emul.c
> > @@ -673,6 +673,18 @@ static bool kvm_pmc_counts_at_el2(struct kvm_pmc *pmc)
> >  	return kvm_pmc_read_evtreg(pmc) & ARMV8_PMU_INCLUDE_EL2;
> >  }
> >  
> > +static u64 kvm_map_pmu_event(struct kvm *kvm, u64 eventsel)
> > +{
> > +	struct arm_pmu *pmu = kvm->arch.arm_pmu;
> > +	int hw_event;
> > +
> > +	if (!pmu->map_pmuv3_event)
> > +		return eventsel;
> > +
> > +	hw_event = pmu->map_pmuv3_event(eventsel);
> > +	return (hw_event < 0) ? eventsel : hw_event;
> 
> I find this a bit odd. If we can translate events, but failed to do
> so, we still install the originally requested event, and we have no
> idea what this maps to on the HW.
> 
> I'd rather we just don't install that event at all rather than
> counting something random.

Heh, this was a leftover party trick that I was using to try "raw"
events from inside a VM. Happy to limit things to the PMUv3 event space
though.

Thanks,
Oliver
