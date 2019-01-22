From: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH 2/4] KVM: arm/arm64: re-create event when setting counter
 value
Date: Tue, 22 Jan 2019 12:12:51 +0000
Message-ID: <a53b470c-f82c-0070-b2b9-61f30d7d01bb@arm.com>
References: <1548154197-5470-1-git-send-email-andrew.murray@arm.com>
 <1548154197-5470-3-git-send-email-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D5EC94A3AF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jan 2019 07:12:56 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RXgAtcPiehBl for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Jan 2019 07:12:55 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C5144A387
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jan 2019 07:12:55 -0500 (EST)
In-Reply-To: <1548154197-5470-3-git-send-email-andrew.murray@arm.com>
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
To: Andrew Murray <andrew.murray@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andrew,

On 22/01/2019 10:49, Andrew Murray wrote:
> The perf event sample_period is currently set based upon the current
> counter value, when PMXEVTYPER is written to and the perf event is created.
> However the user may choose to write the type before the counter value in
> which case sample_period will be set incorrectly. Let's instead decouple
> event creation from PMXEVTYPER and (re)create the event in either
> suitation.
> 
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> ---
>  virt/kvm/arm/pmu.c | 39 ++++++++++++++++++++++++++++++---------
>  1 file changed, 30 insertions(+), 9 deletions(-)
> 
> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> index 531d27f..4464899 100644
> --- a/virt/kvm/arm/pmu.c
> +++ b/virt/kvm/arm/pmu.c
> @@ -24,6 +24,8 @@
>  #include <kvm/arm_pmu.h>
>  #include <kvm/arm_vgic.h>
>  
> +static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 data,
> +				      u64 select_idx);
>  /**
>   * kvm_pmu_get_counter_value - get PMU counter value
>   * @vcpu: The vcpu pointer
> @@ -57,11 +59,18 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
>   */
>  void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
>  {
> -	u64 reg;
> +	u64 reg, data;
>  
>  	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
>  	      ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + select_idx;
>  	__vcpu_sys_reg(vcpu, reg) += (s64)val - kvm_pmu_get_counter_value(vcpu, select_idx);
> +
> +	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
> +	      ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + select_idx;
> +	data = __vcpu_sys_reg(vcpu, reg + select_idx);

I think this should be just "reg" instead of "reg + select_idx".

Cheers,

-- 
Julien Thierry
