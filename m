Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201B3A935
	for <kvmarm@lists.linux.dev>; Mon,  3 Apr 2023 21:08:42 +0000 (UTC)
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-17683b570b8so32261194fac.13
        for <kvmarm@lists.linux.dev>; Mon, 03 Apr 2023 14:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680556121;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YYO5Q9xcDwGhhJXwP7FhrHqIG5oPNHWFCyDP0fw34Y4=;
        b=Y+c7CV1lEypt/5pYzPsfM7H6xqM1xlMSw00MLh5URT4GZp3Qz/oAOCw7tmiVCBD9d0
         lOL7E+YSRE4yfLUD2cPLIDVejl2iVVLOFRR9C5bzvDQKBZU+pAvpukErA/0uON+5K4vZ
         feMOQm/ZL0IViZ3yXz2IWT9nzOmWI6VI20HrX3xzr96v3iPWn2qdJ3JT/ci35k55+4AS
         dUbO1D7L7MoEWP5gK1HQaO+GT38Ze1wKUCKn29AgOrSzobpWebzc3/swww7WhUN4jtzV
         4E2Xyg0Z9cqrDb16SdXGdT3x4l9Vr2nMEgnzb0HhcEIpm7ClFNKSylXj10qvjsouY1Pc
         p9pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680556121;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YYO5Q9xcDwGhhJXwP7FhrHqIG5oPNHWFCyDP0fw34Y4=;
        b=seqszVfkX2nZuRTEY34ZGYFPKQgbu5M1RfY0DYNjcSs8xBFg3ycrW2wCEjL6hKhFJX
         SCszXHvNfJ+mnmvR/J1Onml8IwgGAyS73j6aPg6Tk86+jIOy3FfUbS9qdfBjt4Iycgnh
         c8GxwmXbBiaRlQW9btnFEst+sf/lcsHERdM5FHmDWAlF2Z2QE6dZeXaL5c1l3y9kIAfs
         c/1JGmOvemHFTrT5eix1iWhY8JHidPBB55QZkyhZR4MXI3spoq32yVOyZTrldQckwN+n
         CWrmptpKfIbs4W0NeO0UiBvR23H1APaxlmF0OFV6h5C1vY9xLkR9eea2bMhF1jqfNlHj
         bpaQ==
X-Gm-Message-State: AAQBX9fdIpBWD1/ADmenldEbQOsTRQUvSQzeNqCW035qPiqgEaD/Rt1+
	5E36dfREuGXbDEJvQX+TRR7lAZevKna0CPxx7jmYAQ==
X-Google-Smtp-Source: AKy350Z8MUinKXoco8X7G+BSkzc5PLWN0vKx/ieX8QMuJqevauIUuCxuxxsgGlclYqFlvQe44I4ErC2LpzBXkonie/o=
X-Received: by 2002:a05:6870:3c07:b0:177:b9c0:bcba with SMTP id
 gk7-20020a0568703c0700b00177b9c0bcbamr8642835oab.3.1680556120926; Mon, 03 Apr
 2023 14:08:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230206172340.2639971-1-rananta@google.com> <20230206172340.2639971-4-rananta@google.com>
 <ZCTe5koj8fOgbrYO@linux.dev>
In-Reply-To: <ZCTe5koj8fOgbrYO@linux.dev>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Mon, 3 Apr 2023 14:08:29 -0700
Message-ID: <CAJHc60x-ZHN=ZQemZp0wkj5jp-Ys8024YDQmWhmKn3NgZ0HHCQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/7] KVM: arm64: Implement __kvm_tlb_flush_range_vmid_ipa()
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

On Wed, Mar 29, 2023 at 5:59=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> On Mon, Feb 06, 2023 at 05:23:36PM +0000, Raghavendra Rao Ananta wrote:
> > Define  __kvm_tlb_flush_range_vmid_ipa() (for VHE and nVHE)
>
> bikeshed: Personally, I find that range implies it takes an address as an
> argument already. Maybe just call it __kvm_tlb_flush_vmid_range()
>
Hmm, since TLBI instructions takes-in a variety of ranges, VA or IPA,
I just thought of extending the '_ipa' to make things clear. Moreover
it aligns with the existing __kvm_tlb_flush_vmid_ipa(). WDYT?

Thank you.
Raghavendra

> > to flush a range of stage-2 page-tables using IPA in one go.
> > If the system supports FEAT_TLBIRANGE, the following patches
> > would conviniently replace global TLBI such as vmalls12e1is
> > in the map, unmap, and dirty-logging paths with ripas2e1is
> > instead.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_asm.h   |  3 +++
> >  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 12 ++++++++++++
> >  arch/arm64/kvm/hyp/nvhe/tlb.c      | 28 ++++++++++++++++++++++++++++
> >  arch/arm64/kvm/hyp/vhe/tlb.c       | 24 ++++++++++++++++++++++++
> >  4 files changed, 67 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/=
kvm_asm.h
> > index 995ff048e8851..80a8ea85e84f8 100644
> > --- a/arch/arm64/include/asm/kvm_asm.h
> > +++ b/arch/arm64/include/asm/kvm_asm.h
> > @@ -79,6 +79,7 @@ enum __kvm_host_smccc_func {
> >       __KVM_HOST_SMCCC_FUNC___pkvm_init_vm,
> >       __KVM_HOST_SMCCC_FUNC___pkvm_init_vcpu,
> >       __KVM_HOST_SMCCC_FUNC___pkvm_teardown_vm,
> > +     __KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_range_vmid_ipa,
> >  };
> >
> >  #define DECLARE_KVM_VHE_SYM(sym)     extern char sym[]
> > @@ -243,6 +244,8 @@ extern void __kvm_flush_vm_context(void);
> >  extern void __kvm_flush_cpu_context(struct kvm_s2_mmu *mmu);
> >  extern void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr=
_t ipa,
> >                                    int level);
> > +extern void __kvm_tlb_flush_range_vmid_ipa(struct kvm_s2_mmu *mmu, phy=
s_addr_t start,
> > +                                             phys_addr_t end, int leve=
l, int tlb_level);
> >  extern void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu);
> >
> >  extern void __kvm_timer_set_cntvoff(u64 cntvoff);
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nv=
he/hyp-main.c
> > index 728e01d4536b0..5787eee4c9fe4 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > @@ -125,6 +125,17 @@ static void handle___kvm_tlb_flush_vmid_ipa(struct=
 kvm_cpu_context *host_ctxt)
> >       __kvm_tlb_flush_vmid_ipa(kern_hyp_va(mmu), ipa, level);
> >  }
> >
> > +static void handle___kvm_tlb_flush_range_vmid_ipa(struct kvm_cpu_conte=
xt *host_ctxt)
> > +{
> > +     DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
> > +     DECLARE_REG(phys_addr_t, start, host_ctxt, 2);
> > +     DECLARE_REG(phys_addr_t, end, host_ctxt, 3);
> > +     DECLARE_REG(int, level, host_ctxt, 4);
> > +     DECLARE_REG(int, tlb_level, host_ctxt, 5);
> > +
> > +     __kvm_tlb_flush_range_vmid_ipa(kern_hyp_va(mmu), start, end, leve=
l, tlb_level);
> > +}
> > +
> >  static void handle___kvm_tlb_flush_vmid(struct kvm_cpu_context *host_c=
txt)
> >  {
> >       DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
> > @@ -315,6 +326,7 @@ static const hcall_t host_hcall[] =3D {
> >       HANDLE_FUNC(__kvm_vcpu_run),
> >       HANDLE_FUNC(__kvm_flush_vm_context),
> >       HANDLE_FUNC(__kvm_tlb_flush_vmid_ipa),
> > +     HANDLE_FUNC(__kvm_tlb_flush_range_vmid_ipa),
> >       HANDLE_FUNC(__kvm_tlb_flush_vmid),
> >       HANDLE_FUNC(__kvm_flush_cpu_context),
> >       HANDLE_FUNC(__kvm_timer_set_cntvoff),
> > diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tl=
b.c
> > index d296d617f5896..7398dd00445e7 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/tlb.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
> > @@ -109,6 +109,34 @@ void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *m=
mu,
> >       __tlb_switch_to_host(&cxt);
> >  }
> >
> > +void __kvm_tlb_flush_range_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_=
t start,
> > +                                     phys_addr_t end, int level, int t=
lb_level)
> > +{
> > +     struct tlb_inv_context cxt;
> > +
> > +     dsb(ishst);
> > +
> > +     /* Switch to requested VMID */
> > +     __tlb_switch_to_guest(mmu, &cxt);
> > +
> > +     __kvm_tlb_flush_range(ipas2e1is, mmu, start, end, level, tlb_leve=
l);
> > +
> > +     /*
> > +      * Range-based ipas2e1is flushes only Stage-2 entries, and since =
the
> > +      * VA isn't available for Stage-1 entries, flush the entire stage=
-1.
> > +      */
>
> nit: if we are going to preserve some of the commentary over in
> __kvm_tlb_flush_vmid_ipa(), I would prefer just an exact copy/paste.
> But, FWIW, I think you can just elide the clarifying comments altogether
> since the relationship between stage-1 and stage-2 invalidations is
> already documented.
>
> > +     dsb(ish);
> > +     __tlbi(vmalle1is);
> > +     dsb(ish);
> > +     isb();
> > +
> > +     /* See the comment below in __kvm_tlb_flush_vmid_ipa() */
>
> Same comment as above.
>
> --
> Thanks,
> Oliver
