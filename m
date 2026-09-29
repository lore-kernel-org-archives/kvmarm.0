Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD957320A34
	for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 19:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790710377; cv=none; b=EasZVkPmFH6PzCpy6jQeYqDw9rUKAEnafxbqDtpZx+1mYNOfYCWjLpafR52rZ9meZUgOOIlezRya6Q6Hy4/LJJXfvKWQ20SW0Vi0exfKeadcIfTVFDOQc6yOg+nEJetzPGTZWeDtV4rdfp8wwuFOKMJ9Z7GGd2cr7sQ0GVpPRKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790710377; c=relaxed/simple;
	bh=JQEPC3jyOsXBaYUhdABZQb6AaMB6O2NIiA/24DMwEO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RCKbc3cxfI2RmSJQgjhE/nrepPnd0HSBoIzS5hnxLRVSoY6K1HBZPrbyGCwBB8uBF6GlO7PpSMxlEdI+ZEWNpNsb4LrAY5oXcdG1noYIulK0NFFhZXDmuYgrLio7Z01GvCTfgl98rVT7hEyBmnGT0NFfhjXUBuRp2f3mM5YhOPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nii7bSma; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nii7bSma"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83EFD1F0089B;
	Tue, 29 Sep 2026 19:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790710376;
	bh=JSZ7qhDxfmONH8caf2Y2srBrN3d6GSLhEYO65kvAohk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nii7bSmafSZYnedL7zMMjvXznytZR6n328KIzWlUF0gRK55KL9Z+K/2mDkIsnrfor
	 co9arAt5em4OR5Ps8X8RIaGCVoS7dnySPJanlC8swmwyijuxev/eBfJI/xlG9lmvI/
	 baro/M2dO48MZw3DvXUkvjrBfnShVYXRaHAbisCoGgFzyGJPfPxltwL4gpivreJNVS
	 nLTQ26KmX50rDqfhAH/l+GUwq7W4hpT3KPlRa4NvRe674eNl7WTUWdCFoOVS8bbFNF
	 dzusokoa44Zj3xf8h77MUuyRO/m4RfKlV3isCWGIIpN/ky7KuNIWYTt9XaAQYjaMSR
	 mHPL/a+ewzDdQ==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Yuchao Zhang <ndaugoing@gmail.com>
Subject: Re: (subset) [PATCH v2 0/7] KVM: arm64: vgic-v3: Make LPI disabling robust (and more)
Date: Tue, 29 Sep 2026 12:32:53 -0700
Message-ID: <179071036888.5634.9129214925102842960.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260929093548.3598547-1-maz@kernel.org>
References: <20260929093548.3598547-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 29 Sep 2026 10:35:41 +0100, Marc Zyngier wrote:
> This is v2 of this series addressing shortcomings of LPIs being
> disabled on one CPU from another. It has now expanded into some more
> common areas.
> 
> Yuchao Zhang reported that disabling LPIs on one CPU from another
> could result in UAFs and other horrors.
> 
> [...]

Applied to fixes, thanks!

[3/7] KVM: arm64: vgic: Allow last_lr_irq to be NULL when LRs are not overflowing
      https://git.kernel.org/kvmarm/kvmarm/c/e079ef0b1c40
[4/7] KVM: arm64: vgic: Take a refcount on IRQs referenced by last_lr_irq
      https://git.kernel.org/kvmarm/kvmarm/c/19bc5d79ece6
[6/7] KVM: arm64: vgic-its: Fix MOVALL handling of source redistributor
      https://git.kernel.org/kvmarm/kvmarm/c/751f4641560b

--
Best,
Oliver
