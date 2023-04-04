Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63AE4D2F2
	for <kvmarm@lists.linux.dev>; Tue,  4 Apr 2023 20:59:44 +0000 (UTC)
Received: by mail-ot1-f42.google.com with SMTP id 72-20020a9d064e000000b006a2f108924cso6581362otn.1
        for <kvmarm@lists.linux.dev>; Tue, 04 Apr 2023 13:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680641983;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8XB956O45UzVksOyeGhwxzyBdQXHDRc1Q4yj23qYiJg=;
        b=RN3hkQEhO24vo0vfwd4s0t68KhyLFB5bobj6eS6kQ1lCvGABwa562qwkSJpKBLhHsI
         j9WyV/bZ9XUUkmDYf+xx+nqLQRXXyoH1MuACy1KypDYbTisxMcFFPsQ27f1Wt48z1eCe
         Eff/XBDWq153oNecKmgeVWIXX2Wk5Cl2Wz2mDFmKW4gLy/ix+eYT7xT7Z8Onc9v69H+P
         akaXzFzIepYWUiCTz/CfJFD8qj4ynB6JoyOmjfvskEHLgdwgbEkTOaNBwplMqrR2YZQl
         92xCtdgJd+LiU2AY20nwNoj0e73AWfEbcYIiJBKhfeBA1W8r725EEmwGfIftOIdiMXdj
         dSmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680641983;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8XB956O45UzVksOyeGhwxzyBdQXHDRc1Q4yj23qYiJg=;
        b=y5D1XskErxwiezqDj03LwvrFYBHqu/TjtSjaGFXD7X5PV6u4pEA+VqiXi/cN9MWOcV
         aDyD+msTzj+6tJsJ71typkeQeGznzPF3v4MYRXkOaO2zhBaoPeTbFZEUpxWr48CablCJ
         7SesInLEMOupEjRwItUKtlyWgyJMboCDemRZ6E8MPUwRDMbfwOuj/oYMcqRKTnDqb0hv
         RsT2xaSAn7kKPdtWPULvmhDP1qP1W8tYY/0qtrN2PJPz0BELZIXqHw7C3pPhoQAWgJUD
         iq3Sk2o+AnbPuPiVDIhf/AgtvuPTUHlZm3dkjdpqVMuPpy4s6k36MRVhjemlGZwpMKlI
         kQ6A==
X-Gm-Message-State: AAQBX9c8+ruINnflHunt8/BTD5snjTp3MizXU0jq2ySLp8BsOR1SbnAS
	2ct8Bx0APz3f793mvGyAhc77mJSD6t1Y05vgYphPrw==
X-Google-Smtp-Source: AKy350Yb1ENyDDt/RXMy8DJfza/HP2Xi2qT3CKtQ2KekykdBNnmTfFThnO0XbepJYeJpk18FCS4o4myYZqokMZsT8/Y=
X-Received: by 2002:a9d:6191:0:b0:699:7883:940d with SMTP id
 g17-20020a9d6191000000b006997883940dmr1276983otk.7.1680641983242; Tue, 04 Apr
 2023 13:59:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230206172340.2639971-1-rananta@google.com> <20230206172340.2639971-5-rananta@google.com>
 <ZCTdcJLxWBRXItSM@linux.dev> <CAJHc60xbhyiVieqzeMcB1S7UWw_J3Jyh8PqjA9GLOhudja5nmA@mail.gmail.com>
 <ZCx13Q4nyRghItcI@linux.dev>
In-Reply-To: <ZCx13Q4nyRghItcI@linux.dev>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Tue, 4 Apr 2023 13:59:31 -0700
Message-ID: <CAJHc60z49Hfp0j39owGP1f+5Jv496ViVUfduAvSO36sv_2C1OA@mail.gmail.com>
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

On Tue, Apr 4, 2023 at 12:09=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> On Mon, Apr 03, 2023 at 02:23:17PM -0700, Raghavendra Rao Ananta wrote:
> > On Wed, Mar 29, 2023 at 5:53=E2=80=AFPM Oliver Upton <oliver.upton@linu=
x.dev> wrote:
> > >
> > > On Mon, Feb 06, 2023 at 05:23:37PM +0000, Raghavendra Rao Ananta wrot=
e:
> > > > Implement kvm_arch_flush_remote_tlbs_range() for arm64,
> > > > such that it can utilize the TLBI range based instructions
> > > > if supported.
> > > >
> > > > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > > > ---
> > > >  arch/arm64/include/asm/kvm_host.h |  3 +++
> > > >  arch/arm64/kvm/mmu.c              | 15 +++++++++++++++
> > > >  2 files changed, 18 insertions(+)
> > > >
> > > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include=
/asm/kvm_host.h
> > > > index dee530d75b957..211fab0c1de74 100644
> > > > --- a/arch/arm64/include/asm/kvm_host.h
> > > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > > @@ -1002,6 +1002,9 @@ struct kvm *kvm_arch_alloc_vm(void);
> > > >  #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
> > > >  int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
> > > >
> > > > +#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
> > > > +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_=
gfn, u64 pages);
> > > > +
> > > >  static inline bool kvm_vm_is_protected(struct kvm *kvm)
> > > >  {
> > > >       return false;
> > > > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > > > index e98910a8d0af6..409cb187f4911 100644
> > > > --- a/arch/arm64/kvm/mmu.c
> > > > +++ b/arch/arm64/kvm/mmu.c
> > > > @@ -91,6 +91,21 @@ int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
> > > >       return 0;
> > > >  }
> > > >
> > > > +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_=
gfn, u64 pages)
> > > > +{
> > > > +     phys_addr_t start, end;
> > > > +
> > > > +     if (!system_supports_tlb_range())
> > > > +             return -EOPNOTSUPP;
> > >
> > > There's multiple layers of fallback throughout this series, as it wou=
ld
> > > appear that deep in __kvm_tlb_flush_range() you're blasting the whole
> > > VMID if either the range is too large or the feature isn't supported.
> > >
> > > Is it possible to just normalize on a single spot to gate the use of
> > > range-based invalidations? I have a slight preference for doing it de=
ep
> > > in the handler, as it keeps the upper layers of code a bit more
> > > readable.
> > >
> > I was a little skeptical on this part, since the
> > kvm_arch_flush_remote_tlbs_range() expects to return -EOPNOTSUPP if
> > indeed there's no support.
>
> Well, the arch-neutral code can expect whatever it wants :) The only
> real contract we have with it is to return 0 iff the specified range has
> been invalidated, even if that comes with over-invalidating.
>
> > But I see your point. The if-else in kvm_pgtable_stage2_flush_range()
> > seems redundant and I can simply manage this conditions inside
> > __kvm_tlb_flush_range_vmid_ipa() itself, but I'll leave the
> > kvm_arch_flush_remote_tlbs_range()'s implementation as is. Thoughts?
>
> The largest concern I had is that the series is testing for FEAT_TLBIRANG=
E
> all over the shop and I just raised that concern on this patch. AFAICT,
> the iterative approach to invalidating a range of IPAs is effectively
> dead code, as all flows into __kvm_tlb_flush_range_vmid_ipa() are gated
> by system_supports_tlb_range() somewhere.
>
> Personally, I prefer keeping the higher level software models making
> aggressive use of range-based interfaces and letting the actual
> implementation under the hood select the appropriate instruction. That
> helps readability, as it directly communicates the expected outcome of
> the invalidation.
>
> So, if you want to make use of the iterative approach to TLB invalidation=
s on
> !TLBIRANGE systems, then this function should _not_ return EOPNOTSUPP.
>
Thanks for the explanation. I can make the calls consistent across the
code, and let the actual handler deal TLBIRANGE support.

- Raghavendra
> --
> Thanks,
> Oliver
