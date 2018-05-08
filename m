From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v5 13/14] KVM: arm64: Fold redundant exit code checks out
 of fixup_guest_exit()
Date: Tue, 8 May 2018 13:30:31 +0100
Message-ID: <20180508123031.GI7753@e103592.cambridge.arm.com>
References: <1525449935-31424-1-git-send-email-Dave.Martin@arm.com>
 <1525449935-31424-14-git-send-email-Dave.Martin@arm.com>
 <eddc101f-6f6c-a37b-ae48-e80a24f60815@arm.com>
 <20180508113039.GF7753@e103592.cambridge.arm.com>
 <5b9460e5-207d-befd-446c-b9c7ec2bcc35@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <5b9460e5-207d-befd-446c-b9c7ec2bcc35@arm.com>
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
Cc: Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <cdall@kernel.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, May 08, 2018 at 12:59:39PM +0100, Marc Zyngier wrote:
> On 08/05/18 12:30, Dave Martin wrote:
> > On Tue, May 08, 2018 at 11:59:25AM +0100, Marc Zyngier wrote:
> >> On 04/05/18 17:05, Dave Martin wrote:

[...]

> >>> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> >>> index 39e9166..be09c52 100644
> >>> --- a/arch/arm64/kvm/hyp/switch.c
> >>> +++ b/arch/arm64/kvm/hyp/switch.c
> >>> @@ -385,11 +385,13 @@ static bool __hyp_text fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
> >>>  	 * same PC once the SError has been injected, and replay the
> >>>  	 * trapping instruction.
> >>>  	 */
> >>> -	if (*exit_code == ARM_EXCEPTION_TRAP && !__populate_fault_info(vcpu))
> >>> +	if (*exit_code != ARM_EXCEPTION_TRAP)
> >>> +		goto exit;
> >>> +
> >>> +	if (!__populate_fault_info(vcpu))
> >>>  		return true;
> >>>  
> >>> -	if (static_branch_unlikely(&vgic_v2_cpuif_trap) &&
> >>> -	    *exit_code == ARM_EXCEPTION_TRAP) {
> >>> +	if (static_branch_unlikely(&vgic_v2_cpuif_trap)) {
> >>>  		bool valid;
> >>>  
> >>>  		valid = kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_DABT_LOW &&
> >>> @@ -414,12 +416,12 @@ static bool __hyp_text fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
> >>>  				if (!__skip_instr(vcpu))
> >>>  					*vcpu_cpsr(vcpu) &= ~DBG_SPSR_SS;
> >>>  				*exit_code = ARM_EXCEPTION_EL1_SERROR;
> >>> +				goto exit;
> >>
> >> This goto...
> >>
> >>>  			}
> >>
> >> ... should be placed here. If this was a data abort, it cannot be a
> >> system register trap, and the below conditions cannot possibly apply.
> > 
> > That sounds logically sensible, but to be clear, this would be a
> > semantic change to this function, right?
> > 
> > (i.e., it forces skipping of the GICv3 handling code in a case where
> > it previously wasn't forced -- at least not within this function.  The
> > arguments about whether vgic_v2_cpuif_trap and vgic_v3_cpuif_trap can
> > ever be true simultaneously still apply.)
> 
> I agree that this is a slight semantic change, but one that makes sense,
> just like the one you've introduced in patch #12.

Agreed, just wanted to make sure I hadn't missed something in my
original refactoring.

Cheers
---Dave
