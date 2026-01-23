Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C8C02848A7
	for <kvmarm@lists.linux.dev>; Fri, 23 Jan 2026 15:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769181444; cv=none; b=pw6gqTSK6KRx3lzR5dDTwk/BCXztL4Hi7Qv86j9mpnZbc+XVCdjHLh0y+vgr7k0YzINFyIexzCadxKlN5u7F4g6fmFx4JTDw6Z9ttULk78QY778UmrijTklrTWiBWn3zlRHPYlDUbz1Zj6Igp7CyENcfzbu6c+jWvR6xjOp4rIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769181444; c=relaxed/simple;
	bh=sUGwZyevPX4oX3b8wyABKJcckEZO3PSM9bEe0zfYMXk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KWeKXcjT1uIVUJ0JqbhJfnMwWY1G4CqbzYkLqLsk/wvNP71FRKQw3k4GVAOKdJxSuulG2OwXM7IDMYM6qLLbi/61HTcRwXd3fdI/anqhKN/hmOu1d5DLw0nrck2rjRcjwfYd96Lm0oQ/z+Hpix/AZ2ilERuVOW8ZO+Afggcog3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 491A31515;
	Fri, 23 Jan 2026 07:17:14 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0181E3F632;
	Fri, 23 Jan 2026 07:17:18 -0800 (PST)
Date: Fri, 23 Jan 2026 15:17:15 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>, Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH 0/6] KVM: arm64: ... and FWB for all
Message-ID: <aXOQ-3M7d2wSsAq-@raptor>
References: <20260119105651.255693-1-maz@kernel.org>
 <aXNoIrrjNnoQKkAg@raptor>
 <86pl70bj42.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86pl70bj42.wl-maz@kernel.org>

Hi Marc,

On Fri, Jan 23, 2026 at 12:37:17PM +0000, Marc Zyngier wrote:
> On Fri, 23 Jan 2026 12:22:58 +0000,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > 
> > Hi Marc,
> > 
> > On Mon, Jan 19, 2026 at 10:56:45AM +0000, Marc Zyngier wrote:
> > > [Yes, you can tell what I was listening to]
> > > 
> > > Today, running in protected mode puts the host under it's own S2 with
> > > FWB=0, even if the rest of the guests are running with FWB=1. The
> > > rationale for this special-casing of the host is that we want the
> > > combined attributes to actually reflect the ones exposed by S1.
> > > 
> > > We therefore use NormalCacheable (which is the weakest memory type) as
> > > the default attributes at S2 so that S1 can only strengthen the final
> > > memory type.
> > > 
> > > But there is no reason why we cannot achieve the same effect with
> > > FWB. We normally use FWB to enforce cacheable memory from S2,
> > > irrespective of S1. But it is possible to configure the S2 attributes
> > > as "pass-through", so that the S1 attributes are always used.
> > 
> > Would you mind clarifying why FWB is preferable? Is it so that pkvm uses
> > the same approach for configuring stage 2 for the host as for a guest? Or
> > is it something else?
> 
> Having only one attribute encoding scheme to think about on a given
> machine is vastly preferable, specially when you are debugging.
> Additionally, FWB==0 may not be with us forever.

Got it, thanks for the explanation!

Thanks,
Alex
