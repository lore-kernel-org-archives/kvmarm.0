From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v11 19/21] KVM: ARM64: Add a new feature bit for PMUv3
Date: Mon, 8 Feb 2016 13:29:57 +0100
Message-ID: <20160208122957.GE620@cbox>
References: <1454656456-11640-1-git-send-email-zhaoshenglong@huawei.com>
 <1454656456-11640-20-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1454656456-11640-20-git-send-email-zhaoshenglong@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com, Peter Maydell <peter.maydell@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Feb 05, 2016 at 03:14:14PM +0800, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> To support guest PMUv3, use one bit of the VCPU INIT feature array.
> Initialize the PMU when initialzing the vcpu with that bit and PMU
> overflow interrupt set.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> Acked-by: Peter Maydell <peter.maydell@linaro.org>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> ---
> CC: Peter Maydell <peter.maydell@linaro.org>
> ---
>  Documentation/virtual/kvm/api.txt | 2 ++
>  arch/arm64/include/asm/kvm_host.h | 2 +-
>  arch/arm64/include/uapi/asm/kvm.h | 1 +
>  arch/arm64/kvm/reset.c            | 3 +++
>  include/kvm/arm_pmu.h             | 2 ++
>  include/uapi/linux/kvm.h          | 1 +
>  virt/kvm/arm/pmu.c                | 9 +++++++++
>  7 files changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index 07e4cdf..9684f8d 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -2577,6 +2577,8 @@ Possible features:
>  	  Depends on KVM_CAP_ARM_EL1_32BIT (arm64 only).
>  	- KVM_ARM_VCPU_PSCI_0_2: Emulate PSCI v0.2 for the CPU.
>  	  Depends on KVM_CAP_ARM_PSCI_0_2.
> +	- KVM_ARM_VCPU_PMU_V3: Emulate PMUv3 for the CPU.
> +	  Depends on KVM_CAP_ARM_PMU_V3.
>  
>  
>  4.83 KVM_ARM_PREFERRED_TARGET
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 6bab7fb..cb220b7 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -40,7 +40,7 @@
>  
>  #define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
>  
> -#define KVM_VCPU_MAX_FEATURES 3
> +#define KVM_VCPU_MAX_FEATURES 4
>  
>  int __attribute_const__ kvm_target_cpu(void);
>  int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 2d4ca4b..6aedbe3 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -94,6 +94,7 @@ struct kvm_regs {
>  #define KVM_ARM_VCPU_POWER_OFF		0 /* CPU is started in OFF state */
>  #define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */
>  #define KVM_ARM_VCPU_PSCI_0_2		2 /* CPU uses PSCI v0.2 */
> +#define KVM_ARM_VCPU_PMU_V3		3 /* Support guest PMUv3 */
>  
>  struct kvm_vcpu_init {
>  	__u32 target;
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index dfbce78..cf4f28a 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -77,6 +77,9 @@ int kvm_arch_dev_ioctl_check_extension(long ext)
>  	case KVM_CAP_GUEST_DEBUG_HW_WPS:
>  		r = get_num_wrps();
>  		break;
> +	case KVM_CAP_ARM_PMU_V3:
> +		r = kvm_arm_support_pmu_v3();
> +		break;
>  	case KVM_CAP_SET_GUEST_DEBUG:
>  		r = 1;
>  		break;
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index d73cb97..5f86e1d 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -51,6 +51,7 @@ void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val);
>  void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val);
>  void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
>  				    u64 select_idx);
> +bool kvm_arm_support_pmu_v3(void);
>  #else
>  struct kvm_pmu {
>  };
> @@ -77,6 +78,7 @@ static inline void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val) {}
>  static inline void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val) {}
>  static inline void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu,
>  						  u64 data, u64 select_idx) {}
> +static inline bool kvm_arm_support_pmu_v3(void) { return false; }
>  #endif
>  
>  #endif
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 9da9051..dc16d30 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -850,6 +850,7 @@ struct kvm_ppc_smmu_info {
>  #define KVM_CAP_IOEVENTFD_ANY_LENGTH 122
>  #define KVM_CAP_HYPERV_SYNIC 123
>  #define KVM_CAP_S390_RI 124
> +#define KVM_CAP_ARM_PMU_V3 125
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> index 6b525df..2467d62 100644
> --- a/virt/kvm/arm/pmu.c
> +++ b/virt/kvm/arm/pmu.c
> @@ -384,3 +384,12 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
>  
>  	pmc->perf_event = event;
>  }
> +
> +bool kvm_arm_support_pmu_v3(void)
> +{
> +	/* Check if HW_PERF_EVENTS are supported by checking the number of
> +	 * hardware performance counters. This could ensure physical PMU and
> +	 * PERF_EVENT driver existing.
> +	 */

nit: coding style, opening comment block should be on its own line

I don't understand the last sentence.  Do you mean: "This ensures the
presence of a physical PMU and that CONFIG_PERF_EVENT is selected." ?

Thanks,
-Christoffer
