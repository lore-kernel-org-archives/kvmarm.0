Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB254035BE;
	Tue, 24 Mar 2026 15:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774364911; cv=none; b=NzhsfUzcxp4xvGuGQxlgnbMuv5T4zvmpAqdt+7VALDnIhb6+ArDSNcgL31la1oqUVPajbP0PhTxttzvtM3WgravcNxLLm7wSHf41pfNGdHFlNEyERls5xluMnXDp3FmWjcDibO8pgNjnDtb+pXq5541r8A+fqtTVbMLV4XQdgR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774364911; c=relaxed/simple;
	bh=NsM9htBv/b5wj5VrQLrpw0yDzl6UHZ6CctXTV+kC78c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EE4Z1q3QwmtX0N2IxbzZQpRSfw8NEOQ3b2Wpek9UcojR1EK20diNheaE4h0+x28g622RcCA155fYdSZiUtD1KsHoVTR41JAl/4svKJq41z0b0BBZCjc9ZdV7UwpK256+XvNt2zMWLWg2O3vFHtXb6TYGm3fmEfr6N2a0xdp+QAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JAUYAIMT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JAUYAIMT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECA03C19424;
	Tue, 24 Mar 2026 15:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774364910;
	bh=NsM9htBv/b5wj5VrQLrpw0yDzl6UHZ6CctXTV+kC78c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JAUYAIMTIDqGGSnxOdFCm3GDEW90G6epR7nztPIgl6NHkwKo30m+Kynm993izTL1g
	 ax342Pb3hXD7Y6S4T1WXGrquFksuWnMsEUtyJCQmy8/feMVkKVuJHx2cxZdfjV9Mb8
	 WBv6uowTDe4QCi19dHO5+mSYrwU/qsz5Kdih5fhIzhSa9nwfjWCxJj+8UBpScXfMCk
	 p24hogUOb7927no1C5RYLSz6drepQaf1+/04e6By9b/D7bxj7PowFvkFlF2tsPkmbE
	 jb2WBGXQVNM6b4pPVU7YbjxeDuSu5c1lDDecUG/j+g0OLRXfHBwHNMzDtbTBCa0HnQ
	 RHRruvTv5lymg==
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Colton Lewis <coltonlewis@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	James Clark <james.clark@linaro.org>
Cc: kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] KVM: arm64: Read PMUVer as unsigned
Date: Tue, 24 Mar 2026 15:08:11 +0000
Message-ID: <177435562978.1948488.12134750331688272062.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260305-james-kvm-pmuver-sign-v2-0-ee80a125af9b@linaro.org>
References: <20260305-james-kvm-pmuver-sign-v2-0-ee80a125af9b@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 05 Mar 2026 16:28:16 +0000, James Clark wrote:
> Fix some issues with the signedness of PMUVer and PerfMon ID fields.
> 
> I ran into the first issue when testing "ARM64 PMU Partitioning" patches
> on the FVP. The second issue was only found by inspection.
> 
> 

Applied to will (for-next/perf), thanks!

[1/3] KVM: arm64: Read PMUVer as unsigned
      https://git.kernel.org/will/c/2e30447b233a
[2/3] arm64: cpufeature: Make PMUVer and PerfMon unsigned
      https://git.kernel.org/will/c/d1dcc20bcc40
[3/3] arm64: cpufeature: Use pmuv3_implemented() function
      https://git.kernel.org/will/c/15ed3fa23cbc

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
