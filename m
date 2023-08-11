Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com [209.85.221.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B718833
	for <kvmarm@lists.linux.dev>; Fri, 11 Aug 2023 22:12:55 +0000 (UTC)
Received: by mail-vk1-f178.google.com with SMTP id 71dfb90a1353d-487179c285fso1054705e0c.1
        for <kvmarm@lists.linux.dev>; Fri, 11 Aug 2023 15:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691791974; x=1692396774;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vigJk82Zh6GsRf5kWYFgddWtXweIAQC4nmeTmMM7WNo=;
        b=NL8i2jEn0W5vNnFvcihnMH8sfPD76b+qktaL9W9IZ7bQmqJwGhitLr1AZ9j3ZV2cOe
         T1gbQvpeDMfMkRSdmw7eMLU4+DM93u+Gs7iYJtPnLFiy7WLLc+CekbXw4ssmblGy5Rki
         024s/tcEIpIxOtFb7Vy2S0OwwYCZmHXsE2exl2h762d8E4dipwJyL1m/PACpy6IJlBf4
         DmDaPxpbcLdz/ZlYD97IonmueXCd/Qr7h7CflECG6w57u3wtiiSdciBnJcWKoGYHmTdJ
         H+K7+z+E6YByb5/QKGjepYO+XJNBM/98XppyPB28/r5UEL2jLmrCnnLLAjU5qabcs04P
         4pQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691791974; x=1692396774;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vigJk82Zh6GsRf5kWYFgddWtXweIAQC4nmeTmMM7WNo=;
        b=NJa0fWZRWWry84wnEZC579XisdFI037+lqfGWJDL/4UzHUxUYjats8ZjdTJMe8suHA
         dtUMk2Pf3/y4l7bOAjURPZ00UMhJJ4Vqyl7En0doXfllVzpcGrHm+CiT+6AeI5Qx3TaI
         ExBONSsIg1X7CaihUBRfDZ1MTOS2DI/G1VHOvFuVTo2S8TStyay/zIVqwBVbytI6xUYL
         cIZxDaIMax5azhNjfKNxoZHPiNJsRuyco5x7ty9//I0h8pGa8UYJzy6wKCEFrVYhmoWg
         Z67eDGchFJdfAelj8wsUdilvZFF+naTsBbXJ9NI+LGg13Ok/lHSpFhvOiVsdNaqubfkk
         wXTQ==
X-Gm-Message-State: AOJu0YzN0ozqKiiImXCi895ZVN1aSnJSJdBmj8i3kO5Os1Hbft1T40hC
	oE6QU0BgrJZ3yT+UlFh/6RDvxh4gHamaOVbpwWEA7A==
X-Google-Smtp-Source: AGHT+IGlFrD9Z7jWt4ieXUdba29WvQzn/9yRdy/vz6Ki+kJUPHVu0TG6Qum4Ns+ITZ7Hw7Y7KanmSzVe9ouk8yVwVRk=
X-Received: by 2002:a1f:60c8:0:b0:486:f6cd:b8f2 with SMTP id
 u191-20020a1f60c8000000b00486f6cdb8f2mr3702692vkb.0.1691791974231; Fri, 11
 Aug 2023 15:12:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-4-amoorthy@google.com>
 <ZIn6VQSebTRN1jtX@google.com>
In-Reply-To: <ZIn6VQSebTRN1jtX@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Fri, 11 Aug 2023 15:12:18 -0700
Message-ID: <CAF7b7mqfkLYtWBJ=u0MK7hhARHrahQXHza9VnaughyNz5_tNug@mail.gmail.com>
Subject: Re: [PATCH v4 03/16] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
To: Sean Christopherson <seanjc@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 14, 2023 at 10:35=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > +inline void kvm_populate_efault_info(struct kvm_vcpu *vcpu,
>
> Tagging a globally visible, non-static function as "inline" is odd, to sa=
y the
> least.

I think my eyes glaze over whenever I read the words "translation
unit" (my brain certainly does) so I'll have to take your word for it.
IIRC last time I tried to mark this function "static" the compiler
yelled at me, so removing the "inline" it is.

> > +inline void kvm_populate_efault_info(struct kvm_vcpu *vcpu,
>
> I strongly prefer to avoid "populate" and "efault".  Avoid "populate" bec=
ause
> that verb will become stale the instance we do anything else in the helpe=
r.
> Avoid "efault" because it's imprecise, i.e. this isn't to be used for jus=
t any
> old -EFAULT scenario.  Something like kvm_handle_guest_uaccess_fault()? D=
efinitely
> open to other names (especially less verbose names).

I've taken the kvm_handle_guest_uaccess_fault() name for now, though I
remember you saying something about "uaccess" names being bad because
they'll become inaccurate once GPM rolls around? I'll circle back on
the names before sending v5 out.

> > (WARN_ON_ONCE(vcpu->run->exit_reason !=3D KVM_EXIT_UNKNOWN))
>
> As I've stated multiple times, this can't WARN in "normal" builds because=
 userspace
> can modify kvm_run fields at will.  I do want a WARN as it will allow fuz=
zers to
> find bugs for us, but it needs to be guarded with a Kconfig (or maybe a m=
odule
> param).  One idea would be to make the proposed CONFIG_KVM_PROVE_MMU[*] a=
 generic
> Kconfig and use that.

For now I've added a KVM_WARN_MEMORY_FAULT_ANNOTATE_ALREADY_POPULATED
kconfig: open to suggestions on the name.

> I got a bit (ok, way more than a bit) lost in all of the (A) (B) (C) madn=
ess.  I
> think this what you intended for each case?
>
>   (A) if there are any existing paths in KVM_RUN which cause a vCPU
>       to (1) populate the kvm_run struct then (2) fail a vCPU guest memor=
y
>       access but ignore the failure and then (3) complete the exit to
>       userspace set up in (1), then the contents of the kvm_run struct wr=
itten
>       in (1) will be corrupted.
>
>   (B) if KVM_RUN fails a guest memory access for which the EFAULT is anno=
tated
>       but does not return the EFAULT to userspace, then later returns an =
*un*annotated
>       EFAULT to userspace, then userspace will receive incorrect informat=
ion.
>
>   (C) an annotated EFAULT which is ignored/suppressed followed by one whi=
ch is
>       propagated to userspace. Here the exit-reason-unset check will prev=
ent the
>       second annotation from being written, so userspace sees an annotati=
on with
>       bad contents, If we believe that case (A) is a weird sequence of ev=
ents
>       that shouldn't be happening in the first place, then case (C) seems=
 more
>       important to ensure correctness in. But I don't know anything about=
 how often
>       (A) happens in KVM, which is why I want others' opinions.

Yeah, I got lost in the weeds: you've gotten the important points though

> (A) does sadly happen.  I wouldn't call it a "pattern" though, it's an un=
fortunate
> side effect of deficiencies in KVM's uAPI.
>
> (B) is the trickiest to defend against in the kernel, but as I mentioned =
in earlier
> versions of this series, userspace needs to guard against a vCPU getting =
stuck in
> an infinite fault anyways, so I'm not _that_ concerned with figuring out =
a way to
> address this in the kernel.  KVM's documentation should strongly encourag=
e userspace
> to take action if KVM repeatedly exits with the same info over and over, =
but beyond
> that I think anything else is nice to have, not mandatory.
>
> (C) should simply not be possible.  (A) is very much a "this shouldn't ha=
ppen,
> but it does" case.  KVM provides no meaningful guarantees if (A) does hap=
pen, so
> yes, prioritizing correctness for (C) is far more important.
>
> That said, prioritizing (C) doesn't mean we can't also do our best to pla=
y nice
> with (A).  None of the existing exits use anywhere near the exit info uni=
on's 256
> bytes, i.e. there is tons of space to play with.  So rather than put memo=
ry_fault
> in with all the others, what if we split the union in two, and place memo=
ry_fault
> in the high half (doesn't have to literally be half, but you get the idea=
).  It'd
> kinda be similar to x86's contributory vs. benign faults; exits that can'=
t be
> "nested" or "speculative" go in the low half, and things like memory_faul=
t go in
> the high half.
>
> That way, if (A) does occur, the original information will be preserved w=
hen KVM
> fills memory_fault.  And my suggestion to WARN-and-continue limits the pr=
oblematic
> scenarios to just fields in the second union, i.e. just memory_fault for =
now.
> At the very least, not clobbering would likely make it easier for us to d=
ebug when
> things go sideways.
>
> And rather than use kvm_run.exit_reason as the canary, we should carve ou=
t a
> kernel-only, i.e. non-ABI, field from the union.  That would allow settin=
g the
> canary in common KVM code, which can't be done for kvm_run.exit_reason be=
cause
> some architectures, e.g. s390 (and x86 IIRC), consume the exit_reason ear=
ly on
> in KVM_RUN.

I think this is a good idea :D I was going to suggest something
similar a while back, but I thought it would be off the table- whoops.

My one concern is that if/when other features eventually also use the
"speculative" portion, then they're going to run into the same issues
as we're trying to avoid here. But fixing *that* (probably by
propagating these exits through return values/the call stack) would be
a really big refactor, and C doesn't really have the type system for
it in the first place :(
