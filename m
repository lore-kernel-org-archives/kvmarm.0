From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH 1/2] KVM: arm/arm64: Add save/restore support for
 firmware workaround state
Date: Mon, 18 Feb 2019 10:28:54 +0000
Message-ID: <20190218102852.GP3567@e103592.cambridge.arm.com>
References: <20190107120537.184252-1-andre.przywara@arm.com>
 <20190107120537.184252-2-andre.przywara@arm.com>
 <20190122151714.GG3578@e103592.cambridge.arm.com>
 <20190125144657.3db91c91@donnerap.cambridge.arm.com>
 <20190129213223.GB3567@e103592.cambridge.arm.com>
 <20190130113900.10089070@donnerap.cambridge.arm.com>
 <20190215095857.2fd7e0fb@donnerap.cambridge.arm.com>
 <864l95s2fw.wl-marc.zyngier@arm.com>
 <20190215172558.GO3567@e103592.cambridge.arm.com>
 <20190218090731.3d313d81@why.wild-wind.fr.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1253C4A1DF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Feb 2019 05:29:00 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MzFUh9vqdova for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Feb 2019 05:28:58 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C86E740493
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Feb 2019 05:28:58 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20190218090731.3d313d81@why.wild-wind.fr.eu.org>
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
Cc: Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Feb 18, 2019 at 09:07:31AM +0000, Marc Zyngier wrote:
> On Fri, 15 Feb 2019 17:26:02 +0000
> Dave Martin <Dave.Martin@arm.com> wrote:
> 
> > On Fri, Feb 15, 2019 at 11:42:27AM +0000, Marc Zyngier wrote:
> > > On Fri, 15 Feb 2019 09:58:57 +0000,
> > > Andre Przywara <andre.przywara@arm.com> wrote:  
> > > > 
> > > > On Wed, 30 Jan 2019 11:39:00 +0000
> > > > Andre Przywara <andre.przywara@arm.com> wrote:
> > > > 
> > > > Peter, Marc, Christoffer,
> > > > 
> > > > can we have an opinion on whether it's useful to introduce some
> > > > common scheme for firmware workaround system registers (parts of
> > > > KVM_REG_ARM_FW_REG(x)), which would allow checking them for
> > > > compatibility between two kernels without specifically knowing about
> > > > them?
> > > > Dave suggested to introduce some kind of signed encoding in the 4
> > > > LSBs for all those registers (including future ones), where 0 means
> > > > UNKNOWN and greater values are better. So without knowing about the
> > > > particular register, one could judge whether it's safe to migrate.
> > > > I am just not sure how useful this is, given that QEMU seems to ask
> > > > the receiving kernel about any sysreg, and doesn't particularly care
> > > > about the meaning of those registers. And I am not sure we really
> > > > want to introduce some kind of forward looking scheme in the kernel
> > > > here, short of a working crystal ball. I think the kernel policy was
> > > > always to be as strict as possible about those things.  
> > > 
> > > I honestly don't understand how userspace can decide whether a given
> > > configuration is migratable or not solely based on the value of such a
> > > register. In my experience, the target system has a role to play, and
> > > is the only place where we can find out about whether migration is
> > > actually possible.  
> > 
> > Both origin and target system need to be taken into account.  I don't
> > think that's anything new.
> 
> Well, that was what I understood from Andre's question.
> 
> > 
> > > As you said, userspace doesn't interpret the data, nor should it. It
> > > is only on the receiving end that compatibility is assessed and
> > > whether some level of compatibility can be safely ensured.
> > > 
> > > So to sum it up, I don't believe in this approach as a general way of
> > > describing the handling or errata.  
> > 
> > For context, my idea attempted to put KVM, not userspace, in charge of
> > the decision: userspace applies fixed comparison rules determined ahead
> > of time, but KVM supplies the values compared (and hence determines the
> > result).
> > 
> > My worry was that otherwise we may end up with a wild-west tangle of
> > arbitrary properties that userspace needs specific knowledge about.
> 
> And this is where our understanding differs. I do not think userspace
> has to care at all. All it has to do is to provide the saved register
> values to the target system, and let KVM accept or refuse these
> settings. I can't see what providing a set of predefined values back to
> userspace gains us.

Can we just pull all the UAPI header definitions then?  If this is
really kernel private, we don't even need userspace to know what the
IDs mean, let alone what's in the registers.

[...]

Cheers
---Dave
