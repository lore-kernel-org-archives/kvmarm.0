Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D6D13440A
	for <kvmarm@lists.linux.dev>; Thu, 29 Feb 2024 19:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709233353; cv=none; b=WAm2KYuBy4Ng1ocNhnRvcGsU63X8JJ7HuyzTV0+GZaIaKsljztk4wTMwUCUDg6N+YGDasPH37q09rW+/WK9k4YeNW15Sv6Ps8eahUjMWu00tsWJxtWThszh8UpWZ4YAtjoFqOc+xBu/g7L+m9z6BwSYY0A1PsIZXkEbjqHxZm5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709233353; c=relaxed/simple;
	bh=KZCXz9Ibsx81p6M3+mklx8Z1uV8isylAHnIe3f9FY/8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X3Id2eyldShwbxRoARv1AxP89Gn9QIvvaIp5X/Ta/WFZM4T0qHhUL07ibtZ5T5DJG2DGoMF+Va613gInMP/2c86Gi3qJ3TMkQm/56IOpJk85avKzTjQqeIzXULnd0o666X113tJG93kEA9N29VcIpdyk2jdDdYDK9jFFI2u6QTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=S8sSC1Gr; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="S8sSC1Gr"
Date: Thu, 29 Feb 2024 19:02:20 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709233348;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rC90JL04sHFzjYZv2DlUZVRoD5V6bcjQdETOSNK1DWw=;
	b=S8sSC1GrQQH7DCK4G8Q4fLTuyJBJU4Ywg0X7Ch0oAgEuE2iNtui+PCyrmnFeXD/f3tqZi/
	xJdBYsKRj8dvgvsY+DEkAlhDach+Sx39WXF62qWI413txBOQj617TMRq4ZTjmA0kVYVrtC
	GjjP6HSjpTflDgxU6UWvbpw5qL/o68c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Clark <james.clark@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: [PATCH] KVM: arm64: Fix TRFCR_EL1/PMSCR_EL1 access in hVHE mode
Message-ID: <ZeDUvMtPO37qV2XK@linux.dev>
References: <20240229145417.3606279-1-maz@kernel.org>
 <ZeDAxL9nr_qmYGS9@linux.dev>
 <864jdr2knu.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <864jdr2knu.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Thu, Feb 29, 2024 at 06:24:37PM +0000, Marc Zyngier wrote:
> On Thu, 29 Feb 2024 17:37:08 +0000, Oliver Upton <oliver.upton@linux.dev> wrote:
> > I was wondering if there was a way to surface these screw-ups at compile
> > time, but there's nothing elegant that comes to mind. Guess we need to
> > be very careful reviewing "nVHE" changes going forward.
> 
> My take on this is that there should hardly be any read_sysreg_s() in
> the KVM code at all. We should always use read_sysreg_el*() so that
> there is no ambiguity about the state we're dealing with (that's, of
> course, only valid for registers that have both an EL1 and an EL2
> counterpart -- registers that are shared across ELs must still use the
> read_sysreg_s() accessor).

Agreed, I was thinking something along the lines of an accessor that
expresses our intent to access EL2 state, but you can't really add
compile-time assertions behind that.

Perhaps it makes the code slightly more readable, but at that point
we're just rolling a turd in glitter.

> It would also free the drive-by hacker from having to understand the
> subtleties of the E2H redirection. The macros do the right thing
> everywhere (they are context aware), and they should be the first port
> of call.

Right, I think the mechanism for poking at true EL1 state achieves a
good abstraction.

> > Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
> 
> Thanks. What should we do about it? Fix for 6.8, or part of the 6.9
> drop? hVHE+tracing is a pretty niche thing, and I don't have any other
> fix for the time being...

Ah, we are pretty late in the cycle, I should've asked :) Happy to pick
this up for 6.9 then.

-- 
Thanks,
Oliver
