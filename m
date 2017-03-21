From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 5/5] KVM: arm/arm64: vgic: Get rid of struct vmcr for GICv2
Date: Tue, 21 Mar 2017 14:36:00 +0000
Message-ID: <8db97d92-be13-2e9a-90c6-e834e442ba5e@arm.com>
References: <20170321110530.15857-1-cdall@linaro.org>
 <20170321110530.15857-6-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A45C40BDE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 10:34:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id F-J8yZTHUP8y for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Mar 2017 10:34:17 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED40440BDA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 10:34:16 -0400 (EDT)
In-Reply-To: <20170321110530.15857-6-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Andre Przywara <andre.przywara@arm.com>, Vijaya.Kumar@cavium.com, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 21/03/17 11:05, Christoffer Dall wrote:
> There is no common code in the VGIC that uses the VMCR, so we have no
> use of the intermediate architecture-agnostic representation of the VMCR
> and might as well manipulate the bits specifically using the logic for
> the version of the GIC that the code supports.
> 
> For GICv2, this means translating between the GICH_VMCR register format
> stored in memory and the GICC_X registers exported to user space, with
> the annoying quirk around the format of the GICC_PMR, where we export
> the 8 bit prority field using the lower 5 bits and always assuming
> bits[2:0] are clear.
> 
> This now lets us get completely rid of struct vmcr and its common
> accessor functions.
> 
> Signed-off-by: Christoffer Dall <cdall@linaro.org>
> ---
>  virt/kvm/arm/vgic/vgic-mmio-v2.c | 51 +++++++++++++++++++++++++++++-----------
>  virt/kvm/arm/vgic/vgic-mmio.c    | 16 -------------
>  virt/kvm/arm/vgic/vgic-v2.c      | 29 -----------------------
>  virt/kvm/arm/vgic/vgic.h         | 14 -----------
>  4 files changed, 37 insertions(+), 73 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> index a3ad7ff..1bdb990 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> @@ -219,23 +219,33 @@ static void vgic_mmio_write_sgipends(struct kvm_vcpu *vcpu,
>  static unsigned long vgic_mmio_read_vcpuif(struct kvm_vcpu *vcpu,
>  					   gpa_t addr, unsigned int len)
>  {
> -	struct vgic_vmcr vmcr;
> +	u32 vmcr = vcpu->arch.vgic_cpu.vgic_v2.vgic_vmcr;
>  	u32 val;
>  
> -	vgic_get_vmcr(vcpu, &vmcr);
>  
>  	switch (addr & 0xff) {
>  	case GIC_CPU_CTRL:
> -		val = vmcr.ctlr;
> +		val = (vmcr & GICH_VMCR_CTRL_MASK) >>
> +			GICH_VMCR_CTRL_SHIFT;
>  		break;
>  	case GIC_CPU_PRIMASK:
> -		val = vmcr.pmr;
> +		/*
> +		 * Our KVM_DEV_TYPE_ARM_VGIC_V2 device ABI exports the
> +		 * the PMR field as GICH_VMCR.VMPriMask rather than
> +		 * GICC_PMR.Priority, so we expose the upper five bits of
> +		 * priority mask to userspace using the lower bits in the
> +		 * 32-bit word provided by userspace.
> +		 */
> +		val = (vmcr & GICH_VMCR_PRIMASK_MASK) >>
> +			GICH_VMCR_PRIMASK_SHIFT;
>  		break;
>  	case GIC_CPU_BINPOINT:
> -		val = vmcr.bpr;
> +		val = (vmcr & GICH_VMCR_BINPOINT_MASK) >>
> +			GICH_VMCR_BINPOINT_SHIFT;
>  		break;
>  	case GIC_CPU_ALIAS_BINPOINT:
> -		val = vmcr.abpr;
> +		val = (vmcr & GICH_VMCR_ALIAS_BINPOINT_MASK) >>
> +			GICH_VMCR_ALIAS_BINPOINT_SHIFT;
>  		break;
>  	case GIC_CPU_IDENT:
>  		val = ((PRODUCT_ID_KVM << 20) |
> @@ -253,26 +263,39 @@ static void vgic_mmio_write_vcpuif(struct kvm_vcpu *vcpu,
>  				   gpa_t addr, unsigned int len,
>  				   unsigned long val)
>  {
> -	struct vgic_vmcr vmcr;
> -
> -	vgic_get_vmcr(vcpu, &vmcr);
> +	u32 *vmcr = &vcpu->arch.vgic_cpu.vgic_v2.vgic_vmcr;
> +	u32 mask, field;
>  
>  	switch (addr & 0xff) {
>  	case GIC_CPU_CTRL:
> -		vmcr.ctlr = val;
> +		mask = GICH_VMCR_CTRL_MASK;
> +		field = val << GICH_VMCR_CTRL_SHIFT;
>  		break;
>  	case GIC_CPU_PRIMASK:
> -		vmcr.pmr = val;
> +		/*
> +		 * Our KVM_DEV_TYPE_ARM_VGIC_V2 device ABI exports the
> +		 * the PMR field as GICH_VMCR.VMPriMask rather than
> +		 * GICC_PMR.Priority, so we obtain the upper five bits of
> +		 * priority mask from userspace using the lower bits in the
> +		 * 32-bit word provided by userspace.
> +		 */
> +		mask = GICH_VMCR_PRIMASK_MASK;
> +		field = val << GICH_VMCR_PRIMASK_SHIFT;
>  		break;
>  	case GIC_CPU_BINPOINT:
> -		vmcr.bpr = val;
> +		mask = GICH_VMCR_BINPOINT_MASK;
> +		field = val << GICH_VMCR_BINPOINT_SHIFT;
>  		break;
>  	case GIC_CPU_ALIAS_BINPOINT:
> -		vmcr.abpr = val;
> +		mask = GICH_VMCR_ALIAS_BINPOINT_MASK;
> +		field = val << GICH_VMCR_ALIAS_BINPOINT_SHIFT;
>  		break;
> +	default:
> +		return;


Something seems fishy here. If I have a GICv2-on-GICv3, my vmcr is still
that of a GICv3, not of a GICv2. Here, you're cramming everything into a
v2 representation, which is not going to work on GICv3.

Or am I missing something?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
