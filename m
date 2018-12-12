From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v8 5/5] arm64: KVM: Enable support for :G/:H perf event
 modifiers
Date: Wed, 12 Dec 2018 10:53:35 +0000
Message-ID: <9aaf29ba-b320-fb5e-cbc8-3e6067e3ef26@arm.com>
References: <1544610573-28446-1-git-send-email-andrew.murray@arm.com>
 <1544610573-28446-6-git-send-email-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C5E34A200
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Dec 2018 05:53:42 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id thJY18+CqDhe for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Dec 2018 05:53:41 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 238C34A1FA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Dec 2018 05:53:41 -0500 (EST)
In-Reply-To: <1544610573-28446-6-git-send-email-andrew.murray@arm.com>
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



On 12/12/2018 10:29, Andrew Murray wrote:
> Enable/disable event counters as appropriate when entering and exiting
> the guest to enable support for guest or host only event counting.
> 
> For both VHE and non-VHE we switch the counters between host/guest at
> EL2. EL2 is filtered out by the PMU when we are using the :G modifier.
> 
> The PMU may be on when we change which counters are enabled however
> we avoid adding an isb as we instead rely on existing context
> synchronisation events: the isb in kvm_arm_vhe_guest_exit for VHE and
> the eret from the hvc in kvm_call_hyp.
> 
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> ---
>   arch/arm64/kvm/hyp/switch.c | 52 +++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 52 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index d496ef5..9732ef7 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -373,6 +373,46 @@ static bool __hyp_text __hyp_switch_fpsimd(struct kvm_vcpu *vcpu)
>   	return true;
>   }
>   
> +static bool __hyp_text __pmu_switch_to_guest(struct kvm_cpu_context *host_ctxt)
> +{
> +	struct kvm_host_data *host;
> +	struct kvm_pmu_events *pmu;
> +	u32 clr, set;
> +
> +	host = container_of(host_ctxt, struct kvm_host_data, host_ctxt);
> +	pmu = &host->pmu_events;
> +
> +	clr = pmu->events_host & ~pmu->events_guest;
> +	set = pmu->events_guest & ~pmu->events_host;

It may make sense to add in a comment explaining why we only set:

	events_guest & ~events_host

Either way:

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
