Return-Path: <SRS0=2KC8=AG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29B06C433DF
	for <kvmarm@archiver.kernel.org>; Thu, 25 Jun 2020 13:14:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A554F20720
	for <kvmarm@archiver.kernel.org>; Thu, 25 Jun 2020 13:14:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="gGBLG82B"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A554F20720
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CA3B4B088;
	Thu, 25 Jun 2020 09:14:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LgPczsvmm1z0; Thu, 25 Jun 2020 09:14:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC7454B535;
	Thu, 25 Jun 2020 09:14:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6098C4B533
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 09:14:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IOA7wKkbAPub for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Jun 2020 09:14:25 -0400 (EDT)
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com
 [209.85.128.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B26DB4B512
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 09:14:25 -0400 (EDT)
Received: by mail-wm1-f66.google.com with SMTP id u26so6720173wmn.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 06:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=xPV3vLHNPqkWUx4FYbA872hJ3EvgoWDkGiwzLIz0i8U=;
 b=gGBLG82B4G0LEWygJGTzyWDxE7LGM0L04ycqzZcdpej60fX9ic9cyP3pey9aWRuKDP
 MEWYYdEcSpnwIT1cFiSack6kKFOzTLryy0omOBzokPhYm12AsPuIxoqqh5W6aHn621D6
 U9ZssHu6Eex5heudfWc82FctcVHaaLkgC+pXJ+NVpzKwBy8TUe45g4VlE+KU/FeFf4a8
 JBocUY8ly2fU97u6R6i6lai7EsMjyXK3JtqlwCdnsdWM5KetusRrsTWUM7vapkRAEPiV
 q+modrlkmRcC27WIhL9RdDHKF0iM7BdD3SDGFNwrAKLjRKnTcT8hiwiqX23KkQWfYgYk
 qusA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=xPV3vLHNPqkWUx4FYbA872hJ3EvgoWDkGiwzLIz0i8U=;
 b=V9oL62PWU3DxLTxa4PY7h7ZtGD25RZAkgBM/Omc4c/sr8La0StX0WfwRf56/Dcq3Rr
 3doPQhDhGYBiGyCEA83kE/EkJCAClQ6xtyR89hy9MsYLjenfJd5qZajbFwU8vl6mA5yF
 DlBW7WBIV+TO3UmLE6rVuhKFXnOIXzXg7KOY9Z/aRXyfDPQduuDco88zrk6xiHXi864T
 5z4a/qppO8WDQ92I5hgeEP+YkLbYDj1exEeamz7Eld+2atFBpWF64w/ylvYmbUp0LyDZ
 o5m9Pd314GPfMIuSaYfW6izoPg3azMZAdmqL53Usnb2QQui2X0MwDSyjKEbtklCgZUCD
 I5eg==
X-Gm-Message-State: AOAM533cYcySKQVrrMDbbaiGZojPDrFRqGBq6RXQ1eE4fBwBAKR5KzzH
 +nQBZdI1OBIpCrUkxR+NMMI/Sw==
X-Google-Smtp-Source: ABdhPJx4AejEUnWz/QmzR5T5pjLMScdGzrd8AVVmdQBXiizdwP60UrNvpqe5PiD54KGIHjiCe79hgg==
X-Received: by 2002:a7b:c92e:: with SMTP id h14mr3246932wml.36.1593090864288; 
 Thu, 25 Jun 2020 06:14:24 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:c126:6748:7a9d:2d])
 by smtp.gmail.com with ESMTPSA id c206sm13401130wmf.36.2020.06.25.06.14.23
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 25 Jun 2020 06:14:23 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v4 00/15] Split off nVHE hyp code
Date: Thu, 25 Jun 2020 14:14:05 +0100
Message-Id: <20200625131420.71444-1-dbrazdil@google.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Cc: android-kvm@google.com, linux-kernel@vger.kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

Refactor files in arch/arm64/kvm/hyp to compile all code which runs in EL2
under nVHE into separate object files from the rest of KVM. This is done in
preparation for being able to unmap hyp code from EL1 and kernel code/data
from EL2 but has other benefits too, notably:
 * safe use of KASAN/UBSAN/GCOV instrumentation on VHE code,
 * no need for __hyp_text annotations.

nVHE-specific code is moved to hyp/nvhe and compiled with custom build rules
similar to those used by EFI stub. Shared source files are compiled under both
VHE and nVHE build rules. Where a source file contained both VHE and nVHE code,
it is split into a shared header file and two C source files. This is done one
file per commit to make review easier.

All nVHE symbols are prefixed with "__kvm_nvhe_" to avoid collisions with VHE
variants (also inspired by EFI stub). Since this prefixes unresolved symbols
too, image-vars.h contains a list of kernel symbol aliases where nVHE code
still refers to kernel proper. The list grows fairly large as the patch series
progresses and code is moved around, but at the end contains 20 symbols. These
remaining dependencies on kernel proper will be further reduced in the future.

No functional changes are intended but code was simplified whenever the
refactoring made it possible.

Tested by running kvm-unit-tests on QEMU 5.0 with VHE/nVHE and GIC v2/v3.

Dual compilation of code shared by VHE/nVHE increase the size of the kernel.
Bloat-o-meter vmlinux diff shows an increase of 21 KB on the ELF symbol level.
Size of Image.gz is up by 10 KB; size of Image is unchanged, presumably due
to ELF section alignment.

This is based off v5.8-rc2. Available in branch 'topic/el2-obj-v4' of git repo:
  https://android-kvm.googlesource.com/linux

Changes v3 -> v4:
 * rebase onto v5.8-rc2 (trivial)
 * add SYM_DATA_START/END around __smccc_workaround_1_smc
 * move VHE-specific source files into hyp/vhe
 * move headers shared by VHE/nVHE into hyp/include
 * define __KVM_VHE_HYPERVISOR__ for VHE-specific code
 * has_vhe() compile-time determinable when used in hyp/
 * KVM_NVHE_ALIAS macro in image-vars.h, comments throughout series
 * #define hyp symbols in kernel to magically select between VHE/nVHE variant
 * duplicate hyp/tlb.c instead of splitting it
 * pass idmap_t0sz to hyp-init as parameter to avoid symbol alias

Changes v2 -> v3:
 * rebase onto v5.8-rc1
 * remove patch changing hypcall interface to function IDs
 * move hyp-init.S to nVHE
 * fix symbol aliasing under CONFIG_ARM64_PSEUDO_NMI and CONFIG_ARM64_SVE
 * remove VHE's unused __kvm_enable_ssbs()
 * make nVHE use VHE's hyp_panic_string for consistent use of absolute relocs
   when returning pointers back to kernel
 * replace __noscs annotation (added to __hyp_text macro) with build rule

Changes v1 -> v2:
 * change nVHE symbol prefix from __hyp_text_ to __kvm_nvhe_
 * rename __HYPERVISOR__ macro to __KVM_NVHE_HYPERVISOR__
 * use hcall jump table instead of array of function pointers
 * drop patch to unify HVC callers
 * move __smccc_workaround_1_smc to own file
 * header guards for hyp/*.h
 * improve helpers for handling VHE/nVHE hyp syms in kernel proper
 * improve commit messages, cover letter

-David

Andrew Scull (2):
  arm64: kvm: Handle calls to prefixed hyp functions
  arm64: kvm: Move hyp-init.S to nVHE

David Brazdil (13):
  arm64: kvm: Fix symbol dependency in __hyp_call_panic_nvhe
  arm64: kvm: Move __smccc_workaround_1_smc to .rodata
  arm64: kvm: Add build rules for separate VHE/nVHE object files
  arm64: kvm: Use build-time defines in has_vhe()
  arm64: kvm: Build hyp-entry.S separately for VHE/nVHE
  arm64: kvm: Duplicate hyp/tlb.c for VHE/nVHE
  arm64: kvm: Split hyp/switch.c to VHE/nVHE
  arm64: kvm: Split hyp/debug-sr.c to VHE/nVHE
  arm64: kvm: Split hyp/sysreg-sr.c to VHE/nVHE
  arm64: kvm: Duplicate hyp/timer-sr.c for VHE/nVHE
  arm64: kvm: Compile remaining hyp/ files for both VHE/nVHE
  arm64: kvm: Remove __hyp_text macro, use build rules  instead
  arm64: kvm: Lift instrumentation restrictions on VHE

 arch/arm64/include/asm/kvm_asm.h              |  48 +-
 arch/arm64/include/asm/kvm_emulate.h          |   2 +-
 arch/arm64/include/asm/kvm_host.h             |  23 +-
 arch/arm64/include/asm/kvm_hyp.h              |  15 +-
 arch/arm64/include/asm/mmu.h                  |   7 -
 arch/arm64/include/asm/virt.h                 |  13 +-
 arch/arm64/kernel/image-vars.h                |  51 +
 arch/arm64/kvm/Makefile                       |   2 +-
 arch/arm64/kvm/arm.c                          |  18 +-
 arch/arm64/kvm/hyp/Makefile                   |  24 +-
 arch/arm64/kvm/hyp/aarch32.c                  |   6 +-
 arch/arm64/kvm/hyp/entry.S                    |   1 -
 arch/arm64/kvm/hyp/fpsimd.S                   |   1 -
 arch/arm64/kvm/hyp/hyp-entry.S                |  21 +-
 .../{debug-sr.c => include/hyp/debug-sr.h}    |  78 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h       | 509 ++++++++++
 .../{sysreg-sr.c => include/hyp/sysreg-sr.h}  | 162 +--
 arch/arm64/kvm/hyp/nvhe/Makefile              |  42 +
 arch/arm64/kvm/hyp/nvhe/debug-sr.c            |  77 ++
 arch/arm64/kvm/{ => hyp/nvhe}/hyp-init.S      |  24 +-
 arch/arm64/kvm/hyp/nvhe/switch.c              | 272 +++++
 arch/arm64/kvm/hyp/nvhe/sysreg-sr.c           |  46 +
 arch/arm64/kvm/hyp/{ => nvhe}/timer-sr.c      |   6 +-
 arch/arm64/kvm/hyp/{ => nvhe}/tlb.c           | 100 +-
 arch/arm64/kvm/hyp/smccc_wa.S                 |  32 +
 arch/arm64/kvm/hyp/switch.c                   | 936 ------------------
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c      |   4 +-
 arch/arm64/kvm/hyp/vgic-v3-sr.c               | 130 ++-
 arch/arm64/kvm/hyp/vhe/Makefile               |  11 +
 arch/arm64/kvm/hyp/vhe/debug-sr.c             |  26 +
 arch/arm64/kvm/hyp/vhe/switch.c               | 219 ++++
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c            | 114 +++
 arch/arm64/kvm/hyp/vhe/timer-sr.c             |  12 +
 arch/arm64/kvm/hyp/vhe/tlb.c                  | 162 +++
 scripts/kallsyms.c                            |   1 +
 35 files changed, 1786 insertions(+), 1409 deletions(-)
 rename arch/arm64/kvm/hyp/{debug-sr.c => include/hyp/debug-sr.h} (71%)
 create mode 100644 arch/arm64/kvm/hyp/include/hyp/switch.h
 rename arch/arm64/kvm/hyp/{sysreg-sr.c => include/hyp/sysreg-sr.h} (56%)
 create mode 100644 arch/arm64/kvm/hyp/nvhe/Makefile
 create mode 100644 arch/arm64/kvm/hyp/nvhe/debug-sr.c
 rename arch/arm64/kvm/{ => hyp/nvhe}/hyp-init.S (91%)
 create mode 100644 arch/arm64/kvm/hyp/nvhe/switch.c
 create mode 100644 arch/arm64/kvm/hyp/nvhe/sysreg-sr.c
 rename arch/arm64/kvm/hyp/{ => nvhe}/timer-sr.c (84%)
 rename arch/arm64/kvm/hyp/{ => nvhe}/tlb.c (55%)
 create mode 100644 arch/arm64/kvm/hyp/smccc_wa.S
 delete mode 100644 arch/arm64/kvm/hyp/switch.c
 create mode 100644 arch/arm64/kvm/hyp/vhe/Makefile
 create mode 100644 arch/arm64/kvm/hyp/vhe/debug-sr.c
 create mode 100644 arch/arm64/kvm/hyp/vhe/switch.c
 create mode 100644 arch/arm64/kvm/hyp/vhe/sysreg-sr.c
 create mode 100644 arch/arm64/kvm/hyp/vhe/timer-sr.c
 create mode 100644 arch/arm64/kvm/hyp/vhe/tlb.c

-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
