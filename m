From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 2/2] KVM: arm/arm64: vgic-v3: Fix off-by-one LR access
Date: Wed, 19 Apr 2017 12:09:12 +0200
Message-ID: <20170419100912.GB4104@cbox>
References: <20170410091944.19963-1-marc.zyngier@arm.com>
 <20170410091944.19963-3-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D197140C90
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Apr 2017 06:06:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Lz2UBf0X3tq5 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Apr 2017 06:06:31 -0400 (EDT)
Received: from mail-wm0-f44.google.com (mail-wm0-f44.google.com [74.125.82.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D250740C5B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Apr 2017 06:06:30 -0400 (EDT)
Received: by mail-wm0-f44.google.com with SMTP id r190so18022819wme.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Apr 2017 03:09:09 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170410091944.19963-3-marc.zyngier@arm.com>
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
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Apr 10, 2017 at 10:19:44AM +0100, Marc Zyngier wrote:
> When iterating over the used LRs, be careful not to try to access
> an unused LR, or even an unimplemented one if you're unlucky...
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/hyp/vgic-v3-sr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
> index 91922c1eddc8..bce6037cf01d 100644
> --- a/virt/kvm/arm/hyp/vgic-v3-sr.c
> +++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
> @@ -143,7 +143,7 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
>  		val = read_gicreg(ICH_VTR_EL2);
>  		nr_pri_bits = vtr_to_nr_pri_bits(val);
>  
> -		for (i = 0; i <= used_lrs; i++) {
> +		for (i = 0; i < used_lrs; i++) {
>  			if (cpu_if->vgic_elrsr & (1 << i))
>  				cpu_if->vgic_lr[i] &= ~ICH_LR_STATE;
>  			else
> -- 
> 2.11.0
> 

Whoops, thanks for fixing my stupid mistake:

Reviewed-by: Christoffer Dall <cdall@linaro.org>
