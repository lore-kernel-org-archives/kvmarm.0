Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CAA32D97B5
	for <kvmarm@lists.linux.dev>; Fri,  8 May 2026 08:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778230525; cv=none; b=UHVU4sujsUDDL2nmm+IGQGIWqJbNJHg+ZyO31tOwYjZJicqtazJndDSAXmmXYb/eOMd5cu1p2DvVjtsdc8nhG4uJRjUgdRJiINuQkiCTk4Rkv1Vy6aB+Ms7HrntmW38HsepjM0lnL6psSzzGpX+4mJwD24I2N7Y1ikygF5dJuWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778230525; c=relaxed/simple;
	bh=b8BIYY7ac8Ae7tR8uNbsryLwF7VRUu7eVOGgpilWx2g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G4zcYyden2sm9xhICh87Oq1tQcZzcmZADbffrqmDhL7H2SySjGz+atRoqtuyvrVlzoYYQir474y1y2zDJyL0txtu2ziI43gVqC5xubrGVylAwYvX3z0dlIFhQkurOsB8738rDWbQOFd3GSsmcpyN6t39brpXs/XSCkpC61JVOqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=j5hwWCv6; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="j5hwWCv6"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4EEB61A25;
	Fri,  8 May 2026 01:55:17 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E44CE3F763;
	Fri,  8 May 2026 01:55:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778230522; bh=b8BIYY7ac8Ae7tR8uNbsryLwF7VRUu7eVOGgpilWx2g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j5hwWCv68XJr5xZgsYeNGpRFPW839kSjXhzDNAoCEmAx+LslHM1TCvxwKR9FgL7HX
	 7qlgpTc9tPnjmsKMWmKu7j6SUl/w53aFlvRf03QVvR1NXbQMD6wVAoJ1vd1k1XvnFi
	 iGWzMOiWvWJwtpmADEPZiCUa60GUMI70WdItKzFU=
Date: Fri, 8 May 2026 09:55:17 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Sean Christopherson <seanjc@google.com>
Cc: maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	tabba@google.com, David.Hildenbrand@arm.com
Subject: Re: [RFC PATCH] KVM: arm64: Align KVM_EXIT_MEMORY_FAULT error codes
 with documentation
Message-ID: <af2k9btE5hS6lWHR@raptor>
References: <20260506105053.107404-1-alexandru.elisei@arm.com>
 <afs3wp7xBUf2jYK4@google.com>
 <afxROjBUVzeQQNfg@raptor>
 <afyUkaQ1wtivyH8W@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afyUkaQ1wtivyH8W@google.com>

Hi Sean,

On Thu, May 07, 2026 at 06:33:05AM -0700, Sean Christopherson wrote:
> On Thu, May 07, 2026, Alexandru Elisei wrote:
> > Hi Sean,
> > 
> > (Resending this because I managed to mess up the headers, sorry for the
> > duplicate).
> > 
> > Thanks for the explanations!
> > 
> > On Wed, May 06, 2026 at 05:44:50AM -0700, Sean Christopherson wrote:
> > > On Wed, May 06, 2026, Alexandru Elisei wrote:
> > > > The documentation for KVM_EXIT_MEMORY_FAULT states:
> > > > 
> > > > 'Note!  KVM_EXIT_MEMORY_FAULT is unique among all KVM exit reasons in that
> > > > it accompanies a return code of '-1', not '0'!  errno will always be set to
> > > > EFAULT or EHWPOISON when KVM exits with KVM_EXIT_MEMORY_FAULT, userspace
> > > > should assume kvm_run.exit_reason is stale/undefined for all other error
> > > > numbers'.
> > > > 
> > > > where a return code of '-1' is special because according to man 2 ioctl:
> > > > 
> > > > 'On error, -1 is returned, and errno is set to indicate the error'.
> > > > 
> > > > Putting the two together means that the ioctl KVM_RUN must 1) complete with
> > > > an error and 2) that error must must be either EFAULT or EHWPOISON for
> > > > userspace to detect a KVM_EXIT_MEMORY_FAULT VCPU exit.
> > > 
> > > Yes and no.  The key escape valve we (very deliberately) gave ourselves is this:
> > > 
> > >   userspace should assume kvm_run.exit_reason is stale/undefined for all other
> > >   error numbers.
> > > 
> > > As arm64 already does, that clause allows KVM to "speculatively" set exit_reason
> > > to KVM_EXIT_MEMORY_FAULT.  Which is by design.  The userspace flow is intended
> > > to be "if KVM_RUN returns EFAULT or EHWPOISON, then check for KVM_EXIT_MEMORY_FAULT
> > > to see if KVM provided more information about why the EFAULT/EHWPOISON error was
> > > returned".
> > 
> > Hm... In general, "speculatively" populating exit_reason with
> > KVM_EXIT_MEMORY_FAULT when userspace is not intended to use that information
> > looks a bit dubious to me.
> 
> Oh, for sure, it's not exactly ideal.
> 
> > Why do the work if userspace is not supposed to use the information?
> 
> Because not filling kvm_run when KVM is supposed to (per KVM's contract with
> userspace) would be a bug, whereas unnecessarily filling kvm_run is "just" wasted
> cycles (and not very many of them).  x86 also has multiple flows where it fills
> kvm_run "speculatively", e.g. in low(ish) level helpers where it's not known if
> KVM will actually exit to userspace.

For arm64, it's not that hard to figure out that 0 from the fault handlers means
a return to guest:

fault handler returns 0 => kvm_handle_guest_abort() massages the 0 into 1 =>
kvm_vcpu_arch_ioctl() resumes loop.

Consequently anything other than 0 from the fault handlers means an exit to
userspace.

Not sure if that proves or disproves my point though :(

> 
> Overall, for code like this, IMO it's also yields less complex KVM code, though
> I suppose it can also end up being more confusing for readers.
> 
> > Regarding gmem_abort(). As I see it, if today someone writes userspace that
> > relies on any of the undocumented error codes propagated from kvm_gmem_get_pfn()
> > to handle KVM_EXIT_MEMORY_FAULT, that means that KVM can never use those error
> > codes for any other exit_reason in the future, because that userspace will
> > break.
> 
> Hmm, if we wanted to defend against that, we could scribble kvm_run.exit_reason
> on the way out of KVM_RUN, e.g.
> 
> diff --git virt/kvm/kvm_main.c virt/kvm/kvm_main.c
> index 89489996fbc1..76801d103dd9 100644
> --- virt/kvm/kvm_main.c
> +++ virt/kvm/kvm_main.c
> @@ -4475,6 +4475,10 @@ static long kvm_vcpu_ioctl(struct file *filp,
>                  */
>                 rseq_virt_userspace_exit();
>  
> +               if (vcpu->run->exit_reason == KVM_EXIT_MEMORY_FAULT &&
> +                   r && r != -EFAULT && r != EHWPOISON)
                                               ^^^^^^^^^^
					       -EHWPOISON

> +                       vcpu->run->exit_reason = KVM_EXIT_UNKNOWN;
> +
>                 trace_kvm_userspace_exit(vcpu->run->exit_reason, r);
>                 break;
>         }

I was thinking something like this, to avoid populating KVM_EXIT_MEMORY_FAULT
information and then overwriting it later (I assume all architectures go
through the helper and don't open code it, haven't checked):

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4c14aee1fb06..6e1eeb511967 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2505,11 +2505,14 @@ static inline void kvm_account_pgtable_pages(void *virt, int nr)
 /* Max number of entries allowed for each kvm dirty ring */
 #define  KVM_DIRTY_RING_MAX_ENTRIES  65536

-static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
+static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu, int error,
                                                 gpa_t gpa, gpa_t size,
                                                 bool is_write, bool is_exec,
                                                 bool is_private)
 {
+       if (error != -EFAULT && error != -EHWPOISON)
+               return;
+
        vcpu->run->exit_reason = KVM_EXIT_MEMORY_FAULT;
        vcpu->run->memory_fault.gpa = gpa;
        vcpu->run->memory_fault.size = size;

arm64 sets exit_reason = KVM_EXIT_UNKNOWN before the run loop. After a
cursory look, I *think* x86 does the same, so the result would be similar
to what you propose, at least for these two architectures. We could also
set exit_reason to unknown if !-EFAULT && !-EHWPOISON to be sure.

Avoids leaking what memory the guest accesses, for the extra, extra
paranoid.

It would also make at least one person (me) less confused about why
KVM_EXIT_MEMORY_FAULT is populated when userspace is not supposed to
consume it :)

On the other hand, all call sites would need to be modified.

> 
> I don't know that I'm convinced that level of paranoia is worth it though.

It's up to you, I don't feel strongly about it. If you do decide to go
ahead with it, whatever approach you choose, I can prepare the patch.

> 
> > I'm sure this was all carefully considered when designing the interface, I was
> > just curious how this particular problem has been solved.
> 
> Heh, I like to think we carefully considered the interface, but thinking of every
> possible way userspace can be silly is hard :-)

Agreed. That's why I think exposing strictly the minimum necessary
information to userspace is a good defence :)

Thanks,
Alex
