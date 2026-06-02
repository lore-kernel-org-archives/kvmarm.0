Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 487173E9F76
	for <kvmarm@lists.linux.dev>; Tue,  2 Jun 2026 15:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780413124; cv=none; b=kfMGXmugpONEY6X+JuUy6N6fJDMA9k3Uc2Hb6nxR0+AK9GC+DIprIlkxj59a7cWBuKE2t2RmfmIC45fZygH51I+pdmhPrneloJgsRRohhusr+pZCbOjtaDU6GrDy54fMbzLzn3knhiXow8M2QX5rwqZk6QzCP9XfS5trOuLOTR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780413124; c=relaxed/simple;
	bh=yvzqlqjGgLCgIP9jWOj2bAwL1GBYl1xZuYdCYJ1JYhc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NK6ES8H573yqphjwmyNcEd8eU2dNc1dnWlXTbuARR/4iug1EEVgrQmCRioniX4bm9FOAwh5RS85wqGSIbRVVT6GOrQJtie0X8NijcENYubMuMUOArkxcCe3NbWdGFJjM0nT4JeD9RZF9VKJBQUMPlXq3gOQIAmOpkBnkSMxau9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=UyhKNZkU; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="UyhKNZkU"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D01AF3573;
	Tue,  2 Jun 2026 08:11:57 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 684A13F905;
	Tue,  2 Jun 2026 08:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780413122; bh=yvzqlqjGgLCgIP9jWOj2bAwL1GBYl1xZuYdCYJ1JYhc=;
	h=From:To:Cc:Subject:Date:From;
	b=UyhKNZkU05ypheVNB5ygr+hct8bpXWXZwc0Hw9t09nsMODZvvk7qY1S4JxiM5kAJK
	 qMkEvr4CCXS1LTWHBQ0pzbU+lxlVVn3aCOEzuTDkwKw6RpJCOWN0umVEnyRuNERr3l
	 sdZ6T8czKrMdUBKSt8W0O/kZNJerntoYn8EXENi0=
From: Mark Rutland <mark.rutland@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: broonie@kernel.org,
	catalin.marinas@arm.com,
	james.morse@arm.com,
	mark.rutland@arm.com,
	maz@kernel.org,
	oupton@kernel.org,
	tabba@google.com,
	vladimir.murzin@arm.com,
	will@kernel.org
Subject: [PATCH v3 00/18] arm64+KVM: FPSIMD/SVE/SME cleanups
Date: Tue,  2 Jun 2026 16:11:32 +0100
Message-Id: <20260602151150.925126-1-mark.rutland@arm.com>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi.

This series cleans up low-level FPSIMD/SVE/SME state management code,
making it easier to maintain and extend (e.g. adding SME support to
KVM), and enabling better debugging (e.g. by making SVE/SME save/restore
visible to KASAN and KCSAN).

This is purely cleanup, there are NO bugs addressed by this series.

The series aims to do a few key things:

* Make it harder to mis-manage in-memory SVE state and SME state. These
  are given opaque types (struct sve_state and struct sme_state), and
  the (awkward) calling convention for saving/restoring SVE state is
  simplified to take a pointer to the base of the state rather than a
  pointer to the FFR within the state.

* Minimize duplications between KVM and the rest of the kernel. The
  FPSIMD/SVE/SME routines are moved to inline assembly such that the
  same helper functions can be used everywhere, without the need to wrap
  assembly macros.

* Make the code easier to follow. Assembly sequences are minimized to
  avoid address generation and control-flow that can be written more
  clearly in C. Awkward assembly macros are removed where possible.

* Make it easier to debug state management. Explicit instrumentation is
  added to the save/restore functions so that KASAN and KCSAN can detect
  memory safety issues and concurrency issues.

  This instrumentation is inhibited for nVHE hyp objects, and does not
  adversely affect KVM. I've confirmed by looking at compiler flags
  during the build, and disassembling the relevant object files.

* Remove unnecessary code. By relying on assembler support for SVE and
  SME we can remove awkward assembly macros, making the code
  significantly simpler and easier to read.

Since v1 [1]:
* Add missing '.arch_extension sve' in asm.
* Fix FPCR.Z field name.
* Note the 'Ucj' constraint, and why we don't use it (yet).
* Add missing 'const' usage.
* Updates to commit messages.
* Add tags from Mark Brown and Vladimir Murzin.

Since v2 [2]:
* Rename struct sme_state to struct arm64_sme_state to avoid clash with enum
  sme_state in drivers.
* Rename struct sve_state to struct arm64_sve_state, to match arm64_sme_state.
* Fix instrumentation for ZT0 to use 64 bytes (512-bit), not SVL.
* Fix typos in commit messages.

[1] https://lore.kernel.org/linux-arm-kernel/20260521132556.584676-1-mark.rutland@arm.com/
[2] https://lore.kernel.org/linux-arm-kernel/20260528165446.701944-1-mark.rutland@arm.com/

Mark.

Mark Rutland (18):
  KVM: arm64: Don't include <asm/fpsimdmacros.h>
  KVM: arm64: Don't override FFR save/restore argument
  KVM: arm64: pkvm: Save host FPMR in host cpu context
  KVM: arm64: pkvm: Remove struct cpu_sve_state
  arm64: fpsimd: Fold sve_init_regs() into do_sve_acc()
  arm64: fpsimd: Remove sve_set_vq() and sme_set_vq()
  arm64: fpsimd: Use assembler for SVE instructions
  arm64: fpsimd: Use assembler for baseline SME instructions
  arm64: fpsimd: Move sve_get_vl() and sme_get_vl() inline
  arm64: sysreg: Add FPCR and FPSR
  arm64: fpsimd: Split FPSR/FPCR from SVE save/restore
  arm64: fpsimd: Move fpsimd save/restore inline
  arm64: fpsimd: Use opaque type for SVE state
  arm64: fpsimd: Use opaque type for SME state
  arm64: fpsimd: Move SVE save/restore inline
  arm64: fpsimd: Move sve_flush_live() inline
  arm64: fpsimd: Move SME save/restore inline
  arm64: fpsimd: Remove <asm/fpsimdmacros.h>

 arch/arm64/Kconfig                      |   5 +
 arch/arm64/include/asm/fpsimd.h         | 374 ++++++++++++++++++++++--
 arch/arm64/include/asm/fpsimdmacros.h   | 357 ----------------------
 arch/arm64/include/asm/kvm_host.h       |  27 +-
 arch/arm64/include/asm/kvm_hyp.h        |   5 -
 arch/arm64/include/asm/kvm_pkvm.h       |   3 +-
 arch/arm64/include/asm/processor.h      |   7 +-
 arch/arm64/kernel/Makefile              |   2 +-
 arch/arm64/kernel/entry-common.c        |   8 +-
 arch/arm64/kernel/entry-fpsimd.S        | 134 ---------
 arch/arm64/kernel/fpsimd.c              |  90 +++---
 arch/arm64/kvm/arm.c                    |  16 +-
 arch/arm64/kvm/guest.c                  |   4 +-
 arch/arm64/kvm/hyp/entry.S              |   1 -
 arch/arm64/kvm/hyp/fpsimd.S             |  33 ---
 arch/arm64/kvm/hyp/include/hyp/switch.h |  23 +-
 arch/arm64/kvm/hyp/nvhe/Makefile        |   2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  20 +-
 arch/arm64/kvm/hyp/nvhe/setup.c         |   4 +-
 arch/arm64/kvm/hyp/vhe/Makefile         |   2 +-
 arch/arm64/tools/sysreg                 |  45 +++
 21 files changed, 485 insertions(+), 677 deletions(-)
 delete mode 100644 arch/arm64/include/asm/fpsimdmacros.h
 delete mode 100644 arch/arm64/kernel/entry-fpsimd.S
 delete mode 100644 arch/arm64/kvm/hyp/fpsimd.S

-- 
2.30.2

