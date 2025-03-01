Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F894156861;
	Sat,  1 Mar 2025 07:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740812737; cv=none; b=Mh631iPbjJhaI7RKIZDFRJn8DMcteSxYfIjV0nI232s+VdrKj+P74p+f29TdgXvDlAl3ij/ClIpLIbJ4ZLd4oAId0C5GOVWUQX0HDDw1d5rKynIrRC0LjZQgdP0+Kl6+RaXfaaUb0oUgs60TPt2N3jMrQzIhASoojNhWWwuy75I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740812737; c=relaxed/simple;
	bh=+fhqb2OIeApH9GqBSR9/bHlgcwJ4dCJAUctYxXvGHYg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pxiMo1dmkmEBYkKtLkEb/PW+1oxAWT2JUrofIPgRGEl/m241xhM0VJeQNssioiAhAKVAjN2SO9ZzwHYF1K7bA0bmJqmNMcMgeD8YMdtwXfxb8yK49Vf7Nmb3LxuEfIGO4OuB6x/5IqEKfELyc2YnbYAYkrq/pRCEniz2MwB2Pwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DZtZgzDe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DZtZgzDe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31A97C4CEE5;
	Sat,  1 Mar 2025 07:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740812736;
	bh=+fhqb2OIeApH9GqBSR9/bHlgcwJ4dCJAUctYxXvGHYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DZtZgzDeox7blJGzCTytvlYuN5NP0CFoYki+ophtf02ztIfhu/1AKHYqsWYIX2cxm
	 Pmar+FfLsz6PzA/fxnXx7TimQN9YnfriWup5AChiRqpZObzVJ5sOEicRyNSm51W1id
	 5bdDX+Znij/+CYescJwwOr+GEU2yrwc1AryFBAKf8mOryLBvFARkvBh9fC2uB4Wnwf
	 zpFJFhCobDOZqSjO56dd1RNLIEcCnDD6br/mHEddETFd6u9kwQsxHwUe76tx0TAS+l
	 vYX7rTUlSg0iroXbbpOhUzq8nGWWY21upMM+nL+rGjsXxdIeoWjGOv+gt2fMF0VUmR
	 Qwccz0LEaUWMA==
From: Will Deacon <will@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Clark <james.clark@linaro.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Leo Yan <leo.yan@arm.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Cc: kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v20 00/11] arm64/perf: Enable branch stack sampling
Date: Sat,  1 Mar 2025 07:05:24 +0000
Message-Id: <174080569248.3208873.17639032755999041028.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20250218-arm-brbe-v19-v20-0-4e9922fc2e8e@kernel.org>
References: <20250218-arm-brbe-v19-v20-0-4e9922fc2e8e@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 18 Feb 2025 14:39:55 -0600, Rob Herring (Arm) wrote:
> This series enables perf branch stack sampling support on arm64 via a
> v9.2 arch feature called Branch Record Buffer Extension (BRBE). Details
> on BRBE can be found in the Arm ARM[1] chapter D18.
> 
> I've picked up this series from Anshuman. v19 and v20 versions have been
> reworked quite a bit by Mark and myself. The bulk of those changes are
> in patch 11.
> 
> [...]

Applied cleanups to will (for-next/perf), thanks!

[01/11] perf: arm_pmuv3: Call kvm_vcpu_pmu_resync_el0() before enabling counters
        https://git.kernel.org/will/c/04bd15c4cbc3
[02/11] perf: arm_pmu: Don't disable counter in armpmu_add()
        https://git.kernel.org/will/c/dcca27bc1ecc
[03/11] perf: arm_pmuv3: Don't disable counter in armv8pmu_enable_event()
        https://git.kernel.org/will/c/4b0567ad0be5
[04/11] perf: arm_v7_pmu: Drop obvious comments for enabling/disabling counters and interrupts
        https://git.kernel.org/will/c/7a5387748215
[05/11] perf: arm_v7_pmu: Don't disable counter in (armv7|krait_|scorpion_)pmu_enable_event()
        https://git.kernel.org/will/c/7bf1001e0d91
[06/11] perf: apple_m1: Don't disable counter in m1_pmu_enable_event()
        https://git.kernel.org/will/c/c2e793da59fc
[07/11] perf: arm_pmu: Move PMUv3-specific data
        https://git.kernel.org/will/c/dc4d58a752ea

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
