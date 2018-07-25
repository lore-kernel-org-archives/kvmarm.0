From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [RFC PATCH 11/16] KVM: arm64/sve: System register context switch
 and access support
Date: Wed, 25 Jul 2018 12:45:01 +0100
Message-ID: <20180725114501.GH4240@e103592.cambridge.arm.com>
References: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
 <1529593060-542-12-git-send-email-Dave.Martin@arm.com>
 <20180719111117.qztdqqhco7klvfhz@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E2B540A50
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jul 2018 07:45:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2xd5pau80fTn for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Jul 2018 07:45:06 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EC8A40493
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jul 2018 07:45:06 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180719111117.qztdqqhco7klvfhz@kamzik.brq.redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jul 19, 2018 at 01:11:17PM +0200, Andrew Jones wrote:
> On Thu, Jun 21, 2018 at 03:57:35PM +0100, Dave Martin wrote:
> > This patch adds the necessary support for context switching ZCR_EL1
> > for each vcpu.
> > 
> > The ID_AA64PFR0_EL1 emulation code is updated to expose the
> > presence of SVE to the guest if appropriate, and ioctl() access to
> > ZCR_EL1 is also added.
> > 
> > In the context switch code itself, ZCR_EL1 is context switched if
> > the host is SVE-capable, irrespectively for now of whether SVE is
> > exposed to the guest or not.  Adding a dynamic vcpu_has_sve() check
> > may lose as much performance as would be gained in this simple
> > case.
> > 
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>

[...]

> >  #define SCTLR_ELx_IESB	(1 << 21)
> > diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
> > index 35bc168..0f4046a 100644
> > --- a/arch/arm64/kvm/hyp/sysreg-sr.c
> > +++ b/arch/arm64/kvm/hyp/sysreg-sr.c
> > @@ -21,6 +21,7 @@
> >  #include <asm/kvm_asm.h>
> >  #include <asm/kvm_emulate.h>
> >  #include <asm/kvm_hyp.h>
> > +#include <asm/sysreg.h>
> >  
> >  /*
> >   * Non-VHE: Both host and guest must save everything.
> > @@ -57,6 +58,8 @@ static void __hyp_text __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
> >  	ctxt->sys_regs[SCTLR_EL1]	= read_sysreg_el1(sctlr);
> >  	ctxt->sys_regs[ACTLR_EL1]	= read_sysreg(actlr_el1);
> >  	ctxt->sys_regs[CPACR_EL1]	= read_sysreg_el1(cpacr);
> > +	if (system_supports_sve()) /* implies has_vhe() */
> > +		ctxt->sys_regs[ZCR_EL1]	= read_sysreg_s(SYS_ZCR_EL12);
> >  	ctxt->sys_regs[TTBR0_EL1]	= read_sysreg_el1(ttbr0);
> >  	ctxt->sys_regs[TTBR1_EL1]	= read_sysreg_el1(ttbr1);
> >  	ctxt->sys_regs[TCR_EL1]		= read_sysreg_el1(tcr);
> > @@ -129,6 +132,8 @@ static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
> >  	write_sysreg_el1(ctxt->sys_regs[SCTLR_EL1],	sctlr);
> >  	write_sysreg(ctxt->sys_regs[ACTLR_EL1],	  	actlr_el1);
> >  	write_sysreg_el1(ctxt->sys_regs[CPACR_EL1],	cpacr);
> > +	if (system_supports_sve()) /* implies has_vhe() */
> > +		write_sysreg_s(ctxt->sys_regs[ZCR_EL1],	SYS_ZCR_EL12);
> 
> I feel like the ZCR_EL12 save/restores are out of place, as these
> functions are shared by non-VHE and VHE. Maybe they should be
> moved to the VHE callers?

Hmmm, you're right -- it did look a bit odd at the time.

I think they should move to the vhe-specific paths as you suggest.

I'll change this for the next spin of the series.

Cheers
---Dave
