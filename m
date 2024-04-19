Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98FC913D278
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 21:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713563320; cv=none; b=i8vsGVLE9RX/em59UlFPwmEHd18w+JcB0C1341Mc6ypaxE+jMcZvRVKwkEs3ZFyiqnGeSLPelGK7rrnB4htX4vm4tS93tC+XyqEjH97Cvu9O4r2XkRQFklV7xYli9OJvkWQbcyDWH+0An678iouYZSztZXZn6D+IJMpSeVJC5VI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713563320; c=relaxed/simple;
	bh=jC2wl+OKojvmxomsUcue2OmqxcTv0WGwNmMswaqTDxQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fjxT8FcwoICVM/NJVT65ghI5Ar0u41LIe2+vDNxRAwqZu4rKnXj3Zc3QOeTmvENWcPFRLd4A45de0zJLuT0lVoEMxz6oZYqudbu5vGL3H7DaqHYwrPl6RkssZ/VKAs4gRl6DIF94ZRSU05sy0lID/9lmjPTIwHIXCx+pfNXNA10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0buztvwq; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0buztvwq"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-436ed871225so44831cf.1
        for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 14:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713563317; x=1714168117; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7WUgfQpxFSi9OMu/BLbxS5EwXbfPHvR9Oq0TsJVDLS8=;
        b=0buztvwq92WtozwMEm9UkSF4me/Ll3UyY60pyCQpti0BJTE5wVkdCGqimA/w1iJEzm
         iThwr5lSzZ09T1PGT7MtH/vGmgVSXGiKr65J3A+9ElODVh34Gqw3IwQTLsiXxTibZZlM
         v25QTU8Gmy4eQx3I9UnrjxrqgwkqsprsaEV5+srmxUrkJoeckgPfuqaHN1oLJ77lwlqa
         ADJ/m/Qo+4jQ0q+GTn0HDQArLSUz4WQZZ0gpEgctTpZptKArSRvzL1geojV2aBsrigeH
         3RsLHOJEWZgU3xMn27HLh4361CjF4ynHlXFwWHqlw+8HtLxa3lGpu93IwetkBCoilmZs
         vsXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713563317; x=1714168117;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7WUgfQpxFSi9OMu/BLbxS5EwXbfPHvR9Oq0TsJVDLS8=;
        b=u6RoYnf1FxpqHcU1q0OwNAYeR2Zbw5L77cfsqihLKvBHOwPGfhuAtRSjvzIhoiKOXu
         uhagHqtbcxw12FjQ4Yao/RbTx7kx3X0oEv0Y4s1YZODyfeqRJ0pwJ6zx5mk6veKfupEd
         yMdHuQ2jYvdSFdWaONEcu80RLVAFROD8zaa22FW/n0YVsbZ2J8DqQGcGruxoe8m4og+h
         0hzvGSvrv2az4fe+fXh7gsUvNHlCqXvXIIQhyPyrAWG7vO74ESTVl+rm54CbkdJTvwbV
         oBqIv35479+um8YC6gsSPSq6gtAn4/kmT0FDDqGAFrV5U7oxD5Vtj6b0v/fijigRR9qS
         gOXw==
X-Forwarded-Encrypted: i=1; AJvYcCXZQ7YZ3vhKtQuoxOiEoCqW+vK1YCJx0Gao44A+5dFg+2+pmMG2BW1kMCb4IqByBL4nrFJ0I9vU0BNi63WUcrfAumxw26L+
X-Gm-Message-State: AOJu0YyRjUxLOhclyH7/XZtcILi7pBhFRnVQdGOTUHZxYlqq8OKvW8S9
	bZSpGRWyxCgpFbjMphMm/6luepL27zL04sDOgGyDd7/vlnf3CSqWPz+JesnYcNhjL5x8hS+HQdl
	9HgILrCib8EDhvvma+/D6RAu4s3qAcBfhZaW8
X-Google-Smtp-Source: AGHT+IF/+KLjCOKrIy86O0ywp9xXyAU+ULEISk31UACWIOy8xyUI4tOEo7+H8GJqqYX/DI/5Jm7Jn6Bxyh5mWp8jmOE=
X-Received: by 2002:a05:622a:600f:b0:431:8176:e4e5 with SMTP id
 he15-20020a05622a600f00b004318176e4e5mr25735qtb.13.1713563317426; Fri, 19 Apr
 2024 14:48:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240401232946.1837665-1-jthoughton@google.com>
 <20240401232946.1837665-6-jthoughton@google.com> <ZhgZHJH3c5Lb5SBs@google.com>
 <Zhgdw8mVNYZvzgWH@google.com> <CADrL8HUpHQQbQCxd8JGVRr=eT6e4SYyfYZ7eTDsv8PK44FYV_A@mail.gmail.com>
 <ZiLc8OfXxc9QWxtg@google.com>
In-Reply-To: <ZiLc8OfXxc9QWxtg@google.com>
From: James Houghton <jthoughton@google.com>
Date: Fri, 19 Apr 2024 14:48:00 -0700
Message-ID: <CADrL8HUmGFP=w5COnJzyJ+2a2gjCugqQg9WDXQ2ZAK7B9gJThA@mail.gmail.com>
Subject: Re: [PATCH v3 5/7] KVM: x86: Participate in bitmap-based PTE aging
To: David Matlack <dmatlack@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Yu Zhao <yuzhao@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Gavin Shan <gshan@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	David Rientjes <rientjes@google.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 19, 2024 at 2:07=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> On 2024-04-19 01:47 PM, James Houghton wrote:
> > On Thu, Apr 11, 2024 at 10:28=E2=80=AFAM David Matlack <dmatlack@google=
.com> wrote:
> > > On 2024-04-11 10:08 AM, David Matlack wrote:
> > > bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
> > > {
> > >         bool young =3D false;
> > >
> > >         if (!range->arg.metadata->bitmap && kvm_memslots_have_rmaps(k=
vm))
> > >                 young =3D kvm_handle_gfn_range(kvm, range, kvm_age_rm=
ap);
> > >
> > >         if (tdp_mmu_enabled)
> > >                 young |=3D kvm_tdp_mmu_age_gfn_range(kvm, range);
> > >
> > >         return young;
> > > }
> > >
> > > bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
> > > {
> > >         bool young =3D false;
> > >
> > >         if (!range->arg.metadata->bitmap && kvm_memslots_have_rmaps(k=
vm))
> > >                 young =3D kvm_handle_gfn_range(kvm, range, kvm_test_a=
ge_rmap);
> > >
> > >         if (tdp_mmu_enabled)
> > >                 young |=3D kvm_tdp_mmu_test_age_gfn(kvm, range);
> > >
> > >         return young;
> >
> >
> > Yeah I think this is the right thing to do. Given your other
> > suggestions (on patch 3), I think this will look something like this
> > -- let me know if I've misunderstood something:
> >
> > bool check_rmap =3D !bitmap && kvm_memslot_have_rmaps(kvm);
> >
> > if (check_rmap)
> >   KVM_MMU_LOCK(kvm);
> >
> > rcu_read_lock(); // perhaps only do this when we don't take the MMU loc=
k?
> >
> > if (check_rmap)
> >   kvm_handle_gfn_range(/* ... */ kvm_test_age_rmap)
> >
> > if (tdp_mmu_enabled)
> >   kvm_tdp_mmu_test_age_gfn() // modified to be RCU-safe
> >
> > rcu_read_unlock();
> > if (check_rmap)
> >   KVM_MMU_UNLOCK(kvm);
>
> I was thinking a little different. If you follow my suggestion to first
> make the TDP MMU aging lockless, you'll end up with something like this
> prior to adding bitmap support (note: the comments are just for
> demonstrative purposes):
>
> bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
> {
>         bool young =3D false;
>
>         /* Shadow MMU aging holds write-lock. */
>         if (kvm_memslots_have_rmaps(kvm)) {
>                 write_lock(&kvm->mmu_lock);
>                 young =3D kvm_handle_gfn_range(kvm, range, kvm_age_rmap);
>                 write_unlock(&kvm->mmu_lock);
>         }
>
>         /* TDM MMU aging is lockless. */
>         if (tdp_mmu_enabled)
>                 young |=3D kvm_tdp_mmu_age_gfn_range(kvm, range);
>
>         return young;
> }
>
> Then when you add bitmap support it would look something like this:
>
> bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
> {
>         unsigned long *bitmap =3D range->arg.metadata->bitmap;
>         bool young =3D false;
>
>         /* SHadow MMU aging holds write-lock and does not support bitmap.=
 */
>         if (kvm_memslots_have_rmaps(kvm) && !bitmap) {
>                 write_lock(&kvm->mmu_lock);
>                 young =3D kvm_handle_gfn_range(kvm, range, kvm_age_rmap);
>                 write_unlock(&kvm->mmu_lock);
>         }
>
>         /* TDM MMU aging is lockless and supports bitmap. */
>         if (tdp_mmu_enabled)
>                 young |=3D kvm_tdp_mmu_age_gfn_range(kvm, range);
>
>         return young;
> }
>
> rcu_read_lock/unlock() would be called in kvm_tdp_mmu_age_gfn_range().

Oh yes this is a lot better. I hope I would have seen this when it
came time to actually update this patch. Thanks.

>
> That brings up a question I've been wondering about. If KVM only
> advertises support for the bitmap lookaround when shadow roots are not
> allocated, does that mean MGLRU will be blind to accesses made by L2
> when nested virtualization is enabled? And does that mean the Linux MM
> will think all L2 memory is cold (i.e. good candidate for swapping)
> because it isn't seeing accesses made by L2?

Yes, I think so (for both questions). That's better than KVM not
participating in MGLRU aging at all, which is the case today (IIUC --
also ignoring the case where KVM accesses guest memory directly). We
could have MGLRU always invoke the mmu notifiers, but frequently
taking the MMU lock for writing might be worse than evicting when we
shouldn't. Maybe Yu tried this at some point, but I can't find any
results for this.
