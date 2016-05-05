From: Tom Hanson <thomas.hanson@linaro.org>
Subject: Re: [PATCH v2 18/54] KVM: arm/arm64: vgic-new: Add GICv3 world switch
 backend
Date: Thu, 5 May 2016 11:04:01 -0600
Message-ID: <572B7D01.50202@linaro.org>
References: <1461861973-26464-1-git-send-email-andre.przywara@arm.com>
 <1461861973-26464-19-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 66B0149B6F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 May 2016 13:01:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a8+mUMB6bENp for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 May 2016 13:01:28 -0400 (EDT)
Received: from mail-pa0-f52.google.com (mail-pa0-f52.google.com
 [209.85.220.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0134E49B42
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 May 2016 13:01:27 -0400 (EDT)
Received: by mail-pa0-f52.google.com with SMTP id xk12so38164794pac.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 05 May 2016 10:04:09 -0700 (PDT)
In-Reply-To: <1461861973-26464-19-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 04/28/2016 10:45 AM, Andre Przywara wrote:

...

> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> new file mode 100644
> index 0000000..461229b
> --- /dev/null
> +++ b/virt/kvm/arm/vgic/vgic-v3.c

...

> +void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
> +{
> + struct vgic_v3_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v3;
> + u32 model = vcpu->kvm->arch.vgic.vgic_model;
> + int lr;
> +
> + /* Assumes ap_list_lock held */

If truly required that ap_list_lock already be locked, then the code should enforce it. At least in dev mode. Maybe:
         DEBUG_SPINLOCK_BUG_ON(!spin_is_locked(&vcpu->ap_list_lock));

...

> +/* Requires the irq to be locked already */
> +void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
> +{
> +	u32 model = vcpu->kvm->arch.vgic.vgic_model;
> +	u64 val = irq->intid;
> +

Similarly, if required then the code should enforce it.
         DEBUG_SPINLOCK_BUG_ON(!spin_is_locked(&irq->irq_lock));

...
