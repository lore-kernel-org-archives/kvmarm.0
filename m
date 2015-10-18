From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 2/9] KVM: arm: Do not indent the arguments of
 DECLARE_BITMAP
Date: Sun, 18 Oct 2015 22:34:58 +0200
Message-ID: <20151018203458.GE7531@cbox>
References: <1444940195-28272-1-git-send-email-mmarek@suse.com>
 <1444940195-28272-3-git-send-email-mmarek@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D4F141289
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Oct 2015 16:32:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UmAhasx7hzWi for <kvmarm@lists.cs.columbia.edu>;
 Sun, 18 Oct 2015 16:32:02 -0400 (EDT)
Received: from mail-lf0-f41.google.com (mail-lf0-f41.google.com
 [209.85.215.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 66F074117E
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Oct 2015 16:32:01 -0400 (EDT)
Received: by lffv3 with SMTP id v3so98618394lff.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Oct 2015 13:34:28 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1444940195-28272-3-git-send-email-mmarek@suse.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Michal Marek <mmarek@suse.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Oct 15, 2015 at 10:16:28PM +0200, Michal Marek wrote:
> Besides being a coding style issue, it confuses make tags:
> 
> ctags: Warning: include/kvm/arm_vgic.h:307: null expansion of name pattern "\1"
> ctags: Warning: include/kvm/arm_vgic.h:308: null expansion of name pattern "\1"
> ctags: Warning: include/kvm/arm_vgic.h:309: null expansion of name pattern "\1"
> ctags: Warning: include/kvm/arm_vgic.h:317: null expansion of name pattern "\1"
> 
> Cc: kvmarm@lists.cs.columbia.edu
> Signed-off-by: Michal Marek <mmarek@suse.com>
> ---

Is not being able to deal with a whitespace not a make tags problem?

As for coding style, do we really entertain these kinds of changes just
to adhere to a coding style?  It feels unnecessary taints the log etc.

However, I'm curious what the general concesus and previous practice for
this sort of thing is?

Thanks,
-Christoffer

>  include/kvm/arm_vgic.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index d901f1a47be6..58c5c0eb8d2d 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -304,9 +304,9 @@ struct vgic_cpu {
>  	u8		*vgic_irq_lr_map;
>  
>  	/* Pending/active/both interrupts on this VCPU */
> -	DECLARE_BITMAP(	pending_percpu, VGIC_NR_PRIVATE_IRQS);
> -	DECLARE_BITMAP(	active_percpu, VGIC_NR_PRIVATE_IRQS);
> -	DECLARE_BITMAP(	pend_act_percpu, VGIC_NR_PRIVATE_IRQS);
> +	DECLARE_BITMAP(pending_percpu, VGIC_NR_PRIVATE_IRQS);
> +	DECLARE_BITMAP(active_percpu, VGIC_NR_PRIVATE_IRQS);
> +	DECLARE_BITMAP(pend_act_percpu, VGIC_NR_PRIVATE_IRQS);
>  
>  	/* Pending/active/both shared interrupts, dynamically sized */
>  	unsigned long	*pending_shared;
> @@ -314,7 +314,7 @@ struct vgic_cpu {
>  	unsigned long   *pend_act_shared;
>  
>  	/* Bitmap of used/free list registers */
> -	DECLARE_BITMAP(	lr_used, VGIC_V2_MAX_LRS);
> +	DECLARE_BITMAP(lr_used, VGIC_V2_MAX_LRS);
>  
>  	/* Number of list registers on this CPU */
>  	int		nr_lr;
> -- 
> 2.1.4
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
