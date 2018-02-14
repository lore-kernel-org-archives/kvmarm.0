From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 18/41] KVM: arm64: Move userspace system registers
 into separate function
Date: Wed, 14 Feb 2018 12:22:32 +0100
Message-ID: <20180214112232.GN23189@cbox>
References: <20180112120747.27999-1-christoffer.dall@linaro.org>
 <20180112120747.27999-19-christoffer.dall@linaro.org>
 <a51ef563-df38-771a-0b54-5e77d4f34911@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a51ef563-df38-771a-0b54-5e77d4f34911@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Julien Grall <julien.grall@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Feb 09, 2018 at 06:50:14PM +0000, Julien Grall wrote:
> Hi Christoffer,
> 
> On 01/12/2018 12:07 PM, Christoffer Dall wrote:
> >There's a semantic difference between the EL1 registers that control
> >operation of a kernel running in EL1 and EL1 registers that only control
> >userspace execution in EL0.  Since we can defer saving/restoring the
> >latter, move them into their own function.
> >
> >We also take this chance to rename the function saving/restoring the
> >remaining system register to make it clear this function deals with
> >the EL1 system registers.
> >
> >No functional change.
> >
> >Reviewed-by: Andrew Jones <drjones@redhat.com>
> >Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> >---
> >  arch/arm64/kvm/hyp/sysreg-sr.c | 46 +++++++++++++++++++++++++++++++-----------
> >  1 file changed, 34 insertions(+), 12 deletions(-)
> >
> >diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
> >index 848a46eb33bf..99dd50ce483b 100644
> >--- a/arch/arm64/kvm/hyp/sysreg-sr.c
> >+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
> >@@ -34,18 +34,27 @@ static void __hyp_text __sysreg_do_nothing(struct kvm_cpu_context *ctxt) { }
> >  static void __hyp_text __sysreg_save_common_state(struct kvm_cpu_context *ctxt)
> >  {
> >-	ctxt->sys_regs[ACTLR_EL1]	= read_sysreg(actlr_el1);
> 
> I am a bit confused, the comment on top of the function says the host must
> save ACTLR_EL1 in the VHE case. But AFAICT, after this patch the register
> will not get saved in the host context. Did I miss anything?
> 
You're right, there is indeed a functional change here, introduced in
v2.

I have adjusted the commentary and the patch description.

Thanks,
-Christoffer
