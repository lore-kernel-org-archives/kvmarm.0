Return-Path: <SRS0=3Een=FN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7FE8C4167B
	for <kvmarm@archiver.kernel.org>; Wed,  9 Dec 2020 13:01:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3EC0923B45
	for <kvmarm@archiver.kernel.org>; Wed,  9 Dec 2020 13:01:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3EC0923B45
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CD2D4B2FC;
	Wed,  9 Dec 2020 08:01:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XiCDX+nhEd1Z; Wed,  9 Dec 2020 08:01:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5938F4B2F1;
	Wed,  9 Dec 2020 08:01:52 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B33F4B2D7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Dec 2020 08:01:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WKBKmsv6GQrw for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Dec 2020 08:01:49 -0500 (EST)
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com
 [209.85.128.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CDE644B2D3
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Dec 2020 08:01:49 -0500 (EST)
Received: by mail-wm1-f67.google.com with SMTP id q75so1582458wme.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Dec 2020 05:01:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=JFqrvjW5ggq0+/xnT81gTlAuUmvGAZyqBQrhOvLhybw=;
 b=irNzgcIs/IhlG7j8FZF1Yv9WPdN0pMZxqPBTBeyPmK0rN9pW3V9W2o+UdnVxXcF7Wy
 SnL0VE737jZMGGQdewC8LyxdVVX9V8YXIwPAaaWPIQwNgIMsj7pBh8XJ9SMZhGhf6HJU
 Dzi1RuML9lEOUmJOvWuadpvkhytCcnmmCBD6vSgLJUT7X96tQ5iNOzqkD2qjzuu7TKdl
 zh/fSWDjkA0YbObX1sKXaOS2fScPAsow6oCpniA+yMs6Kb+Ivx2/Z50wB4g2qOkLfHGU
 2tqnUlKn6u8P/kzWqdDPDSnkAgl3ryy79X1lqslCwG5MwNU9ZaaQnm7+lxUQTUi7hGLr
 aXJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=JFqrvjW5ggq0+/xnT81gTlAuUmvGAZyqBQrhOvLhybw=;
 b=CcfNMTBlytHpvuTYS7lUnu/t+HfX3qxUbnVdZbZk8nhk2GVY6ZtHL4pyyKJ6B5gh6H
 59MIQp15fK+WqkePRUw9m+ceyQ/ovHef6bdc5a17USt09gDD72Mexfu2ytK7KFsTtWeL
 q8NPd6ZpGqd0tHGRLQezxr0LxcHrk7WaIDYuy2TEFm04JjcmVCyVJTpTteKaPqB0QchT
 F+fSerMq6FtbZutF/j/sGEHGVAQr5ms3U834mOiUzPiHWajXgwxiYYclnjceIoQHZX+M
 VMKfR7+QrwKoi/qsZmTwbXGYyJE/fjXd7rvRFSHoBjoP6dZmKumuQMD6kTGkLbLb9YaS
 ZHRg==
X-Gm-Message-State: AOAM531D+HTJ+QKoDIjdxshSqBPrKjuyj4h4dd0whwxoJ6sngk+bRiaD
 sgdJSCpcWmNBBx1RsL+anqkO+Q==
X-Google-Smtp-Source: ABdhPJzbr/oYf7go/KboT2H2FsrRWwB06zZx6/cY2dxrHx2MtzHR88WTcnuzuKEME4w0vvBdeL4NAA==
X-Received: by 2002:a1c:287:: with SMTP id 129mr2706564wmc.133.1607518908666; 
 Wed, 09 Dec 2020 05:01:48 -0800 (PST)
Received: from google.com ([2a01:4b00:8523:2d03:9d1b:d0eb:db43:6cd2])
 by smtp.gmail.com with ESMTPSA id b7sm3474204wrv.47.2020.12.09.05.01.45
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 09 Dec 2020 05:01:46 -0800 (PST)
Date: Wed, 9 Dec 2020 13:01:45 +0000
From: David Brazdil <dbrazdil@google.com>
To: Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [RFC PATCH 5/6] kvm: arm64: Fix constant-pool users in hyp
Message-ID: <20201209130145.lh27im2wqjpho5b6@google.com>
References: <20201119162543.78001-1-dbrazdil@google.com>
 <20201119162543.78001-6-dbrazdil@google.com>
 <CAMj1kXG_2MZu=JFqOPioGi-K3AtQHYvJyxkCR-HWBuagz=MoXw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAMj1kXG_2MZu=JFqOPioGi-K3AtQHYvJyxkCR-HWBuagz=MoXw@mail.gmail.com>
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

Hey, relized I never replied to this...

On Tue, Nov 24, 2020 at 03:08:20PM +0100, Ard Biesheuvel wrote:
> On Thu, 19 Nov 2020 at 17:26, David Brazdil <dbrazdil@google.com> wrote:
> >
> > Hyp code used to use absolute addressing via a constant pool to obtain
> > the kernel VA of 3 symbols - panic, __hyp_panic_string and
> > __kvm_handle_stub_hvc. This used to work because the kernel would
> > relocate the addresses in the constant pool to kernel VA at boot and hyp
> > would simply load them from there.
> >
> > Now that relocations are fixed up to point to hyp VAs, this does not
> > work any longer. Rework the helpers to convert hyp VA to kernel VA / PA
> > as needed.
> >
> 
> Ok, so the reason for the problem is that the literal exists inside
> the HYP text, and all literals are fixed up using the HYP mapping,
> even if they don't point to something that is mapped at HYP. Would it
> make sense to simply disregard literals that point outside of the HYP
> VA mapping?

That would be possible - I'm about to post a v1 with build-time generation of
these relocs and kernel symbols are easily recognizable as they're undefined
in that ELF object. But I do worry that that would confuse people a lot.
And if somebody referenced a kernel symbol in C (maybe not a use case, but...)
they would get different results depending on which addressing mode the
compiler picked.

> 
> > Signed-off-by: David Brazdil <dbrazdil@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_mmu.h | 29 +++++++++++++++++++----------
> >  arch/arm64/kvm/hyp/nvhe/host.S   | 29 +++++++++++++++--------------
> >  2 files changed, 34 insertions(+), 24 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> > index 8cb8974ec9cc..0676ff2105bb 100644
> > --- a/arch/arm64/include/asm/kvm_mmu.h
> > +++ b/arch/arm64/include/asm/kvm_mmu.h
> > @@ -72,9 +72,14 @@ alternative_cb kvm_update_va_mask
> >  alternative_cb_end
> >  .endm
> >
> > +.macro hyp_pa reg, tmp
> > +       ldr_l   \tmp, hyp_physvirt_offset
> > +       add     \reg, \reg, \tmp
> > +.endm
> > +
> >  /*
> > - * Convert a kernel image address to a PA
> > - * reg: kernel address to be converted in place
> > + * Convert a hypervisor VA to a kernel image address
> > + * reg: hypervisor address to be converted in place
> >   * tmp: temporary register
> >   *
> >   * The actual code generation takes place in kvm_get_kimage_voffset, and
> > @@ -82,18 +87,22 @@ alternative_cb_end
> >   * perform the register allocation (kvm_get_kimage_voffset uses the
> >   * specific registers encoded in the instructions).
> >   */
> > -.macro kimg_pa reg, tmp
> > +.macro hyp_kimg reg, tmp
> > +       /* Convert hyp VA -> PA. */
> > +       hyp_pa  \reg, \tmp
> > +
> > +       /* Load kimage_voffset. */
> >  alternative_cb kvm_get_kimage_voffset
> > -       movz    \tmp, #0
> > -       movk    \tmp, #0, lsl #16
> > -       movk    \tmp, #0, lsl #32
> > -       movk    \tmp, #0, lsl #48
> > +       movz    \tmp, #0
> > +       movk    \tmp, #0, lsl #16
> > +       movk    \tmp, #0, lsl #32
> > +       movk    \tmp, #0, lsl #48
> >  alternative_cb_end
> >
> > -       /* reg = __pa(reg) */
> > -       sub     \reg, \reg, \tmp
> > +       /* Convert PA -> kimg VA. */
> > +       add     \reg, \reg, \tmp
> >  .endm
> > -
> > +
> >  #else
> >
> >  #include <linux/pgtable.h>
> > diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
> > index 596dd5ae8e77..bcb80d525d8c 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/host.S
> > +++ b/arch/arm64/kvm/hyp/nvhe/host.S
> > @@ -74,27 +74,28 @@ SYM_FUNC_END(__host_enter)
> >   * void __noreturn __hyp_do_panic(bool restore_host, u64 spsr, u64 elr, u64 par);
> >   */
> >  SYM_FUNC_START(__hyp_do_panic)
> > -       /* Load the format arguments into x1-7 */
> > -       mov     x6, x3
> > -       get_vcpu_ptr x7, x3
> > -
> > -       mrs     x3, esr_el2
> > -       mrs     x4, far_el2
> > -       mrs     x5, hpfar_el2
> > -
> >         /* Prepare and exit to the host's panic funciton. */
> >         mov     lr, #(PSR_F_BIT | PSR_I_BIT | PSR_A_BIT | PSR_D_BIT |\
> >                       PSR_MODE_EL1h)
> >         msr     spsr_el2, lr
> >         ldr     lr, =panic
> > +       hyp_kimg lr, x6
> >         msr     elr_el2, lr
> >
> > -       /*
> > -        * Set the panic format string and enter the host, conditionally
> > -        * restoring the host context.
> > -        */
> > +       /* Set the panic format string. Use the, now free, LR as scratch. */
> > +       ldr     lr, =__hyp_panic_string
> > +       hyp_kimg lr, x6
> > +
> > +       /* Load the format arguments into x1-7. */
> > +       mov     x6, x3
> > +       get_vcpu_ptr x7, x3
> > +       mrs     x3, esr_el2
> > +       mrs     x4, far_el2
> > +       mrs     x5, hpfar_el2
> > +
> > +       /* Enter the host, conditionally restoring the host context. */
> >         cmp     x0, xzr
> > -       ldr     x0, =__hyp_panic_string
> > +       mov     x0, lr
> >         b.eq    __host_enter_without_restoring
> >         b       __host_enter_for_panic
> >  SYM_FUNC_END(__hyp_do_panic)
> > @@ -124,7 +125,7 @@ SYM_FUNC_END(__hyp_do_panic)
> >          * Preserve x0-x4, which may contain stub parameters.
> >          */
> >         ldr     x5, =__kvm_handle_stub_hvc
> > -       kimg_pa x5, x6
> > +       hyp_pa  x5, x6
> >         br      x5
> >  .L__vect_end\@:
> >  .if ((.L__vect_end\@ - .L__vect_start\@) > 0x80)
> > --
> > 2.29.2.299.gdc1121823c-goog
> >
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
