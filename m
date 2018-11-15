From: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH] kvm: arm/arm64 : fix vm's hanging at startup time
Date: Thu, 15 Nov 2018 09:42:55 +0000
Message-ID: <63a0ea72-e0ce-b3e4-4fda-f1a359754cc5@arm.com>
References: <1542294848-73839-1-git-send-email-peng.hao2@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1542294848-73839-1-git-send-email-peng.hao2@zte.com.cn>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Peng Hao <peng.hao2@zte.com.cn>, christoffer.dall@arm.com, marc.zyngier@arm.com
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Peng,

On 15/11/18 15:14, Peng Hao wrote:
> When virtual machine starts, hang up. The kernel version of guest
> is 4.16. Host support vgic_v3.

I don't understand the issue here. the vgic_irq->group field does not 
exist in 4.16 (neither in the first nor the last version). Nor does the 
line you are modifying.

Both exist in mainline, but what you are mentioning shouldn't be an 
issue in mainline since vgic_irq->group gets initialized in 
kvm_vgic_vcpu_init for SGIs and PPIs (i.e. intid < 32) which includes 
your interrupt.

Cheers,

> It was mainly due to the incorrect vgic_irq's(intid=27) group value
> during injection interruption. when kvm_vgic_vcpu_init is called,
> dist is not initialized at this time. Unable to get vgic V3 or V2
> correctly, so group is not set.
> group is setted to 1 when vgic_mmio_write_group is invoked at some
> time.
> when irq->group=0 (intid=27), No ICH_LR_GROUP flag was set and
> interrupt injection failed.
> 
> Signed-off-by: Peng Hao <peng.hao2@zte.com.cn>
> ---
>   virt/kvm/arm/vgic/vgic-v3.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> index 9c0dd23..d101000 100644
> --- a/virt/kvm/arm/vgic/vgic-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> @@ -198,7 +198,7 @@ void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
>   	if (vgic_irq_is_mapped_level(irq) && (val & ICH_LR_PENDING_BIT))
>   		irq->line_level = false;
>   
> -	if (irq->group)
> +	if (model == KVM_DEV_TYPE_ARM_VGIC_V3)
>   		val |= ICH_LR_GROUP;
>   
>   	val |= (u64)irq->priority << ICH_LR_PRIORITY_SHIFT;
> 

-- 
Julien Thierry
