Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B04920297C
	for <kvmarm@lists.linux.dev>; Fri, 12 Sep 2025 21:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757713714; cv=none; b=UjCkLL8KerS1Bvr546Lk34MzLN0Jm3hqO4520wVHHWxiSM/bayoXGlSJe1oi9ScZ1yhatlaZi7rh1ebRV+QYrw3+t+M+opqycq6PxqJMawDTqB3D/kmisQowqAXJt3edcWWI91rRbuWUW6ezL5/Uz8Yl/ECUy2hptvUnckzVBFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757713714; c=relaxed/simple;
	bh=cqyUoph485fZREJjS7zJCLofAmjNjCMNsbUrCTIetVw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c/ELm9SJS01HyEoMkhWCfprrHMOildRwd+1ss0trZuCp36mqlf9TF++gWx4SkVyNeEj7YW7qny8rwWukA0ALYFRWwfF5Ab3AExVj8m3HGn/tnDCERaQ2K51AdnOhb+QCA9a0Tbf4XeT+jm/c5OWZBFijpIRSBXqSnt8HDQl5f1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OsPxm6iU; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OsPxm6iU"
Date: Fri, 12 Sep 2025 14:48:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757713710;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=miOiqM9PJywRP2ijiFmsLcJxHKl4Qa+wDhHbmBUP2eQ=;
	b=OsPxm6iU6Pwzs1p1SeMcYRzrfnqf0pCfLvHp0Lx1s/dXAsG5dN2MCFEIJ1/FH8ZSUXSkni
	kGFuj7uoLPnjAtUlZyaKkEIPxcrM58kOUyzUY0D1n5ObaNujYQXL7ezPpBkKuFrvQVVkpb
	NBU6PouDFEir6uAXHhy11xAjYC9mf6g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jinqian Yang <yangjinqian1@huawei.com>
Subject: Re: [PATCH 00/11] KVM: arm64: nv: Align feature limitations with
 current state of support
Message-ID: <aMSVJ_CYh82GuWYY@linux.dev>
References: <20250912212258.407350-1-oliver.upton@linux.dev>
 <87ecsbz6s6.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ecsbz6s6.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Fri, Sep 12, 2025 at 10:43:05PM +0100, Marc Zyngier wrote:
> > In so doing, I found a bug relating to FEAT_DoubleLock where we
> > accidentally claim support where we shouldn't as the 0 value implies
> > the feature is implemented.
> 
> Meh. Don't you love negative features?

Just about as fun as negative polarity traps.

> > I've made each relaxation into its own patch to capture the rationale in
> > the changelog but I'm also fine squashing these based on the affected
> > register. Features that limit our MMU implementation are deliberately
> > left masked, e.g. FEAT_ETS* and FEAT_nTLBPA place constraints on the
> > behavior of our nested MMU. Although the latter is highly unlikely to
> > matter.
> 
> Well, unlikely to matter for S2. For S1, this is a different story.

Indeed -- just my general impression is that we shouldn't constrain
ourselves in terms of future MMU / TLB behavior at this point.

> > Applies to 6.17-rc4. **NOTE** this depends on Jinqian's series to make
> > ID_AA64MMFR1_EL1.TWED writable [*], that should be applied before this
> > series.
> 
> Thanks for that. I'll have a look shortly.

I'll also have a look at the series, need to revisit an open Q from the
last spin.

Thanks,
Oliver
