Return-Path: <SRS0=Ot4E=6O=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0E7EC47253
	for <kvmarm@archiver.kernel.org>; Thu, 30 Apr 2020 14:48:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3A2832074A
	for <kvmarm@archiver.kernel.org>; Thu, 30 Apr 2020 14:48:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="G5oxdiVz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3A2832074A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9803F4B4D8;
	Thu, 30 Apr 2020 10:48:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Bz7dh-wMPOuL; Thu, 30 Apr 2020 10:48:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 576AF4B43E;
	Thu, 30 Apr 2020 10:48:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 990AB4B3A2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2020 10:48:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jAD+mvI7OI4k for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Apr 2020 10:48:44 -0400 (EDT)
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com
 [209.85.128.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3763C4B394
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2020 10:48:44 -0400 (EDT)
Received: by mail-wm1-f66.google.com with SMTP id v4so7643532wme.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2020 07:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=SNF6UHAWqMkyYuIU0QRud/LtidR5txVpCjgq6hRS/rs=;
 b=G5oxdiVzQ6WQl8M6UOHfwP4pdHBU+qv5OHGvlNbCBI0z9EBiG+qssCu1yXAnrFN8gv
 lfko0Ni7uJjsvIxBetErtcwMm+mV2hclOUvBYr+lHY8ApffvotwdYZ9dxALl9nv92YtG
 ROYpq0EMuXYqoMaD8whW/Fjg8RSl+BhJYFo1rMpfzXKwF1hZRGTBo0M+YcbGHkp6zzbT
 G1k70B02KruRIlOfpfIyHn1hA+13411yMCiF3hwc3ZYt+xhsDWBoy8vjYIfZ/Y6/KMcN
 AzA0R3zvornaAnFTrqqiD/YsU76Cz4LdR6w7VuvVnoVzWhYndo+J2qimTWachzUtMCKQ
 5PtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=SNF6UHAWqMkyYuIU0QRud/LtidR5txVpCjgq6hRS/rs=;
 b=p8cJQD4YgzLseDhWmXUuLpBfTFWt12hoxBSMhCBMO4uFoRKAP3hskQqMp4fTlTUvGj
 faeJqQgWwT8pDvtp3aDrc+FVKuCff7mVi/niPAA3TGy8MXpzX1pFcRiLcV69QzJ9du8U
 A8KAz0pDsnKCnRl/8Ucege6hu1UZMMWVwC+jaSfy5D2MPuMQ6JzcCa3mmjarGpo5GaRk
 MIuKoeVCK6HBKGBkMVwhQiyz5a8uillSrxN3mNH1eFFzJEj9ZK7WRw254MrMeSQTSDGZ
 ryOWtQ7XhGuCVuLTLid9WZY+fNy29LXKQPrCQMf2r1w0skx85pXcOILS/oq5Rf+yNuG7
 XKJQ==
X-Gm-Message-State: AGi0Pua+o7rHwOkMyX5IEdG/dkQBox8m3yICuLMA2L/oCscLSGAOEPcu
 gSHlgdohDfCa2a0XZ+WI0Bx/ww==
X-Google-Smtp-Source: APiQypKNM79/w8ZSyytfmzDWXe1CAhLCYA5tA2YOUJb4Z3naBNIFJxsLCPvYaCkYw96MVWpA4gCx5w==
X-Received: by 2002:a05:600c:21ca:: with SMTP id
 x10mr3222316wmj.113.1588258122596; 
 Thu, 30 Apr 2020 07:48:42 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:d4b6:9828:8bd2:ce6f])
 by smtp.gmail.com with ESMTPSA id s8sm4287714wru.38.2020.04.30.07.48.40
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 30 Apr 2020 07:48:41 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
 James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Marc Zyngier <maz@kernel.org>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Will Deacon <will@kernel.org>
Subject: [PATCH 00/15] Split off nVHE hyp code
Date: Thu, 30 Apr 2020 15:48:16 +0100
Message-Id: <20200430144831.59194-1-dbrazdil@google.com>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
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

Refactor files in arch/arm64/kvm/hyp to compile all code which runs in EL2
under nVHE into separate object files from the rest of KVM. This is done in
preparation for being able to unmap .hyp.text from EL1 but has other benefits,
notably:
 * safe use of KASAN/UBSAN/GCOV instrumentation on VHE code,
 * cleaner HVC API,
 * no need for __hyp_text annotations.

nVHE-specific code is moved to hyp/nvhe and compiled with custom build rules
similar to those used by EFI stub. Shared source files are compiled under both
VHE and nVHE build rules. Where a source file contained both VHE and nVHE code,
it is split into a shared header file and two C source files. This is done one
file per commit to make review easier.

All nVHE symbols are prefixed with "__hyp_text_" to avoid collisions with VHE
variants (also inspired by EFI stub). Since this prefixes unresolved symbols
too, image-vars.h contains a list of kernel symbol aliases where nVHE code
still refers to kernel proper. This list will be further reduced in the future.

No functional changes are intended but code was simplified whenever the
refactoring made it possible.

Tested by running kvm-unit-tests on QEMU 5.0 with VHE/nVHE and GIC v2/v3.

This is based off Fuad Tabba's patch series "KVM: arm64: Tidy up arch Kconfig
and Makefiles". Available in branch 'topic/el2-obj' of git repo:
  https://android-kvm.googlesource.com/linux

-David

David Brazdil (13):
  arm64: kvm: Fix symbol dependency in __hyp_call_panic_nvhe
  arm64: kvm: Add build rules for separate nVHE object files
  arm64: kvm: Build hyp-entry.S separately for VHE/nVHE
  arm64: kvm: Move __smccc_workaround_1_smc to .rodata
  arm64: kvm: Split hyp/tlb.c to VHE/nVHE
  arm64: kvm: Split hyp/switch.c to VHE/nVHE
  arm64: kvm: Split hyp/debug-sr.c to VHE/nVHE
  arm64: kvm: Split hyp/sysreg-sr.c to VHE/nVHE
  arm64: kvm: Split hyp/timer-sr.c to VHE/nVHE
  arm64: kvm: Compile remaining hyp/ files for both VHE/nVHE
  arm64: kvm: Add comments around __hyp_text_ symbol aliases
  arm64: kvm: Remove __hyp_text macro, use build rules instead
  arm64: kvm: Lift instrumentation restrictions on VHE

Quentin Perret (2):
  arm64: kvm: Unify users of HVC instruction
  arm64: kvm: Formalize host-hyp hypcall ABI

 arch/arm64/include/asm/kvm_asm.h             |  26 +-
 arch/arm64/include/asm/kvm_emulate.h         |   2 +-
 arch/arm64/include/asm/kvm_host.h            |  32 +-
 arch/arm64/include/asm/kvm_host_hypercalls.h |  62 ++
 arch/arm64/include/asm/kvm_hyp.h             |  15 +-
 arch/arm64/include/asm/kvm_mmu.h             |  13 +-
 arch/arm64/include/asm/mmu.h                 |   7 -
 arch/arm64/include/asm/virt.h                |  33 +-
 arch/arm64/kernel/cpu_errata.c               |   2 +-
 arch/arm64/kernel/hyp-stub.S                 |  34 -
 arch/arm64/kernel/image-vars.h               |  44 ++
 arch/arm64/kvm/arm.c                         |   6 +-
 arch/arm64/kvm/hyp.S                         |  13 +-
 arch/arm64/kvm/hyp/Makefile                  |  12 +-
 arch/arm64/kvm/hyp/aarch32.c                 |   6 +-
 arch/arm64/kvm/hyp/debug-sr.c                | 214 +-----
 arch/arm64/kvm/hyp/debug-sr.h                | 165 +++++
 arch/arm64/kvm/hyp/entry.S                   |   1 -
 arch/arm64/kvm/hyp/fpsimd.S                  |   1 -
 arch/arm64/kvm/hyp/hyp-entry.S               |  62 +-
 arch/arm64/kvm/hyp/nvhe/Makefile             |  42 ++
 arch/arm64/kvm/hyp/nvhe/debug-sr.c           |  77 +++
 arch/arm64/kvm/hyp/nvhe/host_hypercall.c     |  22 +
 arch/arm64/kvm/hyp/nvhe/switch.c             | 271 ++++++++
 arch/arm64/kvm/hyp/nvhe/sysreg-sr.c          |  56 ++
 arch/arm64/kvm/hyp/nvhe/timer-sr.c           |  43 ++
 arch/arm64/kvm/hyp/nvhe/tlb.c                |  67 ++
 arch/arm64/kvm/hyp/switch.c                  | 688 +------------------
 arch/arm64/kvm/hyp/switch.h                  | 438 ++++++++++++
 arch/arm64/kvm/hyp/sysreg-sr.c               | 227 +-----
 arch/arm64/kvm/hyp/sysreg-sr.h               | 211 ++++++
 arch/arm64/kvm/hyp/timer-sr.c                |  38 +-
 arch/arm64/kvm/hyp/tlb.c                     | 168 +----
 arch/arm64/kvm/hyp/tlb.h                     | 126 ++++
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c     |   4 +-
 arch/arm64/kvm/hyp/vgic-v3-sr.c              | 130 ++--
 arch/arm64/kvm/va_layout.c                   |   2 +-
 scripts/kallsyms.c                           |   1 +
 38 files changed, 1887 insertions(+), 1474 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_host_hypercalls.h
 create mode 100644 arch/arm64/kvm/hyp/debug-sr.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/Makefile
 create mode 100644 arch/arm64/kvm/hyp/nvhe/debug-sr.c
 create mode 100644 arch/arm64/kvm/hyp/nvhe/host_hypercall.c
 create mode 100644 arch/arm64/kvm/hyp/nvhe/switch.c
 create mode 100644 arch/arm64/kvm/hyp/nvhe/sysreg-sr.c
 create mode 100644 arch/arm64/kvm/hyp/nvhe/timer-sr.c
 create mode 100644 arch/arm64/kvm/hyp/nvhe/tlb.c
 create mode 100644 arch/arm64/kvm/hyp/switch.h
 create mode 100644 arch/arm64/kvm/hyp/sysreg-sr.h
 create mode 100644 arch/arm64/kvm/hyp/tlb.h

-- 
2.26.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
