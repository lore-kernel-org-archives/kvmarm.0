Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9566F1D514E;
	Sun, 26 Jul 2026 14:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785074470; cv=none; b=W24ZieeF+qu6b13DtK0s7CwGqiJnTwDaUonNdPBCNq/CpQYezpgzO3kpCoKjl0M9c6CMjTEuQxgletiJ6cMK5TzlEAVWWVEf7ri7TEAq/sg3CQJNNQcpKwL3TBLrCUXK9MXJb5Ou7BAlffxP5Ow5DzVTZV+9LTPeWQjXoeh3Rsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785074470; c=relaxed/simple;
	bh=KS4a/mIs2e4yE4WrAVZUOgOESsJ8Yl2dfJkFe0ggIFE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LWu/bOqseon3aVdbToGQJeWt2/W5m1Crl7WWE24UWWE6frLZPbLx2q84geEl9Hi3X5ldmE/5TyXeYTwfGqloQ2jMA5BIqipqrJtImCsIImMNOPZ8oIXoSAuYz8qO6QWmsHtuEdaPnACGAbQorZOA8XPxQLmNsbYVN0uj9MGaXFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZYrWiv6l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZYrWiv6l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 155051F000E9;
	Sun, 26 Jul 2026 14:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785074469;
	bh=Nxvh1p7c+pmINXdKN73uo5IY1gh+WpjKlssK5VfeCXo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZYrWiv6lnewCJxRk8PU+8AH+7ylGoDEVNKoyBrEB0R3qJuNyodqNYlaOovH2zRS3l
	 Z4RaYhWufNPLIIphrwj9yaX3UJoc05Sc3M/nhAotFR5sPGnkXn9QmmfGmOXYDRgwZ2
	 ChEcCqyqQsSTS+ZDikAzrUHfvLW6ljHyhMemmfhbQlyKPNPnvLp1UTu5+BmqmhueMW
	 q6HBcoie2oDZ6jmef3u/3m2ZMQxQ86Jy9veZxMFYn+RMNy1hMoH2S2b55rfQBZ5SJH
	 UHhlkChaAVQ2lOJG+V7C+UDptE+8t21Vtw9Jy5u5PIBj6WxeSZ8gCQPLZQXTCWE9yX
	 upWVDzr/bRh+w==
Date: Sun, 26 Jul 2026 15:01:04 +0100
From: Will Deacon <will@kernel.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	oupton@kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, vdonnefort@google.com, tabba@google.com
Subject: Re: [PATCH] KVM: arm64: Use consistent type for pool size
Message-ID: <amYTIE8QujqyYyDG@willie-the-truck>
References: <20260715150125.2798116-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260715150125.2798116-1-smostafa@google.com>

On Wed, Jul 15, 2026 at 03:01:25PM +0000, Mostafa Saleh wrote:
> All the pool sizes in the hypervisor are "unsigned long" but when
> they get passed to hyp_early_alloc_contig() or hyp_pool_init() they get
> truncated to 32-bits.
> 
> That is not a big problem at the moment as to overflow this we need
> 4G bytes of carveout (2 TB of host or guest system memory).
> 
> However when new users are added (as IOMMU) it is hard to reason
> about the carveout size anymore.
> 
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---
> For example in the SMMUv3 to avoid this overflow, I add a cap
> for the pools size to UINT_MAX to work around this:
> https://lore.kernel.org/linux-iommu/20260715115906.2664882-9-smostafa@google.com/
> ---
>  arch/arm64/kvm/hyp/include/nvhe/early_alloc.h | 2 +-
>  arch/arm64/kvm/hyp/include/nvhe/gfp.h         | 4 ++--
>  arch/arm64/kvm/hyp/nvhe/early_alloc.c         | 2 +-
>  arch/arm64/kvm/hyp/nvhe/page_alloc.c          | 6 +++---
>  4 files changed, 7 insertions(+), 7 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

Will
