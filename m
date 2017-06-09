From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v3 13/27] KVM: arm64: vgic-v3: Add ICV_BPR0_EL1 handler
Date: Fri, 9 Jun 2017 17:29:59 +0200
Message-ID: <20170609152959.GF11099@cbox>
References: <20170609114956.25963-1-marc.zyngier@arm.com>
 <20170609114956.25963-14-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 48FD940625
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Jun 2017 11:25:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JL2CFJzEJyTY for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Jun 2017 11:25:49 -0400 (EDT)
Received: from mail-wr0-f171.google.com (mail-wr0-f171.google.com
 [209.85.128.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 175EC405DA
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Jun 2017 11:25:48 -0400 (EDT)
Received: by mail-wr0-f171.google.com with SMTP id q97so37198462wrb.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 09 Jun 2017 08:30:00 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170609114956.25963-14-marc.zyngier@arm.com>
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

On Fri, Jun 09, 2017 at 12:49:42PM +0100, Marc Zyngier wrote:
> Add a handler for reading/writing the guest's view of the ICC_BPR0_EL1
> register, which is located in the ICH_VMCR_EL2.BPR0 field.
> 
> Tested-by: Alexander Graf <agraf@suse.de>
> Acked-by: David Daney <david.daney@cavium.com>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <cdall@linaro.org>

> ---
>  arch/arm64/include/asm/sysreg.h |  1 +
>  virt/kvm/arm/hyp/vgic-v3-sr.c   | 28 ++++++++++++++++++++++++++++
>  2 files changed, 29 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index bd000686194a..d20be0b28ca4 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -180,6 +180,7 @@
>  
>  #define SYS_VBAR_EL1			sys_reg(3, 0, 12, 0, 0)
>  
> +#define SYS_ICC_BPR0_EL1		sys_reg(3, 0, 12, 8, 3)
>  #define SYS_ICC_AP1Rn_EL1(n)		sys_reg(3, 0, 12, 9, n)
>  #define SYS_ICC_DIR_EL1			sys_reg(3, 0, 12, 11, 1)
>  #define SYS_ICC_SGI1R_EL1		sys_reg(3, 0, 12, 11, 5)
> diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
> index a2a62f030341..f53908cc981c 100644
> --- a/virt/kvm/arm/hyp/vgic-v3-sr.c
> +++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
> @@ -706,11 +706,33 @@ static void __hyp_text __vgic_v3_write_igrpen1(struct kvm_vcpu *vcpu, u32 vmcr,
>  	__vgic_v3_write_vmcr(vmcr);
>  }
>  
> +static void __hyp_text __vgic_v3_read_bpr0(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
> +{
> +	vcpu_set_reg(vcpu, rt, __vgic_v3_get_bpr0(vmcr));
> +}
> +
>  static void __hyp_text __vgic_v3_read_bpr1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
>  {
>  	vcpu_set_reg(vcpu, rt, __vgic_v3_get_bpr1(vmcr));
>  }
>  
> +static void __hyp_text __vgic_v3_write_bpr0(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
> +{
> +	u64 val = vcpu_get_reg(vcpu, rt);
> +	u8 bpr_min = __vgic_v3_bpr_min() - 1;
> +
> +	/* Enforce BPR limiting */
> +	if (val < bpr_min)
> +		val = bpr_min;
> +
> +	val <<= ICH_VMCR_BPR0_SHIFT;
> +	val &= ICH_VMCR_BPR0_MASK;
> +	vmcr &= ~ICH_VMCR_BPR0_MASK;
> +	vmcr |= val;
> +
> +	__vgic_v3_write_vmcr(vmcr);
> +}
> +
>  static void __hyp_text __vgic_v3_write_bpr1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
>  {
>  	u64 val = vcpu_get_reg(vcpu, rt);
> @@ -888,6 +910,12 @@ int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
>  	case SYS_ICC_HPPIR1_EL1:
>  		fn = __vgic_v3_read_hppir;
>  		break;
> +	case SYS_ICC_BPR0_EL1:
> +		if (is_read)
> +			fn = __vgic_v3_read_bpr0;
> +		else
> +			fn = __vgic_v3_write_bpr0;
> +		break;
>  	default:
>  		return 0;
>  	}
> -- 
> 2.11.0
> 
