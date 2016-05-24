From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 7/7] arm64: KVM: vgic-v3: Relax synchronization when
 SRE==1
Date: Tue, 24 May 2016 15:18:38 +0200
Message-ID: <20160524131838.GH3582@cbox>
References: <1464007023-11736-1-git-send-email-marc.zyngier@arm.com>
 <1464007023-11736-8-git-send-email-marc.zyngier@arm.com>
 <20160524125233.GG3582@cbox>
 <574450DB.5010409@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <574450DB.5010409@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, May 24, 2016 at 02:02:19PM +0100, Marc Zyngier wrote:
> On 24/05/16 13:52, Christoffer Dall wrote:
> > On Mon, May 23, 2016 at 01:37:03PM +0100, Marc Zyngier wrote:
> >> The GICv3 backend of the vgic is quite barrier heavy, in order
> >> to ensure synchronization of the system registers and the
> >> memory mapped view for a potential GICv2 guest.
> >>
> >> But when the guest is using a GICv3 model, there is absolutely
> >> no need to execute all these heavy barriers, and it is actually
> >> beneficial to avoid them altogether.
> >>
> >> This patch makes the synchonization conditional, and ensures
> >> that we do not change the EL1 SRE settings if we do not need to.
> >>
> >> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> >> ---
> >>  arch/arm64/kvm/hyp/vgic-v3-sr.c | 23 ++++++++++++++++-------
> >>  1 file changed, 16 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> >> index 40c3b4c..5f8f80b 100644
> >> --- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
> >> +++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> >> @@ -169,7 +169,8 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
> >>  	 * Make sure stores to the GIC via the memory mapped interface
> >>  	 * are now visible to the system register interface.
> >>  	 */
> >> -	dsb(st);
> >> +	if (!cpu_if->vgic_sre)
> >> +		dsb(st);
> >>  
> >>  	cpu_if->vgic_vmcr  = read_gicreg(ICH_VMCR_EL2);
> >>  
> >> @@ -235,8 +236,12 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
> >>  
> >>  	val = read_gicreg(ICC_SRE_EL2);
> >>  	write_gicreg(val | ICC_SRE_EL2_ENABLE, ICC_SRE_EL2);
> >> -	isb(); /* Make sure ENABLE is set at EL2 before setting SRE at EL1 */
> >> -	write_gicreg(1, ICC_SRE_EL1);
> >> +
> >> +	if (!cpu_if->vgic_sre) {
> >> +		/* Make sure ENABLE is set at EL2 before setting SRE at EL1 */
> >> +		isb();
> >> +		write_gicreg(1, ICC_SRE_EL1);
> > 
> > why the change in behavior to only write 1 to the register when
> > (!cpu_if->vgic_sre) ?
> 
> If we're on a GICv3 host and emulating a GICv3 guest, then we never
> changed the SRE mode (i.e. it is still set to 1). The only case we
> change it is when we when have a GICv2 guest (i.e. when vgic_sre is zero).
> 
> So there is no need to restore the host configuration unless we actually
> changed it...
> 
> > 
> >> +	}
> >>  }
> >>  
> >>  void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
> >> @@ -255,8 +260,10 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
> >>  	 * been actually programmed with the value we want before
> >>  	 * starting to mess with the rest of the GIC.
> >>  	 */
> >> -	write_gicreg(cpu_if->vgic_sre, ICC_SRE_EL1);
> >> -	isb();
> >> +	if (!cpu_if->vgic_sre) {
> >> +		write_gicreg(0, ICC_SRE_EL1);
> >> +		isb();
> >> +	}
> 
> ... here.
> 
> Does it make sense? I could also split this as part of another patch if
> you think that's clearer.

No makes totally sense, I just didn't see it because I'm GICed these
days.

Thanks for the explanation, and:

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
