From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v5 04/30] arm64: KVM: Hide unsupported AArch64 CPU
 features from guests
Date: Thu, 2 Nov 2017 09:15:57 +0100
Message-ID: <20171102081557.GB20075@cbox>
References: <1509465082-30427-1-git-send-email-Dave.Martin@arm.com>
 <1509465082-30427-5-git-send-email-Dave.Martin@arm.com>
 <20171101044729.GA11166@lvm>
 <20171101102601.GK19485@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171101102601.GK19485@e103592.cambridge.arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arch@vger.kernel.org, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Nov 01, 2017 at 10:26:03AM +0000, Dave Martin wrote:
> On Wed, Nov 01, 2017 at 05:47:29AM +0100, Christoffer Dall wrote:
> > On Tue, Oct 31, 2017 at 03:50:56PM +0000, Dave Martin wrote:
> > > Currently, a guest kernel sees the true CPU feature registers
> > > (ID_*_EL1) when it reads them using MRS instructions.  This means
> > > that the guest may observe features that are present in the
> > > hardware but the host doesn't understand or doesn't provide support
> > > for.  A guest may legimitately try to use such a feature as per the
> > > architecture, but use of the feature may trap instead of working
> > > normally, triggering undef injection into the guest.
> > > 
> > > This is not a problem for the host, but the guest may go wrong when
> > > running on newer hardware than the host knows about.
> > > 
> > > This patch hides from guest VMs any AArch64-specific CPU features
> > > that the host doesn't support, by exposing to the guest the
> > > sanitised versions of the registers computed by the cpufeatures
> > > framework, instead of the true hardware registers.  To achieve
> > > this, HCR_EL2.TID3 is now set for AArch64 guests, and emulation
> > > code is added to KVM to report the sanitised versions of the
> > > affected registers in response to MRS and register reads from
> > > userspace.
> > > 
> > > The affected registers are removed from invariant_sys_regs[] (since
> > > the invariant_sys_regs handling is no longer quite correct for
> > > them) and added to sys_reg_desgs[], with appropriate access(),
> > > get_user() and set_user() methods.  No runtime vcpu storage is
> > > allocated for the registers: instead, they are read on demand from
> > > the cpufeatures framework.  This may need modification in the
> > > future if there is a need for userspace to customise the features
> > > visible to the guest.
> > > 
> > > Attempts by userspace to write the registers are handled similarly
> > > to the current invariant_sys_regs handling: writes are permitted,
> > > but only if they don't attempt to change the value.  This is
> > > sufficient to support VM snapshot/restore from userspace.
> > > 
> > > Because of the additional registers, restoring a VM on an older
> > > kernel may not work unless userspace knows how to handle the extra
> > > VM registers exposed to the KVM user ABI by this patch.
> > > 
> > > Under the principle of least damage, this patch makes no attempt to
> > > handle any of the other registers currently in
> > > invariant_sys_regs[], or to emulate registers for AArch32: however,
> > > these could be handled in a similar way in future, as necessary.
> > > 
> > > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > > Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> > > Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> > > Cc: Christoffer Dall <christoffer.dall@linaro.org>
> > > ---
> > >  arch/arm64/include/asm/sysreg.h |   3 +
> > >  arch/arm64/kvm/hyp/switch.c     |   6 +
> > >  arch/arm64/kvm/sys_regs.c       | 282 +++++++++++++++++++++++++++++++++-------
> > >  3 files changed, 246 insertions(+), 45 deletions(-)
> > > 
> > > diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> > > index 4dceb12..609d59af 100644
> > > --- a/arch/arm64/include/asm/sysreg.h
> > > +++ b/arch/arm64/include/asm/sysreg.h
> > > @@ -149,6 +149,9 @@
> > >  #define SYS_ID_AA64DFR0_EL1		sys_reg(3, 0, 0, 5, 0)
> > >  #define SYS_ID_AA64DFR1_EL1		sys_reg(3, 0, 0, 5, 1)
> > >  
> > > +#define SYS_ID_AA64AFR0_EL1		sys_reg(3, 0, 0, 5, 4)
> > > +#define SYS_ID_AA64AFR1_EL1		sys_reg(3, 0, 0, 5, 5)
> > > +
> > >  #define SYS_ID_AA64ISAR0_EL1		sys_reg(3, 0, 0, 6, 0)
> > >  #define SYS_ID_AA64ISAR1_EL1		sys_reg(3, 0, 0, 6, 1)
> > >  
> > > diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> > > index 945e79c..35a90b8 100644
> > > --- a/arch/arm64/kvm/hyp/switch.c
> > > +++ b/arch/arm64/kvm/hyp/switch.c
> > > @@ -81,11 +81,17 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
> > >  	 * it will cause an exception.
> > >  	 */
> > >  	val = vcpu->arch.hcr_el2;
> > > +
> > >  	if (!(val & HCR_RW) && system_supports_fpsimd()) {
> > >  		write_sysreg(1 << 30, fpexc32_el2);
> > >  		isb();
> > >  	}
> > > +
> > > +	if (val & HCR_RW) /* for AArch64 only: */
> > > +		val |= HCR_TID3; /* TID3: trap feature register accesses */
> > > +
> > 
> > I still think we should set this in vcpu_reset_hcr() and do it once
> > instead of adding code in every iteration of the critical path.
> 
> Dang, I somehow missed this in the last round.
> 
> How about:
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index e5df3fc..c87be0d 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -49,6 +49,14 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
>  		vcpu->arch.hcr_el2 |= HCR_E2H;
>  	if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features))
>  		vcpu->arch.hcr_el2 &= ~HCR_RW;
> +
> +	/*
> +	 * TID3: trap feature register accesses that we virtualise.
> +	 * For now this is conditional, since no AArch32 feature regs
> +	 * are currently virtualised.
> +	 */
> +	if (vcpu->arch.hcr_el2 & HCR_RW)
> +		vcpu->arch.hcr_el2 |= HCR_TID3;
>  }
>  
>  static inline unsigned long vcpu_get_hcr(struct kvm_vcpu *vcpu)
> > 
> > Otherwise this patch looks good to me.
> 
> I'll probably post this as a separate follow-up patch, unless there's
> some other reason for a full respin.
> 

Fine with me, just remember to remove the part of the world-switch that
was added in this patch, as that's what we want to savoid.

Thanks,
-Christoffer
