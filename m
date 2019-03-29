From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v7 00/27] KVM: arm64: SVE guest support
Date: Fri, 29 Mar 2019 15:06:44 +0000
Message-ID: <20190329150642.GD3567@e103592.cambridge.arm.com>
References: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
 <bed45c04-9b67-9e30-d73e-adc07a902de1@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 43C2C4A319
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Mar 2019 11:06:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IAQ-xMmU7Mo3 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 Mar 2019 11:06:49 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D8D1A4A2E7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Mar 2019 11:06:49 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <bed45c04-9b67-9e30-d73e-adc07a902de1@arm.com>
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 29, 2019 at 02:56:36PM +0000, Marc Zyngier wrote:
> Hi Dave,
> 
> On 29/03/2019 13:00, Dave Martin wrote:
> > This series implements support for allowing KVM guests to use the Arm
> > Scalable Vector Extension (SVE), superseding the previous v6 series [1].
> > 
> > The patches are also available on a branch for reviewer convenience. [2]
> > 
> > The patches are based on v5.1-rc2.
> > 
> > This series addresses a couple of minor review comments received on v6
> > and otherwise applies reviewer tags only.  The code differences
> > between v6 and this series consist of minor cosmetic fixups only.
> > 
> > Draft kvmtool patches were posted separately [3], [4].
> > 
> > For a description of minor updates, see the individual patches.
> > 
> > 
> > Thanks go to Julien Thierry and Julian Grall for their review efforts,
> > and to Zhang Lei for testing the series -- many thanks for their help
> > in getting the series to this point!
> > 
> > 
> > Reviewers' attention is drawn to the following patches, which have no
> > Reviewed-by/Acked-by.  Please take a look if you have a moment.
> > 
> >  * Patch 11 (KVM: arm64: Support runtime sysreg visibility filtering)
> > 
> >    Previously Reviewed-by Julien Thierry, but this version of the
> >    patch contains some minor rework suggested by Mark Rutland during
> >    the v5 review [5].
> > 
> >  * Patch 15 (KVM: arm64: Add missing #include of <linux/string.h>
> >    in guest.c)
> > 
> >    (Trivial patch.)
> > 
> >  * Patch 26: (KVM: Document errors for KVM_GET_ONE_REG and
> >    KVM_SET_ONE_REG)
> > 
> >    (Documentation only.)
> > 
> >  * Patch 27: KVM: arm64/sve: Document KVM API extensions for SVE
> > 
> >    (Documentation only.)
> 
> In order to get people to test this a bit more, I've now pushed this
> series into -next. I'm pretty confident that it won't break a thing, but
> better safe than sorry. I also expect any fix to be pushed on top of
> this series.
> 
> This doesn't mean that the review is over, quite the opposite. I intend
> to go over it once more, and I'd like other people to do the same
> (specially anyone looking at implementing the required support in QEMU).

Agreed, thanks for pushing it to next.

I'll continue testing and await further review from people.

Cheers
---Dave
