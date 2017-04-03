From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v4 07/28] arm64: KVM: Allow the main HYP code to use the
 init hyp stub implementation
Date: Mon, 3 Apr 2017 19:28:30 +0200
Message-ID: <20170403172830.GC11752@cbox>
References: <20170321192058.9300-1-marc.zyngier@arm.com>
 <20170321192058.9300-8-marc.zyngier@arm.com>
 <20170324143358.GC25903@cbox>
 <84dad7c7-a2fc-7b20-caeb-e3fe02c0a7ec@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CAF8540A74
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Apr 2017 13:26:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3RWW15FtCglS for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Apr 2017 13:26:20 -0400 (EDT)
Received: from mail-wr0-f180.google.com (mail-wr0-f180.google.com
 [209.85.128.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6215240187
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Apr 2017 13:26:19 -0400 (EDT)
Received: by mail-wr0-f180.google.com with SMTP id l43so180907722wre.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 03 Apr 2017 10:28:30 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <84dad7c7-a2fc-7b20-caeb-e3fe02c0a7ec@arm.com>
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
Cc: Russell King <linux@arm.linux.org.uk>, kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, Keerthy <j-keerthy@ti.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 24, 2017 at 02:56:51PM +0000, Marc Zyngier wrote:
> On 24/03/17 14:33, Christoffer Dall wrote:
> > On Tue, Mar 21, 2017 at 07:20:37PM +0000, Marc Zyngier wrote:
> >> We now have a full hyp-stub implementation in the KVM init code,
> >> but the main KVM code only supports HVC_GET_VECTORS, which is not
> >> enough.
> >>
> >> Instead of reinventing the wheel, let's reuse the init implementation
> >> by branching to the idmap page when called with a hyp-stub hypercall.
> >>
> >> Reviewed-by: James Morse <james.morse@arm.com>
> >> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> >> ---
> >>  arch/arm64/kvm/hyp/hyp-entry.S | 24 +++++++++++++++++++-----
> >>  1 file changed, 19 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
> >> index d8ef788646c6..4f34c5996f86 100644
> >> --- a/arch/arm64/kvm/hyp/hyp-entry.S
> >> +++ b/arch/arm64/kvm/hyp/hyp-entry.S
> >> @@ -87,10 +87,24 @@ alternative_endif
> >>  	/* Here, we're pretty sure the host called HVC. */
> >>  	ldp	x0, x1, [sp], #16
> >>  
> >> -	cmp	x0, #HVC_GET_VECTORS
> >> -	b.ne	1f
> >> -	mrs	x0, vbar_el2
> >> -	b	2f
> >> +	/* Check for a stub HVC call */
> >> +	cmp	x0, #HVC_STUB_HCALL_NR
> >> +	b.hs	1f
> >> +
> >> +	/*
> >> +	 * Compute the idmap address of __kvm_handle_stub_hvc and
> >> +	 * jump there. Since we use kimage_voffset, do not use the
> >> +	 * HYP VA for __kvm_handle_stub_hvc, but the kernel VA instead
> >> +	 * (by loading it from the constant pool).
> >> +	 *
> >> +	 * Preserve x0-x4, which may contain stub parameters.
> >> +	 */
> >> +	ldr	x5, =__kvm_handle_stub_hvc
> >> +	ldr_l	x6, kimage_voffset
> > 
> > Isn't it a bit dodgy to just overwrite x5 and x6 in something which is
> > not a function?  I know that in practice this always gets called through
> > a function call and we can rely on the calling convention, but this can
> > break if you issue a hypercall to KVM's HVC sub implementation using
> > inline assembly, I think.
> > 
> > Am I missing something here?
> 
> I don't think you're missing anything. We're definitely relying on
> getting there via a function call which is going to preserve the
> caller-saved registers.
> 
> The only case where we issue a naked HVC call is when we use
> HVC_SOFT_RESTART. At this point, corrupted registers is not much of a worry.
> 
> Now, I see two ways of dealing with this:
> - We save x5/x6 on the stack, restoring them in the stub handler , right
> before the eret
> - Or we simply document the behaviour in asm/virt.h so that people
> adding new stub methods know the restrictions.
> 
> Thoughts?
> 

I'm perfectly happy with documenting the feature and documenting it
here.  It just felt arbitrary to me when I read the code that we could
just step on x5/x6.

Thanks,
-Christoffer
