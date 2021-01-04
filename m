Return-Path: <SRS0=G82f=GH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4283DC433E0
	for <kvmarm@archiver.kernel.org>; Mon,  4 Jan 2021 23:40:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A8ACC2253D
	for <kvmarm@archiver.kernel.org>; Mon,  4 Jan 2021 23:40:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A8ACC2253D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E7CE74B26C;
	Mon,  4 Jan 2021 18:40:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4HeFztiieraP; Mon,  4 Jan 2021 18:40:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB1034B28F;
	Mon,  4 Jan 2021 18:40:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 308144B243
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Jan 2021 18:40:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Y8I3mj5n1HMM for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Jan 2021 18:39:58 -0500 (EST)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com
 [209.85.167.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8F0084B1B0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Jan 2021 18:39:58 -0500 (EST)
Received: by mail-lf1-f48.google.com with SMTP id m12so68486500lfo.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Jan 2021 15:39:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=QzwaGd5KCMcuum73OEWM9sVJrbq1N2BeQ3mdBiQwOTE=;
 b=FlH3B3ii4MG4kW1CiHWxs5Gkj9sBLJ5qTIk3tyK0sRDRZr/cwzkUUIkjEeV4sVuC6u
 5wnUHENdwpNCAMfVIVubXhbTQO0YoWzdQ4x8HZsUEz0lmOr7lcGMlca0sLoWaTmObLML
 tTv8TYmfnnS13YHDLnQP43sCV+5GSphfkh/gpKBG0MU7tNFCJUjzMmIIWNSu9YwRGigE
 N87iE6IRsE0qxnr8XGKtGrgZywPNWXUey2uvYk2wY0F6vhLUaT1tIP+zJdvXypUlxq6h
 /bIBySbG0qmyexKSOkMwt9wq8aL9luLHJfoZtbuUHhP8jE+09cIrfhuximFMt8voHoLH
 AFzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=QzwaGd5KCMcuum73OEWM9sVJrbq1N2BeQ3mdBiQwOTE=;
 b=Y6Am0uHZa6xrFXXqihLkgfg1F6InWBde/Tz0JPbm4nZUkPKGtEXO11uFuAKBqoqgG/
 zRHukF+TD/rvxPT76H36042oIoZilWZqF6SlVSMu594wWHHoPQUJLgcP9+onmBD2HAIG
 ejwiLC932xMDmz9ZyfRqAmn0Yb3EVFeyzf3TKyidKy/VmC4ttmKToHviuhGRYQGmNqQ/
 Jovt69qzJojE/2U6XtgyTlnBzBhcgsxOG2nJK9IZcpm2CI1masgYBa1Ky/h7XOB2DZyO
 XIj1vcoc6UdwBoH4U9urI5KCO5Rjp69hx1I0iPTl9m9ojyx93AzA3bGhQfRK9QEKO+tr
 YNxw==
X-Gm-Message-State: AOAM531XHaTzZ9wJkjRwkPQlylKRzot75AuLYSvg2Hc+U3jOfvnrbxpU
 meas31o0vIHf4TsPriSaaSqqP2USgAxNX5UEoDJVT8E/bmg=
X-Google-Smtp-Source: ABdhPJyv5Ph9KlozsOMRzRwxE/lDHQnEwTxDUaznjX+leGU71wlAKqPAHwy7n+UlVRn8TlFkMZXpQ3f6k1oU65ZU4yA=
X-Received: by 2002:a05:651c:48b:: with SMTP id
 s11mr35199865ljc.28.1609803597275; 
 Mon, 04 Jan 2021 15:39:57 -0800 (PST)
MIME-Version: 1.0
References: <20201228104958.1848833-1-maz@kernel.org>
 <20201228104958.1848833-5-maz@kernel.org>
In-Reply-To: <20201228104958.1848833-5-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Mon, 4 Jan 2021 17:39:45 -0600
Message-ID: <CAAdAUtgPCOfzKZZioMAG6KOY23MMnJdZ1Nsi5Z=0jHUbe2mbUw@mail.gmail.com>
Subject: Re: [PATCH 04/17] arm64: Provide an 'upgrade to VHE' stub hypercall
To: Marc Zyngier <maz@kernel.org>
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 Ard Biesheuvel <ardb@kernel.org>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Mon, Dec 28, 2020 at 4:50 AM Marc Zyngier <maz@kernel.org> wrote:
>
> As we are about to change the way a VHE system boots, let's
> provide the core helper, in the form of a stub hypercall that
> enables VHE and replicates the full EL1 context at EL2, thanks
> to EL1 and VHE-EL2 being extremely similar.
>
> On exception return, the kernel carries on at EL2. Fancy!
>
> Nothing calls this new hypercall yet, so no functional change.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/virt.h |  7 +++-
>  arch/arm64/kernel/hyp-stub.S  | 70 ++++++++++++++++++++++++++++++++++-
>  2 files changed, 74 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
> index ee6a48df89d9..7379f35ae2c6 100644
> --- a/arch/arm64/include/asm/virt.h
> +++ b/arch/arm64/include/asm/virt.h
> @@ -35,8 +35,13 @@
>   */
>  #define HVC_RESET_VECTORS 2
>
> +/*
> + * HVC_VHE_RESTART - Upgrade the CPU from EL1 to EL2, if possible
> + */
> +#define HVC_VHE_RESTART        3
> +
>  /* Max number of HYP stub hypercalls */
> -#define HVC_STUB_HCALL_NR 3
> +#define HVC_STUB_HCALL_NR 4
>
>  /* Error returned when an invalid stub number is passed into x0 */
>  #define HVC_STUB_ERR   0xbadca11
> diff --git a/arch/arm64/kernel/hyp-stub.S b/arch/arm64/kernel/hyp-stub.S
> index 160f5881a0b7..6ffdc1f7778b 100644
> --- a/arch/arm64/kernel/hyp-stub.S
> +++ b/arch/arm64/kernel/hyp-stub.S
> @@ -8,9 +8,9 @@
>
>  #include <linux/init.h>
>  #include <linux/linkage.h>
> -#include <linux/irqchip/arm-gic-v3.h>
>
>  #include <asm/assembler.h>
> +#include <asm/el2_setup.h>
>  #include <asm/kvm_arm.h>
>  #include <asm/kvm_asm.h>
>  #include <asm/ptrace.h>
> @@ -47,10 +47,16 @@ SYM_CODE_END(__hyp_stub_vectors)
>
>  SYM_CODE_START_LOCAL(el1_sync)
>         cmp     x0, #HVC_SET_VECTORS
> -       b.ne    2f
> +       b.ne    1f
>         msr     vbar_el2, x1
>         b       9f
>
> +1:     cmp     x0, #HVC_VHE_RESTART
> +       b.ne    2f
> +       mov     x0, #HVC_SOFT_RESTART
> +       adr     x1, mutate_to_vhe
> +       // fall through...
> +
>  2:     cmp     x0, #HVC_SOFT_RESTART
>         b.ne    3f
>         mov     x0, x2
> @@ -70,6 +76,66 @@ SYM_CODE_START_LOCAL(el1_sync)
>         eret
>  SYM_CODE_END(el1_sync)
>
> +// nVHE? No way! Give me the real thing!
> +SYM_CODE_START_LOCAL(mutate_to_vhe)
> +       // Sanity check: MMU *must* be off
> +       mrs     x0, sctlr_el2
> +       tbnz    x0, #0, 1f
> +
> +       // Needs to be VHE capable, obviously
> +       mrs     x0, id_aa64mmfr1_el1
> +       ubfx    x0, x0, #ID_AA64MMFR1_VHE_SHIFT, #4
> +       cbz     x0, 1f
> +
> +       // Engage the VHE magic!
> +       mov_q   x0, HCR_HOST_VHE_FLAGS
> +       msr     hcr_el2, x0
> +       isb
> +
> +       // Doesn't do much on VHE, but still, worth a shot
> +       init_el2_state vhe
> +
> +       // Use the EL1 allocated stack, per-cpu offset
> +       mrs     x0, sp_el1
> +       mov     sp, x0
> +       mrs     x0, tpidr_el1
> +       msr     tpidr_el2, x0
> +
> +       // FP configuration, vectors
> +       mrs_s   x0, SYS_CPACR_EL12
> +       msr     cpacr_el1, x0
> +       mrs_s   x0, SYS_VBAR_EL12
> +       msr     vbar_el1, x0
> +
> +       // Transfert the MM state from EL1 to EL2

Transfert, typo?

> +       mrs_s   x0, SYS_TCR_EL12
> +       msr     tcr_el1, x0
> +       mrs_s   x0, SYS_TTBR0_EL12
> +       msr     ttbr0_el1, x0
> +       mrs_s   x0, SYS_TTBR1_EL12
> +       msr     ttbr1_el1, x0
> +       mrs_s   x0, SYS_MAIR_EL12
> +       msr     mair_el1, x0
> +       isb
> +
> +       // Invalidate TLBs before enabling the MMU
> +       tlbi    vmalle1
> +       dsb     nsh
> +
> +       // Enable the EL2 S1 MMU, as set up from EL1
> +       mrs_s   x0, SYS_SCTLR_EL12
> +       set_sctlr_el1   x0
> +
> +       // Hack the exception return to stay at EL2
> +       mrs     x0, spsr_el1
> +       and     x0, x0, #~PSR_MODE_MASK
> +       mov     x1, #PSR_MODE_EL2h
> +       orr     x0, x0, x1
> +       msr     spsr_el1, x0
> +
> +1:     eret
> +SYM_CODE_END(mutate_to_vhe)
> +
>  .macro invalid_vector  label
>  SYM_CODE_START_LOCAL(\label)
>         b \label
> --
> 2.29.2
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
