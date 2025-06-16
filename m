Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6B0C2E426D
	for <kvmarm@lists.linux.dev>; Mon, 16 Jun 2025 12:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750077331; cv=none; b=nvIRmBznSWr7rLiI/NuFEK+tFTS1oK6ZVRLJTwqK39gH1xiFX8J9m9g7xtJmEtvFpacKcYt8ae2TO6Si4huJA9Vs6mmdpEOoqU+UR+QGOUU8LHNkWIXrjt/YzTp1n2jKDLMfGYy3+IHMbIHcVohRPVUTSn18CfX5fLIBA0NRGDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750077331; c=relaxed/simple;
	bh=g7kYMJW762jSh3AbgWhuLwkwvv91Rgf7GpMr50+QTQU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bn+lCOl56hQRUnFdIxrM45aNjVvPX5OZxoY96Jefy2a2BcS0FplYYDuXIJekXDcEqfUG1HkPRCcoA7ZgundTkhO5f771tn8lccRE8IGEmFCgOHrj3lU2ns19nDntIT3/XzFVk+e2j4uLGl7KljUrH7SdTuuXiDbzfhNtvvmuLoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 95770150C;
	Mon, 16 Jun 2025 05:35:07 -0700 (PDT)
Received: from arm.com (unknown [10.57.84.90])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D062D3F58B;
	Mon, 16 Jun 2025 05:35:22 -0700 (PDT)
Date: Mon, 16 Jun 2025 13:34:17 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Joey Gouly <joey.gouly@arm.com>
Cc: kvm@vger.kernel.org, andrew.jones@linux.dev, kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [kvm-unit-tests PATCH v2 0/9] arm64: support EL2
Message-ID: <aFAPSSHJunx1Ecz2@arm.com>
References: <20250529135557.2439500-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250529135557.2439500-1-joey.gouly@arm.com>

Hi Joey,

On Thu, May 29, 2025 at 02:55:48PM +0100, Joey Gouly wrote:
> Hi all,
> 
> This series is for adding support to running the kvm-unit-tests at EL2. These
> have been tested with Marc Zyngier's Linux kvm-arm64/nv-next branch [1] and
> kvmtool branch arm64/nv-6.13 [2]
> 
> The goal is to later extend and add new tests for Nested Virtualisation,
> however they should also work with bare metal as well.
> 
> Changes since v1[3]:
> 	- Authorship fixed on 2 patches
> 	- Tested and fixed EFI support
> 	- Recactored assembly and added init_el macro
> 	- Clear trap registers, trying to avoid relying on default register
> 	  state
> 	- Cleaned up PMU changes
> 
> The debug tests fail with --nested, but pass with --nested --e2h0, I
> need to investigate this.

That's because the code does not check for the absence of FEAT_E2H0, and it sets
HCR_EL2.E2H to 0 when writing INIT_HCR_EL2_EL1_ONLY even if KVM doesn't support
that.

Have you considered using parts of el2_setup.h as-is instead of rolling out your
own EL2 init code? When I was looking at the init_el macro I was comparing it
with el2_setup.h, and having some of the code shared would make things easier
with updates and fixes too.

Either way, not a deal breaker if you want to write your own init code.

Thanks,
Alex

> 
> Thanks,
> Joey
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git kvm-arm64/nv-next (commit a35d752b17f4)
> [2] https://git.kernel.org/pub/scm/linux/kernel/git/maz/kvmtool.git arm64/nv-6.13 (commit 5b6fe295ea7)
> [3] https://lore.kernel.org/kvmarm/20250220141354.2565567-1-joey.gouly@arm.com/
> 
> Alexandru Elisei (2):
>   arm64: micro-bench: use smc when at EL2
>   arm64: selftest: update test for running at EL2
> 
> Joey Gouly (7):
>   arm64: drop to EL1 if booted at EL2
>   arm64: efi: initialise SCTLR_ELx fully
>   arm64: efi: initialise the EL
>   arm64: timer: use hypervisor timers when at EL2
>   arm64: micro-bench: fix timer IRQ
>   arm64: pmu: count EL2 cycles
>   arm64: run at EL2 if supported
> 
>  arm/cstart64.S             | 56 ++++++++++++++++++++++++++++++++++++--
>  arm/efi/crt0-efi-aarch64.S |  5 ++++
>  arm/micro-bench.c          | 26 ++++++++++++++++--
>  arm/pmu.c                  | 13 ++++++---
>  arm/selftest.c             | 18 ++++++++----
>  arm/timer.c                | 10 +++++--
>  lib/acpi.h                 |  2 ++
>  lib/arm/asm/setup.h        |  1 +
>  lib/arm/asm/timer.h        | 11 ++++++++
>  lib/arm/setup.c            |  6 ++++
>  lib/arm/timer.c            | 19 +++++++++++--
>  lib/arm64/asm/sysreg.h     | 19 +++++++++++++
>  12 files changed, 167 insertions(+), 19 deletions(-)
> 
> -- 
> 2.25.1
> 
