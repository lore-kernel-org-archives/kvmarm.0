Return-Path: <SRS0=ECKt=E6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FB75C2D0E4
	for <kvmarm@archiver.kernel.org>; Tue, 24 Nov 2020 13:45:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A74BA2083E
	for <kvmarm@archiver.kernel.org>; Tue, 24 Nov 2020 13:45:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="TUZkymM2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A74BA2083E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D5D664B93E;
	Tue, 24 Nov 2020 08:45:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2v4Zg7BrqhMl; Tue, 24 Nov 2020 08:45:19 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9165C4BB79;
	Tue, 24 Nov 2020 08:45:19 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C2FD44B50E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2020 08:45:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kll0v+uo8S+a for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Nov 2020 08:45:17 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7867F4B4B6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2020 08:45:17 -0500 (EST)
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com
 [209.85.210.48])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 4DCB22087D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2020 13:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1606225516;
 bh=mcAqjy1BYPHIo78PHi82FxCHHNnjpKdF8mXo2viVFy0=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=TUZkymM2pQgI9k3DphdmGGwQO5UDmPgtHstTZDlrYo+5Na22+Z6OCslKbUfdh5qyx
 W7IlchkKQHw4tUzAn5tFcLAHjw67J4gJRj7Tyxs3/lbQJoKxKc28EsPaean3SR+mtS
 gflNUxQpC3sle80/RDm1lTQVf5VbX2ZMqxzuIiM0=
Received: by mail-ot1-f48.google.com with SMTP id n11so19347686ota.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2020 05:45:16 -0800 (PST)
X-Gm-Message-State: AOAM530SwL+IJFkelZIAqwGeeg78IHTUf+zvR4bq+PkVrtsLrJweFJ4d
 vyoYRtiCIwwQhrghJ2pqHUDOmjvKMP75qoE5Esw=
X-Google-Smtp-Source: ABdhPJzhTmarkZehtEJgEAnn4uEqtzXfGm9JkAaBVRC2uo5XrWhc4DTzOv+kSjfTADqj0CO30WGWj2L8WM++qgosUmI=
X-Received: by 2002:a05:6830:3099:: with SMTP id
 f25mr3488962ots.77.1606225515506; 
 Tue, 24 Nov 2020 05:45:15 -0800 (PST)
MIME-Version: 1.0
References: <20201119162543.78001-1-dbrazdil@google.com>
 <20201119162543.78001-3-dbrazdil@google.com>
In-Reply-To: <20201119162543.78001-3-dbrazdil@google.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Tue, 24 Nov 2020 14:45:04 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFnTtAhs_d0EMsFhfZ=KGZJAsut-gtSEf-9dYC-XhB3Wg@mail.gmail.com>
Message-ID: <CAMj1kXFnTtAhs_d0EMsFhfZ=KGZJAsut-gtSEf-9dYC-XhB3Wg@mail.gmail.com>
Subject: Re: [RFC PATCH 2/6] kvm: arm64: Fix up RELA relocations in hyp
 code/data
To: David Brazdil <dbrazdil@google.com>
Cc: Android Kernel Team <kernel-team@android.com>,
 Marc Zyngier <maz@kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm <kvmarm@lists.cs.columbia.edu>
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

On Thu, 19 Nov 2020 at 17:25, David Brazdil <dbrazdil@google.com> wrote:
>
> KVM nVHE code runs under a different VA mapping than the kernel, hence
> so far it relied only on PC-relative addressing to avoid accidentally
> using a relocated kernel VA from a constant pool (see hyp_symbol_addr).
>
> So as to reduce the possibility of a programmer error, fixup the
> relocated addresses instead. Let the kernel relocate them to kernel VA
> first, but then iterate over them again, filter those that point to hyp
> code/data and convert the kernel VA to hyp VA.
>
> This is done after kvm_compute_layout and before apply_alternatives.
>

If this is significant enough to call out, please include the reason for it.

> Signed-off-by: David Brazdil <dbrazdil@google.com>
> ---
>  arch/arm64/include/asm/kvm_mmu.h |  1 +
>  arch/arm64/kernel/smp.c          |  4 +-
>  arch/arm64/kvm/va_layout.c       | 76 ++++++++++++++++++++++++++++++++
>  3 files changed, 80 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 5168a0c516ae..e5226f7e4732 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -105,6 +105,7 @@ alternative_cb_end
>  void kvm_update_va_mask(struct alt_instr *alt,
>                         __le32 *origptr, __le32 *updptr, int nr_inst);
>  void kvm_compute_layout(void);
> +void kvm_fixup_hyp_relocations(void);
>
>  static __always_inline unsigned long __kern_hyp_va(unsigned long v)
>  {
> diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
> index 18e9727d3f64..30241afc2c93 100644
> --- a/arch/arm64/kernel/smp.c
> +++ b/arch/arm64/kernel/smp.c
> @@ -434,8 +434,10 @@ static void __init hyp_mode_check(void)
>                            "CPU: CPUs started in inconsistent modes");
>         else
>                 pr_info("CPU: All CPU(s) started at EL1\n");
> -       if (IS_ENABLED(CONFIG_KVM))
> +       if (IS_ENABLED(CONFIG_KVM)) {
>                 kvm_compute_layout();
> +               kvm_fixup_hyp_relocations();
> +       }
>  }
>
>  void __init smp_cpus_done(unsigned int max_cpus)
> diff --git a/arch/arm64/kvm/va_layout.c b/arch/arm64/kvm/va_layout.c
> index d8cc51bd60bf..b80fab974896 100644
> --- a/arch/arm64/kvm/va_layout.c
> +++ b/arch/arm64/kvm/va_layout.c
> @@ -10,6 +10,7 @@
>  #include <asm/alternative.h>
>  #include <asm/debug-monitors.h>
>  #include <asm/insn.h>
> +#include <asm/kvm_asm.h>
>  #include <asm/kvm_mmu.h>
>  #include <asm/memory.h>
>
> @@ -82,6 +83,81 @@ __init void kvm_compute_layout(void)
>         init_hyp_physvirt_offset();
>  }
>
> +#define __load_elf_u64(s)                                      \
> +       ({                                                      \
> +               extern u64 s;                                   \
> +               u64 val;                                        \
> +                                                               \
> +               asm ("ldr %0, =%1" : "=r"(val) : "S"(&s));      \
> +               val;                                            \
> +       })
> +

Do you need this to ensure that the reference is absolute? There may
be more elegant ways to achieve that, using weak references for
instance.

Also, in the relocation startup code, I deliberately used a 32-bit
quantity here, as it won't get confused for an absolute virtual
address that needs relocation.


> +static bool __is_within_bounds(u64 addr, char *start, char *end)
> +{
> +       return start <= (char*)addr && (char*)addr < end;
> +}
> +
> +static bool __is_in_hyp_section(u64 addr)
> +{
> +       return __is_within_bounds(addr, __hyp_text_start, __hyp_text_end) ||
> +              __is_within_bounds(addr, __hyp_rodata_start, __hyp_rodata_end) ||
> +              __is_within_bounds(addr,
> +                                 CHOOSE_NVHE_SYM(__per_cpu_start),
> +                                 CHOOSE_NVHE_SYM(__per_cpu_end));
> +}
> +

It is slightly disappointing that we need to filter these one by one
like this, but I don't think there are any guarantees about the order
in which the R_AARCH64_RELATIVE entries appear.

> +static void __fixup_hyp_rel(u64 addr)

__init ?

> +{
> +       u64 *ptr, kern_va, hyp_va;
> +
> +       /* Adjust the relocation address taken from ELF for KASLR. */
> +       addr += kaslr_offset();
> +
> +       /* Skip addresses not in any of the hyp sections. */
> +       if (!__is_in_hyp_section(addr))
> +               return;
> +
> +       /* Get the LM alias of the relocation address. */
> +       ptr = (u64*)kvm_ksym_ref((void*)addr);
> +
> +       /*
> +        * Read the value at the relocation address. It has already been
> +        * relocated to the actual kernel kimg VA.
> +        */
> +       kern_va = (u64)kvm_ksym_ref((void*)*ptr);
> +
> +       /* Convert to hyp VA. */
> +       hyp_va = __early_kern_hyp_va(kern_va);
> +
> +       /* Store hyp VA at the relocation address. */
> +       *ptr = __early_kern_hyp_va(kern_va);
> +}
> +
> +static void __fixup_hyp_rela(void)

__init ?

> +{
> +       Elf64_Rela *rel;
> +       size_t i, n;
> +
> +       rel = (Elf64_Rela*)(kimage_vaddr + __load_elf_u64(__rela_offset));
> +       n = __load_elf_u64(__rela_size) / sizeof(*rel);
> +
> +       for (i = 0; i < n; ++i)
> +               __fixup_hyp_rel(rel[i].r_offset);
> +}
> +
> +/*
> + * The kernel relocated pointers to kernel VA. Iterate over relocations in
> + * the hypervisor ELF sections and convert them to hyp VA. This avoids the
> + * need to only use PC-relative addressing in hyp.
> + */
> +__init void kvm_fixup_hyp_relocations(void)

It is more idiomatic to put the __init after the 'void', and someone
is undoubtedly going to send a patch to 'fix' that if we merge it like
this.

> +{
> +       if (!IS_ENABLED(CONFIG_RELOCATABLE) || has_vhe())
> +               return;
> +
> +       __fixup_hyp_rela();
> +}
> +
>  static u32 compute_instruction(int n, u32 rd, u32 rn)
>  {
>         u32 insn = AARCH64_BREAK_FAULT;
> --
> 2.29.2.299.gdc1121823c-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
