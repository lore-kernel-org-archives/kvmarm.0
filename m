Received: from mail-oi1-f202.google.com (mail-oi1-f202.google.com [209.85.167.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8A530F7F2
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 19:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781292554; cv=none; b=XeMTrgDX3DLiej1Mu9YBLwDOKUxEQrZJR06QLHMekcw7wW6E9q34kPSR+IPBpS+R7Mt6v/B3bBLhh79nscGbnJ8DQ2/lCgPLboKbdkpid+vTetLSgA2n801TzRA+FenQQv2sbXCpQuIZbeCQ43PiUpv+QHMW2zcAtMkMXbkSHKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781292554; c=relaxed/simple;
	bh=5kGKr+m+2SakCtheR8UcEY2IRqG2QSoWSyyeWDBZdSA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WTqd9MYA0JfJn9WfFHBqVP7U7PP34Sx0hJAMX2Rnz6pCD2ZfzcQJDqTWS03/crw7O8IdFMDR9A1RvP7F9KsIMGivLnfmx0BDl+RvdlWGeAwD/jf/VXFIvq4QLlWSW9js0N5EvoYKhC53gSl7fC+SSwAZT6EK2sYiKUyyv1YpDSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=A5HUEs0J; arc=none smtp.client-ip=209.85.167.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A5HUEs0J"
Received: by mail-oi1-f202.google.com with SMTP id 5614622812f47-4865626337fso1313868b6e.2
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 12:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781292551; x=1781897351; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HlOJEoz94FuxFi6Nw0eWYLZk82W0XKPPEF+zFyUMrwY=;
        b=A5HUEs0Jpu35zF55sR5LQX4Eo+zbs1eY7QTmwF3yRSorC+NokqbLc/6neiVdaHK1L5
         rLGs1sQUpzwsN8Ax4laXZbxj0bW7aBos/wF3mOdjM15rt/+QeSkSvSZZCRaoefE4zS/T
         UzG8Rpx5bKvr3tJpezRxNp1MaL/Ege5/g0I8Kp966QWuRLbw1dfn4B1EL1Q3/Zr8/XlZ
         mpPcW+3aT7ifa8Ho5Mva/aem/yft2eYP+dUqgXmhzWJfnJmaXjSfeqf8k6YP2nV0nxwU
         b8hEzkg0qVHFAvwlZJZBrX3b8ne2kHMmxvYE2IVU1VdH2fm7PmBQoAsUPszCuf6w2VYM
         LEuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781292551; x=1781897351;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HlOJEoz94FuxFi6Nw0eWYLZk82W0XKPPEF+zFyUMrwY=;
        b=MQEKEKdDH92Pu3/t23F3uWQCBCg4LlTy0yUmpCb8fxkcFVEpD9KfTMRaeBbPcByozX
         1zv43mH7D4yadPzahpJv8hOlg16EVyPcaO4kYYD9A0kgeHOuENCA4bZw8geIHs16Xapv
         u9rwhzGmpFg3OpmstTznETvk/6fhJt/F+PoYXOws6g/exRMxetKgTrhnF2wzdBxVNO/h
         V6/EDuR7O7I5m9elKZtQs262tTFWsa3XlhXx2B/CU0/yEYN05/GpU92Fdl9ztNwlNxJP
         iQPQWSRkWJ4nRNvSek2ME+VvxdTKzrvzvDPC6eYqRXCwzcJY5FUIdQPKyvdcgSnFJhmi
         wrIA==
X-Forwarded-Encrypted: i=1; AFNElJ9bXaITO3kmr8b081Yj+6lyGSUjXJ5sOTZR2D/b03XgOcuwIi68TloShcXobirYYL3TzLCZ6Y8=@lists.linux.dev
X-Gm-Message-State: AOJu0YwRz30EbLwgwaX/e+NmFDZBjwaXlrCdNxlh8jeVVJxNg9z6K9Yv
	EsJ9eDiXghBGyOFa4d3mszDSYb+Msm3CeMLeHwk3s3OadhRgqTyKlxBRsypvFE8+/JjuGTozA//
	7UhOkFtLcbdUxvxUzza8h9070tQ==
X-Received: from ilb5-n2.prod.google.com ([2002:a05:6e02:5305:20b0:500:2417:f074])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1913:b0:486:45c7:34c5 with SMTP id 5614622812f47-487419e6d1emr682785b6e.17.1781292551319;
 Fri, 12 Jun 2026 12:29:11 -0700 (PDT)
Date: Fri, 12 Jun 2026 19:28:49 +0000
In-Reply-To: <20260612192909.1153907-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260612192909.1153907-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260612192909.1153907-2-coltonlewis@google.com>
Subject: [PATCH 01/21] arm64: cpufeature: Add cpucap for HPMN0
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Mingwei Zhang <mizhang@google.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Shuah Khan <shuah@kernel.org>, Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, 
	James Clark <james.clark@linaro.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a capability for FEAT_HPMN0, whether MDCR_EL2.HPMN can specify 0
counters reserved for the guest.

This required changing HPMN0 to an UnsignedEnum in tools/sysreg
because otherwise not all the appropriate macros are generated to add
it to arm64_cpu_capabilities_arm64_features.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kernel/cpufeature.c | 10 +++++++++-
 arch/arm64/kvm/sys_regs.c      |  3 ++-
 arch/arm64/tools/cpucaps       |  1 +
 arch/arm64/tools/sysreg        |  6 +++---
 4 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 6d53bb15cf7bb..096545a6e4043 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -77,7 +77,7 @@
 #include <linux/percpu.h>
 #include <linux/sched/isolation.h>
 
-#include <asm/arm_pmuv3.h>
+#include <linux/perf/arm_pmuv3.h>
 #include <asm/cpu.h>
 #include <asm/cpufeature.h>
 #include <asm/cpu_ops.h>
@@ -560,6 +560,7 @@ static const struct arm64_ftr_bits ftr_id_mmfr0[] = {
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64dfr0[] = {
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR0_EL1_HPMN0_SHIFT, 4, 0),
 	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR0_EL1_DoubleLock_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR0_EL1_PMSVer_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR0_EL1_CTX_CMPs_SHIFT, 4, 0),
@@ -2965,6 +2966,13 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_cpuid_feature,
 		ARM64_CPUID_FIELDS(ID_AA64MMFR0_EL1, FGT, FGT2)
 	},
+	{
+		.desc = "HPMN0",
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.capability = ARM64_HAS_HPMN0,
+		.matches = has_cpuid_feature,
+		ARM64_CPUID_FIELDS(ID_AA64DFR0_EL1, HPMN0, IMP)
+	},
 #ifdef CONFIG_ARM64_SME
 	{
 		.desc = "Scalable Matrix Extension",
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index fa5c93c7a1352..c52873a6f91ed 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3326,7 +3326,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 		    ID_AA64DFR0_EL1_DoubleLock_MASK |
 		    ID_AA64DFR0_EL1_WRPs_MASK |
 		    ID_AA64DFR0_EL1_PMUVer_MASK |
-		    ID_AA64DFR0_EL1_DebugVer_MASK),
+		    ID_AA64DFR0_EL1_DebugVer_MASK |
+		    ID_AA64DFR0_EL1_HPMN0_MASK),
 	ID_SANITISED(ID_AA64DFR1_EL1),
 	ID_UNALLOCATED(5,2),
 	ID_UNALLOCATED(5,3),
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 811c2479e82d6..f8fb4a6395428 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -42,6 +42,7 @@ HAS_GIC_PRIO_MASKING
 HAS_GIC_PRIO_RELAXED_SYNC
 HAS_ICH_HCR_EL2_TDIR
 HAS_HCR_NV1
+HAS_HPMN0
 HAS_HCX
 HAS_LDAPR
 HAS_LPA2
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 6c3ff14e561e6..2d5cbc8ced114 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1679,9 +1679,9 @@ EndEnum
 EndSysreg
 
 Sysreg	ID_AA64DFR0_EL1	3	0	0	5	0
-Enum	63:60	HPMN0
-	0b0000	UNPREDICTABLE
-	0b0001	DEF
+UnsignedEnum	63:60	HPMN0
+	0b0000	NI
+	0b0001	IMP
 EndEnum
 UnsignedEnum	59:56	ExtTrcBuff
 	0b0000	NI
-- 
2.54.0.1136.gdb2ca164c4-goog

