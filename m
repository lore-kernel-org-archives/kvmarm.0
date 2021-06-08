Return-Path: <SRS0=ky3n=LC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F25A4C47082
	for <kvmarm@archiver.kernel.org>; Tue,  8 Jun 2021 14:11:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5A5FC61078
	for <kvmarm@archiver.kernel.org>; Tue,  8 Jun 2021 14:11:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5A5FC61078
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C649240821;
	Tue,  8 Jun 2021 10:11:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6WZBcPgwrXrC; Tue,  8 Jun 2021 10:11:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D86F40839;
	Tue,  8 Jun 2021 10:11:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DD4640821
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 10:11:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vp8rWEds0TTE for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Jun 2021 10:11:43 -0400 (EDT)
Received: from mail-qt1-f202.google.com (mail-qt1-f202.google.com
 [209.85.160.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E28174079A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 10:11:43 -0400 (EDT)
Received: by mail-qt1-f202.google.com with SMTP id
 l6-20020ac84cc60000b0290243ab0e481cso9300378qtv.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Jun 2021 07:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=o2JaYusrSX5g5l6Yw6yxi3k3vNOoBMCguurDm0+l8Ag=;
 b=QAjX942AbHdhVv90FgSKKOKWthZhg07ww0LE/PswekVtnTIQ+FEJC3UffROIlD8Dqi
 fgh7Goj+WeuL8mRRRjE52DgNtl7QgztYNbPPb0cOEJ+CJybjuGH9Gd9ixwLvGMl7nH2A
 3Y3RtoKefMrohU2jN69vuRDjlCUBPvqwXoSXadqIP6UedKXV3CjK1LWzxOW7054rNCu/
 Dfp4baoOS0c0Xu58yoVwOZcfObIcAmPltdBbwjfhmsECkZ7zyIKmlD8ZNtzugWw8qBKn
 r17DF1FsZGIYjr6hITFWPLZwkDBo2z6oJDJKy5UYQmvSawpSgxAYHsEzgtLugeh3Myjj
 WWUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=o2JaYusrSX5g5l6Yw6yxi3k3vNOoBMCguurDm0+l8Ag=;
 b=g9JRsI1RXID6Upgq1hB/9/AlcQj9IZIJe06XE/uhUEzbu1gE0Xp5EtMbxR8BhOvo1+
 xUMJ1c5TFZhCtxJP1TGTE3YM1Sp9W1oPfZ+n/gZFDEr4hxnA3ImF4vO3KI+rfdNtZQCF
 JmifkAFnKkJzb+wgBTY4HN88gxqUUm36OW9KoZviTYfxNFW0FSruYG7Ldl9Bz/h1u9BV
 qSCjeBhCLXHbW4RpXIV+OfyqYPvxzLwo8gglq/wtMhOA17a87l+4gvr3JStjzoLH6P6G
 rXmRpQ6XgzHsHMGq+wRqM4J6HUYkhFfa1YRk6DiWA93TMvC6YfjmDHvug61mnNY9sgRr
 d+dQ==
X-Gm-Message-State: AOAM533Vepu7Wk45WTiFAhd6TSpzjZCS9G3DPTN5I03Mjq9PXEI8vSr6
 MT1IDkJqDqYcuGJwGzov7MkNgOQXu/q4aX8aYbS/IiDR8k6WTapdFViq4AdODgC5Xq2/Y4lDbFT
 60MjVIFRbfRmc6sbPysInQ6eFzCE3hXsrWBoIvMmEfpE1ZMkRuM+Ryo/8zPs0mZ0f2Qw=
X-Google-Smtp-Source: ABdhPJxSM4ceufbESyUI9a+fBHervXps3fjSrrAiV4eM0G4Dpr1cL3+sY1800798HV5X0kp4wyrcUszRNw==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a0c:fa4a:: with SMTP id
 k10mr202563qvo.18.1623161503263; 
 Tue, 08 Jun 2021 07:11:43 -0700 (PDT)
Date: Tue,  8 Jun 2021 15:11:28 +0100
Message-Id: <20210608141141.997398-1-tabba@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH v1 00/13] KVM: arm64: Fixed features for protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, will@kernel.org, linux-arm-kernel@lists.infradead.org
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

This patch series adds support for restricting CPU features for protected VMs
in KVM [1].

Various feature configurations are allowed in KVM/arm64. Supporting all
these features in pKVM is difficult, as it either involves moving much of
the handling code to EL2, which adds bloat and results in a less verifiable
trusted code base. Or it involves leaving the code handling at EL1, which
risks having an untrusted host kernel feeding wrong information to the EL2
and to the protected guests.

This series attempts to mitigate this by reducing the configuration space,
providing a reduced amount of feature support at EL2 with the least amount of
compromise of protected guests' capabilities.

This is done by restricting CPU features exposed to protected guests through
feature registers. These restrictions are enforced by trapping register
accesses as well as instructions associated with these features, and injecting
an undefined exception into the guest if it attempts to use a restricted
feature.

The features being restricted (only for protected VMs in protected mode) are
the following:
- Debug, Trace, and DoubleLock
- Performance Monitoring (PMU)
- Statistical Profiling (SPE)
- Scalable Vector Extension (SVE)
- Memory Partitioning and Monitoring (MPAM)
- Activity Monitoring (AMU)
- Memory Tagging (MTE)
- Limited Ordering Regions (LOR)
- AArch32 State
- Generic Interrupt Controller (GIC) (depending on rVIC support)
- Nested Virtualization (NV)
- Reliability, Availability, and Serviceability (RAS) above V1
- Implementation-defined Features

This series is based on kvmarm/next and Will's patches for an Initial pKVM user
ABI [1]. You can find the applied series here [2].

Cheers,
/fuad

[1] https://lore.kernel.org/kvmarm/20210603183347.1695-1-will@kernel.org/

For more details about pKVM, please refer to Will's talk at KVM Forum 2020:
https://www.youtube.com/watch?v=edqJSzsDRxk

[2] https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/el2_fixed_feature_v1

To: kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Quentin Perret <qperret@google.com>
Cc: kvm@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: kernel-team@android.com

Fuad Tabba (13):
  KVM: arm64: Remove trailing whitespace in comments
  KVM: arm64: MDCR_EL2 is a 64-bit register
  KVM: arm64: Fix name of HCR_TACR to match the spec
  KVM: arm64: Refactor sys_regs.h,c for nVHE reuse
  KVM: arm64: Restore mdcr_el2 from vcpu
  KVM: arm64: Add feature register flag definitions
  KVM: arm64: Add config register bit definitions
  KVM: arm64: Guest exit handlers for nVHE hyp
  KVM: arm64: Add trap handlers for protected VMs
  KVM: arm64: Move sanitized copies of CPU features
  KVM: arm64: Trap access to pVM restricted features
  KVM: arm64: Handle protected guests at 32 bits
  KVM: arm64: Check vcpu features at pVM creation

 arch/arm64/include/asm/kvm_arm.h        |  34 +-
 arch/arm64/include/asm/kvm_asm.h        |   2 +-
 arch/arm64/include/asm/kvm_host.h       |   2 +-
 arch/arm64/include/asm/kvm_hyp.h        |   4 +
 arch/arm64/include/asm/sysreg.h         |   6 +
 arch/arm64/kvm/arm.c                    |   4 +
 arch/arm64/kvm/debug.c                  |   5 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h |  42 ++
 arch/arm64/kvm/hyp/nvhe/Makefile        |   2 +-
 arch/arm64/kvm/hyp/nvhe/debug-sr.c      |   2 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c   |   6 -
 arch/arm64/kvm/hyp/nvhe/switch.c        | 114 +++++-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c      | 501 ++++++++++++++++++++++++
 arch/arm64/kvm/hyp/vhe/debug-sr.c       |   2 +-
 arch/arm64/kvm/pkvm.c                   |  31 ++
 arch/arm64/kvm/sys_regs.c               |  62 +--
 arch/arm64/kvm/sys_regs.h               |  35 ++
 17 files changed, 782 insertions(+), 72 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/nvhe/sys_regs.c


base-commit: 35b256a5eebe3ac715b4ea6234aa4236a10d1a88
-- 
2.32.0.rc1.229.g3e70b5a671-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
