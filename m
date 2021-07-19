Return-Path: <SRS0=FmU0=ML=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A891AC07E95
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 16:03:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1ED3461469
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 16:03:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1ED3461469
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9ECEE4A4E5;
	Mon, 19 Jul 2021 12:03:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id f3ZbLMutQj8o; Mon, 19 Jul 2021 12:03:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 636964A319;
	Mon, 19 Jul 2021 12:03:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B99FA49FB7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 12:03:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4jckFeJ9c+9y for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Jul 2021 12:03:49 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3F52340667
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 12:03:49 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id
 c22-20020a0ca9d60000b02902e60d75210eso15572410qvb.19
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 09:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=X3IdqzKtSdKmEHqu0gSKjOdvCta/WPAlxOlzNq5U9KI=;
 b=uIH6aFAEogBPjp3JnJ8pNTafadhbYdKOoTiFg87snBwSlO47nkKZDDP+0OgB23SsPL
 pYWETb0wm0ULN8PK5q0FWytbFLfdGggAjYKU5gxU5joDMl09vDKWz3a12uCby8wabOJD
 Sohhdf4JtNvB5/Zc0yoOKHLeKVOxr5nbmtux2Aj4cN1eWopNkVAacAnCsEiWUXQ9UGP/
 yKoGei+fcSWgZrKVqzWWZKGh1m0xsx46brxd4R6EAaVVn+Mdxrf9llPIzADcvJ8r8ahH
 v+eATGrXiMuzHkQHUOAOfOIdacdGXDQLYHt5pGRvRSMaBQHGSFjE6vNg6pxkHqWmB5Q4
 N4Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=X3IdqzKtSdKmEHqu0gSKjOdvCta/WPAlxOlzNq5U9KI=;
 b=bpTJrw1teq2J6XIMmDFEkYRlzDTlu6/e0QaESPmrPT9wPAvm2U9akFW89xzWE8op5I
 k0PS2eJknkr5yo9v524A2zdK9Mc9d3il6hJdHMaOE2pEdlvramM9xJ9eEyllvnlQUQcV
 xJwJyKDkqVVSQcGzF2NBBv9YohFGjnPc2ytC3nGHu8i8pqZ/rqYe1np6pCboKI1KQ5Vk
 fIPooziZDRKYmt8sOhAmjAh1y2dhmV9PmYavUdnosDo5X3m911RI4LLqMar/jXCzGNre
 ct7ESvHeXRgxrhQ/et2kMaSWaX946KrpbKdY6Sw7hiMHdpDu9u+bw08wjGzYAW4oPw4f
 k86A==
X-Gm-Message-State: AOAM531syQm1cVYjnuXk+h3wLpHRXFfZ6G88FEtEQErj73ETmE/K3MFn
 +a090xVQbe3eY/w1Wi9vs/GOHPxWGQ7/vLvZQBaGOtaXITcbBfLO3DHQ51luAaTNJq3+doZtcbp
 AyilUhVipXjS7VYvb3KufmVYC/tb0MaAYaKztJeeE7a4touKpDl96gQG4f7fmjInWlr8=
X-Google-Smtp-Source: ABdhPJxAOglNWseu0wn6j1VK16OzeLqCOGgMEktN+EBmxudy9HH20JMPvsgut3x+BTUFeB3mBdJqAyMDUQ==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:6214:29e9:: with SMTP id
 jv9mr25278307qvb.18.1626710628711; Mon, 19 Jul 2021 09:03:48 -0700 (PDT)
Date: Mon, 19 Jul 2021 17:03:31 +0100
Message-Id: <20210719160346.609914-1-tabba@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v3 00/15] KVM: arm64: Fixed features for protected VMs
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

Changes since v2 [1]:
- Both trapping and setting of feature id registers are toggled by an allowed
  features bitmap of the feature id registers (Will)
- Documentation explaining the rationale behind allowed/blocked features (Drew)
- Restrict protected VM features by checking and restricting VM capabilities
- Misc small fixes and tidying up (mostly Will)
- Remove dependency on Will's protected VM user ABI series [2]
- Rebase on 5.14-rc2
- Carried Will's acks

Changes since v1 [3]:
- Restrict protected VM features based on an allowed features rather than
  rejected ones (Drew)
- Add more background describing protected KVM to the cover letter (Alex)

This patch series adds support for restricting CPU features for protected VMs
in KVM (pKVM) [4].

Various VM feature configurations are allowed in KVM/arm64, each requiring
specific handling logic to deal with traps, context-switching and potentially
emulation. Achieving feature parity in pKVM therefore requires either elevating
this logic to EL2 (and substantially increasing the TCB) or continuing to trust
the host handlers at EL1. Since neither of these options are especially
appealing, pKVM instead limits the CPU features exposed to a guest to a fixed
configuration based on the underlying hardware and which can mostly be provided
straightforwardly by EL2.

This series approaches that by restricting CPU features exposed to protected
guests. Features advertised through feature registers are limited, which pKVM
enforces by trapping register accesses and instructions associated with these
features.

This series is based on 5.14-rc2. You can find the applied series here [5].

Cheers,
/fuad

[1] https://lore.kernel.org/kvmarm/20210615133950.693489-1-tabba@google.com/

[2] https://lore.kernel.org/kvmarm/20210603183347.1695-1-will@kernel.org/

[3] https://lore.kernel.org/kvmarm/20210608141141.997398-1-tabba@google.com/

[4] Once complete, protected KVM adds the ability to create protected VMs.
These protected VMs are protected from the host Linux kernel (and from other
VMs), where the host does not have access to guest memory,even if compromised.
Normal (nVHE) guests can still be created and run in parallel with protected
VMs. Their functionality should not be affected.

For protected VMs, the host should not even have access to a protected guest's
state or anything that would enable it to manipulate it (e.g., vcpu register
context and el2 system registers); only hyp would have that access. If the host
could access that state, then it might be able to get around the protection
provided.  Therefore, anything that is sensitive and that would require such
access needs to happen at hyp, hence the code in nvhe running only at hyp.

For more details about pKVM, please refer to Will's talk at KVM Forum 2020:
https://mirrors.edge.kernel.org/pub/linux/kernel/people/will/slides/kvmforum-2020-edited.pdf
https://www.youtube.com/watch?v=edqJSzsDRxk

[5] https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/el2_fixed_feature_v3

Fuad Tabba (15):
  KVM: arm64: placeholder to check if VM is protected
  KVM: arm64: Remove trailing whitespace in comment
  KVM: arm64: MDCR_EL2 is a 64-bit register
  KVM: arm64: Fix names of config register fields
  KVM: arm64: Refactor sys_regs.h,c for nVHE reuse
  KVM: arm64: Restore mdcr_el2 from vcpu
  KVM: arm64: Track value of cptr_el2 in struct kvm_vcpu_arch
  KVM: arm64: Add feature register flag definitions
  KVM: arm64: Add config register bit definitions
  KVM: arm64: Guest exit handlers for nVHE hyp
  KVM: arm64: Add trap handlers for protected VMs
  KVM: arm64: Move sanitized copies of CPU features
  KVM: arm64: Trap access to pVM restricted features
  KVM: arm64: Handle protected guests at 32 bits
  KVM: arm64: Restrict protected VM capabilities

 arch/arm64/include/asm/cpufeature.h       |   4 +-
 arch/arm64/include/asm/kvm_arm.h          |  54 ++-
 arch/arm64/include/asm/kvm_asm.h          |   2 +-
 arch/arm64/include/asm/kvm_fixed_config.h | 188 +++++++++
 arch/arm64/include/asm/kvm_host.h         |  15 +-
 arch/arm64/include/asm/kvm_hyp.h          |   5 +-
 arch/arm64/include/asm/sysreg.h           |  15 +-
 arch/arm64/kernel/cpufeature.c            |   8 +-
 arch/arm64/kvm/Makefile                   |   2 +-
 arch/arm64/kvm/arm.c                      |  75 +++-
 arch/arm64/kvm/debug.c                    |   2 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h   |  76 +++-
 arch/arm64/kvm/hyp/nvhe/Makefile          |   2 +-
 arch/arm64/kvm/hyp/nvhe/debug-sr.c        |   2 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c     |   6 -
 arch/arm64/kvm/hyp/nvhe/switch.c          |  72 +++-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c        | 445 ++++++++++++++++++++++
 arch/arm64/kvm/hyp/vhe/debug-sr.c         |   2 +-
 arch/arm64/kvm/hyp/vhe/switch.c           |  12 +-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c        |   2 +-
 arch/arm64/kvm/pkvm.c                     | 213 +++++++++++
 arch/arm64/kvm/sys_regs.c                 |  34 +-
 arch/arm64/kvm/sys_regs.h                 |  31 ++
 23 files changed, 1172 insertions(+), 95 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_fixed_config.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/sys_regs.c
 create mode 100644 arch/arm64/kvm/pkvm.c


base-commit: 2734d6c1b1a089fb593ef6a23d4b70903526fe0c
-- 
2.32.0.402.g57bb445576-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
