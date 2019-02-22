From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH] KVM: arm64: Fix architecturally invalid reset value for
 FPEXC32_EL2
Date: Fri, 22 Feb 2019 10:56:07 +0000
Message-ID: <20190222105604.GB3567@e103592.cambridge.arm.com>
References: <1550749352-2315-1-git-send-email-Dave.Martin@arm.com>
 <20190222100103.03fb773d@why.wild-wind.fr.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190222100103.03fb773d@why.wild-wind.fr.eu.org>
Sender: stable-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>, Julien Thierry <julien.thierry@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, stable@vger.kernel.org, James Morse <james.morse@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Feb 22, 2019 at 10:01:03AM +0000, Marc Zyngier wrote:
> On Thu, 21 Feb 2019 11:42:32 +0000
> Dave Martin <Dave.Martin@arm.com> wrote:
> 
> > Due to what looks like a typo dating back to the original addition
> > of FPEXC32_EL2 handling, KVM currently initialises this register to
> > an architecturally invalid value.
> > 
> > As a result, the VECITR field (RES1) in bits [10:8] is initialised
> > with 0, and the two reserved (RES0) bits [6:5] are initialised with
> > 1.  (In the Common VFP Subarchitecture as specified by ARMv7-A,
> > these two bits were IMP DEF.  ARMv8-A removes them.)
> > 
> > This patch changes the reset value from 0x70 to 0x700, which
> > reflects the architectural constraints and is presumably what was
> > originally intended.
> > 
> > Cc: <stable@vger.kernel.org> # 4.12.x-
> > Cc: Marc Zyngier <marc.zyngier@arm.com>
> > Cc: Christoffer Dall <christoffer.dall@arm.com>
> > Fixes: 62a89c44954f ("arm64: KVM: 32bit handling of coprocessor traps")
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> 
> Applied to -next.
> 
> Thanks,

Thanks.

I have a patch for <= v4.11 which I can send to stable once this patch
reaches torvalds/master.

Is it worth it though, in your opinion?

Cheers
---Dave
