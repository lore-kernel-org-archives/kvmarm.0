From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: Fix bug in advertising KVM_CAP_MSI_DEVID
 capability
Date: Tue, 11 Jul 2017 17:35:25 +0100
Message-ID: <f5342680-2085-1e3a-d9c4-fe1c63dd07fd@arm.com>
References: <1499521710-27494-1-git-send-email-shankerd@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 77F2940FA2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jul 2017 12:34:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rPtgcwz9z3nC for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Jul 2017 12:34:54 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A44240D1A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jul 2017 12:34:54 -0400 (EDT)
In-Reply-To: <1499521710-27494-1-git-send-email-shankerd@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shanker Donthineni <shankerd@codeaurora.org>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm <kvm@vger.kernel.org>, Andre Przywara <andre.przywara@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, kvmarm <kvmarm@lists.cs.columbia.edu>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 08/07/17 14:48, Shanker Donthineni wrote:
> Commit 0e4e82f154e3 ("KVM: arm64: vgic-its: Enable ITS emulation as
> a virtual MSI controller") tried to advertise KVM_CAP_MSI_DEVID, but
> the code logic was not updating the dist->msis_require_devid field
> correctly. If hypervisor tool creates the ITS device after VGIC
> initialization then we don't advertise KVM_CAP_MSI_DEVID capability.
> 
> Update the field msis_require_devid to true inside vgic_its_create()
> to fix the issue.
> 
> Fixes: 0e4e82f154e3 ("vgic-its: Enable ITS emulation as a virtual MSI controller")
> Signed-off-by: Shanker Donthineni <shankerd@codeaurora.org>
> ---
>  virt/kvm/arm/vgic/vgic-init.c | 3 ---
>  virt/kvm/arm/vgic/vgic-its.c  | 1 +
>  2 files changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
> index 3a0b899..5801261 100644
> --- a/virt/kvm/arm/vgic/vgic-init.c
> +++ b/virt/kvm/arm/vgic/vgic-init.c
> @@ -285,9 +285,6 @@ int vgic_init(struct kvm *kvm)
>  	if (ret)
>  		goto out;
>  
> -	if (vgic_has_its(kvm))
> -		dist->msis_require_devid = true;
> -
>  	kvm_for_each_vcpu(i, vcpu, kvm)
>  		kvm_vgic_vcpu_enable(vcpu);
>  
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 2dff288..aa6b68d 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -1598,6 +1598,7 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
>  	INIT_LIST_HEAD(&its->device_list);
>  	INIT_LIST_HEAD(&its->collection_list);
>  
> +	dev->kvm->arch.vgic.msis_require_devid = true;
>  	dev->kvm->arch.vgic.has_its = true;
>  	its->enabled = false;
>  	its->dev = dev;
> 

Seems sensible to me. Unless someone screams, I'll queue it for post -rc1.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
