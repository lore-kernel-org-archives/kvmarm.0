Return-Path: <SRS0=YGC0=PG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B29FC433F5
	for <kvmarm@archiver.kernel.org>; Mon, 18 Oct 2021 09:52:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BFB16610E7
	for <kvmarm@archiver.kernel.org>; Mon, 18 Oct 2021 09:52:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BFB16610E7
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FC624B275;
	Mon, 18 Oct 2021 05:52:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id c6hiw2cmPduT; Mon, 18 Oct 2021 05:52:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB62D4B279;
	Mon, 18 Oct 2021 05:52:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 08E894B277
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Oct 2021 05:52:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HlU8Pi77tt8y for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Oct 2021 05:52:30 -0400 (EDT)
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com
 [209.85.210.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C07854B275
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Oct 2021 05:52:30 -0400 (EDT)
Received: by mail-ot1-f51.google.com with SMTP id
 p6-20020a9d7446000000b0054e6bb223f3so1949161otk.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Oct 2021 02:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=hIvrEUDH4eO0WYJ4PqJYB49yqlYXOG/SemvYMWXPzyU=;
 b=HIxagS8WVeBE+G0ajyTJaAZdzxBaPmgZ+XMi01ATbiVxu+clkd0Bz18OdiZgOtmSD7
 cHkARs/25XkG6o5e2c5DYFpyeaqzpJ3hll/HXce3Zu+fzjAeDhEViSGG4n5NSu4VHpAK
 kS41yZx1OWhbnZ1oGLTCOZHDQ00vJhfZHwHWhRMjo3YFLUJEM24PXUzLAX6KNtWcIPKg
 B1VtBf8zTh4/BhuO5HZvNuApQUkbwcU+Ue+KFPtlZw9GlLYGan4W2ve8Ba/SPRQx8JG7
 caFgv+79cmRM2Pn7v2/wVRS7kEIEvYZ52lrDPI49WkHCp7njfE0tuIJeypQH+BR57BrF
 JN1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=hIvrEUDH4eO0WYJ4PqJYB49yqlYXOG/SemvYMWXPzyU=;
 b=BODB0pCymt4rvd0vHN21jtCCNM8to3fgtB7xAPwp9ddKxicCUUtXDJsyIjd+jIhoGn
 PkOs5gAtruv1VoBnHbDk3k9c+3oDYRXAUFZ/9G6zuJa9OMP2bEb/jToVC/rBnCmoC+Y7
 MofC5qxqvXw67EXZKXwIQ1xOqMqYXceLkSP5Vw96RshjBzNjChpXrKaazLbZgoqmgphY
 PqhXBbV6N+Rk6oJfUMYk/kzECVZNYKR94Lw6yNQMiDK/yJ7n3OVT4JXubjMSkfW7NTnv
 gsE5t8NWzaunsi5qN4EQ90MpIXRjWtRDMTnvf30L0/y06QDxuYGEB7wVXpsUBXo71Ung
 GDQg==
X-Gm-Message-State: AOAM531pm75Z1POVEuUhcWVopIOEo3lQ//vhUmnbIwdv80/rVwcJbPf7
 0FRv8PD2PlNCBqfTMFp6zwA22ZYYKhhamFZLTxOdWg==
X-Google-Smtp-Source: ABdhPJzWZHsVsaIL9xeEZSzoCxSaBPHvIjAdCQFyH94KbtFqpNnFfKiOBxLaRi9JpKRLWzlcKnSs/4ctWMJp6q2c9Cg=
X-Received: by 2002:a05:6830:210c:: with SMTP id
 i12mr20576774otc.102.1634550749852; 
 Mon, 18 Oct 2021 02:52:29 -0700 (PDT)
MIME-Version: 1.0
References: <20211010145636.1950948-12-tabba@google.com>
 <20211013120346.2926621-1-maz@kernel.org>
In-Reply-To: <20211013120346.2926621-1-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 18 Oct 2021 10:51:54 +0100
Message-ID: <CA+EHjTxBW2fzSk5wMLceRwExqJwXGTtrK1GZ2L6J-Oh9VCDJJg@mail.gmail.com>
Subject: Re: [PATCH v9 00/22] KVM: arm64: Fixed features for protected VMs
To: Marc Zyngier <maz@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org, pbonzini@redhat.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Hi Marc,

On Wed, Oct 13, 2021 at 1:04 PM Marc Zyngier <maz@kernel.org> wrote:
>
> This is an update on Fuad's series[1].
>
> Instead of going going back and forth over a series that has seen a
> fair few versions, I've opted for simply writing a set of fixes on
> top, hopefully greatly simplifying the handling of most registers, and
> moving things around to suit my own taste (just because I can).
>
> I won't be reposting the initial 11 patches, which is why this series
> in is reply to patch 11.

Thanks for this series. I've reviewed, built it, and tested it with a
dummy protected VM (since we don't have proper protected VMs yet),
which initializes some of the relevant protected VMs metadata as well
as its control registers. So fwiw:

Reviewed-by: Fuad Tabba <tabba@google.com>

And to whatever extent possible at this stage:
Tested-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad





> Thanks,
>
>         M.
>
> [1] https://lore.kernel.org/r/20211010145636.1950948-1-tabba@google.com
>
> Fuad Tabba (8):
>   KVM: arm64: Pass struct kvm to per-EC handlers
>   KVM: arm64: Add missing field descriptor for MDCR_EL2
>   KVM: arm64: Simplify masking out MTE in feature id reg
>   KVM: arm64: Add handlers for protected VM System Registers
>   KVM: arm64: Initialize trap registers for protected VMs
>   KVM: arm64: Move sanitized copies of CPU features
>   KVM: arm64: Trap access to pVM restricted features
>   KVM: arm64: Handle protected guests at 32 bits
>
> Marc Zyngier (14):
>   KVM: arm64: Move __get_fault_info() and co into their own include file
>   KVM: arm64: Don't include switch.h into nvhe/kvm-main.c
>   KVM: arm64: Move early handlers to per-EC handlers
>   KVM: arm64: Fix early exit ptrauth handling
>   KVM: arm64: pkvm: Use a single function to expose all id-regs
>   KVM: arm64: pkvm: Make the ERR/ERX*_EL1 registers RAZ/WI
>   KVM: arm64: pkvm: Drop AArch32-specific registers
>   KVM: arm64: pkvm: Drop sysregs that should never be routed to the host
>   KVM: arm64: pkvm: Handle GICv3 traps as required
>   KVM: arm64: pkvm: Preserve pending SError on exit from AArch32
>   KVM: arm64: pkvm: Consolidate include files
>   KVM: arm64: pkvm: Move kvm_handle_pvm_restricted around
>   KVM: arm64: pkvm: Pass vpcu instead of kvm to
>     kvm_get_exit_handler_array()
>   KVM: arm64: pkvm: Give priority to standard traps over pvm handling
>
>  arch/arm64/include/asm/kvm_arm.h              |   1 +
>  arch/arm64/include/asm/kvm_asm.h              |   1 +
>  arch/arm64/include/asm/kvm_host.h             |   2 +
>  arch/arm64/include/asm/kvm_hyp.h              |   5 +
>  arch/arm64/kvm/arm.c                          |  13 +
>  arch/arm64/kvm/hyp/include/hyp/fault.h        |  75 +++
>  arch/arm64/kvm/hyp/include/hyp/switch.h       | 235 ++++-----
>  .../arm64/kvm/hyp/include/nvhe/fixed_config.h | 200 +++++++
>  .../arm64/kvm/hyp/include/nvhe/trap_handler.h |   2 +
>  arch/arm64/kvm/hyp/nvhe/Makefile              |   2 +-
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  11 +-
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         |   8 +-
>  arch/arm64/kvm/hyp/nvhe/pkvm.c                | 185 +++++++
>  arch/arm64/kvm/hyp/nvhe/setup.c               |   3 +
>  arch/arm64/kvm/hyp/nvhe/switch.c              |  99 ++++
>  arch/arm64/kvm/hyp/nvhe/sys_regs.c            | 487 ++++++++++++++++++
>  arch/arm64/kvm/hyp/vhe/switch.c               |  16 +
>  arch/arm64/kvm/sys_regs.c                     |  10 +-
>  18 files changed, 1200 insertions(+), 155 deletions(-)
>  create mode 100644 arch/arm64/kvm/hyp/include/hyp/fault.h
>  create mode 100644 arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
>  create mode 100644 arch/arm64/kvm/hyp/nvhe/pkvm.c
>  create mode 100644 arch/arm64/kvm/hyp/nvhe/sys_regs.c
>
> --
> 2.30.2
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
