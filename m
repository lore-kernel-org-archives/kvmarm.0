Return-Path: <SRS0=r5x+=SR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22FABC10F0E
	for <kvmarm@archiver.kernel.org>; Mon, 15 Apr 2019 13:49:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B52EF2073F
	for <kvmarm@archiver.kernel.org>; Mon, 15 Apr 2019 13:49:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B52EF2073F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 375E64A486;
	Mon, 15 Apr 2019 09:49:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PTx5RH47RIbQ; Mon, 15 Apr 2019 09:49:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 059724A4C3;
	Mon, 15 Apr 2019 09:49:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B29664A486
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Apr 2019 09:49:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8iWaKWJSjBtE for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Apr 2019 09:49:45 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 52A3A4A484
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Apr 2019 09:49:45 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A5D50374;
 Mon, 15 Apr 2019 06:49:44 -0700 (PDT)
Received: from [10.1.196.93] (en101.cambridge.arm.com [10.1.196.93])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 20CC03F68F;
 Mon, 15 Apr 2019 06:49:42 -0700 (PDT)
Subject: Re: [PATCH v13 7/8] arm64: KVM: avoid isb's by using direct
 pmxevtyper sysreg
To: andrew.murray@arm.com, christoffer.dall@arm.com, marc.zyngier@arm.com,
 catalin.marinas@arm.com, will.deacon@arm.com, mark.rutland@arm.com
References: <20190409192217.23459-1-andrew.murray@arm.com>
 <20190409192217.23459-8-andrew.murray@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <c4a836ec-9e0b-2957-22ec-73d0625ce8cb@arm.com>
Date: Mon, 15 Apr 2019 14:49:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190409192217.23459-8-andrew.murray@arm.com>
Content-Language: en-US
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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
Content-Type: text/plain; charset="UTF-8"; format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190415134941.uDvMkR0_XYYM6dAyICPdOfP0D38GLcfVQaV0MxlO5pQ@z>



On 09/04/2019 20:22, Andrew Murray wrote:
> Upon entering or exiting a guest we may modify multiple PMU counters to
> enable of disable EL0 filtering. We presently do this via the indirect
> PMXEVTYPER_EL0 system register (where the counter we modify is selected
> by PMSELR). With this approach it is necessary to order the writes via
> isb instructions such that we select the correct counter before modifying
> it.
> 
> Let's avoid potentially expensive instruction barriers by using the
> direct PMEVTYPER<n>_EL0 registers instead.
> 
> As the change to counter type relates only to EL0 filtering we can rely
> on the implicit instruction barrier which occurs when we transition from
> EL2 to EL1 on entering the guest. On returning to userspace we can, at the
> latest, rely on the implicit barrier between EL2 and EL0. We can also
> depend on the explicit isb in armv8pmu_select_counter to order our write
> against any other kernel changes by the PMU driver to the type register as
> a result of preemption.
> 
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> ---
>   arch/arm64/kvm/pmu.c | 84 ++++++++++++++++++++++++++++++++++++++------
>   1 file changed, 74 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
> index 3407a529e116..4d55193ccc71 100644
> --- a/arch/arm64/kvm/pmu.c
> +++ b/arch/arm64/kvm/pmu.c
> @@ -91,6 +91,74 @@ void __hyp_text __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
>   		write_sysreg(pmu->events_host, pmcntenset_el0);
>   }
>   
> +#define PMEVTYPER_READ_CASE(idx)				\
> +	case idx:						\
> +		return read_sysreg(pmevtyper##idx##_el0)
> +
> +#define PMEVTYPER_WRITE_CASE(idx)				\
> +	case idx:						\
> +		write_sysreg(val, pmevtyper##idx##_el0);	\
> +		break
> +
> +#define PMEVTYPER_CASES(readwrite)				\
> +	PMEVTYPER_##readwrite##_CASE(0);			\
> +	PMEVTYPER_##readwrite##_CASE(1);			\
> +	PMEVTYPER_##readwrite##_CASE(2);			\
> +	PMEVTYPER_##readwrite##_CASE(3);			\
> +	PMEVTYPER_##readwrite##_CASE(4);			\
> +	PMEVTYPER_##readwrite##_CASE(5);			\
> +	PMEVTYPER_##readwrite##_CASE(6);			\
> +	PMEVTYPER_##readwrite##_CASE(7);			\
> +	PMEVTYPER_##readwrite##_CASE(8);			\
> +	PMEVTYPER_##readwrite##_CASE(9);			\
> +	PMEVTYPER_##readwrite##_CASE(10);			\
> +	PMEVTYPER_##readwrite##_CASE(11);			\
> +	PMEVTYPER_##readwrite##_CASE(12);			\
> +	PMEVTYPER_##readwrite##_CASE(13);			\
> +	PMEVTYPER_##readwrite##_CASE(14);			\
> +	PMEVTYPER_##readwrite##_CASE(15);			\
> +	PMEVTYPER_##readwrite##_CASE(16);			\
> +	PMEVTYPER_##readwrite##_CASE(17);			\
> +	PMEVTYPER_##readwrite##_CASE(18);			\
> +	PMEVTYPER_##readwrite##_CASE(19);			\
> +	PMEVTYPER_##readwrite##_CASE(20);			\
> +	PMEVTYPER_##readwrite##_CASE(21);			\
> +	PMEVTYPER_##readwrite##_CASE(22);			\
> +	PMEVTYPER_##readwrite##_CASE(23);			\
> +	PMEVTYPER_##readwrite##_CASE(24);			\
> +	PMEVTYPER_##readwrite##_CASE(25);			\
> +	PMEVTYPER_##readwrite##_CASE(26);			\
> +	PMEVTYPER_##readwrite##_CASE(27);			\
> +	PMEVTYPER_##readwrite##_CASE(28);			\
> +	PMEVTYPER_##readwrite##_CASE(29);			\
> +	PMEVTYPER_##readwrite##_CASE(30)
> +

Don't we need case 31 and deal with the PMCCFILTR, instead of WARN_ON(1)
below ?

Otherwise,

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
