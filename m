Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE61621
	for <kvmarm@lists.linux.dev>; Wed,  2 Oct 2024 00:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727827628; cv=none; b=I/YM4ThFc0IKoHKqvj6a3lt5P8EOAvc/VpFc9Bt3yDTowlItH/HAwstAdgyyb4dOHEKLFyw2IlxCtUi/jfRcOtFhsqRF7uaZBBSutz1NwtwpoyJ4tTzSREnNtKjnDq+kxmExtWe5fcWdWEXtWcb59JLW/2iig8PXWdjM54TtCxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727827628; c=relaxed/simple;
	bh=PGDbkHIs6XrESFog2BsKG2I5Qhawo8lIBmdx4uEodWc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YXtFXCq8nIAs9oM1F3rOqcsPPZk5d5TMzos2cHKJq+gdznAzQj73MkdOsC60qHjYMXrKIWTac0Z7fXADu0aeAK9qr3g4Wstb3BewaEN4aHHVb/OJGq+ssCLKm60aHEOIXK0FfwKpnU/BlIexy2TnzpC1yvMCYImncpa6tmiRI4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=j2rrg+MF; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="j2rrg+MF"
Date: Tue, 1 Oct 2024 17:06:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1727827623;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=T9/eztCdzuU+BFilGSbGaqhwzVHspkWXMd4y1z+0HaI=;
	b=j2rrg+MF+lVdayOvQzX37KEVL1I2mK5ZB0/WPuD8brV+hJJ6E1TQg0QN4mp7OIcuByGvIX
	KRQA+Isxt9FT/9iaEh8vCRLm9tuZdrrm3zNSULIGPSAXMFavv+Syga+IxGeaFUDoZVUDid
	gkL3xvIQDliyDAY+QH/YdCPy5YXJoI4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 3/3] KVM: arm64: nv: Punt stage-2 recycling to a vCPU
 request
Message-ID: <ZvyOovRpxoQtPvZj@linux.dev>
References: <20241001001709.1303668-1-oliver.upton@linux.dev>
 <20241001001709.1303668-4-oliver.upton@linux.dev>
 <86ed4z76gw.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86ed4z76gw.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Oct 02, 2024 at 12:23:43AM +0100, Marc Zyngier wrote:
> > +
> > +void check_nested_vcpu_requests(struct kvm_vcpu *vcpu)
> > +{
> > +	if (kvm_check_request(KVM_REQ_NESTED_S2_UNMAP, vcpu)) {
> > +		CLASS(vcpu_hw_mmu, mmu)(vcpu);
> 
> I really think a small comment outlining *why* we need to elevate the
> refcount would help. This single line is what holds the whole thing
> together.

Sure, it is only _slightly_ load bearing...

-- 
Thanks,
Oliver
