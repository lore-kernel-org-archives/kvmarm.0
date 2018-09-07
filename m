From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [RFC PATCH] KVM: arm64: Treat FPEXC32_EL2 as a regular guest
 system register
Date: Fri, 7 Sep 2018 14:55:17 +0200
Message-ID: <20180907125517.GW4029@e113682-lin.lund.arm.com>
References: <1536153553-28767-1-git-send-email-Dave.Martin@arm.com>
 <20180905150838.GU4029@e113682-lin.lund.arm.com>
 <20180906121115.GD17801@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E8624A217
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Sep 2018 08:55:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u3pbvHFCtlf7 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Sep 2018 08:55:21 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA0534A1E6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Sep 2018 08:55:20 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180906121115.GD17801@e103592.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Sep 06, 2018 at 01:11:17PM +0100, Dave Martin wrote:
> On Wed, Sep 05, 2018 at 05:08:38PM +0200, Christoffer Dall wrote:
> > On Wed, Sep 05, 2018 at 02:19:13PM +0100, Dave Martin wrote:
> > > Currently FPEXC32_EL2 is handled specially when context-switching.
> > > This made sense for arm, where FPEXC affects host execution
> > > (including VFP/SIMD register save/restore at Hyp).
> > > 
> > > However, FPEXC has no architectural effect when running in AArch64.
> > > The only case where an arm64 host may execute in AArch32 is when
> > > running compat user code at EL0: the architecture explicitly
> > > documents FPEXC as having no effect in this case either when the
> > > kernel (EL2 in the VHE case; otherwise EL1) is AArch64.
> > > 
> > > So, we can just handle FPEXC32_EL2 (which is the AArch64 alias for
> > > this register) as a regular AArch32-only system register and switch
> > > it without any special handling or synchronisation.
> > > 
> > > This allows some gnarly special-case code to be eliminated from
> > > hyp.  The extra isb() in __activate_traps_fpsimd32() is dropped
> > > too: for the reasons explained above arm64 never required this
> > > anyway.
> > 
> > This looks like a reasonable cleanup, but I don't understand how this
> > works.  The reason we had the special casing of FPXEC_EL2 was to ensure
> > that we trap to EL2 when VFP should be trapped for a 32-bit guest
> > instead of going to EL1.  How does that work with this patch if we set
> 
> Actually, I think the problem was to ensure that the guest never sees
> a spurious trap to EL1 when from its point of view FPEXC.EN is set.
> Such a trap shouldn't architecturally happen, but if we execute the
> guest with FPEXC.EN=0 when the guest thinks it should be 1 then a trap
> to EL1 can occur irrespective of CPTR_EL2, because CPTR_EL2 only traps
> things that wouldn't otherwise trap to EL1.
> 

Yes, you're right.  I had this nasty feeling that we originally fixed
a bug where we were saving/restoring FPEXC and yet relying on
CPTR_EL2.TFP to always trap, but I've gone back and looked at the
history, and that code was indeed not saving/restoring FPEXC32_EL2
unless the guest was using VFP.


> > CPTR_EL2.TFP and the guest has set FPXEX32_EL2.EN ?
> 
> I'm not sure whether that's the question you intended to ask:

I obviously meant the guest had *cleared* FPXEX32_EL2.EN, but it's clear
to me now.

Thanks,

    Christoffer
