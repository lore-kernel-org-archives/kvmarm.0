From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH] arm64: KVM: Hide PMU from guests when disabled
Date: Mon, 8 Jan 2018 15:56:29 +0100
Message-ID: <20180108145629.ctdcitinneq2kd74@kamzik.brq.redhat.com>
References: <20171125174031.13117-1-drjones@redhat.com>
 <20180108141815.GA15307@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180108141815.GA15307@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, cdall@linaro.org, marc.zyngier@arm.com, Dave.Martin@arm.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jan 08, 2018 at 03:18:15PM +0100, Christoffer Dall wrote:
> Hi Drew,
> 
> On Sat, Nov 25, 2017 at 06:40:31PM +0100, Andrew Jones wrote:
> > Since commit 93390c0a1b20 ("arm64: KVM: Hide unsupported AArch64 CPU
> > features from guests") we can hide cpu features from guests. Apply
> > this to a long standing issue where guests see a PMU available, but
> > it's not, because it was not enabled by KVM's userspace.
> > 
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 35 +++++++++++++++++++++--------------
> >  1 file changed, 21 insertions(+), 14 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 1830ebc227d1..503144f13af0 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -881,18 +881,25 @@ static bool access_cntp_cval(struct kvm_vcpu *vcpu,
> >  }
> >  
> >  /* Read a sanitised cpufeature ID register by sys_reg_desc */
> > -static u64 read_id_reg(struct sys_reg_desc const *r, bool raz)
> > +static u64 read_id_reg(struct kvm_vcpu *vcpu,
> > +		       struct sys_reg_desc const *r,
> > +		       bool raz)
> >  {
> >  	u32 id = sys_reg((u32)r->Op0, (u32)r->Op1,
> >  			 (u32)r->CRn, (u32)r->CRm, (u32)r->Op2);
> >  	u64 val = raz ? 0 : read_sanitised_ftr_reg(id);
> >  
> > -	if (id == SYS_ID_AA64PFR0_EL1) {
> > +	switch (id) {
> > +	case SYS_ID_AA64DFR0_EL1:
> > +		if (!kvm_arm_pmu_v3_ready(vcpu))
> > +			val &= ~(0xfUL << ID_AA64DFR0_PMUVER_SHIFT);
> 
> This is actually problematic, becuase it can break migration.  If
> user space reads the guest state at some point after the guest has been
> started with vPMU enabled, but then tries to restore the state before
> creating a pmu, then we get an error.  See below...
> 
> > +		break;
> > +	case SYS_ID_AA64PFR0_EL1:
> >  		if (val & (0xfUL << ID_AA64PFR0_SVE_SHIFT))
> >  			pr_err_once("kvm [%i]: SVE unsupported for guests, suppressing\n",
> >  				    task_pid_nr(current));
> > -
> >  		val &= ~(0xfUL << ID_AA64PFR0_SVE_SHIFT);
> > +		break;
> >  	}
> >  
> >  	return val;
> > @@ -908,7 +915,7 @@ static bool __access_id_reg(struct kvm_vcpu *vcpu,
> >  	if (p->is_write)
> >  		return write_to_read_only(vcpu, p, r);
> >  
> > -	p->regval = read_id_reg(r, raz);
> > +	p->regval = read_id_reg(vcpu, r, raz);
> >  	return true;
> >  }
> >  
> > @@ -937,17 +944,17 @@ static u64 sys_reg_to_index(const struct sys_reg_desc *reg);
> >   * are stored, and for set_id_reg() we don't allow the effective value
> >   * to be changed.
> >   */
> > -static int __get_id_reg(const struct sys_reg_desc *rd, void __user *uaddr,
> > -			bool raz)
> > +static int __get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> > +			void __user *uaddr, bool raz)
> >  {
> >  	const u64 id = sys_reg_to_index(rd);
> > -	const u64 val = read_id_reg(rd, raz);
> > +	const u64 val = read_id_reg(vcpu, rd, raz);
> >  
> >  	return reg_to_user(uaddr, &val, id);
> >  }
> >  
> > -static int __set_id_reg(const struct sys_reg_desc *rd, void __user *uaddr,
> > -			bool raz)
> > +static int __set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> > +			void __user *uaddr, bool raz)
> >  {
> >  	const u64 id = sys_reg_to_index(rd);
> >  	int err;
> > @@ -958,7 +965,7 @@ static int __set_id_reg(const struct sys_reg_desc *rd, void __user *uaddr,
> >  		return err;
> >  
> >  	/* This is what we mean by invariant: you can't change it. */
> > -	if (val != read_id_reg(rd, raz))
> > +	if (val != read_id_reg(vcpu, rd, raz))
> 
> So since we modified read_id_reg above for the PMU, we have now broken
> migration, because we've introduced an implicit ordering requirement for
> creating the PMU.
> 
> One way to handle this is to remove this check at this point and verify
> integrity when we're about to run a VCPU, but that changes behavior and
> we've been happy with the invariant checks so far.
> 
> Perhaps a better approach is to let userspace write ID register values
> that can be hidden, and then simply mask of features when the guest is
> running which would allow snapshotting the id register values any time
> before/after adding all features/peripherals to the VCPUs.
> 
> Thoughts?
> 
> I'll drop this patch from queue and next for now until we have a better
> solution.

Argh, sorry about this. I'll revisit it soon.

Thanks,
drew
