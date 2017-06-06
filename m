From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 14/25] KVM: arm64: vgic-v3: Add ICV_IGNREN0_EL1 handler
Date: Tue, 6 Jun 2017 15:22:46 +0200
Message-ID: <20170606132246.GW9464@cbox>
References: <20170601102117.17750-1-marc.zyngier@arm.com>
 <20170601102117.17750-15-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC70940CE9
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Jun 2017 09:18:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bWW1gE7UqZtA for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Jun 2017 09:18:53 -0400 (EDT)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C1B6740C5A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Jun 2017 09:18:53 -0400 (EDT)
Received: by mail-wm0-f50.google.com with SMTP id m7so28339508wmg.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 06 Jun 2017 06:22:59 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170601102117.17750-15-marc.zyngier@arm.com>
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

On Thu, Jun 01, 2017 at 11:21:06AM +0100, Marc Zyngier wrote:
> Add a handler for reading/writing the guest's view of the ICC_IGRPEN0_EL1
> register, which is located in the ICH_VMCR_EL2.VENG0 field.
> 
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <cdall@linaro.org>

> ---
>  arch/arm64/include/asm/sysreg.h |  1 +
>  virt/kvm/arm/hyp/vgic-v3-sr.c   | 23 +++++++++++++++++++++++
>  2 files changed, 24 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index d20be0b28ca4..ba93bc7ac8e4 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -190,6 +190,7 @@
>  #define SYS_ICC_BPR1_EL1		sys_reg(3, 0, 12, 12, 3)
>  #define SYS_ICC_CTLR_EL1		sys_reg(3, 0, 12, 12, 4)
>  #define SYS_ICC_SRE_EL1			sys_reg(3, 0, 12, 12, 5)
> +#define SYS_ICC_GRPEN0_EL1		sys_reg(3, 0, 12, 12, 6)
>  #define SYS_ICC_GRPEN1_EL1		sys_reg(3, 0, 12, 12, 7)
>  
>  #define SYS_CONTEXTIDR_EL1		sys_reg(3, 0, 13, 0, 1)
> diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
> index 54a8e828c85b..b1b9129da045 100644
> --- a/virt/kvm/arm/hyp/vgic-v3-sr.c
> +++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
> @@ -671,11 +671,28 @@ static void __hyp_text __vgic_v3_write_eoir(struct kvm_vcpu *vcpu, u32 vmcr, int
>  	__vgic_v3_clear_active_lr(lr, lr_val);
>  }
>  
> +static void __hyp_text __vgic_v3_read_igrpen0(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
> +{
> +	vcpu_set_reg(vcpu, rt, !!(vmcr & ICH_VMCR_ENG0_MASK));
> +}
> +
>  static void __hyp_text __vgic_v3_read_igrpen1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
>  {
>  	vcpu_set_reg(vcpu, rt, !!(vmcr & ICH_VMCR_ENG1_MASK));
>  }
>  
> +static void __hyp_text __vgic_v3_write_igrpen0(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
> +{
> +	u64 val = vcpu_get_reg(vcpu, rt);
> +
> +	if (val & 1)
> +		vmcr |= ICH_VMCR_ENG0_MASK;
> +	else
> +		vmcr &= ~ICH_VMCR_ENG0_MASK;
> +
> +	__vgic_v3_write_vmcr(vmcr);
> +}
> +
>  static void __hyp_text __vgic_v3_write_igrpen1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
>  {
>  	u64 val = vcpu_get_reg(vcpu, rt);
> @@ -900,6 +917,12 @@ int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
>  	case SYS_ICC_HPPIR1_EL1:
>  		fn = __vgic_v3_read_hppir;
>  		break;
> +	case SYS_ICC_GRPEN0_EL1:
> +		if (is_read)
> +			fn = __vgic_v3_read_igrpen0;
> +		else
> +			fn = __vgic_v3_write_igrpen0;
> +		break;
>  	case SYS_ICC_BPR0_EL1:
>  		if (is_read)
>  			fn = __vgic_v3_read_bpr0;
> -- 
> 2.11.0
> 
