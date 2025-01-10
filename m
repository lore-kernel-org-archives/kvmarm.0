Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0135207DFD
	for <kvmarm@lists.linux.dev>; Fri, 10 Jan 2025 23:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736550303; cv=none; b=s6dQ8V/RKd2MBXcrHzAIAnse40YFbjQbK/cQOJRV3LTcUxRRsQZn+5g94Fub8bh6AWNUcooH56eoYTTx+gJaEXqhWp0uCHWc5AFcYlv9zvcZ3+kFHP59Grp7936u1/iPTlPotu0q54N+RIuqtyFFsL6mXBQntzjRNG2dTd/Wigc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736550303; c=relaxed/simple;
	bh=n67wJ9Y27AWbWXTn7vTSVFo3J2erBLXfq7TKZL3i7rg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FI1+Hx1UPpoq+dPr1HXqJM0dKLiP7rt2jt8JieNssLWC/UOuSVHDHqULAZwrWV3jl4j0n1k//kT1whadSc3ulp86dhTkhQcQ5iR2TPqkYuKttrZfSOTy5frrWx8hOzRLVDQzNq0phxZ1A9E18B6D7DYddzCdNoFOGXDsZq6ON14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sraxE+KE; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sraxE+KE"
Date: Fri, 10 Jan 2025 15:04:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1736550298;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iHW2uIjqLfLRrfePxMDheicUVgtFeVkPZz48RRH6vbw=;
	b=sraxE+KEzy341Fie9FEharelhRsU58Cl0w9fs6jIbtqeKdTyeurqcVepZ8kVGA+tnshp1W
	Nx5Q9rsE7R9U3u/khpEASt3SF1JWqDHcYxLmYKfFkGdBA4dooZkBEyJqAhuVWvqOxe3t/e
	vcMOAK2XHNxiuSPuewis0B+9tcZ4I94=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Sebastian Ott <sebott@redhat.com>,
	Fuad Tabba <tabba@google.com>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: vgic: Use str_enabled_disabled() in
 vgic_v3_probe()
Message-ID: <Z4GnkbjAcFwqYTaK@linux.dev>
References: <20250110225310.369980-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250110225310.369980-2-thorsten.blum@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Fri, Jan 10, 2025 at 11:53:09PM +0100, Thorsten Blum wrote:
> Remove hard-coded strings by using the str_enabled_disabled() helper
> function.
> 
> Suggested-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver
