Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F7DD346FBC
	for <kvmarm@lists.linux.dev>; Sun,  6 Sep 2026 19:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788724606; cv=none; b=dVK+dbTe0hC9OwJP8veU8bvetQXrTNYM47c1fF/EhebIQCCIWvj+SnHYBOnmkuJJYWiQgbdQRANLuaNZ5+ZJbiV9kDFE/dM38CIIxo51+CCqqFN4vqShOfkqxavhvNoe0KNxNbMOdpZnRYN0B8HPDRP7zZ4iM+JcoSlGVDPOsp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788724606; c=relaxed/simple;
	bh=y/XPLT2vWCH2Ci7UhdoddehaDK9VeeTuUMEqj2C7FO4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N4h+NUYeiQrnwK7TtkxthrkJ83fJzh0KCkNADEfTlAHR2harAmIz7A3t+no4odh24RPyzLBY7n0tFsYY2L57E809wCU+WN6PombT2lwmhh/27xjvkCcdGez8hIJqYT8Hk9/2YuFsR6a5oCHAz9jef5GyVmeuB47HM8B1NqlMuO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qGNzfZQm; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qGNzfZQm"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 149AA1477;
	Sun,  6 Sep 2026 12:56:40 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9A4743F882;
	Sun,  6 Sep 2026 12:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788724603; bh=y/XPLT2vWCH2Ci7UhdoddehaDK9VeeTuUMEqj2C7FO4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qGNzfZQmDW7LQcK3lbFzxaP8rK0r7IDbMTGaVvTTr3NDCclKPbY0A64mBlQuD3lMq
	 mz90z8weC54giXjafVk52TczR9jUrSns6tFXr2QLcHGnJbPWzmHZiYnl8tVhxt6KSg
	 ER+D7SLBGAo2PKwffciz94syMFgZ+xpTJnlyng/E=
Date: Sun, 6 Sep 2026 20:56:34 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Oliver Upton <oupton@kernel.org>, Fuad Tabba <tabba@google.com>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Itaru Kitayama <itaru.kitayama@fujitsu.com>
Subject: Re: [PATCH v5 2/6] KVM: arm64: nv: Introduce guest stage-2 tracking
 structures
Message-ID: <w4kihqs6n7ja7nr4sn3i2r4o2mspwj7k36w2fkh4kheizr6oj3@wfsea5mhnto6>
References: <20260810205038.118843-1-weilin.chang@arm.com>
 <20260810205038.118843-3-weilin.chang@arm.com>
 <87mrtu4c21.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mrtu4c21.wl-maz@kernel.org>

On Sun, Sep 06, 2026 at 04:47:02PM +0100, Marc Zyngier wrote:

[...]

> > +/*
> > + * Record of a guest stage-2 mapping, storing canonical and nested IPA
> > + * ranges. Both ranges have the same size.
> > + */
> > +struct kvm_guest_s2_mapping {
> > +	struct interval_tree_node canonical;
> > +	struct interval_tree_node nested;
> > +	struct kvm_s2_mmu *nested_mmu;
> > +};
> > +
> 
> I'm trying hard to find a way to reduce the size of this structure,
> because this is IMO the only real problem with this approach.
> 
> Obviously, the only thing we could kill is this nested_mmu field, as
> everything else is used by the interval trees. I can see two ugly ways
> to do that:
> 
> - either we iterate over all shadow MMUs to find the corresponding
>   'nested' node: really costly if we have a lot of mappings and/or a
>   lot of shadow MMUs
> 
> - or we steal bits from the interval_tree_node to encode extra
>   information. One realisation is that all addresses are PAGE_SIZE
>   aligned, meaning that we have at least 12 bits that are always 0. We
>   could, for example, encode an index in the bottom bits of the
>   nested.start field. Probably easy enough, but may require some
>   careful masking (and the addition of an index in the s2_mmu
>   structure).
> 
> The result would be significant, as we could then use a 96 byte slab,
> which means the cost of a 1GB @4k granularity could fall to 24MB.

One way of meeting in the middle is to keep the nested_mmu pointer, and
use a dedicated kmem cache. That cache will then hand out exact 104-byte
objects.

That's 26MB for 1GB @4K.

This is a nice improvement from the current 128-byte allocations.
Although it's not as good as 96-byte allocations, the code logic can
remain simple. Would you take this approach?

Thanks,
Wei-Lin Chang

[...]
