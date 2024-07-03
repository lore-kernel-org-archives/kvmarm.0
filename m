Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC3017BB0D;
	Wed,  3 Jul 2024 14:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720017533; cv=none; b=fGxvocfrJvAk16pOY6njXvWfT1eY7XwkIKduxgt3+wM1XvONjnQw6qyIVxWv0JlQkNn7/MATTI1f7i+HPnWe675TPa6+LZKCYUnDKcsYzCcMDsCx9YHozbgxp9r+fo8celfdKVOdGrw+L037DSvkTwQOmeVU5KY2eYs/kY/OSyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720017533; c=relaxed/simple;
	bh=MLzXW0zmt8TQcHGK5nYiqQdxT5V+dSydfz7v2Sdsn+Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IZoIUSUXLB0WtXRL6Ehmrbq2zZzki8HIyYM+42UWUUAJsm9Y88l+s/gpZGs0CC7rzrgF6HGp35cRlNV9OiC9H8YM/y3uc6M6cUz1pZK8+HWY72pqZvv5bE0dWzTcTYFK9v8r2TXw8yXafBlc2HOkqdOd2Bs+J1FC3K+O3+Wx/14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UvzXEd+O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UvzXEd+O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E6AC2BD10;
	Wed,  3 Jul 2024 14:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720017532;
	bh=MLzXW0zmt8TQcHGK5nYiqQdxT5V+dSydfz7v2Sdsn+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UvzXEd+OvZE0GLMzyCnlChXUeaWhWzEJj3t77gcq+UEcXMBtRoDIphusBsCr6EWNK
	 cb6ncbDUbZ8yHOyZ1ge01dmAPU4OSt0ItHtzAlU18+IIYgDmn21DivLA65n8M8hSXZ
	 4mAd0279LkOIYcnzbu7cxmzpNPZb5n+Ug0yVV++BH5+DxmgS+NUkXPCKL5Fs+cxutr
	 +LvJsAIDn9ruMwtdpXAN1u2eO/8Mt6HJAQ6Yj0a4YrQQmnD+8ZHh7kkEBnGGIDFuB0
	 dfxJEqm3lzV0s9vcNfBtfAD+IaUCmE5S42Puaf2B0VK3HhupOxtVWkunkRKjlZvLtW
	 GqGKYB49MONug==
From: Will Deacon <will@kernel.org>
To: Russell King <linux@armlinux.org.uk>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Clark <james.clark@arm.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Cc: kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 00/12] arm64: Add support for Armv9.4 PMU fixed instruction counter
Date: Wed,  3 Jul 2024 15:38:44 +0100
Message-Id: <172001203729.3396033.17013529444643308853.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20240626-arm-pmu-3-9-icntr-v2-0-c9784b4f4065@kernel.org>
References: <20240626-arm-pmu-3-9-icntr-v2-0-c9784b4f4065@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 26 Jun 2024 16:32:24 -0600, Rob Herring (Arm) wrote:
> This series adds support for the optional fixed instruction counter
> added in Armv9.4 PMU. Most of the series is a refactoring to remove the
> index to counter number conversion which dates back to the Armv7 PMU
> driver. Removing it is necessary in order to support more than 32
> counters without a bunch of conditional code further complicating the
> conversion.
> 
> [...]

Applied to will (for-next/perf), thanks!

[01/12] perf: arm_pmuv3: Avoid assigning fixed cycle counter with threshold
        https://git.kernel.org/will/c/81e15ca3e523
[02/12] perf: arm_pmuv3: Drop unnecessary IS_ENABLED(CONFIG_ARM64) check
        https://git.kernel.org/will/c/598c1a2d9f4b
[03/12] perf/arm: Move 32-bit PMU drivers to drivers/perf/
        https://git.kernel.org/will/c/8d75537bebfa
[04/12] perf: arm_v6/7_pmu: Drop non-DT probe support
        https://git.kernel.org/will/c/12f051c987dc
[05/12] perf: arm_pmuv3: Include asm/arm_pmuv3.h from linux/perf/arm_pmuv3.h
        https://git.kernel.org/will/c/d688ffa26942
[06/12] perf: arm_pmu: Remove event index to counter remapping
        https://git.kernel.org/will/c/b7e89b0f5bd7
[07/12] perf: arm_pmuv3: Prepare for more than 32 counters
        https://git.kernel.org/will/c/12fef9fb7179
[08/12] KVM: arm64: pmu: Use arm_pmuv3.h register accessors
        https://git.kernel.org/will/c/6ef2846c17a3
[09/12] KVM: arm64: pmu: Use generated define for PMSELR_EL0.SEL access
        https://git.kernel.org/will/c/558fdd12c069
[10/12] arm64: perf/kvm: Use a common PMU cycle counter define
        https://git.kernel.org/will/c/323bc9e17c01
[11/12] KVM: arm64: Refine PMU defines for number of counters
        https://git.kernel.org/will/c/be884dd62461
[12/12] perf: arm_pmuv3: Add support for Armv9.4 PMU instruction counter
        https://git.kernel.org/will/c/dc4c33f753ca

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
