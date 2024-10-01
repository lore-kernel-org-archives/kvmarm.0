Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B71711B86C3
	for <kvmarm@lists.linux.dev>; Tue,  1 Oct 2024 04:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727757384; cv=none; b=XjZ7JWZWZQp+l3WmT4uzN1xaK3Z+Z9ClfkSdUMu14igOPZl7+z1HNsmvl1UwEWZQ3SYL0qbuoEKHt3AxifW85dpv5ABynLEKPsprTdWwFyLIpuCRe5c79ThKlNlPb+ksgcZPgRPn9KVlbLMnocDo2DkS9pC1M7s/jPAb/s+YJDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727757384; c=relaxed/simple;
	bh=jNMnAtlVBE7KJ3eRs67wCvFiwM5szzlTZ+ig/4QzQx8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uC2bRP7G1a91Q/kF+v50rFmgGO8x0uueZTPrAmqQcOvjw4q+nejH2+frnLJe3NuZTCFz9Ns2QLExqOXAHCISY+SteUzw6bt4Pvf1ZafVuZuEUfMTEgZ7d8ACpuXHrE7pL9qyVACds3h0+rpgelbk097DqSojCThqOnF/FLyM/HQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D37E2339;
	Mon, 30 Sep 2024 21:36:51 -0700 (PDT)
Received: from a077893.blr.arm.com (a077893.blr.arm.com [10.162.16.61])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 2A5463F58B;
	Mon, 30 Sep 2024 21:36:17 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	kvmarm@lists.linux.dev,
	linux-doc@vger.kernel.org
Subject: [PATCH 2/3] arm64/boot: Enable EL2 requirements for FEAT_Debugv8p9
Date: Tue,  1 Oct 2024 10:06:01 +0530
Message-Id: <20241001043602.1116991-3-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241001043602.1116991-1-anshuman.khandual@arm.com>
References: <20241001043602.1116991-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fine grained trap control for MDSELR_EL1 register needs to be configured in
HDFGRTR2_EL2, and HDFGWTR2_EL2 registers when kernel enters at EL1, but EL2
is also present. This adds a new helper __init_el2_fgt2() initializing this
new FEAT_FGT2 based fine grained registers.

MDCR_EL2.EBWE needs to be enabled for additional (beyond 16) breakpoint and
watchpoint exceptions when kernel enters at EL1, but EL2 is also present.
This updates __init_el2_debug() as required for FEAT_Debugv8p9.

While here, also update booting.rst with MDCR_EL3 and SCR_EL3 requirements.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: kvmarm@lists.linux.dev
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 Documentation/arch/arm64/booting.rst | 19 +++++++++++++++++++
 arch/arm64/include/asm/el2_setup.h   | 27 +++++++++++++++++++++++++++
 arch/arm64/include/asm/kvm_arm.h     |  1 +
 3 files changed, 47 insertions(+)

diff --git a/Documentation/arch/arm64/booting.rst b/Documentation/arch/arm64/booting.rst
index b57776a68f15..e69d972018cf 100644
--- a/Documentation/arch/arm64/booting.rst
+++ b/Documentation/arch/arm64/booting.rst
@@ -285,6 +285,12 @@ Before jumping into the kernel, the following conditions must be met:
 
     - SCR_EL3.FGTEn (bit 27) must be initialised to 0b1.
 
+  For CPUs with the Fine Grained Traps (FEAT_FGT2) extension present:
+
+  - If EL3 is present and the kernel is entered at EL2:
+
+    - SCR_EL3.FGTEn2 (bit 59) must be initialised to 0b1.
+
   For CPUs with support for HCRX_EL2 (FEAT_HCX) present:
 
   - If EL3 is present and the kernel is entered at EL2:
@@ -319,6 +325,19 @@ Before jumping into the kernel, the following conditions must be met:
     - ZCR_EL2.LEN must be initialised to the same value for all CPUs the
       kernel will execute on.
 
+  For CPUs with FEAT_Debugv8p9 extension present:
+
+  - If the kernel is entered at EL1 and EL2 is present:
+
+    - HDFGRTR2_EL2.nMDSELR_EL1 (bit 5) must be initialized to 0b1
+    - HDFGWTR2_EL2.nMDSELR_EL1 (bit 5) must be initialized to 0b1
+    - MDCR_EL2.EBWE (bit 43) must be initialized to 0b1
+
+  - If EL3 is present:
+
+    - MDCR_EL3.TDA (bit 9) must be initialized to 0b0
+    - MDCR_EL3.EBWE (bit 43) must be initialized to 0b1
+
   For CPUs with the Scalable Matrix Extension (FEAT_SME):
 
   - If EL3 is present:
diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index e0ffdf13a18b..2e6a8de5e4e4 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -97,6 +97,14 @@
 						// to own it.
 
 .Lskip_trace_\@:
+	mrs	x1, id_aa64dfr0_el1
+	ubfx	x1, x1, #ID_AA64DFR0_EL1_DebugVer_SHIFT, #4
+	cmp	x1, #ID_AA64DFR0_EL1_DebugVer_V8P9
+	b.lt	.Lskip_dbg_v8p9_\@
+
+	mov	x0, #MDCR_EL2_EBWE
+	orr	x2, x2, x0
+.Lskip_dbg_v8p9_\@:
 	msr	mdcr_el2, x2			// Configure debug traps
 .endm
 
@@ -215,6 +223,24 @@
 .Lskip_fgt_\@:
 .endm
 
+.macro __init_el2_fgt2
+	mrs	x1, id_aa64mmfr0_el1
+	ubfx	x1, x1, #ID_AA64MMFR0_EL1_FGT_SHIFT, #4
+	cmp	x1, #ID_AA64MMFR0_EL1_FGT_FGT2
+	b.lt	.Lskip_fgt2_\@
+
+	mrs	x1, id_aa64dfr0_el1
+	ubfx	x1, x1, #ID_AA64DFR0_EL1_DebugVer_SHIFT, #4
+	cmp	x1, #ID_AA64DFR0_EL1_DebugVer_V8P9
+	b.lt	.Lskip_dbg_v8p9_\@
+
+	mov_q   x0, HDFGWTR2_EL2_nMDSELR_EL1
+	msr_s	SYS_HDFGWTR2_EL2, x0
+	msr_s	SYS_HDFGRTR2_EL2, x0
+.Lskip_dbg_v8p9_\@:
+.Lskip_fgt2_\@:
+.endm
+
 .macro __init_el2_nvhe_prepare_eret
 	mov	x0, #INIT_PSTATE_EL1
 	msr	spsr_el2, x0
@@ -240,6 +266,7 @@
 	__init_el2_nvhe_idregs
 	__init_el2_cptr
 	__init_el2_fgt
+	__init_el2_fgt2
 .endm
 
 #ifndef __KVM_NVHE_HYPERVISOR__
diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 850fac9a7840..18aeec43efc2 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -312,6 +312,7 @@
 				 GENMASK(15, 0))
 
 /* Hyp Debug Configuration Register bits */
+#define MDCR_EL2_EBWE		(UL(1) << 43)
 #define MDCR_EL2_E2TB_MASK	(UL(0x3))
 #define MDCR_EL2_E2TB_SHIFT	(UL(24))
 #define MDCR_EL2_HPMFZS		(UL(1) << 36)
-- 
2.25.1

