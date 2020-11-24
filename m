Return-Path: <SRS0=ECKt=E6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA2DDC63798
	for <kvmarm@archiver.kernel.org>; Tue, 24 Nov 2020 14:03:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3B4DB2076B
	for <kvmarm@archiver.kernel.org>; Tue, 24 Nov 2020 14:03:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dkbd/7tY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3B4DB2076B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 696B24BD5F;
	Tue, 24 Nov 2020 09:03:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ePA-aB2kSiIG; Tue, 24 Nov 2020 09:03:30 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 456144BD51;
	Tue, 24 Nov 2020 09:03:30 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 03ED64BD53
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2020 09:03:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vlknwdJKjaQv for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Nov 2020 09:03:27 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E3EBE4BD51
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2020 09:03:26 -0500 (EST)
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com
 [209.85.167.173])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id A4EE12083E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2020 14:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1606226605;
 bh=A6TnCuJdLj9q5HfFNTrBxz7k3b4KMIqE2FVnChsQeAg=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=Dkbd/7tYrq1B36XYmFQ15U0G7UvZvvWqs4lhzpnjdTIqpq34KgeDB0zt8TpKH4P1O
 zpfE5mg1+XAezF8UwWznF4NWFw93ZZtxPNCwapqrb+mG3Oc4Zp96G8dy2AvOczzaqx
 k9B8+oOe9RR6eBf2v0IUEwO57gwqWPfaG4rGL7yc=
Received: by mail-oi1-f173.google.com with SMTP id d9so23890234oib.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2020 06:03:25 -0800 (PST)
X-Gm-Message-State: AOAM532Nxoagp4uw6t+cZ06TuSVDorsi9aUCwBlmS7S2xDdcYjfmAJY8
 xf6Mr+oa0LYT2P6xm+ZqWd9+dUXruFRr62jMKzc=
X-Google-Smtp-Source: ABdhPJyLYspSEqcCFKEX1ayBRjo6TOPSA4DbofkL5jNPS1312/pVENwB+l8+OvJjUsywQrD2ILcANQ6HEXZg46Z/Bg8=
X-Received: by 2002:aca:c657:: with SMTP id w84mr2584171oif.47.1606226604807; 
 Tue, 24 Nov 2020 06:03:24 -0800 (PST)
MIME-Version: 1.0
References: <20201119162543.78001-1-dbrazdil@google.com>
 <20201119162543.78001-5-dbrazdil@google.com>
In-Reply-To: <20201119162543.78001-5-dbrazdil@google.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Tue, 24 Nov 2020 15:03:14 +0100
X-Gmail-Original-Message-ID: <CAMj1kXF9c6FXejpesh1E7ivgOm-aeUnG8enUhcyHDDjg8EgVJQ@mail.gmail.com>
Message-ID: <CAMj1kXF9c6FXejpesh1E7ivgOm-aeUnG8enUhcyHDDjg8EgVJQ@mail.gmail.com>
Subject: Re: [RFC PATCH 4/6] kvm: arm64: Remove patching of fn pointers in hyp
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
> Taking a function pointer will now generate a R_AARCH64_RELATIVE that is
> fixed up at early boot. Remove the alternative-based mechanism for
> converting the address from a kernel VA.
>
> Signed-off-by: David Brazdil <dbrazdil@google.com>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>  arch/arm64/include/asm/kvm_mmu.h   | 18 ------------------
>  arch/arm64/kernel/image-vars.h     |  1 -
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 11 ++++-------
>  arch/arm64/kvm/va_layout.c         |  6 ------
>  4 files changed, 4 insertions(+), 32 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index e5226f7e4732..8cb8974ec9cc 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -121,24 +121,6 @@ static __always_inline unsigned long __kern_hyp_va(unsigned long v)
>
>  #define kern_hyp_va(v)         ((typeof(v))(__kern_hyp_va((unsigned long)(v))))
>
> -static __always_inline unsigned long __kimg_hyp_va(unsigned long v)
> -{
> -       unsigned long offset;
> -
> -       asm volatile(ALTERNATIVE_CB("movz %0, #0\n"
> -                                   "movk %0, #0, lsl #16\n"
> -                                   "movk %0, #0, lsl #32\n"
> -                                   "movk %0, #0, lsl #48\n",
> -                                   kvm_update_kimg_phys_offset)
> -                    : "=r" (offset));
> -
> -       return __kern_hyp_va((v - offset) | PAGE_OFFSET);
> -}
> -
> -#define kimg_fn_hyp_va(v)      ((typeof(*v))(__kimg_hyp_va((unsigned long)(v))))
> -
> -#define kimg_fn_ptr(x) (typeof(x) **)(x)
> -
>  /*
>   * We currently support using a VM-specified IPA size. For backward
>   * compatibility, the default IPA size is fixed to 40bits.
> diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
> index 8539f34d7538..6379721236cf 100644
> --- a/arch/arm64/kernel/image-vars.h
> +++ b/arch/arm64/kernel/image-vars.h
> @@ -64,7 +64,6 @@ __efistub__ctype              = _ctype;
>  /* Alternative callbacks for init-time patching of nVHE hyp code. */
>  KVM_NVHE_ALIAS(kvm_patch_vector_branch);
>  KVM_NVHE_ALIAS(kvm_update_va_mask);
> -KVM_NVHE_ALIAS(kvm_update_kimg_phys_offset);
>  KVM_NVHE_ALIAS(kvm_get_kimage_voffset);
>
>  /* Global kernel state accessed by nVHE hyp code. */
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index b3db5f4eea27..7998eff5f0a2 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -110,9 +110,9 @@ static void handle___vgic_v3_restore_aprs(struct kvm_cpu_context *host_ctxt)
>
>  typedef void (*hcall_t)(struct kvm_cpu_context *);
>
> -#define HANDLE_FUNC(x) [__KVM_HOST_SMCCC_FUNC_##x] = kimg_fn_ptr(handle_##x)
> +#define HANDLE_FUNC(x) [__KVM_HOST_SMCCC_FUNC_##x] = (hcall_t)handle_##x
>
> -static const hcall_t *host_hcall[] = {
> +static const hcall_t host_hcall[] = {
>         HANDLE_FUNC(__kvm_vcpu_run),
>         HANDLE_FUNC(__kvm_flush_vm_context),
>         HANDLE_FUNC(__kvm_tlb_flush_vmid_ipa),
> @@ -132,7 +132,6 @@ static const hcall_t *host_hcall[] = {
>  static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
>  {
>         DECLARE_REG(unsigned long, id, host_ctxt, 0);
> -       const hcall_t *kfn;
>         hcall_t hfn;
>
>         id -= KVM_HOST_SMCCC_ID(0);
> @@ -140,13 +139,11 @@ static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
>         if (unlikely(id >= ARRAY_SIZE(host_hcall)))
>                 goto inval;
>
> -       kfn = host_hcall[id];
> -       if (unlikely(!kfn))
> +       hfn = host_hcall[id];
> +       if (unlikely(!hfn))
>                 goto inval;
>
>         cpu_reg(host_ctxt, 0) = SMCCC_RET_SUCCESS;
> -
> -       hfn = kimg_fn_hyp_va(kfn);
>         hfn(host_ctxt);
>
>         return;
> diff --git a/arch/arm64/kvm/va_layout.c b/arch/arm64/kvm/va_layout.c
> index 7f45a98eacfd..0494315f71f2 100644
> --- a/arch/arm64/kvm/va_layout.c
> +++ b/arch/arm64/kvm/va_layout.c
> @@ -373,12 +373,6 @@ static void generate_mov_q(u64 val, __le32 *origptr, __le32 *updptr, int nr_inst
>         *updptr++ = cpu_to_le32(insn);
>  }
>
> -void kvm_update_kimg_phys_offset(struct alt_instr *alt,
> -                                __le32 *origptr, __le32 *updptr, int nr_inst)
> -{
> -       generate_mov_q(kimage_voffset + PHYS_OFFSET, origptr, updptr, nr_inst);
> -}
> -
>  void kvm_get_kimage_voffset(struct alt_instr *alt,
>                             __le32 *origptr, __le32 *updptr, int nr_inst)
>  {
> --
> 2.29.2.299.gdc1121823c-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
