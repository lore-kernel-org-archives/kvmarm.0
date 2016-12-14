From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH 2/2] ARM: soft-reboot into same mode that we entered the
 kernel
Date: Wed, 14 Dec 2016 12:05:41 +0000
Message-ID: <20161214120541.GD14217@n2100.armlinux.org.uk>
References: <20161213113044.GC19985@leverpostej>
 <E1cH751-0003kk-Ts@rmk-PC.armlinux.org.uk>
 <20161214115648.GG17982@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 49247402A3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Dec 2016 07:04:48 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Xv5rnlntH6qR for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Dec 2016 07:04:45 -0500 (EST)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 88AFF4027C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Dec 2016 07:04:45 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20161214115648.GG17982@leverpostej>
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
Cc: marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, dave.martin@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Dec 14, 2016 at 11:56:49AM +0000, Mark Rutland wrote:
> On Wed, Dec 14, 2016 at 10:46:35AM +0000, Russell King wrote:
> > When we soft-reboot (eg, kexec) from one kernel into the next, we need
> > to ensure that we enter the new kernel in the same processor mode as
> > when we were entered, so that (eg) the new kernel can install its own
> > hypervisor - the old kernel's hypervisor will have been overwritten.
> > 
> > In order to do this, we need to pass a flag to cpu_reset() so it knows
> > what to do, and we need to modify the kernel's own hypervisor stub to
> > allow it to handle a soft-reboot.
> > 
> > As we are always guaranteed to install our own hypervisor if we're
> > entered in HYP32 mode, and KVM will have moved itself out of the way
> > on kexec/normal reboot, we can assume that our hypervisor is in place
> > when we want to kexec, so changing our hypervisor API should not be a
> > problem.
> 
> Just to check, does that also hold true for kdump?
> 
> I haven't gone digging yet, but it looks like KVM might still be
> installed, rather than the hyp stub, and we might need some logic to
> ensure that it's torn down...

The same problem will be true of ARM64 - I don't see any solution to
that in the present state.

> > @@ -51,7 +52,9 @@ static void __soft_restart(void *addr)
> >  
> >  	/* Switch to the identity mapping. */
> >  	phys_reset = (phys_reset_t)virt_to_idmap(cpu_reset);
> > -	phys_reset((unsigned long)addr);
> > +
> > +	/* original stub should be restored by kvm */
> > +	phys_reset((unsigned long)addr, is_hyp_mode_available());
> 
> ... otherwise here we'd call into the KVM hyp code in a potentially
> confusing manner.
> 
> Otherwise, this looks fine to me.

The only thing that I can think which would resolve that would be to
lay down a standard API for the hyp code, so things like reboot into
hyp mode can work irrespective of the hyp stub in place.

The issue here is that a panic can happen at any time from any context
with any hyp stub in place, so there _needs_ to be a uniform way to do
this.  It's very bad that we've got this far without this point having
been considered - all we can do right now is to try and fix the issues
as they come up.

Right now, let's fix this so we get some kind of improvement, and later
try to sort out some kind of uniform interface for this task.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
