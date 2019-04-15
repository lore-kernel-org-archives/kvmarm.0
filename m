From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v13 7/8] arm64: KVM: avoid isb's by using direct
 pmxevtyper sysreg
Date: Mon, 15 Apr 2019 14:49:41 +0100
Message-ID: <c4a836ec-9e0b-2957-22ec-73d0625ce8cb@arm.com>
References: <20190409192217.23459-1-andrew.murray@arm.com>
 <20190409192217.23459-8-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B29664A486
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Apr 2019 09:49:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8iWaKWJSjBtE for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Apr 2019 09:49:45 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 52A3A4A484
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Apr 2019 09:49:45 -0400 (EDT)
In-Reply-To: <20190409192217.23459-8-andrew.murray@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: andrew.murray@arm.com, christoffer.dall@arm.com, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, mark.rutland@arm.com
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



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
