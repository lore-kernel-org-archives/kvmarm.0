Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A2AC147
	for <kvmarm@lists.linux.dev>; Thu, 17 Oct 2024 00:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729124579; cv=none; b=aDFdSHRyreRZuoQVhhqt/Xlld5zEoQXfW3IWEOIro8V3x5ZWfQneAPZvIx2GvNt9rVyU1R4F/KomDsc+Q5v1gMVSRcYta9+8bkkBiAN+Gzm5C2RFovvV1epAcWvdwY6LS+LIAFXDa2DbK9P9IMQyLG0vZjlbmObUkEQ/o386XpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729124579; c=relaxed/simple;
	bh=6ITItnxs5LfnsDi6tfRkPkLotowyZBnDIQ5/2CZqjKM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OEsLbMMO5JNutQUKbWMd/G+81JN6js7pRNn92QWsk+9sk3D2IJTAqbSSvqTREmEr/nsDw7IMN2aothLtEQoMbAP1MUUifUKS0RCJ/No18ROvTy1/UiibQGpeMZKFrMowbZ4PSZInGG97CJke/11yZ2dD/FXSrgnwt/1VUcMpvgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BAdanOVD; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BAdanOVD"
Date: Thu, 17 Oct 2024 00:22:07 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729124575;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gM6o1EQ+KbEJwxRFPGOrrzyRsAi8+HEAqhUpOlIjavY=;
	b=BAdanOVDbqAvY1mS4ymvH0IqQ7NoSQF19lSbP6tikdvoj9EX1DJEkz2/ZaIQ2uLsGVyY9R
	KHZStczb85DYsa0b3QXHdEh6gdwhqTmLLnTENja/iP1z4m+AsfBueBU1KCoWRhJdJuLkg9
	H3EPiZbUYZnJTxDvDdBa2KzCiUaCMTs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 0/2] KVM: arm64: Ensure VGIC is fully initialized before
 entering guest
Message-ID: <ZxBYr_lEsUCJA8c-@linux.dev>
References: <20241017001947.2707312-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241017001947.2707312-1-oliver.upton@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Thu, Oct 17, 2024 at 12:19:45AM +0000, Oliver Upton wrote:
> Fix for the race [*] that I had mentioned last week. The first patch
> isn't entirely necessary, but it gets rid of a bogus check that could've
> potentially raced with kvm_vgic_map_resources() as vgic_dist::ready is
> no longer protected with the config_lock.
> 
> Applies to kvmarm/fixes.

-ENEEDBEER

Here's the link I meant to add.

[*]: https://lore.kernel.org/kvmarm/ZweUiHMC3RNwNXzY@linux.dev/

> Oliver Upton (2):
>   KVM: arm64: vgic: Don't check for vgic_ready() when setting NR_IRQS
>   KVM: arm64: Ensure vgic_ready() is ordered against MMIO registration
> 
>  arch/arm64/kvm/vgic/vgic-init.c       | 13 +++++++++++--
>  arch/arm64/kvm/vgic/vgic-kvm-device.c |  7 ++++++-
>  2 files changed, 17 insertions(+), 3 deletions(-)
> 
> 
> base-commit: df5fd75ee305cb5927e0b1a0b46cc988ad8db2b1
> -- 
> 2.47.0.rc1.288.g06298d1525-goog
> 

-- 
Thanks,
Oliver
