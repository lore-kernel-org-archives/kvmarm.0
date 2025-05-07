Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63BBC220F22
	for <kvmarm@lists.linux.dev>; Wed,  7 May 2025 07:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746604630; cv=none; b=fdcYbAHGH6SyGvtPHhtg2QoAxSfoDpGJ31vEHwkcBHUCq/Q8VR344GXGYcZLCsaKHt1E6+cqGK9n5FxuyXWi+qub2d5GYTRwXfnWVDJoNLmHMFOy1YA+5aAk2WE8rVeTN01NUntPjFH/VQUGhOpQ65hOjnhLya0IJWm/MRMr9RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746604630; c=relaxed/simple;
	bh=z/ApciQD2h+gyUJzhSXeO9HL6cAVlTbrVF4uSHhAvoA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PoOdX3lPqEpmG7GRm9qyCeNsGEraJrSfMGDhgn871FZKOlEsOZWO4PeTRXQmb3eQxj3UG0d7jz+d3HONg9tiam/wZiKtAVcU0U2zQas0gPUuRwXT8cszAWWiIbJuJf/YGhFt/QZltXztfAnDsuDPOi/ePg6/e+SAWf1AsBGCDDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=f9Q/+hSU; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="f9Q/+hSU"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746604624;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sS0llExS1eXxyFgw4+Gpjgkw6K/xV+LT7FYdS3MPFFs=;
	b=f9Q/+hSUFnHY6a+pp1lBG1/y48EqELsSn4GeRn0uLg21uAFTFPwitAR0GaDz5s4y4kAakC
	ZUQoK9ZKS7bs2S8KuQu1zdWRYLZ639cPwjrz8JMumYG24Oq7T1Xy8P/3Nch4Ym0LY0ZOpG
	2BP5MgRKbgWY4/Smo0PkxzAyJ4eMn6U=
From: Oliver Upton <oliver.upton@linux.dev>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 0/2] KVM: arm64: Fix HCRX_EL2.GCSEn handling
Date: Wed,  7 May 2025 00:56:48 -0700
Message-Id: <174660459090.2542293.10603043906149596192.b4-ty@linux.dev>
In-Reply-To: <20250430105916.3815157-1-maz@kernel.org>
References: <20250430105916.3815157-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Wed, 30 Apr 2025 11:59:14 +0100, Marc Zyngier wrote:
> Will points out[1] that GCS is completely busted on the host if we
> ever run a guest, as HCRX_EL2 gets set to a fixed value on vcpu exit,
> value that doesn't include the GCSEn bit. This is likely to kaboom on
> a nVHE/hVHE setup.
> 
> Obviously, nobody ever tested this.
> 
> [...]

Applied to fixes, thanks!

[1/2] KVM: arm64: Properly save/restore HCRX_EL2
      https://git.kernel.org/kvmarm/kvmarm/c/ffea7c73d181
[2/2] KVM: arm64: Kill HCRX_HOST_FLAGS
      https://git.kernel.org/kvmarm/kvmarm/c/ef296ee98bb1

--
Best,
Oliver
