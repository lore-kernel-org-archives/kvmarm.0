From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 36/37] KVM: arm/arm64: Move VGIC APR save/restore to vgic
 put/load
Date: Sun, 26 Nov 2017 20:55:02 +0100
Message-ID: <20171126195502.GR28855@cbox>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
 <20171012104141.26902-37-christoffer.dall@linaro.org>
 <20171126150925.n2c24dqjh2h4g4wb@yury-thinkpad>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171126150925.n2c24dqjh2h4g4wb@yury-thinkpad>
Sender: kvm-owner@vger.kernel.org
To: Yury Norov <ynorov@caviumnetworks.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Sun, Nov 26, 2017 at 06:09:25PM +0300, Yury Norov wrote:
> On Thu, Oct 12, 2017 at 12:41:40PM +0200, Christoffer Dall wrote:
> > The APRs can only have bits set when the guest acknowledges an interrupt
> > in the LR and can only have a bit cleared when the guest EOIs an
> > interrupt in the LR.  Therefore, if we have no LRs with any
> > pending/active interrupts, the APR cannot change value and there is no
> > need to clear it on every exit from the VM (hint: it will have already
> > been cleared when we exited the guest the last time with the LRs all
> > EOIed).
> > 
> > The only case we need to take care of is when we migrate the VCPU away
> > from a CPU or migrate a new VCPU onto a CPU, or when we return to
> > userspace to capture the state of the VCPU for migration.  To make sure
> > this works, factor out the APR save/restore functionality into separate
> > functions called from the VCPU (and by extension VGIC) put/load hooks.
> > 
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > ---
> >  arch/arm/include/asm/kvm_hyp.h   |   2 +
> >  arch/arm64/include/asm/kvm_hyp.h |   2 +
> >  virt/kvm/arm/hyp/vgic-v3-sr.c    | 123 +++++++++++++++++++++------------------
> >  virt/kvm/arm/vgic/vgic-v2.c      |   7 +--
> >  virt/kvm/arm/vgic/vgic-v3.c      |   5 ++
> >  5 files changed, 77 insertions(+), 62 deletions(-)
> 
> [...]
> 
> > @@ -361,6 +304,72 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
> >  		     ICC_SRE_EL2);
> >  }
> >  
> > +void __hyp_text __vgic_v3_save_aprs(struct kvm_vcpu *vcpu)
> > +{
> > +	struct vgic_v3_cpu_if *cpu_if;
> > +	u64 val;
> > +	u32 nr_pre_bits;
> > +
> > +	vcpu = kern_hyp_va(vcpu);
> > +	cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
> > +
> > +	val = read_gicreg(ICH_VTR_EL2);
> > +	nr_pre_bits = vtr_to_nr_pre_bits(val);
> > +
> > +	switch (nr_pre_bits) {
> > +	case 7:
> > +		cpu_if->vgic_ap0r[3] = __vgic_v3_read_ap0rn(3);
> > +		cpu_if->vgic_ap0r[2] = __vgic_v3_read_ap0rn(2);
> > +	case 6:
> > +		cpu_if->vgic_ap0r[1] = __vgic_v3_read_ap0rn(1);
> > +	default:
> > +		cpu_if->vgic_ap0r[0] = __vgic_v3_read_ap0rn(0);
> > +	}
> > +
> > +	switch (nr_pre_bits) {
> > +	case 7:
> > +		cpu_if->vgic_ap1r[3] = __vgic_v3_read_ap1rn(3);
> > +		cpu_if->vgic_ap1r[2] = __vgic_v3_read_ap1rn(2);
> > +	case 6:
> > +		cpu_if->vgic_ap1r[1] = __vgic_v3_read_ap1rn(1);
> > +	default:
> > +		cpu_if->vgic_ap1r[0] = __vgic_v3_read_ap1rn(0);
> > +	}
> > +}
> 
> What for 2 switch-cases here? At first glance, you can join them:
> 	switch (nr_pre_bits) {
> 	case 7:
> 		cpu_if->vgic_ap0r[3] = __vgic_v3_read_ap0rn(3);
> 		cpu_if->vgic_ap0r[2] = __vgic_v3_read_ap0rn(2);
> 		cpu_if->vgic_ap1r[3] = __vgic_v3_read_ap1rn(3);
> 		cpu_if->vgic_ap1r[2] = __vgic_v3_read_ap1rn(2);
> 	case 6:
> 		cpu_if->vgic_ap0r[1] = __vgic_v3_read_ap0rn(1);
> 		cpu_if->vgic_ap1r[1] = __vgic_v3_read_ap1rn(1);
> 	default:
> 		cpu_if->vgic_ap1r[0] = __vgic_v3_read_ap1rn(0);
> 		cpu_if->vgic_ap0r[0] = __vgic_v3_read_ap0rn(0);
> 	}
> 
> > +
> > +void __hyp_text __vgic_v3_restore_aprs(struct kvm_vcpu *vcpu)
> > +{
> > +	struct vgic_v3_cpu_if *cpu_if;
> > +	u64 val;
> > +	u32 nr_pre_bits;
> > +
> > +	vcpu = kern_hyp_va(vcpu);
> > +	cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
> > +
> > +	val = read_gicreg(ICH_VTR_EL2);
> > +	nr_pre_bits = vtr_to_nr_pre_bits(val);
> > +
> > +	switch (nr_pre_bits) {
> > +	case 7:
> > +		__vgic_v3_write_ap0rn(cpu_if->vgic_ap0r[3], 3);
> > +		__vgic_v3_write_ap0rn(cpu_if->vgic_ap0r[2], 2);
> > +	case 6:
> > +		__vgic_v3_write_ap0rn(cpu_if->vgic_ap0r[1], 1);
> > +	default:
> > +		__vgic_v3_write_ap0rn(cpu_if->vgic_ap0r[0], 0);
> > +	}
> > +
> > +	switch (nr_pre_bits) {
> > +	case 7:
> > +		__vgic_v3_write_ap1rn(cpu_if->vgic_ap1r[3], 3);
> > +		__vgic_v3_write_ap1rn(cpu_if->vgic_ap1r[2], 2);
> > +	case 6:
> > +		__vgic_v3_write_ap1rn(cpu_if->vgic_ap1r[1], 1);
> > +	default:
> > +		__vgic_v3_write_ap1rn(cpu_if->vgic_ap1r[0], 0);
> > +	}
> 
> And here
> 

Sure.

Thanks,
-Christoffer
