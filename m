From: Andrew Jones <drjones@redhat.com>
Subject: Re: Advice on HYP interface for AsyncPF
Date: Thu, 9 Apr 2015 16:54:14 +0200
Message-ID: <20150409145414.GJ3212@hawk.usersys.redhat.com>
References: <5525DA0E.2010103@samsung.com>
 <20150409085723.0a201cb9@why.wild-wind.fr.eu.org>
 <20150409120646.GA3212@hawk.usersys.redhat.com>
 <20150409124852.GE18488@leverpostej>
 <20150409134326.GF3212@hawk.usersys.redhat.com>
 <20150409140027.GB9648@leverpostej>
 <20150409142258.GH3212@hawk.usersys.redhat.com>
 <20150409143714.GD9648@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 599964BEF3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Apr 2015 10:46:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ignthpkUfGgi for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Apr 2015 10:46:43 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6D7DD4BEF0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Apr 2015 10:46:42 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20150409143714.GD9648@leverpostej>
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

On Thu, Apr 09, 2015 at 03:37:14PM +0100, Mark Rutland wrote:
> > > > Just as the hypervisor node is more attractive with the consideration
> > > > that it's being adopted by other parties (xen and kvmppc), any ACPI
> > > > tables will be more likely to be accepted if they have buy-in from
> > > > a greater audience. kvmarm would be the only consumer for the time
> > > > being, but it'd be good if it was more general from the start,
> > > > particularly if general kernel code would need to know about it.
> > > 
> > > I'm not sure I follow, given that there's no generic hypervisor node in
> > > DT at the moment.
> > > 
> > > In the case of Xen there's a node with a "xen,xen" compatible string.
> > > 
> > > In the case of PPC KVM, there's a node with a "linux,kvm" compatible
> > > string.
> > 
> > DT nodes documented in Documentation/devicetree/bindings are about as
> > good as DT node formalism gets, right? Currently the hypervisor node
> > is only documented separately in the arm/ and powerpc/ dirs, so maybe
> > a Documentation/devicetree/bindings/hypervisor.txt file would be a good
> > addition in order to make the common node official.
> 
> From my PoV, each hypervisor has its own binding, which is identified by
> its set of compatible strings, and node naming colliding on
> "/hypervisor" is coincidental.
> 
> We can suggest that "/hypervisor" is the usual name for a node related
> to a hypervisor, but that tells us nothing about the format of the node.
> 
> > > These don't have any overlap. I'm not sure what a generic node would
> > > buy
> > > you short of detecting (some cases) when you're begin virtualised, given
> > > you'd have to know about the particular hypervisor and/or services
> > > anyway.
> > 
> > As I pointed out, it's possible to fake one hypervisor with another,
> > but only if the guest knows just one (standard) place too look.
> 
> For a hypervisor to impersonate another, it just needs to do whatever
> that other hypervisor does. The guest needs to know where to look for
> the info relating to the hypervisor being impersonated, but that does
> not require a common location.

True. Not required, but more convenient.

> 
> > For example, if Windows guests were taught to look for a particular
> > ACPI table to learn about their HyperV features, then KVM could fake
> > that table and also emulate the hypercalls.
> 
> This requires KVM to provide those services and for the information to
> be in the appropriate location. This does not require all hypervisors to
> place information in the same location, nor for there to be a common
> format for that information.
> 
> > Besides, tools like virt-what would benefit from knowing where to
> > look, etc.
> 
> This is a different case, for which a common location would likely be
> helpful, though not complete.
> 
> > So, if we go the ACPI table route, then I think it should be a
> > hypervisor and architecture agnostic table. Just as the "hypervisor"
> > node is super generically named, and it's up to the compatible strings
> > to sort it out.
> > 
> > (btw, the hypervisor node already supports faking other hypervisors with
> >  its compatible string. You could specify "linux,kvm" first, and
> >  "xen,xen" second, if you had the capability to emulate the later.)
> 
> Evidently we have different views w.r.t. binding to tables.
> 
> From my PoV, a node which we don't recognise the compatible string for
> (which is not a legacy node with a static path) is something we know
> nothing about, and any name applied to the node is just there to help
> the casual reader. For there to be a contract as to the purpose and
> format of the node, there should be a compatible string list.

I see your point of view. I see the hypervisor node as the
"you are a guest" indicator, which, for convenience, should be common
across guests. Otherwise the "is_guest()" function would be many
if-else statements trying to determine the type of guest it is before
it even knows that it is a guest. If the hypervisor node exists, then
is_guest() is true, and the compatible string will tell us how to
proceed with the type. You're right about trying to shove two types of
hypervisors into the same hypervisor node with the compatible list though.
Generically named properties, like 'reg', can only apply to one, so
perhaps that wouldn't work.

Thanks,
drew
