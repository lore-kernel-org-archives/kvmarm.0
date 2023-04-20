Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7469C8F44
	for <kvmarm@lists.linux.dev>; Thu, 20 Apr 2023 17:56:23 +0000 (UTC)
Received: by mail-wm1-f54.google.com with SMTP id iw7-20020a05600c54c700b003f16fce55b5so1552076wmb.0
        for <kvmarm@lists.linux.dev>; Thu, 20 Apr 2023 10:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682013381; x=1684605381;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8BaEiCrvc7KHwNEBjlvfuESnMRe56w2uz4DYBpQhgGA=;
        b=LFrilngd0JDFJ4I4Fn9xBdLU91w/njcH+2iySGD3GKESYjXD6I2V8yqSkeVttOZwDr
         BZza3/5VaBJQiN4R6ozXX1IazA+wrRpwESzz3OECYvIvkRQfBOAxPajrRKOfPuTHV5rv
         2mRb+RjZKManQR9wXK1PxeGoz7NU+VtD6asMprmQPqhYBMAHGTkKMiEQl9qrwZs35Xmv
         s6EC1p3rHr6LzYc97XAeGOGO1mJVAk41IDMDKa1Fcp/s6zdU+jtGAgaclqR6r8WsA1wg
         0RSQs5SWpeZJj3nZ61ndHH0OottFBeXt4XCZGAA6XtyHS5LlJlTHhgGiIMj76Z8tTV22
         DhMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682013381; x=1684605381;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8BaEiCrvc7KHwNEBjlvfuESnMRe56w2uz4DYBpQhgGA=;
        b=UKQRGVV8fBh7w+RdtM+3HUtWrgEGe6L5+pfQuVAlMCz9ACmDIrdyRjhy/XWJqU/uMP
         V7UroSBNi9SKbvpueRDMMIrY1TGbD0OPuiW1bhjxKG3V0FAKHDG6JEwVH4EPxjJClk7s
         a06ozbqDL90NowWEIhcKJKz6+Ltkdcz8muLR+Pnw2TcTsDKzwpGwzVIoy5Ss/ZEMFxX9
         jR0ybbWTDci6Kq6eRHWPZ/5vSQ59HEd++k3EBsG4w/Zmv1Ji/VFQ9MPctKxWrNfgjAcD
         bYjEjYHVG+hvQBwSP4ub3PqD9HZqyCt+oZSdgvyazgrfl2vlFitbiiPRtQzVffhmSONs
         A8vw==
X-Gm-Message-State: AAQBX9e1HQQ6uerMKqStySG+HfWBNFMlJTv7P8Gf5phJBn6IGW2oWCJq
	2KiU5/NQzQbVre1bGnU1EjHLNg7zl/kQLZh5GKcM/w==
X-Google-Smtp-Source: AKy350YwV+jvclmodNud5gT0zhJyILcSdQUr6vuo6/97MQp31mny4Bs372lriE7b/+mPQPLW0sFtt6u788yfyNof3uA=
X-Received: by 2002:a7b:cd11:0:b0:3f0:310c:e3cf with SMTP id
 f17-20020a7bcd11000000b003f0310ce3cfmr2009926wmj.37.1682013381593; Thu, 20
 Apr 2023 10:56:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <20230412213510.1220557-2-amoorthy@google.com>
 <e73e9a97-3c76-fa71-b481-c0673e8562de@gmail.com>
In-Reply-To: <e73e9a97-3c76-fa71-b481-c0673e8562de@gmail.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Thu, 20 Apr 2023 10:55:44 -0700
Message-ID: <CAF7b7mqMhQmQzJEhZJvEXGUzFB=jSXXOQUr22=Ef+oT-EDyEkg@mail.gmail.com>
Subject: Re: [PATCH v3 01/22] KVM: selftests: Allow many vCPUs and reader
 threads per UFFD in demand paging test
To: Hoo Robert <robert.hoo.linux@gmail.com>
Cc: pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev, 
	seanjc@google.com, jthoughton@google.com, bgardon@google.com, 
	dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 19, 2023 at 6:51=E2=80=AFAM Hoo Robert <robert.hoo.linux@gmail.=
com> wrote:
>
> On 4/13/2023 5:34 AM, Anish Moorthy wrote:
> > At the moment, demand_paging_test does not support profiling/testing
> > multiple vCPU threads concurrently faulting on a single uffd because
> >
> >      (a) "-u" (run test in userfaultfd mode) creates a uffd for each vC=
PU's
> >          region, so that each uffd services a single vCPU thread.
> >      (b) "-u -o" (userfaultfd mode + overlapped vCPU memory accesses)
> >          simply doesn't work: the test tries to register the same memor=
y
> >          to multiple uffds, causing an error.
> >
> > Add support for many vcpus per uffd by
> >      (1) Keeping "-u" behavior unchanged.
> >      (2) Making "-u -a" create a single uffd for all of guest memory.
> >      (3) Making "-u -o" implicitly pass "-a", solving the problem in (b=
).
> > In cases (2) and (3) all vCPU threads fault on a single uffd.
> >
> > With multiple potentially multiple vCPU per UFFD, it makes sense to
>         ^^^^^^^^
> redundant "multiple"?

Thanks, fixed

> > --- a/tools/testing/selftests/kvm/demand_paging_test.c
> > +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> > @@ -77,9 +77,15 @@ static int handle_uffd_page_request(int uffd_mode, i=
nt uffd,
> >               copy.mode =3D 0;
> >
> >               r =3D ioctl(uffd, UFFDIO_COPY, &copy);
> > -             if (r =3D=3D -1) {
> > -                     pr_info("Failed UFFDIO_COPY in 0x%lx from thread =
%d with errno: %d\n",
> > -                             addr, tid, errno);
> > +             /*
> > +              * With multiple vCPU threads fault on a single page and =
there are
> > +              * multiple readers for the UFFD, at least one of the UFF=
DIO_COPYs
> > +              * will fail with EEXIST: handle that case without signal=
ing an
> > +              * error.
> > +              */
>
> But this code path is also gone through in other cases, isn't it? In
> those cases, is it still safe to ignore EEXIST?

Good point: the answer is no, it's not always safe to ignore EEXISTs
here. For instance the first UFFDIO_CONTINUE for a page shouldn't be
allowed to EEXIST, and that's swept under the rug here. I've added the
following to the comment

+ * Note that this does sweep under the rug any EEXISTs occurring
+ * from, e.g., the first UFFDIO_COPY/CONTINUEs on a page. A
+ * realistic VMM would maintain some other state to correctly
+ * surface EEXISTs to userspace or prevent duplicate
+ * COPY/CONTINUEs from happening in the first place.

I could add that extra state to the self test (via for instance, an
atomic bitmap that threads "or" into before issuing any
COPY/CONTINUEs) but it's a bit of an extra complication without any
real payoff. Let me know if you think the comment's inadequate though.

> > +             if (r =3D=3D -1 && errno !=3D EEXIST) {
> > +                     pr_info("Failed UFFDIO_COPY in 0x%lx from thread =
%d, errno =3D %d\n",
> > +                                     addr, tid, errno);
>
> unintended indent changes I think.
>
> >                       return r;
> >               }
> >       } else if (uffd_mode =3D=3D UFFDIO_REGISTER_MODE_MINOR) {
> > @@ -89,9 +95,10 @@ static int handle_uffd_page_request(int uffd_mode, i=
nt uffd,
> >               cont.range.len =3D demand_paging_size;
> >
> >               r =3D ioctl(uffd, UFFDIO_CONTINUE, &cont);
> > -             if (r =3D=3D -1) {
> > -                     pr_info("Failed UFFDIO_CONTINUE in 0x%lx from thr=
ead %d with errno: %d\n",
> > -                             addr, tid, errno);
> > +             /* See the note about EEXISTs in the UFFDIO_COPY branch. =
*/
>
> Personally I would suggest copy the comments here. what if some day above
> code/comment was changed/deleted?

You might be right: on the other hand, if the comment ever gets
updated then it would have to be done in two places. Anyone to break
the tie? :)

> > @@ -148,18 +158,32 @@ struct uffd_desc *uffd_setup_demand_paging(int uf=
fd_mode, useconds_t delay,
> >       TEST_ASSERT((uffdio_register.ioctls & expected_ioctls) =3D=3D
> >                   expected_ioctls, "missing userfaultfd ioctls");
> >
> > -     ret =3D pipe2(uffd_desc->pipefds, O_CLOEXEC | O_NONBLOCK);
> > -     TEST_ASSERT(!ret, "Failed to set up pipefd");
> > -
> >       uffd_desc->uffd_mode =3D uffd_mode;
> >       uffd_desc->uffd =3D uffd;
> >       uffd_desc->delay =3D delay;
> >       uffd_desc->handler =3D handler;
>
> Now that these info are encapsulated into reader args below, looks
> unnecessary to have them in uffd_desc here.

Good point. I've removed uffd_mode, delay, and handler from uffd_desc.
I left the "uffd" field in because that's a shared resource, and
close()ing it as "close(desc->uffd)" makes more sense than, say,
"close(desc->reader_args[0].uffd)"
