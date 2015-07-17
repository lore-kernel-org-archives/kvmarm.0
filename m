From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 05/10] KVM: arm/arm64: vgic: Relax vgic_can_sample_irq
 for edge IRQs
Date: Sat, 18 Jul 2015 00:15:40 +0200
Message-ID: <20150717221540.GK14024@cbox>
References: <1436378202-20224-1-git-send-email-marc.zyngier@arm.com>
 <1436378202-20224-6-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CACBE58DF1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 18:03:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GRNFYTbRtECE for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jul 2015 18:03:25 -0400 (EDT)
Received: from mail-lb0-f172.google.com (mail-lb0-f172.google.com
 [209.85.217.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9A49058DE1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 18:03:25 -0400 (EDT)
Received: by lbbzr7 with SMTP id zr7so68299016lbb.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 15:15:22 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1436378202-20224-6-git-send-email-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jul 08, 2015 at 06:56:37PM +0100, Marc Zyngier wrote:
> We only set the irq_queued flag for level interrupts, meaning
> that "!vgic_irq_is_queued(vcpu, irq)" is a good enough predicate
> for all interrupts.
> 
> This will allow us to inject edge HW interrupts, for which the
> state ACTIVE+PENDING is not allowed.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/vgic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> index bc40137..5bd1695 100644
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@ -375,7 +375,7 @@ void vgic_cpu_irq_clear(struct kvm_vcpu *vcpu, int irq)
>  
>  static bool vgic_can_sample_irq(struct kvm_vcpu *vcpu, int irq)
>  {
> -	return vgic_irq_is_edge(vcpu, irq) || !vgic_irq_is_queued(vcpu, irq);
> +	return !vgic_irq_is_queued(vcpu, irq);
>  }
>  
>  /**
> -- 
> 2.1.4
> 
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
