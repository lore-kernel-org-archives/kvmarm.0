Return-Path: <SRS0=W6Rg=6S=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F14DC3A5A9
	for <kvmarm@archiver.kernel.org>; Mon,  4 May 2020 15:30:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 939BA20721
	for <kvmarm@archiver.kernel.org>; Mon,  4 May 2020 15:30:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="c3BmQ69I"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 939BA20721
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 112274B3AD;
	Mon,  4 May 2020 11:30:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sbz0W-LDDckw; Mon,  4 May 2020 11:30:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B7D1A4B3A0;
	Mon,  4 May 2020 11:30:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 038634B39C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 May 2020 11:30:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 459y+yFWErpx for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 May 2020 11:30:25 -0400 (EDT)
Received: from mail-lf1-f65.google.com (mail-lf1-f65.google.com
 [209.85.167.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B800F4B398
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 May 2020 11:30:25 -0400 (EDT)
Received: by mail-lf1-f65.google.com with SMTP id w14so10150950lfk.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 May 2020 08:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=3yyP+pBHvYm04oD3CuxWG1i2qJqvZkMmw01FEu9xASc=;
 b=c3BmQ69IeQPWwPVXpILiunDEXB+CcL/YS9Ico2Hbywz3Kzb9WrRQ5mxBmxAh8MgOp6
 OZ9jzaZHNIJjU1+SYed9/qy9tdnYJD0daWf7O6DuvWVciZNNxFZjJOLd0sASUUXpp93/
 rWzj0D5hlUCdA3hse3bo8637as5dp4E6ceSG6Vkuwy4nFZDTLVh62sa+iaoDk537pMnK
 q720EEhpDyGAuJrgwQlJUSMYDAQcCIKwzjv3/vLf2VQa74NQdfxamaQyYxurgDRCpLZz
 v6jg7GDFO/+zK9hSjK4ndWiV7zX6HgeuzeVryNyxA0qt+toUqC8kLxyzwZN4Enh/KVEo
 mVJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=3yyP+pBHvYm04oD3CuxWG1i2qJqvZkMmw01FEu9xASc=;
 b=BSssu1fp+9TPoOl3NoWtNPluStJZPrjloeA8VEypSzQkS3dltnW79PU2lUf4pj3RJO
 BPhEbaXW/Y46Ea2HiWYfq5qcHULR0eiNG1bCPiRPZrFNGYD5e9PPdFCCmaVH2866+ZjL
 p2DdQsscRDfa/Jq8Cm/5rJmUmZSmagcm2amXCppuJhwU//jtXPNHeNljOun9qpdh8M/W
 C7CWfq1Cu8Y9r6uHn1eeMK6BhYV8KmNDlcFNd/RtdL6dTHPvTqD4kZkyTkp0tv3w3JYk
 DTxpRgagOIMXTqHwFDfAYBgcQ1jtarZH2Kd23QpuVlAnTTFvbJvW9WVocW+6/KOxTfR9
 dPxQ==
X-Gm-Message-State: AGi0PubLr1wKmXvauC8KksJBHqnnS93xRmYXZl3dxHpbx1KupSlBZ2rh
 2gAcM+gikFEVGQPLWqgs7k9u344+lwTDE7cmrEaByg==
X-Google-Smtp-Source: APiQypLVuZdY5mimrXwlwB2MBETiZoHjng3X8GaDc7ZMyt/wfrKlfiR/I9UveLK8NxU8gQxrVD7oKCzHHLfDrRgImbY=
X-Received: by 2002:a19:2282:: with SMTP id i124mr11950463lfi.98.1588606224129; 
 Mon, 04 May 2020 08:30:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200421131734.141766-1-tabba@google.com>
 <20200421131734.141766-5-tabba@google.com>
 <20200504132648.GA65651@google.com>
 <654f7d7260004e4959f0d0bd31800ac2@kernel.org>
In-Reply-To: <654f7d7260004e4959f0d0bd31800ac2@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 4 May 2020 16:29:48 +0100
Message-ID: <CA+EHjTwPgLMXB3GQtQcNEkq3pr1gDkXN66NCXwsqhxkMB_k6Lg@mail.gmail.com>
Subject: Re: [PATCH v4 4/4] KVM: arm64: Clean up kvm makefiles
To: Marc Zyngier <maz@kernel.org>
Cc: catalin.marinas@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu
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

Hi,


On Mon, May 4, 2020 at 4:27 PM Marc Zyngier <maz@kernel.org> wrote:
>
> Hi all,
>
> On 2020-05-04 14:26, Quentin Perret wrote:
> > Hi Fuad,
> >
> > On Tuesday 21 Apr 2020 at 14:17:34 (+0100), Fuad Tabba wrote:
> >> Consolidate references to the CONFIG_KVM configuration item to
> >> encompass
> >> entire folders rather than per line.
> >>
> >> Signed-off-by: Fuad Tabba <tabba@google.com>
> >> ---
> >>  arch/arm64/kvm/Makefile     | 40
> >> ++++++++++++-------------------------
> >>  arch/arm64/kvm/hyp/Makefile | 15 ++++----------
> >>  2 files changed, 17 insertions(+), 38 deletions(-)
> >>
> >> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> >> index 419696e615b3..5354ca1b1bfb 100644
> >> --- a/arch/arm64/kvm/Makefile
> >> +++ b/arch/arm64/kvm/Makefile
> >> @@ -10,30 +10,16 @@ KVM=../../../virt/kvm
> >>  obj-$(CONFIG_KVM) += kvm.o
> >>  obj-$(CONFIG_KVM) += hyp/
> >>
> >> -kvm-$(CONFIG_KVM) += $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o
> >> -kvm-$(CONFIG_KVM) += $(KVM)/eventfd.o $(KVM)/vfio.o $(KVM)/irqchip.o
> >> -kvm-$(CONFIG_KVM) += arm.o mmu.o mmio.o
> >> -kvm-$(CONFIG_KVM) += psci.o perf.o
> >> -kvm-$(CONFIG_KVM) += hypercalls.o
> >> -kvm-$(CONFIG_KVM) += pvtime.o
> >> -
> >> -kvm-$(CONFIG_KVM) += inject_fault.o regmap.o va_layout.o
> >> -kvm-$(CONFIG_KVM) += hyp.o hyp-init.o handle_exit.o
> >> -kvm-$(CONFIG_KVM) += guest.o debug.o reset.o sys_regs.o
> >> sys_regs_generic_v8.o
> >> -kvm-$(CONFIG_KVM) += vgic-sys-reg-v3.o fpsimd.o pmu.o
> >> -kvm-$(CONFIG_KVM) += aarch32.o
> >> -kvm-$(CONFIG_KVM) += arch_timer.o
> >> -kvm-$(CONFIG_KVM_ARM_PMU)  += pmu-emul.o
> >> -
> >> -kvm-$(CONFIG_KVM) += vgic/vgic.o
> >> -kvm-$(CONFIG_KVM) += vgic/vgic-init.o
> >> -kvm-$(CONFIG_KVM) += vgic/vgic-irqfd.o
> >> -kvm-$(CONFIG_KVM) += vgic/vgic-v2.o
> >> -kvm-$(CONFIG_KVM) += vgic/vgic-v3.o
> >> -kvm-$(CONFIG_KVM) += vgic/vgic-v4.o
> >> -kvm-$(CONFIG_KVM) += vgic/vgic-mmio.o
> >> -kvm-$(CONFIG_KVM) += vgic/vgic-mmio-v2.o
> >> -kvm-$(CONFIG_KVM) += vgic/vgic-mmio-v3.o
> >> -kvm-$(CONFIG_KVM) += vgic/vgic-kvm-device.o
> >> -kvm-$(CONFIG_KVM) += vgic/vgic-its.o
> >> -kvm-$(CONFIG_KVM) += vgic/vgic-debug.o
> >> +kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o \
> >> +     $(KVM)/vfio.o $(KVM)/irqchip.o \
> >> +     arm.o mmu.o mmio.o psci.o perf.o hypercalls.o pvtime.o \
> >> +     inject_fault.o regmap.o va_layout.o hyp.o hyp-init.o handle_exit.o
> >> \
> >> +     guest.o debug.o reset.o sys_regs.o sys_regs_generic_v8.o \
> >> +     vgic-sys-reg-v3.o fpsimd.o pmu.o pmu-emul.o \
> >
> > Should we keep pmu-emul.o conditional on CONFIG_KVM_ARM_PMU?
>
> Good point. KVM_ARM_PMU depends on HW_PERF_EVENTS, which depends
> on ARM_PMU. Without the above condition being present, you can
> try and build the kernel with the KVM PMU emulation, and not
> the host CPU PMU. It stops building very quickly.
>
> I guess we should clean this up now that 32 bit is gone. But
> for the sake of this series, it would be better to keep the
> dependency in place and sort out the PMU mess at a later stage.

Of course.  I will fix this and send out a new patch series.

Cheers,
/fuad
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
