From: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH 4/4] arm64: KVM: Enable support for :G/:H perf event
 modifiers
Date: Thu, 15 Nov 2018 14:00:39 +0000
Message-ID: <79000795-971d-22fa-6264-f85f2d528477@arm.com>
References: <1542286549-4501-1-git-send-email-andrew.murray@arm.com>
 <1542286549-4501-5-git-send-email-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A7E674A32F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Nov 2018 09:00:46 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id joA79S90gkrM for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Nov 2018 09:00:45 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7257A4A32A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Nov 2018 09:00:45 -0500 (EST)
In-Reply-To: <1542286549-4501-5-git-send-email-andrew.murray@arm.com>
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
To: Andrew Murray <andrew.murray@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andrew,

On 15/11/18 12:55, Andrew Murray wrote:
> Enable/disable event counters as appropriate when entering and exiting
> the guest to enable support for guest or host only event counting.
> 
> For both VHE and non-VHE we switch the counters between host/guest at
> EL2. EL2 is filtered out by the PMU when we are using the :G modifier.
> 
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> ---
>   arch/arm64/kvm/hyp/switch.c | 38 ++++++++++++++++++++++++++++++++++++++
>   1 file changed, 38 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index d496ef5..ebf0aac 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -373,6 +373,32 @@ static bool __hyp_text __hyp_switch_fpsimd(struct kvm_vcpu *vcpu)
>   	return true;
>   }
>   
> +static bool __hyp_text __pmu_switch_to_guest(struct kvm_cpu_context *host_ctxt)
> +{
> +	u32 host_only = host_ctxt->events_host_only;
> +	u32 guest_only = host_ctxt->events_guest_only;
> +
> +	if (host_only)
> +		write_sysreg(host_only, pmcntenclr_el0);
> +
> +	if (guest_only)
> +		write_sysreg(guest_only, pmcntenset_el0);
> +
> +	return (host_only || guest_only);
> +}
> +
> +static void __hyp_text __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
> +{
> +	u32 host_only = host_ctxt->events_host_only;
> +	u32 guest_only = host_ctxt->events_guest_only;
> +
> +	if (guest_only)
> +		write_sysreg(guest_only, pmcntenclr_el0);
> +
> +	if (host_only)
> +		write_sysreg(host_only, pmcntenset_el0);

In the perf_event code, there is an ISB after enabling an event. I guess 
we don't need it when setting the guest events since I believe the eret 
to the guess give us the context synchronization. But don't we need one 
here when restoring host only events?

Thanks,

-- 
Julien Thierry
