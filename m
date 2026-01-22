Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC803EBF3F
	for <kvmarm@lists.linux.dev>; Thu, 22 Jan 2026 17:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769101208; cv=none; b=q8yS56dvK/UoCRgbIthisKALAysQCRBPCE0B+uZKVGitcmwbwOcZnsnT9Rer6v5yENs8avch6E3XX2WSSJY10joMKG+cm5j/mH1+qaJMmDPQxcVn2fOPZ+XPXbujxfM8SVMeSolnEpkZ9bO50FcxDeOWog4VAB3DAXnu3Tivg7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769101208; c=relaxed/simple;
	bh=/kVRH7OmN6EDRj9qO26TDaI1PWDz6NtgN64FPwIvgqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W8nREHpuJz2Q03bC+fM5udzN07gyuAp02dwg62/Nl2odUMmYXknn5Pd1K0f8XU6GcyO4DEXjIYzJwFR7Ykv/IqWizjFpas5Tklrg2tMFrka5GOmZyLNGAml6SqmKM4ClIgDI9BGlQ650KTHMoe+pVK1Gr0VAX+nlp6ppoL0g2bM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X6WtaTXS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X6WtaTXS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CA2CC19423;
	Thu, 22 Jan 2026 17:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769101207;
	bh=/kVRH7OmN6EDRj9qO26TDaI1PWDz6NtgN64FPwIvgqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X6WtaTXS+RGPqz3QNaE5Z975zw7cbweVuLPVUBi3sjk5fgA4wSwQzRSiNmj2RmftH
	 5cFVLOJj7VkznY2vRcU7F1/MWr0RINqXQLrZNhlc9O1iYCQ1lWIvQlfoudkGLYnGSs
	 Bw6sxvcNOBJ2f3i3RzUd4aCq3oDT3duvCP3hkpn04iDVYROxBeSwmyHCIjjeB+GKdi
	 bRfULfJk0UF7HYJX+LsS6qd+evo3dx+jEjeQwVqNJ8WHF8RbmpHZgSEgeSNvacjz2Z
	 5RXLg+I9uwiHsZkIIMXjPrOwtZ1+8nf2SQnWu6RKyyjRkKGFJKF+1WiLSaZihOtXpj
	 nEYVQ+aekpsOw==
From: Will Deacon <will@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 0/3] arm64: Unconditionally compile LSE/PAN/EPAN support
Date: Thu, 22 Jan 2026 16:59:44 +0000
Message-ID: <176907700325.2035103.13197425164234703706.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260107180701.2858276-1-maz@kernel.org>
References: <20260107180701.2858276-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 07 Jan 2026 18:06:58 +0000, Marc Zyngier wrote:
> FEAT_LSE and FEAT_PAN have been around for a *very* long time (ARMv8.1
> was published 11 years ago), and it is about time we enable these by
> default. The additional text is very small, the advantages pretty
> large in terms of performance (LSE) and security (PAN), and it is very
> hard to find a semi-modern machine that doesn't have these (even the
> RPi5 is ARMv8.2...).
> 
> [...]

Applied first two to arm64 (for-next/cpufeature), thanks!

[1/3] arm64: Unconditionally enable LSE support
      https://git.kernel.org/arm64/c/6191b25d8bd9
[2/3] arm64: Unconditionally enable PAN support
      https://git.kernel.org/arm64/c/018a231b0260

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
