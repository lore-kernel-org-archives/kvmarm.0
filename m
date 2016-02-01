From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 06/21] arm64: KVM: VHE: Patch out use of HVC
Date: Mon, 1 Feb 2016 16:39:12 +0100
Message-ID: <20160201153912.GD1478@cbox>
References: <1453737235-16522-1-git-send-email-marc.zyngier@arm.com>
 <1453737235-16522-7-git-send-email-marc.zyngier@arm.com>
 <20160201131634.GI1478@cbox> <56AF5ED8.7010303@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 27C5840F9B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Feb 2016 10:33:30 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BDANVQzmqBup for <kvmarm@lists.cs.columbia.edu>;
 Mon,  1 Feb 2016 10:33:29 -0500 (EST)
Received: from mail-wm0-f42.google.com (mail-wm0-f42.google.com [74.125.82.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2AF4A40BDA
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Feb 2016 10:33:28 -0500 (EST)
Received: by mail-wm0-f42.google.com with SMTP id p63so76465694wmp.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 01 Feb 2016 07:38:47 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <56AF5ED8.7010303@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Feb 01, 2016 at 01:34:16PM +0000, Marc Zyngier wrote:
> On 01/02/16 13:16, Christoffer Dall wrote:
> > On Mon, Jan 25, 2016 at 03:53:40PM +0000, Marc Zyngier wrote:
> >> With VHE, the host never issues an HVC instruction to get into the
> >> KVM code, as we can simply branch there.
> >>
> >> Use runtime code patching to simplify things a bit.
> >>
> >> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> >> ---
> >>  arch/arm64/kvm/hyp.S           |  7 +++++++
> >>  arch/arm64/kvm/hyp/hyp-entry.S | 38 +++++++++++++++++++++++++++++---------
> >>  2 files changed, 36 insertions(+), 9 deletions(-)
> >>
> >> diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
> >> index 0ccdcbb..0689a74 100644
> >> --- a/arch/arm64/kvm/hyp.S
> >> +++ b/arch/arm64/kvm/hyp.S
> >> @@ -17,7 +17,9 @@
> >>  
> >>  #include <linux/linkage.h>
> >>  
> >> +#include <asm/alternative.h>
> >>  #include <asm/assembler.h>
> >> +#include <asm/cpufeature.h>
> >>  
> >>  /*
> >>   * u64 kvm_call_hyp(void *hypfn, ...);
> >> @@ -38,6 +40,11 @@
> >>   * arch/arm64/kernel/hyp_stub.S.
> >>   */
> >>  ENTRY(kvm_call_hyp)
> >> +alternative_if_not ARM64_HAS_VIRT_HOST_EXTN	
> >>  	hvc	#0
> >>  	ret
> >> +alternative_else
> >> +	b	__vhe_hyp_call
> >> +	nop
> >> +alternative_endif
> >>  ENDPROC(kvm_call_hyp)
> >> diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
> >> index 93e8d983..9e0683f 100644
> >> --- a/arch/arm64/kvm/hyp/hyp-entry.S
> >> +++ b/arch/arm64/kvm/hyp/hyp-entry.S
> >> @@ -38,6 +38,32 @@
> >>  	ldp	x0, x1, [sp], #16
> >>  .endm
> >>  
> >> +.macro do_el2_call
> >> +	/*
> >> +	 * Shuffle the parameters before calling the function
> >> +	 * pointed to in x0. Assumes parameters in x[1,2,3].
> >> +	 */
> >> +	stp	lr, xzr, [sp, #-16]!
> > 
> > remind me why this pair isn't just doing "str" instead of "stp" with the
> > xzr ?
> 
> Because SP has to be aligned on a 16 bytes boundary at all times.
> 

right, duh.

> > 
> >> +	mov	lr, x0
> >> +	mov	x0, x1
> >> +	mov	x1, x2
> >> +	mov	x2, x3
> >> +	blr	lr
> >> +	ldp	lr, xzr, [sp], #16
> >> +.endm
> >> +
> >> +ENTRY(__vhe_hyp_call)
> >> +	do_el2_call
> >> +	/*
> >> +	 * We used to rely on having an exception return to get
> >> +	 * an implicit isb. In the E2H case, we don't have it anymore.
> >> +	 * rather than changing all the leaf functions, just do it here
> >> +	 * before returning to the rest of the kernel.
> >> +	 */
> > 
> > why is this not the case with an ISB before do_el2_call then?
> 
> That's a good point. I guess the safest thing to do would be to add one,
> but looking at the various functions we call, I don't see any that could
> go wrong by not having a ISB in their prologue.
> 
> Or maybe you've identified such a case?
> 
I think I argued on Mario's VFP patches that we could rely on an ISB
before the hyp call, but they're not merged yet, so, hey...

-Christoffer
