Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB5FCC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 02:26:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 560A74B091;
	Mon, 18 Apr 2022 22:26:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lSG2x8+iQjcw; Mon, 18 Apr 2022 22:26:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E80624B0D6;
	Mon, 18 Apr 2022 22:26:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C4F749EE6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2022 22:26:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Goh1d9BcfhUk for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Apr 2022 22:26:10 -0400 (EDT)
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com
 [209.85.221.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BF7B74B0D6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2022 22:26:10 -0400 (EDT)
Received: by mail-wr1-f45.google.com with SMTP id w4so20524229wrg.12
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2022 19:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=KTq4Y6MG952cbTvHOp9S8QrMczzWgHAuOZaPcb2lyOA=;
 b=EE29iXYuMVb/GLtdNuB3Ye8GMB7xgcyCRPY7fLBQyIzdUPoANUNve0iXc2zy4OIY4w
 sqlHmycM+WcT12q2QZ0joUMdkAaZwEYIsfEi6Xob+InHwkkQztaP46mx10bjQEbNDgOV
 rQ/Cztvrnw5o22jB1RbJYxUK8a99jKnqP2RsLyx70bd5XfrhEQvTdLOWC12xctMwupfK
 u/x9Rkt1sh2KKpmIBMSb32Y3ixhpe0nn/9puHUiTQa11UXmFw+cTTMi7K7mVjT9ncxMJ
 6R5K2NBkCgD/0Eny6ATML4nWAjPH9ODoBn9EPOAaqfIUK71S0vkkrmiRa6TsUOTgoFo2
 4qzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=KTq4Y6MG952cbTvHOp9S8QrMczzWgHAuOZaPcb2lyOA=;
 b=vpjlSqacGj+BX/05JMUAt+ta/jXaekbEHuNm/2aAAXz2xkoYTYPFP2iU8p5TVqUHFl
 fXp302788I0S+QXCScm8ZcDexpT5nSX6tKBFPcwpjjknJQ6Ry3tqLHk5wqCy4xbqgxlo
 QBinOhk0349RRkS3yS0U+q7dYfeZsffbF0dVVLJq3D57HhP3+pVvTTNoX4fRwwpRzUx4
 lolFnO+BpmBOEbusxJGkvyu2l16eCjFgb+Aoi/CS8IFkINQIvmhHqJ2+/lIwo9XtdzI1
 MjcobNgo/3xL+9Fpu1TJhE/qrCKEVrtHD+yFy8zLu726kG7UiIuiQZY5WdX8TQW80nuB
 ScsQ==
X-Gm-Message-State: AOAM532ZVkHl/4IuZPf15VHz9C0/wENtEsDJ87CCF8lYntO7Jq+tbxAc
 t5NXBmg3coL5/NMj64DFj4So+zex/BpjcHKYN/wLEg==
X-Google-Smtp-Source: ABdhPJyxCGSlBiOKFfGmT8l9+r/CXUB9ViouaEaAAckadAPOZhmFEmo7/f9noRPmK8DbOVuocEbFln61pb9OOJRTcVw=
X-Received: by 2002:adf:eb86:0:b0:1e6:8c92:af6b with SMTP id
 t6-20020adfeb86000000b001e68c92af6bmr9930705wrn.116.1650335169435; Mon, 18
 Apr 2022 19:26:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220408200349.1529080-1-kaleshsingh@google.com>
 <20220408200349.1529080-4-kaleshsingh@google.com>
 <87wnfmaexc.wl-maz@kernel.org>
In-Reply-To: <87wnfmaexc.wl-maz@kernel.org>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Mon, 18 Apr 2022 19:25:58 -0700
Message-ID: <CAC_TJvfK3zJ_dN-0E3xJOWjdDybU12UfocoMf6-ji_swExas_Q@mail.gmail.com>
Subject: Re: [PATCH v7 3/6] KVM: arm64: Add guard pages for KVM nVHE
 hypervisor stack
To: Marc Zyngier <maz@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>, Will Deacon <will@kernel.org>,
 "Cc: Android Kernel" <kernel-team@android.com>,
 Masahiro Yamada <masahiroy@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 Changbin Du <changbin.du@intel.com>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, kvmarm <kvmarm@lists.cs.columbia.edu>
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

On Mon, Apr 18, 2022 at 3:01 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Fri, 08 Apr 2022 21:03:26 +0100,
> Kalesh Singh <kaleshsingh@google.com> wrote:
> >
> > Map the stack pages in the flexible private VA range and allocate
> > guard pages below the stack as unbacked VA space. The stack is aligned
> > so that any valid stack address has PAGE_SHIFT bit as 1 - this is used
> > for overflow detection (implemented in a subsequent patch in the series).
> >
> > Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> > Tested-by: Fuad Tabba <tabba@google.com>
> > Reviewed-by: Fuad Tabba <tabba@google.com>
> > ---
> >
> > Changes in v7:
> >   - Add Fuad's Reviewed-by and Tested-by tags.
> >
> > Changes in v6:
> >   - Update call to hyp_alloc_private_va_range() (return val and params)
> >
> > Changes in v5:
> >   - Use a single allocation for stack and guard pages to ensure they
> >     are contiguous, per Marc
> >
> > Changes in v4:
> >   - Replace IS_ERR_OR_NULL check with IS_ERR check now that
> >     hyp_alloc_private_va_range() returns an error for null
> >     pointer, per Fuad
> >   - Format comments to < 80 cols, per Fuad
> >
> > Changes in v3:
> >   - Handle null ptr in IS_ERR_OR_NULL checks, per Mark
> >
> >
> >  arch/arm64/include/asm/kvm_asm.h |  1 +
> >  arch/arm64/include/asm/kvm_mmu.h |  3 +++
> >  arch/arm64/kvm/arm.c             | 39 +++++++++++++++++++++++++++++---
> >  arch/arm64/kvm/mmu.c             |  4 ++--
> >  4 files changed, 42 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> > index d5b0386ef765..2e277f2ed671 100644
> > --- a/arch/arm64/include/asm/kvm_asm.h
> > +++ b/arch/arm64/include/asm/kvm_asm.h
> > @@ -169,6 +169,7 @@ struct kvm_nvhe_init_params {
> >       unsigned long tcr_el2;
> >       unsigned long tpidr_el2;
> >       unsigned long stack_hyp_va;
> > +     unsigned long stack_pa;
> >       phys_addr_t pgd_pa;
> >       unsigned long hcr_el2;
> >       unsigned long vttbr;
> > diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> > index a50cbb5ba402..b805316c4866 100644
> > --- a/arch/arm64/include/asm/kvm_mmu.h
> > +++ b/arch/arm64/include/asm/kvm_mmu.h
> > @@ -117,6 +117,9 @@ alternative_cb_end
> >  #include <asm/mmu_context.h>
> >  #include <asm/kvm_host.h>
> >
> > +extern struct kvm_pgtable *hyp_pgtable;
> > +extern struct mutex kvm_hyp_pgd_mutex;
>
> I'd rather you don't expose this at all.
>
> > +
> >  void kvm_update_va_mask(struct alt_instr *alt,
> >                       __le32 *origptr, __le32 *updptr, int nr_inst);
> >  void kvm_compute_layout(void);
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 523bc934fe2f..5687c0175151 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -1483,7 +1483,6 @@ static void cpu_prepare_hyp_mode(int cpu)
> >       tcr |= (idmap_t0sz & GENMASK(TCR_TxSZ_WIDTH - 1, 0)) << TCR_T0SZ_OFFSET;
> >       params->tcr_el2 = tcr;
> >
> > -     params->stack_hyp_va = kern_hyp_va(per_cpu(kvm_arm_hyp_stack_page, cpu) + PAGE_SIZE);
> >       params->pgd_pa = kvm_mmu_get_httbr();
> >       if (is_protected_kvm_enabled())
> >               params->hcr_el2 = HCR_HOST_NVHE_PROTECTED_FLAGS;
> > @@ -1933,14 +1932,48 @@ static int init_hyp_mode(void)
> >        * Map the Hyp stack pages
> >        */
> >       for_each_possible_cpu(cpu) {
> > +             struct kvm_nvhe_init_params *params = per_cpu_ptr_nvhe_sym(kvm_init_params, cpu);
> >               char *stack_page = (char *)per_cpu(kvm_arm_hyp_stack_page, cpu);
> > -             err = create_hyp_mappings(stack_page, stack_page + PAGE_SIZE,
> > -                                       PAGE_HYP);
> > +             unsigned long hyp_addr;
> >
> > +             /*
> > +              * Allocate a contiguous HYP private VA range for the stack
> > +              * and guard page. The allocation is also aligned based on
> > +              * the order of its size.
> > +              */
> > +             err = hyp_alloc_private_va_range(PAGE_SIZE * 2, &hyp_addr);
> > +             if (err) {
> > +                     kvm_err("Cannot allocate hyp stack guard page\n");
> > +                     goto out_err;
> > +             }
> > +
> > +             /*
> > +              * Since the stack grows downwards, map the stack to the page
> > +              * at the higher address and leave the lower guard page
> > +              * unbacked.
> > +              *
> > +              * Any valid stack address now has the PAGE_SHIFT bit as 1
> > +              * and addresses corresponding to the guard page have the
> > +              * PAGE_SHIFT bit as 0 - this is used for overflow detection.
> > +              */
> > +             mutex_lock(&kvm_hyp_pgd_mutex);
> > +             err = kvm_pgtable_hyp_map(hyp_pgtable, hyp_addr + PAGE_SIZE,
> > +                                     PAGE_SIZE, __pa(stack_page), PAGE_HYP);
> > +             mutex_unlock(&kvm_hyp_pgd_mutex);
>
> The mutex (and the HYP page table structure) really should stay
> private to the MMU code. Just add a new helper that will take the lock
> and use hyp_pgtable.

Agreed. I think we can expose __create_hyp_mappings() instead here.

Thanks,
Kalesh

>
> >               if (err) {
> >                       kvm_err("Cannot map hyp stack\n");
> >                       goto out_err;
> >               }
> > +
> > +             /*
> > +              * Save the stack PA in nvhe_init_params. This will be needed
> > +              * to recreate the stack mapping in protected nVHE mode.
> > +              * __hyp_pa() won't do the right thing there, since the stack
> > +              * has been mapped in the flexible private VA space.
> > +              */
> > +             params->stack_pa = __pa(stack_page);
> > +
> > +             params->stack_hyp_va = hyp_addr + (2 * PAGE_SIZE);
> >       }
> >
> >       for_each_possible_cpu(cpu) {
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 3d3efea4e991..a54f00bd06cc 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -22,8 +22,8 @@
> >
> >  #include "trace.h"
> >
> > -static struct kvm_pgtable *hyp_pgtable;
> > -static DEFINE_MUTEX(kvm_hyp_pgd_mutex);
> > +struct kvm_pgtable *hyp_pgtable;
> > +DEFINE_MUTEX(kvm_hyp_pgd_mutex);
> >
> >  static unsigned long hyp_idmap_start;
> >  static unsigned long hyp_idmap_end;
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
