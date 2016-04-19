From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH 28/45] KVM: arm/arm64: vgic-new: Add GICv3 SGI system
 register trap handler
Date: Tue, 19 Apr 2016 13:40:35 +0100
Message-ID: <CAFEAcA83Mbpjh6oq7YS0+NbeJerVLukq0mN+9rfKODFUPt0g0A@mail.gmail.com>
References: <1460740316-8755-1-git-send-email-andre.przywara@arm.com>
 <1460740316-8755-29-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 52B8649B8C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2016 08:38:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0RPXvzZlpxBf for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Apr 2016 08:38:58 -0400 (EDT)
Received: from mail-vk0-f43.google.com (mail-vk0-f43.google.com
 [209.85.213.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 47ED349B86
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2016 08:38:58 -0400 (EDT)
Received: by mail-vk0-f43.google.com with SMTP id n67so14866088vkf.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2016 05:40:55 -0700 (PDT)
In-Reply-To: <1460740316-8755-29-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm-devel <kvm@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 15 April 2016 at 18:11, Andre Przywara <andre.przywara@arm.com> wrote:
> In contrast to GICv2 SGIs in a GICv3 implementation are not triggered
> by a MMIO write, but with a system register write. KVM knows about
> that register already, we just need to implement the handler and wire
> it up to the core KVM/ARM code.
>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>
> Changelog RFC..v1:
> - add comment about SGI_AFFINITY_LEVEL macro

> +/**
> + * vgic_v3_dispatch_sgi - handle SGI requests from VCPUs
> + * @vcpu: The VCPU requesting a SGI
> + * @reg: The value written into the ICC_SGI1R_EL1 register by that VCPU
> + *
> + * With GICv3 (and ARE=1) CPUs trigger SGIs by writing to a system register.
> + * This will trap in sys_regs.c and call this function.
> + * This ICC_SGI1R_EL1 register contains the upper three affinity levels of the
> + * target processors as well as a bitmask of 16 Aff0 CPUs.
> + * If the interrupt routing mode bit is not set, we iterate over all VCPUs to
> + * check for matching ones. If this bit is set, we signal all, but not the
> + * calling VCPU.
> + */

No ICC_SGI0R_EL1, ICC_ASGI1R_EL1 ?

> +void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg)
> +{
> +       struct kvm *kvm = vcpu->kvm;
> +       struct kvm_vcpu *c_vcpu;
> +       u16 target_cpus;
> +       u64 mpidr;
> +       int sgi, c;
> +       int vcpu_id = vcpu->vcpu_id;
> +       bool broadcast;
> +
> +       sgi = (reg & ICC_SGI1R_SGI_ID_MASK) >> ICC_SGI1R_SGI_ID_SHIFT;
> +       broadcast = reg & BIT(ICC_SGI1R_IRQ_ROUTING_MODE_BIT);
> +       target_cpus = (reg & ICC_SGI1R_TARGET_LIST_MASK) >> ICC_SGI1R_TARGET_LIST_SHIFT;
> +       mpidr = SGI_AFFINITY_LEVEL(reg, 3);
> +       mpidr |= SGI_AFFINITY_LEVEL(reg, 2);
> +       mpidr |= SGI_AFFINITY_LEVEL(reg, 1);
> +
> +       /*
> +        * We iterate over all VCPUs to find the MPIDRs matching the request.
> +        * If we have handled one CPU, we clear its bit to detect early
> +        * if we are already finished. This avoids iterating through all
> +        * VCPUs when most of the times we just signal a single VCPU.
> +        */
> +       kvm_for_each_vcpu(c, c_vcpu, kvm) {
> +               struct vgic_irq *irq;
> +
> +               /* Exit early if we have dealt with all requested CPUs */
> +               if (!broadcast && target_cpus == 0)
> +                       break;
> +
> +               /* Don't signal the calling VCPU */
> +               if (broadcast && c == vcpu_id)
> +                       continue;
> +
> +               if (!broadcast) {
> +                       int level0;
> +
> +                       level0 = match_mpidr(mpidr, target_cpus, c_vcpu);
> +                       if (level0 == -1)
> +                               continue;
> +
> +                       /* remove this matching VCPU from the mask */
> +                       target_cpus &= ~BIT(level0);
> +               }

I think you need a check in here that the SGI is actually configured
to be the group that's been requested.

> +
> +               irq = vgic_get_irq(vcpu->kvm, c_vcpu, sgi);
> +
> +               spin_lock(&irq->irq_lock);
> +               irq->pending = true;
> +
> +               vgic_queue_irq_unlock(vcpu->kvm, irq);
> +       }
> +}
>  #endif
> --
> 2.7.3

thanks
-- PMM
