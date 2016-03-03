From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 16/17] arm64: KVM: vgic-v3: Only wipe LRs on vcpu exit
Date: Thu, 3 Mar 2016 20:21:50 +0100
Message-ID: <20160303192150.GI9634@cbox>
References: <1455727249-24752-1-git-send-email-marc.zyngier@arm.com>
 <1455727249-24752-17-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1659B48537
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Mar 2016 14:14:36 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dl1heku+Uasz for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Mar 2016 14:14:35 -0500 (EST)
Received: from mail-wm0-f51.google.com (mail-wm0-f51.google.com [74.125.82.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0DECD4852F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Mar 2016 14:14:34 -0500 (EST)
Received: by mail-wm0-f51.google.com with SMTP id p65so49051072wmp.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Mar 2016 11:21:50 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1455727249-24752-17-git-send-email-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 17, 2016 at 04:40:48PM +0000, Marc Zyngier wrote:
> So far, we're always writing all possible LRs, setting the empty
> ones with a zero value. This is obvious doing a low of work for
> nothing, and we're better off clearing those we've actually
> dirtied on the exit path (it is very rare to inject more than one
> interrupt at a time anyway).
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/hyp/vgic-v3-sr.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> index ff67296..5f12c57 100644
> --- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
> +++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> @@ -199,6 +199,7 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
>  			}
>  
>  			cpu_if->vgic_lr[i] = __gic_v3_get_lr(i);
> +			__gic_v3_set_lr(0, i);
>  		}
>  
>  		switch (nr_pri_bits) {
> @@ -296,12 +297,10 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
>  		}
>  		 	                           
>  		for (i = 0; i <= max_lr_idx; i++) {
> -			val = 0;
> -
> -			if (live_lrs & (1 << i))
> -				val = cpu_if->vgic_lr[i];
> +			if (!(live_lrs & (1 << i)))
> +				continue;
>  
> -			__gic_v3_set_lr(val, i);
> +			__gic_v3_set_lr(cpu_if->vgic_lr[i], i);
>  		}
>  	}
>  
> -- 
> 2.1.4
> 

same comment here with initializing the LRs, but otherwise:

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
