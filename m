From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH 1/2] ARM: hyp-stub: improve ABI
Date: Mon, 9 Jan 2017 14:05:00 +0000
Message-ID: <20170109140500.GA14217@n2100.armlinux.org.uk>
References: <E1cH74w-0003ke-Qp@rmk-PC.armlinux.org.uk>
 <72f93940-cf87-fd91-90f2-760b7ff050fb@arm.com>
 <20161215113539.GK14217@n2100.armlinux.org.uk>
 <06fca797-da5d-f7f2-eecb-9b1b33b7e83f@arm.com>
 <20161215151548.GL14217@n2100.armlinux.org.uk>
 <c21d6514-44a2-ba88-0fe5-d14d5897cc48@arm.com>
 <20161215185717.GM14217@n2100.armlinux.org.uk>
 <20170103095149.GA14242@cbox>
 <20170109122639.GX14217@n2100.armlinux.org.uk>
 <20170109132636.GH4348@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 31FD140295
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 09:03:36 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1zCIbRfejXSR for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 09:03:33 -0500 (EST)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 39E3D40284
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 09:03:33 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20170109132636.GH4348@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, dave.martin@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jan 09, 2017 at 02:26:36PM +0100, Christoffer Dall wrote:
> On Mon, Jan 09, 2017 at 12:26:39PM +0000, Russell King - ARM Linux wrote:
> > On Tue, Jan 03, 2017 at 10:51:49AM +0100, Christoffer Dall wrote:
> > > Hi Russell,
> > > 
> > > On Thu, Dec 15, 2016 at 06:57:18PM +0000, Russell King - ARM Linux wrote:
> > > > What's also coming clear is that there's very few people who understand
> > > > all the interactions here, and the whole thing seems to be an undocumented
> > > > mess.  
> > > 
> > > I think the hyp stub has just served a very limited purpose so far, and
> > > therefore is a somewhat immature implementation.  Now we've discovered a
> > > need to clean it up, and we're all for that.  Again, I don't think the
> > > problem is any larger than that, we just need to fix it, and it seems to
> > > me everyone is willing to work on that.
> > 
> > What I want to see is some documentation of the hyp-stub, so that there
> > can be some element of confidence that changes there are properly
> > coordinated.  As I said in a follow up email:
> > 
> > | Either we need more people to have an understanding (so if one of them
> > | gets run over by a bus, we're not left floundering around) or we need
> > | it to be documented - even if it's just a simple comment "the ABI in
> > | this file is shared with XYZ, if you change the ABI here, also update
> > | XYZ too."
> > 
> > > Marc even offered to work on your suggestion to support the general
> > > hyp ABI commands in KVM.
> > 
> > ... which is pointless, because it's a duplication of the effort I've
> > already put in.  My patches already do the:
> > 
> > #define HVC_GET_VECTORS 0
> > #define HVC_SET_VECTORS 1
> > #define HVC_SOFT_RESTART 2
> > 
> > thing which ARM64 does, passing the arguments in via the appropriate
> > registers.  However, such a change is a major revision of hyp-stub's
> > ABI, which completely changes the way it works.
> 
> Sorry, I'm afraid I might have been unclear.  What I meant with "general
> hyp ABI commands in KVM" was, that if there's a need for KVM to support
> the operations (using a unified and documented ABI) that the hyp stub
> supports, then we could add that in KVM as well.  I thought your patches
> added the functionality for the hyp stub, and Marc would add whichever
> remaining pieces in the KVM side.

The view over Christmas was "we only need to ensure the GET_VECTORS call
continues to work", which is what Marc's patch does.  I've come to
realise (through no help of the documentation situation) that that is
far from the full story, because of the way kdump works.

Let me refresh...

In normal kexec(), kernel_restart_prepare() is called, which calls the
reboot_notifier_list.  KVM uses this via kvm_reboot() and
kvm_arch_hardware_disable() to call cpu_hyp_reset(), and in turn
__kvm_hyp_reset in HYP mode.  That sets the stub vectors back to the
hyp-stub implementation.  So, normal kexec should work fine.

However, kernel_restart_prepare() is _not_ called in the kdump case.
So, with my two patches in place, we will issue a HVC call with the
arguments that I've given to whatever hypervisor is in place at the
time, and as I've pointed out, with the KVM hypervisor, we will try to
branch to address 2 or 3 - who knows what effect that'll have.

So, although Marc produced a patch which updates the KVM hypervisor for
the GET_VECTORS change, through reading the code today, it's become clear
that much more is needed, so I'm yet again banging on about documentation.
It's only become clear to me today that the KVM stub calling convention
for the host kernel is:

entry:
	r0 = function pointer
	r1 = 32-bit function argument 0
	r2 = 32-bit function argument 1
	r3 = 32-bit function argument 2
	no further arguments are supported
	--- or ---
	r0 = -1 (or 0 post Marc's patch) for get_vectors
exit:
	r0 = vectors (if get_vectors call was made)
	otherwise, who knows...

I specify "32-bit" there because they're shifted by one register, which,
if a 64-bit argument is passed with EABI, the arguments will no longer be
appropriately aligned... so it's an important detail to be aware of with
the current KVM hypervisor interface.

What I want to do here is to fix this kexec issue completely, not in a
piecemeal fashion - I'm not interested in fixing one small problem, then
coming back to it in a few months time to fix another problem.  That's a
waste of time (well, unless you're into job creation.)  I've always been
for "if you're going to do the job, damn well do the job properly".  So
I'm not going to accept anything short of fixing _both_ kexec and kdump
together.

So, given that the hyp-stub has this ABI after my patches:

entry:
	r0 = argument (0 = get vectors, 1 = set vectors, 2 = call function)
	r1 = vectors for r0 = 1
	r3 = function pointer (with bit 0 already set for thumb functions)
	     for r0 = 2
exit:
	r0 = -1 for invalid calls
	r0 = current vectors address (for r0 = 0 on entry)
	is not expected to return for r0 = 2 on entry
	otherwise registers preserved preserved

which is clearly incompatible with the current KVM stub, can we come up
with a common ABI that is satisfactory to both.

The above are probably the very first time anyone has written out the
ABI of these things, and as can be seen, it's still something of a mess.

> > Longer term, I'd like to see the existing hypervisor documentation in
> > Documentation/virtual/kvm/hypercalls.txt updated with the ARM details.
> > According to that document, KVM effectively only exists on PPC and x86
> > at the present time...
> > 
> 
> I'm afraid I don't think this is right place to document this behavior.
> 
> There's a difference between an internal ABI between code running in two
> CPU modes but both part of the same kernel, and a hypervisor running
> a guest OS on top.
> 
> I believe that Documentation/virtual/kvm/hypercalls.txt documents the
> latter case (i.e. guest hypercalls supported by the KVM host
> hypervisor), not the former case, and these things should not be
> combined.
> 
> I would suggest adding something like
> Documentation/virtual/kvm/arm/hyp-abi.txt instead.

I'm fine with that - I just want there to be some documentation so we can
stop poking around in the dark, with people stating random different and
incorrect opinions about the code when problems like broken kexec/kdump
come up.

The only way to make me shut up about the documentation thing is to do
something about it...

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
