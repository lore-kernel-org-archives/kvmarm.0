From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [RFC PATCH 2/3] kvm: arm/arm64: vgic-vits: free its resource
 when vm reboot/reset
Date: Wed, 13 Sep 2017 12:34:45 -0700
Message-ID: <20170913193445.GJ1631@lvm>
References: <1504703110-10744-1-git-send-email-wanghaibin.wang@huawei.com>
 <1504703110-10744-3-git-send-email-wanghaibin.wang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A599340FB0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Sep 2017 15:32:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lRJRIEurZGlT for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Sep 2017 15:32:07 -0400 (EDT)
Received: from mail-pf0-f175.google.com (mail-pf0-f175.google.com
 [209.85.192.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 79B4240A86
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Sep 2017 15:32:07 -0400 (EDT)
Received: by mail-pf0-f175.google.com with SMTP id q76so1715524pfq.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Sep 2017 12:34:47 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1504703110-10744-3-git-send-email-wanghaibin.wang@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: wanghaibin <wanghaibin.wang@huawei.com>
Cc: marc.zyngier@arm.com, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, wu.wubin@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Wanghaibin,

On Wed, Sep 06, 2017 at 09:05:09PM +0800, wanghaibin wrote:
> This patch fix the migrate save tables failure.
> 
> When the virtual machine is in booting and the devices haven't initialized,
> the all virtual dte/ite may be invalid. If migrate at this moment, the save
> tables interface traversal device list, and check the dte is valid or not.
> if not, it will return the -EINVAL.
> 
> This patch try to free the its list resource when vm reboot or reset to avoid this.

I think the problem should be described the following way (feel free to
use this in a commit message).

When rebooting a VM, we currently don't have a way to reset the ITS.
This results in the booting a VM with a pre-programmed ITS with existing
cached state.  This can lead to all sorts of interesting problems.

One such problem is that if trying to migrate the VM after rebooting the
VM, we try to traverse the device tables in guest memory.  When using
indirect tables, and the guest has re-initialized the ITS device table
base register pointing to cleared memory, this results in trying to
access address 0 in the guest physical address space, which in turn
causes the ITS saving code to return an error to user space.

The correct fix is to introduce a reset function as a device attribute
for the ITS.

Hope this helps,
-Christoffer

> 
> Signed-off-by: wanghaibin <wanghaibin.wang@huawei.com>
> ---
>  virt/kvm/arm/arm.c           |  5 ++++-
>  virt/kvm/arm/vgic/vgic-its.c | 10 ++++++++++
>  virt/kvm/arm/vgic/vgic.h     |  1 +
>  3 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index a39a1e1..db7632d 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -46,6 +46,7 @@
>  #include <asm/kvm_coproc.h>
>  #include <asm/kvm_psci.h>
>  #include <asm/sections.h>
> +#include "vgic.h"
>  
>  #ifdef REQUIRES_VIRT
>  __asm__(".arch_extension	virt");
> @@ -901,8 +902,10 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
>  	 * Ensure a rebooted VM will fault in RAM pages and detect if the
>  	 * guest MMU is turned off and flush the caches as needed.
>  	 */
> -	if (vcpu->arch.has_run_once)
> +	if (vcpu->arch.has_run_once) {
>  		stage2_unmap_vm(vcpu->kvm);
> +		vgic_its_free_resource(vcpu->kvm);
> +	}
>  
>  	vcpu_reset_hcr(vcpu);
>  
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 25d614f..5c20352 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -2467,6 +2467,16 @@ static int vgic_its_get_attr(struct kvm_device *dev,
>  	.has_attr = vgic_its_has_attr,
>  };
>  
> +void vgic_its_free_resource(struct kvm *kvm)
> +{
> +	struct kvm_device *dev, *tmp;
> +
> +	list_for_each_entry_safe(dev, tmp, &kvm->devices, vm_node) {
> +		if(dev->ops == &kvm_arm_vgic_its_ops)
> +			vgic_its_free_list(kvm, dev->private);
> +	}
> +}
> +
>  int kvm_vgic_register_its_device(void)
>  {
>  	return kvm_register_device_ops(&kvm_arm_vgic_its_ops,
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index c2be5b7..fbcbdfd 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -222,5 +222,6 @@ int vgic_v3_line_level_info_uaccess(struct kvm_vcpu *vcpu, bool is_write,
>  
>  bool lock_all_vcpus(struct kvm *kvm);
>  void unlock_all_vcpus(struct kvm *kvm);
> +void vgic_its_free_resource(struct kvm *kvm);
>  
>  #endif
> -- 
> 1.8.3.1
> 
> 
