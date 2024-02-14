Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292B413A25E
	for <kvmarm@lists.linux.dev>; Wed, 14 Feb 2024 18:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707935535; cv=none; b=dkrdQjni9QmcF6jJuDUl7HCzINTHLY+MjkZGcL1MCB4o4UH/qHOW7yx0S0UBqw2Lpf3bF/CC3Q0FDkRODAkbEbN0gBzSKyhcJWnZXBF7UROyOzvc5UqzUzof8ypIKG2OVZf8548QwUCt5jxPpsLppa3M2VIa/sgUtRiadjrVubs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707935535; c=relaxed/simple;
	bh=hQJBRQGs+RMDCzJU9MhP0ybkU+4yNcL1dqxEYsEzrCo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BdRP4eapASufYqeQrr1/5ebhuYQu24aIxh0kO4nGowUNm1sQWZhzTYhNAfmgIld5DUpQ5ZXjIm3Ta6ovLt301mCUcJHIxNzlMxecWGQuwB8fRSXcNo0iHmnyda2+W4dPiHVyW5OqxlQe0tw74nTOALC3hj0x/KG8apFxPchcClY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CP+h46Zp; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CP+h46Zp"
Date: Wed, 14 Feb 2024 10:32:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707935531;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GfEPhq0mY5MqLsPcWaUBe1RZW2jMzAXPTv3wIHSwKlQ=;
	b=CP+h46ZpoN7SQ22Jluz5ihfwrCgfTdgpoPkPirGUtf3QP+9gfQ7TEZm0pRPTbYuEMl+pm6
	Ww60ZIbeXtIkx2Xu/Bq+4IhqE7Uhwq33o4iA5pVBPTUjRu3nib+0GpnTUKxEf3sTAFbAJW
	3lyWZklfv39+UBTo+dfGIdiaYZGg6Ts=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 07/23] KVM: arm64: vgic: Use atomics to count LPIs
Message-ID: <Zc0HIorNZG9KG5Mg@linux.dev>
References: <20240213093250.3960069-1-oliver.upton@linux.dev>
 <20240213093250.3960069-8-oliver.upton@linux.dev>
 <861q9f56x6.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <861q9f56x6.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

Hey,

On Wed, Feb 14, 2024 at 04:47:49PM +0000, Marc Zyngier wrote:
> I'd like to propose an alternative approach here. I've always hated
> this "copy a bunch of INTIDs" thing,

Agree. 

> and the only purpose of this
> silly counter is to dimension the resulting array.

Well, we also use it to trivially print the number of LPIs for a
particular vgic in the debug interface.

> Could we instead rely on an xarray marking a bunch of entries (the
> ones we want to 'copy'), and get the reader to clear these marks once
> done?

I think that'd work. I'm trying to convince myself we don't have bugs
lurking in some of the existing usage of vgic_copy_lpi_list()...

> Of course, we only have 3 marks, so that's a bit restrictive from a
> concurrency perspective, but since most callers hold a lock, it should
> be OK.

They all hold *a* lock, but maybe not the same one! :)

Maybe we should serialize the use of markers on the LPI list on the
config_lock. A slight misuse, but we need a mutex since we're poking at
guest memory. Then we can go through the whole N-dimensional locking
puzzle and convince ourselves it is still correct.

-- 
Thanks,
Oliver
