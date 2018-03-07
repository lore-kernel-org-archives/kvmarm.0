From: Christoffer Dall <cdall@kernel.org>
Subject: Re: [PATCH 1/2] KVM: arm/arm64: vgic: Don't populate multiple LRs
 with the same vintid
Date: Wed, 7 Mar 2018 23:34:17 +0000
Message-ID: <CAEDV+gJoamQJX_hcwCNBo1gc7-NUT+m-N9n=00wCJ=_TD82EkQ@mail.gmail.com>
References: <20180307124055.13800-1-marc.zyngier@arm.com>
 <20180307124055.13800-2-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6138D401AB
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Mar 2018 18:27:25 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QV-EB4omdiGo for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Mar 2018 18:27:03 -0500 (EST)
Received: from mail-lf0-f65.google.com (mail-lf0-f65.google.com
 [209.85.215.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A6E7E4017F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Mar 2018 18:27:03 -0500 (EST)
Received: by mail-lf0-f65.google.com with SMTP id 37-v6so5764001lfs.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 07 Mar 2018 15:34:19 -0800 (PST)
In-Reply-To: <20180307124055.13800-2-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Andre Przywara <Andre.Przywara@arm.com>, kvmarm@lists.cs.columbia.edu, KVM General <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Mar 7, 2018 at 12:40 PM, Marc Zyngier <marc.zyngier@arm.com> wrote:
> The vgic code is trying to be clever when injecting GICv2 SGIs,
> and will happily populate LRs with the same interrupt number if
> they come from multiple vcpus (after all, they are distinct
> interrupt sources).
>
> Unfortunately, this is against the letter of the architecture,
> and the GICv2 architecture spec says "Each valid interrupt stored
> in the List registers must have a unique VirtualID for that
> virtual CPU interface.". GICv3 has similar (although slightly
> ambiguous) restrictions.
>
> This results in guests locking up when using GICv2-on-GICv3, for
> example. The obvious fix is to stop trying so hard, and inject
> a single vcpu per SGI per guest entry. After all, pending SGIs
> with multiple source vcpus are pretty rare, and are mostly seen
> in scenario where the physical CPUs are severely overcomitted.
>
> Cc: stable@vger.kernel.org
> Fixes: 0919e84c0fc1 ("KVM: arm/arm64: vgic-new: Add IRQ sync/flush framework")
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic.c | 11 +----------
>  1 file changed, 1 insertion(+), 10 deletions(-)
>
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index c7c5ef190afa..1f7ff175f47b 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c
> @@ -720,18 +720,9 @@ static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
>         list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
>                 spin_lock(&irq->irq_lock);
>
> -               if (unlikely(vgic_target_oracle(irq) != vcpu))
> -                       goto next;
> -
> -               /*
> -                * If we get an SGI with multiple sources, try to get
> -                * them in all at once.
> -                */
> -               do {
> +               if (likely(vgic_target_oracle(irq) == vcpu))
>                         vgic_populate_lr(vcpu, irq, count++);

I think we need to change vgic_populate_lr to set the EOI maintenance
interrupt flag so that when the interrupt is deactivated, if there are
additional pending sources, we exit the guest and pick up the
interrupt.

An alternative would be to set the underflow interrupt, but I don't
think that would be correct for multiple priorities, because the SGI
could have a higher priority than other pending interrupts we put in
the LR.

Thanks,
Christoffer
