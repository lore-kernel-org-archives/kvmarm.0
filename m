From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 2/2] ARM: soft-reboot into same mode that we entered the
 kernel
Date: Wed, 14 Dec 2016 12:40:56 +0000
Message-ID: <20161214124056.GI17982@leverpostej>
References: <20161213113044.GC19985@leverpostej>
 <E1cH751-0003kk-Ts@rmk-PC.armlinux.org.uk>
 <20161214115648.GG17982@leverpostej>
 <20161214120541.GD14217@n2100.armlinux.org.uk>
 <20161214121747.GH17982@leverpostej>
 <20161214122945.GE14217@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B2180404AC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Dec 2016 07:40:39 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c3z85EGOmF1S for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Dec 2016 07:40:38 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2895D402A3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Dec 2016 07:40:37 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20161214122945.GE14217@n2100.armlinux.org.uk>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, dave.martin@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Dec 14, 2016 at 12:29:45PM +0000, Russell King - ARM Linux wrote:
> On Wed, Dec 14, 2016 at 12:17:47PM +0000, Mark Rutland wrote:
> > On Wed, Dec 14, 2016 at 12:05:41PM +0000, Russell King - ARM Linux wrote:
> > > The issue here is that a panic can happen at any time from any context
> > > with any hyp stub in place, so there _needs_ to be a uniform way to do
> > > this.  It's very bad that we've got this far without this point having
> > > been considered - all we can do right now is to try and fix the issues
> > > as they come up.
> > > 
> > > Right now, let's fix this so we get some kind of improvement, and later
> > > try to sort out some kind of uniform interface for this task.
> > 
> > Sure, that's a bigger task, and this is definitely a step in the right
> > direction.
> > 
> > We need to avoid the kdump regression somehow though; can we somehow
> > detect if KVM is active and avoid issuing the HVC_SOFT_RESTART?
> 
> That's a question for KVM people.
> 
> However, there's a bigger question, which is: what do we want to happen
> in the case of kdump - do we want to be entering the kdump kernel in
> HYP or SVC mode?  As the kdump kernel exists to be able to save the
> state of a crashing system, the kdump kernel should do that and then
> restart the system in a clean way (iow, not via yet another kexec.)
> 
> So maybe the right answer is that kdump should always invoke the kernel
> in SVC mode.

Personally, my view is the opposite -- we should always exit the way we
came, and kdump can go from there. Otherwise we're leaving context
active in hyp mode that might hinder kdump (or would otherwise be useful
for kdump to be able to access).

For example, we might want to do something like kernel guard, where even
the host kernel would have a stage-2 translation active in hyp that we'd
need to tear down. That, or the hyp page table might have been
corrupted, and tearing down ASAP might save us from asynchrnous issues
from page table walks. It's all a trade-off, either way -- the hyp code
could also be corrupt.

Certainly I would expect that once kdump's logged what it can, it should
trigger a real reboot.

Thanks,
Mark.

[1] https://01.org/intel-kgt
