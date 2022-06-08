Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6274EC433EF
	for <kvmarm@archiver.kernel.org>; Wed,  8 Jun 2022 18:17:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C84DC4B30F;
	Wed,  8 Jun 2022 14:17:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cqWCACXy3qQg; Wed,  8 Jun 2022 14:17:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8EEE54B2B0;
	Wed,  8 Jun 2022 14:17:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FF634B2B0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jun 2022 14:17:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oEfacY0o0BN3 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Jun 2022 14:17:43 -0400 (EDT)
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com
 [209.85.128.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B0A074B2AC
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jun 2022 14:17:43 -0400 (EDT)
Received: by mail-wm1-f53.google.com with SMTP id
 o37-20020a05600c512500b0039c4ba4c64dso5800182wms.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Jun 2022 11:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=8OBEITiFgGXkvExNu2dr60CBVLtLaZLG+tp2Q7CMyjg=;
 b=QX22xBb6csNQfOnTZ2QT3ee/qAR9RbhiSn4S17tioRyWi+z5Ew8SDvQpwgtPMwu0rI
 8He8zI5lKFhuiduYi6alQrKsNN9+BEx2+dGbWdAn5gxOAb90LU1MiIeSdvMQO5XyJEm6
 /GfEfGlVXwB8qlKQ3x4lvhcKkwwvkwONqN2Kb0Yp1nA/nqvzztq6Hc2dKQWJYeEtoPut
 SKVfgFny+08xq/+tRYuv153gN67uJ0ZqbiIrLjOBzBFdjIazMDp0jih1s5rcYbtazeRo
 OH6m9rhUQbAVi248y79YPs9TuzuKvDFf85hJu7E2RRTDdGVd0mmwtp6YwcWHDsaAbUFT
 +nMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=8OBEITiFgGXkvExNu2dr60CBVLtLaZLG+tp2Q7CMyjg=;
 b=ijpTJ1GDHKS9CO8/svePt3riFr6wbDa7MrVXpTj2v6DQZHK1DFcW9kUaILAp0sszyY
 JWMdBAPsjdEU5IbPt7xznspFj87jXcMBUN+Y0wEqEXacuCD4WFdx1HU/dhPVJngfQUnu
 cVzQzx78dRO3KfCUkRemF10NqlhYJCXzC7UE2kGIp26ulYCjcMmQg7zGN+tqqa2qL/MR
 2mSXhn3sPR6FkLVSPg6A8Lb7U/SZmNr0x3UyZlAfBYafjStZCbOr1GIXSUkgxUxD/XJJ
 wA0qf14bMZVICCkwkwTYN5w6Ogl0QXbYD9HU/616QnbK7fdtRmvNT1Z1CMZK4sTFthlX
 zvOA==
X-Gm-Message-State: AOAM532La/XB/ZdKPP+brrp5Yz/i5gb+SymzHyTsZuha5dxoub/sybhf
 7QQ/dskhLbZI+hJ/dDjksWbIFL1QJkxDaZX7EiCVeg==
X-Google-Smtp-Source: ABdhPJzxoLhtIiYwhNavmnixrmq6422CIJ7MOSe9r2ka3IOZ5J+nZfQMbcy9C6rUizoeBIbp/bE31iqpNY8gfjkhano=
X-Received: by 2002:a05:600c:4ed2:b0:397:7493:53e6 with SMTP id
 g18-20020a05600c4ed200b00397749353e6mr458035wmq.61.1654712262298; Wed, 08 Jun
 2022 11:17:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220607165105.639716-1-kaleshsingh@google.com>
 <20220607165105.639716-5-kaleshsingh@google.com>
 <8735gfr0jf.wl-maz@kernel.org>
In-Reply-To: <8735gfr0jf.wl-maz@kernel.org>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Wed, 8 Jun 2022 11:17:31 -0700
Message-ID: <CAC_TJvdKM4S1kSmr3jkOvFofjyg=ASibNqgiTJBTYP=We1S=fA@mail.gmail.com>
Subject: Re: [PATCH v3 4/5] KVM: arm64: Allocate shared stacktrace pages
To: Marc Zyngier <maz@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Alexei Starovoitov <ast@kernel.org>,
 Will Deacon <will@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 kvmarm <kvmarm@lists.cs.columbia.edu>,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>,
 "Cc: Android Kernel" <kernel-team@android.com>,
 Mark Brown <broonie@kernel.org>, "T.J. Mercier" <tjmercier@google.com>,
 LKML <linux-kernel@vger.kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Wed, Jun 8, 2022 at 2:02 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Tue, 07 Jun 2022 17:50:46 +0100,
> Kalesh Singh <kaleshsingh@google.com> wrote:
> >
> > The nVHE hypervisor can use this shared area to dump its stacktrace
> > addresses on hyp_panic(). Symbolization and printing the stacktrace can
> > then be handled by the host in EL1 (done in a later patch in this series).
> >
> > Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_asm.h |  1 +
> >  arch/arm64/kvm/arm.c             | 34 ++++++++++++++++++++++++++++++++
> >  arch/arm64/kvm/hyp/nvhe/setup.c  | 11 +++++++++++
> >  3 files changed, 46 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> > index 2e277f2ed671..ad31ac68264f 100644
> > --- a/arch/arm64/include/asm/kvm_asm.h
> > +++ b/arch/arm64/include/asm/kvm_asm.h
> > @@ -174,6 +174,7 @@ struct kvm_nvhe_init_params {
> >       unsigned long hcr_el2;
> >       unsigned long vttbr;
> >       unsigned long vtcr;
> > +     unsigned long stacktrace_hyp_va;
> >  };
> >
> >  /* Translate a kernel address @ptr into its equivalent linear mapping */
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 400bb0fe2745..c0a936a7623d 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -50,6 +50,7 @@ DEFINE_STATIC_KEY_FALSE(kvm_protected_mode_initialized);
> >  DECLARE_KVM_HYP_PER_CPU(unsigned long, kvm_hyp_vector);
> >
> >  static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
> > +DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stacktrace_page);
>
> Why isn't this static, since the address is passed via the
> kvm_nvhe_init_params block?

In the subsequent patch the host will need to read and symbolize the
addresses that the hypervisor dumped, it's done in stacktrace.c

>
> >  unsigned long kvm_arm_hyp_percpu_base[NR_CPUS];
> >  DECLARE_KVM_NVHE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
> >
> > @@ -1554,6 +1555,7 @@ static void cpu_prepare_hyp_mode(int cpu)
> >       tcr |= (idmap_t0sz & GENMASK(TCR_TxSZ_WIDTH - 1, 0)) << TCR_T0SZ_OFFSET;
> >       params->tcr_el2 = tcr;
> >
> > +     params->stacktrace_hyp_va = kern_hyp_va(per_cpu(kvm_arm_hyp_stacktrace_page, cpu));
> >       params->pgd_pa = kvm_mmu_get_httbr();
> >       if (is_protected_kvm_enabled())
> >               params->hcr_el2 = HCR_HOST_NVHE_PROTECTED_FLAGS;
> > @@ -1845,6 +1847,7 @@ static void teardown_hyp_mode(void)
> >       free_hyp_pgds();
> >       for_each_possible_cpu(cpu) {
> >               free_page(per_cpu(kvm_arm_hyp_stack_page, cpu));
> > +             free_page(per_cpu(kvm_arm_hyp_stacktrace_page, cpu));
> >               free_pages(kvm_arm_hyp_percpu_base[cpu], nvhe_percpu_order());
> >       }
> >  }
> > @@ -1936,6 +1939,23 @@ static int init_hyp_mode(void)
> >               per_cpu(kvm_arm_hyp_stack_page, cpu) = stack_page;
> >       }
> >
> > +     /*
> > +      * Allocate stacktrace pages for Hypervisor-mode.
> > +      * This is used by the hypervisor to share its stacktrace
> > +      * with the host on a hyp_panic().
> > +      */
> > +     for_each_possible_cpu(cpu) {
> > +             unsigned long stacktrace_page;
> > +
> > +             stacktrace_page = __get_free_page(GFP_KERNEL);
> > +             if (!stacktrace_page) {
> > +                     err = -ENOMEM;
> > +                     goto out_err;
> > +             }
> > +
> > +             per_cpu(kvm_arm_hyp_stacktrace_page, cpu) = stacktrace_page;
>
> I have the same feeling as with the overflow stack. This is
> potentially a huge amount of memory: on my test box, with 64k pages,
> this is a whole 10MB that I give away for something that is only a
> debug facility.
>
> Can this somehow be limited? I don't see it being less than a page as
> a problem, as the memory is always shared back with EL1 in the case of
> pKVM (and normal KVM doesn't have that problem anyway).
>
> Alternatively, this should be restricted to pKVM. With normal nVHE,
> the host should be able to parse the EL2 stack directly with some
> offsetting. Actually, this is probably the best option.

In a previous approach we had something similar to what you propose
(unwinding in el1) [1]. But doesn't work for our production use case
with protected mode since it disabled the stage 2 protection. We could
do the split and take a different approach for the protected and
unprotected mode, but  I'm not sure if it is worth the extra
complexity? If it is the memory usage you are concerned with, it could
be reduced to half of the current stack size (page size) [2], if we
want to retain all frames. But we could also have some max depth, say
like 16? One downside being that it could make stack overflows more
challenging to root cause.


[1] https://lore.kernel.org/lkml/20220224051439.640768-8-kaleshsingh@google.com/
[2] https://lore.kernel.org/r/CAC_TJvdCuGNEJC4M+bV6o48CSJRs_4GEUb3iiP_4ro79q=KesA@mail.gmail.com/

Thanks
Kalesh

>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
