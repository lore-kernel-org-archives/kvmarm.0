Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A39A935
	for <kvmarm@lists.linux.dev>; Mon,  3 Apr 2023 21:23:29 +0000 (UTC)
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-17aceccdcf6so32313373fac.9
        for <kvmarm@lists.linux.dev>; Mon, 03 Apr 2023 14:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680557009;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X9EPMXOr7/BpSW0fz3V3pwNkNbHFJwN9oEHw10txBko=;
        b=JSrJHjc8ZlkN946jtgq7pXnminH4yEpKyDgM/gCOAmSADuPaZeN8qyXKh6Lz/tzW1k
         vTRrhW3M0FG6eVQiT1zs3JO0WEUFCRAZXEmnyUVmCQfh325zdk6HjRCKfWEO5vHZ2RSV
         GeyPLeOR4EuNwTOZEGuko3LAMXLdC7iuV1Zwrm4P2sKWvXR9ibfS69kHCma4Gu3Go0Bl
         N0hS3WBTKQ4Fgr4To1R7dFmoSj2mJpzvYRJ4QLoHHQcRjM7UoUVVOXbRWEgE/Yix3v4F
         qNsnERfOgf0ulmyZMGLFUpMyd/z89HcxRIWryz4ryLmHOlJnDzJUmy8/eUVgYwgz32x+
         5bJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680557009;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X9EPMXOr7/BpSW0fz3V3pwNkNbHFJwN9oEHw10txBko=;
        b=LfjX4o1KSxvwXNFHwdOR5yeGvUqfpzBoq+NT6vq27XlYHTwhqB3f1bHoZ25kwS+IQb
         ZIKVgfejGJA3gGJUfOToT2/dGOIQ2yRKfsE0tATgqUi7gNIDnxNS8wGG7qNo/45/idIx
         iAznFiQdEeGzJKvXKAc5p5IkpKkdSFtFdhCZn2Unge7GWAx4EscHNqYJbN5zwIQvG24q
         QxkdOB561PApyT2m92Ark+DHTgQsc57s9JG7aUQn6ps20/b9cOlGV+42n8P45vexpadp
         1A6zI+gnWcAwDzYdpicn7jD5uoxRRYcyesEVH6B3bHhUs+JSmq6+hmcaXuQEMMcO5k9v
         fHbQ==
X-Gm-Message-State: AAQBX9fphki9QtTBH+p2/MEbfkZf2K48KgVjwYXr+mSgyCKvgjMSqmf6
	qVuSyAtnCnbhKDavMu5PzKHpamN25B0tISc0SSmHRQ==
X-Google-Smtp-Source: AKy350ZxhWGAvzQvHaIIWFH212tmU5Na2D4k/xzxENz1UReTgZm1yspXtLicu2nfaNdqwOwe55eUrkgJerG4aimb47Y=
X-Received: by 2002:a05:6870:339e:b0:17e:7674:8df0 with SMTP id
 w30-20020a056870339e00b0017e76748df0mr281290oae.9.1680557008648; Mon, 03 Apr
 2023 14:23:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230206172340.2639971-1-rananta@google.com> <20230206172340.2639971-5-rananta@google.com>
 <ZCTdcJLxWBRXItSM@linux.dev>
In-Reply-To: <ZCTdcJLxWBRXItSM@linux.dev>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Mon, 3 Apr 2023 14:23:17 -0700
Message-ID: <CAJHc60xbhyiVieqzeMcB1S7UWw_J3Jyh8PqjA9GLOhudja5nmA@mail.gmail.com>
Subject: Re: [PATCH v2 4/7] KVM: arm64: Implement kvm_arch_flush_remote_tlbs_range()
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>, 
	Ricardo Koller <ricarkol@google.com>, Reiji Watanabe <reijiw@google.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Jing Zhang <jingzhangos@google.com>, Colton Lewis <coltonlewis@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 29, 2023 at 5:53=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> On Mon, Feb 06, 2023 at 05:23:37PM +0000, Raghavendra Rao Ananta wrote:
> > Implement kvm_arch_flush_remote_tlbs_range() for arm64,
> > such that it can utilize the TLBI range based instructions
> > if supported.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |  3 +++
> >  arch/arm64/kvm/mmu.c              | 15 +++++++++++++++
> >  2 files changed, 18 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm=
/kvm_host.h
> > index dee530d75b957..211fab0c1de74 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -1002,6 +1002,9 @@ struct kvm *kvm_arch_alloc_vm(void);
> >  #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
> >  int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
> >
> > +#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
> > +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn,=
 u64 pages);
> > +
> >  static inline bool kvm_vm_is_protected(struct kvm *kvm)
> >  {
> >       return false;
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index e98910a8d0af6..409cb187f4911 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -91,6 +91,21 @@ int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
> >       return 0;
> >  }
> >
> > +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn,=
 u64 pages)
> > +{
> > +     phys_addr_t start, end;
> > +
> > +     if (!system_supports_tlb_range())
> > +             return -EOPNOTSUPP;
>
> There's multiple layers of fallback throughout this series, as it would
> appear that deep in __kvm_tlb_flush_range() you're blasting the whole
> VMID if either the range is too large or the feature isn't supported.
>
> Is it possible to just normalize on a single spot to gate the use of
> range-based invalidations? I have a slight preference for doing it deep
> in the handler, as it keeps the upper layers of code a bit more
> readable.
>
I was a little skeptical on this part, since the
kvm_arch_flush_remote_tlbs_range() expects to return -EOPNOTSUPP if
indeed there's no support.
But I see your point. The if-else in kvm_pgtable_stage2_flush_range()
seems redundant and I can simply manage this conditions inside
__kvm_tlb_flush_range_vmid_ipa() itself, but I'll leave the
kvm_arch_flush_remote_tlbs_range()'s implementation as is. Thoughts?

Thank you.
Raghavendra


> > +     start =3D start_gfn << PAGE_SHIFT;
> > +     end =3D (start_gfn + pages) << PAGE_SHIFT;
> > +
> > +     kvm_call_hyp(__kvm_tlb_flush_range_vmid_ipa, &kvm->arch.mmu,
> > +                     start, end, KVM_PGTABLE_MAX_LEVELS - 1, 0);
> > +     return 0;
> > +}
> > +
> >  static bool kvm_is_device_pfn(unsigned long pfn)
> >  {
> >       return !pfn_is_map_memory(pfn);
> > --
> > 2.39.1.519.gcb327c4b5f-goog
> >
> >
>
> --
> Thanks,
> Oliver
