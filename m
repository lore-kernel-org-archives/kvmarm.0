From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH 2/2] arm/arm64: KVM: share the check for vcpu events
 capability
Date: Thu, 27 Sep 2018 15:01:35 +0000
Message-ID: <0184EA26B2509940AA629AE1405DD7F201E9CD77@dggema523-mbx.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: zh-CN
Sender: linux-kernel-owner@vger.kernel.org
To: "christoffer.dall@arm.com" <christoffer.dall@arm.com>, "marc.zyngier@arm.com" <marc.zyngier@arm.com>, "james.morse@arm.com" <james.morse@arm.com>, "drjones@redhat.com" <drjones@redhat.com>, "peter.maydell@linaro.org" <peter.maydell@linaro.org>, "linux@armlinux.org.uk" <linux@armlinux.org.uk>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will.deacon@arm.com" <will.deacon@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi christoffer/marc,
   Could you review this simple patch to enable the 32 bit KVM vcpu event supports?  Because below user space patch depended on it. thanks
   https://patchwork.kernel.org/patch/10617601/


> subject: [PATCH 2/2] arm/arm64: KVM: share the check for vcpu events capability
> 
> The commit 539aee0edb9f ("KVM: arm64: Share the parts of get/set events useful to 32bit") shares the get/set events helper for arm64
> and arm32, it is better also share the check for vcpu events capability.
> 
> User space will check whether KVM supports vcpu events through KVM_CAP_VCPU_EVENTS IOCTL.
> 
> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> ---
> For the 32 bit guest migration, it needs to enable the vcpu events
> 
> ---
>  arch/arm64/kvm/reset.c | 1 -
>  virt/kvm/arm/arm.c     | 1 +
>  2 files changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c index fd37c53..e50245e 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -82,7 +82,6 @@ int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  		break;
>  	case KVM_CAP_SET_GUEST_DEBUG:
>  	case KVM_CAP_VCPU_ATTRIBUTES:
> -	case KVM_CAP_VCPU_EVENTS:
>  		r = 1;
>  		break;
>  	default:
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c index 40e79ea..64e5d97 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -212,6 +212,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_READONLY_MEM:
>  	case KVM_CAP_MP_STATE:
>  	case KVM_CAP_IMMEDIATE_EXIT:
> +	case KVM_CAP_VCPU_EVENTS:
>  		r = 1;
>  		break;
>  	case KVM_CAP_ARM_SET_DEVICE_ADDR:
> --
> 1.9.1
> 
