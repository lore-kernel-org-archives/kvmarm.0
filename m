Return-Path: <SRS0=5TFS=PB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D761C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 13 Oct 2021 12:04:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9267460273
	for <kvmarm@archiver.kernel.org>; Wed, 13 Oct 2021 12:04:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9267460273
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4754A4B125;
	Wed, 13 Oct 2021 08:04:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IOdj9ZFaQcdl; Wed, 13 Oct 2021 08:04:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 27B594B12E;
	Wed, 13 Oct 2021 08:04:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 233294B0D9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 08:04:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id I-uRkL9VeYs1 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Oct 2021 08:04:01 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D614E4B0D7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 08:04:00 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id D519460EB4;
 Wed, 13 Oct 2021 12:03:59 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1maczF-00GTgY-Gq; Wed, 13 Oct 2021 13:03:57 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH v9 00/22] KVM: arm64: Fixed features for protected VMs
Date: Wed, 13 Oct 2021 13:03:35 +0100
Message-Id: <20211013120346.2926621-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211010145636.1950948-12-tabba@google.com>
References: <20211010145636.1950948-12-tabba@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, will@kernel.org, james.morse@arm.com,
 alexandru.elisei@arm.com, suzuki.poulose@arm.com, mark.rutland@arm.com,
 pbonzini@redhat.com, drjones@redhat.com, oupton@google.com, qperret@google.com,
 kernel-team@android.com, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, pbonzini@redhat.com, will@kernel.org
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

This is an update on Fuad's series[1].

Instead of going going back and forth over a series that has seen a
fair few versions, I've opted for simply writing a set of fixes on
top, hopefully greatly simplifying the handling of most registers, and
moving things around to suit my own taste (just because I can).

I won't be reposting the initial 11 patches, which is why this series
in is reply to patch 11.

Thanks,

	M.

[1] https://lore.kernel.org/r/20211010145636.1950948-1-tabba@google.com

Fuad Tabba (8):
  KVM: arm64: Pass struct kvm to per-EC handlers
  KVM: arm64: Add missing field descriptor for MDCR_EL2
  KVM: arm64: Simplify masking out MTE in feature id reg
  KVM: arm64: Add handlers for protected VM System Registers
  KVM: arm64: Initialize trap registers for protected VMs
  KVM: arm64: Move sanitized copies of CPU features
  KVM: arm64: Trap access to pVM restricted features
  KVM: arm64: Handle protected guests at 32 bits

Marc Zyngier (14):
  KVM: arm64: Move __get_fault_info() and co into their own include file
  KVM: arm64: Don't include switch.h into nvhe/kvm-main.c
  KVM: arm64: Move early handlers to per-EC handlers
  KVM: arm64: Fix early exit ptrauth handling
  KVM: arm64: pkvm: Use a single function to expose all id-regs
  KVM: arm64: pkvm: Make the ERR/ERX*_EL1 registers RAZ/WI
  KVM: arm64: pkvm: Drop AArch32-specific registers
  KVM: arm64: pkvm: Drop sysregs that should never be routed to the host
  KVM: arm64: pkvm: Handle GICv3 traps as required
  KVM: arm64: pkvm: Preserve pending SError on exit from AArch32
  KVM: arm64: pkvm: Consolidate include files
  KVM: arm64: pkvm: Move kvm_handle_pvm_restricted around
  KVM: arm64: pkvm: Pass vpcu instead of kvm to
    kvm_get_exit_handler_array()
  KVM: arm64: pkvm: Give priority to standard traps over pvm handling

 arch/arm64/include/asm/kvm_arm.h              |   1 +
 arch/arm64/include/asm/kvm_asm.h              |   1 +
 arch/arm64/include/asm/kvm_host.h             |   2 +
 arch/arm64/include/asm/kvm_hyp.h              |   5 +
 arch/arm64/kvm/arm.c                          |  13 +
 arch/arm64/kvm/hyp/include/hyp/fault.h        |  75 +++
 arch/arm64/kvm/hyp/include/hyp/switch.h       | 235 ++++-----
 .../arm64/kvm/hyp/include/nvhe/fixed_config.h | 200 +++++++
 .../arm64/kvm/hyp/include/nvhe/trap_handler.h |   2 +
 arch/arm64/kvm/hyp/nvhe/Makefile              |   2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  11 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         |   8 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                | 185 +++++++
 arch/arm64/kvm/hyp/nvhe/setup.c               |   3 +
 arch/arm64/kvm/hyp/nvhe/switch.c              |  99 ++++
 arch/arm64/kvm/hyp/nvhe/sys_regs.c            | 487 ++++++++++++++++++
 arch/arm64/kvm/hyp/vhe/switch.c               |  16 +
 arch/arm64/kvm/sys_regs.c                     |  10 +-
 18 files changed, 1200 insertions(+), 155 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/include/hyp/fault.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/pkvm.c
 create mode 100644 arch/arm64/kvm/hyp/nvhe/sys_regs.c

-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
