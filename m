From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [RFC PATCH 16/16] KVM: arm64/sve: Report and enable SVE API
 extensions for userspace
Date: Wed, 8 Aug 2018 09:30:44 +0100
Message-ID: <20180808083043.GJ9097@e103592.cambridge.arm.com>
References: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
 <1529593060-542-17-git-send-email-Dave.Martin@arm.com>
 <20180719145921.oasa3a57at5nnwya@kamzik.brq.redhat.com>
 <20180725152749.GQ4240@e103592.cambridge.arm.com>
 <20180725165256.k2kcrazgyt7y4i4o@kamzik.brq.redhat.com>
 <20180726131802.GX4240@e103592.cambridge.arm.com>
 <20180806134133.GE5985@e113682-lin.lund.arm.com>
 <20180807112345.GG9097@e103592.cambridge.arm.com>
 <20180807200828.GJ5985@e113682-lin.lund.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B7B84A0CC
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Aug 2018 04:30:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id N7AVODkzmSmX for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Aug 2018 04:30:48 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C7D0140672
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Aug 2018 04:30:48 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180807200828.GJ5985@e113682-lin.lund.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Aug 07, 2018 at 10:08:28PM +0200, Christoffer Dall wrote:
> On Tue, Aug 07, 2018 at 12:23:45PM +0100, Dave Martin wrote:
> > On Mon, Aug 06, 2018 at 03:41:33PM +0200, Christoffer Dall wrote:

[...]

> > > I'm personally fine with both feature flags and vcpu device ioctls.  If
> > > using vcpu device ioctls gives you an obvious way to set attributes
> > > relating to SVE, e.g. the vector length, then I think that's a strong
> > > argument for that approach.
> > 
> > There is another option I'm tending towards, which is simply to have
> > a "set vector lengths" ioctl (whether presented as a vcpu device
> > ioctl or a random arch ioctl).
> 
> Someone complained once about adding too many arch ioctls because there
> is a limited number space for doing so, but I'm not sure if that was and
> still a valid concern.

I have no strong opinion on this.  I may stick with the separate ioctl
approach for the next spin just to reduce the amount of churn, but I'm
not overly committed to it.

> > 
> > If that ioctl() fails then SVE support is not available.
> > 
> > If it succeeds, it will update its arguments to indicate which
> > vector lengths are enabled (if different).
> > 
> > Old userspace, or userspace that doesn't want to use SVE, would
> > not use this ioctl at all.
> > 
> > It would also do no harm additionally to advertise this as a
> > capability, though I wonder whether it's necessary to do so (?)
> > 
> 
> It is customary to expose features via capabilities.  I have a vague
> recollection that tools like libvirt negotiate capabilities across
> systems and would need more plumbing to discover features by probing an
> ioctl instead.

OK, fair enough.

Cheers
---Dave
