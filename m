Return-Path: <SRS0=c5RA=B6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76B13C433E1
	for <kvmarm@archiver.kernel.org>; Thu, 20 Aug 2020 10:35:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EE95020658
	for <kvmarm@archiver.kernel.org>; Thu, 20 Aug 2020 10:35:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="k5APOp+X"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EE95020658
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B5024B83E;
	Thu, 20 Aug 2020 06:35:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LnBsMfjilI2c; Thu, 20 Aug 2020 06:35:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2359A4B865;
	Thu, 20 Aug 2020 06:35:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DDB514B83F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 06:35:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pt7ka+yWg53C for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Aug 2020 06:35:21 -0400 (EDT)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8F3D64B24C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 06:35:21 -0400 (EDT)
Received: by mail-wm1-f73.google.com with SMTP id h6so804869wml.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Aug 2020 03:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:message-id:mime-version:subject:from:to:cc;
 bh=roKza3OkfK9qcZNG3qmxeeQQHwHPlHxDLrwJREVN+jY=;
 b=k5APOp+X7954cRuBlSgSvvTmDsVBfbcBplTzg0SSnPyEE7dhYFN+VdiJCSQPR+07cb
 Nvbkt1+THK1iVcQnp3K+uGDSRpAZfc+RRw9BYjkTQ49/CplNabTPHPn0xG+Vzuvl8MNh
 51NyxISNS0jYK9hgiOxqYFAIm4s4myZbu8QMBaM8k5Ob6leNVrSmP3WwYgw1kUx8kDsZ
 u4ORCB6SmLiWfDERaQVbOAyMpvYVw5gsAi/K/Y7WIoGoAxMbOo4wYBClpa0q/3rPhNiZ
 cJAfd/SqzB4ab6E+XkdFv/0zAp+GjorHTMFy0H3XS6K2mYu8oQmw/zvKA5MruFz4Jzyx
 K5gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
 :to:cc;
 bh=roKza3OkfK9qcZNG3qmxeeQQHwHPlHxDLrwJREVN+jY=;
 b=reaDWqL2z4BmTTXCqgXzZADnM5h3LQoeRb9u3AU6DWFJNtzRImYkA1ufvx6+Pockvw
 sGT81iBj9M9G/Fr22qHOjLQaUHtkLQKMgpUsHS0AgFgT23gHSH694gT05oBpoeTXCqrA
 tP4lIYg8rE740HQ0L/cMIpkGmQXEl/ASTEQLqk48X5RG7IP/ZJf/XISrp3IUTCD/ZnQD
 ENqu7tIk9ps07A1b+qFVBor6dDgLO3GiAW5TKjPf77ODfPMREBg+ghBY8LtZt4OrpdLw
 3HNcY16W2vsZr5T6o1JdUWBFU6dupniE5lDEmHSj0RH1lKMGCIqtXTaQONnuItbi6UCz
 7bZA==
X-Gm-Message-State: AOAM530izZif9beimK1mCbUt6OgNTKrGj28QBW3qG5YKL+aNX2TCOZcc
 bTBOQHFaixFz68Y2WkOXExHSVf9biLlSpyyvy1Pq+y75rF9zczA4b9G1yHS0KJvmZ6vfCjnV8xw
 DMi9RbmhAmllxCNOyY3RD4OGkq/Vx43BBhOJw8ETjtfWkHXgbR1MS0xHLWOPtXSVAopEdFA==
X-Google-Smtp-Source: ABdhPJzkMIHwFjPe2Er10blaW+o9uH+JH+Lopx4PDaqRilCeGhqNxB96dpkqGuO/lQKfISkrAI9EW3U0pFY=
X-Received: from ascull.lon.corp.google.com
 ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 (user=ascull job=sendgmr) by 2002:a7b:c20a:: with SMTP id
 x10mr2435124wmi.78.1597919720187; 
 Thu, 20 Aug 2020 03:35:20 -0700 (PDT)
Date: Thu, 20 Aug 2020 11:34:26 +0100
Message-Id: <20200820103446.959000-1-ascull@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH v2 00/20] Introduce separate nVHE hyp context
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 maz@kernel.org, Sudeep Holla <sudeep.holla@arm.com>, catalin.marinas@arm.com,
 will@kernel.org
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

As a step on the way to isolating hyp from the host on nVHE as part of
Android's "Protected KVM" project, this series introduces a separate
register context for hyp visiting these topics on the way:

 - RAS for nVHE
 - Panicking from guest vectors with SCS
 - Switching to hyp context
 - Migration hyp interface off of function pointers

After four small refactors, focus turns to adding a new exception vector
for the nVHE hyp to use with the host. With this new freedom, the
erroneous consumption of the host's RAS errors by nVHE is corrected.

Following this, attention turns to fixing hyp panics from the guest
context, e.g. an invalid vector, so they have a chance of completely
cleanly with features such as shadow call stack (SCS) enabled on VHE.

Then, hyp is made to switch to its own context rather than borrowing the
host context before migrating the hyp interface from raw function
pointers to SMCCC based functions IDs.

This series is based on v5.8-rc1 and has been tested on a VIM 3L.

From v1:
 - https://lore.kernel.org/kvmarm/20200715184438.1390996-1-ascull@google.com/
 - HVC microbenchmark overhead cut from over 15% to under 6%.
 - Abandon the symmetry of a run loop in hyp and treating the host as a
   vCPU as there was little practical benefit for the overhead it
   introduced.

Cc: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Suzuki Poulose <suzuki.poulose@arm.com>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: kernel-team@android.com
Cc: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org

Andrew Scull (20):
  KVM: arm64: Remove __activate_vm wrapper
  KVM: arm64: Remove hyp_panic arguments
  KVM: arm64: Remove kvm_host_data_t typedef
  KVM: arm64: Restrict symbol aliasing to outside nVHE
  KVM: arm64: Save chosen hyp vector to a percpu variable
  KVM: arm64: nVHE: Use separate vector for the host
  KVM: arm64: nVHE: Don't consume host SErrors with ESB
  KVM: arm64: Preserve host DISR_EL1
  KVM: arm64: Introduce hyp context
  KVM: arm64: Update context references from host to hyp
  KVM: arm64: Restore hyp when panicking in guest context
  KVM: arm64: Share context save and restore macros
  KVM: arm64: nVHE: Switch to hyp context for EL2
  KVM: arm64: nVHE: Handle hyp panics
  smccc: Cast arguments to unsigned long
  KVM: arm64: nVHE: Pass pointers consistently to hyp-init
  KVM: arm64: nVHE: Migrate hyp interface to SMCCC
  KVM: arm64: nVHE: Migrate hyp-init to SMCCC
  KVM: arm64: nVHE: Fix pointers during SMCCC convertion
  KVM: arm64: nVHE: Handle stub HVCs in the host loop

 arch/arm64/include/asm/kvm_asm.h           |  78 ++++++++++
 arch/arm64/include/asm/kvm_host.h          |  26 ++--
 arch/arm64/include/asm/kvm_hyp.h           |   9 +-
 arch/arm64/include/asm/kvm_ptrauth.h       |   6 +-
 arch/arm64/kernel/image-vars.h             |   2 +
 arch/arm64/kvm/Makefile                    |   2 +-
 arch/arm64/kvm/arm.c                       |  34 +++-
 arch/arm64/kvm/hyp.S                       |  34 ----
 arch/arm64/kvm/hyp/entry.S                 |  95 +++++-------
 arch/arm64/kvm/hyp/hyp-entry.S             |  83 +---------
 arch/arm64/kvm/hyp/include/hyp/switch.h    |   9 +-
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  16 +-
 arch/arm64/kvm/hyp/nvhe/Makefile           |   2 +-
 arch/arm64/kvm/hyp/nvhe/host.S             | 156 +++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/hyp-init.S         |  80 ++++++----
 arch/arm64/kvm/hyp/nvhe/hyp-main.c         | 171 +++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/switch.c           |  37 ++---
 arch/arm64/kvm/hyp/nvhe/tlb.c              |   2 -
 arch/arm64/kvm/hyp/vhe/switch.c            |  18 ++-
 arch/arm64/kvm/vgic/vgic-v3.c              |   4 +-
 include/linux/arm-smccc.h                  |  20 +--
 21 files changed, 606 insertions(+), 278 deletions(-)
 delete mode 100644 arch/arm64/kvm/hyp.S
 create mode 100644 arch/arm64/kvm/hyp/nvhe/host.S
 create mode 100644 arch/arm64/kvm/hyp/nvhe/hyp-main.c

-- 
2.28.0.220.ged08abb693-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
