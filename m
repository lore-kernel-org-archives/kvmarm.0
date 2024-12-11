Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0D6B1DD886
	for <kvmarm@lists.linux.dev>; Wed, 11 Dec 2024 16:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733932984; cv=none; b=pBmdGvmq7LWcuZ0gpRC5rqnxfBNjkGHm77vtugWsI8pQtFMRISROZ21o+7Er+bs9aGqtJA97P7EdwOmxUxrtMuzEAkDB3k49LOxdZ5nTzvfTEAZ3qoIQWAeq9uUOkzjeHUOuJYVbF4bpEpdfTidVmc4eqPkbz2E1M5LYy3Tp+LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733932984; c=relaxed/simple;
	bh=TYmsKaI2XKy6nFl7ZdhjfrfqKCt+R2KKhTjaP3gr3BE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sjNUTlEGsUJz57XejidtLvTy8Id1yGdvg1kuKzMwM179/VJMIOsa1xYoG588ybHZr5ar+a2hjOPsJcCQZT8ape/1cj4tOL/a1RvudblqTn2PzOIP1G/0cpukBheJeleTm+Y3FBkOC9cV1f9AYAlR1QmRduQZxsBZMOByE2bSVmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7B01E169E;
	Wed, 11 Dec 2024 08:03:30 -0800 (PST)
Received: from mazurka.cambridge.arm.com (mazurka.cambridge.arm.com [10.1.196.66])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 583E83F5A1;
	Wed, 11 Dec 2024 08:03:00 -0800 (PST)
From: =?UTF-8?q?Miko=C5=82aj=20Lenczewski?= <miko.lenczewski@arm.com>
To: ryan.roberts@arm.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	corbet@lwn.net,
	maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com
Cc: =?UTF-8?q?Miko=C5=82aj=20Lenczewski?= <miko.lenczewski@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: [RESEND RFC PATCH v1 2/5] arm64: Add BBM Level 2 cpu feature
Date: Wed, 11 Dec 2024 16:01:38 +0000
Message-ID: <20241211160218.41404-3-miko.lenczewski@arm.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241211160218.41404-1-miko.lenczewski@arm.com>
References: <20241211160218.41404-1-miko.lenczewski@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The Break-Before-Make cpu feature supports multiple levels (levels 0-2),
and this commit adds a dedicated BBML2 cpufeature to test against
support for.

In supporting BBM level 2, we open ourselves up to potential TLB
Conflict Abort Exceptions during expected execution, instead of only
in exceptional circumstances. In the case of an abort, it is
implementation defined at what stage the abort is generated, and
the minimal set of required invalidations is also implementation
defined. The maximal set of invalidations is to do a `tlbi vmalle1`
or `tlbi vmalls12e1`, depending on the stage.

Such aborts should not occur on Arm hardware, and were not seen in
benchmarked systems, so unless performance concerns arise, implementing
the abort handlers with the worst-case invalidations seems like an
alright hack.

Signed-off-by: Mikołaj Lenczewski <miko.lenczewski@arm.com>
---
 arch/arm64/include/asm/cpufeature.h | 14 ++++++++++++++
 arch/arm64/kernel/cpufeature.c      |  7 +++++++
 arch/arm64/mm/fault.c               | 27 ++++++++++++++++++++++++++-
 arch/arm64/tools/cpucaps            |  1 +
 4 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 8b4e5a3cd24c..a9f2ac335392 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -866,6 +866,20 @@ static __always_inline bool system_supports_mpam_hcr(void)
 	return alternative_has_cap_unlikely(ARM64_MPAM_HCR);
 }
 
+static inline bool system_supports_bbml2(void)
+{
+	/* currently, BBM is only relied on by code touching the userspace page
+	 * tables, and as such we are guaranteed that caps have been finalised.
+	 *
+	 * if later we want to use BBM for kernel mappings, particularly early
+	 * in the kernel, this may return 0 even if BBML2 is actually supported,
+	 * which means unnecessary break-before-make sequences, but is still
+	 * correct
+	 */
+
+	return alternative_has_cap_unlikely(ARM64_HAS_BBML2);
+}
+
 int do_emulate_mrs(struct pt_regs *regs, u32 sys_reg, u32 rt);
 bool try_emulate_mrs(struct pt_regs *regs, u32 isn);
 
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 6ce71f444ed8..7cc94bd5da24 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2917,6 +2917,13 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_cpuid_feature,
 		ARM64_CPUID_FIELDS(ID_AA64MMFR2_EL1, EVT, IMP)
 	},
+	{
+		.desc = "BBM Level 2 Support",
+		.capability = ARM64_HAS_BBML2,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = has_cpuid_feature,
+		ARM64_CPUID_FIELDS(ID_AA64MMFR2_EL1, BBM, 2)
+	},
 	{
 		.desc = "52-bit Virtual Addressing for KVM (LPA2)",
 		.capability = ARM64_HAS_LPA2,
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index ef63651099a9..dc119358cbc1 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -844,6 +844,31 @@ static int do_tag_check_fault(unsigned long far, unsigned long esr,
 	return 0;
 }
 
+static int do_conflict_abort(unsigned long far, unsigned long esr,
+			     struct pt_regs *regs)
+{
+	if (!system_supports_bbml2())
+		return do_bad(far, esr, regs);
+
+	/* if we receive a TLB conflict abort, we know that there are multiple
+	 * TLB entries that translate the same address range. the minimum set
+	 * of invalidations to clear these entries is implementation defined.
+	 * the maximum set is defined as either tlbi(vmalls12e1) or tlbi(alle1).
+	 *
+	 * if el2 is enabled and stage 2 translation enabled, this may be
+	 * raised as a stage 2 abort. if el2 is enabled but stage 2 translation
+	 * disabled, or if el2 is disabled, it will be raised as a stage 1
+	 * abort.
+	 *
+	 * local_flush_tlb_all() does a tlbi(vmalle1), which is enough to
+	 * handle a stage 1 abort.
+	 */
+
+	local_flush_tlb_all();
+
+	return 0;
+}
+
 static const struct fault_info fault_info[] = {
 	{ do_bad,		SIGKILL, SI_KERNEL,	"ttbr address size fault"	},
 	{ do_bad,		SIGKILL, SI_KERNEL,	"level 1 address size fault"	},
@@ -893,7 +918,7 @@ static const struct fault_info fault_info[] = {
 	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 45"			},
 	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 46"			},
 	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 47"			},
-	{ do_bad,		SIGKILL, SI_KERNEL,	"TLB conflict abort"		},
+	{ do_conflict_abort,	SIGKILL, SI_KERNEL,	"TLB conflict abort"		},
 	{ do_bad,		SIGKILL, SI_KERNEL,	"Unsupported atomic hardware update fault"	},
 	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 50"			},
 	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 51"			},
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index eb17f59e543c..4ee0fbb7765b 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -26,6 +26,7 @@ HAS_ECV
 HAS_ECV_CNTPOFF
 HAS_EPAN
 HAS_EVT
+HAS_BBML2
 HAS_FPMR
 HAS_FGT
 HAS_FPSIMD
-- 
2.45.2

