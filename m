From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 14/16] KVM: arm64: Take pending SErrors on entry to
 the guest
Date: Tue, 1 Aug 2017 14:53:06 +0200
Message-ID: <20170801125306.GF5176@cbox>
References: <20170728141019.9084-1-james.morse@arm.com>
 <20170728141019.9084-15-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A26749C31
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Aug 2017 08:51:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xc5SEpjMz0sf for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Aug 2017 08:51:55 -0400 (EDT)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B197049C30
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Aug 2017 08:51:55 -0400 (EDT)
Received: by mail-wm0-f47.google.com with SMTP id m85so13872719wma.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 01 Aug 2017 05:53:11 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170728141019.9084-15-james.morse@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Wang Xiongfeng <wangxiongfeng2@huawei.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi James,

On Fri, Jul 28, 2017 at 03:10:17PM +0100, James Morse wrote:
> SErrors due to RAS are either taken as an SError, or deferred because
> of an Error Synchronization Barrier (ESB). Systems that support the RAS
> extensions are very likely to have firmware-first handling of these
> errors, taking all SErrors to EL3.
> 
> Add {I,}ESB support to KVM and be prepared to handle any resulting SError
> if we are notified directly. (i.e. no firmware-first handling). Do this
> for the cases where we can take the SError instead of deferring it.

Sorry, I forgot how this works again.  If we do have firmware-first, are
we sure that the firmware doesn't just emulate the SError to EL2,
resulting in it looking the same whether or not we have firmware-first?
(perhaps the firmware-first thing clearly defines what should happen
when the firmware detects an SError?)

> 
> With VHE KVM is covered by the host's setting of SCTLR_EL1.IESB: unmask
> SError when entering a guest. This will hyp-panic if there was an SError
> pending during world switch (and we don't have firmware first). Make
> sure this only happens when its KVM's 'fault' by adding an ESB to

nit: it's

> __kvm_call_hyp().
> 
> On systems without the RAS extensions a pending SError triggered by KVM's
> world switch will no longer be blamed on the guest, causing a panic
> instead.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> ---
>  arch/arm64/include/asm/assembler.h |  1 +
>  arch/arm64/kvm/hyp.S               |  1 +
>  arch/arm64/kvm/hyp/entry.S         | 18 ++++++++++++++++++
>  3 files changed, 20 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
> index e2bb551f59f7..e440fba6d0fe 100644
> --- a/arch/arm64/include/asm/assembler.h
> +++ b/arch/arm64/include/asm/assembler.h
> @@ -29,6 +29,7 @@
>  #include <asm/page.h>
>  #include <asm/pgtable-hwdef.h>
>  #include <asm/ptrace.h>
> +#include <asm/sysreg.h>
>  #include <asm/thread_info.h>
>  
>  	.macro save_and_disable_daif, flags
> diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
> index 952f6cb9cf72..e96a5f6afecd 100644
> --- a/arch/arm64/kvm/hyp.S
> +++ b/arch/arm64/kvm/hyp.S
> @@ -40,6 +40,7 @@
>   * arch/arm64/kernel/hyp_stub.S.
>   */
>  ENTRY(__kvm_call_hyp)
> +	esb

are esb instructions ignored on earlier versions than ARMv8.2?  (I
couldn't easily determine this from the spec)

So this is not necessarily the world switch path we're entering (as
hinted in the commit message), but we could also be doing TLB
maintenance.  Is this still going to work in that case?

>  alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
>  	hvc	#0
>  	ret
> diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
> index 12ee62d6d410..cec18df5a324 100644
> --- a/arch/arm64/kvm/hyp/entry.S
> +++ b/arch/arm64/kvm/hyp/entry.S
> @@ -49,6 +49,21 @@
>  	ldp	x29, lr,  [\ctxt, #CPU_XREG_OFFSET(29)]
>  .endm
>  
> +/* We have an implicit esb if we have VHE and IESB. */
> +.macro kvm_explicit_esb
> +	alternative_if_not ARM64_HAS_RAS_EXTN
> +	b	998f
> +	alternative_else_nop_endif
> +	alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
> +	esb
> +	b	998f
> +	alternative_else_nop_endif
> +	alternative_if_not ARM64_HAS_IESB
> +	esb
> +	alternative_else_nop_endif
> +998:
> +.endm
> +
>  /*
>   * u64 __guest_enter(struct kvm_vcpu *vcpu,
>   *		     struct kvm_cpu_context *host_ctxt);
> @@ -85,6 +100,9 @@ ENTRY(__guest_enter)
>  	ldr	x18,      [x18, #CPU_XREG_OFFSET(18)]
>  
>  	// Do not touch any register after this!
> +
> +	enable_serror		// Don't defer an IESB SError
> +	kvm_explicit_esb
>  	eret
>  ENDPROC(__guest_enter)
>  
> -- 
> 2.13.2
> 

Thanks,
-Christoffer
