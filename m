Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B057C433F5
	for <kvmarm@archiver.kernel.org>; Mon,  7 Feb 2022 16:36:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AA52049ECE;
	Mon,  7 Feb 2022 11:36:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aHwNEJMLnWzX; Mon,  7 Feb 2022 11:36:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E688249EC5;
	Mon,  7 Feb 2022 11:36:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B484749E44
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Feb 2022 11:36:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P+FMYPvB9++M for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Feb 2022 11:36:35 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E2FF348F9C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Feb 2022 11:36:34 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5E4B311FB;
 Mon,  7 Feb 2022 08:36:34 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8BEC23F718;
 Mon,  7 Feb 2022 08:36:31 -0800 (PST)
Date: Mon, 7 Feb 2022 16:36:42 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v6 26/64] KVM: arm64: nv: Respect the virtual HCR_EL2.NV1
 bit setting
Message-ID: <YgFKmsrDLR9m3c5y@monolith.localdoman>
References: <20220128121912.509006-1-maz@kernel.org>
 <20220128121912.509006-27-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220128121912.509006-27-maz@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Andre Przywara <andre.przywara@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Chase Conklin <chase.conklin@arm.com>, kvmarm@lists.cs.columbia.edu,
 mihai.carabas@oracle.com,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 "Russell King \(Oracle\)" <linux@armlinux.org.uk>,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Fri, Jan 28, 2022 at 12:18:34PM +0000, Marc Zyngier wrote:
> From: Jintack Lim <jintack@cs.columbia.edu>
> 
> Forward ELR_EL1, SPSR_EL1 and VBAR_EL1 traps to the virtual EL2 if the
> virtual HCR_EL2.NV bit is set.

Those registers are trapped when HCR_EL2.{NV,NV1} = {1,1}. They aren't trapped
when only HCR_EL2.NV is set.

> 
> This is for recursive nested virtualization.
> 
> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_arm.h    |  1 +
>  arch/arm64/include/asm/kvm_nested.h |  1 +
>  arch/arm64/kvm/emulate-nested.c     |  5 +++++
>  arch/arm64/kvm/sys_regs.c           | 22 +++++++++++++++++++++-
>  4 files changed, 28 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index 8043827e7dc0..748c2b068d4e 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -20,6 +20,7 @@
>  #define HCR_AMVOFFEN	(UL(1) << 51)
>  #define HCR_FIEN	(UL(1) << 47)
>  #define HCR_FWB		(UL(1) << 46)
> +#define HCR_NV1		(UL(1) << 43)
>  #define HCR_NV		(UL(1) << 42)
>  #define HCR_API		(UL(1) << 41)
>  #define HCR_APK		(UL(1) << 40)
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> index 37ff6458296d..82fc8b6c990b 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -68,5 +68,6 @@ static inline u64 translate_cnthctl_el2_to_cntkctl_el1(u64 cnthctl)
>  int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe);
>  extern bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit);
>  extern bool forward_nv_traps(struct kvm_vcpu *vcpu);
> +extern bool forward_nv1_traps(struct kvm_vcpu *vcpu);
>  
>  #endif /* __ARM64_KVM_NESTED_H */
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index 7dd98d6e96e0..0109dfd664dd 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -33,6 +33,11 @@ bool forward_nv_traps(struct kvm_vcpu *vcpu)
>  	return forward_traps(vcpu, HCR_NV);
>  }
>  
> +bool forward_nv1_traps(struct kvm_vcpu *vcpu)
> +{
> +	return forward_traps(vcpu, HCR_NV1);
> +}
> +
>  static u64 kvm_check_illegal_exception_return(struct kvm_vcpu *vcpu, u64 spsr)
>  {
>  	u64 mode = spsr & PSR_MODE_MASK;
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index edaf287c7ec9..31d739d59f67 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -288,6 +288,16 @@ static bool access_rw(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> +static bool access_vbar_el1(struct kvm_vcpu *vcpu,
> +			    struct sys_reg_params *p,
> +			    const struct sys_reg_desc *r)
> +{
> +	if (forward_nv1_traps(vcpu))
> +		return false;
> +
> +	return access_rw(vcpu, p, r);
> +}
> +
>  /*
>   * See note at ARMv7 ARM B1.14.4 (TL;DR: S/W ops are not easily virtualized).
>   */
> @@ -1669,6 +1679,7 @@ static bool access_sp_el1(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> +

Hm... extra newline?

Thanks,
Alex

>  static bool access_elr(struct kvm_vcpu *vcpu,
>  		       struct sys_reg_params *p,
>  		       const struct sys_reg_desc *r)
> @@ -1676,6 +1687,9 @@ static bool access_elr(struct kvm_vcpu *vcpu,
>  	if (el12_reg(p) && forward_nv_traps(vcpu))
>  		return false;
>  
> +	if (!el12_reg(p) && forward_nv1_traps(vcpu))
> +		return false;
> +
>  	if (p->is_write)
>  		vcpu_write_sys_reg(vcpu, p->regval, ELR_EL1);
>  	else
> @@ -1691,6 +1705,9 @@ static bool access_spsr(struct kvm_vcpu *vcpu,
>  	if (el12_reg(p) && forward_nv_traps(vcpu))
>  		return false;
>  
> +	if (!el12_reg(p) && forward_nv1_traps(vcpu))
> +		return false;
> +
>  	if (p->is_write)
>  		__vcpu_sys_reg(vcpu, SPSR_EL1) = p->regval;
>  	else
> @@ -1706,6 +1723,9 @@ static bool access_spsr_el2(struct kvm_vcpu *vcpu,
>  	if (el12_reg(p) && forward_nv_traps(vcpu))
>  		return false;
>  
> +	if (!el12_reg(p) && forward_nv1_traps(vcpu))
> +		return false;
> +
>  	if (p->is_write)
>  		vcpu_write_sys_reg(vcpu, p->regval, SPSR_EL2);
>  	else
> @@ -1914,7 +1934,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	{ SYS_DESC(SYS_LORC_EL1), trap_loregion },
>  	{ SYS_DESC(SYS_LORID_EL1), trap_loregion },
>  
> -	{ SYS_DESC(SYS_VBAR_EL1), access_rw, reset_val, VBAR_EL1, 0 },
> +	{ SYS_DESC(SYS_VBAR_EL1), access_vbar_el1, reset_val, VBAR_EL1, 0 },
>  	{ SYS_DESC(SYS_DISR_EL1), NULL, reset_val, DISR_EL1, 0 },
>  
>  	{ SYS_DESC(SYS_ICC_IAR0_EL1), write_to_read_only },
> -- 
> 2.30.2
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
