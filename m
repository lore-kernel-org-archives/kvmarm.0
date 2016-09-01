From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH] KVM: arm: vgic: Drop build compatibility hack for older
 kernel versions
Date: Thu, 1 Sep 2016 10:03:03 +0200
Message-ID: <c7f91cc3-238d-d35f-9f56-fc8fadbf6839@redhat.com>
References: <1472579659-20772-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F68040FA6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Sep 2016 03:55:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5nyHdQ3hwC59 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Sep 2016 03:54:57 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 47D4B40C9A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Sep 2016 03:54:57 -0400 (EDT)
In-Reply-To: <1472579659-20772-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 30/08/2016 19:54, Marc Zyngier wrote:
> As kvm_set_routing_entry() was changing prototype between 4.7 and 4.8,
> an ugly hack was put in place in order to survive both building in
> -next and the merge window.
> 
> Now that everything has been merged, let's dump the compatibility
> hack for good.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-irqfd.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-irqfd.c b/virt/kvm/arm/vgic/vgic-irqfd.c
> index b31a51a..d918dcf 100644
> --- a/virt/kvm/arm/vgic/vgic-irqfd.c
> +++ b/virt/kvm/arm/vgic/vgic-irqfd.c
> @@ -46,15 +46,9 @@ static int vgic_irqfd_set_irq(struct kvm_kernel_irq_routing_entry *e,
>   * @ue: user api routing entry handle
>   * return 0 on success, -EINVAL on errors.
>   */
> -#ifdef KVM_CAP_X2APIC_API
>  int kvm_set_routing_entry(struct kvm *kvm,
>  			  struct kvm_kernel_irq_routing_entry *e,
>  			  const struct kvm_irq_routing_entry *ue)
> -#else
> -/* Remove this version and the ifdefery once merged into 4.8 */
> -int kvm_set_routing_entry(struct kvm_kernel_irq_routing_entry *e,
> -			  const struct kvm_irq_routing_entry *ue)
> -#endif
>  {
>  	int r = -EINVAL;
>  
> 

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
