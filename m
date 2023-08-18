Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1A762B
	for <kvmarm@lists.linux.dev>; Fri, 18 Aug 2023 17:33:26 +0000 (UTC)
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-4890b09484dso725343e0c.0
        for <kvmarm@lists.linux.dev>; Fri, 18 Aug 2023 10:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692380006; x=1692984806;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FZUmh4L0ZNJmEKTe+uz+m/IIiqHPcVQlWlryrahPPys=;
        b=C219ZDzT3afCIRDJdBSnsWGsBH8Z7buvN1O9XuxSK6vXjeySTirnzXGut4S3Sr+fiO
         Gua7Fo3Q+N/w1lVsrRVEtMn9b5MuqxqeoOMTKeqcAy+mUWeH4eVyK3G2FZsQNL5SSMAl
         iXQUDN3Yy1DgAIOTb4qLf6kiF53TOOgMSKNUbMhwSKLLcEdukXbRCR+Dx0o7BPOml79M
         gMpBMxFCb0+lnL1N0sQr7o6pY8VmxDJbQd4CvgHf3eFvphPgpE94H6pHcaV6ljscGYH2
         v1+0LI5oBdmLHDhUKiVQwVAW5JbMK+bYuRocZPO1s1g2XncUOpEuGFVYRXo2R0AbL83+
         drmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692380006; x=1692984806;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FZUmh4L0ZNJmEKTe+uz+m/IIiqHPcVQlWlryrahPPys=;
        b=O3VyVnwDcsoDSFQFFA6LRbXimDMurS3CQ6jCjQ3QoM/Qyi7oVlJ/bPuugS0XGgTAIP
         /FLjvM+x0j+rY+kVF2kBBqQPML8qEtXut7uh/1H8Sh9F7TYhPxOZnWQbUWkAqcyy8SQ+
         Rmeue1f6yB5SSE/+e29VmmyzKEUkeqhrqdoVO/tC7YVo7XFGqjAceOo9BVGJK+rLUoBA
         AyvkUHwDbSh8VeETiBX2WppbkkuqAq8dwius2q5yplM5D6iMErEePp0Jyq3a3U0oszMc
         tfxJOtKNn/Mte1YhxE6NI2Ux2bAPYUJJTK/WjiJ1VSjhKtBcNZAZPPzNmAx4qVQFO8OZ
         c88A==
X-Gm-Message-State: AOJu0YyC9W9iSsnz9OgaNF/YprZD0vbAZNK271+dWt9C5/le5yubrvXe
	P4Xg1LROjcExwdv7BTp0rz8WXYms2UJO1ruZJIPwYg==
X-Google-Smtp-Source: AGHT+IFrhzfP6ep4E8MKVexYUJZwaKI/q/H1v0I/2EAMruUom4mo3tDqpemJrofHHyjOc8UwPGrCvLTveWHftj/7vYU=
X-Received: by 2002:a1f:bf58:0:b0:486:3edf:5274 with SMTP id
 p85-20020a1fbf58000000b004863edf5274mr3486429vkf.8.1692380005680; Fri, 18 Aug
 2023 10:33:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-4-amoorthy@google.com>
 <ZIn6VQSebTRN1jtX@google.com> <CAF7b7mqfkLYtWBJ=u0MK7hhARHrahQXHza9VnaughyNz5_tNug@mail.gmail.com>
 <ZNpsCngiSjISMG5j@google.com> <CAF7b7mo0gGGhv9dSFV70md1fNqMvPCfZ05VawPOB=xFkaax8AA@mail.gmail.com>
 <ZNrKNs8IjkUWOatn@google.com> <CAF7b7mp=bDBpaN+NHoSmL-+JUdShGfippRKdxr9LW0nNUhtpWA@mail.gmail.com>
 <ZNzyHqLKQu9bMT8M@google.com> <CAF7b7mpOAJ5MO0F4EPMvb9nsgmjBCASo-6=rMC3kUbFPAh4Vfg@mail.gmail.com>
 <ZN60KPh2uzSo8W4I@google.com>
In-Reply-To: <ZN60KPh2uzSo8W4I@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Fri, 18 Aug 2023 10:32:49 -0700
Message-ID: <CAF7b7mo3WDWQDoRX=bQUy-bnm7_3+UMaQX9DKeRxAZ+opQCZiw@mail.gmail.com>
Subject: Re: [PATCH v4 03/16] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
To: Sean Christopherson <seanjc@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 17, 2023 at 4:58=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Wed, Aug 16, 2023, Anish Moorthy wrote:
> > > but the names just need to be unique, e.g. the below compiles just fi=
ne.  So unless
> > > someone has a better idea, using a separate union for exits that migh=
t be clobbered
> > > seems like the way to go.
> >
> > Agreed. By the way, what was the reason why you wanted to avoid the
> > exit reason canary being ABI?
>
> Because it doesn't need to be exposed to usersepace, and it would be quit=
e
> unfortunate if we ever need/want to drop the canary, but can't because it=
's exposed
> to userspace.

> No need for a full 32-bit value, or even a separate field, we can use kvm=
_run.flags.
> Ugh, but of course flags' usage is arch specific.  *sigh*

Ah, I realise now you're thinking of separating the canary and
whatever userspace reads to check for an annotated memory fault. I
think that even if one variable in kvm_run did double-duty for now,
we'd always be able to switch to using another as the canary without
changing the ABI. But I'm on board with separating them anyways.

> Regarding the canary, if we want to use it for WARN_ON_ONCE(), it can't b=
e
> exposed to userspace.  Either that or we need to guard the WARN in some w=
ay.

It's guarded behind a kconfig atm, although if we decide to drop the
userspace-visible canary then I'll drop that bit.

> > On Wed, Jun 14, 2023 at 10:35=E2=80=AFAM Sean Christopherson <seanjc@go=
ogle.com> wrote:
> > > +       __u32 speculative_exit_reason;
> ...
> We can either defines a flags2 (blech), or grab the upper byte of flags f=
or
> arch agnostic flags (slightly less blech).

Grabbing the upper byte seems reasonable: but do you anticipate KVM
ever supporting more than eight of these speculative exits? Because if
so then it seems like it'd be less trouble to use a separate u32 or
u16 (or even u8, judging by the number of KVM exits). Not sure how
much future-proofing is appropriate here :)

>
> > > +       union {
> > > +               /* KVM_SPEC_EXIT_MEMORY_FAULT */
>
> Definitely just KVM_EXIT_MEMORY_FAULT, the vast, vast majority of exits t=
o
> userspace will not be speculative in any way.

Speaking of future-proofing, this was me trying to anticipate future
uses of the speculative exit struct: I figured that some case might
come along where KVM_RUN returns 0 *and* the contents of the speculative
exit struct might be useful- it'd be weird to look for KVM_EXIT_*s in
two different fields.
