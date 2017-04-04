From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 2/9] KVM: Add documentation for VCPU requests
Date: Tue, 4 Apr 2017 19:23:40 +0200
Message-ID: <20170404172340.GQ11752@cbox>
References: <20170331160658.4331-1-drjones@redhat.com>
 <20170331160658.4331-3-drjones@redhat.com>
 <20170404152403.GK11752@cbox>
 <20170404170600.w6snnecqoi4aqv4d@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CAD040A63
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Apr 2017 13:21:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zPKQ1MQHDtrN for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Apr 2017 13:21:26 -0400 (EDT)
Received: from mail-wm0-f48.google.com (mail-wm0-f48.google.com [74.125.82.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B21F840948
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Apr 2017 13:21:26 -0400 (EDT)
Received: by mail-wm0-f48.google.com with SMTP id o81so31263331wmb.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 04 Apr 2017 10:23:38 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170404170600.w6snnecqoi4aqv4d@kamzik.brq.redhat.com>
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
Cc: marc.zyngier@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Apr 04, 2017 at 07:06:00PM +0200, Andrew Jones wrote:
> On Tue, Apr 04, 2017 at 05:24:03PM +0200, Christoffer Dall wrote:
> > Hi Drew,
> > 
> > On Fri, Mar 31, 2017 at 06:06:51PM +0200, Andrew Jones wrote:
> > > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > > ---
> > >  Documentation/virtual/kvm/vcpu-requests.rst | 114 ++++++++++++++++++++++++++++
> > >  1 file changed, 114 insertions(+)
> > >  create mode 100644 Documentation/virtual/kvm/vcpu-requests.rst
> > > 
> > > diff --git a/Documentation/virtual/kvm/vcpu-requests.rst b/Documentation/virtual/kvm/vcpu-requests.rst
> > > new file mode 100644
> > > index 000000000000..ea4a966d5c8a
> > > --- /dev/null
> > > +++ b/Documentation/virtual/kvm/vcpu-requests.rst
> > > @@ -0,0 +1,114 @@
> > > +=================
> > > +KVM VCPU Requests
> > > +=================
> > > +
> > > +Overview
> > > +========
> > > +
> > > +KVM supports an internal API enabling threads to request a VCPU thread to
> > > +perform some activity.  For example, a thread may request a VCPU to flush
> > > +its TLB with a VCPU request.  The API consists of only four calls::
> > > +
> > > +  /* Check if VCPU @vcpu has request @req pending. Clears the request. */
> > > +  bool kvm_check_request(int req, struct kvm_vcpu *vcpu);
> > > +
> > > +  /* Check if any requests are pending for VCPU @vcpu. */
> > > +  bool kvm_request_pending(struct kvm_vcpu *vcpu);
> > > +
> > > +  /* Make request @req of VCPU @vcpu. */
> > > +  void kvm_make_request(int req, struct kvm_vcpu *vcpu);
> > > +
> > > +  /* Make request @req of all VCPUs of the VM with struct kvm @kvm. */
> > > +  bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req);
> > > +
> > > +Typically a requester wants the VCPU to perform the activity as soon
> > > +as possible after making the request.  This means most requests,
> > > +kvm_make_request() calls, are followed by a call to kvm_vcpu_kick(),
> > > +and kvm_make_all_cpus_request() has the kicking of all VCPUs built
> > > +into it.
> > > +
> > > +VCPU Kicks
> > > +----------
> > > +
> > > +A VCPU kick does one of three things:
> > > +
> > > + 1) wakes a sleeping VCPU (which sleeps outside guest mode).
> > 
> > You could clarify this to say that a sleeping VCPU is a VCPU thread
> > which is not runnable and placed on waitqueue, and waking it makes
> > the thread runnable again.
> > 
> > > + 2) sends an IPI to a VCPU currently in guest mode, in order to bring it
> > > +    out.
> > > + 3) nothing, when the VCPU is already outside guest mode and not sleeping.
> > > +
> > > +VCPU Request Internals
> > > +======================
> > > +
> > > +VCPU requests are simply bit indices of the vcpu->requests bitmap.  This
> > > +means general bitops[1], e.g. clear_bit(KVM_REQ_UNHALT, &vcpu->requests),
> > > +may also be used.  The first 8 bits are reserved for architecture
> > > +independent requests, all additional bits are available for architecture
> > > +dependent requests.
> > 
> > Should we explain the ones that are generically defined and how they're
> > supposed to be used?  For example, we don't use them on ARM, and I don't
> > think I understand why another thread would ever make a PENDING_TIMER
> > request on a vcpu?
> 
> Yes, I agree the general requests should be described.  I'll have to
> figure out how :-)  Describing KVM_REQ_UNHALT will likely lead to a
> subsection on kvm_vcpu_block(), as you bring up below.
> 
> > 
> > > +
> > > +VCPU Requests with Associated State
> > > +===================================
> > > +
> > > +Requesters that want the requested VCPU to handle new state need to ensure
> > > +the state is observable to the requested VCPU thread's CPU at the time the
> > 
> > nit: need to ensure that the newly written state is observable ... by
> > the time it observed the request.
> > 
> > > +CPU observes the request.  This means a write memory barrier should be
> >                                                                  ^^^
> > 							         must
> > 
> > > +insert between the preparation of the state and the write of the VCPU
> >     ^^^
> >    inserted
> > 
> > I would rephrase this as: '... after writing the new state to memory and
> > before setting the VCPU request bit.'
> > 
> > 
> > > +request bitmap.  Additionally, on the requested VCPU thread's side, a
> > > +corresponding read barrier should be issued after reading the request bit
> >                                 ^^^       ^^^
> > 			       must      inserted (for consistency)
> > 
> > 
> > 
> > > +and before proceeding to use the state associated with it.  See the kernel
> >                             ^^^    ^
> > 		           read    new
> > 
> > 
> > > +memory barrier documentation [2].
> > 
> > I think it would be great if this document explains if this is currently
> > taken care of by the API you explain above or if there are cases where
> > people have to explicitly insert these barriers, and in that case, which
> > barriers they should use (if we know at this point already).
> 
> Will do.  The current API does take care of it.  I'll state that.  I'd
> have to grep around to see if there are any non-API users that also need
> barriers, but as they could change, I probably wouldn't want to call them
> out is the doc.  So I guess I'll still just wave my hand at that type of
> use.
> 

Sounds good.

> > 
> > > +
> > > +VCPU Requests and Guest Mode
> > > +============================
> > > +
> > 
> > I feel like an intro about the overall goal here is missing.  How about
> > something like this:
> > 
> >   When making requests to VCPUs, we want to avoid the receiving VCPU
> >   executing inside the guest for an arbitrary long time without handling
> >   the request.  The way we prevent this from happening is by keeping
> >   track of when a VCPU is running and sending an IPI to the physical CPU
> >   running the VCPU when that is the case.  However, each architecture
> >   implementation of KVM must take great care to ensure that requests are
> >   not missed when a VCPU stops running at the same time when a request
> >   is received.
> > 
> > Also, I'm not sure what the semantics are with kvm_vcpu_block().  Is it
> > ok to send a request to a VCPU and then the VCPU blocks and goes to
> > sleep forever even though there are pending requests?
> > kvm_vcpu_check_block() doesn't seem to check vcpu->requests which would
> > indicate that this is the case, but maybe architectures that actually do
> > use requests implement something else themselves?
> 
> I'll add a kvm_vcpu_block() subsection as part of the KVM_REQ_UNHALT
> documentation.
> 
> > 
> > > +As long as the guest is either in guest mode, in which case it gets an IPI
> > 
> > guest is in guest mode?
> 
> oops, s/guest/vcpu/
> 
> > 
> > Perhaps this could be more clearly written as:
> > 
> > As long as the VCPU is running, it is marked as having vcpu->mode =
> > IN_GUEST MODE.  A requesting thread observing IN_GUEST_MODE will send an
> > IPI to the CPU running the VCPU thread.  On the other hand, when a
> > requesting thread observes vcpu->mode == OUTSIDE_GUEST_MODE, it will not send
> > any IPIs, but will simply set the request bit, a the VCPU thread will be
> > able to check the requests before running the VCPU again.  However, the
> > transition...
> > 
> > > +and will definitely see the request, or is outside guest mode, but has yet
> > > +to do its final request check, and therefore when it does, it will see the
> > > +request, then things will work.  However, the transition from outside to
> > > +inside guest mode, after the last request check has been made, opens a
> > > +window where a request could be made, but the VCPU would not see until it
> > > +exits guest mode some time later.  See the table below.
> > 
> > This text, and the table below, only deals with the details of entering
> > the guest.  Should we talk about kvm_vcpu_exiting_guest_mode() and
> > anything related to exiting the guest?
> 
> I think all !IN_GUEST_MODE should behave the same, so I was avoiding
> the use of EXITING_GUEST_MODE and OUTSIDE_GUEST_MODE, which wouldn't be
> hard to address, but then I'd also have to address
> READING_SHADOW_PAGE_TABLES, which may complicate the document more than
> necessary.  I'm not sure we need to address a VCPU exiting guest mode,
> other than making sure it's clear that a VCPU that exits must check
> requests before it enters again.

But the problem is that kvm_make_all_cpus_request() only sends IPIs to
CPUs where the mode was different from OUTSIDE_GUEST_MODE, so there it's
about !OUTSIDE_GUEST_MODE rather than !IN_GUEST_MODE, so there's some
subtlety here which I feel like it's dangerous to paper over.

> 
> > 
> > > +
> > > ++------------------+-----------------+----------------+--------------+
> > > +| vcpu->mode       | done last check | kick sends IPI | request seen |
> > > ++==================+=================+================+==============+
> > > +| IN_GUEST_MODE    |      N/A        |      YES       |     YES      |
> > > ++------------------+-----------------+----------------+--------------+
> > > +| !IN_GUEST_MODE   |      NO         |      NO        |     YES      |
> > > ++------------------+-----------------+----------------+--------------+
> > > +| !IN_GUEST_MODE   |      YES        |      NO        |     NO       |
> > > ++------------------+-----------------+----------------+--------------+
> > > +
> > > +To ensure the third scenario shown in the table above cannot happen, we
> > > +need to ensure the VCPU's mode change is observable by all CPUs prior to
> > > +its final request check and that a requester's request is observable by
> > > +the requested VCPU prior to the kick.  To do that we need general memory
> > > +barriers between each pair of operations involving mode and requests, i.e.
> > > +
> > > +  CPU_i                                  CPU_j
> > > +-------------------------------------------------------------------------
> > > +  vcpu->mode = IN_GUEST_MODE;            kvm_make_request(REQ, vcpu);
> > > +  smp_mb();                              smp_mb();
> > > +  if (kvm_request_pending(vcpu))         if (vcpu->mode == IN_GUEST_MODE)
> > > +      handle_requests();                     send_IPI(vcpu->cpu);
> > > +
> > > +Whether explicit barriers are needed, or reliance on implicit barriers is
> > > +sufficient, is architecture dependent.  Alternatively, an architecture may
> > > +choose to just always send the IPI, as not sending it, when it's not
> > > +necessary, is just an optimization.
> > 
> > Is this universally true?  This is certainly true on ARM, because we
> > disable interrupts before doing all this, so the IPI remains pending and
> > causes an immediate exit, but if any of the above is done with
> > interrupts enabled, just sending an IPI does nothing to ensure the
> > request is observed.  Perhaps this is not a case we should care about.
> 
> I'll try to make this less generic, as some architectures may not work
> this way.  Indeed, s390 doesn't seem to have kvm_vcpu_kick(), so I guess
> things don't work this way for them.
> 
> > 
> > > +
> > > +Additionally, the error prone third scenario described above also exhibits
> > > +why a request-less VCPU kick is almost never correct.  Without the
> > > +assurance that a non-IPI generating kick will still result in an action by
> > > +the requested VCPU, as the final kvm_request_pending() check does, then
> > > +the kick may not initiate anything useful at all.  If, for instance, a
> > > +request-less kick was made to a VCPU that was just about to set its mode
> > > +to IN_GUEST_MODE, meaning no IPI is sent, then the VCPU may continue its
> > > +entry without actually having done whatever it was the kick was meant to
> > > +initiate.
> > 
> > Indeed.
> > 
> > 
> > > +
> > > +References
> > > +==========
> > > +
> > > +[1] Documentation/core-api/atomic_ops.rst
> > > +[2] Documentation/memory-barriers.txt
> > > -- 
> > > 2.9.3
> > > 
> > 
> > This is a great writeup!  I enjoyed reading it and it made me think more
> > carefully about a number of things, so I definitely think we should
> > merge this.
> >
> 
> Thanks Christoffer!  I'll take all your suggestions above and try to
> answer your questions for v2.
> 

Awesome, I hope Radim finds this useful for his series and the rework
later on.

Thanks,
-Christoffer
