Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com [209.85.222.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C928C0F
	for <kvmarm@lists.linux.dev>; Wed, 10 May 2023 16:36:29 +0000 (UTC)
Received: by mail-ua1-f48.google.com with SMTP id a1e0cc1a2514c-77d0322e1c1so4225545241.3
        for <kvmarm@lists.linux.dev>; Wed, 10 May 2023 09:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683736589; x=1686328589;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SAqtE+DcLfG7N8esCSyEjXIIIGiOx/x9AOYXvN/9SlM=;
        b=CpTGshtusnWTXEjPL3xyj6Ink3Lm05+td9PjyNsKg9LIlZWAx44E1f1FUkf8YdrGvC
         ZERhUvH4K+YmMCPyW5fMl4rZB4KNQyQyN+/CVVs4OhffPhIIm5pUHKH0a+5rtfwDyD3A
         ygxITiLw1Q66OfxtYwMGqyRTUOZUdLXZXyui6UWdIw0zmRft5zamXOsjBqehhvEJC3pb
         FZmZBxu1xwW01zKHdNrSrkajFTTjWbjCoUj/idyT6jC5RYpKUsq3qrGItBDe8nMJbY2g
         CG0VxXQEKbO3vmv95e7v5F1zXgN0mKrhpVoONPYGU5mEqURvtCvPTHPr4PSsJjp5LtqS
         QALg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683736589; x=1686328589;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SAqtE+DcLfG7N8esCSyEjXIIIGiOx/x9AOYXvN/9SlM=;
        b=OzbsSvuJ9CahRy58PD52XG5M8LEBWgFdzIvq4/wGo6RszVQxitB0kXe3zgeIrvu4FZ
         iuFrVGNJ1z/2ZLmMY+sAsA2L1OnZ4HNLUgjfptPriB/fXFmwgeHhjGeqPf2SMv0tq524
         4z2bvRf8OT4XErO/KG7as+eRDi0oA5vts1UFm4JWf5r1g3Gp6Sj5MdrVsgweowVEdnat
         qNdjieEnEapVOgWp3KZ3tM+PjQxKmhrS7A3lTG3KJodKJjCaSOmalXLXuz/DKxnLp8mH
         nK4jx1XnCe8vHr9esYHSAtAobCP7OGxsYg+72YbPE5xRHGROXiQoqZmAJsYbJtXTKIws
         Y3Aw==
X-Gm-Message-State: AC+VfDznVmbI0dW1dtXN9qrcBdgM5ioVATz0XUKgzagMyjf31TnKIe9u
	gerT2ZYv7y9iYY8knZfFMxr9R74DDyP56mQ3Wt/5GQ==
X-Google-Smtp-Source: ACHHUZ5EfFMckPFqxx/agmbuMCP8e1njho1N7LESIeDyr7U6kHsdtUo+dh5NoajaLktBL5NsAsPI4ygc/Lcoj4eiKMI=
X-Received: by 2002:a1f:3dc1:0:b0:453:753f:ef2e with SMTP id
 k184-20020a1f3dc1000000b00453753fef2emr111943vka.8.1683736588775; Wed, 10 May
 2023 09:36:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <ZFrG4KSacT/K9+k5@google.com>
In-Reply-To: <ZFrG4KSacT/K9+k5@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Wed, 10 May 2023 09:35:52 -0700
Message-ID: <CAF7b7moan1eWqqwoGw8Qu4T2yFOZKm8PHY56g9rYsAfyPLhuLA@mail.gmail.com>
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
To: David Matlack <dmatlack@google.com>
Cc: pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev, 
	seanjc@google.com, jthoughton@google.com, bgardon@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 9, 2023 at 3:19=E2=80=AFPM David Matlack <dmatlack@google.com> =
wrote:
>
> On Wed, Apr 12, 2023 at 09:34:48PM +0000, Anish Moorthy wrote:
> > Upon receiving an annotated EFAULT, userspace may take appropriate
> > action to resolve the failed access. For instance, this might involve a
> > UFFDIO_CONTINUE or MADV_POPULATE_WRITE in the context of uffd-based liv=
e
> > migration postcopy.
>
> As implemented, I think it will be prohibitively expensive if not
> impossible for userspace to determine why KVM is returning EFAULT when
> KVM_CAP_ABSENT_MAPPING_FAULT is enabled, which means userspace can't
> decide the correct action to take (try to resolve or bail).
>
> Consider the direct_map() case in patch in PATCH 15. The only way to hit
> that condition is a logic bug in KVM or data corruption. There isn't
> really anything userspace can do to handle this situation, and it has no
> way to distinguish that from faults to due absent mappings.
>
> We could end up hitting cases where userspace loops forever doing
> KVM_RUN, EFAULT, UFFDIO_CONTINUE/MADV_POPULATE_WRITE, KVM_RUN, EFAULT...
>
> Maybe we should just change direct_map() to use KVM_BUG() and return
> something other than EFAULT. But the general problem still exists and
> even if we have confidence in all the current EFAULT sites, we don't have
> much protection against someone adding an EFAULT in the future that
> userspace can't handle.

Hmm, I had been operating under the assumption that userspace would
always have been able to make the memory access succeed somehow- I
(naively) didn't count on some guest memory access errors being
unrecoverable.

If that's the case, then we're back to needing some way to distinguish
the new faults/exits emitted by user_mem_abort/kvm_faultin_pfn with
the ABSENT_MAPPING_FAULT cap enabled :/ Let me paste in a bit of what
Sean said to refute the idea of a special page-fault-failure set in
those spots.

(from https://lore.kernel.org/kvm/ZBoIzo8FGxSyUJ2I@google.com/)
On Tue, Mar 21, 2023 at 12:43=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
>
> Setting a flag that essentially says "failure when handling a guest page =
fault"
> is problematic on multiple fronts.  Tying the ABI to KVM's internal imple=
mentation
> is not an option, i.e. the ABI would need to be defined as "on page fault=
s from
> the guest".  And then the resulting behavior would be non-deterministic, =
e.g.
> userspace would see different behavior if KVM accessed a "bad" gfn via em=
ulation
> instead of in response to a guest page fault.  And because of hardware TL=
Bs, it
> would even be possible for the behavior to be non-deterministic on the sa=
me
> platform running the same guest code (though this would be exteremly unli=
klely
> in practice).
>
> And even if userspace is ok with only handling guest page faults_today_, =
I highly
> doubt that will hold forever.  I.e. at some point there will be a use cas=
e that
> wants to react to uaccess failures on fast-only memslots.
>
> Ignoring all of those issues, simplify flagging "this -EFAULT occurred wh=
en
> handling a guest page fault" isn't precise enough for userspace to blindl=
y resolve
> the failure.  Even if KVM went through the trouble of setting information=
 if and
> only if get_user_page_fast_only() failed while handling a guest page faul=
t,
> userspace would still need/want a way to verify that the failure was expe=
cted and
> can be resolved, e.g. to guard against userspace bugs due to wrongly unma=
pping
> or mprotecting a page.

I wonder, how much of this problem comes down to my description/name
(I suggested MEMFAULT_REASON_PAGE_FAULT_FAILURE) for the flag? I see
Sean's concerns of the behavior issues when fast-only pages are
accessed via guest mode or via emulation/uaccess. What if the
description of the fast-only fault cap was tightened to something like
"generates vcpu faults/exits in response to *EPT/SLAT violations*
which cannot be mapped by present userspace page table entries?" I
think that would eliminate the emulation/uaccess issues (though I may
be wrong, so please let me know).

Of course, by the time we get to kvm_faultin_pfn we don't know that
we're faulting pages in response to an EPT violation... but if the
idea makes sense then that might justify some plumbing code.
