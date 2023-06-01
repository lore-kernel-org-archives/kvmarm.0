Received: from out-29.mta0.migadu.com (out-29.mta0.migadu.com [91.218.175.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F629BA2F
	for <kvmarm@lists.linux.dev>; Thu,  1 Jun 2023 16:04:50 +0000 (UTC)
Date: Thu, 1 Jun 2023 16:04:43 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1685635488;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HJ0BnJ5Z1HoNgG6VdWoHZwHdBQsBDD4dVK/Okzl/Wvo=;
	b=uXGisnGfpdnhy6dHM6x0TkBItta0ube4Zqy3ePPn0XioEuOaO7arFQZLCCteh4MkyAJmzr
	dSbGfMGVJBpmSPLO99K7PpGB3CCPE1KAGL+nDG3BvC833kadH/6TCmU+NsriJzY6yiUIVg
	9vAvzQaMzkiEMmmMHbZk1U14DeDabo0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Anish Moorthy <amoorthy@google.com>, pbonzini@redhat.com,
	maz@kernel.org, jthoughton@google.com, bgardon@google.com,
	dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com,
	peterx@redhat.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 17/22] KVM: Introduce KVM_CAP_ABSENT_MAPPING_FAULT
 without implementation
Message-ID: <ZHjBm1DNK28B4Ujq@linux.dev>
References: <20230412213510.1220557-1-amoorthy@google.com>
 <20230412213510.1220557-18-amoorthy@google.com>
 <ZEbueTfeJugSl31X@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEbueTfeJugSl31X@google.com>
X-Migadu-Flow: FLOW_OUT

Better late than never right? :)

On Mon, Apr 24, 2023 at 02:02:49PM -0700, Sean Christopherson wrote:
> On Wed, Apr 12, 2023, Anish Moorthy wrote:
> > Add documentation, memslot flags, useful helper functions, and the
> > actual new capability itself.
> > 
> > Memory fault exits on absent mappings are particularly useful for
> > userfaultfd-based postcopy live migration. When many vCPUs fault on a
> > single userfaultfd the faults can take a while to surface to userspace
> > due to having to contend for uffd wait queue locks. Bypassing the uffd
> > entirely by returning information directly to the vCPU exit avoids this
> > contention and improves the fault rate.
> > 
> > Suggested-by: James Houghton <jthoughton@google.com>
> > Signed-off-by: Anish Moorthy <amoorthy@google.com>
> > ---
> >  Documentation/virt/kvm/api.rst | 31 ++++++++++++++++++++++++++++---
> >  include/linux/kvm_host.h       |  7 +++++++
> >  include/uapi/linux/kvm.h       |  2 ++
> >  tools/include/uapi/linux/kvm.h |  1 +
> >  virt/kvm/kvm_main.c            |  3 +++
> >  5 files changed, 41 insertions(+), 3 deletions(-)
> > 
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index f174f43c38d45..7967b9909e28b 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -1312,6 +1312,7 @@ yet and must be cleared on entry.
> >    /* for kvm_userspace_memory_region::flags */
> >    #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
> >    #define KVM_MEM_READONLY	(1UL << 1)
> > +  #define KVM_MEM_ABSENT_MAPPING_FAULT (1UL << 2)
> 
> This name is both too specific and too vague.  It's too specific because it affects
> more than just "absent" mappings, it will affect any page fault that can't be
> resolved by fast GUP, i.e. I'm objecting for all the same reasons I objected to
> the exit reason being name KVM_MEMFAULT_REASON_ABSENT_MAPPING.  It's too vague
> because it doesn't describe what behavior the flag actually enables in any way.
> 
> I liked the "nowait" verbiage from the RFC.  "fast_only" is an ok alternative,
> but that's much more of a kernel-internal name.
> 
> Oliver, you had concerns with using "fault" in the name, is something like
> KVM_MEM_NOWAIT_ON_PAGE_FAULT or KVM_MEM_NOWAIT_ON_FAULT palatable?  IMO, "fault"
> is perfectly ok, we just need to ensure it's unlikely to be ambiguous for userspace.

Yeah, I can get over it. Slight preference towards KVM_MEM_NOWAIT_ON_FAULT,
fewer characters and still gets the point across.

-- 
Thanks,
Oliver
