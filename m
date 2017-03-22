From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 00/15] arm64/kvm: use common sysreg definitions
Date: Wed, 22 Mar 2017 18:35:13 +0000
Message-ID: <20170322183512.GB27921@leverpostej>
References: <1489079247-31092-1-git-send-email-mark.rutland@arm.com>
 <87a88tv94d.fsf@on-the-bus.cambridge.arm.com>
 <20170310183555.GB6271@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DE9C40A63
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Mar 2017 14:33:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rBmV0l6jftlp for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Mar 2017 14:33:41 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D38F40A54
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Mar 2017 14:33:41 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20170310183555.GB6271@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On Fri, Mar 10, 2017 at 06:35:55PM +0000, Will Deacon wrote:
> On Fri, Mar 10, 2017 at 08:17:22AM +0000, Marc Zyngier wrote:

> > The next question is how do we merge this. Obviously, we can't split it
> > between trees, and this is very likely to clash with anything that we
> > will merge on the KVM side (the sysreg table is a popular place).
> > 
> > Will, Catalin: Would it make sense to create a stable branch with these
> > patches, and merge it into both the arm64 and KVM trees? That'd make
> > things easier...
> 
> I think the scope for conflict on our side is pretty high too, so a shared
> branch might be the best way to go. I don't want to branch just yet though,
> so I'll probably wait a week or so before setting something in stone.

Any further thoughts on this?

Christoffer has Acked the KVM bits, so if you're happy to do so for the
arm64 bits I can make a stable branch.

Thanks,
Mark.
