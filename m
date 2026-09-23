Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B880D51E44D;
	Wed, 23 Sep 2026 14:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175553; cv=none; b=LZPqw4GTknIBOQCpPCRiw7TC6kFZ93X5eFkalQg5TuSGPEf5O3k3GkMXadMvQ1nVBQzXM9DdIeSNImAiho9KLxdC8yUzqxNQKAuHtSTs4liR+RRyaPWDn9qfHoRuy+1MxRxP0gO+SrskEDnIpBw4CffOzJ1/p+NQjbZQbsxNvMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175553; c=relaxed/simple;
	bh=gswDY1mG66Lwu8tE7+G4+W7L5mN7cWkxPfHU3SkDVKo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=OPfMESd0I8G4+upEcPcV3X4s26+5E1zSFUywTf+eDkVB82vnMjw4WvyuWiAlMJVc5E6k7Zu/9ifIOvO2Bn6QZku0GqZAWCaTPAgRhWzocQI3LZRh4ilnLLPKRwBMqv10DyER6nEVeySTvsjK1+A62mBHWW32ggQb2jf5iVFGPHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gxODoNb7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gxODoNb7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79AFD1F000FF;
	Wed, 23 Sep 2026 14:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790175547;
	bh=gswDY1mG66Lwu8tE7+G4+W7L5mN7cWkxPfHU3SkDVKo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=gxODoNb72NWn9YPpDe8KLIfANsjCxo5gtqjTs0tVjyVQLSUt7VjxY4odyO7h2T0nC
	 o4xeysn4SqbjBbrzO/k8BC6P1zv9vl39VCVI9ZQ7IOhYkLNyT6sllXj5fSpyE5qyVe
	 kAe4GlZ84iDl0ZDLt9081Bf44hBYpqnANogB3sSSAe4bYi6Nt71WpYEqApRXHNHQFV
	 lsW/OSUjSOhCaTupqB/rAoBRuvGlM5KaAA6S7fHWuC1YeKSSi9S9ZLdoFOi0P4jEFP
	 SY9nq/2ZAJRRqMiLkoe+vZrhbLNj0eg7oSntaVwEl+MhSA8FXaTng/Ah83KmnM661J
	 SANvHw/6tOcAA==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	christian.koenig@amd.com, Joerg Roedel <joro@8bytes.org>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v7 02/13] mm: Add an allocator for CoCo shared memory
In-Reply-To: <20260923130611.GF1540250@ziepe.ca>
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
 <20260921144847.501151-3-aneesh.kumar@kernel.org>
 <arKsFofudnTYpXj1@arm.com> <yq5aik3w344o.fsf@kernel.org>
 <arOfD6syXOgQhZYA@arm.com> <yq5a5wzw2ree.fsf@kernel.org>
 <arOspFxWZ1DjgcAr@arm.com> <20260923130611.GF1540250@ziepe.ca>
Date: Wed, 23 Sep 2026 20:28:57 +0530
Message-ID: <yq5atsng10b2.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Jason Gunthorpe <jgg@ziepe.ca> writes:

> On Wed, Sep 23, 2026 at 11:40:36AM +0100, Catalin Marinas wrote:
>
>> The simplest is probably to always zero in the backend and ignore
>> __GFP_ZERO to the allocator. But it's probably only marginally smaller
>> than passing a CC_SHARED_ZERO flag down. Get codex to try this as well
>> and compare the diffstat.
>
> For patch ordering I would convert to use the allocator first
>
> The semantics of the new API should be clear
>
> If you pass GFP_ZERO then the resulting allocated memory is zero
>
> Otherwise the allocator does Whatever The Arch Needs to not leak
> private data out.
>

ok

>
> Once places are converted to the allocator lets go see what is left
> and ask why it is left and what API it actually needs.
>

I'm also considering requiring the address passed to cc_make_shared() to
be in the linear map. This is currently required by both TDX and CCA,
while AMD SNP appears to support vmalloc addresses. The only user of
that vmalloc support is Hyper-V VMBus GPADL setup
(vmbus_establish_gpadl()). How should the generic CoCo shared-memory
allocator handle this?

-aneesh
