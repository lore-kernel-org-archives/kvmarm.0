From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH 1/3] arm64: KVM: Move CPU ID reg trap setup off the world
 switch path
Date: Tue, 5 Dec 2017 12:31:51 +0000
Message-ID: <20171205123150.GX22781@e103592.cambridge.arm.com>
References: <1512141582-17474-1-git-send-email-Dave.Martin@arm.com>
 <1512141582-17474-2-git-send-email-Dave.Martin@arm.com>
 <20171205090915.GI32397@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 69A6549D35
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Dec 2017 07:28:46 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yaghSGpRknSa for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Dec 2017 07:28:45 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 29F1140795
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Dec 2017 07:28:45 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20171205090915.GI32397@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Dec 05, 2017 at 10:09:15AM +0100, Christoffer Dall wrote:
> On Fri, Dec 01, 2017 at 03:19:40PM +0000, Dave Martin wrote:
> > The HCR_EL2.TID3 flag needs to be set when trapping guest access to
> > the CPU ID registers is required.  However, the decision about
> > whether to set this bit does not need to be repeated at every
> > switch to the guest.
> > 
> > Instead, it's sufficient to make this decision once and record the
> > outcome.
> > 
> > This patch moves the decision to vcpu_reset_hcr() and records the
> > choice made in vcpu->arch.hcr_el2.  The world switch code can then
> > load this directly when switching to the guest without the need for
> > conditional logic on the critical path.
> > 
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > Suggested-by: Christoffer Dall <christoffer.dall@linaro.org>
> > Cc: Marc Zyngier <marc.zyngier@arm.com>
> 
> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
> 
> > 
> > ---
> > 
> > Note to maintainers: this was discussed on-list [1] prior to the merge
> > window, but this patch implementing the agreed decision hasn't been
> > posted previously.
> > 
> > This should be considered a fix for v4.15.
> 
> It's actually easier for me to apply this for v4.16 and base my VHE
> optimization patches on it.

If you're happy for this optimisation to be missing for v4.15, I'm fine
with that.

Can I leave it you to pick this up then?

I'll repost the other stuff from this series separately for Will to
take care of.

Cheers
---Dave
