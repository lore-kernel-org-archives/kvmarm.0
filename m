From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [RFC PATCH] arm64: KVM: Allow userspace to configure guest
 MPIDR_EL1
Date: Wed, 20 Apr 2016 15:38:38 +0100
Message-ID: <20160420143838.GB15229@leverpostej>
References: <1461161319-38835-1-git-send-email-ashoks@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 559D449B21
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Apr 2016 10:37:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id D0lY1ofhiI-P for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Apr 2016 10:37:01 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B2B704998D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Apr 2016 10:37:01 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1461161319-38835-1-git-send-email-ashoks@broadcom.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Ashok Kumar <ashoks@broadcom.com>
Cc: marc.zyngier@arm.com, will.deacon@arm.com, shannon.zhao@linaro.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Apr 20, 2016 at 07:08:39AM -0700, Ashok Kumar wrote:
> For guests with NUMA configuration, Node ID needs to
> be recorded in the respective affinity byte of MPIDR_EL1.

The MPIDR.Aff* fields are effectively arbitrary, and do not encode NUMA
topology information. They may describe some level of closeness of CPUs
relative to each other, but that is independent of the memory hierarchy,
and even then is unfortunately not all that informative.

NUMA topology information has to come from FW. With ACPI that's
SRAT+SLIT, and with DT that's something like [1].

There may be reasons to want to configure the MPIDR_EL1.Aff* fields, but
this is not required for NUMA, nor is it a good idea for an OS to assume
NUMA topology from the MPIDR_EL1.Aff* fields.

Thanks,
Mark.

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2016-April/420900.html

> 
> Cache the MPIDR_EL1 programmed by userspace and use it for
> subsequent reset_mpidr calls.
> 
> Signed-off-by: Ashok Kumar <ashoks@broadcom.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  1 +
>  arch/arm64/kvm/sys_regs.c         | 44 ++++++++++++++++++++++++++++-----------
>  2 files changed, 33 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index f5c6bd2..1fc723d 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -197,6 +197,7 @@ struct kvm_vcpu_arch {
>  	/* HYP configuration */
>  	u64 hcr_el2;
>  	u32 mdcr_el2;
> +	u64 vmpidr_el2;
>  
>  	/* Exception Information */
>  	struct kvm_vcpu_fault_info fault;
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 7bbe3ff..468f251 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -424,21 +424,29 @@ static void reset_amair_el1(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  	vcpu_sys_reg(vcpu, AMAIR_EL1) = amair;
>  }
>  
> +static int set_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> +		     const struct kvm_one_reg *reg, void __user *uaddr);
> +
>  static void reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  {
>  	u64 mpidr;
>  
> -	/*
> -	 * Map the vcpu_id into the first three affinity level fields of
> -	 * the MPIDR. We limit the number of VCPUs in level 0 due to a
> -	 * limitation to 16 CPUs in that level in the ICC_SGIxR registers
> -	 * of the GICv3 to be able to address each CPU directly when
> -	 * sending IPIs.
> -	 */
> -	mpidr = (vcpu->vcpu_id & 0x0f) << MPIDR_LEVEL_SHIFT(0);
> -	mpidr |= ((vcpu->vcpu_id >> 4) & 0xff) << MPIDR_LEVEL_SHIFT(1);
> -	mpidr |= ((vcpu->vcpu_id >> 12) & 0xff) << MPIDR_LEVEL_SHIFT(2);
> -	vcpu_sys_reg(vcpu, MPIDR_EL1) = (1ULL << 31) | mpidr;
> +	if (!vcpu->arch.vmpidr_el2) {
> +		/*
> +		 * Map the vcpu_id into the first three affinity level fields of
> +		 * the MPIDR. We limit the number of VCPUs in level 0 due to a
> +		 * limitation to 16 CPUs in that level in the ICC_SGIxR registers
> +		 * of the GICv3 to be able to address each CPU directly when
> +		 * sending IPIs.
> +		 */
> +		mpidr = (vcpu->vcpu_id & 0x0f) << MPIDR_LEVEL_SHIFT(0);
> +		mpidr |= ((vcpu->vcpu_id >> 4) & 0xff) << MPIDR_LEVEL_SHIFT(1);
> +		mpidr |= ((vcpu->vcpu_id >> 12) & 0xff) << MPIDR_LEVEL_SHIFT(2);
> +		vcpu_sys_reg(vcpu, MPIDR_EL1) = (1ULL << 31) | mpidr;
> +	} else {
> +		/* use the userspace configured value */
> +		vcpu_sys_reg(vcpu, MPIDR_EL1) = vcpu->arch.vmpidr_el2;
> +	}
>  }
>  
>  static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> @@ -902,7 +910,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  
>  	/* MPIDR_EL1 */
>  	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0000), Op2(0b101),
> -	  NULL, reset_mpidr, MPIDR_EL1 },
> +	  NULL, reset_mpidr, MPIDR_EL1, 0, NULL, set_mpidr },
>  	/* SCTLR_EL1 */
>  	{ Op0(0b11), Op1(0b000), CRn(0b0001), CRm(0b0000), Op2(0b000),
>  	  access_vm_reg, reset_val, SCTLR_EL1, 0x00C50078 },
> @@ -2034,6 +2042,18 @@ static int demux_c15_set(u64 id, void __user *uaddr)
>  	}
>  }
>  
> +static int set_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> +		     const struct kvm_one_reg *reg, void __user *uaddr)
> +{
> +	int ret;
> +
> +	ret = reg_from_user(&vcpu_sys_reg(vcpu, rd->reg), uaddr, reg->id);
> +	if (!ret)
> +		vcpu->arch.vmpidr_el2 = vcpu_sys_reg(vcpu, rd->reg);
> +
> +	return ret;
> +}
> +
>  int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  {
>  	const struct sys_reg_desc *r;
> -- 
> 2.1.0
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
