Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B812CAB
	for <kvmarm@lists.linux.dev>; Fri,  1 Nov 2024 15:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730476078; cv=none; b=dfwr6fPf4iKIbzoUta9V/kCFmrX9sLr3vSHk6GSW+2c6390+iGgxsPj6Z+zFrtUgdZ+DCf6w0s0KZbeWUjYxTOOncKOB5vzoJM4n2mcGPEj5DCT0n1iHaG08aJ9DjSCXiAi91/ug7GYRP518FnCaMep2T6gVtszgj6xzE9BAjbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730476078; c=relaxed/simple;
	bh=+U39yDnkjmc634whBULlf4rZnU8tmWJhNdMBvL/oAOk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W12v/oGlPQfBtx5zYIGGSU3sJJui0PVDTWH3e6J48u80eTMmPy5SesZadlgjaZeNzCVPlMjLZYs9D5H9tAEcRg9NxMwMo4EruHZUCsuoBmarLnotJI5RHIpZWbZys8z/OpE6uOq5SDf9gHLSumOreeWNQyFz41+1Jr4vA+RxC4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ODort3/n; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ODort3/n"
Date: Fri, 1 Nov 2024 08:47:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730476074;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TiT8EfJOMyPEs4Ofrdl7qs5hu6G3ir4nXFOyI3wPwUA=;
	b=ODort3/ngL4QSo6UzvOQ7df0QpGpils2XhqGhVqXzjYocBR7ABHsElMMd+SsWfa4l8mkaB
	YnyRd/7BozGZQhpBI7W7uiu+jqbqnOUxMkm6ZTqI0QGysF3Bz8ccgXa7oEUNN6TxU8HnqH
	IHhNm3Lmh038u+7jOUZOqeu1Cxwnskk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] arm64: Expose ID_AA64ISAR1_EL1.XS to sanitised feature
 consumers
Message-ID: <ZyT4JG1Nec_xPCHH@linux.dev>
References: <20241031083519.364313-1-maz@kernel.org>
 <ZyT1Tblp624a79CD@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZyT1Tblp624a79CD@arm.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Nov 01, 2024 at 03:35:41PM +0000, Catalin Marinas wrote:
> On Thu, Oct 31, 2024 at 08:35:19AM +0000, Marc Zyngier wrote:
> > Despite KVM now being able to deal with XS-tagged TLBIs, we still don't
> > expose these feature bits to KVM.
> > 
> > Plumb in the feature in ID_AA64ISAR1_EL1.
> > 
> > Fixes: 0feec7769a63 ("KVM: arm64: nv: Add handling of NXS-flavoured TLBI operations")
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> 
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> 
> Happy for this to go in as a fix via the kvm tree but let me know if I
> should pick it up instead.

Thanks Catalin. I think this can wait for 6.13, would you mind grabbing
it?

If you do:

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver
