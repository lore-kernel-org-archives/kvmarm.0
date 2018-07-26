From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [RFC PATCH 16/16] KVM: arm64/sve: Report and enable SVE API
 extensions for userspace
Date: Thu, 26 Jul 2018 14:18:02 +0100
Message-ID: <20180726131802.GX4240@e103592.cambridge.arm.com>
References: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
 <1529593060-542-17-git-send-email-Dave.Martin@arm.com>
 <20180719145921.oasa3a57at5nnwya@kamzik.brq.redhat.com>
 <20180725152749.GQ4240@e103592.cambridge.arm.com>
 <20180725165256.k2kcrazgyt7y4i4o@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 655B940672
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jul 2018 09:18:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id N2DRihhtx084 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Jul 2018 09:18:07 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 041244043C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jul 2018 09:18:06 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180725165256.k2kcrazgyt7y4i4o@kamzik.brq.redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jul 25, 2018 at 06:52:56PM +0200, Andrew Jones wrote:
> On Wed, Jul 25, 2018 at 04:27:49PM +0100, Dave Martin wrote:
> > On Thu, Jul 19, 2018 at 04:59:21PM +0200, Andrew Jones wrote:
> > > On Thu, Jun 21, 2018 at 03:57:40PM +0100, Dave Martin wrote:
> > > > -	/*
> > > > -	 * For now, we don't return any features.
> > > > -	 * In future, we might use features to return target
> > > > -	 * specific features available for the preferred
> > > > -	 * target type.
> > > > -	 */
> > > > +	/* KVM_ARM_VCPU_SVE understood by KVM_VCPU_INIT */
> > > > +	init->features[0] = 1 << KVM_ARM_VCPU_SVE;
> > > > +
> > > 
> > > We shouldn't need to do this. The "preferred" target type isn't defined
> > > well (that I know of), but IMO it should probably be the target that
> > > best matches the host, minus optional features. The best base target. We
> > > may use these features to convey that the preferred target should enable
> > > some optional feature if that feature is necessary to workaround a bug,
> > > i.e. using the "feature" bit as an erratum bit someday, but that'd be
> > > quite a debatable use, so maybe not even that. Most likely we'll never
> > > need to add features here.
> > 
> > init->features[] has no semantics yet so we can define it how we like,
> > but I agree that the way I use it here is not necessarily the most
> > natural.
> > 
> > OTOH, we cannot use features[] for "mandatory" features like erratum
> > workarounds, because current userspace just ignores these bits.
> 
> It would have to learn to look here if that's how we started using it,
> but it'd be better to invent something else that wouldn't appear as
> abusive if we're going to teach userspace new stuff anyway.
> 
> > 
> > Rather, these bits would be for features that are considered beneficial
> > but must be off by default (due to incompatibility risks across nodes,
> > or due to ABI impacts).  Just blindly using the preferred target
> > already risks configuring a vcpu that won't work across all nodes in
> > your cluster.
> 
> KVM usually advertises optional features through capabilities. A device
> (vcpu device, in this case) ioctl can also be used to check for feature
> availability.
> 
> > 
> > So I'm not convinced that there is any useful interpretation of
> > features[] unless we interpret it as suggested in this patch.
> > 
> > Can you elaborate why you think it should be used with a more
> > concrete example?
> 
> I'm advocating that it *not* be used here. I think it should be used
> like the PMU feature uses it - and the PMU feature doesn't set a bit
> here.
> 
> > 
> > > That said, I think defining the feature bit makes sense. ATM, I'm feeling
> > > like we'll want to model the user interface for SVE like PMU (using VCPU
> > > device ioctls).
> > 
> > Some people expressed concerns about the ioctls becoming order-sensitive.
> > 
> > In the SVE case we don't want people enabling/disabling/reconfiguring
> > "silicon" features like SVE after the vcpu starts executing.
> > 
> > We will need an extra ioctl() for configuring the allowed SVE vector
> > lengths though.  I don't see a way around that.  So maybe we have to
> > solve the ordering problem anyway.
> 
> Yes, that's why I'm thinking that the vcpu device ioctls is probably the
> right way to go. The SVE group can have its own "finalize" request that
> allows all other SVE ioctls to be in any order prior to it.
> 
> > 
> > 
> > By current approach (not in this series) was to have VCPU_INIT return
> > -EINPROGRESS or similar if SVE is enabled in features[]: this indicates
> > that certain setup ioctls are required before the vcpu can run.
> > 
> > This may be overkill / not the best approach though.  I can look at
> > vcpu device ioctls as an alternative.
> 
> With a "finalize" attribute if SVE isn't finalized by VCPU_INIT or
> KVM_RUN time, then SVE just won't be enabled for that VCPU.

So I suppose we could do something like this:

 * Advertise SVE availability through a vcpu device capability (I need
   to check how that works).

 * SVE-aware userspace that understands SVE can do the relevant
   vcpu device ioctls to configure SVE and turn it on: these are only
   permitted before the vcpu runs.  We might require an explicit
   "finish SVE setup" ioctl to be issued before the vcpu can run.

 * Finally, the vcpu is set running by userspace as normal.

Marc or Christoffer was objecting to me previously that this may be an
abuse of vcpu device ioctls, because SVE is a CPU feature rather than a
device.  I guess it depends on how you define "device" -- I'm not sure
where to draw the line.

The vcpu device approach might reduce the amount of weird special-case
API that needs to be invented, which is probably a good thing.

Cheers
---Dave
