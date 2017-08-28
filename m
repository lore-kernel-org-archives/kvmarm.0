From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v3 50/59] KVM: arm/arm64: GICv4: Use pending_last as a
 scheduling hint
Date: Mon, 28 Aug 2017 20:18:46 +0200
Message-ID: <20170828181846.GK24649@cbox>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
 <20170731172637.29355-51-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B53249C1C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Aug 2017 14:16:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1DKRjjbPyKib for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Aug 2017 14:16:40 -0400 (EDT)
Received: from mail-wm0-f44.google.com (mail-wm0-f44.google.com [74.125.82.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9A7CB49C41
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Aug 2017 14:16:40 -0400 (EDT)
Received: by mail-wm0-f44.google.com with SMTP id b14so14839294wme.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Aug 2017 11:18:49 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170731172637.29355-51-marc.zyngier@arm.com>
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
Cc: Jason Cooper <jason@lakedaemon.net>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jul 31, 2017 at 06:26:28PM +0100, Marc Zyngier wrote:
> When a vPE exits, the pending_last flag is set when there are
> pending VLPIs stored in the pending table. Similarily, we set
> this flag when a doorbell interrupt fires, as it indicates the
> same condition.
> 
> Let's update kvm_vgic_vcpu_pending_irq() to account for that
> flag as well, making a vcpu runnable when set.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index a96e566905d2..dfac894f6f03 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c
> @@ -781,6 +781,9 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
>  	if (!vcpu->kvm->arch.vgic.enabled)
>  		return false;
>  
> +	if (vcpu->arch.vgic_cpu.vgic_v3.its_vpe.pending_last)
> +		return true;
> +
>  	spin_lock(&vgic_cpu->ap_list_lock);
>  
>  	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
> -- 
> 2.11.0
> 

Acked-by: Christoffer Dall <cdall@linaro.org>
