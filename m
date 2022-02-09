Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1947FC433F5
	for <kvmarm@archiver.kernel.org>; Wed,  9 Feb 2022 11:04:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 65BAE49F2E;
	Wed,  9 Feb 2022 06:04:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iMOZPV2nIQgR; Wed,  9 Feb 2022 06:04:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AAE3949F0A;
	Wed,  9 Feb 2022 06:04:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE76749F05
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Feb 2022 06:04:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LLdytswPv9uJ for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Feb 2022 06:04:23 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4684F49F02
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Feb 2022 06:04:23 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0F4D9ED1;
 Wed,  9 Feb 2022 03:04:22 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E1BBB3F73B;
 Wed,  9 Feb 2022 03:04:18 -0800 (PST)
Date: Wed, 9 Feb 2022 11:04:39 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v6 29/64] KVM: arm64: nv: Forward debug traps to the
 nested guest
Message-ID: <YgOfxxqVOjLYZLGL@monolith.localdoman>
References: <20220128121912.509006-1-maz@kernel.org>
 <20220128121912.509006-30-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220128121912.509006-30-maz@kernel.org>
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

On Fri, Jan 28, 2022 at 12:18:37PM +0000, Marc Zyngier wrote:
> On handling a debug trap, check whether we need to forward it to the
> guest before handling it.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_nested.h | 2 ++
>  arch/arm64/kvm/emulate-nested.c     | 9 +++++++--
>  arch/arm64/kvm/sys_regs.c           | 3 +++
>  3 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> index 82fc8b6c990b..047ca700163b 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -66,6 +66,8 @@ static inline u64 translate_cnthctl_el2_to_cntkctl_el1(u64 cnthctl)
>  }
>  
>  int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe);
> +extern bool __forward_traps(struct kvm_vcpu *vcpu, unsigned int reg,
> +			    u64 control_bit);
>  extern bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit);
>  extern bool forward_nv_traps(struct kvm_vcpu *vcpu);
>  extern bool forward_nv1_traps(struct kvm_vcpu *vcpu);
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index 0109dfd664dd..1f6cf8fe9fe3 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -13,14 +13,14 @@
>  
>  #include "trace.h"
>  
> -bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit)
> +bool __forward_traps(struct kvm_vcpu *vcpu, unsigned int reg, u64 control_bit)
>  {
>  	bool control_bit_set;
>  
>  	if (!vcpu_has_nv(vcpu))
>  		return false;
>  
> -	control_bit_set = __vcpu_sys_reg(vcpu, HCR_EL2) & control_bit;
> +	control_bit_set = __vcpu_sys_reg(vcpu, reg) & control_bit;
>  	if (!vcpu_is_el2(vcpu) && control_bit_set) {
>  		kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
>  		return true;
> @@ -28,6 +28,11 @@ bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit)
>  	return false;
>  }
>  
> +bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit)
> +{
> +	return __forward_traps(vcpu, HCR_EL2, control_bit);
> +}
> +
>  bool forward_nv_traps(struct kvm_vcpu *vcpu)
>  {
>  	return forward_traps(vcpu, HCR_NV);
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 697bf0bca550..3e1f37c507a8 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -566,6 +566,9 @@ static bool trap_debug_regs(struct kvm_vcpu *vcpu,
>  			    struct sys_reg_params *p,
>  			    const struct sys_reg_desc *r)
>  {
> +	if (__forward_traps(vcpu, MDCR_EL2, MDCR_EL2_TDA | MDCR_EL2_TDE))
> +		return false;

The description of the MDCR_EL2.TDA field says:

"This field is treated as being 1 for all purposes other than a direct read
when one or more of the following are true:

- MDCR_EL2.TDE == 1
- HCR_EL2.TGE == 1"

Shouldn't we also check for HCR_EL2.TGE == 1 when deciding to forward the trap?

Thanks,
Alex

> +
>  	access_rw(vcpu, p, r);
>  	if (p->is_write)
>  		vcpu->arch.flags |= KVM_ARM64_DEBUG_DIRTY;
> -- 
> 2.30.2
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
