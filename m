Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D935025A2B5;
	Tue,  7 Apr 2026 14:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775572209; cv=none; b=nW5o5HSASePpB6Xvb/91uJXT9dHryagrKswJ0dQr+8a5AcNLcGUcYF/A0h/k1wcydHDZE30IIiz87NNLJLIQxRwOiBDVdWkPftTy2ExWrHbTHIE9HpM2gS54n9xMS/o2Uncc5PaFHInp6ClYMG4HXCLd8Hu0n5D4IS9E2wh1yx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775572209; c=relaxed/simple;
	bh=F6zPippwXT9NoAaPuBCmjQXM7i5cwJ55Lk+dK97iVfo=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=QI7yCXjsu3Bfqr82+wqMmKmf9v/qyuJKCfblIhakwwPV4I6glhhMr6qzjlF5zTI96VKyt2mLRxEqgyXKT5tHV6SdUDDvYAD+jreMwQiBcHCD8DcBlT6rWox1m3vxZ7WRFCXV39uk5PZVqJ5/xuSlbtxCB+Kpmfu7QHXE8ABq4g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SGGpCilo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SGGpCilo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B4AFC116C6;
	Tue,  7 Apr 2026 14:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775572209;
	bh=F6zPippwXT9NoAaPuBCmjQXM7i5cwJ55Lk+dK97iVfo=;
	h=From:Subject:Date:To:Cc:From;
	b=SGGpCiloA16YGCNOBtnjqATKduo9VqxPftvhFTU4wQ99oD6xhZII3QIIPuZ2BteZi
	 It4oNSzT+9TV6imSaukmNALxBbaSIH04pnHw+M6T4s3hbGTZk66/6p4/JDiCZ1VdLA
	 sAQn37Sb6xna/XRQ3bokAGI4LKLj7xAfa4HSGVbr+crUhyoVjTFNNgF0zVgexUITaG
	 3oO0IctM29eF06Ko+4LKEtWm/Y5wll033MXeJp4amWrRhRc8aRdB9Fsi2Ax/RP3KVY
	 Y8DZqVWkFinHJV507eYo9FG4A3vIba8mdeHmRheb1U4J/C6vnYUKpC5VRqfkbkMLh6
	 sCi7TVjgfAdYQ==
From: "Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH v4 0/6] arm64: Add support for FEAT_Debugv8p9
Date: Tue, 07 Apr 2026 09:29:42 -0500
Message-Id: <20260407-arm-debug-8-9-v4-0-a4864e69b0ea@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIANYU1WkC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyTHQUlJIzE
 vPSU3UzU4B8JSMDIzMDEwMz3cSiXN2U1KTSdF0LXUtdE8M0szSDVHNjyyRTJaCegqLUtMwKsHn
 RsbW1ABe/erJfAAAA
X-Change-ID: 20260406-arm-debug-8-9-41f6f0e739b5
To: Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>, 
 linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, 
 Oliver Upton <oupton@kernel.org>
X-Mailer: b4 0.15-dev

This series enables FEAT_Debugv8p9 which extends the breakpoint and 
watchpoint support from 16 up to 64. I've picked up this series from 
Anshuman.

Changes in V4:

- Limit enabling of FEAT_Debugv8p9 to only when more than 16 breakpoints 
  or watchpoints are present.
- Add lockdep_assert_irqs_disabled() to document the constraints. Drop 
  unnecessary IRQ disabling.
- Add more kprobe blacklist annotations and disallow breakpoints in the 
  nokprobe code.
- Drop previously applied sysreg patches.

Prior versions from Anshuman:

Changes in V3:

https://lore.kernel.org/all/20241216040831.2448257-1-anshuman.khandual@arm.com/

- Marked ID_AA64DFR1_EL1.ABLE as FTR_NONSTRICT in ftr_id_aa64dfr1[]
- Dropped MDCR_EL3.TDA boot requirement from documentation (separate series)
- Dropped MDCR_EL2_EBWE definition as MDCR_EL2 is now defined in tools sysreg
- Used SYS_FIELD_PREP() in read_wb_reg() and write_wb_reg()
- Added MAX_PER_BANK based BUILD_BUG_ON() tests in arch_hw_breakpoint_init()
- Dropped local variables i.e mdsel_bank and index
- Derived bank and index from MAX_PER_BANK as required

Changes in V2:

https://lore.kernel.org/all/20241028053426.2486633-1-anshuman.khandual@arm.com/

Following changes have been made per review comments from Mark Rutland

- Orr MDCR_EL2_EBWE directly without an intermittent register
- Alphabetically order header files in debug-monitors.c
- Dropped embwe_ref_count mechanism
- Dropped preempt_enable() from AARCH64_DBG_READ
- Dropped preempt_disable() from AARCH64_DBG_WRITE
- Dropped set_bank_index()
- Renamed read/write_wb_reg() as __read/__write_wb_reg()
- Modified read/write_wb_reg() to have MDSELR_E1 based banked read/write
- Added required sysreg tools patches from KVM FEAT_FGT2 series for build

Changes in V1:

https://lore.kernel.org/all/20241001043602.1116991-1-anshuman.khandual@arm.com/

- Changed FTR_STRICT to FTR_NONSTRICT for the following ID_AA64DFR1_EL1
  register fields - ABL_CMPs, DPFZS, PMICNTR, CTX_CMPs, WRPs and BRPs

Changes in RFC V2:

https://lore.kernel.org/linux-arm-kernel/20240620092607.267132-1-anshuman.khandual@arm.com/

- This series has been split from RFC V1 dealing only with arm64 breakpoints
- Restored back DBG_MDSCR_MASK definition (unrelated change)
- Added preempt_disable()/enable() blocks between selecting banks and registers

Changes in RFC:

https://lore.kernel.org/all/20240405080008.1225223-1-anshuman.khandual@arm.com/

Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
---
Anshuman Khandual (3):
      arm64/cpufeature: Add field details for ID_AA64DFR1_EL1 register
      arm64/boot: Enable EL2 requirements for FEAT_Debugv8p9
      arm64: hw_breakpoint: Enable FEAT_Debugv8p9

Rob Herring (Arm) (3):
      arm64: hw_breakpoint: Disallow breakpoints in no kprobe code
      arm64: hw_breakpoint: Add additional kprobe excluded functions
      arm64: hw_breakpoint: Add lockdep_assert_irqs_disabled() on install/uninstall

 Documentation/arch/arm64/booting.rst   | 13 +++++++
 arch/arm64/include/asm/el2_setup.h     | 14 +++++++
 arch/arm64/include/asm/hw_breakpoint.h | 47 ++++++++++++++++++-----
 arch/arm64/kernel/cpufeature.c         | 21 ++++++++---
 arch/arm64/kernel/debug-monitors.c     | 16 +++++---
 arch/arm64/kernel/hw_breakpoint.c      | 68 +++++++++++++++++++++++++++++-----
 6 files changed, 150 insertions(+), 29 deletions(-)
---
base-commit: 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f
change-id: 20260406-arm-debug-8-9-41f6f0e739b5

Best regards,
--  
Rob Herring (Arm) <robh@kernel.org>

