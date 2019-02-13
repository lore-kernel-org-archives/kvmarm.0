From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v2 3/5] KVM: arm/arm64: re-create event when setting
 counter value
Date: Wed, 13 Feb 2019 14:28:51 +0000
Message-ID: <3adc7d31-9d5a-d66b-21ee-9b4da986d24f@arm.com>
References: <1549299218-44714-1-git-send-email-andrew.murray@arm.com>
 <1549299218-44714-4-git-send-email-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1549299218-44714-4-git-send-email-andrew.murray@arm.com>
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
To: andrew.murray@arm.com, christoffer.dall@arm.com, marc.zyngier@arm.com
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, julien.thierry@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andrew,

On 04/02/2019 16:53, Andrew Murray wrote:
> The perf event sample_period is currently set based upon the current
> counter value, when PMXEVTYPER is written to and the perf event is created.
> However the user may choose to write the type before the counter value in
> which case sample_period will be set incorrectly. Let's instead decouple
> event creation from PMXEVTYPER and (re)create the event in either
> suitation.
> 
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> ---
>   virt/kvm/arm/pmu.c | 40 +++++++++++++++++++++++++++++++---------
>   1 file changed, 31 insertions(+), 9 deletions(-)
> 
> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> index 6e7c179..95d74ec 100644
> --- a/virt/kvm/arm/pmu.c
> +++ b/virt/kvm/arm/pmu.c
> @@ -24,6 +24,7 @@
>   #include <kvm/arm_pmu.h>
>   #include <kvm/arm_vgic.h>
>   
> +static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx);
>   /**
>    * kvm_pmu_get_counter_value - get PMU counter value
>    * @vcpu: The vcpu pointer
> @@ -62,6 +63,9 @@ void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
>   	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
>   	      ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + select_idx;
>   	__vcpu_sys_reg(vcpu, reg) += (s64)val - kvm_pmu_get_counter_value(vcpu, select_idx);
> +
> +	/* Recreate the perf event to reflect the updated sample_period */
> +	kvm_pmu_create_perf_event(vcpu, select_idx);
>   }
>   
>   /**
> @@ -378,23 +382,22 @@ static bool kvm_pmu_counter_is_enabled(struct kvm_vcpu *vcpu, u64 select_idx)
>   }
>   
>   /**
> - * kvm_pmu_set_counter_event_type - set selected counter to monitor some event
> + * kvm_pmu_create_perf_event - create a perf event for a counter
>    * @vcpu: The vcpu pointer
> - * @data: The data guest writes to PMXEVTYPER_EL0
> + * @data: Type of event as per PMXEVTYPER_EL0 format
>    * @select_idx: The number of selected counter

nit: data no longer exists.


> - *
> - * When OS accesses PMXEVTYPER_EL0, that means it wants to set a PMC to count an
> - * event with given hardware event number. Here we call perf_event API to
> - * emulate this action and create a kernel perf event for it.
>    */
> -void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
> -				    u64 select_idx)
> +static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
>   {

With the comment from Julien addressed,

Reviewed-by: Suzuki K Poulose <suzuki.poulse@arm.com>
