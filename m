Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5901870
	for <kvmarm@lists.linux.dev>; Thu, 15 Feb 2024 02:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707962559; cv=none; b=gfR8Tq3SjP3qZZpmL6TPtIkFd0d/RLC4buiSL0ahbaVUrcImmiH7FOG9dtWsCKwBDUF90d8Udij/CXMAPKBXLl0Zal6x9vnS7wGPWSBOcmajZGZMtHhbcRN9NG8hhD7sPoya6O4SBb+zTUjzqoDOkzp+QxCMoZeDGBKV+UDmtXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707962559; c=relaxed/simple;
	bh=CBFfg4lsG6uthITfULx7/4uzU0BrV/P0YX/Kx3fwZiU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mw9o/SahjK6buXLgak1659f84tla4ROEtvOWtK9HUXEMaSX6gerC3u1BgIfVQ5UDqqZKh4KxMXRbb54VkYM9FwqV81l+Jva/cbPbSNn71w7AiwUMj4ZMjNSZMr8uH4UE7or4LI1KKjAZ7/r9hfr9h6Dk+MJo/5uCKicmy+LhE2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=R6u4cJLY; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="R6u4cJLY"
Date: Thu, 15 Feb 2024 02:02:24 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707962554;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZyA1x6QYO+Yd5FJT4KgOcirJWdJt5WNEKspufx5cLOA=;
	b=R6u4cJLYKnpGCE7Amq675xgd+YuPTAo7bfuzlns3sKnDrNyTyaO/pIApeKk/obajMJ2oEb
	6KIEWQUXFcWagmZdks4Ez9XwW0xOz536VUEvOA9zXRYRNLNZDWVIRz/p7TUu5OkJCqm21q
	/dfgReA4KWaAp4ZKMUsv+fHeSBZ/dZQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH 2/2] arm64: cpufeatures: Only check for NV1 if NV is
 present
Message-ID: <Zc1wsKzAvooOvR-v@linux.dev>
References: <20240212144736.1933112-1-maz@kernel.org>
 <CGME20240212144758eucas1p1345ba6f2000c10a4b33f8575f0a8d22b@eucas1p1.samsung.com>
 <20240212144736.1933112-3-maz@kernel.org>
 <5b2d8fee-9d0f-48f7-b9ec-b86e95387a61@samsung.com>
 <86bk8k5ts3.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86bk8k5ts3.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Feb 13, 2024 at 02:21:48PM +0000, Marc Zyngier wrote:
> From cd75279d3b6c387c13972b61c486a203d9652e97 Mon Sep 17 00:00:00 2001
> From: Marc Zyngier <maz@kernel.org>
> Date: Tue, 13 Feb 2024 13:37:57 +0000
> Subject: [PATCH] arm64: cpufeatures: Fix FEAT_NV check when checking for
>  FEAT_NV1
> 
> Using this_cpu_has_cap() has the potential to go wrong when
> used system-wide on a preemptible kernel. Instead, use the
> __system_matches_cap() helper when checking for FEAT_NV in the
> FEAT_NV1 probing helper.
> 
> Fixes: 3673d01a2f55 ("arm64: cpufeatures: Only check for NV1 if NV is present")
> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

b4 wasn't very happy with grabbing this patch in reply to a series
(probably user error), but I've picked this up for kvmarm/next.

https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/commit/?id=9aa030cee1c45d6e962f6bf22ba63d4aff2b1644

-- 
Thanks,
Oliver
