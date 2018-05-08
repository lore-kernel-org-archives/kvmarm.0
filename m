From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v5 13/14] KVM: arm64: Fold redundant exit code checks out
 of fixup_guest_exit()
Date: Tue, 8 May 2018 12:30:39 +0100
Message-ID: <20180508113039.GF7753@e103592.cambridge.arm.com>
References: <1525449935-31424-1-git-send-email-Dave.Martin@arm.com>
 <1525449935-31424-14-git-send-email-Dave.Martin@arm.com>
 <eddc101f-6f6c-a37b-ae48-e80a24f60815@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <eddc101f-6f6c-a37b-ae48-e80a24f60815@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Christoffer Dall <cdall@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, May 08, 2018 at 11:59:25AM +0100, Marc Zyngier wrote:
> On 04/05/18 17:05, Dave Martin wrote:
> > The entire tail of fixup_guest_exit() is contained in if statements
> > of the form if (x && *exit_code == ARM_EXCEPTION_TRAP).  As a result,
> > we can check just once and bail out of the function early, allowing
> > the remaining if conditions to be simplified.
> > 
> > The only awkward case is where *exit_code is changed to
> > ARM_EXCEPTION_EL1_SERROR in the case of an illegal GICv2 CPU
> > interface access: in that case, the GICv3 trap handling code is
> > skipped using a goto.  This avoids pointlessly evaluating the
> > static branch check for the GICv3 case, even though we can't have
> > vgic_v2_cpuif_trap and vgic_v3_cpuif_trap true simultaneously
> > unless we have a GICv3 and GICv2 on the host: that sounds stupid,
> > but I haven't satisfied myself that it can't happen.
> 
> Indeed, this cannot happen, unless we decided to trap access to the
> memory-mapped interface of a GICv3 implementation. We don't do that.
> 
> But I guess the goto also serves a visual clue that the two cases are
> mutually exclusives. Small nit below though:
> 
> > 
> > No functional change.
> > 
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > ---
> >  arch/arm64/kvm/hyp/switch.c | 11 +++++++----
> >  1 file changed, 7 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> > index 39e9166..be09c52 100644
> > --- a/arch/arm64/kvm/hyp/switch.c
> > +++ b/arch/arm64/kvm/hyp/switch.c
> > @@ -385,11 +385,13 @@ static bool __hyp_text fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
> >  	 * same PC once the SError has been injected, and replay the
> >  	 * trapping instruction.
> >  	 */
> > -	if (*exit_code == ARM_EXCEPTION_TRAP && !__populate_fault_info(vcpu))
> > +	if (*exit_code != ARM_EXCEPTION_TRAP)
> > +		goto exit;
> > +
> > +	if (!__populate_fault_info(vcpu))
> >  		return true;
> >  
> > -	if (static_branch_unlikely(&vgic_v2_cpuif_trap) &&
> > -	    *exit_code == ARM_EXCEPTION_TRAP) {
> > +	if (static_branch_unlikely(&vgic_v2_cpuif_trap)) {
> >  		bool valid;
> >  
> >  		valid = kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_DABT_LOW &&
> > @@ -414,12 +416,12 @@ static bool __hyp_text fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
> >  				if (!__skip_instr(vcpu))
> >  					*vcpu_cpsr(vcpu) &= ~DBG_SPSR_SS;
> >  				*exit_code = ARM_EXCEPTION_EL1_SERROR;
> > +				goto exit;
> 
> This goto...
> 
> >  			}
> 
> ... should be placed here. If this was a data abort, it cannot be a
> system register trap, and the below conditions cannot possibly apply.

That sounds logically sensible, but to be clear, this would be a
semantic change to this function, right?

(i.e., it forces skipping of the GICv3 handling code in a case where
it previously wasn't forced -- at least not within this function.  The
arguments about whether vgic_v2_cpuif_trap and vgic_v3_cpuif_trap can
ever be true simultaneously still apply.)


Cheers
---Dave
