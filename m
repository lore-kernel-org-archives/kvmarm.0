Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7753D21D5AE
	for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 18:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740596190; cv=none; b=savRafudg7nwdW7BZ+z4xX0VXCEKGbia5kT57HyPG0cdT4OeaAI8dLPyUU8rDIdMEEFUxSWZz2atk57Jp+7BJDYRH62haS74yjPVdD8LAx5VJVHYEhb+DT7YaX0drB1vE3OFaA3otP1cOiAtLSckBxY9ZPEkl6OhB1n1+f5GzMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740596190; c=relaxed/simple;
	bh=EUlIfdeF1pzupry08mNxqfWtBGYYyvkzaYg8I7GMfQg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uce8qilppa8rwugnZPDS/djzPhcQqX06sNDNpg29N8/MCIPfVJzZqICtoRWchbeeB9RFhJw0BdZUMYTinR98SBFcayeKarvxwx1U17QlrEcv2b1JLAWq6f+9Vp190PKAveHuBX/O4DkAwmsg2fhpdu1YzY93RE9te2dnh84fTxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DTrVl07I; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DTrVl07I"
Date: Wed, 26 Feb 2025 10:56:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740596186;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BSZAKZJBtmXPfCIzyN+pyGhW+GDpOa1dgPvIqwhe5V4=;
	b=DTrVl07ICp5qpVt9MAbJRYr2jB6odrQGw25//j+jiz92ZneaTgdDrKxpiezmpU/LqmQ43I
	JALYeNQ0rzYI+D5/Kg7jn9ve6YZsWTOq2pUMBN/fF/SjaKuW4hlJPRhK+IMYGRaD01KVOD
	/BMsU7qHDH6aVQa/frsYmyPqUVcg77s=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sebastian Ott <sebott@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Cornelia Huck <cohuck@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/4] KVM: arm64: writable MIDR/REVIDR
Message-ID: <Z79j1ckWLx_Hwqct@linux.dev>
References: <20250218163443.32836-1-sebott@redhat.com>
 <Z7zxSdW5b6rqe2bt@linux.dev>
 <b2b015de-569b-2cdd-8ec3-8c8690ff950b@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2b015de-569b-2cdd-8ec3-8c8690ff950b@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 26, 2025 at 05:47:53PM +0100, Sebastian Ott wrote:
> On Mon, 24 Feb 2025, Oliver Upton wrote:
> > On Tue, Feb 18, 2025 at 05:34:39PM +0100, Sebastian Ott wrote:
> > > Based on prior discussion [1] this series allows VMMs to change
> > > MIDR/REVIDR to enable migration between machines that differ in
> > > these registers. Since these are used for errata handling the
> > > errata management series [2] is a prerequisite for this one.
> > > 
> > > changes for V3:
> > > * handle VPIDR_EL2 as part of vcpu ctxt - thanks Oliver!
> > 
> > Thanks for respinning. While your changes are looking good, as I got
> > ready to apply this series I wound up peeling the onion a bit further
> > and have a few more concerns:
> > 
> > - Current KVM allows guests to read SMIDR_EL1 despite the fact that we
> >   do not support SME (this is part of TID1 traps)
> > 
> > - The "invariant" values that KVM presents to userspace originate from
> >   the boot CPU, not the CPU that resets the ID registers for a VM
> > 
> > - A VMM that wants to present big-little can do so on current KVM by
> >   affining vCPUs, but cannot with this series
> > 
> > All of this is to say, I think your series is going to collide with
> > the pre-existing pile of crap we have. I'm going to pick up these
> > changes and rework them so we can send a fix for #1 to stable trees and
> > (hopefully) avoid breaking the old "invariant" behavior.
> > 
> > I'll post what I have as soon as I test it, hopefully we can get this
> > shaped up for 6.15.
> 
> Sry, for the additional work I've caused. I gave what you have in next a
> spin and it looks good so far.
> Thank you very much!

Don't apologize -- it isn't your fault what we had already was a mess! :)

Thanks for kicking the tires.

Best,
Oliver
