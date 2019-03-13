From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: RE: [PATCH] KVM: arm/arm64: Set ICH_HCR_EN in guest anyway when
 using gicv4
Date: Wed, 13 Mar 2019 15:59:33 +0000
Message-ID: <5FC3163CFD30C246ABAA99954A238FA839311C4F@lhreml524-mbs.china.huawei.com>
References: <F348A9E21A573744858FF7E5D32E29D81FEFA462@DGGEMI529-MBX.china.huawei.com>
 <3993685d-a78f-2e73-e22a-8ade3b6a6279@arm.com>
 <d97bd073-8775-f0cf-637a-ea1b04afbd8f@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <d97bd073-8775-f0cf-637a-ea1b04afbd8f@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, "Tangnianyao (ICT)" <tangnianyao@huawei.com>, Christoffer Dall <christoffer.dall@arm.com>, "james.morse@arm.com" <james.morse@arm.com>, "julien.thierry@arm.com" <julien.thierry@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will.deacon@arm.com" <will.deacon@arm.com>, "alex.bennee@linaro.org" <alex.bennee@linaro.org>, "mark.rutland@arm.com" <mark.rutland@arm.com>, "andre.przywara@arm.com" <andre.przywara@arm.com>, Zhangshaokun <zhangshaokun@hisilicon.com>, "keescook@chromium.org" <keescook@chromium.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, linux-kern
Cc: Linuxarm <linuxarm@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

> -----Original Message-----
> From: kvmarm-bounces@lists.cs.columbia.edu
> [mailto:kvmarm-bounces@lists.cs.columbia.edu] On Behalf Of Marc Zyngier
> Sent: 13 March 2019 11:59
> To: Tangnianyao (ICT) <tangnianyao@huawei.com>; Christoffer Dall
> <christoffer.dall@arm.com>; james.morse@arm.com; julien.thierry@arm.com;
> suzuki.poulose@arm.com; catalin.marinas@arm.com; will.deacon@arm.com;
> alex.bennee@linaro.org; mark.rutland@arm.com; andre.przywara@arm.com;
> Zhangshaokun <zhangshaokun@hisilicon.com>; keescook@chromium.org;
> linux-arm-kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] KVM: arm/arm64: Set ICH_HCR_EN in guest anyway when
> using gicv4
> 
> On 12/03/2019 15:48, Marc Zyngier wrote:
> > Nianyao,
> >
> > Please do not send patches as HTML. Or any email as HTML. Please make
> > sure that you only send plain text emails on any mailing list (see point
> > #6 in Documentation/process/submitting-patches.rst).
> >
> > On 12/03/2019 12:22, Tangnianyao (ICT) wrote:
> >> In gicv4, direct vlpi may be forward to PE without using LR or ap_list. If
> >>
> >> ICH_HCR_EL2.En is 0 in guest, direct vlpi cannot be accepted by PE.
> >>
> >> It will take long time for direct vlpi to be forwarded in some cases.
> >>
> >> Direct vlpi has to wait for ICH_HCR_EL2.En=1 where some other interrupts
> >>
> >> using LR need to be forwarded, because in kvm_vgic_flush_hwstate,
> >>
> >> if ap_list is empty, it will return quickly not setting ICH_HCR_EL2.En.
> >>
> >> To fix this, set ICH_HCR_EL2.En to 1 before returning to guest when
> >>
> >> using GICv4.
> >>
> >>
> >>
> >> Signed-off-by: Nianyao Tang <tangnianyao@huawei.com>
> >>
> >> ---
> >>
> >> arch/arm64/include/asm/kvm_asm.h |  1 +
> >>
> >> virt/kvm/arm/hyp/vgic-v3-sr.c    | 10 ++++++++++
> >>
> >> virt/kvm/arm/vgic/vgic-v4.c      |  8 ++++++++
> >>
> >> 3 files changed, 19 insertions(+)
> >>
> >>
> >>
> >> diff --git a/arch/arm64/include/asm/kvm_asm.h
> >> b/arch/arm64/include/asm/kvm_asm.h
> >>
> >> index f5b79e9..0581c4d 100644
> >>
> >> --- a/arch/arm64/include/asm/kvm_asm.h
> >>
> >> +++ b/arch/arm64/include/asm/kvm_asm.h
> >>
> >> @@ -79,6 +79,7 @@
> >>
> >> extern void __vgic_v3_init_lrs(void);
> >>
> >>  extern u32 __kvm_get_mdcr_el2(void);
> >>
> >> +extern void __vgic_v3_write_hcr(u32 vmcr);
> >>
> >>  /* Home-grown __this_cpu_{ptr,read} variants that always work at HYP */
> >>
> >> #define
> >>
> __hyp_this_cpu_ptr(sym)
> 
> >> \
> >>
> >> diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
> >>
> >> index 264d92d..12027af 100644
> >>
> >> --- a/virt/kvm/arm/hyp/vgic-v3-sr.c
> >>
> >> +++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
> >>
> >> @@ -434,6 +434,16 @@ void __hyp_text __vgic_v3_write_vmcr(u32 vmcr)
> >>
> >>        write_gicreg(vmcr, ICH_VMCR_EL2);
> >>
> >> }
> >>
> >> +u64 __hyp_text __vgic_v3_read_hcr(void)
> >>
> >> +{
> >>
> >> +       return read_gicreg(ICH_HCR_EL2);
> >>
> >> +}
> >>
> >> +
> >>
> >> +void __hyp_text __vgic_v3_write_hcr(u32 vmcr)
> >>
> >> +{
> >>
> >> +       write_gicreg(vmcr, ICH_HCR_EL2);
> >>
> >> +}
> >
> > This is HYP code...
> >
> >>
> >> +
> >>
> >> #ifdef CONFIG_ARM64
> >>
> >>  static int __hyp_text __vgic_v3_bpr_min(void)
> >>
> >> diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
> >>
> >> index 1ed5f22..515171a 100644
> >>
> >> --- a/virt/kvm/arm/vgic/vgic-v4.c
> >>
> >> +++ b/virt/kvm/arm/vgic/vgic-v4.c
> >>
> >> @@ -208,6 +208,8 @@ int vgic_v4_sync_hwstate(struct kvm_vcpu *vcpu)
> >>
> >>        if (!vgic_supports_direct_msis(vcpu->kvm))
> >>
> >>                 return 0;
> >>
> >> +       __vgic_v3_write_hcr(vcpu->arch.vgic_cpu.vgic_v3.vgic_hcr &
> >> ~ICH_HCR_EN);
> >
> > And you've now crashed your non-VHE system by branching directly to code
> > that cannot be executed at EL1.
> >
> >>
> >> +
> >>
> >>        return its_schedule_vpe(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe,
> false);
> >>
> >> }
> >>
> >> @@ -220,6 +222,12 @@ int vgic_v4_flush_hwstate(struct kvm_vcpu *vcpu)
> >>
> >>                 return 0;
> >>
> >>         /*
> >>
> >> +       * Enable ICH_HCR_EL.En so that guest can accpet and handle
> direct
> >>
> >> +       * vlpi.
> >>
> >> +       */
> >>
> >> +       __vgic_v3_write_hcr(vcpu->arch.vgic_cpu.vgic_v3.vgic_hcr);
> >>
> >> +
> >>
> >> +       /*
> >>
> >>         * Before making the VPE resident, make sure the redistributor
> >>
> >>         * corresponding to our current CPU expects us here. See the
> >>
> >>         * doc in drivers/irqchip/irq-gic-v4.c to understand how this
> >>
> >> --
> >>
> >> 1.9.1
> >>
> >>
> >>
> >>
> >>
> >
> > Overall, this looks like the wrong approach. It is not the GICv4 code's
> > job to do this, but the low-level code (either the load/put code for VHE
> > or the save/restore code for non-VHE).
> >
> > It would certainly help if you could describe which context you're in
> > (VHE, non-VHE). I suppose the former...
> 
> Can you please give the following patch a go? I can't test it, but hopefully
> you can.

Thanks for your quick response. I just did a quick test on one of our platforms
with VHE+GICv4 and it seems to fix the performance issue we were seeing
when GICv4 is enabled.

Test setup:

Host connected to a PC over a 10G port.
Launch Guest with an assigned vf dev.
Run iperf from Guest,

5.0 kernel:
[ ID]  Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec  1.30 GBytes  1.12 Gbits/sec

+Patch:

[ ID] 	Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec  10.9 GBytes  9.39 Gbits/sec

Cheers,
Shameer

> Thanks,
> 
> 	M.
> 
> diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
> index 9652c453480f..3c3f7cda95c7 100644
> --- a/virt/kvm/arm/hyp/vgic-v3-sr.c
> +++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
> @@ -222,7 +222,7 @@ void __hyp_text __vgic_v3_save_state(struct
> kvm_vcpu *vcpu)
>  		}
>  	}
> 
> -	if (used_lrs) {
> +	if (used_lrs || cpu_if->its_vpe.its_vm) {
>  		int i;
>  		u32 elrsr;
> 
> @@ -247,7 +247,7 @@ void __hyp_text __vgic_v3_restore_state(struct
> kvm_vcpu *vcpu)
>  	u64 used_lrs = vcpu->arch.vgic_cpu.used_lrs;
>  	int i;
> 
> -	if (used_lrs) {
> +	if (used_lrs || cpu_if->its_vpe.its_vm) {
>  		write_gicreg(cpu_if->vgic_hcr, ICH_HCR_EL2);
> 
>  		for (i = 0; i < used_lrs; i++)
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index abd9c7352677..3af69f2a3866 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c
> @@ -867,15 +867,21 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu
> *vcpu)
>  	 * either observe the new interrupt before or after doing this check,
>  	 * and introducing additional synchronization mechanism doesn't change
>  	 * this.
> +	 *
> +	 * Note that we still need to go through the whole thing if anything
> +	 * can be directly injected (GICv4).
>  	 */
> -	if (list_empty(&vcpu->arch.vgic_cpu.ap_list_head))
> +	if (list_empty(&vcpu->arch.vgic_cpu.ap_list_head) &&
> +	    !vgic_supports_direct_msis(vcpu->kvm))
>  		return;
> 
>  	DEBUG_SPINLOCK_BUG_ON(!irqs_disabled());
> 
> -	raw_spin_lock(&vcpu->arch.vgic_cpu.ap_list_lock);
> -	vgic_flush_lr_state(vcpu);
> -	raw_spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
> +	if (!list_empty(&vcpu->arch.vgic_cpu.ap_list_head)) {
> +		raw_spin_lock(&vcpu->arch.vgic_cpu.ap_list_lock);
> +		vgic_flush_lr_state(vcpu);
> +		raw_spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
> +	}
> 
>  	if (can_access_vgic_from_kernel())
>  		vgic_restore_state(vcpu);
> 
> 
> --
> Jazz is not dead. It just smells funny...
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
