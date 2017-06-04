From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 05/25] KVM: arm64: vgic-v3: Add ICV_BPR1_EL1 handler
Date: Sun, 4 Jun 2017 22:25:28 +0200
Message-ID: <20170604202528.GH9464@cbox>
References: <20170601102117.17750-1-marc.zyngier@arm.com>
 <20170601102117.17750-6-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DD75A40C4A
 for <kvmarm@lists.cs.columbia.edu>; Sun,  4 Jun 2017 16:21:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YYx7k7JNFiF9 for <kvmarm@lists.cs.columbia.edu>;
 Sun,  4 Jun 2017 16:21:42 -0400 (EDT)
Received: from mail-wm0-f42.google.com (mail-wm0-f42.google.com [74.125.82.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C2F1840BBC
 for <kvmarm@lists.cs.columbia.edu>; Sun,  4 Jun 2017 16:21:42 -0400 (EDT)
Received: by mail-wm0-f42.google.com with SMTP id b84so59390696wmh.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 04 Jun 2017 13:25:45 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170601102117.17750-6-marc.zyngier@arm.com>
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

On Thu, Jun 01, 2017 at 11:20:57AM +0100, Marc Zyngier wrote:
> Add a handler for reading/writing the guest's view of the ICC_BPR1_EL1
> register, which is located in the ICH_VMCR_EL2.BPR1 field.
> 
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/hyp/vgic-v3-sr.c | 51 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 51 insertions(+)
> 
> diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
> index 943bf11252d9..6254eaf72a77 100644
> --- a/virt/kvm/arm/hyp/vgic-v3-sr.c
> +++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
> @@ -375,6 +375,51 @@ void __hyp_text __vgic_v3_write_vmcr(u32 vmcr)
>  
>  #ifdef CONFIG_ARM64
>  
> +static unsigned int __hyp_text __vgic_v3_get_bpr0(u32 vmcr)
> +{
> +	return (vmcr & ICH_VMCR_BPR0_MASK) >> ICH_VMCR_BPR0_SHIFT;
> +}
> +
> +static unsigned int __hyp_text __vgic_v3_get_bpr1(u32 vmcr)
> +{
> +	unsigned int bpr;
> +
> +	if (vmcr & ICH_VMCR_CBPR_MASK) {
> +		bpr = __vgic_v3_get_bpr0(vmcr);
> +		if (bpr < 7)
> +			bpr++;
> +	} else {
> +		bpr = (vmcr & ICH_VMCR_BPR1_MASK) >> ICH_VMCR_BPR1_SHIFT;
> +	}
> +
> +	return bpr;
> +}
> +
> +static void __hyp_text __vgic_v3_read_bpr1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
> +{
> +	vcpu_set_reg(vcpu, rt, __vgic_v3_get_bpr1(vmcr));
> +}
> +
> +static void __hyp_text __vgic_v3_write_bpr1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
> +{
> +	u64 val = vcpu_get_reg(vcpu, rt);
> +	u8 bpr_min = 8 - vtr_to_nr_pre_bits(read_gicreg(ICH_VTR_EL2));

I can't seem to find where this behavior is documented, is it that 8 is
the theoretical max, and it's the upper preemption levels that apply, so
it must be 8 - number supported?

> +
> +	if (vmcr & ICH_VMCR_CBPR_MASK)
> +		return;
> +
> +	/* Enforce BPR limiting */
> +	if (val < bpr_min)
> +		val = bpr_min;

Are we not implying that the reset value here also means bpr_min?  I
also can't seem to find this behavior in the spec and it appears we rely
on the underlying hardware to set a reset value (by setting vmcr=0 on
first run).  Could this result in a guest observing one reset value,
writing 0 to this register, and observing another one?

> +
> +	val <<= ICH_VMCR_BPR1_SHIFT;
> +	val &= ICH_VMCR_BPR1_MASK;
> +	vmcr &= ~ICH_VMCR_BPR1_MASK;
> +	vmcr |= val;
> +
> +	__vgic_v3_write_vmcr(vmcr);
> +}
> +
>  int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
>  {
>  	int rt;
> @@ -397,6 +442,12 @@ int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
>  	is_read = (esr & ESR_ELx_SYS64_ISS_DIR_MASK) == ESR_ELx_SYS64_ISS_DIR_READ;
>  
>  	switch (sysreg) {
> +	case SYS_ICC_BPR1_EL1:
> +		if (is_read)
> +			fn = __vgic_v3_read_bpr1;
> +		else
> +			fn = __vgic_v3_write_bpr1;
> +		break;

Did you consider a lookup table with the sysreg encoding, the read
function, and the right function as each entry?  It may compress the
code a bit, but I'm not sure if it's nicer or worth it.

>  	default:
>  		return 0;
>  	}
> -- 
> 2.11.0
> 

Thanks,
-Christoffer
