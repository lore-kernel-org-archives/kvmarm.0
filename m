Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D48DBCA62
	for <kvmarm@lists.linux.dev>; Mon, 10 Jun 2024 11:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718017350; cv=none; b=VQ2E4wV1fmmeYSpI576nKE0nuKxnJzLwHm91myC9W/BpvFddA9vbqGYgGcKlV2xmT4kWoc8AgtqsB6jqifb3n4FFf8ZD+8Zbw0KrFFW6gZ+5S7UIUE+cfYp+NcQEENh7NNq17plCNJjRy+a/NUKHdG9YT67G62axES9oqX12lg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718017350; c=relaxed/simple;
	bh=MjM3cb17jNlp/QJiDI3GbGiFDNREJWjq+dacs+GnmvE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FgLbky80VRO4s9cN6XLjvSPIM59ktelQX6XkYVRSSVc3gezzeDlag1WwKhPKhJTqTC9GBTPwwqt4l/WjWqqHx+oqHK6PFuULwDi//VALF413V6CWyo9oj6RF4r6mBfpMxXZcrd3PRMIUzjgshxmle7dAePW2+uAvE5Xip3NoHuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C935812FC;
	Mon, 10 Jun 2024 04:02:51 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 040AA3F73B;
	Mon, 10 Jun 2024 04:02:23 -0700 (PDT)
Date: Mon, 10 Jun 2024 12:02:21 +0100
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
Subject: Re: [PATCH 5/9] KVM: arm64: pmu: Use arm_pmuv3.h register accessors
Message-ID: <ZmbdPYndL2_We387@J2N7QTR9R3>
References: <20240607-arm-pmu-3-9-icntr-v1-0-c7bd2dceff3b@kernel.org>
 <20240607-arm-pmu-3-9-icntr-v1-5-c7bd2dceff3b@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240607-arm-pmu-3-9-icntr-v1-5-c7bd2dceff3b@kernel.org>

On Fri, Jun 07, 2024 at 02:31:30PM -0600, Rob Herring (Arm) wrote:
> Commit df29ddf4f04b ("arm64: perf: Abstract system register accesses
> away") split off PMU register accessor functions to a standalone header.
> Let's use it for KVM PMU code and get rid one copy of the ugly switch
> macro.
> 
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> ---
>  arch/arm64/include/asm/arm_pmuv3.h | 13 ++++++++
>  arch/arm64/kvm/pmu.c               | 67 +++++---------------------------------
>  2 files changed, 22 insertions(+), 58 deletions(-)

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> 
> diff --git a/arch/arm64/include/asm/arm_pmuv3.h b/arch/arm64/include/asm/arm_pmuv3.h
> index e96ce7900fc7..1ed91334fede 100644
> --- a/arch/arm64/include/asm/arm_pmuv3.h
> +++ b/arch/arm64/include/asm/arm_pmuv3.h
> @@ -33,6 +33,14 @@ static inline void write_pmevtypern(int n, unsigned long val)
>  	PMEVN_SWITCH(n, WRITE_PMEVTYPERN);
>  }
>  
> +#define RETURN_READ_PMEVTYPERN(n) \
> +	return read_sysreg(pmevtyper##n##_el0)
> +static inline unsigned long read_pmevtypern(int n)
> +{
> +	PMEVN_SWITCH(n, RETURN_READ_PMEVTYPERN);
> +	return 0;
> +}
> +
>  static inline unsigned long read_pmmir(void)
>  {
>  	return read_cpuid(PMMIR_EL1);
> @@ -96,6 +104,11 @@ static inline void write_pmccfiltr(u64 val)
>  	write_sysreg(val, pmccfiltr_el0);
>  }
>  
> +static inline u64 read_pmccfiltr(void)
> +{
> +	return read_sysreg(pmccfiltr_el0);
> +}
> +
>  static inline void write_pmovsclr(u64 val)
>  {
>  	write_sysreg(val, pmovsclr_el0);
> diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
> index e633b4434c6a..01c9a9efdd1c 100644
> --- a/arch/arm64/kvm/pmu.c
> +++ b/arch/arm64/kvm/pmu.c
> @@ -6,6 +6,8 @@
>  #include <linux/kvm_host.h>
>  #include <linux/perf_event.h>
>  
> +#include <asm/arm_pmuv3.h>
> +
>  static DEFINE_PER_CPU(struct kvm_pmu_events, kvm_pmu_events);
>  
>  /*
> @@ -62,63 +64,16 @@ void kvm_clr_pmu_events(u64 clr)
>  	pmu->events_guest &= ~clr;
>  }
>  
> -#define PMEVTYPER_READ_CASE(idx)				\
> -	case idx:						\
> -		return read_sysreg(pmevtyper##idx##_el0)
> -
> -#define PMEVTYPER_WRITE_CASE(idx)				\
> -	case idx:						\
> -		write_sysreg(val, pmevtyper##idx##_el0);	\
> -		break
> -
> -#define PMEVTYPER_CASES(readwrite)				\
> -	PMEVTYPER_##readwrite##_CASE(0);			\
> -	PMEVTYPER_##readwrite##_CASE(1);			\
> -	PMEVTYPER_##readwrite##_CASE(2);			\
> -	PMEVTYPER_##readwrite##_CASE(3);			\
> -	PMEVTYPER_##readwrite##_CASE(4);			\
> -	PMEVTYPER_##readwrite##_CASE(5);			\
> -	PMEVTYPER_##readwrite##_CASE(6);			\
> -	PMEVTYPER_##readwrite##_CASE(7);			\
> -	PMEVTYPER_##readwrite##_CASE(8);			\
> -	PMEVTYPER_##readwrite##_CASE(9);			\
> -	PMEVTYPER_##readwrite##_CASE(10);			\
> -	PMEVTYPER_##readwrite##_CASE(11);			\
> -	PMEVTYPER_##readwrite##_CASE(12);			\
> -	PMEVTYPER_##readwrite##_CASE(13);			\
> -	PMEVTYPER_##readwrite##_CASE(14);			\
> -	PMEVTYPER_##readwrite##_CASE(15);			\
> -	PMEVTYPER_##readwrite##_CASE(16);			\
> -	PMEVTYPER_##readwrite##_CASE(17);			\
> -	PMEVTYPER_##readwrite##_CASE(18);			\
> -	PMEVTYPER_##readwrite##_CASE(19);			\
> -	PMEVTYPER_##readwrite##_CASE(20);			\
> -	PMEVTYPER_##readwrite##_CASE(21);			\
> -	PMEVTYPER_##readwrite##_CASE(22);			\
> -	PMEVTYPER_##readwrite##_CASE(23);			\
> -	PMEVTYPER_##readwrite##_CASE(24);			\
> -	PMEVTYPER_##readwrite##_CASE(25);			\
> -	PMEVTYPER_##readwrite##_CASE(26);			\
> -	PMEVTYPER_##readwrite##_CASE(27);			\
> -	PMEVTYPER_##readwrite##_CASE(28);			\
> -	PMEVTYPER_##readwrite##_CASE(29);			\
> -	PMEVTYPER_##readwrite##_CASE(30)
> -
>  /*
>   * Read a value direct from PMEVTYPER<idx> where idx is 0-30
>   * or PMCCFILTR_EL0 where idx is ARMV8_PMU_CYCLE_IDX (31).
>   */
>  static u64 kvm_vcpu_pmu_read_evtype_direct(int idx)
>  {
> -	switch (idx) {
> -	PMEVTYPER_CASES(READ);
> -	case ARMV8_PMU_CYCLE_IDX:
> -		return read_sysreg(pmccfiltr_el0);
> -	default:
> -		WARN_ON(1);
> -	}
> +	if (idx == ARMV8_PMU_CYCLE_IDX)
> +		return read_pmccfiltr();
>  
> -	return 0;
> +	return read_pmevtypern(idx);
>  }
>  
>  /*
> @@ -127,14 +82,10 @@ static u64 kvm_vcpu_pmu_read_evtype_direct(int idx)
>   */
>  static void kvm_vcpu_pmu_write_evtype_direct(int idx, u32 val)
>  {
> -	switch (idx) {
> -	PMEVTYPER_CASES(WRITE);
> -	case ARMV8_PMU_CYCLE_IDX:
> -		write_sysreg(val, pmccfiltr_el0);
> -		break;
> -	default:
> -		WARN_ON(1);
> -	}
> +	if (idx == ARMV8_PMU_CYCLE_IDX)
> +		write_pmccfiltr(val);
> +	else
> +		write_pmevtypern(idx, val);
>  }
>  
>  /*
> 
> -- 
> 2.43.0
> 
