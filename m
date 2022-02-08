Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22C9AC433F5
	for <kvmarm@archiver.kernel.org>; Tue,  8 Feb 2022 14:36:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 71E1A4B129;
	Tue,  8 Feb 2022 09:36:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8Fjk1R9k8LHM; Tue,  8 Feb 2022 09:36:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E0F5C4B137;
	Tue,  8 Feb 2022 09:36:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B7E6C4B129
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Feb 2022 09:36:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id snqnoCfjzAS2 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Feb 2022 09:36:15 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1077C4B128
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Feb 2022 09:36:14 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 634542B;
 Tue,  8 Feb 2022 06:36:14 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 774753F73B;
 Tue,  8 Feb 2022 06:36:11 -0800 (PST)
Date: Tue, 8 Feb 2022 14:36:26 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v6 27/64] KVM: arm64: nv: Allow a sysreg to be hidden
 from userspace only
Message-ID: <YgJ/rmfmKUVbUMtO@monolith.localdoman>
References: <20220128121912.509006-1-maz@kernel.org>
 <20220128121912.509006-28-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220128121912.509006-28-maz@kernel.org>
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

Hi Marc,

On Fri, Jan 28, 2022 at 12:18:35PM +0000, Marc Zyngier wrote:
> So far, we never needed to distinguish between registers hidden
> from userspace and being hidden from a guest (they are always
> either visible to both, or hidden from both).
> 
> With NV, we have the ugly case of the EL{0,1}2 registers, which
                                        ^^^^^^^^
That might be easier to parse if it is rephrased to "EL02 and EL12
registers".

> are only a view on the EL{0,1} registers. It makes absolutely no
> sense to expose them to userspace, since it already has the
> canonical view.
> 
> Add a new visibility flag (REG_HIDDEN_USER) and a new helper that
> checks for it and REG_HIDDEN when checking whether to expose
> a sysreg to userspace. Subsequent patches will make use of it.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

The patch makes sense to me, the _EL02 and _EL12 are just aliases for the
EL0 and EL1 registers, no sense in exposing both to userspace. And these
registers also only make sense when the VCPU has the EL2 feature, which is
not always the case:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex

> ---
>  arch/arm64/kvm/sys_regs.c |  6 +++---
>  arch/arm64/kvm/sys_regs.h | 12 +++++++++++-
>  2 files changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 31d739d59f67..0c9bbe5eee5e 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -3031,7 +3031,7 @@ int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
>  		return get_invariant_sys_reg(reg->id, uaddr);
>  
>  	/* Check for regs disabled by runtime config */
> -	if (sysreg_hidden(vcpu, r))
> +	if (sysreg_hidden_user(vcpu, r))
>  		return -ENOENT;
>  
>  	if (r->get_user)
> @@ -3056,7 +3056,7 @@ int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
>  		return set_invariant_sys_reg(reg->id, uaddr);
>  
>  	/* Check for regs disabled by runtime config */
> -	if (sysreg_hidden(vcpu, r))
> +	if (sysreg_hidden_user(vcpu, r))
>  		return -ENOENT;
>  
>  	if (r->set_user)
> @@ -3127,7 +3127,7 @@ static int walk_one_sys_reg(const struct kvm_vcpu *vcpu,
>  	if (!(rd->reg || rd->get_user))
>  		return 0;
>  
> -	if (sysreg_hidden(vcpu, rd))
> +	if (sysreg_hidden_user(vcpu, rd))
>  		return 0;
>  
>  	if (!copy_reg_to_user(rd, uind))
> diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> index cc0cc95a0280..850629f083a3 100644
> --- a/arch/arm64/kvm/sys_regs.h
> +++ b/arch/arm64/kvm/sys_regs.h
> @@ -78,7 +78,8 @@ struct sys_reg_desc {
>  };
>  
>  #define REG_HIDDEN		(1 << 0) /* hidden from userspace and guest */
> -#define REG_RAZ			(1 << 1) /* RAZ from userspace and guest */
> +#define REG_HIDDEN_USER		(1 << 1) /* hidden from userspace only */
> +#define REG_RAZ			(1 << 2) /* RAZ from userspace and guest */
>  
>  static __printf(2, 3)
>  inline void print_sys_reg_msg(const struct sys_reg_params *p,
> @@ -138,6 +139,15 @@ static inline bool sysreg_hidden(const struct kvm_vcpu *vcpu,
>  	return r->visibility(vcpu, r) & REG_HIDDEN;
>  }
>  
> +static inline bool sysreg_hidden_user(const struct kvm_vcpu *vcpu,
> +				      const struct sys_reg_desc *r)
> +{
> +	if (likely(!r->visibility))
> +		return false;
> +
> +	return r->visibility(vcpu, r) & (REG_HIDDEN | REG_HIDDEN_USER);
> +}
> +
>  static inline bool sysreg_visible_as_raz(const struct kvm_vcpu *vcpu,
>  					 const struct sys_reg_desc *r)
>  {
> -- 
> 2.30.2
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
