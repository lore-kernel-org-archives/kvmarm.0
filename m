From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: Advice on HYP interface for AsyncPF
Date: Thu, 9 Apr 2015 16:22:33 +0200
Message-ID: <20150409142233.GP4715@cbox>
References: <5525DA0E.2010103@samsung.com>
 <20150409085723.0a201cb9@why.wild-wind.fr.eu.org>
 <20150409120646.GA3212@hawk.usersys.redhat.com>
 <20150409133506.GN4715@cbox>
 <20150409135945.GG3212@hawk.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FD3F4BEB9
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Apr 2015 10:14:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0L07UjKnFOXX for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Apr 2015 10:14:57 -0400 (EDT)
Received: from mail-la0-f46.google.com (mail-la0-f46.google.com
 [209.85.215.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3D1814BEAE
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Apr 2015 10:14:57 -0400 (EDT)
Received: by labbd9 with SMTP id bd9so79326021lab.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Apr 2015 07:22:32 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20150409135945.GG3212@hawk.usersys.redhat.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Apr 09, 2015 at 03:59:46PM +0200, Andrew Jones wrote:
> On Thu, Apr 09, 2015 at 03:35:06PM +0200, Christoffer Dall wrote:
> > On Thu, Apr 09, 2015 at 02:06:47PM +0200, Andrew Jones wrote:
> > > On Thu, Apr 09, 2015 at 08:57:23AM +0100, Marc Zyngier wrote:
> > > > On Thu, 9 Apr 2015 02:46:54 +0100
> > > > Mario Smarduch <m.smarduch@samsung.com> wrote:
> > > > 
> > > > Hi Mario,
> > > > 
> > > > > I'm working with AsyncPF, and currently using
> > > > > hyp call to communicate guest GFN for host to inject
> > > > > virtual abort - page not available/page available.
> > > > > 
> > > > > Currently only PSCI makes use of that interface,
> > > > > (handle_hvc()) can we overload interface with additional
> > > > > hyp calls in this case pass guest gfn? Set arg0
> > > > > to some range outside of PSCI use.
> > > > 
> > > > I can't see a reason why we wouldn't open handle_hvc() to other
> > > > paravirtualized services. But this has to be done with extreme caution:
> > > > 
> > > > - This becomes an ABI between host and guest
> > > 
> > > To expand on that, if the benefits don't out weight the maintenance
> > > required for that ABI, for life, then it turns into a life-time burden.
> > > Any guest-host speedups that can be conceived, which require hypercalls,
> > > should probably be bounced of the hardware people first. Waiting for
> > > improvements in the virt extensions may be a better choice than
> > > committing to a PV solution.
> > > 
> > > > - We need a discovery protocol
> > > 
> > > Hopefully all users of the PSCI hypcall have been using function #0,
> > > because handle_hvc unfortunately hasn't been checking it.
> > 
> > huh?  I don't understand this, sorry.
> 
> The hvc immediate used for psci is 0, and that's fine because there's
> only a single hvc function currently defined. If we want to define
> additional functions then we could assign each additional function a
> new immediate. However, as we've never enforced the immediate to be
> zero, then there's no guarantee we won't mess up a guest that expects
> any immediate to work.

you're refering to an implicit definition of an "hvc function"
differentiated by the immediate field - this is what threw me off.

> 
> Of course we can continue allowing any immediate to work too, by
> passing the function number in some register. Xen uses x16? We could
> use reg0 too, and just integrate with the PSCI function space as well.
> 

I think you have to allow any immediate value, since I don't think PSCI
differentiates on that, and we want to implement that spec.  So if you
can't rely on re-using the PSCI function numbers within a different
immediate number space, you might as well use the register that PSCI
uses for differentiating between 'functions'.

> > 
> > > In any case,
> > > I'm not sure we have much choice but to start enforcing it now. Once we
> > > do, with something like
> > > 
> > > switch(hypcall_nr) {
> > > case 0: /* handle psci call */
> > > default: return -KVM_ENOSYS;
> > > }
> > > 
> > > then, I think the guest's discovery protocol can simply be
> > > 
> > > if (do_hypercall() == -ENOSYS) {
> > >    /* PV path not supported, fall back to whatever... */
> > > }
> > > 
> > > > - We need to make sure other hypervisors don't reuse the same function
> > > >   number for other purposes
> > > 
> > > I'm not sure what this means. Xen already has several hypercalls defined
> > > for ARM, the same that they have for x86, which don't match any of the
> > > KVM hypercalls. Now, KVM for other arches (which is maybe what you meant)
> > > does define a handful, which we should integrate with, as KVM mixes
> > > architectures within it's hypercall number allocation, see
> > > include/uapi/linux/kvm_para.h. Just using the common code should make it
> > > easy to avoid problems. We don't have a problem with the PSCI hypcall, as
> > > zero isn't allocated. Ideally we would define PSCI properly though,
> > > e.g. KVM_HC_ARM_PSCI, and still reserve zero in the common header. To do
> > > that maybe we'll need to keep #0 as an ARM-only alias for the new number
> > > for compatibility now?
> > > 
> > > > 
> > > > Maybe we should adopt Xen's idea of a hypervisor node in DT where we
> > > > would describe the various services? How will that work with ACPI?
> > > 
> > > I don't think we'll ever have a "virt guest" ACPI table that we can
> > > use for this stuff, so this won't work for ACPI. But I think the ENOSYS
> > > probing should be sufficient for this anyway.
> > > 
> > We've reserved a Xen table on ACPI, not sure why we can't do the same
> > for KVM or a generic ARM PV table for that matter... ?
> 
> OK. Does that table require the Linux kernel (outside dom0 specific
> code) to know about it? Would a more generic table require that? I'm
> always wary of virt creep.
> 

Not sure what your distinction between dom0 specific code and Linux is,
but it's very similar to the Xen node in the DT.  If it's present and
contain valid entries, the table tells an OS that it's running on the
Xen hypervisor and provides the necessary info to run on Xen, such as
the grant table addresses etc.

See the spec here:
http://wiki.xenproject.org/mediawiki/images/c/c4/Xen-environment-table.pdf

Note that this table spec is not part of the ACPI spec but is just a
reserved name, which is significantly easier than including something in
the ACPI spec itself.  For the purposes of Linux on KVM/ARM this is
completely fine too, and if anything else wants to run on KVM/ARM they
most likely will refer to the same table and/or advocate including the
table spec within the ACPI spec itself.

-Christoffer
