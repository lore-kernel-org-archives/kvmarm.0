From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 15/25] KVM: arm64: vgic-v3: Add misc Group-0 handlers
Date: Tue, 6 Jun 2017 15:22:51 +0200
Message-ID: <20170606132251.GX9464@cbox>
References: <20170601102117.17750-1-marc.zyngier@arm.com>
 <20170601102117.17750-16-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8506440A74
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Jun 2017 09:19:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GGYzZSQiocbA for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Jun 2017 09:18:59 -0400 (EDT)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8BFC140A69
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Jun 2017 09:18:59 -0400 (EDT)
Received: by mail-wm0-f45.google.com with SMTP id n195so100598429wmg.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 06 Jun 2017 06:23:05 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170601102117.17750-16-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Robert Richter <rrichter@cavium.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jun 01, 2017 at 11:21:07AM +0100, Marc Zyngier wrote:
> A number of Group-0 registers can be handled by the same accessors
> as that of Group-1, so let's add the required system register encodings
> and catch them in the dispatching function.
> 
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Christoffer Dall <cdall@linaro.org>

> ---
>  arch/arm64/include/asm/sysreg.h | 4 ++++
>  virt/kvm/arm/hyp/vgic-v3-sr.c   | 7 +++++++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index ba93bc7ac8e4..9971c5c435a7 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -180,7 +180,11 @@
>  
>  #define SYS_VBAR_EL1			sys_reg(3, 0, 12, 0, 0)
>  
> +#define SYS_ICC_IAR0_EL1		sys_reg(3, 0, 12, 8, 0)
> +#define SYS_ICC_EOIR0_EL1		sys_reg(3, 0, 12, 8, 1)
> +#define SYS_ICC_HPPIR0_EL1		sys_reg(3, 0, 12, 8, 2)
>  #define SYS_ICC_BPR0_EL1		sys_reg(3, 0, 12, 8, 3)
> +#define SYS_ICC_AP0Rn_EL1(n)		sys_reg(3, 0, 12, 8, 4 | n)
>  #define SYS_ICC_AP1Rn_EL1(n)		sys_reg(3, 0, 12, 9, n)
>  #define SYS_ICC_DIR_EL1			sys_reg(3, 0, 12, 11, 1)
>  #define SYS_ICC_SGI1R_EL1		sys_reg(3, 0, 12, 11, 5)
> diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
> index b1b9129da045..5ff788d308ee 100644
> --- a/virt/kvm/arm/hyp/vgic-v3-sr.c
> +++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
> @@ -872,9 +872,11 @@ int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
>  	is_read = (esr & ESR_ELx_SYS64_ISS_DIR_MASK) == ESR_ELx_SYS64_ISS_DIR_READ;
>  
>  	switch (sysreg) {
> +	case SYS_ICC_IAR0_EL1:
>  	case SYS_ICC_IAR1_EL1:
>  		fn = __vgic_v3_read_iar;
>  		break;
> +	case SYS_ICC_EOIR0_EL1:
>  	case SYS_ICC_EOIR1_EL1:
>  		fn = __vgic_v3_write_eoir;
>  		break;
> @@ -890,30 +892,35 @@ int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
>  		else
>  			fn = __vgic_v3_write_bpr1;
>  		break;
> +	case SYS_ICC_AP0Rn_EL1(0):
>  	case SYS_ICC_AP1Rn_EL1(0):
>  		if (is_read)
>  			fn = __vgic_v3_read_apxr0;
>  		else
>  			fn = __vgic_v3_write_apxr0;
>  		break;
> +	case SYS_ICC_AP0Rn_EL1(1):
>  	case SYS_ICC_AP1Rn_EL1(1):
>  		if (is_read)
>  			fn = __vgic_v3_read_apxr1;
>  		else
>  			fn = __vgic_v3_write_apxr1;
>  		break;
> +	case SYS_ICC_AP0Rn_EL1(2):
>  	case SYS_ICC_AP1Rn_EL1(2):
>  		if (is_read)
>  			fn = __vgic_v3_read_apxr2;
>  		else
>  			fn = __vgic_v3_write_apxr2;
>  		break;
> +	case SYS_ICC_AP0Rn_EL1(3):
>  	case SYS_ICC_AP1Rn_EL1(3):
>  		if (is_read)
>  			fn = __vgic_v3_read_apxr3;
>  		else
>  			fn = __vgic_v3_write_apxr3;
>  		break;
> +	case SYS_ICC_HPPIR0_EL1:
>  	case SYS_ICC_HPPIR1_EL1:
>  		fn = __vgic_v3_read_hppir;
>  		break;
> -- 
> 2.11.0
> 
