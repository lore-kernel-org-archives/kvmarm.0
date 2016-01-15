From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v9 19/21] KVM: ARM64: Add a new feature bit for PMUv3
Date: Fri, 15 Jan 2016 12:08:16 +0100
Message-ID: <20160115110816.GE3915@hawk.localdomain>
References: <1452839275-19368-1-git-send-email-zhaoshenglong@huawei.com>
 <1452839275-19368-20-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1452839275-19368-20-git-send-email-zhaoshenglong@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com, Peter Maydell <peter.maydell@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jan 15, 2016 at 02:27:53PM +0800, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> To support guest PMUv3, use one bit of the VCPU INIT feature array.
> Initialize the PMU when initialzing the vcpu with that bit and PMU
> overflow interrupt set.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
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
> index 053f613..e51fa04 100644
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
> index d90fc65..c35b11d 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -48,6 +48,7 @@ void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val);
>  void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val);
>  void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
>  				    u64 select_idx);
> +int kvm_arm_support_pmu_v3(void);
>  #else
>  struct kvm_pmu {
>  };
> @@ -72,6 +73,7 @@ static inline void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val) {}
>  static inline void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val) {}
>  static inline void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu,
>  						  u64 data, u64 select_idx) {}
> +static inline int kvm_arm_support_pmu_v3(void) { return 0; }
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
> index 45d4d91..cb373d4 100644
> --- a/virt/kvm/arm/pmu.c
> +++ b/virt/kvm/arm/pmu.c
> @@ -374,3 +374,12 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
>  
>  	pmc->perf_event = event;
>  }
> +
> +int kvm_arm_support_pmu_v3(void)
> +{
> +	/* Check if HW_PERF_EVENTS are supported by checking the number of
> +	 * hardware performance counters. This could ensure physical PMU and
> +	 * PERF_EVENT driver existing.
> +	 */
> +	return perf_num_counters();

This returns the number of counters, but the CAP name and function name imply
a true/false response. Is it useful to userspace to return the number of
counters? Or should this just be a bool function and instead return
perf_num_counters() != 0

drew
