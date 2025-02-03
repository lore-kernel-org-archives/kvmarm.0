Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE471DDC1B;
	Mon,  3 Feb 2025 00:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738543414; cv=none; b=j4G8/AXCVkSVJdcPzxOeJvNGpn5ewC0fXX6ZWMyp/dSF40qydFQQgP1GruLPLUv/Exf8l+JkRjmf5oBRKoVAmUu/g3ggPd3NGPDuq5+PSjd2p2fd6OA0ya431n4HmEISC+I41Z+AXMiZiu8sEa6NpRcsyUgThcKVP/Rx7QhERk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738543414; c=relaxed/simple;
	bh=UvhWz4QMJq7nUIMWUztfZUFcC7JB9nRQ0ZkYVGZaW+Q=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=rgHxM3mHhiGc9jUgsOVcubSwxG6ktMaT7vvbr56MaVLh+ELBQIVYabasFHVaJ+PAO2bIZBBfraPtWyXdyUlYy/IheG015wWC+Fh3Wz7MPCkBM7W6EfGoiEt5OTFDDyeX3BAJRKr+eeAl7YX6r3E6QIqgN7EslhH5kCyKF5g9hAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZOFiYs4n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZOFiYs4n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 147F9C4CED1;
	Mon,  3 Feb 2025 00:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738543414;
	bh=UvhWz4QMJq7nUIMWUztfZUFcC7JB9nRQ0ZkYVGZaW+Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ZOFiYs4nlI5YjUNkNTP26ucBkXrM7ZxT8XXhnjgk/BEMzas/Z42tWdjtIRy61oLk5
	 Jf8+Il6fCGDtkoY7+Nj52zgymAhm94sufBFjnFfeKh6K5dtWWm/Go4zoO3hlWbhphI
	 gyK4wmw/Rb5dEzH3diA9jim46gi/FrS2TDAoUUUYOv1UH5Blt6v9CualK7nliI5u7o
	 l2HiK/2261nHsXOyxYe3dRfW7TbbT5quxiOwX4hdrGRq345nXmHcdvsAjdiJ4Gsi7g
	 v1hxj+2jm3O4tvTJ0h9M4+lm8RWer2qhI+qfgXHLW5CwwMg4dnBGLxc5+ch4oIRKPy
	 SZyPpyTcb0WAA==
From: "Rob Herring (Arm)" <robh@kernel.org>
Date: Sun, 02 Feb 2025 18:43:05 -0600
Subject: [PATCH v19 11/11] perf: arm_pmuv3: Add support for the Branch
 Record Buffer Extension (BRBE)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250202-arm-brbe-v19-v19-11-1c1300802385@kernel.org>
References: <20250202-arm-brbe-v19-v19-0-1c1300802385@kernel.org>
In-Reply-To: <20250202-arm-brbe-v19-v19-0-1c1300802385@kernel.org>
To: Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Jonathan Corbet <corbet@lwn.net>, 
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, James Clark <james.clark@linaro.org>, 
 Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 kvmarm@lists.linux.dev
X-Mailer: b4 0.15-dev

From: Anshuman Khandual <anshuman.khandual@arm.com>

The ARMv9.2 architecture introduces the optional Branch Record Buffer
Extension (BRBE), which records information about branches as they are
executed into set of branch record registers. BRBE is similar to x86's
Last Branch Record (LBR) and PowerPC's Branch History Rolling Buffer
(BHRB).

BRBE supports filtering by exception level and can filter just the
source or target address if excluded to avoid leaking privileged
addresses. The h/w filter would be sufficient except when there are
multiple events with disjoint filtering requirements. In this case, BRBE
is configured with a union of all the events' desired branches, and then
the recorded branches are filtered based on each event's filter. For
example, with one event capturing kernel events and another event
capturing user events, BRBE will be configured to capture both kernel
and user branches. When handling event overflow, the branch records have
to be filtered by software to only include kernel or user branch
addresses for that event. In contrast, x86 simply configures LBR using
the last installed event which seems broken.

The event and branch exception level filtering are separately
controlled. On x86, it is possible to request filtering which is
disjoint (e.g. kernel only event with user only branches). It is also
possible on x86 to configure branch filter such that no branches are
ever recorded (e.g. -j save_type). For BRBE, events with mismatched
exception level filtering or a configuration that will result in no
samples are rejected. This can be relaxed in the future if such a need
arises.

The handling of KVM guests is similar to the above. On x86, branch
recording is always disabled when a guest is running. However,
requesting branch recording in guests is allowed. The guest events are
recorded, but the resulting branches are all from the host. For BRBE,
branch recording is similarly disabled when guest is running. In
addition, events with branch recording and "exclude_host" set are
rejected. Requiring "exclude_guest" to be set did not work. The default
for the perf tool does set "exclude_guest" if no exception level
options are specified. However, specifying kernel or user defaults to
including both host and guest. In this case, only host branches are
recorded.

BRBE can support some additional exception, FIQ, and debug branch
types, but they are not supported currently. There's no control in the
perf ABI to enable/disable these branch types, so they could only be
enabled for the 'any' filter which might be undesired or unexpected.
The other architectures don't have any support similar events (at least
with perf). These can be added in the future if there is demand by
adding additional specific filter types.

BRBE records are invalidated whenever events are reconfigured, a new
task is scheduled in, or after recording is paused (and the records
have been recorded for the event). The architecture allows branch
records to be invalidated by the PE under implementation defined
conditions. It is expected that these conditions are rare.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Co-developed-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Co-developed-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
---
v19:
- Drop saving of branch records when task scheduled out. (Mark)
- Got rid of added armpmu ops. All BRBE support contained within pmuv3
  code.
- Dropped armpmu.num_branch_records as reg_brbidr has same info.
- Make sched_task() callback actually get called. Enabling requires a
  call to perf_sched_cb_inc().
- Fix freeze on overflow for VHE
- The cycle counter doesn't freeze BRBE on overflow, so avoid assigning
  it when BRBE is enabled.
- Drop all the Arm specific exception branches. Not a clear need for
  them.
- Simplify enable/disable to avoid RMW and document ISBs needed
- Fix handling of branch 'cycles' reading. CC field is
  mantissa/exponent, not an integer.
- Save BRBFCR and BRBCR settings in event->hw.branch_reg.config and
  event->hw.extra_reg.config to avoid recalculating the register value
  each time the event is installed.
- Rework s/w filtering to better match h/w filtering
- Reject events with disjoint event filter and branch filter
- Reject events if exclude_host is set

v18: https://lore.kernel.org/all/20240613061731.3109448-6-anshuman.khandual@arm.com/
---
 drivers/perf/Kconfig         |  11 +
 drivers/perf/Makefile        |   1 +
 drivers/perf/arm_brbe.c      | 794 +++++++++++++++++++++++++++++++++++++++++++
 drivers/perf/arm_brbe.h      |  47 +++
 drivers/perf/arm_pmu.c       |  15 +-
 drivers/perf/arm_pmuv3.c     |  87 ++++-
 include/linux/perf/arm_pmu.h |   8 +
 7 files changed, 958 insertions(+), 5 deletions(-)

diff --git a/drivers/perf/Kconfig b/drivers/perf/Kconfig
index 4e268de351c4..3be60ff4236d 100644
--- a/drivers/perf/Kconfig
+++ b/drivers/perf/Kconfig
@@ -223,6 +223,17 @@ config ARM_SPE_PMU
 	  Extension, which provides periodic sampling of operations in
 	  the CPU pipeline and reports this via the perf AUX interface.
 
+config ARM64_BRBE
+	bool "Enable support for branch stack sampling using FEAT_BRBE"
+	depends on ARM_PMUV3 && ARM64
+	default y
+	help
+	  Enable perf support for Branch Record Buffer Extension (BRBE) which
+	  records all branches taken in an execution path. This supports some
+	  branch types and privilege based filtering. It captures additional
+	  relevant information such as cycle count, misprediction and branch
+	  type, branch privilege level etc.
+
 config ARM_DMC620_PMU
 	tristate "Enable PMU support for the ARM DMC-620 memory controller"
 	depends on (ARM64 && ACPI) || COMPILE_TEST
diff --git a/drivers/perf/Makefile b/drivers/perf/Makefile
index de71d2574857..192fc8b16204 100644
--- a/drivers/perf/Makefile
+++ b/drivers/perf/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_STARFIVE_STARLINK_PMU) += starfive_starlink_pmu.o
 obj-$(CONFIG_THUNDERX2_PMU) += thunderx2_pmu.o
 obj-$(CONFIG_XGENE_PMU) += xgene_pmu.o
 obj-$(CONFIG_ARM_SPE_PMU) += arm_spe_pmu.o
+obj-$(CONFIG_ARM64_BRBE) += arm_brbe.o
 obj-$(CONFIG_ARM_DMC620_PMU) += arm_dmc620_pmu.o
 obj-$(CONFIG_MARVELL_CN10K_TAD_PMU) += marvell_cn10k_tad_pmu.o
 obj-$(CONFIG_MARVELL_CN10K_DDR_PMU) += marvell_cn10k_ddr_pmu.o
diff --git a/drivers/perf/arm_brbe.c b/drivers/perf/arm_brbe.c
new file mode 100644
index 000000000000..18eb9bfa1f9c
--- /dev/null
+++ b/drivers/perf/arm_brbe.c
@@ -0,0 +1,794 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Branch Record Buffer Extension Driver.
+ *
+ * Copyright (C) 2022-2025 ARM Limited
+ *
+ * Author: Anshuman Khandual <anshuman.khandual@arm.com>
+ */
+#include <linux/types.h>
+#include <linux/bitmap.h>
+#include <linux/perf/arm_pmu.h>
+#include "arm_brbe.h"
+
+#define BRBFCR_EL1_BRANCH_FILTERS (BRBFCR_EL1_DIRECT   | \
+				   BRBFCR_EL1_INDIRECT | \
+				   BRBFCR_EL1_RTN      | \
+				   BRBFCR_EL1_INDCALL  | \
+				   BRBFCR_EL1_DIRCALL  | \
+				   BRBFCR_EL1_CONDDIR)
+
+/*
+ * BRBTS_EL1 is currently not used for branch stack implementation
+ * purpose but BRBCR_ELx.TS needs to have a valid value from all
+ * available options. BRBCR_ELx_TS_VIRTUAL is selected for this.
+ */
+#define BRBCR_ELx_DEFAULT_TS      FIELD_PREP(BRBCR_ELx_TS_MASK, BRBCR_ELx_TS_VIRTUAL)
+
+/*
+ * BRBE Buffer Organization
+ *
+ * BRBE buffer is arranged as multiple banks of 32 branch record
+ * entries each. An individual branch record in a given bank could
+ * be accessed, after selecting the bank in BRBFCR_EL1.BANK and
+ * accessing the registers i.e [BRBSRC, BRBTGT, BRBINF] set with
+ * indices [0..31].
+ *
+ * Bank 0
+ *
+ *	---------------------------------	------
+ *	| 00 | BRBSRC | BRBTGT | BRBINF |	| 00 |
+ *	---------------------------------	------
+ *	| 01 | BRBSRC | BRBTGT | BRBINF |	| 01 |
+ *	---------------------------------	------
+ *	| .. | BRBSRC | BRBTGT | BRBINF |	| .. |
+ *	---------------------------------	------
+ *	| 31 | BRBSRC | BRBTGT | BRBINF |	| 31 |
+ *	---------------------------------	------
+ *
+ * Bank 1
+ *
+ *	---------------------------------	------
+ *	| 32 | BRBSRC | BRBTGT | BRBINF |	| 00 |
+ *	---------------------------------	------
+ *	| 33 | BRBSRC | BRBTGT | BRBINF |	| 01 |
+ *	---------------------------------	------
+ *	| .. | BRBSRC | BRBTGT | BRBINF |	| .. |
+ *	---------------------------------	------
+ *	| 63 | BRBSRC | BRBTGT | BRBINF |	| 31 |
+ *	---------------------------------	------
+ */
+#define BRBE_BANK_MAX_ENTRIES	32
+#define BRBE_MAX_BANK		2
+#define BRBE_MAX_ENTRIES	(BRBE_BANK_MAX_ENTRIES * BRBE_MAX_BANK)
+
+struct brbe_regset {
+	unsigned long brbsrc;
+	unsigned long brbtgt;
+	unsigned long brbinf;
+};
+
+#define PERF_BR_ARM64_MAX (PERF_BR_MAX + PERF_BR_NEW_MAX)
+
+struct brbe_hw_attr {
+	int	brbe_version;
+	int	brbe_cc;
+	int	brbe_nr;
+	int	brbe_format;
+};
+
+#define BRBE_REGN_CASE(n, case_macro) \
+	case n: case_macro(n); break
+
+#define BRBE_REGN_SWITCH(x, case_macro)				\
+	do {							\
+		switch (x) {					\
+		BRBE_REGN_CASE(0, case_macro);			\
+		BRBE_REGN_CASE(1, case_macro);			\
+		BRBE_REGN_CASE(2, case_macro);			\
+		BRBE_REGN_CASE(3, case_macro);			\
+		BRBE_REGN_CASE(4, case_macro);			\
+		BRBE_REGN_CASE(5, case_macro);			\
+		BRBE_REGN_CASE(6, case_macro);			\
+		BRBE_REGN_CASE(7, case_macro);			\
+		BRBE_REGN_CASE(8, case_macro);			\
+		BRBE_REGN_CASE(9, case_macro);			\
+		BRBE_REGN_CASE(10, case_macro);			\
+		BRBE_REGN_CASE(11, case_macro);			\
+		BRBE_REGN_CASE(12, case_macro);			\
+		BRBE_REGN_CASE(13, case_macro);			\
+		BRBE_REGN_CASE(14, case_macro);			\
+		BRBE_REGN_CASE(15, case_macro);			\
+		BRBE_REGN_CASE(16, case_macro);			\
+		BRBE_REGN_CASE(17, case_macro);			\
+		BRBE_REGN_CASE(18, case_macro);			\
+		BRBE_REGN_CASE(19, case_macro);			\
+		BRBE_REGN_CASE(20, case_macro);			\
+		BRBE_REGN_CASE(21, case_macro);			\
+		BRBE_REGN_CASE(22, case_macro);			\
+		BRBE_REGN_CASE(23, case_macro);			\
+		BRBE_REGN_CASE(24, case_macro);			\
+		BRBE_REGN_CASE(25, case_macro);			\
+		BRBE_REGN_CASE(26, case_macro);			\
+		BRBE_REGN_CASE(27, case_macro);			\
+		BRBE_REGN_CASE(28, case_macro);			\
+		BRBE_REGN_CASE(29, case_macro);			\
+		BRBE_REGN_CASE(30, case_macro);			\
+		BRBE_REGN_CASE(31, case_macro);			\
+		default: WARN(1, "Invalid BRB* index %d\n", x);	\
+		}						\
+	} while (0)
+
+#define RETURN_READ_BRBSRCN(n) \
+	return read_sysreg_s(SYS_BRBSRC_EL1(n))
+static inline u64 get_brbsrc_reg(int idx)
+{
+	BRBE_REGN_SWITCH(idx, RETURN_READ_BRBSRCN);
+	return 0;
+}
+
+#define RETURN_READ_BRBTGTN(n) \
+	return read_sysreg_s(SYS_BRBTGT_EL1(n))
+static u64 get_brbtgt_reg(int idx)
+{
+	BRBE_REGN_SWITCH(idx, RETURN_READ_BRBTGTN);
+	return 0;
+}
+
+#define RETURN_READ_BRBINFN(n) \
+	return read_sysreg_s(SYS_BRBINF_EL1(n))
+static u64 get_brbinf_reg(int idx)
+{
+	BRBE_REGN_SWITCH(idx, RETURN_READ_BRBINFN);
+	return 0;
+}
+
+static u64 brbe_record_valid(u64 brbinf)
+{
+	return FIELD_GET(BRBINFx_EL1_VALID_MASK, brbinf);
+}
+
+static bool brbe_invalid(u64 brbinf)
+{
+	return brbe_record_valid(brbinf) == BRBINFx_EL1_VALID_NONE;
+}
+
+static bool brbe_record_is_complete(u64 brbinf)
+{
+	return brbe_record_valid(brbinf) == BRBINFx_EL1_VALID_FULL;
+}
+
+static bool brbe_record_is_source_only(u64 brbinf)
+{
+	return brbe_record_valid(brbinf) == BRBINFx_EL1_VALID_SOURCE;
+}
+
+static bool brbe_record_is_target_only(u64 brbinf)
+{
+	return brbe_record_valid(brbinf) == BRBINFx_EL1_VALID_TARGET;
+}
+
+static int brbinf_get_in_tx(u64 brbinf)
+{
+	return FIELD_GET(BRBINFx_EL1_T_MASK, brbinf);
+}
+
+static int brbinf_get_mispredict(u64 brbinf)
+{
+	return FIELD_GET(BRBINFx_EL1_MPRED_MASK, brbinf);
+}
+
+static int brbinf_get_lastfailed(u64 brbinf)
+{
+	return FIELD_GET(BRBINFx_EL1_LASTFAILED_MASK, brbinf);
+}
+
+static u16 brbinf_get_cycles(u64 brbinf)
+{
+	u32 exp, mant, cycles;
+	/*
+	 * Captured cycle count is unknown and hence
+	 * should not be passed on to userspace.
+	 */
+	if (brbinf & BRBINFx_EL1_CCU)
+		return 0;
+
+	exp = FIELD_GET(BRBINFx_EL1_CC_EXP_MASK, brbinf);
+	mant = FIELD_GET(BRBINFx_EL1_CC_MANT_MASK, brbinf);
+
+	if (!exp)
+		return mant;
+
+	cycles = (mant | 0x100) << (exp - 1);
+
+	return (cycles > U16_MAX) ? U16_MAX : cycles;
+}
+
+static int brbinf_get_type(u64 brbinf)
+{
+	return FIELD_GET(BRBINFx_EL1_TYPE_MASK, brbinf);
+}
+
+static int brbinf_get_el(u64 brbinf)
+{
+	return FIELD_GET(BRBINFx_EL1_EL_MASK, brbinf);
+}
+
+static void brbe_invalidate_nosync(void)
+{
+	asm volatile(BRB_IALL_INSN);
+}
+
+void brbe_invalidate(void)
+{
+	// Ensure all branches before this point are recorded
+	isb();
+	brbe_invalidate_nosync();
+	// Ensure all branch records are invalidated after this point
+	isb();
+}
+
+static bool valid_brbe_nr(int brbe_nr)
+{
+	return brbe_nr == BRBIDR0_EL1_NUMREC_8 ||
+	       brbe_nr == BRBIDR0_EL1_NUMREC_16 ||
+	       brbe_nr == BRBIDR0_EL1_NUMREC_32 ||
+	       brbe_nr == BRBIDR0_EL1_NUMREC_64;
+}
+
+static bool valid_brbe_cc(int brbe_cc)
+{
+	return brbe_cc == BRBIDR0_EL1_CC_20_BIT;
+}
+
+static bool valid_brbe_format(int brbe_format)
+{
+	return brbe_format == BRBIDR0_EL1_FORMAT_FORMAT_0;
+}
+
+static bool valid_brbidr(u64 brbidr)
+{
+	int brbe_format, brbe_cc, brbe_nr;
+
+	brbe_format = FIELD_GET(BRBIDR0_EL1_FORMAT_MASK, brbidr);
+	brbe_cc = FIELD_GET(BRBIDR0_EL1_CC_MASK, brbidr);
+	brbe_nr = FIELD_GET(BRBIDR0_EL1_NUMREC_MASK, brbidr);
+
+	return valid_brbe_format(brbe_format) && valid_brbe_cc(brbe_cc) && valid_brbe_nr(brbe_nr);
+}
+
+static bool valid_brbe_version(int brbe_version)
+{
+	return brbe_version == ID_AA64DFR0_EL1_BRBE_IMP ||
+	       brbe_version == ID_AA64DFR0_EL1_BRBE_BRBE_V1P1;
+}
+
+static void select_brbe_bank(int bank)
+{
+	u64 brbfcr;
+
+	brbfcr = read_sysreg_s(SYS_BRBFCR_EL1);
+	brbfcr &= ~BRBFCR_EL1_BANK_MASK;
+	brbfcr |= SYS_FIELD_PREP(BRBFCR_EL1, BANK, bank);
+	write_sysreg_s(brbfcr, SYS_BRBFCR_EL1);
+	/*
+	 * Arm ARM (DDI 0487K.a) D.18.4 rule PPBZP requires explicit sync
+	 * between setting BANK and accessing branch records.
+	 */
+	isb();
+}
+
+static bool __read_brbe_regset(struct brbe_regset *entry, int idx)
+{
+	entry->brbinf = get_brbinf_reg(idx);
+
+	if (brbe_invalid(entry->brbinf))
+		return false;
+
+	entry->brbsrc = get_brbsrc_reg(idx);
+	entry->brbtgt = get_brbtgt_reg(idx);
+	return true;
+}
+
+/*
+ * Generic perf branch filters supported on BRBE
+ *
+ * New branch filters need to be evaluated whether they could be supported on
+ * BRBE. This ensures that such branch filters would not just be accepted, to
+ * fail silently. PERF_SAMPLE_BRANCH_HV is a special case that is selectively
+ * supported only on platforms where kernel is in hyp mode.
+ */
+#define BRBE_EXCLUDE_BRANCH_FILTERS (PERF_SAMPLE_BRANCH_ABORT_TX	| \
+				     PERF_SAMPLE_BRANCH_IN_TX		| \
+				     PERF_SAMPLE_BRANCH_NO_TX		| \
+				     PERF_SAMPLE_BRANCH_CALL_STACK	| \
+				     PERF_SAMPLE_BRANCH_COUNTERS)
+
+#define BRBE_ALLOWED_BRANCH_TYPES   (PERF_SAMPLE_BRANCH_ANY		| \
+				     PERF_SAMPLE_BRANCH_ANY_CALL	| \
+				     PERF_SAMPLE_BRANCH_ANY_RETURN	| \
+				     PERF_SAMPLE_BRANCH_IND_CALL	| \
+				     PERF_SAMPLE_BRANCH_COND		| \
+				     PERF_SAMPLE_BRANCH_IND_JUMP	| \
+				     PERF_SAMPLE_BRANCH_CALL)
+
+
+#define BRBE_ALLOWED_BRANCH_FILTERS (PERF_SAMPLE_BRANCH_USER		| \
+				     PERF_SAMPLE_BRANCH_KERNEL		| \
+				     PERF_SAMPLE_BRANCH_HV		| \
+				     BRBE_ALLOWED_BRANCH_TYPES		| \
+				     PERF_SAMPLE_BRANCH_NO_FLAGS	| \
+				     PERF_SAMPLE_BRANCH_NO_CYCLES	| \
+				     PERF_SAMPLE_BRANCH_TYPE_SAVE	| \
+				     PERF_SAMPLE_BRANCH_HW_INDEX	| \
+				     PERF_SAMPLE_BRANCH_PRIV_SAVE)
+
+#define BRBE_PERF_BRANCH_FILTERS    (BRBE_ALLOWED_BRANCH_FILTERS	| \
+				     BRBE_EXCLUDE_BRANCH_FILTERS)
+
+/*
+ * BRBE supports the following functional branch type filters while
+ * generating branch records. These branch filters can be enabled,
+ * either individually or as a group i.e ORing multiple filters
+ * with each other.
+ *
+ * BRBFCR_EL1_CONDDIR  - Conditional direct branch
+ * BRBFCR_EL1_DIRCALL  - Direct call
+ * BRBFCR_EL1_INDCALL  - Indirect call
+ * BRBFCR_EL1_INDIRECT - Indirect branch
+ * BRBFCR_EL1_DIRECT   - Direct branch
+ * BRBFCR_EL1_RTN      - Subroutine return
+ */
+static u64 branch_type_to_brbfcr(int branch_type)
+{
+	u64 brbfcr = 0;
+
+	if (branch_type & PERF_SAMPLE_BRANCH_ANY) {
+		brbfcr |= BRBFCR_EL1_BRANCH_FILTERS;
+		return brbfcr;
+	}
+
+	if (branch_type & PERF_SAMPLE_BRANCH_ANY_CALL) {
+		brbfcr |= BRBFCR_EL1_INDCALL;
+		brbfcr |= BRBFCR_EL1_DIRCALL;
+	}
+
+	if (branch_type & PERF_SAMPLE_BRANCH_ANY_RETURN)
+		brbfcr |= BRBFCR_EL1_RTN;
+
+	if (branch_type & PERF_SAMPLE_BRANCH_IND_CALL)
+		brbfcr |= BRBFCR_EL1_INDCALL;
+
+	if (branch_type & PERF_SAMPLE_BRANCH_COND)
+		brbfcr |= BRBFCR_EL1_CONDDIR;
+
+	if (branch_type & PERF_SAMPLE_BRANCH_IND_JUMP)
+		brbfcr |= BRBFCR_EL1_INDIRECT;
+
+	if (branch_type & PERF_SAMPLE_BRANCH_CALL)
+		brbfcr |= BRBFCR_EL1_DIRCALL;
+
+	return brbfcr;
+}
+
+/*
+ * BRBE supports the following privilege mode filters while generating
+ * branch records.
+ *
+ * BRBCR_ELx_E0BRE - EL0 branch records
+ * BRBCR_ELx_ExBRE - EL1/EL2 branch records
+ *
+ * BRBE also supports the following additional functional branch type
+ * filters while generating branch records.
+ *
+ * BRBCR_ELx_EXCEPTION - Exception
+ * BRBCR_ELx_ERTN     -  Exception return
+ */
+static u64 branch_type_to_brbcr(int branch_type)
+{
+	u64 brbcr = BRBCR_ELx_FZP | BRBCR_ELx_DEFAULT_TS;
+
+	if (branch_type & PERF_SAMPLE_BRANCH_USER)
+		brbcr |= BRBCR_ELx_E0BRE;
+
+	/*
+	 * When running in the hyp mode, writing into BRBCR_EL1
+	 * actually writes into BRBCR_EL2 instead. Field E2BRE
+	 * is also at the same position as E1BRE.
+	 */
+	if (branch_type & PERF_SAMPLE_BRANCH_KERNEL)
+		brbcr |= BRBCR_ELx_ExBRE;
+
+	if (branch_type & PERF_SAMPLE_BRANCH_HV) {
+		if (is_kernel_in_hyp_mode())
+			brbcr |= BRBCR_ELx_ExBRE;
+	}
+
+	if (!(branch_type & PERF_SAMPLE_BRANCH_NO_CYCLES))
+		brbcr |= BRBCR_ELx_CC;
+
+	if (!(branch_type & PERF_SAMPLE_BRANCH_NO_FLAGS))
+		brbcr |= BRBCR_ELx_MPRED;
+
+	/*
+	 * The exception and exception return branches could be
+	 * captured, irrespective of the perf event's privilege.
+	 * If the perf event does not have enough privilege for
+	 * a given exception level, then addresses which falls
+	 * under that exception level will be reported as zero
+	 * for the captured branch record, creating source only
+	 * or target only records.
+	 */
+	if (branch_type & PERF_SAMPLE_BRANCH_ANY) {
+		brbcr |= BRBCR_ELx_EXCEPTION;
+		brbcr |= BRBCR_ELx_ERTN;
+	}
+
+	if (branch_type & PERF_SAMPLE_BRANCH_ANY_CALL)
+		brbcr |= BRBCR_ELx_EXCEPTION;
+
+	if (branch_type & PERF_SAMPLE_BRANCH_ANY_RETURN)
+		brbcr |= BRBCR_ELx_ERTN;
+
+	return brbcr;
+}
+
+bool brbe_branch_attr_valid(struct perf_event *event)
+{
+	u64 branch_type = event->attr.branch_sample_type;
+
+	/*
+	 * Ensure both perf branch filter allowed and exclude
+	 * masks are always in sync with the generic perf ABI.
+	 */
+	BUILD_BUG_ON(BRBE_PERF_BRANCH_FILTERS != (PERF_SAMPLE_BRANCH_MAX - 1));
+
+	if (branch_type & BRBE_EXCLUDE_BRANCH_FILTERS) {
+		pr_debug_once("requested branch filter not supported 0x%llx\n", branch_type);
+		return false;
+	}
+
+	/* Ensure at least 1 branch type is enabled */
+	if (!(branch_type & BRBE_ALLOWED_BRANCH_TYPES)) {
+		pr_debug_once("no branch type enabled 0x%llx\n", branch_type);
+		return false;
+	}
+
+	/*
+	 * No branches are recorded in guests nor nVHE hypervisors, so
+	 * excluding the host or both kernel and user is invalid.
+	 *
+	 * Ideally we'd just require exclude_guest and exclude_hv, but setting
+	 * event filters with perf for kernel or user don't set exclude_guest.
+	 * So effectively, exclude_guest and exclude_hv are ignored.
+	 */
+	if (event->attr.exclude_host || (event->attr.exclude_user && event->attr.exclude_kernel))
+		return false;
+
+	/*
+	 * Require that the event filter and branch filter permissions match.
+	 *
+	 * The event and branch permissions can only mismatch if the user set
+	 * at least one of the privilege branch filters in PERF_SAMPLE_BRANCH_PLM_ALL.
+	 * Otherwise, the core will set the branch sample permissions in
+	 * perf_copy_attr().
+	 */
+	if ((event->attr.exclude_user != !(branch_type & PERF_SAMPLE_BRANCH_USER)) ||
+	    (event->attr.exclude_kernel != !(branch_type & PERF_SAMPLE_BRANCH_KERNEL)) ||
+	    (!is_kernel_in_hyp_mode() &&
+	     (event->attr.exclude_hv != !(branch_type & PERF_SAMPLE_BRANCH_HV))))
+		return false;
+
+	event->hw.branch_reg.config = branch_type_to_brbfcr(event->attr.branch_sample_type);
+	event->hw.extra_reg.config = branch_type_to_brbcr(event->attr.branch_sample_type);
+
+	return true;
+}
+
+unsigned int brbe_num_branch_records(const struct arm_pmu *armpmu)
+{
+	return FIELD_GET(BRBIDR0_EL1_NUMREC_MASK, armpmu->reg_brbidr);
+}
+
+void brbe_probe(struct arm_pmu *armpmu)
+{
+	u64 aa64dfr0 = read_sysreg_s(SYS_ID_AA64DFR0_EL1);
+	u32 brbe;
+
+	brbe = cpuid_feature_extract_unsigned_field(aa64dfr0, ID_AA64DFR0_EL1_BRBE_SHIFT);
+	if (!valid_brbe_version(brbe))
+		return;
+
+	u64 brbidr = read_sysreg_s(SYS_BRBIDR0_EL1);
+	if (!valid_brbidr(brbidr))
+		return;
+
+	armpmu->reg_brbidr = brbidr;
+}
+
+void brbe_enable(const struct arm_pmu *arm_pmu)
+{
+	struct pmu_hw_events *cpuc = this_cpu_ptr(arm_pmu->hw_events);
+	u64 brbfcr = 0, brbcr = 0;
+
+	/*
+	 * Merge the permitted branch filters of all events.
+	 */
+	for (int i = 0; i < ARMPMU_MAX_HWEVENTS; i++) {
+		struct perf_event *event = cpuc->events[i];
+
+		if (event && has_branch_stack(event)) {
+			brbfcr |= event->hw.branch_reg.config;
+			brbcr |= event->hw.extra_reg.config;
+		}
+	}
+
+	/*
+	 * If the record buffer contains any branches, we've already read them
+	 * out and don't want to read them again.
+	 * No need to sync as we're already stopped.
+	 */
+	brbe_invalidate_nosync();
+	isb(); // Make sure invalidate takes effect before enabling
+
+	/*
+	 * In VHE mode with MDCR_EL2.HPMN set to PMCR_EL0.N, the counters are
+	 * controlled by BRBCR_EL1 rather than BRBCR_EL2 (which writes to
+	 * BRBCR_EL1 are redirected to). Use the same value for both register
+	 * except keep EL1 and EL0 recording disabled in guests.
+	 */
+	if (is_kernel_in_hyp_mode())
+		write_sysreg_s(brbcr & ~(BRBCR_ELx_ExBRE | BRBCR_ELx_E0BRE), SYS_BRBCR_EL12);
+	write_sysreg_s(brbcr, SYS_BRBCR_EL1);
+	isb(); // Ensure BRBCR_ELx settings take effect before unpausing
+
+	write_sysreg_s(brbfcr, SYS_BRBFCR_EL1);
+}
+
+void brbe_disable(void)
+{
+	/*
+	 * No need for synchronization here as synchronization in PMCR write
+	 * ensures ordering and in the interrupt handler this is a NOP as
+	 * we're already paused.
+	 */
+	write_sysreg_s(BRBFCR_EL1_PAUSED, SYS_BRBFCR_EL1);
+}
+
+static const int brbe_type_to_perf_type_map[BRBINFx_EL1_TYPE_DEBUG_EXIT + 1][2] = {
+	[BRBINFx_EL1_TYPE_DIRECT_UNCOND] = { PERF_BR_UNCOND, 0 },
+	[BRBINFx_EL1_TYPE_INDIRECT] = { PERF_BR_IND, 0 },
+	[BRBINFx_EL1_TYPE_DIRECT_LINK] = { PERF_BR_CALL, 0 },
+	[BRBINFx_EL1_TYPE_INDIRECT_LINK] = { PERF_BR_IND_CALL, 0 },
+	[BRBINFx_EL1_TYPE_RET] = { PERF_BR_RET, 0 },
+	[BRBINFx_EL1_TYPE_DIRECT_COND] = { PERF_BR_COND, 0 },
+	[BRBINFx_EL1_TYPE_CALL] = { PERF_BR_CALL, 0 },
+	[BRBINFx_EL1_TYPE_ERET] = { PERF_BR_ERET, 0 },
+	[BRBINFx_EL1_TYPE_IRQ] = { PERF_BR_IRQ, 0 },
+};
+
+static void brbe_set_perf_entry_type(struct perf_branch_entry *entry, u64 brbinf)
+{
+	int brbe_type = brbinf_get_type(brbinf);
+
+	if (brbe_type <= BRBINFx_EL1_TYPE_DEBUG_EXIT) {
+		const int *br_type = brbe_type_to_perf_type_map[brbe_type];
+
+		entry->type = br_type[0];
+		entry->new_type = br_type[1];
+	}
+}
+
+static int brbinf_get_perf_priv(u64 brbinf)
+{
+	int brbe_el = brbinf_get_el(brbinf);
+
+	switch (brbe_el) {
+	case BRBINFx_EL1_EL_EL0:
+		return PERF_BR_PRIV_USER;
+	case BRBINFx_EL1_EL_EL1:
+		return PERF_BR_PRIV_KERNEL;
+	case BRBINFx_EL1_EL_EL2:
+		if (is_kernel_in_hyp_mode())
+			return PERF_BR_PRIV_KERNEL;
+		return PERF_BR_PRIV_HV;
+	default:
+		pr_warn_once("%d - unknown branch privilege captured\n", brbe_el);
+		return PERF_BR_PRIV_UNKNOWN;
+	}
+}
+
+static void capture_brbe_flags(struct perf_branch_entry *entry,
+			       const struct perf_event *event,
+			       u64 brbinf)
+{
+	brbe_set_perf_entry_type(entry, brbinf);
+
+	if (!branch_sample_no_cycles(event))
+		entry->cycles = brbinf_get_cycles(brbinf);
+
+	if (!branch_sample_no_flags(event)) {
+		/* Mispredict info is available for source only and complete branch records. */
+		if (!brbe_record_is_target_only(brbinf)) {
+			entry->mispred = brbinf_get_mispredict(brbinf);
+			entry->predicted = !entry->mispred;
+		}
+
+		/*
+		 * Currently TME feature is neither implemented in any hardware
+		 * nor it is being supported in the kernel. Just warn here once
+		 * if TME related information shows up rather unexpectedly.
+		 */
+		if (brbinf_get_lastfailed(brbinf) || brbinf_get_in_tx(brbinf))
+			pr_warn_once("Unknown transaction states\n");
+	}
+
+	/*
+	 * Branch privilege level is available for target only and complete
+	 * branch records.
+	 */
+	if (!brbe_record_is_source_only(brbinf))
+		entry->priv = brbinf_get_perf_priv(brbinf);
+}
+
+static bool perf_entry_from_brbe_regset(int index, struct perf_branch_entry *entry,
+					const struct perf_event *event)
+{
+	struct brbe_regset bregs;
+
+	if (!__read_brbe_regset(&bregs, index))
+		return false;
+
+	perf_clear_branch_entry_bitfields(entry);
+	if (brbe_record_is_complete(bregs.brbinf)) {
+		entry->from = bregs.brbsrc;
+		entry->to = bregs.brbtgt;
+	} else if (brbe_record_is_source_only(bregs.brbinf)) {
+		entry->from = bregs.brbsrc;
+		entry->to = 0;
+	} else if (brbe_record_is_target_only(bregs.brbinf)) {
+		entry->from = 0;
+		entry->to = bregs.brbtgt;
+	}
+	capture_brbe_flags(entry, event, bregs.brbinf);
+	return true;
+}
+
+#define PERF_BR_ARM64_ALL (		\
+	BIT(PERF_BR_COND) |		\
+	BIT(PERF_BR_UNCOND) |		\
+	BIT(PERF_BR_IND) |		\
+	BIT(PERF_BR_CALL) |		\
+	BIT(PERF_BR_IND_CALL) |		\
+	BIT(PERF_BR_RET) |		\
+	BIT(PERF_BR_SYSCALL) |		\
+	BIT(PERF_BR_ERET) |		\
+	BIT(PERF_BR_IRQ))
+
+static void prepare_event_branch_type_mask(const struct perf_event *event,
+					   unsigned long *event_type_mask)
+{
+	u64 branch_sample = event->attr.branch_sample_type;
+
+	if (branch_sample & PERF_SAMPLE_BRANCH_ANY) {
+		bitmap_from_u64(event_type_mask, PERF_BR_ARM64_ALL);
+		return;
+	}
+
+	bitmap_zero(event_type_mask, PERF_BR_ARM64_MAX);
+
+	if (branch_sample & PERF_SAMPLE_BRANCH_IND_JUMP)
+		set_bit(PERF_BR_IND, event_type_mask);
+
+	if (branch_sample & PERF_SAMPLE_BRANCH_COND)
+		set_bit(PERF_BR_COND, event_type_mask);
+
+	if (branch_sample & PERF_SAMPLE_BRANCH_CALL)
+		set_bit(PERF_BR_CALL, event_type_mask);
+
+	if (branch_sample & PERF_SAMPLE_BRANCH_IND_CALL)
+		set_bit(PERF_BR_IND_CALL, event_type_mask);
+
+	if (branch_sample & PERF_SAMPLE_BRANCH_ANY_CALL) {
+		set_bit(PERF_BR_CALL, event_type_mask);
+		set_bit(PERF_BR_IND_CALL, event_type_mask);
+		set_bit(PERF_BR_SYSCALL, event_type_mask);
+
+		if (!event->attr.exclude_kernel)
+			set_bit(PERF_BR_IRQ, event_type_mask);
+	}
+
+	if (branch_sample & PERF_SAMPLE_BRANCH_ANY_RETURN) {
+		set_bit(PERF_BR_RET, event_type_mask);
+
+		if (!event->attr.exclude_kernel)
+			set_bit(PERF_BR_ERET, event_type_mask);
+	}
+}
+
+/*
+ * BRBE is configured with an OR of permissions from all events, so there may
+ * be events which have to be dropped or events where just the source or target
+ * address has to be zeroed.
+ */
+static bool filter_branch_privilege(struct perf_branch_entry *entry, u64 branch_sample_type)
+{
+	/* We can only have a half record if permissions have not been expanded */
+	if (!entry->from || !entry->to)
+		return true;
+
+	bool from_user = access_ok((void __user *)(unsigned long)entry->from, 4);
+	bool to_user = access_ok((void __user *)(unsigned long)entry->to, 4);
+	bool exclude_kernel = !((branch_sample_type & PERF_SAMPLE_BRANCH_KERNEL) ||
+		(is_kernel_in_hyp_mode() && (branch_sample_type & PERF_SAMPLE_BRANCH_HV)));
+
+	/*
+	 * If record is within a single exception level, just need to either
+	 * drop or keep the entire record.
+	 */
+	if (from_user == to_user)
+		return ((entry->priv == PERF_BR_PRIV_KERNEL) && !exclude_kernel) ||
+			((entry->priv == PERF_BR_PRIV_USER) &&
+			 (branch_sample_type & PERF_SAMPLE_BRANCH_USER));
+
+	/*
+	 * Record is across exception levels, mask addresses for the exception
+	 * level we're not capturing.
+	 */
+	if (!(branch_sample_type & PERF_SAMPLE_BRANCH_USER)) {
+		if (from_user)
+			entry->from = 0;
+		if (to_user)
+			entry->to = 0;
+	}
+
+	if (exclude_kernel) {
+		if (!from_user)
+			entry->from = 0;
+		if (!to_user)
+			entry->to = 0;
+	}
+	return true;
+}
+
+static bool filter_branch_record(struct perf_branch_entry *entry,
+				 u64 branch_sample,
+				 const unsigned long *event_type_mask)
+{
+	return test_bit(entry->type, event_type_mask) &&
+		filter_branch_privilege(entry, branch_sample);
+}
+
+void brbe_read_filtered_entries(struct perf_branch_stack *branch_stack,
+				const struct perf_event *event)
+{
+	struct arm_pmu *cpu_pmu = to_arm_pmu(event->pmu);
+	int nr_hw = brbe_num_branch_records(cpu_pmu);
+	int nr_banks = DIV_ROUND_UP(nr_hw, BRBE_BANK_MAX_ENTRIES);
+	int nr_filtered = 0;
+	DECLARE_BITMAP(event_type_mask, PERF_BR_ARM64_MAX);
+
+	prepare_event_branch_type_mask(event, event_type_mask);
+
+	for (int bank = 0; bank < nr_banks; bank++) {
+		int nr_remaining = nr_hw - (bank * BRBE_BANK_MAX_ENTRIES);
+		int nr_this_bank = min(nr_remaining, BRBE_BANK_MAX_ENTRIES);
+
+		select_brbe_bank(bank);
+
+		for (int i = 0; i < nr_this_bank; i++) {
+			struct perf_branch_entry *pbe = &branch_stack->entries[nr_filtered];
+
+			if (!perf_entry_from_brbe_regset(i, pbe, event))
+				goto done;
+
+			if (!filter_branch_record(pbe, event->attr.branch_sample_type, event_type_mask))
+				continue;
+
+			nr_filtered++;
+		}
+	}
+
+done:
+	branch_stack->nr = nr_filtered;
+}
diff --git a/drivers/perf/arm_brbe.h b/drivers/perf/arm_brbe.h
new file mode 100644
index 000000000000..b7c7d8796c86
--- /dev/null
+++ b/drivers/perf/arm_brbe.h
@@ -0,0 +1,47 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Branch Record Buffer Extension Helpers.
+ *
+ * Copyright (C) 2022-2025 ARM Limited
+ *
+ * Author: Anshuman Khandual <anshuman.khandual@arm.com>
+ */
+
+struct arm_pmu;
+struct perf_branch_stack;
+struct perf_event;
+
+#ifdef CONFIG_ARM64_BRBE
+void brbe_probe(struct arm_pmu *arm_pmu);
+unsigned int brbe_num_branch_records(const struct arm_pmu *armpmu);
+void brbe_invalidate(void);
+
+void brbe_enable(const struct arm_pmu *arm_pmu);
+void brbe_disable(void);
+
+bool brbe_branch_attr_valid(struct perf_event *event);
+void brbe_read_filtered_entries(struct perf_branch_stack *branch_stack,
+				const struct perf_event *event);
+#else
+static inline void brbe_probe(struct arm_pmu *arm_pmu) { }
+static inline unsigned int brbe_num_branch_records(const struct arm_pmu *armpmu)
+{
+	return 0;
+}
+
+static inline void brbe_invalidate(void) { }
+
+static inline void brbe_enable(const struct arm_pmu *arm_pmu) { };
+static inline void brbe_disable(void) { };
+
+static inline bool brbe_branch_attr_valid(struct perf_event *event)
+{
+	WARN_ON_ONCE(!has_branch_stack(event));
+	return false;
+}
+
+static void brbe_read_filtered_entries(struct perf_branch_stack *branch_stack,
+				       const struct perf_event *event)
+{
+}
+#endif
diff --git a/drivers/perf/arm_pmu.c b/drivers/perf/arm_pmu.c
index 2f33e69a8caf..df9867c0dc57 100644
--- a/drivers/perf/arm_pmu.c
+++ b/drivers/perf/arm_pmu.c
@@ -99,7 +99,7 @@ static const struct pmu_irq_ops percpu_pmunmi_ops = {
 	.free_pmuirq = armpmu_free_percpu_pmunmi
 };
 
-static DEFINE_PER_CPU(struct arm_pmu *, cpu_armpmu);
+DEFINE_PER_CPU(struct arm_pmu *, cpu_armpmu);
 static DEFINE_PER_CPU(int, cpu_irq);
 static DEFINE_PER_CPU(const struct pmu_irq_ops *, cpu_irq_ops);
 
@@ -317,6 +317,11 @@ armpmu_del(struct perf_event *event, int flags)
 	struct hw_perf_event *hwc = &event->hw;
 	int idx = hwc->idx;
 
+	if (has_branch_stack(event)) {
+		hw_events->branch_users--;
+		perf_sched_cb_dec(event->pmu);
+	}
+
 	armpmu_stop(event, PERF_EF_UPDATE);
 	hw_events->events[idx] = NULL;
 	armpmu->clear_event_idx(hw_events, event);
@@ -345,6 +350,11 @@ armpmu_add(struct perf_event *event, int flags)
 	/* The newly-allocated counter should be empty */
 	WARN_ON_ONCE(hw_events->events[idx]);
 
+	if (has_branch_stack(event)) {
+		hw_events->branch_users++;
+		perf_sched_cb_inc(event->pmu);
+	}
+
 	event->hw.idx = idx;
 	hw_events->events[idx] = event;
 
@@ -509,8 +519,7 @@ static int armpmu_event_init(struct perf_event *event)
 		!cpumask_test_cpu(event->cpu, &armpmu->supported_cpus))
 		return -ENOENT;
 
-	/* does not support taken branch sampling */
-	if (has_branch_stack(event))
+	if (has_branch_stack(event) && !armpmu->reg_brbidr)
 		return -EOPNOTSUPP;
 
 	return __hw_perf_event_init(event);
diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
index 5406b9ca591a..748728c4227d 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -25,6 +25,8 @@
 #include <linux/smp.h>
 #include <linux/nmi.h>
 
+#include "arm_brbe.h"
+
 /* ARMv8 Cortex-A53 specific event types. */
 #define ARMV8_A53_PERFCTR_PREF_LINEFILL				0xC2
 
@@ -809,6 +811,7 @@ static void armv8pmu_disable_event(struct perf_event *event)
 static void armv8pmu_start(struct arm_pmu *cpu_pmu)
 {
 	struct perf_event_context *ctx;
+	struct pmu_hw_events *hw_events = this_cpu_ptr(cpu_pmu->hw_events);
 	int nr_user = 0;
 
 	ctx = perf_cpu_task_ctx();
@@ -822,16 +825,34 @@ static void armv8pmu_start(struct arm_pmu *cpu_pmu)
 
 	kvm_vcpu_pmu_resync_el0();
 
+	if (hw_events->branch_users)
+		brbe_enable(cpu_pmu);
+
 	/* Enable all counters */
 	armv8pmu_pmcr_write(armv8pmu_pmcr_read() | ARMV8_PMU_PMCR_E);
 }
 
 static void armv8pmu_stop(struct arm_pmu *cpu_pmu)
 {
+	struct pmu_hw_events *hw_events = this_cpu_ptr(cpu_pmu->hw_events);
+
+	if (hw_events->branch_users)
+		brbe_disable();
+
 	/* Disable all counters */
 	armv8pmu_pmcr_write(armv8pmu_pmcr_read() & ~ARMV8_PMU_PMCR_E);
 }
 
+static void read_branch_records(struct pmu_hw_events *cpuc,
+				struct perf_event *event,
+				struct perf_sample_data *data)
+{
+	struct perf_branch_stack *branch_stack = cpuc->branch_stack;
+
+	brbe_read_filtered_entries(branch_stack, event);
+	perf_sample_save_brstack(data, event, branch_stack, NULL);
+}
+
 static irqreturn_t armv8pmu_handle_irq(struct arm_pmu *cpu_pmu)
 {
 	u64 pmovsr;
@@ -882,6 +903,13 @@ static irqreturn_t armv8pmu_handle_irq(struct arm_pmu *cpu_pmu)
 		if (!armpmu_event_set_period(event))
 			continue;
 
+		/*
+		 * PMU IRQ should remain asserted until all branch records
+		 * are captured and processed into struct perf_sample_data.
+		 */
+		if (has_branch_stack(event))
+			read_branch_records(cpuc, event, &data);
+
 		/*
 		 * Perf event overflow will queue the processing of the event as
 		 * an irq_work which will be taken care of in the handling of
@@ -939,7 +967,7 @@ static int armv8pmu_get_event_idx(struct pmu_hw_events *cpuc,
 
 	/* Always prefer to place a cycle counter into the cycle counter. */
 	if ((evtype == ARMV8_PMUV3_PERFCTR_CPU_CYCLES) &&
-	    !armv8pmu_event_get_threshold(&event->attr)) {
+	    !armv8pmu_event_get_threshold(&event->attr) && !has_branch_stack(event)) {
 		if (!test_and_set_bit(ARMV8_PMU_CYCLE_IDX, cpuc->used_mask))
 			return ARMV8_PMU_CYCLE_IDX;
 		else if (armv8pmu_event_is_64bit(event) &&
@@ -988,6 +1016,18 @@ static int armv8pmu_user_event_idx(struct perf_event *event)
 	return event->hw.idx + 1;
 }
 
+static void armv8pmu_sched_task(struct perf_event_pmu_context *pmu_ctx, bool sched_in)
+{
+	struct arm_pmu *armpmu = *this_cpu_ptr(&cpu_armpmu);
+	struct pmu_hw_events *hw_events = this_cpu_ptr(armpmu->hw_events);
+
+	if (!hw_events->branch_users)
+		return;
+
+	if (sched_in)
+		brbe_invalidate();
+}
+
 /*
  * Add an event filter to a given event.
  */
@@ -1005,6 +1045,13 @@ static int armv8pmu_set_event_filter(struct hw_perf_event *event,
 		return -EOPNOTSUPP;
 	}
 
+	if (has_branch_stack(perf_event)) {
+		if (!brbe_num_branch_records(cpu_pmu) || !brbe_branch_attr_valid(perf_event))
+			return -EOPNOTSUPP;
+
+		perf_event->attach_state |= PERF_ATTACH_SCHED_CB;
+	}
+
 	/*
 	 * If we're running in hyp mode, then we *are* the hypervisor.
 	 * Therefore we ignore exclude_hv in this configuration, since
@@ -1071,6 +1118,9 @@ static void armv8pmu_reset(void *info)
 	/* Clear the counters we flip at guest entry/exit */
 	kvm_clr_pmu_events(mask);
 
+	if (brbe_num_branch_records(cpu_pmu))
+		brbe_disable();
+
 	/*
 	 * Initialize & Reset PMNC. Request overflow interrupt for
 	 * 64 bit cycle counter but cheat in armv8pmu_write_counter().
@@ -1239,6 +1289,30 @@ static void __armv8pmu_probe_pmu(void *info)
 		cpu_pmu->reg_pmmir = read_pmmir();
 	else
 		cpu_pmu->reg_pmmir = 0;
+
+	brbe_probe(cpu_pmu);
+}
+
+static int branch_records_alloc(struct arm_pmu *armpmu)
+{
+	struct perf_branch_stack *branch_stack;
+	size_t size = struct_size(branch_stack, entries, brbe_num_branch_records(armpmu));
+	int cpu;
+
+	branch_stack = __alloc_percpu_gfp(size, __alignof__(*branch_stack),
+					  GFP_KERNEL);
+	if (!branch_stack)
+		return -ENOMEM;
+
+	for_each_possible_cpu(cpu) {
+		struct pmu_hw_events *events_cpu;
+		struct perf_branch_stack *branch_stack_cpu;
+
+		events_cpu = per_cpu_ptr(armpmu->hw_events, cpu);
+		branch_stack_cpu = per_cpu_ptr(branch_stack, cpu);
+		events_cpu->branch_stack = branch_stack_cpu;
+	}
+	return 0;
 }
 
 static int armv8pmu_probe_pmu(struct arm_pmu *cpu_pmu)
@@ -1255,7 +1329,15 @@ static int armv8pmu_probe_pmu(struct arm_pmu *cpu_pmu)
 	if (ret)
 		return ret;
 
-	return probe.present ? 0 : -ENODEV;
+	if (!probe.present)
+		return -ENODEV;
+
+	if (brbe_num_branch_records(cpu_pmu)) {
+		ret = branch_records_alloc(cpu_pmu);
+		if (ret)
+			return ret;
+	}
+	return 0;
 }
 
 static void armv8pmu_disable_user_access_ipi(void *unused)
@@ -1314,6 +1396,7 @@ static int armv8_pmu_init(struct arm_pmu *cpu_pmu, char *name,
 	cpu_pmu->set_event_filter	= armv8pmu_set_event_filter;
 
 	cpu_pmu->pmu.event_idx		= armv8pmu_user_event_idx;
+	cpu_pmu->pmu.sched_task		= armv8pmu_sched_task;
 
 	cpu_pmu->name			= name;
 	cpu_pmu->map_event		= map_event;
diff --git a/include/linux/perf/arm_pmu.h b/include/linux/perf/arm_pmu.h
index c70d528594f2..219d58259857 100644
--- a/include/linux/perf/arm_pmu.h
+++ b/include/linux/perf/arm_pmu.h
@@ -70,6 +70,11 @@ struct pmu_hw_events {
 	struct arm_pmu		*percpu_pmu;
 
 	int irq;
+
+	struct perf_branch_stack	*branch_stack;
+
+	/* Active events requesting branch records */
+	unsigned int		branch_users;
 };
 
 enum armpmu_attr_groups {
@@ -111,6 +116,7 @@ struct arm_pmu {
 	/* PMUv3 only */
 	int		pmuver;
 	u64		reg_pmmir;
+	u64		reg_brbidr;
 #define ARMV8_PMUV3_MAX_COMMON_EVENTS		0x40
 	DECLARE_BITMAP(pmceid_bitmap, ARMV8_PMUV3_MAX_COMMON_EVENTS);
 #define ARMV8_PMUV3_EXT_COMMON_EVENT_BASE	0x4000
@@ -122,6 +128,8 @@ struct arm_pmu {
 
 #define to_arm_pmu(p) (container_of(p, struct arm_pmu, pmu))
 
+DECLARE_PER_CPU(struct arm_pmu *, cpu_armpmu);
+
 u64 armpmu_event_update(struct perf_event *event);
 
 int armpmu_event_set_period(struct perf_event *event);

-- 
2.47.2

