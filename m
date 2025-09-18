Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40D03128C3;
	Thu, 18 Sep 2025 16:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758213810; cv=none; b=KLPIRxkZAk6gGlgYWgw6tj5dLd+wNwc7gj84b389g5HAcu+HvDFLP0ultMYHJ9/ax6PbAs8WfmAMnYKyQPeQqZZvpIr47PSx94wYk1QZPhgRmXSF1PSUYPW8U3wSG4Q/DmkceLQyqXhTzg6P3jCfgUa4blgYropap1Dv0bz/mSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758213810; c=relaxed/simple;
	bh=h9r87sKSL8lye2f7s8CYcNKEjCq+sl5T4kGt0qLKA3k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IA4texkxCurgrt91f2hV7DGyo6YVFkuh2/S2n3VMuwwWHlLH0ek6XQDm/+PTDcaDfVgkr31toMAS0etGGkT9fYXXdYQmtu3bdFLmXzrB7mIJbk/YlL0d2u3K85hCwa19R9oeAYPMODrQ/nBPcMezVJWxvHSr6aYmceoQ2f8eZ2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OcLwB/3c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OcLwB/3c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCD63C4CEE7;
	Thu, 18 Sep 2025 16:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758213810;
	bh=h9r87sKSL8lye2f7s8CYcNKEjCq+sl5T4kGt0qLKA3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OcLwB/3cK+Hq+E9fTHI2F7AqsGyYBmhJhVW+2ehxX2i9V5DZrqNfhwfCZjvaGOjbl
	 rX2srpTymZHXqt3zFrM4lr5DXNUo2WDVcH/pxM+k3Cw2zZQ7cT/aUSHIhqHsVD+ZE2
	 JcmwQRAkRTF1/7p7pVl8Et614GC2LXL/f9IdRyOg1HqOE0x11DS2MNuIBW6G6Bg900
	 CBIW888sSRlyjQuskjphNYG5eD3tBVZmC/SFVp/BRJ8+DdqECfhaVw9Som8m/+SYL9
	 eqORwm725/v2zzuTh2sOxoKf0D9Zysp/61f4NTK7l6aR+NF49JWgs84aZuLeuk/Z/v
	 3GIAyc8byUKlg==
From: Will Deacon <will@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Leo Yan <leo.yan@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	James Clark <james.clark@linaro.org>
Cc: kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v8 00/12] perf: arm_spe: Armv8.8 SPE features
Date: Thu, 18 Sep 2025 17:43:08 +0100
Message-Id: <175820142456.3469431.6863967464115578024.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250901-james-perf-feat_spe_eft-v8-0-2e2738f24559@linaro.org>
References: <20250901-james-perf-feat_spe_eft-v8-0-2e2738f24559@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 01 Sep 2025 13:40:29 +0100, James Clark wrote:
> Support 3 new SPE features: FEAT_SPEv1p4 filters, FEAT_SPE_EFT extended
> filtering, and SPE_FEAT_FDS data source filtering. The features are
> independent can be applied separately:
> 
>   * Prerequisite sysreg changes - patch 1
>   * FEAT_SPEv1p4 - patches 2 - 3
>   * FEAT_SPE_EFT - patch 4
>   * FEAT_SPE_FDS - patches 5 - 9
>   * FEAT_SPE_FDS Perf tool changes - patches 10 - 12
> 
> [...]

I took the first 6 patches but 7 and 8 still need maintainer acks before
I can pick up 9 as well.

Applied to will (for-next/perf), thanks!

[01/12] arm64: sysreg: Add new PMSFCR_EL1 fields and PMSDSFR_EL1 register
        https://git.kernel.org/will/c/a7005ff2d0a5
[02/12] perf: arm_spe: Support FEAT_SPEv1p4 filters
        https://git.kernel.org/will/c/b4401403afb9
[03/12] perf: arm_spe: Expose event filter
        https://git.kernel.org/will/c/51b9f16697cd
[04/12] perf: arm_spe: Add support for FEAT_SPE_EFT extended filtering
        https://git.kernel.org/will/c/dad9603c5ea3
[05/12] arm64/boot: Factor out a macro to check SPE version
        https://git.kernel.org/will/c/510a8fa49dc1
[06/12] arm64/boot: Enable EL2 requirements for SPE_FEAT_FDS
        https://git.kernel.org/will/c/00d7a1af5ab5

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
