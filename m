From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PULL 2/4] arm64: KVM: Only force FPEXC32_EL2.EN if trapping
 FPSIMD
Date: Fri, 7 Sep 2018 12:19:27 +0100
Message-ID: <20180907111924.GE17801@e103592.cambridge.arm.com>
References: <20180903134516.17796-1-christoffer.dall@arm.com>
 <20180903134516.17796-3-christoffer.dall@arm.com>
 <20180904113952.GB17801@e103592.cambridge.arm.com>
 <20180904125121.GO4029@e113682-lin.lund.arm.com>
 <20180905112846.GC17801@e103592.cambridge.arm.com>
 <20180905150321.GT4029@e113682-lin.lund.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D4D284A1E5
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Sep 2018 07:19:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ztSFmVAkHujY for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Sep 2018 07:19:31 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F4604A1DB
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Sep 2018 07:19:31 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180905150321.GT4029@e113682-lin.lund.arm.com>
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

On Wed, Sep 05, 2018 at 05:03:21PM +0200, Christoffer Dall wrote:
> On Wed, Sep 05, 2018 at 12:28:46PM +0100, Dave Martin wrote:

[...]

> > You can try taking a look at the archietctural pseudocode -- see the
> > CheckFPAdvSIMDEnabled64() (for AArch64) and CheckFPAdvSIMDEnabled() (for
> > AArch32) function hierarchies on developer.arm.com.
> > 
> > ARM DDI 0487B.b says for FPEXC32_EL2:
> > 
> > "Purpose:  Allows access to the AArch32 register FPEXC from AArch64
> > state only. Its value has no effect on execution in AArch64 state."
> > 
> > This could arguably be worded better, but the second sentence is
> > pretty unequivocal.
> > 
> 
> I think I was confused about your point.  I thought you were arguing
> that CPTR_EL2.TFP==1 + FPEXC_EL2.EN==0, and running in AArch32 EL1+EL0,
> and accessing VFP at EL0 would trap to EL2, when in fact it traps to
> EL1.  But now I think you're arguing that EL2 is unaffected by
> FPEXC32_EL2, and I agree with that.
> 
> However, given the above, I don't understand how we can let the guest be
> in control of FPEXC, if we want to make sure we trap VFP accesses?

If the guest set FPEXC.EN to 0, then it is expecting its own VFP
accesses to trap to EL1.  If a VFP access attempt traps to EL1 and the
guest is expecting it, why does hyp need to get involved?

Hyp only needs to interfere when an otherwise untrapped access to the
VFP state would occur.

If we don't have the guest context loaded, we would still trap any
attempt by the guest to modify FPEXC to EL2 as a result of CPTR_EL2.TFP
still being set (or equivalent).

Cheers
---Dave
