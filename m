Return-Path: <SRS0=JeL3=EW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B2B2C4742C
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 20:43:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E09232225B
	for <kvmarm@archiver.kernel.org>; Mon, 16 Nov 2020 20:43:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="va51Yehh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E09232225B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B6D24C246;
	Mon, 16 Nov 2020 15:43:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TjZV89xQCgMe; Mon, 16 Nov 2020 15:43:26 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DE05A4C1AB;
	Mon, 16 Nov 2020 15:43:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F5C24C19D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 15:43:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id udKx1iMij+1y for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Nov 2020 15:43:24 -0500 (EST)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6D8DD4C16F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 15:43:24 -0500 (EST)
Received: by mail-wr1-f65.google.com with SMTP id u12so13060671wrt.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2020 12:43:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=ez4ezJGM8Jye68W6k3JKSGLh1n6D0kATjez8aR9Nk54=;
 b=va51YehhJ8FuXErziEVWdMd9wXcAcl4xZugOQZ9QYh78uUUBQf4izOIsceIj+DHENe
 nVjDRANKSDKWBZZ21bMns1g3Mz+TdXqyIxJfNgMgv/p5XDCwEVQo99V2HiPBEcWCwAdd
 GyZB3uAV/RqwGwjUDJMSBuywaXNBBJWNLAKST1NG0orO5Lqa0jG9vv9eTNvMQYHEGvcd
 MdAPMiuE89gOqAp+ue95nMTLAI4gmZx2aADaKMGLS24JNy0bmghOh0zHYvF4Zzat+XBJ
 rKsI7VCFh+MhIsPDmV+KrXxZAL6DvY7HQ1k9Omh3EdNbRSNfQIAkJr17/gEx9SiUt1+G
 Eq4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=ez4ezJGM8Jye68W6k3JKSGLh1n6D0kATjez8aR9Nk54=;
 b=PKsIBkgRWDzrkvb5Ts7/ZGRywGqWkuGBmX0lh0WFgCL/IDCOp8nrvl3hdNgn6mjrSi
 y02zwHChqQoudXhrbPR32uPmQktsXktiCoFCvlEE01zXBLYVdt7JMYFbSNH8zVj0i/aT
 fhtiATgydPFivru8PDHXrclXJdGTSAA7masJ41daq6RJptSAvemoKEiRSHolfpAk4Da4
 xDwW7YW2/H4wOqSi8xBzUrNFOfrexE7oCfal1jYEMkUZ1kF4OiS7KVdULKUs2IwHMX1O
 717ztvuD+R78IvwmZrrSL5ndpW60GHfsFIBLKPUsDxSFvQKOs2xNVH4v6Rt5t9O51OKL
 cX2w==
X-Gm-Message-State: AOAM530vI+4LZKGZK37oU8ELY8m3deLqpIXxAOIArW1T8In6KOyCVDKK
 uA6bQpBsfehCW8D77FGMnuZLa4+CrB7H+CLfsR8=
X-Google-Smtp-Source: ABdhPJzjQSGFtJU+tB0SjZoeZ35rs2S4wU4sI06EPwHTB2KSFHgQdm+IXGMc26iCRHlhPIq+4sBJLg==
X-Received: by 2002:a05:6000:345:: with SMTP id
 e5mr20485510wre.333.1605559402826; 
 Mon, 16 Nov 2020 12:43:22 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:bc40:bd71:373a:1b33])
 by smtp.gmail.com with ESMTPSA id l24sm566784wmi.7.2020.11.16.12.43.21
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 16 Nov 2020 12:43:21 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 00/24] Opt-in always-on nVHE hypervisor
Date: Mon, 16 Nov 2020 20:42:54 +0000
Message-Id: <20201116204318.63987-1-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Cc: kernel-team@android.com, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Andrew Walbran <qwandor@google.com>, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
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

All functionality described below is opt-in, guarded by an early param
'kvm-arm.protected'. Future patches specific to the new "protected" mode
should be hidden behind the same param.

The hypervisor starts trapping host SMCs and intercepting host's PSCI
CPU_ON/SUSPEND calls. It replaces the host's entry point with its own,
initializes the EL2 state of the new CPU and installs the nVHE hyp vector
before ERETing to the host's entry point.

The kernel checks new cores' features against the finalized system
capabilities. To avoid the need to move this code/data to EL2, the
implementation only allows to boot cores that were online at the time of
KVM initialization and therefore had been checked already.

Other PSCI SMCs are forwarded to EL3, though only the known set of SMCs
implemented in the kernel is allowed. Non-PSCI SMCs are also forwarded
to EL3. Future changes will need to ensure the safety of all SMCs wrt.
private guests.

The host is still allowed to reset EL2 back to the stub vector, eg. for
hibernation or kexec, but will not disable nVHE when there are no VMs.

Tested on Rock Pi 4b, based on 5.10-rc4.

changes since v1:
  * early param sets a capability instead of a static key
  * assume SMCCC v1.2 for host SMC forwarding
  * fix reserved SMC ID range for PSCI
  * split init_el2_state into smaller macros, move to el2_setup.h
  * many small cleanups

changes since RFC:
  * add early param to make features opt-in
  * simplify CPU_ON/SUSPEND implementation
  * replace spinlocks with CAS atomic
  * make cpu_logical_map ro_after_init

David Brazdil (24):
  psci: Support psci_ops.get_version for v0.1
  psci: Accessor for configured PSCI function IDs
  arm64: Make cpu_logical_map() take unsigned int
  arm64: Move MAIR_EL1_SET to asm/memory.h
  kvm: arm64: Initialize MAIR_EL2 using a constant
  kvm: arm64: Move hyp-init params to a per-CPU struct
  kvm: arm64: Refactor handle_trap to use a switch
  kvm: arm64: Add SMC handler in nVHE EL2
  kvm: arm64: Add .hyp.data..ro_after_init ELF section
  kvm: arm64: Support per_cpu_ptr in nVHE hyp code
  kvm: arm64: Create nVHE copy of cpu_logical_map
  kvm: arm64: Bootstrap PSCI SMC handler in nVHE EL2
  kvm: arm64: Add offset for hyp VA <-> PA conversion
  kvm: arm64: Forward safe PSCI SMCs coming from host
  kvm: arm64: Extract parts of el2_setup into a macro
  kvm: arm64: Extract __do_hyp_init into a helper function
  kvm: arm64: Add CPU entry point in nVHE hyp
  kvm: arm64: Add function to enter host from KVM nVHE hyp code
  kvm: arm64: Intercept host's PSCI_CPU_ON SMCs
  kvm: arm64: Intercept host's CPU_SUSPEND PSCI SMCs
  kvm: arm64: Add kvm-arm.protected early kernel parameter
  kvm: arm64: Keep nVHE EL2 vector installed
  kvm: arm64: Trap host SMCs in protected mode.
  kvm: arm64: Fix EL2 mode availability checks

 arch/arm64/include/asm/cpucaps.h     |   3 +-
 arch/arm64/include/asm/el2_setup.h   | 185 +++++++++++++++++
 arch/arm64/include/asm/kvm_arm.h     |   1 +
 arch/arm64/include/asm/kvm_asm.h     |  16 +-
 arch/arm64/include/asm/kvm_hyp.h     |   8 +
 arch/arm64/include/asm/memory.h      |  29 ++-
 arch/arm64/include/asm/percpu.h      |   6 +
 arch/arm64/include/asm/sections.h    |   1 +
 arch/arm64/include/asm/smp.h         |   4 +-
 arch/arm64/include/asm/sysreg.h      |  30 +++
 arch/arm64/include/asm/virt.h        |  26 +++
 arch/arm64/kernel/asm-offsets.c      |   5 +
 arch/arm64/kernel/cpufeature.c       |  29 +++
 arch/arm64/kernel/head.S             | 144 ++-----------
 arch/arm64/kernel/image-vars.h       |   3 +
 arch/arm64/kernel/setup.c            |   2 +-
 arch/arm64/kernel/vmlinux.lds.S      |  10 +
 arch/arm64/kvm/arm.c                 |  94 +++++++--
 arch/arm64/kvm/hyp/nvhe/Makefile     |   3 +-
 arch/arm64/kvm/hyp/nvhe/host.S       |  47 +++++
 arch/arm64/kvm/hyp/nvhe/hyp-init.S   |  90 +++++++--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c   |  47 ++++-
 arch/arm64/kvm/hyp/nvhe/hyp-smp.c    |  40 ++++
 arch/arm64/kvm/hyp/nvhe/hyp.lds.S    |   1 +
 arch/arm64/kvm/hyp/nvhe/psci-relay.c | 289 +++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/switch.c     |   5 +-
 arch/arm64/kvm/va_layout.c           |  30 ++-
 arch/arm64/mm/proc.S                 |  15 +-
 drivers/firmware/psci/psci.c         |  21 +-
 include/linux/psci.h                 |  10 +
 30 files changed, 977 insertions(+), 217 deletions(-)
 create mode 100644 arch/arm64/include/asm/el2_setup.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/hyp-smp.c
 create mode 100644 arch/arm64/kvm/hyp/nvhe/psci-relay.c

--
2.29.2.299.gdc1121823c-goog
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
