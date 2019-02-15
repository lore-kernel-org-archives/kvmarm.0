From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH 1/2] KVM: arm/arm64: Add save/restore support for
 firmware workaround state
Date: Fri, 15 Feb 2019 17:26:02 +0000
Message-ID: <20190215172558.GO3567@e103592.cambridge.arm.com>
References: <20190107120537.184252-1-andre.przywara@arm.com>
 <20190107120537.184252-2-andre.przywara@arm.com>
 <20190122151714.GG3578@e103592.cambridge.arm.com>
 <20190125144657.3db91c91@donnerap.cambridge.arm.com>
 <20190129213223.GB3567@e103592.cambridge.arm.com>
 <20190130113900.10089070@donnerap.cambridge.arm.com>
 <20190215095857.2fd7e0fb@donnerap.cambridge.arm.com>
 <864l95s2fw.wl-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B4DD49E3E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Feb 2019 12:26:08 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BJDUl1VxKbuz for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Feb 2019 12:26:06 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AB9D340493
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Feb 2019 12:26:06 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <864l95s2fw.wl-marc.zyngier@arm.com>
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
Cc: linux-arm-kernel@lists.infradead.org, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Feb 15, 2019 at 11:42:27AM +0000, Marc Zyngier wrote:
> On Fri, 15 Feb 2019 09:58:57 +0000,
> Andre Przywara <andre.przywara@arm.com> wrote:
> > 
> > On Wed, 30 Jan 2019 11:39:00 +0000
> > Andre Przywara <andre.przywara@arm.com> wrote:
> > 
> > Peter, Marc, Christoffer,
> > 
> > can we have an opinion on whether it's useful to introduce some
> > common scheme for firmware workaround system registers (parts of
> > KVM_REG_ARM_FW_REG(x)), which would allow checking them for
> > compatibility between two kernels without specifically knowing about
> > them?
> > Dave suggested to introduce some kind of signed encoding in the 4
> > LSBs for all those registers (including future ones), where 0 means
> > UNKNOWN and greater values are better. So without knowing about the
> > particular register, one could judge whether it's safe to migrate.
> > I am just not sure how useful this is, given that QEMU seems to ask
> > the receiving kernel about any sysreg, and doesn't particularly care
> > about the meaning of those registers. And I am not sure we really
> > want to introduce some kind of forward looking scheme in the kernel
> > here, short of a working crystal ball. I think the kernel policy was
> > always to be as strict as possible about those things.
> 
> I honestly don't understand how userspace can decide whether a given
> configuration is migratable or not solely based on the value of such a
> register. In my experience, the target system has a role to play, and
> is the only place where we can find out about whether migration is
> actually possible.

Both origin and target system need to be taken into account.  I don't
think that's anything new.

> As you said, userspace doesn't interpret the data, nor should it. It
> is only on the receiving end that compatibility is assessed and
> whether some level of compatibility can be safely ensured.
> 
> So to sum it up, I don't believe in this approach as a general way of
> describing the handling or errata.

For context, my idea attempted to put KVM, not userspace, in charge of
the decision: userspace applies fixed comparison rules determined ahead
of time, but KVM supplies the values compared (and hence determines the
result).

My worry was that otherwise we may end up with a wild-west tangle of
arbitrary properties that userspace needs specific knowledge about.

We can tolerate a few though.  If we accumulate a significant number
of errata/vulnerability properties that need to be reported to
userspace, this may be worth revisiting.  If not, it doesn't matter.

Cheers
---Dave
