From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PULL 2/4] arm64: KVM: Only force FPEXC32_EL2.EN if trapping
 FPSIMD
Date: Wed, 5 Sep 2018 12:28:46 +0100
Message-ID: <20180905112846.GC17801@e103592.cambridge.arm.com>
References: <20180903134516.17796-1-christoffer.dall@arm.com>
 <20180903134516.17796-3-christoffer.dall@arm.com>
 <20180904113952.GB17801@e103592.cambridge.arm.com>
 <20180904125121.GO4029@e113682-lin.lund.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 491AB4A0CA
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Sep 2018 07:28:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IGWuGZjVfmPj for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Sep 2018 07:28:52 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E888F49FA8
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Sep 2018 07:28:51 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180904125121.GO4029@e113682-lin.lund.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Sep 04, 2018 at 02:51:21PM +0200, Christoffer Dall wrote:
> On Tue, Sep 04, 2018 at 12:39:54PM +0100, Dave Martin wrote:
> > On Mon, Sep 03, 2018 at 03:45:14PM +0200, Christoffer Dall wrote:
> > > From: Marc Zyngier <marc.zyngier@arm.com>
> > > 
> > > If trapping FPSIMD in the context of an AArch32 guest, it is critical
> > > to set FPEXC32_EL2.EN to 1 so that the trapping is taken to EL2 and
> > > not EL1.
> > > 
> > > Conversely, it is just as critical *not* to set FPEXC32_EL2.EN to 1
> > > if we're not going to trap FPSIMD, as we then corrupt the existing
> > > VFP state.
> > > 
> > > Moving the call to __activate_traps_fpsimd32 to the point where we
> > > know for sure that we are going to trap ensures that we don't set that
> > > bit spuriously.
> > 
> > 
> > Hmmm, this looks like a viable fix but actually the way the code is
> > structured is a bit confusing here.
> > 
> > It looks like some unnecessary functionality has been inherited from
> > arch/arm here: for a 32-bit host, FPEXC controls FPSIMD trapping even
> > at Hyp, so we need to handle it specially in order for the Hyp FPSIMD
> > context switching code to run without generating additional traps.
> > 
> > For a 64-bit host, this doesn't apply: FPEXC32_EL2 is just guest
> > context and doesn't affect EL2 execution.
> 
> Hmm, is that really true?  Earlier versions of the Armv8 Arm ARM, for
> the description of CPTR_EL2.TFP:
> 
>   This causes instructions that access the registers associated with
>   Floating Point and Advanced SIMD execution to trap to EL2 when
>   executed from EL0, EL1, or EL2, unless trapped to EL1.
> 
> In the current version I think you can arrive at the same conclusion by
> looking at the FPEXC_EL2.EN description which tells you that if EN==0,
> then the instruction is UNDEFINED, and the Synchronous exception
> prioritization rules specify that undefined instructions are taken
> before trapped intructions because of CPTR_EL2.
> 
> But there does seem to be some inconsistency with the description of
> generally trapping floating point access to EL2.

You can try taking a look at the archietctural pseudocode -- see the
CheckFPAdvSIMDEnabled64() (for AArch64) and CheckFPAdvSIMDEnabled() (for
AArch32) function hierarchies on developer.arm.com.

ARM DDI 0487B.b says for FPEXC32_EL2:

"Purpose:  Allows access to the AArch32 register FPEXC from AArch64
state only. Its value has no effect on execution in AArch64 state."

This could arguably be worded better, but the second sentence is
pretty unequivocal.

> 
> > 
> > The wrinkle this patch fixes is that implicit reads of FPEXC by
> 
> what do you mean by implicit reads here?

In effect any trappable instruction can be thought of as reading a bunch
of system registers in order to decide whether to take a trap or execute
the instruction normally.  The pseudocode adopts this model.  These
reads are not done by actual MRS instructions in the instruction stream,
so they are deemed implicit.

[...]

Cheers
---Dave
