From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: Advice on HYP interface for AsyncPF
Date: Thu, 9 Apr 2015 16:20:09 +0100
Message-ID: <20150409152009.GH9648@leverpostej>
References: <5525DA0E.2010103@samsung.com>
 <20150409085723.0a201cb9@why.wild-wind.fr.eu.org>
 <20150409120646.GA3212@hawk.usersys.redhat.com>
 <20150409124852.GE18488@leverpostej>
 <20150409134326.GF3212@hawk.usersys.redhat.com>
 <20150409140027.GB9648@leverpostej>
 <20150409142258.GH3212@hawk.usersys.redhat.com>
 <20150409143714.GD9648@leverpostej>
 <20150409145414.GJ3212@hawk.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 60D474BEFF
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Apr 2015 11:12:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yrbYd-HcTdxz for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Apr 2015 11:12:37 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E89F14BE83
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Apr 2015 11:12:36 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20150409145414.GJ3212@hawk.usersys.redhat.com>
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
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

> > > For example, if Windows guests were taught to look for a particular
> > > ACPI table to learn about their HyperV features, then KVM could fake
> > > that table and also emulate the hypercalls.
> > 
> > This requires KVM to provide those services and for the information to
> > be in the appropriate location. This does not require all hypervisors to
> > place information in the same location, nor for there to be a common
> > format for that information.
> > 
> > > Besides, tools like virt-what would benefit from knowing where to
> > > look, etc.
> > 
> > This is a different case, for which a common location would likely be
> > helpful, though not complete.
> > 
> > > So, if we go the ACPI table route, then I think it should be a
> > > hypervisor and architecture agnostic table. Just as the "hypervisor"
> > > node is super generically named, and it's up to the compatible strings
> > > to sort it out.
> > > 
> > > (btw, the hypervisor node already supports faking other hypervisors with
> > >  its compatible string. You could specify "linux,kvm" first, and
> > >  "xen,xen" second, if you had the capability to emulate the later.)
> > 
> > Evidently we have different views w.r.t. binding to tables.
> > 
> > From my PoV, a node which we don't recognise the compatible string for
> > (which is not a legacy node with a static path) is something we know
> > nothing about, and any name applied to the node is just there to help
> > the casual reader. For there to be a contract as to the purpose and
> > format of the node, there should be a compatible string list.
> 
> I see your point of view. I see the hypervisor node as the
> "you are a guest" indicator, which, for convenience, should be common
> across guests. 

I assume you mean common across hypervisors?

A node called "hypervisor" is admittedly a pretty good sign, but there
won't always be such a node.

We can certainly encourage vendors to call their node /hypervisor. I
don't think that it makes sense to enforce a common binding across
these, because they are by definition trying to convey
hypervisor-specific information.

> Otherwise the "is_guest()" function would be many if-else statements
> trying to determine the type of guest it is before it even knows that
> it is a guest.

It's worth noting that to some extent this may always be the case (e.g.
is Dom0 a guest?), and it won't always be possible to determine if any
(particular) hypervisor is present. For example, kvmtool does not place
any special information in the DT regarding itself, and uses common
peripherals (so you can't use these to fingerprint it reliably).

> If the hypervisor node exists, then is_guest() is true, and the
> compatible string will tell us how to proceed with the type. 

Nit: s/the hypervisor node/a hypervisor node/ -- let's not pretend
there's a common standard where there is not.

This would work where you recognise the string, but so would looking for
well-known strings.

The only thing you gain by assuming that the hypervisor has a node
called /hypervisor is the ability to (sometimes) detect that a
hypervisor you know nothing about is probably present.

> You're right about trying to shove two types of hypervisors into the
> same hypervisor node with the compatible list though.  Generically
> named properties, like 'reg', can only apply to one, so perhaps that
> wouldn't work.

In general, it will not work.

As I understand it on x86 if KVM masquerades as HyperV it's not also
visible as KVM. Is that correct?

There's also a huge grey area regarding what the guest should do if it
thinks it recognises both HyperV and KVM (or any other combination)
simultaneously.

Is there any reason for a hypervisor to try to both masquerade as a
different hypervisor and advertise itself natively? The whole sharing a
node / table thing may be irrelevant.

Thanks,
Mark.
