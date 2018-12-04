From: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH v4 4/4] arm64: KVM: Enable support for :G/:H perf event
 modifiers
Date: Tue, 4 Dec 2018 16:16:01 +0000
Message-ID: <4ddb1abb-441d-b504-790d-f2bc45c52db9@arm.com>
References: <1543935500-23207-1-git-send-email-andrew.murray@arm.com>
 <1543935500-23207-5-git-send-email-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BDFA4A214
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Dec 2018 11:16:07 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id edSZksr5bMxF for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Dec 2018 11:16:06 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3590D4A1FA
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Dec 2018 11:16:06 -0500 (EST)
In-Reply-To: <1543935500-23207-5-git-send-email-andrew.murray@arm.com>
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

On 04/12/18 14:58, Andrew Murray wrote:
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
>  arch/arm64/kvm/hyp/switch.c | 41 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 41 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index d496ef5..5e03921 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -373,6 +373,35 @@ static bool __hyp_text __hyp_switch_fpsimd(struct kvm_vcpu *vcpu)
>  	return true;
>  }
>  
> +static bool __hyp_text __pmu_switch_to_guest(struct kvm_cpu_context *host_ctxt)
> +{
> +	u32 host = host_ctxt->events_host;
> +	u32 guest = host_ctxt->events_guest;
> +
> +	if (host == guest)
> +		return false;
> +
> +	if (host)
> +		write_sysreg(host, pmcntenclr_el0);

Nit:
Instead of clearing host counters we could clear non-guest counters:

	u32 clear_events = host_ctxt->events_hosts & ~guest;
		
	if (clear_events)
		write_sysreg(clear_events, pmcntenclr_el0);

Don't know if it makes a lot of difference.

> +
> +	if (guest)
> +		write_sysreg(guest, pmcntenset_el0);
> +
> +	return (host || guest);

We know this is true. If both (host == 0 && guest == 0) then (host ==
guest) meaning we returned false.


> +}
> +
> +static void __hyp_text __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
> +{
> +	u32 host = host_ctxt->events_host;
> +	u32 guest = host_ctxt->events_guest;
> +
> +	if (guest)
> +		write_sysreg(guest, pmcntenclr_el0);

Nit:
Same as above, we could just clear the counters that are exclusive to
the guest.

Cheers,

-- 
Julien Thierry
