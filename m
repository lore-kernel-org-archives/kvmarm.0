From: Yury Norov <ynorov@caviumnetworks.com>
Subject: Re: [PATCH 36/37] KVM: arm/arm64: Move VGIC APR save/restore to vgic
 put/load
Date: Sun, 26 Nov 2017 18:09:25 +0300
Message-ID: <20171126150925.n2c24dqjh2h4g4wb@yury-thinkpad>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
 <20171012104141.26902-37-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 43F7849DA8
 for <kvmarm@lists.cs.columbia.edu>; Sun, 26 Nov 2017 10:06:54 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YOMmz9k-elLF for <kvmarm@lists.cs.columbia.edu>;
 Sun, 26 Nov 2017 10:06:53 -0500 (EST)
Received: from NAM03-CO1-obe.outbound.protection.outlook.com
 (mail-co1nam03on0053.outbound.protection.outlook.com [104.47.40.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C8D2449DA3
 for <kvmarm@lists.cs.columbia.edu>; Sun, 26 Nov 2017 10:06:52 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20171012104141.26902-37-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Oct 12, 2017 at 12:41:40PM +0200, Christoffer Dall wrote:
> The APRs can only have bits set when the guest acknowledges an interrupt
> in the LR and can only have a bit cleared when the guest EOIs an
> interrupt in the LR.  Therefore, if we have no LRs with any
> pending/active interrupts, the APR cannot change value and there is no
> need to clear it on every exit from the VM (hint: it will have already
> been cleared when we exited the guest the last time with the LRs all
> EOIed).
> 
> The only case we need to take care of is when we migrate the VCPU away
> from a CPU or migrate a new VCPU onto a CPU, or when we return to
> userspace to capture the state of the VCPU for migration.  To make sure
> this works, factor out the APR save/restore functionality into separate
> functions called from the VCPU (and by extension VGIC) put/load hooks.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  arch/arm/include/asm/kvm_hyp.h   |   2 +
>  arch/arm64/include/asm/kvm_hyp.h |   2 +
>  virt/kvm/arm/hyp/vgic-v3-sr.c    | 123 +++++++++++++++++++++------------------
>  virt/kvm/arm/vgic/vgic-v2.c      |   7 +--
>  virt/kvm/arm/vgic/vgic-v3.c      |   5 ++
>  5 files changed, 77 insertions(+), 62 deletions(-)

[...]

> @@ -361,6 +304,72 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
>  		     ICC_SRE_EL2);
>  }
>  
> +void __hyp_text __vgic_v3_save_aprs(struct kvm_vcpu *vcpu)
> +{
> +	struct vgic_v3_cpu_if *cpu_if;
> +	u64 val;
> +	u32 nr_pre_bits;
> +
> +	vcpu = kern_hyp_va(vcpu);
> +	cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
> +
> +	val = read_gicreg(ICH_VTR_EL2);
> +	nr_pre_bits = vtr_to_nr_pre_bits(val);
> +
> +	switch (nr_pre_bits) {
> +	case 7:
> +		cpu_if->vgic_ap0r[3] = __vgic_v3_read_ap0rn(3);
> +		cpu_if->vgic_ap0r[2] = __vgic_v3_read_ap0rn(2);
> +	case 6:
> +		cpu_if->vgic_ap0r[1] = __vgic_v3_read_ap0rn(1);
> +	default:
> +		cpu_if->vgic_ap0r[0] = __vgic_v3_read_ap0rn(0);
> +	}
> +
> +	switch (nr_pre_bits) {
> +	case 7:
> +		cpu_if->vgic_ap1r[3] = __vgic_v3_read_ap1rn(3);
> +		cpu_if->vgic_ap1r[2] = __vgic_v3_read_ap1rn(2);
> +	case 6:
> +		cpu_if->vgic_ap1r[1] = __vgic_v3_read_ap1rn(1);
> +	default:
> +		cpu_if->vgic_ap1r[0] = __vgic_v3_read_ap1rn(0);
> +	}
> +}

What for 2 switch-cases here? At first glance, you can join them:
	switch (nr_pre_bits) {
	case 7:
		cpu_if->vgic_ap0r[3] = __vgic_v3_read_ap0rn(3);
		cpu_if->vgic_ap0r[2] = __vgic_v3_read_ap0rn(2);
		cpu_if->vgic_ap1r[3] = __vgic_v3_read_ap1rn(3);
		cpu_if->vgic_ap1r[2] = __vgic_v3_read_ap1rn(2);
	case 6:
		cpu_if->vgic_ap0r[1] = __vgic_v3_read_ap0rn(1);
		cpu_if->vgic_ap1r[1] = __vgic_v3_read_ap1rn(1);
	default:
		cpu_if->vgic_ap1r[0] = __vgic_v3_read_ap1rn(0);
		cpu_if->vgic_ap0r[0] = __vgic_v3_read_ap0rn(0);
	}

> +
> +void __hyp_text __vgic_v3_restore_aprs(struct kvm_vcpu *vcpu)
> +{
> +	struct vgic_v3_cpu_if *cpu_if;
> +	u64 val;
> +	u32 nr_pre_bits;
> +
> +	vcpu = kern_hyp_va(vcpu);
> +	cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
> +
> +	val = read_gicreg(ICH_VTR_EL2);
> +	nr_pre_bits = vtr_to_nr_pre_bits(val);
> +
> +	switch (nr_pre_bits) {
> +	case 7:
> +		__vgic_v3_write_ap0rn(cpu_if->vgic_ap0r[3], 3);
> +		__vgic_v3_write_ap0rn(cpu_if->vgic_ap0r[2], 2);
> +	case 6:
> +		__vgic_v3_write_ap0rn(cpu_if->vgic_ap0r[1], 1);
> +	default:
> +		__vgic_v3_write_ap0rn(cpu_if->vgic_ap0r[0], 0);
> +	}
> +
> +	switch (nr_pre_bits) {
> +	case 7:
> +		__vgic_v3_write_ap1rn(cpu_if->vgic_ap1r[3], 3);
> +		__vgic_v3_write_ap1rn(cpu_if->vgic_ap1r[2], 2);
> +	case 6:
> +		__vgic_v3_write_ap1rn(cpu_if->vgic_ap1r[1], 1);
> +	default:
> +		__vgic_v3_write_ap1rn(cpu_if->vgic_ap1r[0], 0);
> +	}

And here

Thanks,
Yury

> +}
> +
>  void __hyp_text __vgic_v3_init_lrs(void)
>  {
>  	int max_lr_idx = vtr_to_max_lr_idx(read_gicreg(ICH_VTR_EL2));
> diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
> index df7e03b..c04c3475 100644
> --- a/virt/kvm/arm/vgic/vgic-v2.c
> +++ b/virt/kvm/arm/vgic/vgic-v2.c
> @@ -428,7 +428,6 @@ void vgic_v2_save_state(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm *kvm = vcpu->kvm;
>  	struct vgic_dist *vgic = &kvm->arch.vgic;
> -	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
>  	void __iomem *base = vgic->vctrl_base;
>  	u64 used_lrs = vcpu->arch.vgic_cpu.used_lrs;
>  
> @@ -436,11 +435,8 @@ void vgic_v2_save_state(struct kvm_vcpu *vcpu)
>  		return;
>  
>  	if (used_lrs) {
> -		cpu_if->vgic_apr = readl_relaxed(base + GICH_APR);
>  		save_lrs(vcpu, base);
>  		writel_relaxed(0, base + GICH_HCR);
> -	} else {
> -		cpu_if->vgic_apr = 0;
>  	}
>  }
>  
> @@ -458,7 +454,6 @@ void vgic_v2_restore_state(struct kvm_vcpu *vcpu)
>  
>  	if (used_lrs) {
>  		writel_relaxed(cpu_if->vgic_hcr, base + GICH_HCR);
> -		writel_relaxed(cpu_if->vgic_apr, base + GICH_APR);
>  		for (i = 0; i < used_lrs; i++) {
>  			writel_relaxed(cpu_if->vgic_lr[i],
>  				       base + GICH_LR0 + (i * 4));
> @@ -472,6 +467,7 @@ void vgic_v2_load(struct kvm_vcpu *vcpu)
>  	struct vgic_dist *vgic = &vcpu->kvm->arch.vgic;
>  
>  	writel_relaxed(cpu_if->vgic_vmcr, vgic->vctrl_base + GICH_VMCR);
> +	writel_relaxed(cpu_if->vgic_apr, vgic->vctrl_base + GICH_APR);
>  }
>  
>  void vgic_v2_put(struct kvm_vcpu *vcpu)
> @@ -480,4 +476,5 @@ void vgic_v2_put(struct kvm_vcpu *vcpu)
>  	struct vgic_dist *vgic = &vcpu->kvm->arch.vgic;
>  
>  	cpu_if->vgic_vmcr = readl_relaxed(vgic->vctrl_base + GICH_VMCR);
> +	cpu_if->vgic_apr = readl_relaxed(vgic->vctrl_base + GICH_APR);
>  }
> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> index 0900649..df3a222 100644
> --- a/virt/kvm/arm/vgic/vgic-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> @@ -16,6 +16,7 @@
>  #include <linux/kvm.h>
>  #include <linux/kvm_host.h>
>  #include <kvm/arm_vgic.h>
> +#include <asm/kvm_hyp.h>
>  #include <asm/kvm_mmu.h>
>  #include <asm/kvm_asm.h>
>  
> @@ -544,6 +545,8 @@ void vgic_v3_load(struct kvm_vcpu *vcpu)
>  	 */
>  	if (likely(cpu_if->vgic_sre))
>  		kvm_call_hyp(__vgic_v3_write_vmcr, cpu_if->vgic_vmcr);
> +
> +	kvm_call_hyp(__vgic_v3_restore_aprs, vcpu);
>  }
>  
>  void vgic_v3_put(struct kvm_vcpu *vcpu)
> @@ -552,4 +555,6 @@ void vgic_v3_put(struct kvm_vcpu *vcpu)
>  
>  	if (likely(cpu_if->vgic_sre))
>  		cpu_if->vgic_vmcr = kvm_call_hyp(__vgic_v3_read_vmcr);
> +
> +	kvm_call_hyp(__vgic_v3_save_aprs, vcpu);
>  }
> -- 
> 2.9.0
