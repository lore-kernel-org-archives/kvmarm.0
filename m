From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v11 1/4] arm64: KVM: export the capability to set guest
 SError syndrome
Date: Tue, 10 Apr 2018 15:15:55 +0100
Message-ID: <98360e36-5fb7-aea4-52c3-21595d09419f@arm.com>
References: <1523309796-36423-1-git-send-email-gengdongjiu@huawei.com>
 <1523309796-36423-2-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1523309796-36423-2-git-send-email-gengdongjiu@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Dongjiu Geng <gengdongjiu@huawei.com>
Cc: rkrcmar@redhat.com, corbet@lwn.net, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux@armlinux.org.uk, catalin.marinas@arm.com, rjw@rjwysocki.net, bp@alien8.de, lenb@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-acpi@vger.kernel.org, devel@acpica.org, huangshaoyu@huawei.com, zhengxiang9@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Dongjiu Geng,

On 09/04/18 22:36, Dongjiu Geng wrote:
> Before user space injects a SError, it needs to know whether it can
> specify the guest Exception Syndrome, so KVM should tell user space
> whether it has such capability.

(you could improve the commit message by briefly explaining how/why user-space
would want to do this. As this is patch 1, you don't have the context of the
previous patch to say that some systems can provide an ESR with virtual-SError)


> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index fc3ae95..8a3d708 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -4415,3 +4415,14 @@ Parameters: none
>  This capability indicates if the flic device will be able to get/set the
>  AIS states for migration via the KVM_DEV_FLIC_AISM_ALL attribute and allows
>  to discover this without having to create a flic device.
> +
> +8.14 KVM_CAP_ARM_SET_SERROR_ESR
> +
> +Architectures: arm, arm64
> +
> +This capability indicates that userspace can specify syndrome value reported to

(Nit: 'the syndrome value')

> +guest OS when guest takes a virtual SError interrupt exception.

(Nit: 'the guest')

> +If KVM has this capability, userspace can only specify the ISS field for the ESR
> +syndrome, can not specify the EC field which is not under control by KVM.

(Nit: 'it can not specify...')

> +If this virtual SError is taken to EL1 using AArch64, this value will be reported
> +into ISS filed of ESR_EL1.

(Nit: 'in the ISS field')


> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 3256b92..38c8a64 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -77,6 +77,9 @@ int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_ARM_PMU_V3:
>  		r = kvm_arm_support_pmu_v3();
>  		break;
> +	case KVM_CAP_ARM_INJECT_SERROR_ESR:
> +		r = cpus_have_const_cap(ARM64_HAS_RAS_EXTN);
> +		break;
>  	case KVM_CAP_SET_GUEST_DEBUG:
>  	case KVM_CAP_VCPU_ATTRIBUTES:
>  		r = 1;

'dev_ioctl' feels a bit weird, but we already have cpu_has_32bit_el1() in here.


> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 8fb90a0..3587b33 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -934,6 +934,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_S390_AIS_MIGRATION 150
>  #define KVM_CAP_PPC_GET_CPU_CHAR 151
>  #define KVM_CAP_S390_BPB 152
> +#define KVM_CAP_ARM_INJECT_SERROR_ESR 153
>  
>  #ifdef KVM_CAP_IRQ_ROUTING

(patch 1&2 should probably be swapped around, as on its own this does thing).

Reviewed-by: James Morse <james.morse@arm.com>


Thanks,

James
