From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH 1/2] ARM: hyp-stub: improve ABI
Date: Mon, 9 Jan 2017 13:20:26 +0000
Message-ID: <20170109132026.GZ14217@n2100.armlinux.org.uk>
References: <20161213113044.GC19985@leverpostej>
 <E1cH74w-0003ke-Qp@rmk-PC.armlinux.org.uk>
 <72f93940-cf87-fd91-90f2-760b7ff050fb@arm.com>
 <20170109125431.GY14217@n2100.armlinux.org.uk>
 <e16d9b76-49ce-ae22-60f9-f2000d1862af@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 49DF1403FB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 08:18:55 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id A6-Oc6ui50Mp for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 08:18:53 -0500 (EST)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9CF27401A1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 08:18:53 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <e16d9b76-49ce-ae22-60f9-f2000d1862af@arm.com>
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
Cc: linux-arm-kernel@lists.infradead.org, dave.martin@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jan 09, 2017 at 01:14:31PM +0000, Marc Zyngier wrote:
> On 09/01/17 12:54, Russell King - ARM Linux wrote:
> > I don't think this is sufficient - the kdump case for ARM will still be
> > broken after these patches.
> > 
> > The new soft-restart ABI introduced by my patch 2 passes in:
> > 
> > r0 = HVC_SOFT_RESTART
> > r1 = non-zero
> > r2 = undefined
> > r3 = function pointer
> > 
> > and the assumption is that r3 will be preserved if the HVC call does
> > nothing - which probably isn't a safe assumption.
> > 
> > With these arguments passed to the KVM stub (which may be in place at
> > the point of a kdump), we end up executing this code:
> > 
> >         push    {lr}
> > 
> >         mov     lr, r0
> >         mov     r0, r1
> >         mov     r1, r2
> >         mov     r2, r3
> > 
> > THUMB(  orr     lr, #1)
> >         blx     lr                      @ Call the HYP function
> > 
> > This will result in an attempt to branch to address 2 or 3, which isn't
> > sane - a panic in the host kernel (eg due to a NULL pointer deref with
> > panic_on_oops enabled) will then cause kdump to try to execute code from
> > a stupid address.
> > 
> > So, we need KVM's stub to be (a) better documented so this stuff is
> > obvious, and (b) updated so that kdump stands a chance of working even
> > if the KVM stub is still in place at the point the host kernel panics.
> > 
> > Another reason why documentation is important here is that we need to
> > make it clear to alternative hypervisors that the host kernel may issue
> > a HVC call at any moment due to a crash with particular arguments, and
> > that the host kernel expects a certain behaviour in that case, and that
> > the hypervisor does not crash.
> > 
> > For example, how will Xen behave - is introducing these changes going
> > to cause a regression with Xen?  Does anyone even know the answer to
> > that?  From what I can see, it seems we'll end up calling Xen's
> > hypervisor with a random r12 value (which it uses as a reason code)
> > but without the 0xea1 immediate constant in the HVC instruction.
> > Beyond that, I've no idea.
> 
> I fail to see why you would issue a hyp stub hypercall if you're booted
> under *any* hypervisor. The only way you can have a valid hyp stub is
> because the kernel was booted at EL2/HYP. If you're running under Xen,
> KVM or whatever other hypervisor, you're booted at EL1/SVC, you only
> have the hypercall API exposed by that hypervisor, and nothing else. You
> can't even install the stub the first place.
> 
> So any code path that tries to tear down KVM would better check that the
> kernel was entered at HYP. If it doesn't, it is broken.

Let me refresh your memory.  This thread is about kexec/kdump on 32-bit
ARM of the _host_ kernel, which will be entered in HYP mode.

I've never used Xen, so I've no idea about it.  I'm merely pointing out
the possibilities as I see them.

Let me repeat the on-going theme here.  Documentation.  Documentation.
Documentation.  Documentation.  Documentation.  Documentation.
Documentation.  Documentation.  Documentation.  Documentation.
Documentation.  Documentation.  Documentation.  Documentation.
Documentation.  Documentation.  Documentation.  Documentation.
Documentation.  Documentation.  Documentation.  Documentation.
Documentation.  Documentation.  Documentation.  Documentation.

Is the message getting through yet?  Can you see the waste of time
the lack of documentation is having yet - not only my time, but your
time replying to these emails.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
