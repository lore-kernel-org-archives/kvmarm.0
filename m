Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E94100CA
	for <kvmarm@lists.linux.dev>; Thu, 17 Aug 2023 23:58:34 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-589f437fef0so4427347b3.3
        for <kvmarm@lists.linux.dev>; Thu, 17 Aug 2023 16:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692316714; x=1692921514;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7+og8CWbFf6Zv1sbRNxLsKMDBiVhC6M6icGTbCuvzek=;
        b=py2N+ypoqoY6C09PsaRnQ5k3iJHVK4XGKfy9nqitR+xQygsYBqpor76d5YFrJxoC35
         3AhofQF4w0eTF1rvJTwq/MWYgmKpL/qxMDxR20u1L2WjcM7U36OIddOzfYZ9K+12YrdE
         LuVVeG8Uy3k9iG0sO/4GaOdTMnzS8dz6/07ROqQcNNAq+NDx7WK6r8XNyAdd/AAG0Lqx
         RIB/ek+u9kmvhCpbuUHKWOwWM/1BWGfw8af382TmJY5FWWlrMF9XjyKkdScCZg02KUv0
         vo+xdVvnNSog8PxjqvUxKNqXeKJ9iRGuYTEUjMI212C+JdicgjSMIjr01BXMvS1k9YK/
         URHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692316714; x=1692921514;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7+og8CWbFf6Zv1sbRNxLsKMDBiVhC6M6icGTbCuvzek=;
        b=OXVEH9jFEZa7ev1izgttF7RtyltXfLUOZKtA0Md4AK/wjBrkymGAemvTb/6K4dF1C1
         3poEuSKDApXNi4bnaZF/YoZC7KpzDKtlso5vamhaTfRBYTYzrFhMXMaQUYAuiYtx7BSG
         eVTaqfBQSyA4wVLwdx2ebYuJsCffp08EEJO6r7UVOFlS+DbxxnAhQQWAJy91El/JkZQE
         m1dlPQEO0fYL68IqmTLSQTbF6QTC5RXgZSF7uACIGWKVHXEZmo5NQ9cJXwOVVoHB2DwB
         Xk2nVyTYD39R3xW8RnzGlad8s90+VUF2RtOuoPjiJeFrFWE68iRcVbmBNjcn9N1NP9XG
         crng==
X-Gm-Message-State: AOJu0Yxy6XTas9ANCb4kmTWK63tYnRYzKCbK1rHaY89DCqgnv6yNCm8j
	+/MDyvuGnY9geCjUutG+EUvfG5PSocc=
X-Google-Smtp-Source: AGHT+IGystukLEOiwSBetOyGkkr2GHPbvN4puEr62BLoTROPFErRtY0J7986gPZTn46Drw1qKOwd2aHh2PM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ce47:0:b0:d44:be8a:ca39 with SMTP id
 x68-20020a25ce47000000b00d44be8aca39mr12651ybe.7.1692316713949; Thu, 17 Aug
 2023 16:58:33 -0700 (PDT)
Date: Thu, 17 Aug 2023 16:58:32 -0700
In-Reply-To: <CAF7b7mpOAJ5MO0F4EPMvb9nsgmjBCASo-6=rMC3kUbFPAh4Vfg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-4-amoorthy@google.com>
 <ZIn6VQSebTRN1jtX@google.com> <CAF7b7mqfkLYtWBJ=u0MK7hhARHrahQXHza9VnaughyNz5_tNug@mail.gmail.com>
 <ZNpsCngiSjISMG5j@google.com> <CAF7b7mo0gGGhv9dSFV70md1fNqMvPCfZ05VawPOB=xFkaax8AA@mail.gmail.com>
 <ZNrKNs8IjkUWOatn@google.com> <CAF7b7mp=bDBpaN+NHoSmL-+JUdShGfippRKdxr9LW0nNUhtpWA@mail.gmail.com>
 <ZNzyHqLKQu9bMT8M@google.com> <CAF7b7mpOAJ5MO0F4EPMvb9nsgmjBCASo-6=rMC3kUbFPAh4Vfg@mail.gmail.com>
Message-ID: <ZN60KPh2uzSo8W4I@google.com>
Subject: Re: [PATCH v4 03/16] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 16, 2023, Anish Moorthy wrote:
> > but the names just need to be unique, e.g. the below compiles just fine=
.  So unless
> > someone has a better idea, using a separate union for exits that might =
be clobbered
> > seems like the way to go.
>=20
> Agreed. By the way, what was the reason why you wanted to avoid the
> exit reason canary being ABI?

Because it doesn't need to be exposed to usersepace, and it would be quite
unfortunate if we ever need/want to drop the canary, but can't because it's=
 exposed
to userspace.

Though I have no idea why I suggested it be placed in kvm_run, the canary c=
an simply
go in kvm_vcpu.  I'm guessing I was going for code locality, but abusing an
#ifdef to achieve that is silly.

> On Wed, Jun 14, 2023 at 10:35=E2=80=AFAM Sean Christopherson <seanjc@goog=
le.com> wrote:
> >
> > And rather than use kvm_run.exit_reason as the canary, we should carve =
out a
> > kernel-only, i.e. non-ABI, field from the union.  That would allow sett=
ing the
> > canary in common KVM code, which can't be done for kvm_run.exit_reason =
because
> > some architectures, e.g. s390 (and x86 IIRC), consume the exit_reason e=
arly on
> > in KVM_RUN.
> >
> > E.g. something like this (the #ifdefs are heinous, it might be better t=
o let
> > userspace see the exit_canary, but make it abundantly clear that it's n=
ot ABI).
> >
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index 143abb334f56..233702124e0a 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -511,16 +511,43 @@ struct kvm_run {
> > +       /*
> > +        * This second KVM_EXIT_* union holds structures for exits that=
 may be
> > +        * triggered after KVM has already initiated a different exit, =
and/or
> > +        * may be filled speculatively by KVM.  E.g. because of limitat=
ions in
> > +        * KVM's uAPI, a memory fault can be encountered after an MMIO =
exit is
> > +        * initiated and kvm_run.mmio is filled.  Isolating these struc=
tures
> > +        * from the primary KVM_EXIT_* union ensures that KVM won't clo=
bber
> > +        * information for the original exit.
> > +        */
> > +       union {
> >                 /* KVM_EXIT_MEMORY_FAULT */
> >                 blahblahblah
> > +#endif
> >         };
> >
> > +#ifdef __KERNEL__
> > +       /*
> > +        * Non-ABI, kernel-only field that KVM uses to detect bugs rela=
ted to
> > +        * filling exit_reason and the exit unions, e.g. to guard again=
st
> > +        * clobbering a previous exit.
> > +        */
> > +       __u64 exit_canary;
> > +#endif
> > +
>=20
> We can't set exit_reason in the kvm_handle_guest_uaccess_fault()
> helper if we're to handle case A (the setup vcpu exit -> fail guest
> memory access -> return to userspace) correctly. But then userspace
> needs some other way to check whether an efault is annotated, and
> might as well check the canary, so something like
>=20
> > +       __u32 speculative_exit_reason;

No need for a full 32-bit value, or even a separate field, we can use kvm_r=
un.flags.
Ugh, but of course flags' usage is arch specific.  *sigh*

We can either defines a flags2 (blech), or grab the upper byte of flags for
arch agnostic flags (slightly less blech).

Regarding the canary, if we want to use it for WARN_ON_ONCE(), it can't be
exposed to userspace.  Either that or we need to guard the WARN in some way=
.

> > +       union {
> > +               /* KVM_SPEC_EXIT_MEMORY_FAULT */

Definitely just KVM_EXIT_MEMORY_FAULT, the vast, vast majority of exits to
userspace will not be speculative in any way.

> > +               struct {
> > +                       __u64 flags;
> > +                       __u64 gpa;
> > +                       __u64 len;
> > +               } memory_fault;
> > +               /* Fix the size of the union. */
> > +               char speculative_padding[256];
> > +       };
>=20
> With the condition for an annotated efault being "if kvm_run returns
> -EFAULT and speculative_exit_reason is..."
