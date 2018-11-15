From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH]  kvm: arm/arm64 : fix vm's hanging at startup time
Date: Thu, 15 Nov 2018 14:39:06 +0000
Message-ID: <20181115143906.5c2302d5@donnerap.cambridge.arm.com>
References: <1542294848-73839-1-git-send-email-peng.hao2@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1542294848-73839-1-git-send-email-peng.hao2@zte.com.cn>
Sender: linux-kernel-owner@vger.kernel.org
To: Peng Hao <peng.hao2@zte.com.cn>
Cc: christoffer.dall@arm.com, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, 15 Nov 2018 23:14:08 +0800
Peng Hao <peng.hao2@zte.com.cn> wrote:

Hi,

> When virtual machine starts, hang up.

I take it you mean the *guest* hangs? Because it doesn't get a timer
interrupt?

> The kernel version of guest
> is 4.16. Host support vgic_v3.

Your host kernel is something recent, I guess?

> It was mainly due to the incorrect vgic_irq's(intid=27) group value
> during injection interruption. when kvm_vgic_vcpu_init is called,
> dist is not initialized at this time. Unable to get vgic V3 or V2
> correctly, so group is not set.

Mmh, that shouldn't happen with (v)GICv3. Do you use QEMU (which
version?) or some other userland tool?

> group is setted to 1 when vgic_mmio_write_group is invoked at some
> time.
> when irq->group=0 (intid=27), No ICH_LR_GROUP flag was set and
> interrupt injection failed.
> 
> Signed-off-by: Peng Hao <peng.hao2@zte.com.cn>
> ---
>  virt/kvm/arm/vgic/vgic-v3.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> index 9c0dd23..d101000 100644
> --- a/virt/kvm/arm/vgic/vgic-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> @@ -198,7 +198,7 @@ void vgic_v3_populate_lr(struct kvm_vcpu *vcpu,
> struct vgic_irq *irq, int lr) if (vgic_irq_is_mapped_level(irq) &&
> (val & ICH_LR_PENDING_BIT)) irq->line_level = false;
>  
> -	if (irq->group)
> +	if (model == KVM_DEV_TYPE_ARM_VGIC_V3)

This is not the right fix, not only because it basically reverts the
GICv3 part of 87322099052 (KVM: arm/arm64: vgic: Signal IRQs using
their configured group).

Can you try to work out why kvm_vgic_vcpu_init() is apparently called
before dist->vgic_model is set, also what value it has?
If I understand the code correctly, that shouldn't happen for a GICv3.

Cheers,
Andre.

>  		val |= ICH_LR_GROUP;
>  
>  	val |= (u64)irq->priority << ICH_LR_PRIORITY_SHIFT;
