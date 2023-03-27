Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0834533C0
	for <kvmarm@lists.linux.dev>; Mon, 27 Mar 2023 15:01:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3465C433A0;
	Mon, 27 Mar 2023 15:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1679929306;
	bh=r+dQg0PSqxF3VlUF2mJkLYbGDx+UxqX2Bes1Pj330fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tRhqHa2RVftPiBnJK+wRC2nuNifGfnZOkN2+asNj5Q4o/ncjN39GMqkSk+7DAR9FR
	 hVyNMa7yh/l6/aREh5YbTK1/x+NEVGMibGi7NP8soas+vOzTwTsTnIIZzeTT9A+Ji3
	 c8DntpvW4ncJoqa7mZ9y6JthdOAy+pzLf3nr6R+jmS5o6M15YL5vmORj9ocyap4vjp
	 4Tb8XKxX1qH5dn2F6VjCaJCicZFO23DgP72p6BjbxBsQeqGPOMigiNkyiPM4WZuPne
	 Q5v8VjYi0d7SWFkKD+eyaga1OJ7rqre6LPfszesjnD5+lp0e1PRvmH5oRNWWkC57Ng
	 bH4BYAIp1yhJQ==
From: Will Deacon <will@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>,
	Zaid Al-Bassam <zalbassam@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Marc Zyngier <maz@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jesus Sanchez-Palencia <jesussanp@google.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-kernel@vger.kernel.org,
	f.fainelli@gmail.com,
	Russell King <linux@armlinux.org.uk>,
	linux-perf-users@vger.kernel.org,
	James Morse <james.morse@arm.com>,
	kvmarm@lists.cs.columbia.edu,
	kvmarm@lists.linux.dev,
	Peter Zijlstra <peterz@infradead.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>
Cc: kernel-team@android.com,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v4 0/8] perf: arm: Make PMUv3 driver available for aarch32
Date: Mon, 27 Mar 2023 16:01:19 +0100
Message-Id: <167992208038.2117465.2416051281544086020.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20230317195027.3746949-1-zalbassam@google.com>
References: <20230317195027.3746949-1-zalbassam@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 17 Mar 2023 15:50:19 -0400, Zaid Al-Bassam wrote:
> Currently, PMUv3 driver is only available for ARMv8 aarch64 platforms,
> ARMv8 platorms running in aarch32 mode dont have access to the driver.
> This is, especially, a problem for ARMv8 platforms that only have
> aarch32 support, like the Cortex-A32.
> 
> Make the PMUv3 driver available to arm arch (ARMv8 aarch32) by moving
> the PMUv3 driver from arm64 to drivers, that makes the driver common
> to both arm and arm64 architectures, then add PMUv3 arm Support.
> 
> [...]

Applied to will (for-next/perf), thanks!

[1/8] arm64: perf: Move PMUv3 driver to drivers/perf
      https://git.kernel.org/will/c/7755cec63ade
[2/8] arm64: perf: Abstract system register accesses away
      https://git.kernel.org/will/c/df29ddf4f04b
[3/8] perf: pmuv3: Abstract PMU version checks
      https://git.kernel.org/will/c/711432770f78
[4/8] perf: pmuv3: Move inclusion of kvm_host.h to the arch-specific helper
      https://git.kernel.org/will/c/11fba29a8a1f
[5/8] perf: pmuv3: Change GENMASK to GENMASK_ULL
      https://git.kernel.org/will/c/b3a070869f39
[6/8] ARM: Make CONFIG_CPU_V7 valid for 32bit ARMv8 implementations
      https://git.kernel.org/will/c/252309adc81f
[7/8] ARM: perf: Allow the use of the PMUv3 driver on 32bit ARM
      https://git.kernel.org/will/c/009d6dc87a56
[8/8] ARM: mach-virt: Select PMUv3 driver by default
      https://git.kernel.org/will/c/3b16f6268e66

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
