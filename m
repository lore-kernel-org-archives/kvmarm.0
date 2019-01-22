From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH 0/2] KVM: arm/arm64: Add VCPU workarounds firmware register
Date: Tue, 22 Jan 2019 15:28:27 +0000
Message-ID: <20190122152826.GH3578@e103592.cambridge.arm.com>
References: <20190107120537.184252-1-andre.przywara@arm.com>
 <20190122101657.GE3578@e103592.cambridge.arm.com>
 <86a7jt9cc2.wl-marc.zyngier@arm.com>
 <20190122135632.GF3578@e103592.cambridge.arm.com>
 <8636pkagps.wl-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 51BB44A3C3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jan 2019 10:28:32 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ClP9R8CbX+YO for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Jan 2019 10:28:31 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B3754A3B6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jan 2019 10:28:31 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <8636pkagps.wl-marc.zyngier@arm.com>
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
Cc: Andre Przywara <andre.przywara@arm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jan 22, 2019 at 02:51:11PM +0000, Marc Zyngier wrote:
> On Tue, 22 Jan 2019 13:56:34 +0000,
> Dave Martin <Dave.Martin@arm.com> wrote:
> > 
> > On Tue, Jan 22, 2019 at 11:11:09AM +0000, Marc Zyngier wrote:
> > > On Tue, 22 Jan 2019 10:17:00 +0000,
> > > Dave Martin <Dave.Martin@arm.com> wrote:
> > > > 
> > > > On Mon, Jan 07, 2019 at 12:05:35PM +0000, Andre Przywara wrote:
> > > > > Workarounds for Spectre variant 2 or 4 vulnerabilities require some help
> > > > > from the firmware, so KVM implements an interface to provide that for
> > > > > guests. When such a guest is migrated, we want to make sure we don't
> > > > > loose the protection the guest relies on.
> > > > > 
> > > > > This introduces two new firmware registers in KVM's GET/SET_ONE_REG
> > > > > interface, so userland can save the level of protection implemented by
> > > > > the hypervisor and used by the guest. Upon restoring these registers,
> > > > > we make sure we don't downgrade and reject any values that would mean
> > > > > weaker protection.
> > > > 
> > > > Just trolling here, but could we treat these as immutable, like the ID
> > > > registers?  
> > > > 
> > > > We don't support migration between nodes that are "too different" in any
> > > > case, so I wonder if adding complex logic to compare vulnerabilities and
> > > > workarounds is liable to create more problems than it solves...
> > > 
> > > And that's exactly the case we're trying to avoid. Two instances of
> > > the same HW. One with firmware mitigations, one without. Migrating in
> > > one direction is perfectly safe, migrating in the other isn't.
> > > 
> > > It is not about migrating to different HW at all.
> > 
> > So this is a realistic scenario when deploying a firmware update across
> > a cluter that has homogeneous hardware -- there will temporarly be
> > different firmware versions running on different nodes?
> 
> Case in point: I have on my desk two AMD Seattle systems. One with an
> ancient firmware that doesn't mitigate anything, and one that has all
> the mitigations applied (and correctly advertised). I can migrate
> stuff back and forth, and that's really bad.

Agreed.

> What people do in their data centre is none of my business,
> really. What concerns me is that there is a potential for something
> bad to happen without people noticing. And it is KVM's job to do the
> right thing in this case.

Fair enough.

> > My concern is really "will the checking be too buggy / untested in
> > practice to be justified by the use case".
> 
> Not doing anything is not going to make the current situation "less
> buggy". We have all the stuff we need to test this. We can even
> artificially create the various scenarios on a model.

Agreed.  My concern is about how this will scale if future
vulnerabilities are added to the mix.  We might ultimately end up in a
worse mess, but I may be being paranoid.

> > I'll take a closer look at the checking logic.

See the other thread.  I have an idea there for exposing the information
in a different way that may simplfy things (or be totally misguided...)

Cheers
---Dave
