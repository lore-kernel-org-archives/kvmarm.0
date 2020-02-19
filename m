Return-Path: <SRS0=1n5P=4H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E480C34047
	for <kvmarm@archiver.kernel.org>; Wed, 19 Feb 2020 13:53:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B087F2176D
	for <kvmarm@archiver.kernel.org>; Wed, 19 Feb 2020 13:53:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=agner.ch header.i=@agner.ch header.b="v7bnLInY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B087F2176D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=agner.ch
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 11E924A528;
	Wed, 19 Feb 2020 08:53:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@agner.ch
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id R4uXyFWQOsD0; Wed, 19 Feb 2020 08:53:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C9494ACBE;
	Wed, 19 Feb 2020 08:53:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E94F4A51F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Feb 2020 08:53:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SwIqa0wZ4K5w for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Feb 2020 08:53:34 -0500 (EST)
Received: from mail.kmu-office.ch (mail.kmu-office.ch [178.209.48.109])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8ACAE4A4FF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Feb 2020 08:53:34 -0500 (EST)
Received: from webmail.kmu-office.ch (unknown [IPv6:2a02:418:6a02::a3])
 by mail.kmu-office.ch (Postfix) with ESMTPSA id BCFA25C4EA4;
 Wed, 19 Feb 2020 14:53:32 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=agner.ch; s=dkim;
 t=1582120412;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=584CG7iV8fP/g0uoqGFCOFV1KmVRFzk005+5LCc+GNE=;
 b=v7bnLInYHzR7HlgS/jkPQ1zoPX1Zto/O0QTrCToF9nd44H+EiGKqZnQ5zYGGYvFvVytEzh
 TeyHfp/ZV3fYGEa9vhIZtLPF2IZtILdUE+fFkNnVsaV3Fou/bQViT0gN3EWVVUymAmgvvB
 /C2F7WFrsCH3J+1gGL4+2DMAMglkDO0=
MIME-Version: 1.0
Date: Wed, 19 Feb 2020 14:53:32 +0100
From: Stefan Agner <stefan@agner.ch>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [RFC PATCH 0/5] Removing support for 32bit KVM/arm host
In-Reply-To: <20200210141324.21090-1-maz@kernel.org>
References: <20200210141324.21090-1-maz@kernel.org>
User-Agent: Roundcube Webmail/1.4.1
Message-ID: <69845f739bbd91e73cd82e7c4683ab5a@agner.ch>
X-Sender: stefan@agner.ch
Cc: Anders Berg <anders.berg@lsi.com>, Russell King <linux@arm.linux.org.uk>,
 Arnd Bergmann <arnd@arndb.de>, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
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

On 2020-02-10 15:13, Marc Zyngier wrote:
> KVM/arm was merged just over 7 years ago, and has lived a very quiet
> life so far. It mostly works if you're prepared to deal with its
> limitations, it has been a good prototype for the arm64 version,
> but it suffers a few problems:
> 
> - It is incomplete (no debug support, no PMU)
> - It hasn't followed any of the architectural evolutions
> - It has zero users (I don't count myself here)
> - It is more and more getting in the way of new arm64 developments
> 
> So here it is: unless someone screams and shows that they rely on
> KVM/arm to be maintained upsteam, I'll remove 32bit host support
> form the tree. One of the reasons that makes me confident nobody is
> using it is that I never receive *any* bug report. Yes, it is perfect.

Not entirely true:
https://lore.kernel.org/m/e2f7196ca6c70c55463a45b490f6731a@agner.ch

But, after that was fixed, it actually was perfect :-D
https://blog.printk.io/2016/09/kvm-with-kvmtool-on-armv7/

That said, I never used it in a real-world application, so from my side
removing it is fine.

--
Stefan

> But if you depend on KVM/arm being available in mainline, please shout.
> 
> To reiterate: 32bit guest support for arm64 stays, of course. Only
> 32bit host goes. Once this is merged, I plan to move virt/kvm/arm to
> arm64, and cleanup all the now unnecessary abstractions.
> 
> The patches have been generated with the -D option to avoid spamming
> everyone with huge diffs, and there is a kvm-arm/goodbye branch in
> my kernel.org repository.
> 
> Marc Zyngier (5):
>   arm: Unplug KVM from the build system
>   arm: Remove KVM from config files
>   arm: Remove 32bit KVM host support
>   arm: Remove HYP/Stage-2 page-table support
>   arm: Remove GICv3 vgic compatibility macros
> 
>  Documentation/virt/kvm/arm/hyp-abi.txt |    5 +
>  arch/arm/Kconfig                       |    2 -
>  arch/arm/Makefile                      |    1 -
>  arch/arm/configs/axm55xx_defconfig     |    2 -
>  arch/arm/include/asm/arch_gicv3.h      |  114 --
>  arch/arm/include/asm/kvm_arm.h         |  239 ----
>  arch/arm/include/asm/kvm_asm.h         |   77 --
>  arch/arm/include/asm/kvm_coproc.h      |   36 -
>  arch/arm/include/asm/kvm_emulate.h     |  372 ------
>  arch/arm/include/asm/kvm_host.h        |  459 --------
>  arch/arm/include/asm/kvm_hyp.h         |  127 ---
>  arch/arm/include/asm/kvm_mmu.h         |  435 -------
>  arch/arm/include/asm/kvm_ras.h         |   14 -
>  arch/arm/include/asm/pgtable-3level.h  |   20 -
>  arch/arm/include/asm/pgtable.h         |    9 -
>  arch/arm/include/asm/sections.h        |    6 +-
>  arch/arm/include/asm/stage2_pgtable.h  |   75 --
>  arch/arm/include/asm/virt.h            |   12 -
>  arch/arm/include/uapi/asm/kvm.h        |  314 -----
>  arch/arm/kernel/asm-offsets.c          |   11 -
>  arch/arm/kernel/vmlinux-xip.lds.S      |    8 -
>  arch/arm/kernel/vmlinux.lds.S          |    8 -
>  arch/arm/kernel/vmlinux.lds.h          |   10 -
>  arch/arm/kvm/Kconfig                   |   59 -
>  arch/arm/kvm/Makefile                  |   43 -
>  arch/arm/kvm/coproc.c                  | 1455 ------------------------
>  arch/arm/kvm/coproc.h                  |  130 ---
>  arch/arm/kvm/coproc_a15.c              |   39 -
>  arch/arm/kvm/coproc_a7.c               |   42 -
>  arch/arm/kvm/emulate.c                 |  166 ---
>  arch/arm/kvm/guest.c                   |  387 -------
>  arch/arm/kvm/handle_exit.c             |  175 ---
>  arch/arm/kvm/hyp/Makefile              |   34 -
>  arch/arm/kvm/hyp/banked-sr.c           |   70 --
>  arch/arm/kvm/hyp/cp15-sr.c             |   72 --
>  arch/arm/kvm/hyp/entry.S               |  121 --
>  arch/arm/kvm/hyp/hyp-entry.S           |  295 -----
>  arch/arm/kvm/hyp/s2-setup.c            |   22 -
>  arch/arm/kvm/hyp/switch.c              |  242 ----
>  arch/arm/kvm/hyp/tlb.c                 |   68 --
>  arch/arm/kvm/hyp/vfp.S                 |   57 -
>  arch/arm/kvm/init.S                    |  157 ---
>  arch/arm/kvm/interrupts.S              |   36 -
>  arch/arm/kvm/irq.h                     |   16 -
>  arch/arm/kvm/reset.c                   |   86 --
>  arch/arm/kvm/trace.h                   |   86 --
>  arch/arm/kvm/vgic-v3-coproc.c          |   27 -
>  arch/arm/mach-exynos/Kconfig           |    2 +-
>  arch/arm/mm/mmu.c                      |   26 -
>  49 files changed, 7 insertions(+), 6262 deletions(-)
>  delete mode 100644 arch/arm/include/asm/kvm_arm.h
>  delete mode 100644 arch/arm/include/asm/kvm_asm.h
>  delete mode 100644 arch/arm/include/asm/kvm_coproc.h
>  delete mode 100644 arch/arm/include/asm/kvm_emulate.h
>  delete mode 100644 arch/arm/include/asm/kvm_host.h
>  delete mode 100644 arch/arm/include/asm/kvm_hyp.h
>  delete mode 100644 arch/arm/include/asm/kvm_mmu.h
>  delete mode 100644 arch/arm/include/asm/kvm_ras.h
>  delete mode 100644 arch/arm/include/asm/stage2_pgtable.h
>  delete mode 100644 arch/arm/include/uapi/asm/kvm.h
>  delete mode 100644 arch/arm/kvm/Kconfig
>  delete mode 100644 arch/arm/kvm/Makefile
>  delete mode 100644 arch/arm/kvm/coproc.c
>  delete mode 100644 arch/arm/kvm/coproc.h
>  delete mode 100644 arch/arm/kvm/coproc_a15.c
>  delete mode 100644 arch/arm/kvm/coproc_a7.c
>  delete mode 100644 arch/arm/kvm/emulate.c
>  delete mode 100644 arch/arm/kvm/guest.c
>  delete mode 100644 arch/arm/kvm/handle_exit.c
>  delete mode 100644 arch/arm/kvm/hyp/Makefile
>  delete mode 100644 arch/arm/kvm/hyp/banked-sr.c
>  delete mode 100644 arch/arm/kvm/hyp/cp15-sr.c
>  delete mode 100644 arch/arm/kvm/hyp/entry.S
>  delete mode 100644 arch/arm/kvm/hyp/hyp-entry.S
>  delete mode 100644 arch/arm/kvm/hyp/s2-setup.c
>  delete mode 100644 arch/arm/kvm/hyp/switch.c
>  delete mode 100644 arch/arm/kvm/hyp/tlb.c
>  delete mode 100644 arch/arm/kvm/hyp/vfp.S
>  delete mode 100644 arch/arm/kvm/init.S
>  delete mode 100644 arch/arm/kvm/interrupts.S
>  delete mode 100644 arch/arm/kvm/irq.h
>  delete mode 100644 arch/arm/kvm/reset.c
>  delete mode 100644 arch/arm/kvm/trace.h
>  delete mode 100644 arch/arm/kvm/vgic-v3-coproc.c
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
