Return-Path: <SRS0=PxFR=EK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81566C4742C
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 18:36:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AE55420719
	for <kvmarm@archiver.kernel.org>; Wed,  4 Nov 2020 18:36:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="l6wxGTW9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AE55420719
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DFEF44B543;
	Wed,  4 Nov 2020 13:36:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id v-E651+Ok4Rw; Wed,  4 Nov 2020 13:36:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C8FB64B6D6;
	Wed,  4 Nov 2020 13:36:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F4C64B55A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 13:36:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qWkBULua4O2h for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Nov 2020 13:36:38 -0500 (EST)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C662F4B543
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2020 13:36:38 -0500 (EST)
Received: by mail-wm1-f68.google.com with SMTP id d142so3349195wmd.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Nov 2020 10:36:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=9bnsPOxn9yGq928zTuAG9ePIv/5JkrABhmxyp7kCDgs=;
 b=l6wxGTW9/LgEK7XEkr5CmOoS+dYbC2prLnazJg1dUjb83k2tfBbIuo1MO4xfZuYuq2
 sdCXNTy3SkxO9ZDbZMd3NOEHJs6ugqJAtzosfyql8vY74UHap4MybGlDLWijiRZXgNL2
 ukXB3rZMzB4hfoEZDlt1s11vC2vnIaVIKJNFHYOoH9vUcjoIXfy1vRSHptzTvVN+B5SZ
 4nCASvL0GV20ahufoXLFL+HdwJO1PLsbLwPV0JNLmWxWUMdIIbkL9NGUdfqAk9XstiEY
 3sEQ4PgP50Nx7Z3YaYwq+KXRrQaOS0rD6uHN3wn+AKch4N4pP8rsBwWw8K+ZWGmb4isW
 YE1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=9bnsPOxn9yGq928zTuAG9ePIv/5JkrABhmxyp7kCDgs=;
 b=Wn+v5aYhUrzAjyset4KmSJNpnkdaNhsMhiFSIprWZSONS93OZfc3alcxMF4UmV/0eu
 VB5NI/4r0d+neTTzQ+kn4jA4s53ERliwLc5bnRprR6SE9tYg5R+oKICw3qs4Zv+tF81t
 67wN6X9LEFHWER/Q/RsAbSHUVryDn2ANyubP7t6WeOJRSwRUEcvtlkeCBgBehVaJI5ao
 kkszIWk9DSbIZ0LoEu4jpta3b3yRAZW5f4Nzx6cfkk7+p2qHimyUp25OOwpsldh62apQ
 xQF6nuRRY/HyJAQJl3d4eaz5oD1vRHaVEpSBLtOrmmVlKXZ3hWV6ipPWAV9+6yMIVzMB
 5/tw==
X-Gm-Message-State: AOAM533j1W+pTyaYXKfUSdHm1UCljmuZA6oLcPsTYN7/yZvaLd53FVVl
 F34RQteBeoup7svgj+wa2ZwzxLlu85TWukpv
X-Google-Smtp-Source: ABdhPJzETxfQOiqTB15tW/fCe98/ypLF2uI3mbgefn2W2p6cqFwsV46hT/Ypd/7K3nRZPYbyiOyf9g==
X-Received: by 2002:a1c:18b:: with SMTP id 133mr1119334wmb.157.1604514996877; 
 Wed, 04 Nov 2020 10:36:36 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:c8d2:30f2:53c6:bc2])
 by smtp.gmail.com with ESMTPSA id d8sm3267985wmb.11.2020.11.04.10.36.35
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 04 Nov 2020 10:36:35 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH 00/26] kvm: arm64: Always-on nVHE hypervisor
Date: Wed,  4 Nov 2020 18:36:04 +0000
Message-Id: <20201104183630.27513-1-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.1
MIME-Version: 1.0
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kernel-team@android.com,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
 Will Deacon <will@kernel.org>
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

As we progress towards being able to keep guest state private to the
host running nVHE hypervisor, this series allows the hypervisor to
install itself on newly booted CPUs before the host is allowed to run
on them.

To this end, the hypervisor starts trapping host SMCs and intercepting
host's PSCI CPU_ON/OFF/SUSPEND calls. It replaces the host's entry point
with its own, initializes the EL2 state of the new CPU and installs
the nVHE hyp vector before ERETing to the host's entry point.

Other PSCI SMCs are forwarded to EL3, though only the known set of SMCs
implemented in the kernel is allowed. Non-PSCI SMCs are also forwarded
to EL3. Future changes will need to ensure the safety of all SMCs wrt.
private guests.

The host is still allowed to reset EL2 back to the stub vector, eg. for
hibernation or kexec, but will not disable nVHE when there are no VMs.

Tested on Rock Pi 4b.


Sending this as an RFC to get feedback on the following decisions:

1) The kernel checks new cores' features against the finalized system
capabilities. To avoid the need to move this code/data to EL2, the
implementation only allows to boot cores that were online at the time of
KVM initialization.

2) Trapping and forwarding SMCs cannot be switched off. This could cause
issues eg. if EL3 always returned to EL1. A kernel command line flag may
be needed to turn the feature off on such platforms.

  -David

David Brazdil (25):
  psci: Export configured PSCI version
  psci: Export configured PSCI function IDs
  psci: Export psci_cpu_suspend_feature
  arm64: Move MAIR_EL1_SET to asm/memory.h
  kvm: arm64: Initialize MAIR_EL2 using a constant
  kvm: arm64: Add .hyp.data ELF section
  kvm: arm64: Support per_cpu_ptr in nVHE hyp code
  kvm: arm64: Create nVHE copy of cpu_logical_map
  kvm: arm64: Move hyp-init params to a per-CPU struct
  kvm: arm64: Refactor handle_trap to use a switch
  kvm: arm64: Extract parts of el2_setup into a macro
  kvm: arm64: Add SMC handler in nVHE EL2
  kvm: arm64: Bootstrap PSCI SMC handler in nVHE EL2
  kvm: arm64: Forward safe PSCI SMCs coming from host
  kvm: arm64: Add offset for hyp VA <-> PA conversion
  kvm: arm64: Bootstrap PSCI power state of host CPUs
  kvm: arm64: Intercept PSCI_CPU_OFF host SMC calls
  kvm: arm64: Extract __do_hyp_init into a helper function
  kvm: arm64: Add CPU entry point in nVHE hyp
  kvm: arm64: Add function to enter host from KVM nVHE hyp code
  kvm: arm64: Intercept PSCI_CPU_ON host SMC calls
  kvm: arm64: Intercept host's CPU_SUSPEND PSCI SMCs
  kvm: arm64: Keep nVHE EL2 vector installed
  kvm: arm64: Trap host SMCs
  kvm: arm64: Fix EL2 mode availability checks

Will Deacon (1):
  arm64: kvm: Add standalone ticket spinlock implementation for use at
    hyp

 arch/arm64/include/asm/kvm_arm.h           |   3 +-
 arch/arm64/include/asm/kvm_asm.h           | 142 +++++++++
 arch/arm64/include/asm/kvm_hyp.h           |  10 +
 arch/arm64/include/asm/memory.h            |  13 +
 arch/arm64/include/asm/percpu.h            |   6 +
 arch/arm64/include/asm/sections.h          |   1 +
 arch/arm64/include/asm/virt.h              |  16 +
 arch/arm64/kernel/asm-offsets.c            |   5 +
 arch/arm64/kernel/head.S                   | 140 +--------
 arch/arm64/kernel/image-vars.h             |   3 +
 arch/arm64/kernel/vmlinux.lds.S            |  10 +
 arch/arm64/kvm/arm.c                       | 109 ++++++-
 arch/arm64/kvm/hyp/include/nvhe/spinlock.h |  96 ++++++
 arch/arm64/kvm/hyp/nvhe/Makefile           |   3 +-
 arch/arm64/kvm/hyp/nvhe/host.S             |   9 +
 arch/arm64/kvm/hyp/nvhe/hyp-init.S         |  82 ++++-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c         |  57 +++-
 arch/arm64/kvm/hyp/nvhe/hyp.lds.S          |   3 +
 arch/arm64/kvm/hyp/nvhe/percpu.c           |  38 +++
 arch/arm64/kvm/hyp/nvhe/psci.c             | 333 +++++++++++++++++++++
 arch/arm64/mm/proc.S                       |  13 -
 drivers/firmware/psci/psci.c               |  27 +-
 include/linux/psci.h                       |  20 ++
 include/uapi/linux/psci.h                  |   8 +
 24 files changed, 948 insertions(+), 199 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/spinlock.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/percpu.c
 create mode 100644 arch/arm64/kvm/hyp/nvhe/psci.c

--
2.29.1.341.ge80a0c044ae-goog
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
