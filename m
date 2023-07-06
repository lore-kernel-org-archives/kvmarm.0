Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B04DA47
	for <kvmarm@lists.linux.dev>; Thu,  6 Jul 2023 05:18:20 +0000 (UTC)
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2b703d7ed3aso3354731fa.1
        for <kvmarm@lists.linux.dev>; Wed, 05 Jul 2023 22:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1688620698; x=1691212698;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4Pyew4brPaMX67Blh5xxcFOiu+e7xaU8tvYkzN+gBE8=;
        b=ZboYtskoEVGQ3PAqWlv+EBZjzbuk1OtrqlZtJIldGS6YDLutnht+md5ynH3JRJ8reP
         O9sA9xzXz5EHSG2POC0lUxSiVgvc7g7xpfmgJTsbBuVsmqpgLvDG6AOnubNdoIhOMyYk
         j58tsmmg6qUEhR8g9N0K5S6HWrxFegfdCvcp4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688620698; x=1691212698;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4Pyew4brPaMX67Blh5xxcFOiu+e7xaU8tvYkzN+gBE8=;
        b=KK7s/izcjTR863noQFdrOwEHaQzBaF9UqFIgA0btOZ5ZPEfz+7m0GgplrCYTEsMN0z
         6bSPpG61Oblu/OEmdUEqGIKU18p2RfNgyjZuBn7lFpOvqf7Z+lQdUJCy0sl8AwlT6Tlj
         S5sRW5cyqPIEpEXkExPRMgzeNhZluc7M17dC0j/Z8tiK71CVBCd9G9YhP7Vt8Unld+PB
         wyvUjJrk6iVnV92V8Ra2USQv+O5OrjjS26ZJgD8lvOel5Vg+OFWIbB89/l25oD82ZynB
         I82FIkWEj/rbnSEPHAzASDlNIsWMHcwedfXJrXj96Y0ZNRpywk3cfdxtZjx5dtxpMk9t
         I6aw==
X-Gm-Message-State: ABy/qLZvAlMi61wT+az0/dv6gXhuai1/JONS3B5KpigZ4zXiQW+ys781
	4cfvNFO/pU6gpIgLCyHfige0IhaImMezr1AEta6Txw==
X-Google-Smtp-Source: APBJJlFiaE5Rjy8N1mpXTKWuoY2gflHQlG7Qa0YN0CEaaUlIylK7sjjnfKxe8x2S2ynq0UzPO6qqGQ3z9DYXcAHxgSU=
X-Received: by 2002:a2e:8902:0:b0:2b6:de6d:8148 with SMTP id
 d2-20020a2e8902000000b002b6de6d8148mr499717lji.31.1688620697982; Wed, 05 Jul
 2023 22:18:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230704075054.3344915-1-stevensd@google.com> <20230704075054.3344915-6-stevensd@google.com>
 <20230706021016.GC3894444@ls.amr.corp.intel.com>
In-Reply-To: <20230706021016.GC3894444@ls.amr.corp.intel.com>
From: David Stevens <stevensd@chromium.org>
Date: Thu, 6 Jul 2023 14:18:06 +0900
Message-ID: <CAD=HUj5ermRAjxVYhERDA7fE0cZ5TAGunP6j7zM5YC6PyiZh-g@mail.gmail.com>
Subject: Re: [PATCH v7 5/8] KVM: x86/mmu: Don't pass FOLL_GET to __kvm_follow_pfn
To: Isaku Yamahata <isaku.yamahata@gmail.com>
Cc: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Peter Xu <peterx@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 6, 2023 at 11:10=E2=80=AFAM Isaku Yamahata <isaku.yamahata@gmai=
l.com> wrote:
>
> On Tue, Jul 04, 2023 at 04:50:50PM +0900,
> David Stevens <stevensd@chromium.org> wrote:
>
> > diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> > index cf2c6426a6fc..46c681dc45e6 100644
> > --- a/arch/x86/kvm/mmu/spte.c
> > +++ b/arch/x86/kvm/mmu/spte.c
> > @@ -138,7 +138,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mm=
u_page *sp,
> >              const struct kvm_memory_slot *slot,
> >              unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
> >              u64 old_spte, bool prefetch, bool can_unsync,
> > -            bool host_writable, u64 *new_spte)
> > +            bool host_writable, bool is_refcounted, u64 *new_spte)
> >  {
> >       int level =3D sp->role.level;
> >       u64 spte =3D SPTE_MMU_PRESENT_MASK;
> > @@ -188,6 +188,8 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mm=
u_page *sp,
> >
> >       if (level > PG_LEVEL_4K)
> >               spte |=3D PT_PAGE_SIZE_MASK;
> > +     else if (is_refcounted)
> > +             spte |=3D SPTE_MMU_PAGE_REFCOUNTED;
>
> Is REFCOUNTED for 4K page only?  What guarantees that large page doesn't =
have
> FOLL_GET? or can we set the bit for large page?

Oh, you're right, it should apply to >4K pages as well. This was based
on stale thinking from earlier versions of this series.

-David
