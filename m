From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: Advice on HYP interface for AsyncPF
Date: Thu, 9 Apr 2015 15:00:27 +0100
Message-ID: <20150409140027.GB9648@leverpostej>
References: <5525DA0E.2010103@samsung.com>
 <20150409085723.0a201cb9@why.wild-wind.fr.eu.org>
 <20150409120646.GA3212@hawk.usersys.redhat.com>
 <20150409124852.GE18488@leverpostej>
 <20150409134326.GF3212@hawk.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BBC14BE91
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Apr 2015 09:52:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Xpv0V8hqx-EO for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Apr 2015 09:52:55 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 243A24BE83
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Apr 2015 09:52:54 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20150409134326.GF3212@hawk.usersys.redhat.com>
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

> > While the HVC immediate could be used to distinguish different types of
> > calls, the guest still needs to first determine that issuing a HVC is
> > not going to bring down the system, which requires it to know that a
> > suitable hypervisor is present.
> 
> Right. I forgot we don't have anything for this in the kvmarm world. I
> should have remembered, having just crossed this path for a different
> issue (virt-what). In the x86 world we have a cpuid that allows guests
> to see that they are a) a guest and b) of what type. The hypervisor can
> fake the type if it wishes. For example KVM can emulate HyperV, allowing
> Windows guests to use their "native" PV ops.
> 
> In the ARM world the hypervisor DT node does seem to be the closet
> equivalent that currently exists. Both Xen and ppc KVM use it already.
> Using this for DT guests means we'll need the ACPI solution though.

Sure.

> > > > Maybe we should adopt Xen's idea of a hypervisor node in DT where we
> > > > would describe the various services? How will that work with ACPI?
> > > 
> > > I don't think we'll ever have a "virt guest" ACPI table that we can
> > > use for this stuff, so this won't work for ACPI. But I think the ENOSYS
> > > probing should be sufficient for this anyway.
> > 
> > As mentioned above, I don't think that probing is safe.
> > 
> > What prevents us from creating a trivial "KVM guest" table that we can
> > use to determine that we can query more advanced info from KVM itself?
> > Given the point is to expose KVM-specific functionality, I don't see why
> > we need a more generic "virt guest" ACPI table.
> >
> 
> Just as the hypervisor node is more attractive with the consideration
> that it's being adopted by other parties (xen and kvmppc), any ACPI
> tables will be more likely to be accepted if they have buy-in from
> a greater audience. kvmarm would be the only consumer for the time
> being, but it'd be good if it was more general from the start,
> particularly if general kernel code would need to know about it.

I'm not sure I follow, given that there's no generic hypervisor node in
DT at the moment.

In the case of Xen there's a node with a "xen,xen" compatible string.

In the case of PPC KVM, there's a node with a "linux,kvm" compatible
string.

These don't have any overlap. I'm not sure what a generic node would buy
you short of detecting (some cases) when you're begin virtualised, given
you'd have to know about the particular hypervisor and/or services
anyway.

Mark.
