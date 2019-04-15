From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v13 6/8] arm64: KVM: Enable VHE support for :G/:H perf
 event modifiers
Date: Mon, 15 Apr 2019 14:43:36 +0100
Message-ID: <2bbd0c72-3f51-f942-d6a2-478db940445f@arm.com>
References: <20190409192217.23459-1-andrew.murray@arm.com>
 <20190409192217.23459-7-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20190409192217.23459-7-andrew.murray@arm.com>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: andrew.murray@arm.com, christoffer.dall@arm.com, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, mark.rutland@arm.com
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, julien.thierry@arm.com
List-Id: kvmarm@lists.cs.columbia.edu



On 09/04/2019 20:22, Andrew Murray wrote:
> With VHE different exception levels are used between the host (EL2) and
> guest (EL1) with a shared exception level for userpace (EL0). We can take
> advantage of this and use the PMU's exception level filtering to avoid
> enabling/disabling counters in the world-switch code. Instead we just

s/Instead// ?

> modify the counter type to include or exclude EL0 at vcpu_{load,put} time.


> 
> We also ensure that trapped PMU system register writes do not re-enable
> EL0 when reconfiguring the backing perf events.
> 
> This approach completely avoids blackout windows seen with !VHE.
> 
> Suggested-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> Acked-by: Will Deacon <will.deacon@arm.com>

....

> +/*
> + * On VHE ensure that only guest events have EL0 counting enabled
> + */
> +void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_cpu_context *host_ctxt;
> +	struct kvm_host_data *host;
> +	u32 events_guest, events_host;
> +
> +	if (!has_vhe())
> +		return;
> +
> +	host_ctxt = vcpu->arch.host_cpu_context;
> +	host = container_of(host_ctxt, struct kvm_host_data, host_ctxt);
> +	events_guest = host->pmu_events.events_guest;
> +	events_host = host->pmu_events.events_host;
> +
> +	kvm_vcpu_pmu_enable_el0(events_guest);
> +	kvm_vcpu_pmu_disable_el0(events_host);
> +}
> +
> +/*
> + * On VHE ensure that only guest host have EL0 counting enabled

nit: s/guest/host/host events/

> + */
> +void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_cpu_context *host_ctxt;
> +	struct kvm_host_data *host;
> +	u32 events_guest, events_host;
> +
> +	if (!has_vhe())
> +		return;
> +
> +	host_ctxt = vcpu->arch.host_cpu_context;
> +	host = container_of(host_ctxt, struct kvm_host_data, host_ctxt);
> +	events_guest = host->pmu_events.events_guest;
> +	events_host = host->pmu_events.events_host;
> +
> +	kvm_vcpu_pmu_enable_el0(events_host);
> +	kvm_vcpu_pmu_disable_el0(events_guest);
> +}
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 539feecda5b8..c7fa47ad2387 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -695,6 +695,7 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>   		val |= p->regval & ARMV8_PMU_PMCR_MASK;
>   		__vcpu_sys_reg(vcpu, PMCR_EL0) = val;
>   		kvm_pmu_handle_pmcr(vcpu, val);
> +		kvm_vcpu_pmu_restore_guest(vcpu);

nit: I am not sure if we need to do this for PMCR accesses ? Unless
we have modified some changes to the events (e.g, like the two instances
below). Or am I missing something here ?

Otherwise:

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
