Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D511B1C2DB2
	for <kvmarm@lists.linux.dev>; Fri,  1 Nov 2024 15:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730475345; cv=none; b=n/unbm/xVToWGZOZBWiZxqCdI6B1Wgr2h/xrJQuVFjvbyGa0SoT0MV9Wq6tP1xn5e9eazDtNmoO3QtAKvAPw2Qyidc8mdABriy0SfGybvLb5mFfKg3s0CRZmG+HFx/ubUqBgLzurcf2Tj0yOMdcCiXW8i4z8VlUrAycv85V7AE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730475345; c=relaxed/simple;
	bh=BxFgoTUQ6w+Bm6PuyHaApwu6r0DMuljI7mGA08Xiyh0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MYjbdY+v1op4VwcWt0eg23aRZbUClSHWEvt60VBc+5ysRbY5I36lN7S3Jc7OidDB7JA0Fhqpi/u7mJ4gza9R+fdSdBNh58TRq0jMlXyXt8oexuKiq4OLgI5Ec9GZCU8SN2I97ccijdURVV5jJfSM3Lg1Rr6GpAG+IOjjHefoWLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2FA3C4CECD;
	Fri,  1 Nov 2024 15:35:43 +0000 (UTC)
Date: Fri, 1 Nov 2024 15:35:41 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] arm64: Expose ID_AA64ISAR1_EL1.XS to sanitised feature
 consumers
Message-ID: <ZyT1Tblp624a79CD@arm.com>
References: <20241031083519.364313-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241031083519.364313-1-maz@kernel.org>

On Thu, Oct 31, 2024 at 08:35:19AM +0000, Marc Zyngier wrote:
> Despite KVM now being able to deal with XS-tagged TLBIs, we still don't
> expose these feature bits to KVM.
> 
> Plumb in the feature in ID_AA64ISAR1_EL1.
> 
> Fixes: 0feec7769a63 ("KVM: arm64: nv: Add handling of NXS-flavoured TLBI operations")
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

Happy for this to go in as a fix via the kvm tree but let me know if I
should pick it up instead.

-- 
Catalin
