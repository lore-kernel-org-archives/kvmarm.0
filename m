From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 1/7] KVM: arm/arm64: vgic-irqfd: Fix MSI entry allocation
Date: Mon, 20 Nov 2017 15:49:57 +0100
Message-ID: <20171120144957.GJ28855@cbox>
References: <20171116175821.26544-1-marc.zyngier@arm.com>
 <20171116175821.26544-2-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4365C40FB0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Nov 2017 09:47:20 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8h5BpyTsOb7B for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Nov 2017 09:47:19 -0500 (EST)
Received: from mail-wr0-f194.google.com (mail-wr0-f194.google.com
 [209.85.128.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1080840D25
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Nov 2017 09:47:19 -0500 (EST)
Received: by mail-wr0-f194.google.com with SMTP id a63so8285772wrc.12
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Nov 2017 06:49:49 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20171116175821.26544-2-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Kristina Martsenko <kristina.martsenko@arm.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Nov 16, 2017 at 05:58:15PM +0000, Marc Zyngier wrote:
> Using the size of the structure we're allocating is a good idea
> and avoids any surprise... In this case, we're happilly confusing
> kvm_kernel_irq_routing_entry and kvm_irq_routing_entry...

Yikes.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

> 
> Fixes: 95b110ab9a09 ("KVM: arm/arm64: Enable irqchip routing")
> Cc: stable@vger.kernel.org # 4.8
> Reported-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-irqfd.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-irqfd.c b/virt/kvm/arm/vgic/vgic-irqfd.c
> index b7baf581611a..99e026d2dade 100644
> --- a/virt/kvm/arm/vgic/vgic-irqfd.c
> +++ b/virt/kvm/arm/vgic/vgic-irqfd.c
> @@ -112,8 +112,7 @@ int kvm_vgic_setup_default_irq_routing(struct kvm *kvm)
>  	u32 nr = dist->nr_spis;
>  	int i, ret;
>  
> -	entries = kcalloc(nr, sizeof(struct kvm_kernel_irq_routing_entry),
> -			  GFP_KERNEL);
> +	entries = kcalloc(nr, sizeof(*entries), GFP_KERNEL);
>  	if (!entries)
>  		return -ENOMEM;
>  
> -- 
> 2.14.2
> 
