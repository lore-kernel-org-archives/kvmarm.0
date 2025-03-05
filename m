Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98B7207A3A
	for <kvmarm@lists.linux.dev>; Wed,  5 Mar 2025 23:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741219158; cv=none; b=V5hNmZt3+IRB3eM6RUVDeSo+6x+b5Cp8woCzmeSoBmpKwkOPRjv9f7e9a5fL5IvDymM93xyjBglzBPfxBQZZvWkKoOA3a+ci/g6E/CVnLBlyw2psNDNZj5efhquF4NZH0XlJB44wVm+iCY5lvTKdPI0z40653l9vy8+RW/8UWPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741219158; c=relaxed/simple;
	bh=wFMNEISFqXyKpipTOXblyR2Mf8x4ED7rUaIhnVOa60k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HGxnN2tBKYqjj5N6WDUr//2pL5WIHtb2FdyZtTt9Dw8glv420+5ozpnxP8r5L6TbI5b3QDrI9mQBQ1XqDllASauNZ0fILGG5plXt1EvX9tDL4cYCVSv8edJNMT1BRa4XcCdS/7Naya1oIvzYKBk+6PjYvrq5w4/56nQkiI0IXsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=g+fwP1vV; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="g+fwP1vV"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741219150;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qo71ZpEWjiEuvLYpOm6cAQgKCLTzQJocq3h05KhJ4+Q=;
	b=g+fwP1vVUZCiSK3tA3+HTbZuRMGqSIym7xip6ti4nJpm1G6mEk0M86mhjE/vpR2pHEd9+E
	E68cTE/B8DuevphtzeOPhYpsPhm7dJdakl13OJ8DPeTR53caffF/jKYtLMQJNDPeLFVFKm
	TfS5DP7TKpjBghTLTJ9PxQsj6az55jI=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	maz@kernel.org,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	cohuck@redhat.com,
	eric.auger@redhat.com,
	sebott@redhat.com,
	yuzenghui@huawei.com,
	wangzhou1@hisilicon.com,
	jiangkunkun@huawei.com,
	jonathan.cameron@huawei.com,
	anthony.jebson@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	linuxarm@huawei.com
Subject: Re: [PATCH v8 0/6] KVM: arm64: Errata management for VM Live migration
Date: Wed,  5 Mar 2025 15:58:56 -0800
Message-Id: <174121899987.513001.15032119490654823649.b4-ty@linux.dev>
In-Reply-To: <20250221140229.12588-1-shameerali.kolothum.thodi@huawei.com>
References: <20250221140229.12588-1-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Fri, 21 Feb 2025 14:02:23 +0000, Shameer Kolothum wrote:
> v7-->v8
> https://lore.kernel.org/kvmarm/20250214151343.61348-1-shameerali.kolothum.thodi@huawei.com/
> 
> Changes:
>  -Fixed the compile error issue due to CONFIG_CORESIGHT_SOURCE_ETM4X=m
>   (Thanks to Sebastian for checking that config)- patch #4
>  -Added R-by tags.
> 
> [...]

The feature branch for all of this can be found here should the need arise.

git://git.kernel.org/pub/scm/linux/kernel/git/oupton/linux.git kvm-arm64/pv-cpuid

Applied to next, thanks!

[1/6] arm64: Modify _midr_range() functions to read MIDR/REVIDR internally
      https://git.kernel.org/kvmarm/kvmarm/c/e3121298c7fc
[2/6] KVM: arm64: Introduce hypercall support for retrieving target implementations
      https://git.kernel.org/kvmarm/kvmarm/c/57e5cc9b8a39
[3/6] KVM: arm64: Introduce KVM_REG_ARM_VENDOR_HYP_BMAP_2
      https://git.kernel.org/kvmarm/kvmarm/c/c0000e58c74e
[4/6] arm64: Make _midr_in_range_list() an exported function
      https://git.kernel.org/kvmarm/kvmarm/c/c8c2647e69be
[5/6] smccc/kvm_guest: Enable errata based on implementation CPUs
      https://git.kernel.org/kvmarm/kvmarm/c/86edf6bdcf05
[6/6] KVM: selftests: Add test for KVM_REG_ARM_VENDOR_HYP_BMAP_2
      https://git.kernel.org/kvmarm/kvmarm/c/f69656656fa7

--
Best,
Oliver
