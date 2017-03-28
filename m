From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 00/15] arm64/kvm: use common sysreg definitions
Date: Tue, 28 Mar 2017 22:29:31 +0200
Message-ID: <20170328202931.GF20211@cbox>
References: <1489079247-31092-1-git-send-email-mark.rutland@arm.com>
 <87a88tv94d.fsf@on-the-bus.cambridge.arm.com>
 <20170310183555.GB6271@arm.com>
 <20170322183512.GB27921@leverpostej>
 <20170328184828.GF8643@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E0E740992
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Mar 2017 16:27:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dWbFnbQpRsvD for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Mar 2017 16:27:34 -0400 (EDT)
Received: from mail-wm0-f51.google.com (mail-wm0-f51.google.com [74.125.82.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4863A40969
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Mar 2017 16:27:33 -0400 (EDT)
Received: by mail-wm0-f51.google.com with SMTP id u132so48922431wmg.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Mar 2017 13:29:33 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170328184828.GF8643@leverpostej>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, catalin.marinas@arm.com, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Mar 28, 2017 at 07:48:28PM +0100, Mark Rutland wrote:
> On Wed, Mar 22, 2017 at 06:35:13PM +0000, Mark Rutland wrote:
> > On Fri, Mar 10, 2017 at 06:35:55PM +0000, Will Deacon wrote:
> > > On Fri, Mar 10, 2017 at 08:17:22AM +0000, Marc Zyngier wrote:
> > 
> > > > The next question is how do we merge this. Obviously, we can't split it
> > > > between trees, and this is very likely to clash with anything that we
> > > > will merge on the KVM side (the sysreg table is a popular place).
> > > > 
> > > > Will, Catalin: Would it make sense to create a stable branch with these
> > > > patches, and merge it into both the arm64 and KVM trees? That'd make
> > > > things easier...
> > > 
> > > I think the scope for conflict on our side is pretty high too, so a shared
> > > branch might be the best way to go. I don't want to branch just yet though,
> > > so I'll probably wait a week or so before setting something in stone.
> > 
> > Any further thoughts on this?
> > 
> > Christoffer has Acked the KVM bits, so if you're happy to do so for the
> > arm64 bits I can make a stable branch.
> 
> Looking around, it doesn't look like there's anything outside of arm64
> that'll conflict on the <asm/sysreg.h> changes, and git's happy to merge
> my changes with Suzuki's changes currently queued in arm64's
> for-next/core branch.
> 
> I think it would make sense for those to be in a common branch taken by
> both the arm64 and KVM trees, with the KVM-specific parts being taken by
> KVM alone atop of that.
> 
> Would everyone be happy with that?

I'm happy with that.

> 
> For reference, I've updated my branches so that arm64/common-sysreg only
> contains the common parts, with the KVM parts atop of that in
> kvm/common-sysreg.
> 

Will, Catalin:  Let me know if you're going to pull from common-sysreg
and I'll do the same and add the kvm patches above.

Thanks for preparing the patches.
-Christoffer
