Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F1B86BFCA
	for <kvmarm@lists.linux.dev>; Mon, 10 Jun 2024 11:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718018688; cv=none; b=F9pHlMkLQ7L8clbjvod5pqQov9wo1GpQ/eJHF0Cxlc6jeptd0TYtzVDAvy+8QpkJq364TcUgnHrLSiirPn3mb36aWcrmgHU1dBn1AxKR73VpOZxk2+Y7uCRWUxar95pjYg6oL8/ekSQ/TKp/YeIoJTwjgEtACj18tik2/N0m2RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718018688; c=relaxed/simple;
	bh=nPOoARfVywQm1Pm2aleqpSEX9lB7OYntKURSvXUt+/8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CtHXclohZEHrHhcDjCFVpaKnUrbekPY4zr6U+4yg74GLrqVpAgsHWauJboGMqWbYPETRS7LcX8YqE4Ob5KarBzeXvknmKVAc0j8NgWtxp4Kwj9OKnMEWqddUVKuEN34HF7z6NwHW/VD7aZ5PInapImyPjr8gDb42/xxBR+yA4EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E07E112FC;
	Mon, 10 Jun 2024 04:25:09 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 141F23F73B;
	Mon, 10 Jun 2024 04:24:41 -0700 (PDT)
Date: Mon, 10 Jun 2024 12:24:39 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: "Rob Herring (Arm)" <robh@kernel.org>
Cc: Russell King <linux@armlinux.org.uk>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH 7/9] arm64: perf/kvm: Use a common PMU cycle counter
 define
Message-ID: <Zmbid4pN7gz4Y4CH@J2N7QTR9R3>
References: <20240607-arm-pmu-3-9-icntr-v1-0-c7bd2dceff3b@kernel.org>
 <20240607-arm-pmu-3-9-icntr-v1-7-c7bd2dceff3b@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240607-arm-pmu-3-9-icntr-v1-7-c7bd2dceff3b@kernel.org>

On Fri, Jun 07, 2024 at 02:31:32PM -0600, Rob Herring (Arm) wrote:
> The PMUv3 and KVM code each have a define for the PMU cycle counter
> index. Move KVM's define to a shared location and use it for PMUv3
> driver.
> 
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> ---
>  arch/arm/include/asm/arm_pmuv3.h   |  2 ++
>  arch/arm64/include/asm/arm_pmuv3.h |  2 ++
>  arch/arm64/kvm/sys_regs.c          |  1 +
>  drivers/perf/arm_pmuv3.c           | 23 +++++++++--------------
>  include/kvm/arm_pmu.h              |  1 -
>  5 files changed, 14 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/arm/include/asm/arm_pmuv3.h b/arch/arm/include/asm/arm_pmuv3.h
> index a41b503b7dcd..ac2cf37b57e3 100644
> --- a/arch/arm/include/asm/arm_pmuv3.h
> +++ b/arch/arm/include/asm/arm_pmuv3.h
> @@ -9,6 +9,8 @@
>  #include <asm/cp15.h>
>  #include <asm/cputype.h>
>  
> +#define ARMV8_PMU_CYCLE_IDX		31
> +
>  #define PMCCNTR			__ACCESS_CP15_64(0, c9)
>  
>  #define PMCR			__ACCESS_CP15(c9,  0, c12, 0)
> diff --git a/arch/arm64/include/asm/arm_pmuv3.h b/arch/arm64/include/asm/arm_pmuv3.h
> index 1ed91334fede..46930729fb3f 100644
> --- a/arch/arm64/include/asm/arm_pmuv3.h
> +++ b/arch/arm64/include/asm/arm_pmuv3.h
> @@ -11,6 +11,8 @@
>  #include <asm/cpufeature.h>
>  #include <asm/sysreg.h>
>  
> +#define ARMV8_PMU_CYCLE_IDX		31

I think we can define this in <linux/perf/arm_pmuv3.h>, rather than
needing separate definitions for arm/arm64. 

> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index f8b5db48ea8a..22393ae7ce14 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -18,6 +18,7 @@
>  #include <linux/printk.h>
>  #include <linux/uaccess.h>
>  
> +#include <asm/arm_pmuv3.h>
>  #include <asm/cacheflush.h>
>  #include <asm/cputype.h>
>  #include <asm/debug-monitors.h>

... so we'd need to change the include here, but the rest of this patch
looks good as-is.

Mark.
