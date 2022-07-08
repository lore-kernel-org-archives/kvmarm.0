Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1227FC43334
	for <kvmarm@archiver.kernel.org>; Mon, 11 Jul 2022 09:43:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BAAD74B9B3;
	Mon, 11 Jul 2022 05:43:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gb6nKaiot1z7; Mon, 11 Jul 2022 05:43:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 112AE4BA95;
	Mon, 11 Jul 2022 05:42:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E028B4B575
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jul 2022 15:39:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BYI3lA7R1aEW for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Jul 2022 15:39:04 -0400 (EDT)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 85C094B573
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jul 2022 15:39:04 -0400 (EDT)
Date: Fri, 8 Jul 2022 12:38:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1657309143;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=5d+WLe+pPY6KD27qmvuAK3CNfwmt7KukfTGSfmdEEk0=;
 b=O+oE0vNQ4vaiyzdkCSa3zinQVkgkJGpPNH4goYM/n1VCvZVp0tbhLxGq0GGCXGWRA8pYm2
 y4jgINWRB5Fur+TSByewkHAAP2IYoqP5DhFVzGgav4qkm60izuYgZSuIQN/F7qFAxcTjjh
 x/wDgti3OfeHGRzaQjDyjQpyuGTmg9E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 07/19] KVM: arm64: vgic-v3: Simplify
 vgic_v3_has_cpu_sysregs_attr()
Message-ID: <YsiH0lLs+wXX+rUU@google.com>
References: <20220706164304.1582687-1-maz@kernel.org>
 <20220706164304.1582687-8-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220706164304.1582687-8-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Mailman-Approved-At: Mon, 11 Jul 2022 05:42:55 -0400
Cc: kvm@vger.kernel.org, kernel-team@android.com, Schspa Shi <schspa@gmail.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Wed, Jul 06, 2022 at 05:42:52PM +0100, Marc Zyngier wrote:
> Finding out whether a sysreg exists has little to do with that
> register being accessed, so drop the is_write parameter.
> 
> Also, the reg pointer is completely unused, and we're better off
> just passing the attr pointer to the function.
> 
> This result in a small cleanup of the calling site, with a new
> helper converting the vGIC view of a sysreg into the canonical
> one (this is purely cosmetic, as the encoding is the same).
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

> ---
>  arch/arm64/kvm/vgic-sys-reg-v3.c   | 14 ++++++++++----
>  arch/arm64/kvm/vgic/vgic-mmio-v3.c |  8 ++------
>  arch/arm64/kvm/vgic/vgic.h         |  3 +--
>  3 files changed, 13 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic-sys-reg-v3.c b/arch/arm64/kvm/vgic-sys-reg-v3.c
> index 644acda33c7c..85a5e1d15e9f 100644
> --- a/arch/arm64/kvm/vgic-sys-reg-v3.c
> +++ b/arch/arm64/kvm/vgic-sys-reg-v3.c
> @@ -260,12 +260,18 @@ static const struct sys_reg_desc gic_v3_icc_reg_descs[] = {
>  	{ SYS_DESC(SYS_ICC_IGRPEN1_EL1), access_gic_grpen1 },
>  };
>  
> -int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, bool is_write, u64 id,
> -				u64 *reg)
> +static u64 attr_to_id(u64 attr)
>  {
> -	u64 sysreg = (id & KVM_DEV_ARM_VGIC_SYSREG_MASK) | KVM_REG_SIZE_U64;
> +	return ARM64_SYS_REG(FIELD_GET(KVM_REG_ARM_VGIC_SYSREG_OP0_MASK, attr),
> +			     FIELD_GET(KVM_REG_ARM_VGIC_SYSREG_OP1_MASK, attr),
> +			     FIELD_GET(KVM_REG_ARM_VGIC_SYSREG_CRN_MASK, attr),
> +			     FIELD_GET(KVM_REG_ARM_VGIC_SYSREG_CRM_MASK, attr),
> +			     FIELD_GET(KVM_REG_ARM_VGIC_SYSREG_OP2_MASK, attr));
> +}
>  
> -	if (get_reg_by_id(sysreg, gic_v3_icc_reg_descs,
> +int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
> +{
> +	if (get_reg_by_id(attr_to_id(attr->attr), gic_v3_icc_reg_descs,
>  			  ARRAY_SIZE(gic_v3_icc_reg_descs)))
>  		return 0;
>  
> diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> index f15e29cc63ce..a2ff73899976 100644
> --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> @@ -986,12 +986,8 @@ int vgic_v3_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr)
>  		iodev.base_addr = 0;
>  		break;
>  	}
> -	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS: {
> -		u64 reg, id;
> -
> -		id = (attr->attr & KVM_DEV_ARM_VGIC_SYSREG_INSTR_MASK);
> -		return vgic_v3_has_cpu_sysregs_attr(vcpu, 0, id, &reg);
> -	}
> +	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
> +		return vgic_v3_has_cpu_sysregs_attr(vcpu, attr);
>  	default:
>  		return -ENXIO;
>  	}
> diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
> index 4c6bdd321faa..ffc2d3c81b28 100644
> --- a/arch/arm64/kvm/vgic/vgic.h
> +++ b/arch/arm64/kvm/vgic/vgic.h
> @@ -247,8 +247,7 @@ int vgic_v3_redist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
>  			 int offset, u32 *val);
>  int vgic_v3_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu, bool is_write,
>  			 u64 id, u64 *val);
> -int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, bool is_write, u64 id,
> -				u64 *reg);
> +int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
>  int vgic_v3_line_level_info_uaccess(struct kvm_vcpu *vcpu, bool is_write,
>  				    u32 intid, u64 *val);
>  int kvm_register_vgic_device(unsigned long type);
> -- 
> 2.34.1
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
