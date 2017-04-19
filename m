From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2] KVM: arm/arm64: vgic-v3: De-optimize VMCR
 save/restore when emulating a GICv2
Date: Wed, 19 Apr 2017 16:45:16 +0200
Message-ID: <20170419144516.GD4104@cbox>
References: <20170419111526.21073-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 221A140C30
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Apr 2017 10:42:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rXUs9-rVYZeI for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Apr 2017 10:42:35 -0400 (EDT)
Received: from mail-wr0-f170.google.com (mail-wr0-f170.google.com
 [209.85.128.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9406740C2D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Apr 2017 10:42:35 -0400 (EDT)
Received: by mail-wr0-f170.google.com with SMTP id c55so17123718wrc.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Apr 2017 07:45:14 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170419111526.21073-1-marc.zyngier@arm.com>
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
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Apr 19, 2017 at 12:15:26PM +0100, Marc Zyngier wrote:
> When emulating a GICv2-on-GICv3, special care must be taken to only
> save/restore VMCR_EL2 when ICC_SRE_EL1.SRE is cleared. Otherwise,
> all Group-0 interrupts end-up being delivered as FIQ, which is
> probably not what the guest expects, as demonstrated here with
> an unhappy EFI:
> 
> 	FIQ Exception at 0x000000013BD21CC4
> 
> This means that we cannot perform the load/put trick when dealing
> with VMCR_EL2 (because the host has SRE set), and we have to deal
> with it in the world-switch.
> 
> Fortunately, this is not the most common case (modern guests should
> be able to deal with GICv3 directly), and the performance is not worse
> than what it was before the VMCR optimization.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <cdall@linaro.org>

I have applied both fixes.

Thanks,
-Christoffer

> ---
> * From v1:
>   - Move vgic_sre testing from vgic_{load,put} to vgic_v3_{load,put}
> 
>  virt/kvm/arm/hyp/vgic-v3-sr.c |  8 ++++++--
>  virt/kvm/arm/vgic/vgic-v3.c   | 11 +++++++++--
>  2 files changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
> index 3d0b1ddb6929..91922c1eddc8 100644
> --- a/virt/kvm/arm/hyp/vgic-v3-sr.c
> +++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
> @@ -128,8 +128,10 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
>  	 * Make sure stores to the GIC via the memory mapped interface
>  	 * are now visible to the system register interface.
>  	 */
> -	if (!cpu_if->vgic_sre)
> +	if (!cpu_if->vgic_sre) {
>  		dsb(st);
> +		cpu_if->vgic_vmcr = read_gicreg(ICH_VMCR_EL2);
> +	}
>  
>  	if (used_lrs) {
>  		int i;
> @@ -205,11 +207,13 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
>  	 * delivered as a FIQ to the guest, with potentially fatal
>  	 * consequences. So we must make sure that ICC_SRE_EL1 has
>  	 * been actually programmed with the value we want before
> -	 * starting to mess with the rest of the GIC.
> +	 * starting to mess with the rest of the GIC, and VMCR_EL2 in
> +	 * particular.
>  	 */
>  	if (!cpu_if->vgic_sre) {
>  		write_gicreg(0, ICC_SRE_EL1);
>  		isb();
> +		write_gicreg(cpu_if->vgic_vmcr, ICH_VMCR_EL2);
>  	}
>  
>  	val = read_gicreg(ICH_VTR_EL2);
> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> index bc7010db9f4d..df1503650300 100644
> --- a/virt/kvm/arm/vgic/vgic-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> @@ -373,12 +373,19 @@ void vgic_v3_load(struct kvm_vcpu *vcpu)
>  {
>  	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
>  
> -	kvm_call_hyp(__vgic_v3_write_vmcr, cpu_if->vgic_vmcr);
> +	/*
> +	 * If dealing with a GICv2 emulation on GICv3, VMCR_EL2.VFIQen
> +	 * is dependent on ICC_SRE_EL1.SRE, and we have to perform the
> +	 * VMCR_EL2 save/restore in the world switch.
> +	 */
> +	if (likely(cpu_if->vgic_sre))
> +		kvm_call_hyp(__vgic_v3_write_vmcr, cpu_if->vgic_vmcr);
>  }
>  
>  void vgic_v3_put(struct kvm_vcpu *vcpu)
>  {
>  	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
>  
> -	cpu_if->vgic_vmcr = kvm_call_hyp(__vgic_v3_read_vmcr);
> +	if (likely(cpu_if->vgic_sre))
> +		cpu_if->vgic_vmcr = kvm_call_hyp(__vgic_v3_read_vmcr);
>  }
> -- 
> 2.11.0
> 
