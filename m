From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v11 20/21] KVM: ARM: Introduce per-vcpu kvm device
 controls
Date: Mon, 8 Feb 2016 13:40:59 +0100
Message-ID: <20160208124059.GF620@cbox>
References: <1454656456-11640-1-git-send-email-zhaoshenglong@huawei.com>
 <1454656456-11640-21-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1454656456-11640-21-git-send-email-zhaoshenglong@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com, Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Feb 05, 2016 at 03:14:15PM +0800, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> In some cases it needs to get/set attributes specific to a vcpu and so
> needs something else than ONE_REG.
> 
> Let's copy the KVM_DEVICE approach, and define the respective ioctls
> for the vcpu file descriptor.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> Acked-by: Peter Maydell <peter.maydell@linaro.org>
> ---
> CC: Peter Maydell <peter.maydell@linaro.org>

strange cc section here?
> ---
>  Documentation/virtual/kvm/api.txt          | 10 +++---
>  Documentation/virtual/kvm/devices/vcpu.txt |  8 +++++
>  arch/arm/kvm/arm.c                         | 55 ++++++++++++++++++++++++++++++
>  arch/arm64/kvm/reset.c                     |  1 +
>  include/uapi/linux/kvm.h                   |  1 +
>  5 files changed, 71 insertions(+), 4 deletions(-)
>  create mode 100644 Documentation/virtual/kvm/devices/vcpu.txt
> 
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index 9684f8d..cb2ef0b 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -2507,8 +2507,9 @@ struct kvm_create_device {
>  
>  4.80 KVM_SET_DEVICE_ATTR/KVM_GET_DEVICE_ATTR
>  
> -Capability: KVM_CAP_DEVICE_CTRL, KVM_CAP_VM_ATTRIBUTES for vm device
> -Type: device ioctl, vm ioctl
> +Capability: KVM_CAP_DEVICE_CTRL, KVM_CAP_VM_ATTRIBUTES for vm device,
> +  KVM_CAP_VCPU_ATTRIBUTES for vcpu device
> +Type: device ioctl, vm ioctl, vcpu ioctl
>  Parameters: struct kvm_device_attr
>  Returns: 0 on success, -1 on error
>  Errors:
> @@ -2533,8 +2534,9 @@ struct kvm_device_attr {
>  
>  4.81 KVM_HAS_DEVICE_ATTR
>  
> -Capability: KVM_CAP_DEVICE_CTRL, KVM_CAP_VM_ATTRIBUTES for vm device
> -Type: device ioctl, vm ioctl
> +Capability: KVM_CAP_DEVICE_CTRL, KVM_CAP_VM_ATTRIBUTES for vm device,
> +  KVM_CAP_VCPU_ATTRIBUTES for vcpu device
> +Type: device ioctl, vm ioctl, vcpu ioctl
>  Parameters: struct kvm_device_attr
>  Returns: 0 on success, -1 on error
>  Errors:
> diff --git a/Documentation/virtual/kvm/devices/vcpu.txt b/Documentation/virtual/kvm/devices/vcpu.txt
> new file mode 100644
> index 0000000..3cc59c5
> --- /dev/null
> +++ b/Documentation/virtual/kvm/devices/vcpu.txt
> @@ -0,0 +1,8 @@
> +Generic vcpu interface
> +====================================
> +
> +The virtual cpu "device" also accepts the ioctls KVM_SET_DEVICE_ATTR,
> +KVM_GET_DEVICE_ATTR, and KVM_HAS_DEVICE_ATTR. The interface uses the same struct
> +kvm_device_attr as other devices, but targets VCPU-wide settings and controls.
> +
> +The groups and attributes per virtual cpu, if any, are architecture specific.
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index d2c2cc3..34d7395 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -826,11 +826,51 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
>  	return 0;
>  }
>  
> +static int kvm_arm_vcpu_set_attr(struct kvm_vcpu *vcpu,
> +				 struct kvm_device_attr *attr)
> +{
> +	int ret = -ENXIO;
> +
> +	switch (attr->group) {
> +	default:
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
> +static int kvm_arm_vcpu_get_attr(struct kvm_vcpu *vcpu,
> +				 struct kvm_device_attr *attr)
> +{
> +	int ret = -ENXIO;
> +
> +	switch (attr->group) {
> +	default:
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
> +static int kvm_arm_vcpu_has_attr(struct kvm_vcpu *vcpu,
> +				 struct kvm_device_attr *attr)
> +{
> +	int ret = -ENXIO;
> +
> +	switch (attr->group) {
> +	default:
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
>  long kvm_arch_vcpu_ioctl(struct file *filp,
>  			 unsigned int ioctl, unsigned long arg)
>  {
>  	struct kvm_vcpu *vcpu = filp->private_data;
>  	void __user *argp = (void __user *)arg;
> +	struct kvm_device_attr attr;
>  
>  	switch (ioctl) {
>  	case KVM_ARM_VCPU_INIT: {
> @@ -873,6 +913,21 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  			return -E2BIG;
>  		return kvm_arm_copy_reg_indices(vcpu, user_list->reg);
>  	}
> +	case KVM_SET_DEVICE_ATTR: {
> +		if (copy_from_user(&attr, argp, sizeof(attr)))
> +			return -EFAULT;
> +		return kvm_arm_vcpu_set_attr(vcpu, &attr);
> +	}
> +	case KVM_GET_DEVICE_ATTR: {
> +		if (copy_from_user(&attr, argp, sizeof(attr)))
> +			return -EFAULT;
> +		return kvm_arm_vcpu_get_attr(vcpu, &attr);
> +	}
> +	case KVM_HAS_DEVICE_ATTR: {
> +		if (copy_from_user(&attr, argp, sizeof(attr)))
> +			return -EFAULT;
> +		return kvm_arm_vcpu_has_attr(vcpu, &attr);
> +	}

do we share the ioctl number space across device, VM, and VCPU file
descriptors?  If not, don't these need to be specifically defined as
VCPU ioctl numbers in kvm.h ?

Thanks,
-Christoffer

>  	default:
>  		return -EINVAL;
>  	}
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index cf4f28a..9677bf0 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -81,6 +81,7 @@ int kvm_arch_dev_ioctl_check_extension(long ext)
>  		r = kvm_arm_support_pmu_v3();
>  		break;
>  	case KVM_CAP_SET_GUEST_DEBUG:
> +	case KVM_CAP_VCPU_ATTRIBUTES:
>  		r = 1;
>  		break;
>  	default:
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index dc16d30..50f44a2 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -851,6 +851,7 @@ struct kvm_ppc_smmu_info {
>  #define KVM_CAP_HYPERV_SYNIC 123
>  #define KVM_CAP_S390_RI 124
>  #define KVM_CAP_ARM_PMU_V3 125
> +#define KVM_CAP_VCPU_ATTRIBUTES 126
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> -- 
> 2.0.4
> 
> 
