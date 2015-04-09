From: Andrew Jones <drjones@redhat.com>
Subject: Re: Advice on HYP interface for AsyncPF
Date: Thu, 9 Apr 2015 15:43:27 +0200
Message-ID: <20150409134326.GF3212@hawk.usersys.redhat.com>
References: <5525DA0E.2010103@samsung.com>
 <20150409085723.0a201cb9@why.wild-wind.fr.eu.org>
 <20150409120646.GA3212@hawk.usersys.redhat.com>
 <20150409124852.GE18488@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 768D64BE77
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Apr 2015 09:36:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wk3xxnTlt+xN for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Apr 2015 09:35:58 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 48E534BE74
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Apr 2015 09:35:57 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20150409124852.GE18488@leverpostej>
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

On Thu, Apr 09, 2015 at 01:48:52PM +0100, Mark Rutland wrote:
> On Thu, Apr 09, 2015 at 01:06:47PM +0100, Andrew Jones wrote:
> > On Thu, Apr 09, 2015 at 08:57:23AM +0100, Marc Zyngier wrote:
> > > On Thu, 9 Apr 2015 02:46:54 +0100
> > > Mario Smarduch <m.smarduch@samsung.com> wrote:
> > > 
> > > Hi Mario,
> > > 
> > > > I'm working with AsyncPF, and currently using
> > > > hyp call to communicate guest GFN for host to inject
> > > > virtual abort - page not available/page available.
> > > > 
> > > > Currently only PSCI makes use of that interface,
> > > > (handle_hvc()) can we overload interface with additional
> > > > hyp calls in this case pass guest gfn? Set arg0
> > > > to some range outside of PSCI use.
> > > 
> > > I can't see a reason why we wouldn't open handle_hvc() to other
> > > paravirtualized services. But this has to be done with extreme caution:
> > > 
> > > - This becomes an ABI between host and guest
> > 
> > To expand on that, if the benefits don't out weight the maintenance
> > required for that ABI, for life, then it turns into a life-time burden.
> > Any guest-host speedups that can be conceived, which require hypercalls,
> > should probably be bounced of the hardware people first. Waiting for
> > improvements in the virt extensions may be a better choice than
> > committing to a PV solution.
> > 
> > > - We need a discovery protocol
> > 
> > Hopefully all users of the PSCI hypcall have been using function #0,
> > because handle_hvc unfortunately hasn't been checking it. In any case,
> > I'm not sure we have much choice but to start enforcing it now. Once we
> > do, with something like
> > 
> > switch(hypcall_nr) {
> > case 0: /* handle psci call */
> > default: return -KVM_ENOSYS;
> > }
> > 
> > then, I think the guest's discovery protocol can simply be
> > 
> > if (do_hypercall() == -ENOSYS) {
> >    /* PV path not supported, fall back to whatever... */
> > }
> 
> That only tells you the code at EL2/Hyp did something, and only if it
> actually returns. Call this on a different hypervisor (or in the absence
> of one, there's no mechanism for querying) and you might bring down that
> CPU or the entire system.
> 
> We need to be able to detect that some hypercall interface is present
> _before_ issuing the relevant hypercalls. As Marc mentioned, we could
> have a DT node and/or ACPI entry for this, and it only needs to tell us
> enough to bootstrap querying the hypervisor for more info (as is the
> case with Xen, I believe).
> 
> > 
> > > - We need to make sure other hypervisors don't reuse the same function
> > >   number for other purposes
> 
> I don't think this is a problem so long as there's a mechanism for
> detecting the hyp interfaces provided. Xen and KVM could use the same
> numbers for different things and that's fine because you'll only use the
> Xen functions when you see the Xen node, and the KVM functions when you
> are aware you're under KVM. You can't have both simultaneously.
> 
> However, these numbers must be chosen so as not to clash with SMC/HVC
> Calling Convention IDs. We can't risk clashing with PSCI or other
> standard interfaces we may want to expose to a guest in future.
> 
> > I'm not sure what this means. Xen already has several hypercalls defined
> > for ARM, the same that they have for x86, which don't match any of the
> > KVM hypercalls. Now, KVM for other arches (which is maybe what you meant)
> > does define a handful, which we should integrate with, as KVM mixes
> > architectures within it's hypercall number allocation, see
> > include/uapi/linux/kvm_para.h. Just using the common code should make it
> > easy to avoid problems. We don't have a problem with the PSCI hypcall, as
> > zero isn't allocated. Ideally we would define PSCI properly though,
> > e.g. KVM_HC_ARM_PSCI, and still reserve zero in the common header. To do
> > that maybe we'll need to keep #0 as an ARM-only alias for the new number
> > for compatibility now?
> 
> While the HVC immediate could be used to distinguish different types of
> calls, the guest still needs to first determine that issuing a HVC is
> not going to bring down the system, which requires it to know that a
> suitable hypervisor is present.

Right. I forgot we don't have anything for this in the kvmarm world. I
should have remembered, having just crossed this path for a different
issue (virt-what). In the x86 world we have a cpuid that allows guests
to see that they are a) a guest and b) of what type. The hypervisor can
fake the type if it wishes. For example KVM can emulate HyperV, allowing
Windows guests to use their "native" PV ops.

In the ARM world the hypervisor DT node does seem to be the closet
equivalent that currently exists. Both Xen and ppc KVM use it already.
Using this for DT guests means we'll need the ACPI solution though.

> 
> > > Maybe we should adopt Xen's idea of a hypervisor node in DT where we
> > > would describe the various services? How will that work with ACPI?
> > 
> > I don't think we'll ever have a "virt guest" ACPI table that we can
> > use for this stuff, so this won't work for ACPI. But I think the ENOSYS
> > probing should be sufficient for this anyway.
> 
> As mentioned above, I don't think that probing is safe.
> 
> What prevents us from creating a trivial "KVM guest" table that we can
> use to determine that we can query more advanced info from KVM itself?
> Given the point is to expose KVM-specific functionality, I don't see why
> we need a more generic "virt guest" ACPI table.
>

Just as the hypervisor node is more attractive with the consideration
that it's being adopted by other parties (xen and kvmppc), any ACPI
tables will be more likely to be accepted if they have buy-in from
a greater audience. kvmarm would be the only consumer for the time
being, but it'd be good if it was more general from the start,
particularly if general kernel code would need to know about it.

drew
