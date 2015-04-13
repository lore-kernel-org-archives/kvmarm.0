From: Andrew Jones <drjones@redhat.com>
Subject: Re: Advice on HYP interface for AsyncPF
Date: Mon, 13 Apr 2015 14:52:46 +0200
Message-ID: <20150413125245.GA4023@hawk.usersys.redhat.com>
References: <20150409120646.GA3212@hawk.usersys.redhat.com>
 <20150409124852.GE18488@leverpostej>
 <20150409134326.GF3212@hawk.usersys.redhat.com>
 <20150409140027.GB9648@leverpostej>
 <20150409142258.GH3212@hawk.usersys.redhat.com>
 <20150409143714.GD9648@leverpostej>
 <20150409145414.GJ3212@hawk.usersys.redhat.com>
 <20150409152009.GH9648@leverpostej>
 <20150409190122.GK3212@hawk.usersys.redhat.com>
 <20150413104635.GC4076@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FE9A4C441
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2015 08:45:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Vgq++qa-WAk6 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Apr 2015 08:45:08 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B99BD4C437
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2015 08:45:08 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20150413104635.GC4076@leverpostej>
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
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Apr 13, 2015 at 11:46:36AM +0100, Mark Rutland wrote:
> Hi,
> 
> > > > Otherwise the "is_guest()" function would be many if-else statements
> > > > trying to determine the type of guest it is before it even knows that
> > > > it is a guest.
> > > 
> > > It's worth noting that to some extent this may always be the case (e.g.
> > > is Dom0 a guest?), and it won't always be possible to determine if any
> > > (particular) hypervisor is present. For example, kvmtool does not place
> > > any special information in the DT regarding itself, and uses common
> > > peripherals (so you can't use these to fingerprint it reliably).
> > 
> > Right, but if we need kvm to advertise hypervisor features in some way,
> > (which, btw, x86 does do as well, by using a bitmap in another cpuid
> > leaf), then we'll need this DT node and ACPI table, or some other idea.
> 
> That presumes you already know the hypervisor, in order to parse those
> bitmaps. So I'm not sure I follow. We will need some mechanism to expose
> features, but this is orthogonal to detecting the presence of a
> hypervisor, no?

Yes, orthogonal. But, depending on the method of detection for the
hypervisor used, then hypervisor-feature detection will either be a
straight-forward extension of that, or we'll be revisiting the 'how'
discussion for it as well (although for that discussion we would only
need to consider kvmarm). Anyway, I think it's worth considering both
at the same time, at least for now.

> 
> > Anyway, it wouldn't hurt to have something now, just for the virt-what
> > type of case.
> 
> We can add a KVM node (or a "hypervisor services" node), but we should
> first figure out what we actually need to expose. It can hurt if
> whatever we come up with now clashes with what we want later.

atm, just 'this is a KVM guest', and maybe even which userspace; qemu
vs. kvmtool vs. ??. I think a feature bitmap and/or the address of
some hypervisor shared page could be some likely additions though.

> 
> [...]
> 
> > > The only thing you gain by assuming that the hypervisor has a node
> > > called /hypervisor is the ability to (sometimes) detect that a
> > > hypervisor you know nothing about is probably present.
> > 
> > You also gain a common location for the documentation of those
> > well-known strings, and the ability to share a bit of code in the
> > parsing.
> 
> Sorry if I sound like a broken record here, but I don't see why the node
> needs to be called /hypervisor for either of those to be true. We can
> (and should) place the documentation together in a common location
> regardless, and we don't need a common DT path for code to be shared,
> especially given...
> 
> > > As I understand it on x86 if KVM masquerades as HyperV it's not also
> > > visible as KVM. Is that correct?
> > 
> > Actually you can supply more than one hypervisor signature in the cpuids.
> > There's cpuid space allocated for up to 256. A guest can then search
> > the space in preference order for the hypervisor type it wants. QEMU/KVM
> > for x86 does this. It sets things up such that hyperv is in the first
> > location, which is the lowest preferred location for Linux, and likely
> > the only place Windows checks. It still puts KVM in the second location,
> > which is a higher preference location for Linux, and relies on Linux
> > finding it there. Linux finds it with
> > arch/x86/kernel/cpu/hypervisor.c:detect_hypervisor_vendor
> 
> ... that the x86 code here just iterates over a set of callbacks, with
> the detection logic living in each callback.

Yes, at the top level it's just callbacks, thus it reserves the right to
do anything it wants, but each detect() callback actually does the same
thing today, which is to look at the same cpuid leaf for a signature. See
arch/x86/include/asm/processor.h:hypervisor_cpuid_base, which is also
common x86 code, and is used by both kvm and xen. vmware and hyeprv
detection do the same thing too, but just don't use the common helper.

> 
> It would be interesting to know which hypervisors pretend to be each
> other and why. I can see that KVM masquerading as HyperV is useful for
> some existing systems, but does KVM masquerade as Xen (or vice versa)?

Not that I know of. The only reason one would do that is if a KVM host
expected to be given xen-only enlightened images, i.e. the image knows
how to deal with xen paravirt, but not kvm. This is pretty unlikely for
Linux distros, which are generally compiled to be enlightened for both.

> 
> If this is simply to share common services, then those services could be
> described independently of the hypervisor-specific node(s).

The services this would be for are specific to hypervisors. We already have
independence from paravirt I/O support, e.g. virtio. However, once you know
what hypervisor you're on, then you can start probing for hypervisor-
specific features. I'm suggesting that it'd be nice if the determination of
hypervisors was done in a common way. The determination of features may
optionally be done the same way.

> 
> [side note: Are any Xen (or other hypervisor) developers on this list?
> We need to involve them when determining standards]

We should copy xen-devel at some point, if we get that far, but I don't
think we've actually gotten to a determining standards point with this
discussion yet. If you're starting to see some value in a standard, then
maybe we're getting closer ;-)

> 
> > Note how the hypervisor detection is common for all x86 hypervisors that
> > Linux knows about. A specified /hypervisor node could be the DT
> > equivalent.
> 
> Note how this is just a list of callbacks, and there's no actual sharing
> of the hypervisor-specific detection mechanism. ;)
> 
> We could do likewise, but this doesn't require trying to share a
> /hypervisor node.
> 
> > > There's also a huge grey area regarding what the guest should do if it
> > > thinks it recognises both HyperV and KVM (or any other combination)
> > > simultaneously.
> > 
> > I don't think so. If the guest searches in preference-order, or the list
> > order tells the guest which one it should prefer, as is done for x86,
> > then it just uses the most preferred, and supported, one it finds.
> 
> Those both assume that the guest only decides to use a single
> hypervisor's interfaces, rather than trying to use portions of both,
> which I can imagine being a possibility unless the OS has policies to
> prevent that (e.g. stopping detection once _some_ hypervisor has been
> detected). That's a horrible grey area.

Well, a guest can try anything it wants, and that idea actually points
to an area that we should look at for potential host bugs, as behavior
like this could expose something, but I don't think it makes sense to
actually support this behavior.

> 
> Preference order would depend on the guest's preferences rather than the
> user's, but perhaps that's not really a problem.

I wouldn't think so.

> 
> > > Is there any reason for a hypervisor to try to both masquerade as a
> > > different hypervisor and advertise itself natively? The whole sharing a
> > > node / table thing may be irrelevant.
> > >
> > 
> > Yes. When you don't know the guest type you're booting, then you need
> > to expose all that you can handle, and then rely on the guest to pick
> > the right one.
> 
> I can see that masquerading is useful for providing services to guest
> which only understand some proprietary hypervisor. However, we haven't
> seen proprietary hypervisors (nor proprietary clients) thus far.
> 
> Is masquerading relevant currently?

No, not for ARM, and wrt to a DT node, I doubt it will ever matter. If
we're going to need masquerading for ARM virt, then I'm guessing the
hypervisor type and features will also need to be exposed in a different
way. ACPI? I don't think it hurts to try and work out issues we can foresee
on the DT side first though.

> 
> Which services would we want to share?

Primarily 'am I guest? And, if so, what type?' Maybe also 'at what
address can I find hypervisor-specific data?'

> 
> Can we come up with common standards for those services instead?

I'm not sure what types of services you have in mind that deserve
standards. Is hypervisor type detection not worthy?

Thanks,
drew
