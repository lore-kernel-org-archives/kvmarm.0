From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 06/10] KVM: arm/arm64: vgic: Allow dynamic mapping of
 physical/virtual interrupts
Date: Wed, 1 Jul 2015 13:45:19 +0200
Message-ID: <20150701114519.GB17890@cbox>
References: <1433783045-8002-1-git-send-email-marc.zyngier@arm.com>
 <1433783045-8002-7-git-send-email-marc.zyngier@arm.com>
 <20150630201942.GB11332@cbox>
 <5593BEFD.4030608@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5593BEFD.4030608@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Eric Auger <eric.auger@linaro.org>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jul 01, 2015 at 11:20:45AM +0100, Marc Zyngier wrote:
> On 30/06/15 21:19, Christoffer Dall wrote:
> > On Mon, Jun 08, 2015 at 06:04:01PM +0100, Marc Zyngier wrote:
> >> In order to be able to feed physical interrupts to a guest, we need
> >> to be able to establish the virtual-physical mapping between the two
> >> worlds.
> >>
> >> The mapping is kept in a rbtree, indexed by virtual interrupts.
> > 
> > how many of these do you expect there will be?  Is the extra code and
> > complexity of an rbtree really warranted?
> > 
> > I would assume that you'll have one PPI for each CPU in the default case
> > plus potentially a few more for an assigned network adapter, let's say a
> > couple of handfulls.  Am I missing something obvious or is this
> > optimization of traversing a list of 10-12 mappings in the typical case
> > not likely to be measurable?
> > 
> > I would actually be more concerned about the additional locking and
> > would look at RCU for protecting a list instead.  Can you protect an
> > rbtree with RCU easily?
> 
> Not very easily. There was some work done a while ago for the dentry
> cache IIRC, but I doubt that's reusable directly, and probably overkill.
> 
> RCU protected lists are, on the other hand, readily available. Bah. I'll
> switch to this. By the time it becomes the bottleneck, the world will
> have moved on. Or so I hope.
> 
We can also move to RB trees if we have some data to show us it's worth
the hassle later on, but I assume that since these structs are fairly
small and overhead like this is mostly to show up on a hot path, a
better optimization would be to allocate a bunch of these structures
contiguously for cache locality, but again, I feel like this is all
premature and we should measure the beast first.

Thanks,
-Christoffer
