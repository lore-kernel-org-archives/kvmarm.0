Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44F713E8AB
	for <kvmarm@lists.linux.dev>; Mon,  8 Apr 2024 15:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712591873; cv=none; b=tFXKVZGS3eBP/cQqgZwzrg+aPmHzvjao9LythxNmYx5qkUY+GS7cV+hqLl8sDzgdnvXzfwV+zfjnJsaNCodCZpX8YGTuj25/ly0pyqCm2FE7Fhc5T96DMVVcA0b96BvjVxQaKNecHlMizQJvxYaTUMDhZeJjg2Y1iOP0Ba8+v40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712591873; c=relaxed/simple;
	bh=Ad5C/UYhuvUhdMklJkieDNTRggO1HkgxtiVOtHU+lm4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b/bxwk9jsKh/+BPWn+A8Y4rCBhIThsMYYVv0qJjmF7Oy5IarrvqXdDQbrd3+YNHxLbV6RLd0PYyv2Wkz3mNF4mkK9Yo/qY1nLTxJ0o1FtaZ9B8eKCmAA6WsNwrYOlmIN8j0M+51Y9JOiXjAVKwXjUTPgqn1U2SYXOQ+01Ugky1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IASEGLAZ; arc=none smtp.client-ip=209.85.217.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IASEGLAZ"
Received: by mail-vs1-f53.google.com with SMTP id ada2fe7eead31-47a0bebeacaso291878137.0
        for <kvmarm@lists.linux.dev>; Mon, 08 Apr 2024 08:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712591870; x=1713196670; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YRMNNKeuxHrTajZrY5Q4P7nTCkdxS2+0xOMyH7RZT6Y=;
        b=IASEGLAZN61FZO9xfZSlL03I8j1xCZybZFWWliQubuiXUK0rQJadiFviyHTePb7fVT
         V4HSEXZ5pJaFZHwEwc0pt3wuZM5qN43sOq7FqONhPZ4S9DO7sUCW6RC6cxBc9f4TGfPG
         lnrzfcPmXy/edvq/C4EqGjQLF43rXDtj1QzfstF+VVL2Y7EWS12ponjxl3SRj2woSbOo
         FmfosnDAyYp8zsEFTehogL42ds2tkTkcWBAJyKaLs5BmtG4CrCNAZR+os9sr8lex6cqR
         7AwFswBjf/SloYqsSCW8h4L1Pz/7/COxNRU4Fdr6Wp3wJQu+gHkmVztrvEZpdZ3clfut
         rHuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712591870; x=1713196670;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YRMNNKeuxHrTajZrY5Q4P7nTCkdxS2+0xOMyH7RZT6Y=;
        b=wmKok4DEU4athsYUpG1wAZEh0vkFwjK7/0T6jFWNaxfdxer5DWG++54KQC8WJEMIK+
         k1PfdJSp354kg+bDcZfAWwPJWibMOCfEXRpWahqsN5EU40Di30mX+BS28a3UC++b5f7Z
         /3H5KOn++oAXIjk7VgYlaXKmQdjTGHRAUmyrNBF3tIoH/G9mHHsfQcqrp480q35OsbUu
         A2t7Qka/BsaR3Ip3F579c3FaXtk8lMnUDyRG8tMMcHVOxliB9N/hQIEFeI0NXafnKHYx
         PW+xkCzIE7qPHkNcAyEFwP6UDpVa5Mta2p08R+G/7zHWsbZ/HQRhlIuvj/ALxuLEA/Sh
         sEUA==
X-Gm-Message-State: AOJu0YwTAzv+CsnrgDY7FUpLwqH3XlC8o4dKT2o31dh6B4UeCiTiKlG3
	Z3AV+jJc7WtO3enC8r9JuZnAx08VdvFMqIrgOvUvoWcO3nFbg77XbrwhFYsd+2tRxrfeSo+v1NG
	3HHjspcs8KuNqmeKSuk4VnMPUrzDuuO/QcSdq
X-Google-Smtp-Source: AGHT+IFQnR+tKR996QvDJnP40U9B8iI0w8XtJJa2imquBNZDYtTItak0TUJ7+f10qZi9SGoeBvdQ/t86LJGMDmcItYM=
X-Received: by 2002:a05:6102:38c6:b0:479:e3bd:8b2f with SMTP id
 k6-20020a05610238c600b00479e3bd8b2fmr7325573vst.12.1712591870450; Mon, 08 Apr
 2024 08:57:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com> <20240327173531.1379685-4-tabba@google.com>
 <864jccti69.wl-maz@kernel.org> <CA+EHjTxRSQdaKXpYd6GHEejZk0mpKwPz0CPmnAxPPneGijtSsw@mail.gmail.com>
 <86zfu3sveu.wl-maz@kernel.org>
In-Reply-To: <86zfu3sveu.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 8 Apr 2024 16:57:13 +0100
Message-ID: <CA+EHjTzbtUXXeNGTjRH0-TjSf2VP+574qGzZHJ40g12jkxUivQ@mail.gmail.com>
Subject: Re: [PATCH v1 03/44] KVM: arm64: Move setting the page as dirty out
 of the critical section
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, will@kernel.org, qperret@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 8, 2024 at 4:53=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote:
>
> On Mon, 08 Apr 2024 16:41:15 +0100,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Hi Marc,
> >
> > On Mon, Apr 8, 2024 at 8:41=E2=80=AFAM Marc Zyngier <maz@kernel.org> wr=
ote:
> > >
> > > On Wed, 27 Mar 2024 17:34:50 +0000,
> > > Fuad Tabba <tabba@google.com> wrote:
> > > >
> > > > Move the unlock earlier in user_mem_abort() to shorten the
> > > > critical section. This also helps for future refactoring and
> > > > reuse of similar code.
> > > >
> > > > Signed-off-by: Fuad Tabba <tabba@google.com>
> > > > ---
> > > >  arch/arm64/kvm/mmu.c | 8 +++++---
> > > >  1 file changed, 5 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > > > index 18680771cdb0..3afc42d8833e 100644
> > > > --- a/arch/arm64/kvm/mmu.c
> > > > +++ b/arch/arm64/kvm/mmu.c
> > > > @@ -1522,8 +1522,10 @@ static int user_mem_abort(struct kvm_vcpu *v=
cpu, phys_addr_t fault_ipa,
> > > >
> > > >       read_lock(&kvm->mmu_lock);
> > > >       pgt =3D vcpu->arch.hw_mmu->pgt;
> > > > -     if (mmu_invalidate_retry(kvm, mmu_seq))
> > > > +     if (mmu_invalidate_retry(kvm, mmu_seq)) {
> > > > +             ret =3D -EAGAIN;
> > > >               goto out_unlock;
> > > > +     }
> > > >
> > > >       /*
> > > >        * If we are not forced to use page mapping, check if we are
> > > > @@ -1581,6 +1583,8 @@ static int user_mem_abort(struct kvm_vcpu *vc=
pu, phys_addr_t fault_ipa,
> > > >                                            memcache,
> > > >                                            KVM_PGTABLE_WALK_HANDLE_=
FAULT |
> > > >                                            KVM_PGTABLE_WALK_SHARED)=
;
> > > > +out_unlock:
> > > > +     read_unlock(&kvm->mmu_lock);
> > > >
> > > >       /* Mark the page dirty only if the fault is handled successfu=
lly */
> > > >       if (writable && !ret) {
> > > > @@ -1588,8 +1592,6 @@ static int user_mem_abort(struct kvm_vcpu *vc=
pu, phys_addr_t fault_ipa,
> > > >               mark_page_dirty_in_slot(kvm, memslot, gfn);
> > > >       }
> > > >
> > > > -out_unlock:
> > > > -     read_unlock(&kvm->mmu_lock);
> > > >       kvm_release_pfn_clean(pfn);
> > > >       return ret !=3D -EAGAIN ? ret : 0;
> > > >  }
> > >
> > > It now means that things such as marking a page dirty happens outside
> > > of the lock, which may interact with the dirty log/bitmap stuff.
> > >
> > > Can you elaborate on *why* this is correct?
> >
> > The reason why I _think_ this is correct (something I am less certain
> > about now judging by your reply :) is that this is a lock that
> > protects the stage-2 page tables (struct kvm_vcpu_arch::hw_mmu), held
> > in this case for read. As far as I can tell, kvm_set_pfn_dirty() and
> > mark_page_dirty_in_slot() only access and modify (i.e., write to) the
> > page without accessing the stage-2 page table. I think that the dirtly
> > log is protected by the slots_lock.
> >
> > Am I missing something?
>
> I'm just not sure, nothing more sinister than that. I was also
> reviewing 20240402213656.3068504-1-dmatlack@google.com, which also
> moves the access to the dirty bitmap outside of the critical section.
>
> I haven't had a chance to page the whole thing in, unfortunately,
> hence my question. In any case, it would be work documenting the
> rationale for this relaxation.

Of course. I'll do that in the respin (if I'm still convinced it's correct =
:)

/fuad

> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
