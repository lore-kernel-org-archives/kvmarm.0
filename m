From: Andrew Jones <drjones@redhat.com>
Subject: Re: Advice on HYP interface for AsyncPF
Date: Thu, 9 Apr 2015 21:01:23 +0200
Message-ID: <20150409190122.GK3212@hawk.usersys.redhat.com>
References: <5525DA0E.2010103@samsung.com>
 <20150409085723.0a201cb9@why.wild-wind.fr.eu.org>
 <20150409120646.GA3212@hawk.usersys.redhat.com>
 <20150409124852.GE18488@leverpostej>
 <20150409134326.GF3212@hawk.usersys.redhat.com>
 <20150409140027.GB9648@leverpostej>
 <20150409142258.GH3212@hawk.usersys.redhat.com>
 <20150409143714.GD9648@leverpostej>
 <20150409145414.GJ3212@hawk.usersys.redhat.com>
 <20150409152009.GH9648@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 279CC4BF89
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Apr 2015 14:53:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id k9NsiAjEHcIx for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Apr 2015 14:53:52 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 663CE4BF87
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Apr 2015 14:53:51 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20150409152009.GH9648@leverpostej>
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

On Thu, Apr 09, 2015 at 04:20:09PM +0100, Mark Rutland wrote:
> We can certainly encourage vendors to call their node /hypervisor. I
> don't think that it makes sense to enforce a common binding across
> these, because they are by definition trying to convey
> hypervisor-specific information.

OK, I agree. There's no need to require a common binding. Making it
easy for the same binding to be used by multiple hypervisors, at least
to some degree, would still be nice though.

> > Otherwise the "is_guest()" function would be many if-else statements
> > trying to determine the type of guest it is before it even knows that
> > it is a guest.
> 
> It's worth noting that to some extent this may always be the case (e.g.
> is Dom0 a guest?), and it won't always be possible to determine if any
> (particular) hypervisor is present. For example, kvmtool does not place
> any special information in the DT regarding itself, and uses common
> peripherals (so you can't use these to fingerprint it reliably).

Right, but if we need kvm to advertise hypervisor features in some way,
(which, btw, x86 does do as well, by using a bitmap in another cpuid
leaf), then we'll need this DT node and ACPI table, or some other idea.
Anyway, it wouldn't hurt to have something now, just for the virt-what
type of case.

> This would work where you recognise the string, but so would looking for
> well-known strings.
> 
> The only thing you gain by assuming that the hypervisor has a node
> called /hypervisor is the ability to (sometimes) detect that a
> hypervisor you know nothing about is probably present.

You also gain a common location for the documentation of those
well-known strings, and the ability to share a bit of code in the
parsing.

> 
> > You're right about trying to shove two types of hypervisors into the
> > same hypervisor node with the compatible list though.  Generically
> > named properties, like 'reg', can only apply to one, so perhaps that
> > wouldn't work.
> 
> In general, it will not work.
> 
> As I understand it on x86 if KVM masquerades as HyperV it's not also
> visible as KVM. Is that correct?

Actually you can supply more than one hypervisor signature in the cpuids.
There's cpuid space allocated for up to 256. A guest can then search
the space in preference order for the hypervisor type it wants. QEMU/KVM
for x86 does this. It sets things up such that hyperv is in the first
location, which is the lowest preferred location for Linux, and likely
the only place Windows checks. It still puts KVM in the second location,
which is a higher preference location for Linux, and relies on Linux
finding it there. Linux finds it with
arch/x86/kernel/cpu/hypervisor.c:detect_hypervisor_vendor

Note how the hypervisor detection is common for all x86 hypervisors that
Linux knows about. A specified /hypervisor node could be the DT
equivalent. Unfortunately, as we've stated, specifying a list of
compatible hypervisor types in the compatible property won't work, as
generically named properties of the /hypervisor node would then become
useless. I guess we need something else.

> 
> There's also a huge grey area regarding what the guest should do if it
> thinks it recognises both HyperV and KVM (or any other combination)
> simultaneously.

I don't think so. If the guest searches in preference-order, or the list
order tells the guest which one it should prefer, as is done for x86,
then it just uses the most preferred, and supported, one it finds.

> 
> Is there any reason for a hypervisor to try to both masquerade as a
> different hypervisor and advertise itself natively? The whole sharing a
> node / table thing may be irrelevant.
>

Yes. When you don't know the guest type you're booting, then you need
to expose all that you can handle, and then rely on the guest to pick
the right one.

Thanks,
drew
