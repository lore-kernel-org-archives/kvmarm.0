Return-Path: <SRS0=Ladk=4V=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04887C3F2CE
	for <kvmarm@archiver.kernel.org>; Wed,  4 Mar 2020 18:02:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B947024658
	for <kvmarm@archiver.kernel.org>; Wed,  4 Mar 2020 18:02:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B947024658
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 630054AF67;
	Wed,  4 Mar 2020 13:02:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pjmKVglqobvF; Wed,  4 Mar 2020 13:02:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 389724AF58;
	Wed,  4 Mar 2020 13:02:53 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E7B254AEC2
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Mar 2020 13:02:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zjBerS9Hv7YB for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Mar 2020 13:02:50 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9144C4AF46
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Mar 2020 13:02:50 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2676531B;
 Wed,  4 Mar 2020 10:02:50 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A6AAD3F6C4;
 Wed,  4 Mar 2020 10:02:48 -0800 (PST)
Date: Wed, 4 Mar 2020 18:02:46 +0000
From: Andre Przywara <andre.przywara@arm.com>
To: Eric Auger <eric.auger@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v2 4/9] arm: pmu: Check Required Event
 Support
Message-ID: <20200304180246.20725ceb@donnerap.cambridge.arm.com>
In-Reply-To: <20200130112510.15154-5-eric.auger@redhat.com>
References: <20200130112510.15154-1-eric.auger@redhat.com>
 <20200130112510.15154-5-eric.auger@redhat.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, maz@kernel.org, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, andrew.murray@arm.com, kvmarm@lists.cs.columbia.edu,
 eric.auger.pro@gmail.com
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Thu, 30 Jan 2020 12:25:05 +0100
Eric Auger <eric.auger@redhat.com> wrote:

Hi,

> If event counters are implemented check the common events
> required by the PMUv3 are implemented.
> 
> Some are unconditionally required (SW_INCR, CPU_CYCLES,
> either INST_RETIRED or INST_SPEC). Some others only are
> required if the implementation implements some other features.
> 
> Check those wich are unconditionally required.
> 
> This test currently fails on TCG as neither INST_RETIRED
> or INST_SPEC are supported.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> 
> v1 -> v2:
> - fix is_event_supported()
> - fix boolean condition for PMU v4
> - fix PMCEID0 definition
> 
> RFC ->v1:
> - add a comment to explain the PMCEID0/1 splits
> ---
>  arm/pmu.c         | 62 +++++++++++++++++++++++++++++++++++++++++++++++
>  arm/unittests.cfg |  6 +++++
>  2 files changed, 68 insertions(+)
> 
> diff --git a/arm/pmu.c b/arm/pmu.c
> index d24857e..4a26a76 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -101,6 +101,10 @@ static inline void precise_instrs_loop(int loop, uint32_t pmcr)
>  	: [pmcr] "r" (pmcr), [z] "r" (0)
>  	: "cc");
>  }
> +
> +/* event counter tests only implemented for aarch64 */
> +static void test_event_introspection(void) {}
> +
>  #elif defined(__aarch64__)
>  #define ID_AA64DFR0_PERFMON_SHIFT 8
>  #define ID_AA64DFR0_PERFMON_MASK  0xf
> @@ -139,6 +143,61 @@ static inline void precise_instrs_loop(int loop, uint32_t pmcr)
>  	: [pmcr] "r" (pmcr)
>  	: "cc");
>  }
> +
> +#define PMCEID1_EL0 sys_reg(3, 3, 9, 12, 7)
> +
> +static bool is_event_supported(uint32_t n, bool warn)
> +{
> +	uint64_t pmceid0 = read_sysreg(pmceid0_el0);
> +	uint64_t pmceid1 = read_sysreg_s(PMCEID1_EL0);
> +	bool supported;
> +	uint64_t reg;
> +
> +	/*
> +	 * The low 32-bits of PMCEID0/1 respectly describe
> +	 * event support for events 0-31/32-63. Their High
> +	 * 32-bits describe support for extended events
> +	 * starting at 0x4000, using the same split.
> +	 */
> +	if (n >= 0x0  && n <= 0x3F)
> +		reg = (pmceid0 & 0xFFFFFFFF) | ((pmceid1 & 0xFFFFFFFF) << 32);
> +	else if  (n >= 0x4000 && n <= 0x403F)
> +		reg = (pmceid0 >> 32) | ((pmceid1 >> 32) << 32);
> +	else
> +		abort();
> +
> +	supported =  reg & (1UL << (n & 0x3F));
> +
> +	if (!supported && warn)
> +		report_info("event %d is not supported", n);
> +	return supported;
> +}
> +
> +static void test_event_introspection(void)
> +{
> +	bool required_events;
> +
> +	if (!pmu.nb_implemented_counters) {
> +		report_skip("No event counter, skip ...");
> +		return;
> +	}
> +
> +	/* PMUv3 requires an implementation includes some common events */
> +	required_events = is_event_supported(0x0, true) /* SW_INCR */ &&
> +			  is_event_supported(0x11, true) /* CPU_CYCLES */ &&
> +			  (is_event_supported(0x8, true) /* INST_RETIRED */ ||
> +			   is_event_supported(0x1B, true) /* INST_PREC */);
> +
> +	if (pmu.version == 0x4) {

I think this should read >= 0x4, since those requirements are stacked on top of the prevision revision's requirements. Even better with some symbolic name.

With that fixed:

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> +		/* ARMv8.1 PMU: STALL_FRONTEND and STALL_BACKEND are required */
> +		required_events = required_events &&
> +				  is_event_supported(0x23, true) &&
> +				  is_event_supported(0x24, true);
> +	}
> +
> +	report(required_events, "Check required events are implemented");
> +}
> +
>  #endif
>  
>  /*
> @@ -326,6 +385,9 @@ int main(int argc, char *argv[])
>  		       "Monotonically increasing cycle count");
>  		report(check_cpi(cpi), "Cycle/instruction ratio");
>  		pmccntr64_test();
> +	} else if (strcmp(argv[1], "event-introspection") == 0) {
> +		report_prefix_push(argv[1]);
> +		test_event_introspection();
>  	} else {
>  		report_abort("Unknown sub-test '%s'", argv[1]);
>  	}
> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> index 79f0d7a..4433ef3 100644
> --- a/arm/unittests.cfg
> +++ b/arm/unittests.cfg
> @@ -66,6 +66,12 @@ file = pmu.flat
>  groups = pmu
>  extra_params = -append 'cycle-counter 0'
>  
> +[pmu-event-introspection]
> +file = pmu.flat
> +groups = pmu
> +arch = arm64
> +extra_params = -append 'event-introspection'
> +
>  # Test PMU support (TCG) with -icount IPC=1
>  #[pmu-tcg-icount-1]
>  #file = pmu.flat

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
