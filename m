From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 15/21] arm64: KVM: VHE: Use unified sysreg accessors
 for timer
Date: Mon, 1 Feb 2016 15:23:19 +0100
Message-ID: <20160201142319.GU1478@cbox>
References: <1453737235-16522-1-git-send-email-marc.zyngier@arm.com>
 <1453737235-16522-16-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E06B410EB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Feb 2016 09:17:37 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id anj9DoLjmn0A for <kvmarm@lists.cs.columbia.edu>;
 Mon,  1 Feb 2016 09:17:36 -0500 (EST)
Received: from mail-wm0-f42.google.com (mail-wm0-f42.google.com [74.125.82.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 20742410D7
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Feb 2016 09:17:36 -0500 (EST)
Received: by mail-wm0-f42.google.com with SMTP id 128so73427878wmz.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 01 Feb 2016 06:22:54 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1453737235-16522-16-git-send-email-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jan 25, 2016 at 03:53:49PM +0000, Marc Zyngier wrote:
> Switch the timer code to the unified sysreg accessors.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

> ---
>  arch/arm64/kvm/hyp/timer-sr.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/timer-sr.c b/arch/arm64/kvm/hyp/timer-sr.c
> index 1051e5d..f276d9e 100644
> --- a/arch/arm64/kvm/hyp/timer-sr.c
> +++ b/arch/arm64/kvm/hyp/timer-sr.c
> @@ -31,12 +31,12 @@ void __hyp_text __timer_save_state(struct kvm_vcpu *vcpu)
>  	u64 val;
>  
>  	if (kvm->arch.timer.enabled) {
> -		timer->cntv_ctl = read_sysreg(cntv_ctl_el0);
> -		timer->cntv_cval = read_sysreg(cntv_cval_el0);
> +		timer->cntv_ctl = read_sysreg_el0(cntv_ctl);
> +		timer->cntv_cval = read_sysreg_el0(cntv_cval);
>  	}
>  
>  	/* Disable the virtual timer */
> -	write_sysreg(0, cntv_ctl_el0);
> +	write_sysreg_el0(0, cntv_ctl);
>  
>  	/* Allow physical timer/counter access for the host */
>  	val = read_sysreg(cnthctl_el2);
> @@ -64,8 +64,8 @@ void __hyp_text __timer_restore_state(struct kvm_vcpu *vcpu)
>  
>  	if (kvm->arch.timer.enabled) {
>  		write_sysreg(kvm->arch.timer.cntvoff, cntvoff_el2);
> -		write_sysreg(timer->cntv_cval, cntv_cval_el0);
> +		write_sysreg_el0(timer->cntv_cval, cntv_cval);
>  		isb();
> -		write_sysreg(timer->cntv_ctl, cntv_ctl_el0);
> +		write_sysreg_el0(timer->cntv_ctl, cntv_ctl);
>  	}
>  }
> -- 
> 2.1.4
> 
