Return-Path: <SRS0=HOrx=GL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F64BC433E6
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jan 2021 12:15:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 228A0239EB
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jan 2021 12:15:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 228A0239EB
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A478A4B428;
	Fri,  8 Jan 2021 07:15:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qWKlapV+mXCl; Fri,  8 Jan 2021 07:15:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C031D4B43E;
	Fri,  8 Jan 2021 07:15:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0889C4B378
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2021 07:15:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id l7xcrqICy71v for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Jan 2021 07:15:55 -0500 (EST)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D92AF4B408
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2021 07:15:54 -0500 (EST)
Received: by mail-wr1-f74.google.com with SMTP id g16so4102715wrv.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Jan 2021 04:15:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=XzM1R3G7iPuwWNhb7rvYlamX+8/2PUNQToNsyQEZsII=;
 b=DcKmxLORRq1M0kuovDWg/xP8OMXxTwrOF1DgVrJ/oZz0DDarrYz/XCNtKeRq0PM4mL
 7mQ905PXF/2WcWqR2bVtKvBb9Q+EMqd5Hq+Lg6bsWrbGaqf3uU/GlBoNOe8+C/LLcvVa
 npkwZ24gaoPrrTbndrnH41KXYZ6dDPFfxalkWli3+0tT2E0KNcXHnF4bczzCYIqCpy62
 jVveL/voAZz6EHnXr8YMtycQPIBQL2Vyp5SRGeNs0mDC8Cjy/wrExpKmHyt7ZvQxbPGk
 FygyqJW6IE3D/K9yDrMsA67cOEunpV3gtHa2n+TpA3pBPU7IO6whLEj9Bu2wJJVCkQo0
 isCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=XzM1R3G7iPuwWNhb7rvYlamX+8/2PUNQToNsyQEZsII=;
 b=jRG5wPRMlCBbTnFyua71j5EFukyNwp6jzDG2KP1sIpu8/xuCWasauPhoPkdcixXIMY
 +y15HYVkoKQAGc0qdMoF+seaiZOVKSb46twN6piUlKFZcNJ/etcJIGfMUF300MLKsL9d
 U7HzdTENQLys+dG3axaF6cpmABX8w0vdyEItDmC+OhlPSWTkxHEKvZb+VVMySuOmUt9e
 6sLrjiDDlzykGDk/+CjOQ5b12hUCNEiYBWsTSOB3fuxXeTebkMsd6502JG6iMxxQiIq0
 wOCDREkFcG3bMVaqCfhPJ3k7Nh3sGAFYyKjMK1l5E7OV5DK1TQ40LUmBmfs1wB8MNsvu
 EgRw==
X-Gm-Message-State: AOAM5322FlaSssdCZnqeCoGcon5LJejhhN2d9SER0UzJMYAor3wvYRDA
 85cmYw3QHXqi6i8wsglzAk7SvlEOwEIp
X-Google-Smtp-Source: ABdhPJyFmSVG1I0i2SdgXi2p2BgXDRlYslbUGi+bLN946AWy1KJL4BIuJSWsCymKp386o9X+cEeV1PaXK082
X-Received: from r2d2-qp.c.googlers.com
 ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a05:600c:250:: with SMTP id
 16mr2864472wmj.6.1610108154051; Fri, 08 Jan 2021 04:15:54 -0800 (PST)
Date: Fri,  8 Jan 2021 12:15:11 +0000
In-Reply-To: <20210108121524.656872-1-qperret@google.com>
Message-Id: <20210108121524.656872-14-qperret@google.com>
Mime-Version: 1.0
References: <20210108121524.656872-1-qperret@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [RFC PATCH v2 13/26] KVM: arm64: Enable access to sanitized CPU
 features at EL2
From: Quentin Perret <qperret@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>
Cc: devicetree@vger.kernel.org, android-kvm@google.com,
 linux-kernel@vger.kernel.org, Fuad Tabba <tabba@google.com>,
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

Introduce the infrastructure in KVM enabling to copy CPU feature
registers into EL2-owned data-structures, to allow reading sanitised
values directly at EL2 in nVHE.

Given that only a subset of these features are being read by the
hypervisor, the ones that need to be copied are to be listed under
<asm/kvm_cpufeature.h> together with the name of the nVHE variable that
will hold the copy.

While at it, introduce the first user of this infrastructure by
implementing __flush_dcache_area at EL2, which needs
arm64_ftr_reg_ctrel0.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/cpufeature.h     |  1 +
 arch/arm64/include/asm/kvm_cpufeature.h | 17 ++++++++++++++
 arch/arm64/kernel/cpufeature.c          | 12 ++++++++++
 arch/arm64/kvm/arm.c                    | 31 +++++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/Makefile        |  3 ++-
 arch/arm64/kvm/hyp/nvhe/cache.S         | 13 +++++++++++
 arch/arm64/kvm/hyp/nvhe/cpufeature.c    |  8 +++++++
 7 files changed, 84 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/include/asm/kvm_cpufeature.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/cache.S
 create mode 100644 arch/arm64/kvm/hyp/nvhe/cpufeature.c

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 16063c813dcd..742e9bcc051b 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -600,6 +600,7 @@ void __init setup_cpu_features(void);
 void check_local_cpu_capabilities(void);
 
 u64 read_sanitised_ftr_reg(u32 id);
+int copy_ftr_reg(u32 id, struct arm64_ftr_reg *dst);
 
 static inline bool cpu_supports_mixed_endian_el0(void)
 {
diff --git a/arch/arm64/include/asm/kvm_cpufeature.h b/arch/arm64/include/asm/kvm_cpufeature.h
new file mode 100644
index 000000000000..d34f85cba358
--- /dev/null
+++ b/arch/arm64/include/asm/kvm_cpufeature.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2020 - Google LLC
+ * Author: Quentin Perret <qperret@google.com>
+ */
+
+#include <asm/cpufeature.h>
+
+#ifndef KVM_HYP_CPU_FTR_REG
+#if defined(__KVM_NVHE_HYPERVISOR__)
+#define KVM_HYP_CPU_FTR_REG(id, name) extern struct arm64_ftr_reg name;
+#else
+#define KVM_HYP_CPU_FTR_REG(id, name) DECLARE_KVM_NVHE_SYM(name);
+#endif
+#endif
+
+KVM_HYP_CPU_FTR_REG(SYS_CTR_EL0, arm64_ftr_reg_ctrel0)
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index bc3549663957..c2019aaaadc3 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1113,6 +1113,18 @@ u64 read_sanitised_ftr_reg(u32 id)
 }
 EXPORT_SYMBOL_GPL(read_sanitised_ftr_reg);
 
+int copy_ftr_reg(u32 id, struct arm64_ftr_reg *dst)
+{
+	struct arm64_ftr_reg *regp = get_arm64_ftr_reg(id);
+
+	if (!regp)
+		return -EINVAL;
+
+	memcpy(dst, regp, sizeof(*regp));
+
+	return 0;
+}
+
 #define read_sysreg_case(r)	\
 	case r:		return read_sysreg_s(r)
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 51b53ca36dc5..9fd769349e9e 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -34,6 +34,7 @@
 #include <asm/virt.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_asm.h>
+#include <asm/kvm_cpufeature.h>
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_emulate.h>
 #include <asm/sections.h>
@@ -1697,6 +1698,29 @@ static void teardown_hyp_mode(void)
 	}
 }
 
+#undef KVM_HYP_CPU_FTR_REG
+#define KVM_HYP_CPU_FTR_REG(id, name) \
+	{ .sys_id = id, .dst = (struct arm64_ftr_reg *)&kvm_nvhe_sym(name) },
+static const struct __ftr_reg_copy_entry {
+	u32			sys_id;
+	struct arm64_ftr_reg	*dst;
+} hyp_ftr_regs[] = {
+	#include <asm/kvm_cpufeature.h>
+};
+
+static int copy_cpu_ftr_regs(void)
+{
+	int i, ret;
+
+	for (i = 0; i < ARRAY_SIZE(hyp_ftr_regs); i++) {
+		ret = copy_ftr_reg(hyp_ftr_regs[i].sys_id, hyp_ftr_regs[i].dst);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 /**
  * Inits Hyp-mode on all online CPUs
  */
@@ -1705,6 +1729,13 @@ static int init_hyp_mode(void)
 	int cpu;
 	int err = 0;
 
+	/*
+	 * Copy the required CPU feature register in their EL2 counterpart
+	 */
+	err = copy_cpu_ftr_regs();
+	if (err)
+		return err;
+
 	/*
 	 * Allocate Hyp PGD and setup Hyp identity mapping
 	 */
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 9e5eacfec6ec..72cfe53f106f 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -10,7 +10,8 @@ lib-objs := clear_page.o copy_page.o memcpy.o memset.o
 lib-objs := $(addprefix ../../../lib/, $(lib-objs))
 
 obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
-	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o stub.o page_alloc.o
+	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o stub.o page_alloc.o \
+	 cache.o cpufeature.o
 obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o
 obj-y += $(lib-objs)
diff --git a/arch/arm64/kvm/hyp/nvhe/cache.S b/arch/arm64/kvm/hyp/nvhe/cache.S
new file mode 100644
index 000000000000..36cef6915428
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/cache.S
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Code copied from arch/arm64/mm/cache.S.
+ */
+
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+#include <asm/alternative.h>
+
+SYM_FUNC_START_PI(__flush_dcache_area)
+	dcache_by_line_op civac, sy, x0, x1, x2, x3
+	ret
+SYM_FUNC_END_PI(__flush_dcache_area)
diff --git a/arch/arm64/kvm/hyp/nvhe/cpufeature.c b/arch/arm64/kvm/hyp/nvhe/cpufeature.c
new file mode 100644
index 000000000000..a887508f996f
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/cpufeature.c
@@ -0,0 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2020 - Google LLC
+ * Author: Quentin Perret <qperret@google.com>
+ */
+
+#define KVM_HYP_CPU_FTR_REG(id, name) struct arm64_ftr_reg name;
+#include <asm/kvm_cpufeature.h>
-- 
2.30.0.284.gd98b1dd5eaa7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
