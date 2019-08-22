Return-Path: <SRS0=16Xb=WS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0B9EC3A59D
	for <kvmarm@archiver.kernel.org>; Thu, 22 Aug 2019 10:57:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 57A46233FD
	for <kvmarm@archiver.kernel.org>; Thu, 22 Aug 2019 10:57:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 57A46233FD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B84084A58C;
	Thu, 22 Aug 2019 06:57:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AgBAnVyjLMcL; Thu, 22 Aug 2019 06:57:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C7F24A596;
	Thu, 22 Aug 2019 06:57:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C13104A58C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Aug 2019 06:57:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RcMarZkdCmyI for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Aug 2019 06:57:42 -0400 (EDT)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 76A114A55B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Aug 2019 06:57:41 -0400 (EDT)
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id DC7189DA9D936A007E2D;
 Thu, 22 Aug 2019 18:57:36 +0800 (CST)
Received: from localhost (10.202.226.61) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Thu, 22 Aug 2019
 18:57:35 +0800
Date: Thu, 22 Aug 2019 11:57:22 +0100
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v3 07/10] KVM: arm64: Provide a PV_TIME device to user
 space
Message-ID: <20190822115722.00005aa7@huawei.com>
In-Reply-To: <20190821153656.33429-8-steven.price@arm.com>
References: <20190821153656.33429-1-steven.price@arm.com>
 <20190821153656.33429-8-steven.price@arm.com>
Organization: Huawei
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; i686-w64-mingw32)
MIME-Version: 1.0
X-Originating-IP: [10.202.226.61]
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Russell
 King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Paolo
 Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Wed, 21 Aug 2019 16:36:53 +0100
Steven Price <steven.price@arm.com> wrote:

> Allow user space to inform the KVM host where in the physical memory
> map the paravirtualized time structures should be located.
> 
> A device is created which provides the base address of an array of
> Stolen Time (ST) structures, one for each VCPU. There must be (64 *
> total number of VCPUs) bytes of memory available at this location.
> 
> The address is given in terms of the physical address visible to
> the guest and must be page aligned. The guest will discover the address
> via a hypercall.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>

Hi Steven,

One general question inline.  I'm not particularly familiar with this area
of the kernel, so maybe I'm missing something obvious, but having
.destroy free the kvm_device which wasn't created in .create seems
'unusual'. 

Otherwise, FWIW looks good to me.

Jonathan

> ---
>  arch/arm/include/asm/kvm_host.h   |  4 ++
>  arch/arm64/include/asm/kvm_host.h |  1 +
>  arch/arm64/include/uapi/asm/kvm.h |  8 +++
>  include/uapi/linux/kvm.h          |  2 +
>  virt/kvm/arm/arm.c                |  1 +
>  virt/kvm/arm/pvtime.c             | 94 +++++++++++++++++++++++++++++++
>  6 files changed, 110 insertions(+)
> 
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index 47d2ced99421..b6c8dbc0556b 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -325,6 +325,10 @@ static inline int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  int kvm_perf_init(void);
>  int kvm_perf_teardown(void);
>  
> +static inline void kvm_pvtime_init(void)
> +{
> +}
> +
>  static inline int kvm_hypercall_pv_features(struct kvm_vcpu *vcpu)
>  {
>  	return SMCCC_RET_NOT_SUPPORTED;
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index b6fa7beffd8a..7b2147f62c16 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -489,6 +489,7 @@ void handle_exit_early(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  int kvm_perf_init(void);
>  int kvm_perf_teardown(void);
>  
> +void kvm_pvtime_init(void);
>  int kvm_hypercall_pv_features(struct kvm_vcpu *vcpu);
>  int kvm_hypercall_stolen_time(struct kvm_vcpu *vcpu);
>  int kvm_update_stolen_time(struct kvm_vcpu *vcpu, bool init);
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 9a507716ae2f..209c4de67306 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -367,6 +367,14 @@ struct kvm_vcpu_events {
>  #define KVM_PSCI_RET_INVAL		PSCI_RET_INVALID_PARAMS
>  #define KVM_PSCI_RET_DENIED		PSCI_RET_DENIED
>  
> +/* Device Control API: PV_TIME */
> +#define KVM_DEV_ARM_PV_TIME_REGION	0
> +#define  KVM_DEV_ARM_PV_TIME_ST		0
> +struct kvm_dev_arm_st_region {
> +	__u64 gpa;
> +	__u64 size;
> +};
> +
>  #endif
>  
>  #endif /* __ARM_KVM_H__ */
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 5e3f12d5359e..265156a984f2 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1222,6 +1222,8 @@ enum kvm_device_type {
>  #define KVM_DEV_TYPE_ARM_VGIC_ITS	KVM_DEV_TYPE_ARM_VGIC_ITS
>  	KVM_DEV_TYPE_XIVE,
>  #define KVM_DEV_TYPE_XIVE		KVM_DEV_TYPE_XIVE
> +	KVM_DEV_TYPE_ARM_PV_TIME,
> +#define KVM_DEV_TYPE_ARM_PV_TIME	KVM_DEV_TYPE_ARM_PV_TIME
>  	KVM_DEV_TYPE_MAX,
>  };
>  
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 5e8343e2dd62..bfb5a842e6ab 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -1494,6 +1494,7 @@ static int init_subsystems(void)
>  
>  	kvm_perf_init();
>  	kvm_coproc_table_init();
> +	kvm_pvtime_init();
>  
>  out:
>  	on_each_cpu(_kvm_arch_hardware_disable, NULL, 1);
> diff --git a/virt/kvm/arm/pvtime.c b/virt/kvm/arm/pvtime.c
> index 28603689f6e0..3e55c1fb6a49 100644
> --- a/virt/kvm/arm/pvtime.c
> +++ b/virt/kvm/arm/pvtime.c
> @@ -2,7 +2,9 @@
>  // Copyright (C) 2019 Arm Ltd.
>  
>  #include <linux/arm-smccc.h>
> +#include <linux/kvm_host.h>
>  
> +#include <asm/kvm_mmu.h>
>  #include <asm/pvclock-abi.h>
>  
>  #include <kvm/arm_hypercalls.h>
> @@ -86,3 +88,95 @@ int kvm_hypercall_stolen_time(struct kvm_vcpu *vcpu)
>  
>  	return ret;
>  }
> +
> +static int kvm_arm_pvtime_create(struct kvm_device *dev, u32 type)
> +{
> +	return 0;
> +}
> +
> +static void kvm_arm_pvtime_destroy(struct kvm_device *dev)
> +{
> +	struct kvm_arch_pvtime *pvtime = &dev->kvm->arch.pvtime;
> +
> +	pvtime->st_base = GPA_INVALID;
> +	kfree(dev);

Nothing to do with your patch as such... All users do the same.

This seems miss balanced. Why do we need to free the device by hand
when we didn't create it in the create function?  I appreciate
the comments say this is needed, but as far as I can see every
single callback does kfree(dev) at the end which seems an
odd thing to do.

> +}
> +
> +static int kvm_arm_pvtime_set_attr(struct kvm_device *dev,
> +				   struct kvm_device_attr *attr)
> +{
> +	struct kvm *kvm = dev->kvm;
> +	struct kvm_arch_pvtime *pvtime = &kvm->arch.pvtime;
> +	u64 __user *user = (u64 __user *)attr->addr;
> +	struct kvm_dev_arm_st_region region;
> +
> +	switch (attr->group) {
> +	case KVM_DEV_ARM_PV_TIME_REGION:
> +		if (copy_from_user(&region, user, sizeof(region)))
> +			return -EFAULT;
> +		if (region.gpa & ~PAGE_MASK)
> +			return -EINVAL;
> +		if (region.size & ~PAGE_MASK)
> +			return -EINVAL;
> +		switch (attr->attr) {
> +		case KVM_DEV_ARM_PV_TIME_ST:
> +			if (pvtime->st_base != GPA_INVALID)
> +				return -EEXIST;
> +			pvtime->st_base = region.gpa;
> +			pvtime->st_size = region.size;
> +			return 0;
> +		}
> +		break;
> +	}
> +	return -ENXIO;
> +}
> +
> +static int kvm_arm_pvtime_get_attr(struct kvm_device *dev,
> +				   struct kvm_device_attr *attr)
> +{
> +	struct kvm_arch_pvtime *pvtime = &dev->kvm->arch.pvtime;
> +	u64 __user *user = (u64 __user *)attr->addr;
> +	struct kvm_dev_arm_st_region region;
> +
> +	switch (attr->group) {
> +	case KVM_DEV_ARM_PV_TIME_REGION:
> +		switch (attr->attr) {
> +		case KVM_DEV_ARM_PV_TIME_ST:
> +			region.gpa = pvtime->st_base;
> +			region.size = pvtime->st_size;
> +			if (copy_to_user(user, &region, sizeof(region)))
> +				return -EFAULT;
> +			return 0;
> +		}
> +		break;
> +	}
> +	return -ENXIO;
> +}
> +
> +static int kvm_arm_pvtime_has_attr(struct kvm_device *dev,
> +				   struct kvm_device_attr *attr)
> +{
> +	switch (attr->group) {
> +	case KVM_DEV_ARM_PV_TIME_REGION:
> +		switch (attr->attr) {
> +		case KVM_DEV_ARM_PV_TIME_ST:
> +			return 0;
> +		}
> +		break;
> +	}
> +	return -ENXIO;
> +}
> +
> +static const struct kvm_device_ops pvtime_ops = {
> +	"Arm PV time",
> +	.create = kvm_arm_pvtime_create,
> +	.destroy = kvm_arm_pvtime_destroy,
> +	.set_attr = kvm_arm_pvtime_set_attr,
> +	.get_attr = kvm_arm_pvtime_get_attr,
> +	.has_attr = kvm_arm_pvtime_has_attr
> +};
> +
> +void kvm_pvtime_init(void)
> +{
> +	kvm_register_device_ops(&pvtime_ops, KVM_DEV_TYPE_ARM_PV_TIME);
> +}


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
