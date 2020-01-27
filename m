Return-Path: <SRS0=6gnH=3Q=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBB1DC2D0DB
	for <kvmarm@archiver.kernel.org>; Mon, 27 Jan 2020 12:32:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7645A206F0
	for <kvmarm@archiver.kernel.org>; Mon, 27 Jan 2020 12:32:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="WsK7TKXA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7645A206F0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 18F424AEB3;
	Mon, 27 Jan 2020 07:32:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xrvmfwyGC4OA; Mon, 27 Jan 2020 07:32:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B1D804ACFA;
	Mon, 27 Jan 2020 07:32:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 39C834ACF4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jan 2020 07:32:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 06an1p0MrnHO for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Jan 2020 07:32:25 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ACF5C4A5BD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jan 2020 07:32:25 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 54E10206F0;
 Mon, 27 Jan 2020 12:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1580128344;
 bh=E0Rndhv4n8+31UjpDo5c6otkcmH+yPSSM/NvvxVcoEk=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=WsK7TKXANvoO+hyaTCDZjlq/GlfY2FDvsaRPLLfAlC0Kj4cx+XcKPVte4YoBzhtzL
 eSR+ucBmICnO1WjFrV2bZ0UTgfr/v/dS7MbRZ3aRUxEGbyX1DZRKAgRc7/6ZZEjrzu
 PVIcQanlWx6Oveb2Cy1wbwhMHiaD9RzswVGWV+wc=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1iw3Z0-001boM-D8; Mon, 27 Jan 2020 12:32:22 +0000
MIME-Version: 1.0
Date: Mon, 27 Jan 2020 12:32:22 +0000
From: Marc Zyngier <maz@kernel.org>
To: Andrew Murray <andrew.murray@arm.com>
Subject: Re: [PATCH v5 3/3] arm64: perf: Add support for ARMv8.5-PMU 64-bit
 counters
In-Reply-To: <1580125469-23887-4-git-send-email-andrew.murray@arm.com>
References: <1580125469-23887-1-git-send-email-andrew.murray@arm.com>
 <1580125469-23887-4-git-send-email-andrew.murray@arm.com>
Message-ID: <c948d8202b82bccbac0ec2a4f71ce94b@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.8
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: andrew.murray@arm.com, catalin.marinas@arm.com,
 will@kernel.org, mark.rutland@arm.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Suzuki.Poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2020-01-27 11:44, Andrew Murray wrote:
> At present ARMv8 event counters are limited to 32-bits, though by
> using the CHAIN event it's possible to combine adjacent counters to
> achieve 64-bits. The perf config1:0 bit can be set to use such a
> configuration.
> 
> With the introduction of ARMv8.5-PMU support, all event counters can
> now be used as 64-bit counters.
> 
> Let's enable 64-bit event counters where support exists. Unless the
> user sets config1:0 we will adjust the counter value such that it
> overflows upon 32-bit overflow. This follows the same behaviour as
> the cycle counter which has always been (and remains) 64-bits.
> 
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  arch/arm64/include/asm/perf_event.h |  3 +-
>  arch/arm64/include/asm/sysreg.h     |  1 +
>  arch/arm64/kernel/perf_event.c      | 86 
> +++++++++++++++++++++++++++++--------
>  include/linux/perf/arm_pmu.h        |  1 +
>  4 files changed, 73 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/perf_event.h
> b/arch/arm64/include/asm/perf_event.h
> index 2bdbc79..e7765b6 100644
> --- a/arch/arm64/include/asm/perf_event.h
> +++ b/arch/arm64/include/asm/perf_event.h
> @@ -176,9 +176,10 @@
>  #define ARMV8_PMU_PMCR_X	(1 << 4) /* Export to ETM */
>  #define ARMV8_PMU_PMCR_DP	(1 << 5) /* Disable CCNT if non-invasive 
> debug*/
>  #define ARMV8_PMU_PMCR_LC	(1 << 6) /* Overflow on 64 bit cycle counter 
> */
> +#define ARMV8_PMU_PMCR_LP	(1 << 7) /* Long event counter enable */
>  #define	ARMV8_PMU_PMCR_N_SHIFT	11	 /* Number of counters supported */
>  #define	ARMV8_PMU_PMCR_N_MASK	0x1f
> -#define	ARMV8_PMU_PMCR_MASK	0x7f	 /* Mask for writable bits */
> +#define	ARMV8_PMU_PMCR_MASK	0xff	 /* Mask for writable bits */
> 
>  /*
>   * PMOVSR: counters overflow flag status reg
> diff --git a/arch/arm64/include/asm/sysreg.h 
> b/arch/arm64/include/asm/sysreg.h
> index 1009878..30c1e18 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -675,6 +675,7 @@
>  #define ID_DFR0_PERFMON_SHIFT		24
> 
>  #define ID_DFR0_EL1_PMUVER_8_1		4
> +#define ID_DFR0_EL1_PMUVER_8_4		5

This doesn't seem right, see below.

>  #define ID_AA64DFR0_EL1_PMUVER_8_1	4
> 
>  #define ID_ISAR5_RDM_SHIFT		24
> diff --git a/arch/arm64/kernel/perf_event.c 
> b/arch/arm64/kernel/perf_event.c
> index e40b656..4e27f90 100644
> --- a/arch/arm64/kernel/perf_event.c
> +++ b/arch/arm64/kernel/perf_event.c
> @@ -285,6 +285,17 @@ static struct attribute_group
> armv8_pmuv3_format_attr_group = {
>  #define	ARMV8_IDX_COUNTER_LAST(cpu_pmu) \
>  	(ARMV8_IDX_CYCLE_COUNTER + cpu_pmu->num_events - 1)
> 
> +
> +/*
> + * We unconditionally enable ARMv8.5-PMU long event counter support
> + * (64-bit events) where supported. Indicate if this arm_pmu has long
> + * event counter support.
> + */
> +static bool armv8pmu_has_long_event(struct arm_pmu *cpu_pmu)
> +{
> +	return (cpu_pmu->pmuver > ID_DFR0_EL1_PMUVER_8_4);

Isn't the ID_DFR0 prefix for AArch32? Although this doesn't change much
the final result (the values happen to be the same on both 
architectures),
it is nonetheless a bit confusing.

> +}
> +
>  /*
>   * We must chain two programmable counters for 64 bit events,
>   * except when we have allocated the 64bit cycle counter (for CPU
> @@ -294,9 +305,11 @@ static struct attribute_group
> armv8_pmuv3_format_attr_group = {
>  static inline bool armv8pmu_event_is_chained(struct perf_event *event)
>  {
>  	int idx = event->hw.idx;
> +	struct arm_pmu *cpu_pmu = to_arm_pmu(event->pmu);
> 
>  	return !WARN_ON(idx < 0) &&
>  	       armv8pmu_event_is_64bit(event) &&
> +	       !armv8pmu_has_long_event(cpu_pmu) &&
>  	       (idx != ARMV8_IDX_CYCLE_COUNTER);
>  }
> 
> @@ -345,7 +358,7 @@ static inline void armv8pmu_select_counter(int idx)
>  	isb();
>  }
> 
> -static inline u32 armv8pmu_read_evcntr(int idx)
> +static inline u64 armv8pmu_read_evcntr(int idx)
>  {
>  	armv8pmu_select_counter(idx);
>  	return read_sysreg(pmxevcntr_el0);
> @@ -362,6 +375,44 @@ static inline u64 armv8pmu_read_hw_counter(struct
> perf_event *event)
>  	return val;
>  }
> 
> +/*
> + * The cycle counter is always a 64-bit counter. When 
> ARMV8_PMU_PMCR_LP
> + * is set the event counters also become 64-bit counters. Unless the
> + * user has requested a long counter (attr.config1) then we want to
> + * interrupt upon 32-bit overflow - we achieve this by applying a 
> bias.
> + */
> +static bool armv8pmu_event_needs_bias(struct perf_event *event)
> +{
> +	struct arm_pmu *cpu_pmu = to_arm_pmu(event->pmu);
> +	struct hw_perf_event *hwc = &event->hw;
> +	int idx = hwc->idx;
> +
> +	if (armv8pmu_event_is_64bit(event))
> +		return false;
> +
> +	if (armv8pmu_has_long_event(cpu_pmu) ||
> +	    idx == ARMV8_IDX_CYCLE_COUNTER)
> +		return true;
> +
> +	return false;
> +}
> +
> +static u64 armv8pmu_bias_long_counter(struct perf_event *event, u64 
> value)
> +{
> +	if (armv8pmu_event_needs_bias(event))
> +		value |= GENMASK(63, 32);
> +
> +	return value;
> +}
> +
> +static u64 armv8pmu_unbias_long_counter(struct perf_event *event, u64 
> value)
> +{
> +	if (armv8pmu_event_needs_bias(event))
> +		value &= ~GENMASK(63, 32);
> +
> +	return value;
> +}
> +
>  static u64 armv8pmu_read_counter(struct perf_event *event)
>  {
>  	struct arm_pmu *cpu_pmu = to_arm_pmu(event->pmu);
> @@ -377,10 +428,10 @@ static u64 armv8pmu_read_counter(struct 
> perf_event *event)
>  	else
>  		value = armv8pmu_read_hw_counter(event);
> 
> -	return value;
> +	return  armv8pmu_unbias_long_counter(event, value);
>  }
> 
> -static inline void armv8pmu_write_evcntr(int idx, u32 value)
> +static inline void armv8pmu_write_evcntr(int idx, u64 value)
>  {
>  	armv8pmu_select_counter(idx);
>  	write_sysreg(value, pmxevcntr_el0);
> @@ -405,20 +456,14 @@ static void armv8pmu_write_counter(struct
> perf_event *event, u64 value)
>  	struct hw_perf_event *hwc = &event->hw;
>  	int idx = hwc->idx;
> 
> +	value = armv8pmu_bias_long_counter(event, value);
> +
>  	if (!armv8pmu_counter_valid(cpu_pmu, idx))
>  		pr_err("CPU%u writing wrong counter %d\n",
>  			smp_processor_id(), idx);
> -	else if (idx == ARMV8_IDX_CYCLE_COUNTER) {
> -		/*
> -		 * The cycles counter is really a 64-bit counter.
> -		 * When treating it as a 32-bit counter, we only count
> -		 * the lower 32 bits, and set the upper 32-bits so that
> -		 * we get an interrupt upon 32-bit overflow.
> -		 */
> -		if (!armv8pmu_event_is_64bit(event))
> -			value |= 0xffffffff00000000ULL;
> +	else if (idx == ARMV8_IDX_CYCLE_COUNTER)
>  		write_sysreg(value, pmccntr_el0);
> -	} else
> +	else
>  		armv8pmu_write_hw_counter(event, value);
>  }
> 
> @@ -743,7 +788,8 @@ static int armv8pmu_get_event_idx(struct
> pmu_hw_events *cpuc,
>  	/*
>  	 * Otherwise use events counters
>  	 */
> -	if (armv8pmu_event_is_64bit(event))
> +	if (armv8pmu_event_is_64bit(event) &&
> +	    !armv8pmu_has_long_event(cpu_pmu))
>  		return	armv8pmu_get_chain_idx(cpuc, cpu_pmu);
>  	else
>  		return armv8pmu_get_single_idx(cpuc, cpu_pmu);
> @@ -815,7 +861,7 @@ static int armv8pmu_filter_match(struct perf_event 
> *event)
>  static void armv8pmu_reset(void *info)
>  {
>  	struct arm_pmu *cpu_pmu = (struct arm_pmu *)info;
> -	u32 idx, nb_cnt = cpu_pmu->num_events;
> +	u32 idx, pmcr, nb_cnt = cpu_pmu->num_events;
> 
>  	/* The counter and interrupt enable registers are unknown at reset. 
> */
>  	for (idx = ARMV8_IDX_CYCLE_COUNTER; idx < nb_cnt; ++idx) {
> @@ -830,8 +876,13 @@ static void armv8pmu_reset(void *info)
>  	 * Initialize & Reset PMNC. Request overflow interrupt for
>  	 * 64 bit cycle counter but cheat in armv8pmu_write_counter().
>  	 */
> -	armv8pmu_pmcr_write(ARMV8_PMU_PMCR_P | ARMV8_PMU_PMCR_C |
> -			    ARMV8_PMU_PMCR_LC);
> +	pmcr = ARMV8_PMU_PMCR_P | ARMV8_PMU_PMCR_C | ARMV8_PMU_PMCR_LC;
> +
> +	/* Enable long event counter support where available */
> +	if (armv8pmu_has_long_event(cpu_pmu))
> +		pmcr |= ARMV8_PMU_PMCR_LP;
> +
> +	armv8pmu_pmcr_write(pmcr);
>  }
> 
>  static int __armv8_pmuv3_map_event(struct perf_event *event,
> @@ -914,6 +965,7 @@ static void __armv8pmu_probe_pmu(void *info)
>  	if (pmuver == 0xf || pmuver == 0)
>  		return;
> 
> +	cpu_pmu->pmuver = pmuver;

And pmuver comes from ID_AA64DFR0_PMUVER_SHIFT, so the above really
needs fixing in the name of consistency.

>  	probe->present = true;
> 
>  	/* Read the nb of CNTx counters supported from PMNC */
> diff --git a/include/linux/perf/arm_pmu.h 
> b/include/linux/perf/arm_pmu.h
> index 71f525a..5b616dd 100644
> --- a/include/linux/perf/arm_pmu.h
> +++ b/include/linux/perf/arm_pmu.h
> @@ -80,6 +80,7 @@ struct arm_pmu {
>  	struct pmu	pmu;
>  	cpumask_t	supported_cpus;
>  	char		*name;
> +	int		pmuver;
>  	irqreturn_t	(*handle_irq)(struct arm_pmu *pmu);
>  	void		(*enable)(struct perf_event *event);
>  	void		(*disable)(struct perf_event *event);

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
