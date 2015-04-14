From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm: irqfd: fix value returned by kvm_irq_map_gsi
Date: Tue, 14 Apr 2015 12:44:46 +0200
Message-ID: <20150414104446.GA6186@cbox>
References: <1428930119-21692-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F2B8A4D026
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2015 06:36:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mYcNKawb3JZM for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Apr 2015 06:36:50 -0400 (EDT)
Received: from mail-lb0-f176.google.com (mail-lb0-f176.google.com
 [209.85.217.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BAB444D025
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2015 06:36:49 -0400 (EDT)
Received: by lbbzk7 with SMTP id zk7so4741322lbb.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2015 03:44:38 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1428930119-21692-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, kvm@vger.kernel.org, patches@linaro.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Apr 13, 2015 at 03:01:59PM +0200, Eric Auger wrote:
> irqfd/arm curently does not support routing. kvm_irq_map_gsi is
> supposed to return all the routing entries associated with the
> provided gsi and return the number of those entries. We should
> return 0 at this point.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> ---
>  virt/kvm/arm/vgic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> index 9ad074e..9b4f7d4 100644
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@ -1947,7 +1947,7 @@ int kvm_irq_map_gsi(struct kvm *kvm,
>  		    struct kvm_kernel_irq_routing_entry *entries,
>  		    int gsi)
>  {
> -	return gsi;
> +	return 0;
>  }
>  
>  int kvm_irq_map_chip_pin(struct kvm *kvm, unsigned irqchip, unsigned pin)
> -- 

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
