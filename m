Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D13A51AEF8;
	Fri, 18 Sep 2026 17:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789751407; cv=none; b=PEewqXbp3dGV2ZbbHt0EGOs4tpKNEXvxIMKI2H4YUr34lx2VR8d7fbwOOyA4rmWW48USFY8Oie+tJ04G6gvdG0wHSJ52RyHUOhJMFwYWNW+Byqb9KufkaXddU3f1gaPa+L7wRvmiFFDV3HJ08uMuxSOpQZLZjJCn554TO7QZFiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789751407; c=relaxed/simple;
	bh=BgKcsXT68JH7sgpTC8Gm4cYQ/2FLLJZL15J9ATZKhdY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tqv1uzmon/EQUHNsE7vs0myqfg5QNlq3pfIe3VdswnJM4CG4oIfR5Itk49a4ZpCBZuSmcKyGutS/VB42oyJOUK70mGGH6e5CEBnuqIQj9KEMInEvVT1WgyzOeqc1MfEKZ2NsfjVahmD6ufRQ1KCOOnTj0nWzOhxZMIX4O3vGcIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=c+3nHSYF; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="c+3nHSYF"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4209B1476;
	Fri, 18 Sep 2026 10:10:02 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1DACF3F7B4;
	Fri, 18 Sep 2026 10:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789751405; bh=BgKcsXT68JH7sgpTC8Gm4cYQ/2FLLJZL15J9ATZKhdY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c+3nHSYFUtf7SaswiArlABvI3b2BtMzdxnuXNvLB87iAQX6Q6HaMpLdSwSayvDuVR
	 gJxPsA6IT7ZWN1hQIzcfuUzSvmwyEfbapuvFZPGEGXQzo6qO0pR9L257MQcNmha+M/
	 EGHJ6ZVdBmJB4loa8mqNP1EmXfTgf3xUNsoRUZOA=
Date: Fri, 18 Sep 2026 18:10:01 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v6 0/9] coco: guest: Enforce host page-size alignment for
 shared buffers
Message-ID: <aq1wabiHOhLRjHEd@arm.com>
References: <20260904103452.1197239-1-aneesh.kumar@kernel.org>
 <aq1sT2EDsGaomqST@arm.com>
 <20260918165754.GG11599@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918165754.GG11599@ziepe.ca>

On Fri, Sep 18, 2026 at 01:57:54PM -0300, Jason Gunthorpe wrote:
> On Fri, Sep 18, 2026 at 05:52:31PM +0100, Catalin Marinas wrote:
> 
> > TBH, I'm tempted not to support this configuration at all, just fail
> > gracefully if the realm page size doesn't match the host's. However, if
> > that's a real world configuration, 
> 
> realm != host is going to be fairly common.
> 
> host > realm is probably not that common, I would guess.

It's the latter that's problematic. If we don't think it's common, maybe
not worth solving.

> > I wonder whether could we leverage the swiotlb mechanism but with a
> > separate io_tlb_mem as a shared coco allocator with the right
> > alignment and use this pool when force_dma_unencrypted() instead of
> > specific alloc_pages() with adjusted order.
> 
> I propose we fix the far too low level set memory decrypted apis into
> proper allocators, with APIs that can handle a round up. Then see
> where we end up after that.

I fully agree. As you said, it also solves the double zeroing problem
and we can wire up the granule difference handling.

-- 
Catalin
