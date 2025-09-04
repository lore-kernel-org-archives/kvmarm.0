Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B032A1B2
	for <kvmarm@lists.linux.dev>; Thu,  4 Sep 2025 11:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756984722; cv=none; b=BHdUNKGlKJXjxFW+exZBhnwOrsFuEpF1WsvDpKkJsZhIoyOg5exHHvp/+ZSRplJb2QOk4UmGzLrRpA3Mu/oZv5biKI+dDJwOZZYZfvTtEn/09U7nTb6dyyT2AXCv8mmEzy/dvJyPdKaHElb88SGCe50oiUleIK+bnJKRyN8Cgxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756984722; c=relaxed/simple;
	bh=5g48D2zkuTju1pNjFv7UM5Yw8QGoDqge67mlopFYcvo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YJUIegfHF0t5E+ywiv2YfXQpoAqvhoDRn5J0gDqL1cUFHqe91CDi80hlN/P+B0rrnq/YRgTeBWmof52gZOFy5piZrbiPCIveDsHx7lZ7oV7JmD+tQlD4YjgGaEImF4swp/aqDSiU89aMIFjJIepYR4LfeCrmVOiZrqohQuyb0NM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KYTNEtFP; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KYTNEtFP"
Date: Thu, 4 Sep 2025 01:19:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756984717;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EcoJbTkATfQ9wOvxAl56fnzuN9cc3dDkmxjLc8Qfbjc=;
	b=KYTNEtFPhyo6LVQv17XcXkT4A6V5vBpksuFb9pvm3qYCTLtdRvzkzfEyQhYmfgCJmxpJNR
	fW95WcLlQlH0oIIFDlBpdZv1l5J3wAKA4XFtPShckBbfYbIL0x5RUxqBE4QMZxl+qHQJsV
	Dn36ZcgrdP0DD+1qGcUI3cEz+6epgwA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ben Horgan <ben.horgan@arm.com>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 5/5] KVM: arm64: vgic-v3: Indicate vgic_put_irq() may
 take LPI xarray lock
Message-ID: <aLlLgC4GBXYnUWO4@linux.dev>
References: <20250904062348.223976-1-oliver.upton@linux.dev>
 <20250904062348.223976-6-oliver.upton@linux.dev>
 <308ef1ea-f81c-4081-b664-a55e77de81d6@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <308ef1ea-f81c-4081-b664-a55e77de81d6@arm.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Sep 04, 2025 at 11:25:08AM +0100, Ben Horgan wrote:
> Hi Oliver,
> 
> On 9/4/25 07:23, Oliver Upton wrote:
> > The release path on LPIs is quite rare, meaning it can be difficult to
> > find lock ordering bugs on the LPI xarray's spinlock. Tell lockdep that
> > vgic_put_irq() might acquire the xa_lock to make unsafe patterns more
> > obvious.
> > 
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  arch/arm64/kvm/vgic/vgic.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> > index a21b482844ce..e61b95167ed1 100644
> > --- a/arch/arm64/kvm/vgic/vgic.c
> > +++ b/arch/arm64/kvm/vgic/vgic.c
> > @@ -142,6 +142,9 @@ void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
> >  {
> >  	struct vgic_dist *dist = &kvm->arch.vgic;
> >  
> > +	if (irq->intid > VGIC_MIN_LPI)
> > +		might_lock(&dist->lpi_xa.xa_lock);
> > +
> 
> nit: Use >= rather than > to include all LPI.

Of course, silly typo.

Thanks!
Oliver
