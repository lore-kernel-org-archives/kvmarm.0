Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4661BDAB8;
	Fri, 16 Aug 2024 15:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723821400; cv=none; b=Iay5nC+4wRKCKTzK4C/qIF/UjUeVHxIhObEzLNuAwXO85KaSjglAHbCUNGl0i9BoeS9bgL5IVP4g6DMHgDAg+MWpiSNYlRrgeu1OwuOmk1jBW2M+uLbZoqCOS94w5LyQtkCK1BVCfKNxv1+qqf0ms8Mm/XGQ8xCZAtxUiFVWLDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723821400; c=relaxed/simple;
	bh=HrCbWr5sE7d1FSdM7OLBHJqb9SmFXoXZLsUxeMJ23UI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OLzeYLLxKHAOrY1uGjiDrp8lkpG/tX/nYT+oc/v5ZapGRxVNhGD6T3v+zm1IwdjVSEIJoJOShJz8yFVjCci+UAflcnF0opJ2rb/Qlq1WXnFzxVpBIf/lv+vlbRte4qKcq0I9isuCWmuoxHOtno0iUU4Y2bRUA8CwyroW8R1g2/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g0ow7PZC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g0ow7PZC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB04DC4AF15;
	Fri, 16 Aug 2024 15:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723821397;
	bh=HrCbWr5sE7d1FSdM7OLBHJqb9SmFXoXZLsUxeMJ23UI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g0ow7PZCEAeb1DhfX64PhHghH8VhkFKmrwqQMgR9rLVNBmd43SIIOtS9FOi0qX87X
	 cUiRlvGtXuTGsgtYcFxohdKZmuHSSd8c4sbESFF3D2QK8pmWOM4qwKXL1NT30h/UeD
	 r9jE65tOX6EtKYQVm7Juj2voDjuY3UmN6jAqmm+/jGos7P78CW0+3m329QJ9u8+oiO
	 5EX+MbrCoGy0qHv8iKYxH1LVj4feBTxQknCiQP5DAY0q+bNYvaaY66dBc4GksU7tIS
	 HZ5dRigI+gtE7jjSrTaKl0+kr2arqwy7vaMbtoKd0Ftf3BHovRC5UBvE+qga02mZTt
	 ur8Qgvx40jshg==
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	James Clark <james.clark@linaro.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Cc: kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 0/7] arm64: Add support for Armv9.4 PMU fixed instruction counter
Date: Fri, 16 Aug 2024 16:16:00 +0100
Message-Id: <172381015369.134151.12311687013802000544.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20240731-arm-pmu-3-9-icntr-v3-0-280a8d7ff465@kernel.org>
References: <20240731-arm-pmu-3-9-icntr-v3-0-280a8d7ff465@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 31 Jul 2024 10:51:17 -0600, Rob Herring (Arm) wrote:
> This series adds support for the optional fixed instruction counter
> added in Armv9.4 PMU. Most of the series is a refactoring to remove the
> index to counter number conversion which dates back to the Armv7 PMU
> driver. Removing it is necessary in order to support more than 32
> counters without a bunch of conditional code further complicating the
> conversion.
> 
> [...]

Applied to will (for-next/perf), thanks!

[1/7] perf: arm_pmu: Remove event index to counter remapping
      https://git.kernel.org/will/c/bf5ffc8c80e0
[2/7] perf: arm_pmuv3: Prepare for more than 32 counters
      https://git.kernel.org/will/c/a4a6e2078d85
[3/7] KVM: arm64: pmu: Use arm_pmuv3.h register accessors
      https://git.kernel.org/will/c/741ee5284551
[4/7] KVM: arm64: pmu: Use generated define for PMSELR_EL0.SEL access
      https://git.kernel.org/will/c/f9b11aa00708
[5/7] arm64: perf/kvm: Use a common PMU cycle counter define
      https://git.kernel.org/will/c/126d7d7cce5e
[6/7] KVM: arm64: Refine PMU defines for number of counters
      https://git.kernel.org/will/c/2f62701fa5b0
[7/7] perf: arm_pmuv3: Add support for Armv9.4 PMU instruction counter
      https://git.kernel.org/will/c/d8226d8cfbaf

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
