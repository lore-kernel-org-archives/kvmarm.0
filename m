Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB04E209B5
	for <kvmarm@lists.linux.dev>; Tue, 23 May 2023 17:49:41 +0000 (UTC)
Received: by mail-yb1-f172.google.com with SMTP id 3f1490d57ef6-ba81ded8d3eso11286907276.3
        for <kvmarm@lists.linux.dev>; Tue, 23 May 2023 10:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684864180; x=1687456180;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=teADhgUUgRtuhoc0vngcSNYea7469csRr+QcCgP2cV8=;
        b=PP8A0tJVgSsF6+XlAoH0nCl5/spaW3hRTf5xD9MZe10CcC1O2Mel+VxGsUg6HmHjaI
         821d2WRlFIj4PgVaNoeEIJj8LFm1SNeYKNcr+43E/sdOfQQGIyZBQMkI0Uuhl6zHBBU3
         Nm3REHjepznU5+SEe0QOO0Z8kcAuvWQWfBwBV0B6pC9ObiXKoMlNTcYJVsltkedYez0F
         DfW3WFLUFuwTJtf1eICPk+trQ3ReVGRjuc7T7UBZAmMcA3H+AMYo8MyaSWW/cDSCIgwO
         rj3cYM8DlMUZAUFQfA3VPGNZ2ktnnKbhEX6vKqE0snr1VAeJeldPjrYqXioIhChKbBVS
         RS4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684864180; x=1687456180;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=teADhgUUgRtuhoc0vngcSNYea7469csRr+QcCgP2cV8=;
        b=GhZDQkyftkYsWQCjCN75OnRN3+AbmUFXz6x5tlfEmdPkBPe3e22YOXI7n5sOcMallM
         9Oa2A6RTh3784klwwgDV69yIldwZaDpienAxDTBuDuxb/ZD6ltku3Ul2yUDPo6WPBnTv
         8NeTkKOKOzcbpUpr0fNl9jYQsyTc20a+wIhaQ2ZL0e4WvaJxQIz0ixdvB42/NMzrZ8Ic
         IdrA/6O6BOdcnhmUI3cBNeDg0sEcecRCT4wz2LO5QXPQig++XzE98NWumFmgkABFYFZ4
         4qnKZYIw562OLJ13V6g+nskabWbkOeZavKqMeJtDgKlYtRrBdZItcgOepuy0Z8kqBrhT
         39LQ==
X-Gm-Message-State: AC+VfDzwyFAA4olyitzCxEYRkFKvxUR3kMVVcNfqeln5GozurIRiFym7
	xOookAYlAbJa5tI1Gn3l/jdlkkRIo3GM7zo6FdUEVA==
X-Google-Smtp-Source: ACHHUZ64MxzhoeIa9nMm2w4gR6xAh3HRSexsIcbotGwNskFJLyinWGCHMxnIzuYWzIx9WkYz9iElc1sCJBXyzQb1GBc=
X-Received: by 2002:a25:50cf:0:b0:ba8:1578:d12e with SMTP id
 e198-20020a2550cf000000b00ba81578d12emr16012899ybb.54.1684864180551; Tue, 23
 May 2023 10:49:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <ZFrG4KSacT/K9+k5@google.com>
 <ZFwcRCSSlpCBspxy@google.com>
In-Reply-To: <ZFwcRCSSlpCBspxy@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Tue, 23 May 2023 10:49:04 -0700
Message-ID: <CAF7b7moF1URFC2yZXymPCwvDME8oJafCse12DSf0Rwo43JEDVg@mail.gmail.com>
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
To: Sean Christopherson <seanjc@google.com>
Cc: David Matlack <dmatlack@google.com>, pbonzini@redhat.com, maz@kernel.org, 
	oliver.upton@linux.dev, jthoughton@google.com, bgardon@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 10, 2023 at 4:44=E2=80=AFPM Anish Moorthy <amoorthy@google.com>=
 wrote:
>
> On Wed, May 10, 2023 at 3:35=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > Yeah, when I speed read the series, several of the conversions stood ou=
t as being
> > "wrong".  My (potentially unstated) idea was that KVM would only signal
> > KVM_EXIT_MEMORY_FAULT when the -EFAULT could be traced back to a user a=
ccess,
> > i.e. when the fault _might_ be resolvable by userspace.
>
> Sean, besides direct_map which other patches did you notice as needing
> to be dropped/marked as unrecoverable errors?

I tried going through on my own to try and identify the incorrect
annotations: here's my read.

Correct (or can easily be corrected)
-----------------------------------------------
- user_mem_abort
  Incorrect as is: the annotations in patch 19 are incorrect, as they
cover an error-on-no-slot case and one more I don't fully understand:
the one in patch 20 should be good though.

- kvm_vcpu_read/write_guest_page:
  Incorrect as-is, but can fixed: the current annotations cover
gpa_to_hva_memslot(_prot) failures, which can happen when "gpa" is not
converted by a memslot. However we can leave these as bare efaults and
just annotate the copy_to/from_user failures, which userspace should
be able to resolve by checking/changing the slot permissions.

- kvm_handle_error_pfn
  Correct: at the annotation point, the fault must be either a (a)
read/write to a writable memslot or (b) read from a readable one.
hva_to_pfn must have returned KVM_PFN_ERR_FAULT, which userspace can
attempt to resolve using a MADV

Flatly Incorrect (will drop in next version)
-----------------------------------------------
- kvm_handle_page_fault
  efault corresponds to a kernel bug not resolvable by userspace

- direct_map
  Same as above

- kvm_mmu_page_fault
  Not a "leaf" return of efault, Also, the
check-for-efault-and-annotate here catches efaults which userspace can
do nothing about: such as the one from direct_map [1]

Unsure (Switch kvm_read/write_guest to kvm_vcpu_read/write_guest?)
-----------------------------------------------

- setup_vmgexit_scratch and kvm_pv_clock_pairing
  These efault on errors from kvm_read/write_guest, and theoretically
it does seem to make sense to annotate them. However, the annotations
are incorrect as is for the same reason that the
kvm_vcpu_read/write_guest_page need to be corrected.

In fact, the kvm_read/write_guest calls are of the form
"kvm_read_guest(vcpu->kvm, ...)": if we switched these calls to
kvm_vcpu_read/write_guest instead, then it seems like we'd get correct
annotations for free. Would it be correct to make this switch? If not,
then perhaps an optional kvm_vcpu* parameter for the "non-vcpu"
read/write functions strictly for annotation purposes? That seems
rather ugly though...

Unsure (Similar-ish to above)
-----------------------------------------------

- kvm_hv_get_assist_page
  Incorrect as-is. The existing annotation would cover some efaults
which it doesn't seem likely that userspace can resolve [2]. Right
after those though, there's a copy_from_user which it could make sense
to annotate.

The efault here comes from failures of
kvm_read_guest_cached/kvm_read_guest_offset_cached, for which all of
the calls are again of the form "f(vcpu->kvm, ...)". Again, we'll need
either an (optional) vcpu parameter or to refactor these to just take
a "kvm_vcpu" instead if we want to annotate just the failing
uaccesses.

PS: I plan to add a couple of flags to the memory fault exit to
identify whether the failed access was a read/write/exec


[1] https://github.com/torvalds/linux/blob/v6.3/arch/x86/kvm/mmu/mmu.c#L319=
6
[2] https://github.com/torvalds/linux/blob/v6.3/virt/kvm/kvm_main.c#L3261-L=
3270
