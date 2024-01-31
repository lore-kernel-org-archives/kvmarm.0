Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 265613A1DD
	for <kvmarm@lists.linux.dev>; Wed, 31 Jan 2024 22:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706740720; cv=none; b=ZDbq6ffKYyS75iNVCq/RXEgOBu8VEPZ4yonSLOnUrrRmcss2QgrIC5xyK69E3xpZUZNgdKnwq2e+y5sZSB+iUv9xU5WArYX/RLtdximcpthkWFcGlfxeLX3drwM8K68QVr0KhYKjn+VATVxxv+k7suytgG6O8CUiBNiTq9HskQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706740720; c=relaxed/simple;
	bh=yoNh0T6PTwSXjbboNf8HUKKSK9ptTYeZLMonhIMFcjA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KaNYLCGPr44huThhsq0uz/Aen9kwbOyxc3Hqm2osM+3Ft8pT7HO2i1vw1CC0cI6ygkdXjNgo+GmEGHRdn1LzOtV6e/L9t/JJS0N83QEdf4dKCrNRN9c/cXS0Es11sMjOfDrdErA3mNuVBTiK5kitFLtWjC5asRXdTBl5pdvtKiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F/kGBXxM; arc=none smtp.client-ip=209.85.160.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F/kGBXxM"
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-20503dc09adso173111fac.2
        for <kvmarm@lists.linux.dev>; Wed, 31 Jan 2024 14:38:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706740718; x=1707345518; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sihp+DDuzPlSLNRO3613GGhwVYkcOubyS/IEd97PSkE=;
        b=F/kGBXxMw6lOdVaPCbDDRws2TbHpTMXHU2Kis5xDxYuUnvWTz8DwlaDucIj9T1jRX/
         dyKxk0PgqtuumdD8T0sIOY6bRObklp700Fv7x+ygRHCXcZjPnyYPz1ZpenVJQUSvY3h3
         pzrFpBU7VdxrLh2KYgHoOoofT2XA7rhKPJYc//rINb0o/MUN68OKefebwv5pLjtq3hFh
         11I6Bcbzc80VwRSh3AwIm9lOk8hdaLCmWyVkwRRJeKaDI3CbijFrmCSwCEv8C+m7a947
         BUM3yaQQ/oM1s3gOLwIItawwkVcmcprsbfpf8c7kX8eqAyqyn/AkJ2AzsKzLLV2TgG10
         KJxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706740718; x=1707345518;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sihp+DDuzPlSLNRO3613GGhwVYkcOubyS/IEd97PSkE=;
        b=MBdfC0DLg7KRAPXQyK4rXLeOPSmovaq7U89tqEy4zEVcecGZToGr/rGhqzN5Tv9Lko
         tGKLRrUp1gRJe8A36pnuNw/S73mu4fEBtbPhFVFerlbD7e7BUrcJxqnlzdWKSNJkOgL5
         TWMrSP7Yx9yK8lhUGI1075ivYGHaW7Xw5oHgCyrDLj+S5QoAs0WPe6vi6skCg4EQeSOs
         ox/89W52K41DpjENTIdl+GzHmHzAoBgBSlVjIorshWwmYm9l8203n5rNxpdSGvKQluVb
         +vHJDPNMUBACD70Vn2NIGirhsPMKsZehGqLxcfDmPEHDtixyv9VnoMOXjhcvg0ZzHoIL
         anuQ==
X-Gm-Message-State: AOJu0Ywkxf4IPxBJB/h/gJenJ2WFiyS5qDYxAayFPkCYB+g4QXuPEhzt
	3xVyl5LC9GKMjBP4/RjIn4kMHoTlrppJOD2pTDCxwJWedG+WQqO+KAAvMYnj8UNcNjfbE/1iDVe
	U6vA/hvjpy8R6ngUGmHOrdQomUHiEgcXCFZpJ
X-Google-Smtp-Source: AGHT+IG8GrrgZLcy7HqR+2o1QAFDucoWMa3/eNN8i/KauxGYEngI/wPyqxBwo50CC35GztzssCnleBwgGP7jPiLTB3I=
X-Received: by 2002:a05:6870:3a09:b0:218:e36a:bc4f with SMTP id
 du9-20020a0568703a0900b00218e36abc4fmr362783oab.11.1706740718064; Wed, 31 Jan
 2024 14:38:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com> <20231109210325.3806151-10-amoorthy@google.com>
 <CADrL8HXLF+EQZt+oXJAiatoJNzz2E-fiwUSJj=YpHzGQxL00mQ@mail.gmail.com>
In-Reply-To: <CADrL8HXLF+EQZt+oXJAiatoJNzz2E-fiwUSJj=YpHzGQxL00mQ@mail.gmail.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Wed, 31 Jan 2024 14:38:01 -0800
Message-ID: <CAF7b7mrALBBWCg+ctU867BjQhtLQNuX=Yo8u9TZEuDTEtCV6qw@mail.gmail.com>
Subject: Re: [PATCH v6 09/14] KVM: arm64: Enable KVM_CAP_EXIT_ON_MISSING and
 annotate an EFAULT from stage-2 fault-handler
To: James Houghton <jthoughton@google.com>
Cc: seanjc@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	oliver.upton@linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, dmatlack@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 30, 2024 at 3:58=E2=80=AFPM James Houghton <jthoughton@google.c=
om> wrote:
>
> Hi Anish,
>
> Sorry to get back to you so late. :) I was hoping others would provide
> more feedback, but I have a little bit to give anyway. Overall the
> series looks good to me.

Thanks James. I'm just happy to have some review :D

> On Thu, Nov 9, 2023 at 1:03=E2=80=AFPM Anish Moorthy <amoorthy@google.com=
> wrote:
> >
> > Prevent the stage-2 fault handler from faulting in pages when
> > KVM_MEM_EXIT_ON_MISSING is set by allowing its  __gfn_to_pfn_memslot()
> > calls to check the memslot flag.
> >
> > To actually make that behavior useful, prepare a KVM_EXIT_MEMORY_FAULT
> > when the stage-2 handler cannot resolve the pfn for a fault. With
> > KVM_MEM_EXIT_ON_MISSING enabled this effects the delivery of stage-2
> > faults as vCPU exits, which userspace can attempt to resolve without
> > terminating the guest.
> >
> > Delivering stage-2 faults to userspace in this way sidesteps the
> > significant scalabiliy issues associated with using userfaultfd for the
> > same purpose.
> >
> > Signed-off-by: Anish Moorthy <amoorthy@google.com>
> > ---
> >  Documentation/virt/kvm/api.rst | 2 +-
> >  arch/arm64/kvm/Kconfig         | 1 +
> >  arch/arm64/kvm/mmu.c           | 7 +++++--
> >  3 files changed, 7 insertions(+), 3 deletions(-)
> >
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/ap=
i.rst
> > index fd87bbfbfdf2..67fcb9dbe855 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -8068,7 +8068,7 @@ See KVM_EXIT_MEMORY_FAULT for more information.
> >  7.35 KVM_CAP_EXIT_ON_MISSING
> >  ----------------------------
> >
> > -:Architectures: x86
> > +:Architectures: x86, arm64
> >  :Returns: Informational only, -EINVAL on direct KVM_ENABLE_CAP.
> >
> >  The presence of this capability indicates that userspace may set the
> > diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> > index 1a777715199f..d6fae31f7e1a 100644
> > --- a/arch/arm64/kvm/Kconfig
> > +++ b/arch/arm64/kvm/Kconfig
> > @@ -43,6 +43,7 @@ menuconfig KVM
> >         select GUEST_PERF_EVENTS if PERF_EVENTS
> >         select INTERVAL_TREE
> >         select XARRAY_MULTI
> > +        select HAVE_KVM_EXIT_ON_MISSING
> >         help
> >           Support hosting virtualized guest machines.
> >
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 13066a6fdfff..3b9fb80672ac 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1486,13 +1486,16 @@ static int user_mem_abort(struct kvm_vcpu *vcpu=
, phys_addr_t fault_ipa,
> >         mmap_read_unlock(current->mm);
> >
> >         pfn =3D __gfn_to_pfn_memslot(memslot, gfn, false, false, NULL,
> > -                                  write_fault, &writable, false, NULL)=
;
> > +                                  write_fault, &writable, true, NULL);
> >         if (pfn =3D=3D KVM_PFN_ERR_HWPOISON) {
> >                 kvm_send_hwpoison_signal(hva, vma_shift);
> >                 return 0;
> >         }
> > -       if (is_error_noslot_pfn(pfn))
> > +       if (is_error_noslot_pfn(pfn)) {
> > +               kvm_prepare_memory_fault_exit(vcpu, gfn * PAGE_SIZE, PA=
GE_SIZE,
> > +                                             write_fault, exec_fault, =
false);
>
> I think that either (1) we move this kvm_prepare_memory_fault_exit
> logic into the previous patch[1], or (2) we merge this patch with the
> previous one. IIUC, we can only advertise KVM_CAP_MEMORY_FAULT_INFO on
> arm64 if this logic is present.

Actually (sorry, about-face from our off-list chat), *does* it make
sense to merge these two patches? arm64 could benefit from annotated
EFAULTs even without KVM_CAP_EXIT_ON_MISSING: for instance if there
were spots outside the stage-2 handler if EFAULTs were annotated [a].
And if this patch was for some reason reverted in the future, then we
probably wouldn't want that to entail silencing any other
KVM_EXIT_MEMORY_FAULTs that arm64 might also get.

Sean did also ask me to merge some patches back on v5 [b], but I think
the point there was to enable KVM_CAP_EXIT_ON_MISSING at the same time
as adding the stage-2 annotation, which I'm doing here.

[a] Theoretically, anyways. Atm only x86 code uses
kvm_prepare_memory_fault_exit()
[b] https://lore.kernel.org/kvm/ZR4WzE1JOvq_0dhE@google.com/

> As for the changelog in the previous patch[1], if you leave it
> unmerged with this one, something like "Enable
> KVM_CAP_MEMORY_FAULT_INFO to make KVM_CAP_EXIT_ON_MISSING useful, as
> without it, userspace doesn't know which page(s) of memory it needs to
> fix" works for me.

For that previous patch, I updated the description to the following

> Advertise to arm64 userspaces that KVM_RUN may return annotated EFAULTs
> (see KVM_EXIT_MEMORY_FAULT). In fact KVM_RUN might already be annotating
> some EFAULTs, but this capability is necessary for userspace to know
> that.

Which I think makes more sense than sort of forward-declaring
KVM_CAP_EXIT_ON_MISSING on arm64.

On Tue, Jan 30, 2024 at 3:58=E2=80=AFPM James Houghton <jthoughton@google.c=
om> wrote:
>
> Also, I think we need to update the documentation for
> KVM_CAP_MEMORY_FAULT_INFO to say that it is available for arm64 now
> (just like you have done for KVM_CAP_EXIT_ON_MISSING).

Done, ty
