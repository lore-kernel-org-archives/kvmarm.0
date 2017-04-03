From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v4 19/28] ARM: KVM: Allow the main HYP code to use the
 init hyp stub implementation
Date: Mon, 3 Apr 2017 19:32:25 +0200
Message-ID: <20170403173225.GD11752@cbox>
References: <20170321192058.9300-1-marc.zyngier@arm.com>
 <20170321192058.9300-20-marc.zyngier@arm.com>
 <20170324143432.GD25903@cbox>
 <00380529-bee2-ba10-548d-319bc4fa5c1b@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4404040A74
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Apr 2017 13:30:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BV6+d57uqRiN for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Apr 2017 13:30:15 -0400 (EDT)
Received: from mail-wr0-f175.google.com (mail-wr0-f175.google.com
 [209.85.128.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 237A140187
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Apr 2017 13:30:14 -0400 (EDT)
Received: by mail-wr0-f175.google.com with SMTP id w11so177964530wrc.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 03 Apr 2017 10:32:25 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <00380529-bee2-ba10-548d-319bc4fa5c1b@arm.com>
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

On Fri, Mar 24, 2017 at 03:01:23PM +0000, Marc Zyngier wrote:
> On 24/03/17 14:34, Christoffer Dall wrote:
> > On Tue, Mar 21, 2017 at 07:20:49PM +0000, Marc Zyngier wrote:
> >> We now have a full hyp-stub implementation in the KVM init code,
> >> but the main KVM code only supports HVC_GET_VECTORS, which is not
> >> enough.
> >>
> >> Instead of reinventing the wheel, let's reuse the init implementation
> >> by branching to the idmap page when called with a hyp-stub hypercall.
> >>
> >> Tested-by: Keerthy <j-keerthy@ti.com>
> >> Acked-by: Russell King <rmk+kernel@armlinux.org.uk>
> >> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> >> ---
> >>  arch/arm/kvm/hyp/hyp-entry.S | 29 ++++++++++++++++++++++++-----
> >>  1 file changed, 24 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/arch/arm/kvm/hyp/hyp-entry.S b/arch/arm/kvm/hyp/hyp-entry=
.S
> >> index 1f8db7d21fc5..a35baa81fd23 100644
> >> --- a/arch/arm/kvm/hyp/hyp-entry.S
> >> +++ b/arch/arm/kvm/hyp/hyp-entry.S
> >> @@ -126,11 +126,30 @@ hyp_hvc:
> >>  	 */
> >>  	pop	{r0, r1, r2}
> >>  =

> >> -	/* Check for __hyp_get_vectors */
> >> -	cmp	r0, #HVC_GET_VECTORS
> >> -	mrceq	p15, 4, r0, c12, c0, 0	@ get HVBAR
> >> -	beq	1f
> >> +	/*
> >> +	 * Check if we have a kernel function, which is guaranteed to be
> >> +	 * bigger than the maximum hyp stub hypercall
> >> +	 */
> >> +	cmp	r0, #HVC_STUB_HCALL_NR
> >> +	bhs	1f
> >>  =

> >> +	/*
> >> +	 * Not a kernel function, treat it as a stub hypercall.
> >> +	 * Compute the physical address for __kvm_handle_stub_hvc
> >> +	 * (as the code lives in the idmaped page) and branch there.
> >> +	 * We hijack ip (r12) as a tmp register.
> >> +	 */
> > =

> > How can we just clobber r12 and be sure we don't corrupt the caller?
> =

> r12 (aka ip) is allowed to be clobbered by the linker (used by inserted
> code veneers, for example). Given that this is a standalone object, we
> can safely assume that r12 has been saved if it was used by the caller.
> =

> Here is what the PCS says:
> =

> "Register r12 (IP) may be used by a linker as a scratch register between
> a routine and any subroutine it calls (for details, see
> =A75.3.1.1, Use of IP by the linker). It can also be used within a routine
> to hold intermediate values between subroutine calls."
> =


So isn't this similar to my comment on the arm64 code, which relies on
this being called via a function call, as opposed to directly issuring
an HVC via inline assembly?

If so, documenting this limitation/restriction/feature would be nice.

Thanks,
-Christoffer
