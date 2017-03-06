From: Jintack Lim <jintack@cs.columbia.edu>
Subject: Re: [PATCH v2] KVM: arm/arm64: Let vcpu thread modify its own active
 state
Date: Mon, 6 Mar 2017 14:20:44 -0500
Message-ID: <CAHyh4xgQDy9t8YD2P_q8MSQfv_1wa9JicZkQKV2OQNG3w48+9A@mail.gmail.com>
References: <1488807757-86131-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5169F40B58
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Mar 2017 14:19:28 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ax3ADMTMH3df for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Mar 2017 14:19:27 -0500 (EST)
Received: from outprodmail02.cc.columbia.edu (outprodmail02.cc.columbia.edu
 [128.59.72.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 42EBE40A6A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Mar 2017 14:19:27 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v26JJiva037626
 for <kvmarm@lists.cs.columbia.edu>; Mon, 6 Mar 2017 14:20:47 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 42C8D80
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Mar 2017 14:20:47 -0500 (EST)
Received: from sendprodmail04.cc.columbia.edu (sendprodmail04.cc.columbia.edu
 [128.59.72.16]) by hazelnut (Postfix) with ESMTP id E895A7E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Mar 2017 14:20:46 -0500 (EST)
Received: from mail-oi0-f70.google.com (mail-oi0-f70.google.com
 [209.85.218.70])
 by sendprodmail04.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v26JKkJU060575
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 6 Mar 2017 14:20:46 -0500
Received: by mail-oi0-f70.google.com with SMTP id 2so146689771oif.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 06 Mar 2017 11:20:46 -0800 (PST)
Received: from mail-ot0-f173.google.com (mail-ot0-f173.google.com.
 [74.125.82.173])
 by smtp.gmail.com with ESMTPSA id w12sm9181292oiw.21.2017.03.06.11.20.45
 for <kvmarm@lists.cs.columbia.edu>
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Mon, 06 Mar 2017 11:20:45 -0800 (PST)
Received: by mail-ot0-f173.google.com with SMTP id o24so55376138otb.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 06 Mar 2017 11:20:45 -0800 (PST)
In-Reply-To: <1488807757-86131-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: KVM General <kvm@vger.kernel.org>, Eric Auger <eric.auger@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

thanks for submitting this patch.

On Mon, Mar 6, 2017 at 8:42 AM, Christoffer Dall
<christoffer.dall@linaro.org> wrote:
> From: Jintack Lim <jintack@cs.columbia.edu>
>
> Currently, if a vcpu thread tries to change the active state of an
> interrupt which is already on the same vcpu's AP list,

"it'll loop forever" is remove accidentally in the commit message in v2?

> Since the VGIC
> mmio handler is called after a vcpu has already synced back the LR state
> to the struct vgic_irq, we can just let it proceed safely.
>
> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
> ---
> Changes since v1:
>  - Reworked comment
>  - Consider userspace accesses
>  - Get the right requester VCPU for GICv3 private IRQ accesses
>  - Tested using kvm-unit-tests and verified that it deadlocked without
>    this patch and passed the test with this patch :)

nice!

>
>  virt/kvm/arm/vgic/vgic-mmio.c | 32 ++++++++++++++++++++++++--------
>  1 file changed, 24 insertions(+), 8 deletions(-)
>
> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
> index 3654b4c..2a5db13 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
> @@ -180,21 +180,37 @@ unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
>  static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
>                                     bool new_active_state)
>  {
> +       struct kvm_vcpu *requester_vcpu;
>         spin_lock(&irq->irq_lock);
> +
> +       /*
> +        * The vcpu parameter here can mean multiple things depending on how
> +        * this function is called; when handling a trap from the kernel it
> +        * depends on the GIC version, and these functions are also called as
> +        * part of save/restore from userspace.
> +        *
> +        * Therefore, we have to figure out the requester in a reliable way.
> +        *
> +        * When accessing VGIC state from user space, the requester_vcpu is
> +        * NULL, which is fine, because we guarantee that no VCPUs are running
> +        * when accessing VGIC state from user space so irq->vcpu->cpu is
> +        * always -1.
> +        */
> +       requester_vcpu = kvm_arm_get_running_vcpu();
> +
>         /*
>          * If this virtual IRQ was written into a list register, we
>          * have to make sure the CPU that runs the VCPU thread has
> -        * synced back LR state to the struct vgic_irq.  We can only
> -        * know this for sure, when either this irq is not assigned to
> -        * anyone's AP list anymore, or the VCPU thread is not
> -        * running on any CPUs.
> +        * synced back the LR state to the struct vgic_irq.
>          *
> -        * In the opposite case, we know the VCPU thread may be on its
> -        * way back from the guest and still has to sync back this
> -        * IRQ, so we release and re-acquire the spin_lock to let the
> -        * other thread sync back the IRQ.
> +        * As long as the conditions below are true, we know the VCPU thread
> +        * may be on its way back from the guest (we kicked the VCPU thread in
> +        * vgic_change_active_prepare)  and still has to sync back this IRQ,
> +        * so we release and re-acquire the spin_lock to let the other thread
> +        * sync back the IRQ.
>          */
>         while (irq->vcpu && /* IRQ may have state in an LR somewhere */
> +              irq->vcpu != requester_vcpu && /* Current thread is not the VCPU thread */
>                irq->vcpu->cpu != -1) /* VCPU thread is running */
>                 cond_resched_lock(&irq->irq_lock);
>
> --
> 2.5.0
>
>
