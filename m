From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [RFC PATCH v2 3/3] KVM: arm64: Optimise FPSIMD handling to
 reduce guest/host thrashing
Date: Mon, 9 Apr 2018 11:23:19 +0100
Message-ID: <20180409102317.GT16308@e103592.cambridge.arm.com>
References: <1523026864-15413-1-git-send-email-Dave.Martin@arm.com>
 <1523026864-15413-4-git-send-email-Dave.Martin@arm.com>
 <20180409094818.GB10904@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180409094818.GB10904@cbox>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Christoffer Dall <cdall@kernel.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Apr 09, 2018 at 11:48:18AM +0200, Christoffer Dall wrote:

[...]

> > diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> > index 8605e04..797b259 100644
> > --- a/arch/arm64/kvm/hyp/switch.c
> > +++ b/arch/arm64/kvm/hyp/switch.c
> > @@ -27,6 +27,7 @@
> >  #include <asm/kvm_mmu.h>
> >  #include <asm/fpsimd.h>
> >  #include <asm/debug-monitors.h>
> > +#include <asm/thread_info.h>
> >  
> >  static bool __hyp_text __fpsimd_enabled_nvhe(void)
> >  {
> > @@ -47,24 +48,40 @@ bool __hyp_text __fpsimd_enabled(void)
> >  	return __fpsimd_is_enabled()();
> >  }
> >  
> > -static void __hyp_text __activate_traps_vhe(void)
> > +static bool update_fp_enabled(struct kvm_vcpu *vcpu)
> > +{
> > +	if (vcpu->arch.host_thread_info->flags & _TIF_FOREIGN_FPSTATE) {
> > +		vcpu->arch.host_fpsimd_state = NULL;
> 
> I can't see where host_fpsimd_state gets set to anything else than NULL,
> what am I missing?

It's set in kvm_arch_vcpu_load_fp().  Once we enter the run loop the
pointer can only be changed to NULL, because the host state only needs
to be saved once.

Cheers
---Dave
