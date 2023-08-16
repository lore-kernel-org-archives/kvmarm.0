Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A39ADDD0
	for <kvmarm@lists.linux.dev>; Wed, 16 Aug 2023 15:58:25 +0000 (UTC)
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-564fa3b49e1so6742106a12.0
        for <kvmarm@lists.linux.dev>; Wed, 16 Aug 2023 08:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692201505; x=1692806305;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AlEksp+W5th3R7gYgc5KdY3FwbFOqSJHU/Pdtj/sHPc=;
        b=4hPZ8aoiSwbbtgY4JhNFTWP0UBRBiaFDJbv7pO8IcssYnGSuONuQsxAw53w9VFfPOZ
         AiWXfzGj0Kq7/DJvBnZupEUTquIjhv5J04a4lA91+5T+LYTAqJJztJNj4WSezGAfLNm1
         vULYIFgU5lsz6yHbmk2J91bTp2B7pQoW10wFMEwuoEEG4rinPvPlhWmx5zfVx1F7UIFj
         5KRgtaji6QH3vOqsxtc8RcaUbBzWRXjc6KQL2GTqCD9Ize3wpAVZnDEW1s6BQFLiCuY9
         eCibI7l8DzT1uqyJJUJf7yYXZW208t+EI2gWyYlXAljslkiaF0Jq3CqY/BdH2pMpfbHZ
         Udug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692201505; x=1692806305;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=AlEksp+W5th3R7gYgc5KdY3FwbFOqSJHU/Pdtj/sHPc=;
        b=VXux+U9LfeAuvF+oWUzhuwFgFd5BX2LdmVFvW0c0qp8nz6kxzsqYhxNHhXiVVrdglU
         nCafR6tb2ssjKBOL+kWcgFovppr8rl8YmyNhJdyb2CJJT7LMSJUBGs/g3YWfcXdVO8Cc
         En8TRULwLfjHQuTMGpI0Vit/A2S2sm4fs4t9V8sBIPRrEeaVDaUyD5GhZdmzpZipZWlc
         p3r3qj6Uc/FghheOhn8eFChr8QuEHghQbyQBQ4zU9A2NY/yfNF8928ky5SbJU1qNrXJa
         wq0oNWgdrHyHZM08FgagUWHHXh5qh1zqMAUNHSly9YYgxP8daULmvJ75v2xUN4/snFjE
         ZqSQ==
X-Gm-Message-State: AOJu0YxA9oD3ynfXzv0UTiPShSUpeh8O70xwjsuKRhXlfTDYaHEtHK9V
	bLhHv6s0Dzs1jKlgFVpflwSzPk2A2Ek=
X-Google-Smtp-Source: AGHT+IGlGdObb9caIKpCe8nB40C28gIA4Ew3eOVEJAfRr38vtvMUP4muRVHv1URBKhcF+eOgbMGV1o60i88=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:5a0:b0:55b:ddd5:9b57 with SMTP id
 by32-20020a056a0205a000b0055bddd59b57mr4214pgb.1.1692201504714; Wed, 16 Aug
 2023 08:58:24 -0700 (PDT)
Date: Wed, 16 Aug 2023 08:58:22 -0700
In-Reply-To: <CAF7b7mp=bDBpaN+NHoSmL-+JUdShGfippRKdxr9LW0nNUhtpWA@mail.gmail.com>
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
Message-ID: <ZNzyHqLKQu9bMT8M@google.com>
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

On Tue, Aug 15, 2023, Anish Moorthy wrote:
> On Fri, Aug 11, 2023 at 3:12=E2=80=AFPM Anish Moorthy <amoorthy@google.co=
m> wrote:
> >
> > On Wed, Jun 14, 2023 at 10:35=E2=80=AFAM Sean Christopherson <seanjc@go=
ogle.com> wrote:
> > >
> > > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > > +inline void kvm_populate_efault_info(struct kvm_vcpu *vcpu,
> > >
> > > Tagging a globally visible, non-static function as "inline" is odd, t=
o say the
> > > least.
> >
> > I think my eyes glaze over whenever I read the words "translation
> > unit" (my brain certainly does) so I'll have to take your word for it.
> > IIRC last time I tried to mark this function "static" the compiler
> > yelled at me, so removing the "inline" it is.
> >
> >...
> >
> On Mon, Aug 14, 2023 at 5:43=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > Can you point me at your branch?  That should be easy to resolve, but i=
t's all
> > but impossible to figure out what's going wrong without being able to s=
ee the
> > full code.
>=20
> Sure: https://github.com/anlsh/linux/tree/suffd-kvm-staticinline.
> Don't worry about this unless you're bored though: I only called out
> my change because I wanted to make sure the final signature was fine.
> If you say it should be static inline then I can take a more concerted
> stab at learning/figuring out what's going on here.

That branch builds (and looks) just fine on gcc-12 and clang-14.  Maybe you=
 have
stale objects in your build directory?  Or maybe PEBKAC?
=20
> > > Btw, do you actually know the size of the union in the run struct? I
> > > started checking it but stopped when I realized that it includes
> > > arch-dependent structs.
> >
> > 256 bytes, though how much of that is actually free for the "speculativ=
e" idea...
> >
> >                 /* Fix the size of the union. */
> >                 char padding[256];
> >
> > Well fudge.  PPC's KVM_EXIT_OSI actually uses all 256 bytes.  And KVM_E=
XIT_SYSTEM_EVENT
> > is closer to the limit than I'd like
> >
> > On the other hand, despite burning 2048 bytes for kvm_sync_regs, all of=
 kvm_run
> > is only 2352 bytes, i.e. we have plenty of room in the 4KiB page.  So w=
e could
> > throw the "speculative" exits in a completely different union.  But tha=
t would
> > be cumbersome for userspace.
>=20
> Haha, well it's a good thing we checked. What about an extra union
> would be cumbersome for userspace though? From an API perspective it
> doesn't seem like splitting the current struct or adding an extra one
> would be all too different- is it something about needing to recompile
> things due to the struct size change?

I was thinking that we couldn't have two anonymous unions, and so userspace=
 (and
KVM) would need to do something like

	run->exit2.memory_fault.gpa

instead of=20

	run->memory_fault.gpa

but the names just need to be unique, e.g. the below compiles just fine.  S=
o unless
someone has a better idea, using a separate union for exits that might be c=
lobbered
seems like the way to go.

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5bdda75bfd10..fc3701d835d6 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3289,6 +3289,9 @@ static int kvm_handle_error_pfn(struct kvm_vcpu *vcpu=
, struct kvm_page_fault *fa
                return RET_PF_RETRY;
        }
=20
+       vcpu->run->memory_fault.flags =3D 0;
+       vcpu->run->memory_fault.gpa =3D fault->gfn << PAGE_SHIFT;
+       vcpu->run->memory_fault.len =3D PAGE_SIZE;
        return -EFAULT;
 }
=20
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index f089ab290978..1a8ccd5f949a 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -531,6 +531,18 @@ struct kvm_run {
                struct kvm_sync_regs regs;
                char padding[SYNC_REGS_SIZE_BYTES];
        } s;
+
+       /* Anonymous union for exits #2. */
+       union {
+               /* KVM_EXIT_MEMORY_FAULT */
+               struct {
+                       __u64 flags;
+                       __u64 gpa;
+                       __u64 len; /* in bytes */
+               } memory_fault;
+
+               char padding2[256];
+       };
 };
=20
 /* for KVM_REGISTER_COALESCED_MMIO / KVM_UNREGISTER_COALESCED_MMIO */
