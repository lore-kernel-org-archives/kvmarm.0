From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v4 03/11] KVM: Add documentation for VCPU requests
Date: Fri, 26 May 2017 09:31:00 +0200
Message-ID: <20170526073100.GD6319@cbox>
References: <20170516022035.7674-1-drjones@redhat.com>
 <20170516022035.7674-4-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C033940A86
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 May 2017 03:27:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2w179NwdtL7C for <kvmarm@lists.cs.columbia.edu>;
 Fri, 26 May 2017 03:27:32 -0400 (EDT)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com [74.125.82.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3A1E940962
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 May 2017 03:27:31 -0400 (EDT)
Received: by mail-wm0-f52.google.com with SMTP id e127so10489458wmg.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 May 2017 00:31:17 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170516022035.7674-4-drjones@redhat.com>
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

Hi Drew,

On Tue, May 16, 2017 at 04:20:27AM +0200, Andrew Jones wrote:
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  Documentation/virtual/kvm/vcpu-requests.rst | 299 ++++++++++++++++++++++++++++
>  1 file changed, 299 insertions(+)
>  create mode 100644 Documentation/virtual/kvm/vcpu-requests.rst
> 
> diff --git a/Documentation/virtual/kvm/vcpu-requests.rst b/Documentation/virtual/kvm/vcpu-requests.rst
> new file mode 100644
> index 000000000000..7a2b4c05c267
> --- /dev/null
> +++ b/Documentation/virtual/kvm/vcpu-requests.rst
> @@ -0,0 +1,299 @@
> +=================
> +KVM VCPU Requests
> +=================
> +
> +Overview
> +========
> +
> +KVM supports an internal API enabling threads to request a VCPU thread to
> +perform some activity.  For example, a thread may request a VCPU to flush
> +its TLB with a VCPU request.  The API consists of the following functions::
> +
> +  /* Check if any requests are pending for VCPU @vcpu. */
> +  bool kvm_request_pending(struct kvm_vcpu *vcpu);
> +
> +  /* Check if VCPU @vcpu has request @req pending. */
> +  bool kvm_test_request(int req, struct kvm_vcpu *vcpu);
> +
> +  /* Clear request @req for VCPU @vcpu. */
> +  void kvm_clear_request(int req, struct kvm_vcpu *vcpu);
> +
> +  /*
> +   * Check if VCPU @vcpu has request @req pending. When the request is
> +   * pending it will be cleared and a memory barrier, which pairs with
> +   * another in kvm_make_request(), will be issued.
> +   */
> +  bool kvm_check_request(int req, struct kvm_vcpu *vcpu);
> +
> +  /*
> +   * Make request @req of VCPU @vcpu. Issues a memory barrier, which pairs
> +   * with another in kvm_check_request(), prior to setting the request.
> +   */
> +  void kvm_make_request(int req, struct kvm_vcpu *vcpu);
> +
> +  /* Make request @req of all VCPUs of the VM with struct kvm @kvm. */
> +  bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req);
> +
> +Typically a requester wants the VCPU to perform the activity as soon
> +as possible after making the request.  This means most requests
> +(kvm_make_request() calls) are followed by a call to kvm_vcpu_kick(),
> +and kvm_make_all_cpus_request() has the kicking of all VCPUs built
> +into it.
> +
> +VCPU Kicks
> +----------
> +
> +The goal of a VCPU kick is to bring a VCPU thread out of guest mode in
> +order to perform some KVM maintenance.  To do so, an IPI is sent, forcing
> +a guest mode exit.  However, a VCPU thread may not be in guest mode at the
> +time of the kick.  Therefore, depending on the mode and state of the VCPU
> +thread, there are two other actions a kick may take.  All three actions
> +are listed below:
> +
> +1) Send an IPI.  This forces a guest mode exit.
> +2) Waking a sleeping VCPU.  Sleeping VCPUs are VCPU threads outside guest
> +   mode that wait on waitqueues.  Waking them removes the threads from
> +   the waitqueues, allowing the threads to run again.  This behavior
> +   may be suppressed, see KVM_REQUEST_NO_WAKEUP below.
> +3) Nothing.  When the VCPU is not in guest mode and the VCPU thread is not
> +   sleeping, then there is nothing to do.
> +
> +VCPU Mode
> +---------
> +
> +VCPUs have a mode state, ``vcpu->mode``, that is used to track whether the
> +guest is running in guest mode or not, as well as some specific
> +outside guest mode states.  The architecture may use ``vcpu->mode`` to
> +ensure VCPU requests are seen by VCPUs (see "Ensuring Requests Are Seen"),
> +as well as to avoid sending unnecessary IPIs (see "IPI Reduction"), and
> +even to ensure IPI acknowledgements are waited upon (see "Waiting for
> +Acknowledgements").  The following modes are defined:
> +
> +OUTSIDE_GUEST_MODE
> +
> +  The VCPU thread is outside guest mode.
> +
> +IN_GUEST_MODE
> +
> +  The VCPU thread is in guest mode.
> +
> +EXITING_GUEST_MODE
> +
> +  The VCPU thread is transitioning from IN_GUEST_MODE to
> +  OUTSIDE_GUEST_MODE.
> +
> +READING_SHADOW_PAGE_TABLES
> +
> +  The VCPU thread is outside guest mode, but it wants the sender of
> +  certain VCPU requests, namely KVM_REQ_TLB_FLUSH, to wait until the VCPU
> +  thread is done reading the page tables.
> +
> +VCPU Request Internals
> +======================
> +
> +VCPU requests are simply bit indices of the ``vcpu->requests`` bitmap.
> +This means general bitops, like those documented in [atomic-ops]_ could
> +also be used, e.g. ::
> +
> +  clear_bit(KVM_REQ_UNHALT & KVM_REQUEST_MASK, &vcpu->requests);
> +
> +However, VCPU request users should refrain from doing so, as it would
> +break the abstraction.  The first 8 bits are reserved for architecture
> +independent requests, all additional bits are available for architecture
> +dependent requests.
> +
> +Architecture Independent Requests
> +---------------------------------
> +
> +KVM_REQ_TLB_FLUSH
> +
> +  KVM's common MMU notifier may need to flush all of a guest's TLB
> +  entries, calling kvm_flush_remote_tlbs() to do so.  Architectures that
> +  choose to use the common kvm_flush_remote_tlbs() implementation will
> +  need to handle this VCPU request.
> +
> +KVM_REQ_MMU_RELOAD
> +
> +  When shadow page tables are used and memory slots are removed it's
> +  necessary to inform each VCPU to completely refresh the tables.  This
> +  request is used for that.
> +
> +KVM_REQ_PENDING_TIMER
> +
> +  This request may be made from a timer handler run on the host on behalf
> +  of a VCPU.  It informs the VCPU thread to inject a timer interrupt.
> +
> +KVM_REQ_UNHALT
> +
> +  This request may be made from the KVM common function kvm_vcpu_block(),
> +  which is used to emulate an instruction that causes a CPU to halt until
> +  one of an architectural specific set of events and/or interrupts is
> +  received (determined by checking kvm_arch_vcpu_runnable()).  When that
> +  event or interrupt arrives kvm_vcpu_block() makes the request.  This is
> +  in contrast to when kvm_vcpu_block() returns due to any other reason,
> +  such as a pending signal, which does not indicate the VCPU's halt
> +  emulation should stop, and therefore does not make the request.
> +
> +KVM_REQUEST_MASK
> +----------------
> +
> +VCPU requests should be masked by KVM_REQUEST_MASK before using them with
> +bitops.  This is because only the lower 8 bits are used to represent the
> +request's number.  The upper bits are used as flags.  Currently only two
> +flags are defined.
> +
> +VCPU Request Flags
> +------------------
> +
> +KVM_REQUEST_NO_WAKEUP
> +
> +  This flag is applied to a request that does not need immediate
> +  attention.  When a request does not need immediate attention, and the

Isn't this an over-simplification?  I thought KVM_REQUEST_NO_WAKEUP was
only used in cases where you simply want to make sure the VCPU is not
ignoring a request while exexuting in the guest, but if it's sleeping
and therefore not in the guest, it can just handle the request whenever
it wakes up anyway.  So perhaps something like:

   This flag is applied to a request that only needs immediate attention
   from VCPUs running in the guest.  That is, sleeping VCPUs do not need
   to be removed from their waitqueues but can handle this request when
   they wake up for any other reason.

> +  VCPU's thread is outside guest mode sleeping, then the thread is not
> +  awaken by a kick.
> +
> +KVM_REQUEST_WAIT
> +
> +  When requests with this flag are made with kvm_make_all_cpus_request(),
> +  then the caller will wait for each VCPU to acknowledge the IPI before
> +  proceeding.

How does the interaction work with KVM_REQUEST_NO_WAKEUP?  Does it mean
it only waits on those VCPUs to which is needs to send an IPI, but the
rest are ignored ?

> +
> +VCPU Requests with Associated State
> +===================================
> +
> +Requesters that want the receiving VCPU to handle new state need to ensure
> +the newly written state is observable to the receiving VCPU thread's CPU
> +by the time it observes the request.  This means a write memory barrier
> +must be inserted after writing the new state and before setting the VCPU
> +request bit.  Additionally, on the receiving VCPU thread's side, a
> +corresponding read barrier must be inserted after reading the request bit
> +and before proceeding to read the new state associated with it.  See
> +scenario 3, Message and Flag, of [lwn-mb]_ and the kernel documentation
> +[memory-barriers]_.
> +
> +The pair of functions, kvm_check_request() and kvm_make_request(), provide
> +the memory barriers, allowing this requirement to be handled internally by
> +the API.
> +
> +Ensuring Requests Are Seen
> +==========================
> +
> +When making requests to VCPUs, we want to avoid the receiving VCPU
> +executing in guest mode for an arbitrary long time without handling the
> +request.  We can be sure this won't happen as long as we ensure the VCPU
> +thread checks kvm_request_pending() before entering guest mode and that a
> +kick will send an IPI when necessary.  Extra care must be taken to cover

                        ^ to force an exit from the guest

> +the period after the VCPU thread's last kvm_request_pending() check and
> +before it has entered guest mode, as kick IPIs will only trigger VCPU run
> +loops for VCPU threads that are in guest mode or at least have already

IPIs trigger VCPU run loops?  I think you mean that IPIs triggers a
return from guest mode which eventually results in running another
iteration of the run loop?

> +disabled interrupts in order to prepare to enter guest mode.  This means
> +that an optimized implementation (see "IPI Reduction") must be certain
> +when it's safe to not send the IPI.  One solution, which all architectures
> +except s390 apply, is to:
> +
> +- set ``vcpu->mode`` to IN_GUEST_MODE between disabling the interrupts and
> +  the last kvm_request_pending() check;
> +- enable interrupts atomically when entering the guest.
> +
> +This solution also requires memory barriers to be placed carefully in both
> +the requesting thread and the receiving VCPU.  With the memory barriers we
> +can exclude the possibility of a VCPU thread observing
> +!kvm_request_pending() on its last check and then not receiving an IPI for
> +the next request made of it, even if the request is made immediately after
> +the check.  This is done by way of the Dekker memory barrier pattern
> +(scenario 10 of [lwn-mb]_).  As the Dekker pattern requires two variables,
> +this solution pairs ``vcpu->mode`` with ``vcpu->requests``.  Substituting
> +them into the pattern gives::
> +
> +  CPU1                                    CPU2
> +  =================                       =================
> +  local_irq_disable();
> +  WRITE_ONCE(vcpu->mode, IN_GUEST_MODE);  kvm_make_request(REQ, vcpu);
> +  smp_mb();                               smp_mb();
> +  if (kvm_request_pending(vcpu)) {        if (READ_ONCE(vcpu->mode) ==
> +                                              IN_GUEST_MODE) {
> +      ...abort guest entry...                 ...send IPI...
> +  }                                       }
> +
> +As stated above, the IPI is only useful for VCPU threads in guest mode or
> +that have already disabled interrupts.  This is why this specific case of
> +the Dekker pattern has been extended to disable interrupts before setting
> +``vcpu->mode`` to IN_GUEST_MODE.  WRITE_ONCE() and READ_ONCE() are used to
> +pedantically implement the memory barrier pattern, guaranteeing the
> +compiler doesn't interfere with ``vcpu->mode``'s carefully planned
> +accesses.
> +
> +IPI Reduction
> +-------------
> +
> +As only one IPI is needed to get a VCPU to check for any/all requests,
> +then they may be coalesced.  This is easily done by having the first IPI
> +sending kick also change the VCPU mode to something !IN_GUEST_MODE.  The
> +transitional state, EXITING_GUEST_MODE, is used for this purpose.
> +
> +Waiting for Acknowledgements
> +----------------------------
> +
> +Some requests, those with the KVM_REQUEST_WAIT flag set, require IPIs to
> +be sent, and the acknowledgements to be waited upon, even when the target
> +VCPU threads are in modes other than IN_GUEST_MODE.  For example, one case
> +is when a target VCPU thread is in READING_SHADOW_PAGE_TABLES mode, which
> +is set after disabling interrupts.  For these cases, the "should send an
> +IPI" condition becomes READ_ONCE(``vcpu->mode``) != OUTSIDE_GUEST_MODE.

Hmm, did you mean, "To support these cases, the condition for sending an
IPI checks not to be equal to IN_GUEST_MODE, but different from
OUTSIDE_GUEST_MODE.".

(The confusion is whether we check different things depending on which
request we're dealing with, or just explaining why the single
implementation is done the way it is.)

> +
> +Request-less VCPU Kicks
> +-----------------------
> +
> +As the determination of whether or not to send an IPI depends on the
> +two-variable Dekker memory barrier pattern, then it's clear that
> +request-less VCPU kicks are almost never correct.  Without the assurance
> +that a non-IPI generating kick will still result in an action by the
> +receiving VCPU, as the final kvm_request_pending() check does for
> +request-accompanying kicks, then the kick may not do anything useful at
> +all.  If, for instance, a request-less kick was made to a VCPU that was
> +just about to set its mode to IN_GUEST_MODE, meaning no IPI is sent, then
> +the VCPU thread may continue its entry without actually having done
> +whatever it was the kick was meant to initiate.
> +
> +One exception is x86's posted interrupt mechanism.  In this case, however,
> +even the request-less VCPU kick is coupled with the same
> +local_irq_disable() + smp_mb() pattern described above; the ON bit
> +(Outstanding Notification) in the posted interrupt descriptor takes the
> +role of ``vcpu->requests``.  When sending a posted interrupt, PIR.ON is
> +set before reading ``vcpu->mode``; dually, in the VCPU thread,
> +vmx_sync_pir_to_irr() reads PIR after setting ``vcpu->mode`` to
> +IN_GUEST_MODE.
> +
> +Additional Considerations
> +=========================
> +
> +Sleeping VCPUs
> +--------------
> +
> +VCPU threads may need to consider requests before and/or after calling
> +functions that may put them to sleep, e.g. kvm_vcpu_block().  Whether they
> +do or not, and, if they do, which requests need consideration, is
> +architecture dependent.  kvm_vcpu_block() calls kvm_arch_vcpu_runnable()
> +to check if it should awaken.  One reason to do so is to provide
> +architectures a function where requests may be checked if necessary.
> +
> +Clearing Requests
> +-----------------
> +
> +Generally it only makes sense for the receiving VCPU thread to clear a
> +request.  However, in some circumstances, such as when the requesting
> +thread is executing synchronously with the receiving VCPU thread, it's

what does it mean that the requesting thread is executing synchronously
with the receiving VCPU thread?  How can that ever be enforced on SMP
system, if the two threads are not the same thread?

If we simply mean that some sequence of operations between the two
threads is synchronized (for example using locks), then that's a
different (less general) case from the two thread overall executing
synchronously, I think?

> +possible to know that the request may be cleared immediately, rather than
> +waiting for the receiving VCPU thread to handle the request in VCPU RUN.
> +The only current examples of this are kvm_vcpu_block() calls, where a
> +side-effect of a call may be to set KVM_REQ_UNHALT.  When the requesting
> +thread is itself the receiving VCPU, 

when the requsting thread and the VCPU thread are the same thread ?

> then it's possible to know that the
> +request does not need to be handled in VCPU RUN, and therefore may be
> +cleared immediately.
> +
> +References
> +==========
> +
> +.. [atomic-ops] Documentation/core-api/atomic_ops.rst
> +.. [memory-barriers] Documentation/memory-barriers.txt
> +.. [lwn-mb] https://lwn.net/Articles/573436/
> -- 
> 2.9.3
> 

This write up is excellent.

My comments are mostly for clarification, so:

Acked-by: Christoffer Dall <cdall@linaro.org>


Thanks,
-Christoffer
