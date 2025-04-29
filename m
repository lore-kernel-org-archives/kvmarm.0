Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12C8267B85
	for <kvmarm@lists.linux.dev>; Tue, 29 Apr 2025 20:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745958507; cv=none; b=lrjWg+tebTqEDNpbGj5moXuki+VChUPvubqot24yXiN5HlbRD0eHftsJWSQRWww45enVcuNB/9Dyv2HIjGR7tUDiHfUqEgTI6bVvyFGCg7P/wkgHTamQONuSGhCBtjKO4Is8EbmPBMoI9IeQnjFIeZFGnDoH7kCkOI1qmDY5G/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745958507; c=relaxed/simple;
	bh=ox3lx5JlJ8b5ZVrs7yb4Ryi6efyD6oZG+SX4GVnpUQ0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rbmm+JVP9G+waPFN4Z3Jg/DH62tTOEDUTu3MLUJ5nuQ1C8i+WJor1iap407/2bKCTybz1rO2lUNPVJfrDwzqG4vlj0r0SfS7JIi4ADHKtIHdny4KrhBC3cezf6QVz1m02NCSzeFK0h3Eumnut5aPzuj9C4GH5//WK6FCaGiRBz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IgK0Q+KT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IgK0Q+KT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD32C4CEEA;
	Tue, 29 Apr 2025 20:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745958506;
	bh=ox3lx5JlJ8b5ZVrs7yb4Ryi6efyD6oZG+SX4GVnpUQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IgK0Q+KTnoknBdI0qBrfZEEOVwiUsIiTq7TZOWSVo5nqxDmsIIOI5tQCsQOejuIXM
	 ZmhoDXq8c4JlVXS8Kx4eo1MN/bkEtdwWYIBiiRL7+tuHShNIydxOl+Ir5Iuc5LR7nz
	 5k4QOqzSs+CziwyNEBW8e+v2uKZjNEEcYwVieS/Lx7j7IKHmL0xhpaZ65U4urXN9ra
	 mIcoawHkHAK5hvo7xhHrwOe76zpSL3X4uQk3AjZwjFFmeVZt/a/4cRYXo7HobGuT6I
	 TNxxY/jCii66xs4U2yJg70ZpRG3TouPBlWj70rp/xF5POQ4kzsN/Y0w9ZPgoiuUG0C
	 I13Toccn/EaMA==
From: Will Deacon <will@kernel.org>
To: catalin.marinas@arm.com,
	maz@kernel.org,
	oliver.upton@linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Yicong Yang <yangyicong@huawei.com>
Cc: kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	shameerali.kolothum.thodi@huawei.com,
	jonathan.cameron@huawei.com,
	prime.zeng@hisilicon.com,
	xuwei5@huawei.com,
	yangyicong@hisilicon.com,
	linuxarm@huawei.com
Subject: Re: [PATCH 0/3] Two minor fixups around FEAT_E2H0
Date: Tue, 29 Apr 2025 21:27:53 +0100
Message-Id: <174593019872.429067.18438816126339860301.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20250329034409.21354-1-yangyicong@huawei.com>
References: <20250329034409.21354-1-yangyicong@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Sat, 29 Mar 2025 11:44:06 +0800, Yicong Yang wrote:
> Two minor fixups for the FEAT_E2H0:
> 1) add missing feature register update
> 2) fix boot warning with kvm-arm.mode=nvhe if !FEAT_E2H0
> 
> Add a cpucap identify the HCR_EL2.E2H RES1 (!FEAT_E2H0) support.
> 
> Yicong Yang (3):
>   arm64/cpufeature: Add missing id_aa64mmfr4 feature reg update
>   arm64/cpufeature: Add cpucap for HCR_EL2.E2H RES1 (!FEAT_E2H0)
>   KVM: arm64: Fix boot warning with kvm-arm.mode=nvhe on !FEAT_E2H0
>     platforms
> 
> [...]

Applied first patch only to arm64 (for-next/cpufeature), thanks!

[1/3] arm64/cpufeature: Add missing id_aa64mmfr4 feature reg update
      https://git.kernel.org/arm64/c/35382a364640

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
