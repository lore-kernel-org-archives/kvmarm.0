Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0BE125B2
	for <kvmarm@lists.linux.dev>; Wed, 16 Aug 2023 21:29:31 +0000 (UTC)
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-48be61950aeso1343e0c.1
        for <kvmarm@lists.linux.dev>; Wed, 16 Aug 2023 14:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692221370; x=1692826170;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DlcbRLxSS9LJxSfztLkyLAJRRpXHnMpareK1YLEXhh8=;
        b=LSHhMsW41PTgH3YTb+e8PZKig6HyY6Drph3GPlflLxEgpiZVP4/6mvaBBknLkzx7DY
         qYnOAiEg9BrIRQiL0N/zHwJ2Dy8XXAmFbdNTj0D+kRFVIzeYZU3pcJv8yDCHCg0KXyXQ
         +ghop3iVqkFWQSJZwMbZzBLoV8wrC5MsuBCIEUXp7Yb+kq6tXfv02mdFzCmPS8HvcFzs
         k361vZVKLKD7yaybs+fYvYzV+jExZ+o44J6TmCvCw5oSc/W8L5UOBLRqR5QN4N8EdUIA
         E6kB0/Qu7IEsg972YNeCwjLRY3hwwa8NksShW89ifQWd1ud5pbNKgQhy0n3QKz+TvfAw
         WMVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692221370; x=1692826170;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DlcbRLxSS9LJxSfztLkyLAJRRpXHnMpareK1YLEXhh8=;
        b=ZMLjYBP94qf6hX80NJCYJ/sqjlLRYmDhHcwwwqv2V7p2QIKId8uc0aydQ3z69+4hJG
         3b3GRPVFNuA0QoxMNXRXMfvkC3lE8T4/JonlLaHVYIvcT2pXE09D0+HF/WheaFbxTQy8
         imMxaKJonrmBtuhIZVmf/gsQlXtnx44y4RDcMOOADGHDDvr83LYZkqkZWODWunSk3lyu
         608Ic1eBrPP6A28dNvoI6wS6WB9qbLrIAbg0bXCbWTry4yqYczQTQ5MWrFgXfN995bnV
         6FKvGKoaiyP2+x1nCusV8FTkWf5wu1K2I9odBs1Wj4KpzmToZ7WL6bZ0TVKZ5AqWM/YL
         Q7MA==
X-Gm-Message-State: AOJu0YyXTVIBsI1LVXbjuNjVttEopT5NyI35XR+YNP875qeGcTdc6sda
	Cu4lkdq+rr5EVZux4MoEDGNuar1k56vN0uIzVczadg==
X-Google-Smtp-Source: AGHT+IGPuiV8gPvloD58PgsLpwUsBkS4qGPhk5DeyvH9pk/s9V/9rokUEZVAEoYKMJdthCiTbd5tU7COfpAaEq3lgJ8=
X-Received: by 2002:a1f:ccc6:0:b0:486:3e05:da14 with SMTP id
 c189-20020a1fccc6000000b004863e05da14mr2912659vkg.12.1692221370260; Wed, 16
 Aug 2023 14:29:30 -0700 (PDT)
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
 <ZNzyHqLKQu9bMT8M@google.com>
In-Reply-To: <ZNzyHqLKQu9bMT8M@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Wed, 16 Aug 2023 14:28:54 -0700
Message-ID: <CAF7b7mpOAJ5MO0F4EPMvb9nsgmjBCASo-6=rMC3kUbFPAh4Vfg@mail.gmail.com>
Subject: Re: [PATCH v4 03/16] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
To: Sean Christopherson <seanjc@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 16, 2023 at 8:58=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> That branch builds (and looks) just fine on gcc-12 and clang-14.  Maybe y=
ou have
> stale objects in your build directory?  Or maybe PEBKAC?

Hmm, so it does- PEBKAC indeed...

> I was thinking that we couldn't have two anonymous unions, and so userspa=
ce (and
> KVM) would need to do something like
>
>         run->exit2.memory_fault.gpa
>
> instead of
>
>         run->memory_fault.gpa
>
> but the names just need to be unique, e.g. the below compiles just fine. =
 So unless
> someone has a better idea, using a separate union for exits that might be=
 clobbered
> seems like the way to go.

Agreed. By the way, what was the reason why you wanted to avoid the
exit reason canary being ABI?

On Wed, Jun 14, 2023 at 10:35=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
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
>
> E.g. something like this (the #ifdefs are heinous, it might be better to =
let
> userspace see the exit_canary, but make it abundantly clear that it's not=
 ABI).
>
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 143abb334f56..233702124e0a 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -511,16 +511,43 @@ struct kvm_run {
> +       /*
> +        * This second KVM_EXIT_* union holds structures for exits that m=
ay be
> +        * triggered after KVM has already initiated a different exit, an=
d/or
> +        * may be filled speculatively by KVM.  E.g. because of limitatio=
ns in
> +        * KVM's uAPI, a memory fault can be encountered after an MMIO ex=
it is
> +        * initiated and kvm_run.mmio is filled.  Isolating these structu=
res
> +        * from the primary KVM_EXIT_* union ensures that KVM won't clobb=
er
> +        * information for the original exit.
> +        */
> +       union {
>                 /* KVM_EXIT_MEMORY_FAULT */
>                 blahblahblah
> +#endif
>         };
>
> +#ifdef __KERNEL__
> +       /*
> +        * Non-ABI, kernel-only field that KVM uses to detect bugs relate=
d to
> +        * filling exit_reason and the exit unions, e.g. to guard against
> +        * clobbering a previous exit.
> +        */
> +       __u64 exit_canary;
> +#endif
> +

We can't set exit_reason in the kvm_handle_guest_uaccess_fault()
helper if we're to handle case A (the setup vcpu exit -> fail guest
memory access -> return to userspace) correctly. But then userspace
needs some other way to check whether an efault is annotated, and
might as well check the canary, so something like

> +       __u32 speculative_exit_reason;
> +       union {
> +               /* KVM_SPEC_EXIT_MEMORY_FAULT */
> +               struct {
> +                       __u64 flags;
> +                       __u64 gpa;
> +                       __u64 len;
> +               } memory_fault;
> +               /* Fix the size of the union. */
> +               char speculative_padding[256];
> +       };

With the condition for an annotated efault being "if kvm_run returns
-EFAULT and speculative_exit_reason is..."
