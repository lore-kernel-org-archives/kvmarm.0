From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v3 5/8] arm/arm64: KVM: Use appropriate define in VGIC
 reset code
Date: Fri, 2 Oct 2015 15:51:58 +0100
Message-ID: <560E9A0E.2010507@arm.com>
References: <1443538145-11990-1-git-send-email-christoffer.dall@linaro.org>
 <1443538145-11990-6-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4934941294
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Oct 2015 10:49:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7EDl8pkINhfp for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Oct 2015 10:49:11 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 276D5410BB
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Oct 2015 10:49:11 -0400 (EDT)
In-Reply-To: <1443538145-11990-6-git-send-email-christoffer.dall@linaro.org>
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
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 29/09/15 15:49, Christoffer Dall wrote:
> We currently initialize the SGIs to be enabled in the VGIC code, but we
> use the VGIC_NR_PPIS define for this purpose, instead of the the more
> natural VGIC_NR_SGIS.  Change this slightly confusing use of the
> defines.
> 
> Note: This should have no functional change, as both names are defined
> to the number 16.
> 
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  virt/kvm/arm/vgic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> index e606f78..9ed8d53 100644
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@ -2109,7 +2109,7 @@ int vgic_init(struct kvm *kvm)
>  		}
>  
>  		for (i = 0; i < dist->nr_irqs; i++) {
> -			if (i < VGIC_NR_PPIS)
> +			if (i < VGIC_NR_SGIS)
>  				vgic_bitmap_set_irq_val(&dist->irq_enabled,
>  							vcpu->vcpu_id, i, 1);
>  			if (i < VGIC_NR_PRIVATE_IRQS)
> 

While the patch itself is a good catch, I wonder why we iterate over all
IRQs here if we only do something for private IRQs? Can you fix that on
the way as well?
Oh, and while you are at it: ;-)
A comments like: "Set all private IRQs to be edge-triggered and enable
all SGIs." sounds useful to me.

Cheers,
Andre.
