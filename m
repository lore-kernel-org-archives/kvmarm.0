Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07039C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  4 Jan 2022 19:49:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B234D49EE5;
	Tue,  4 Jan 2022 14:49:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id brVl9V9f12AM; Tue,  4 Jan 2022 14:49:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BC6949F10;
	Tue,  4 Jan 2022 14:49:55 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D15949F52
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jan 2022 14:49:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aiDGMckV9g7P for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Jan 2022 14:49:51 -0500 (EST)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E3D064A100
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jan 2022 14:49:50 -0500 (EST)
Received: by mail-pf1-f201.google.com with SMTP id
 b17-20020aa78ed1000000b004badf95ccd9so18987141pfr.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 04 Jan 2022 11:49:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Qh+Ta1S1fpLiR/qxOoRTJEsN2xZx8MgQiasnAqhdpKI=;
 b=qodIf5Sp0toMDWuz4GnHwkIJE7T0eJwJj7XdaK4HqwgEu61RrjXaMGtG5bAQYFHgVU
 XQcbOArXF9hWDYXtgUBPFe5RyyNHqj8HKDG02or+gF7hxJERFIWFsZHnwRYBGF2RrLA7
 prLizFfZU0oVimzxlpTk/p/99n5bho38zEkuFfff1jJdzeML07UR8iJYyS1CtXONZ5rs
 AljuEwculfNWBzfaqhoKHArHZUo3q3zZwuRTeLhq13TdxnCWghpnjMsPTu2eprtgW5nZ
 jWzFSYNxr+6LetRwqZtkS11nYTGkvBl4tJTOFtZyoV7NLuTS/ruVNZ1ISutQcLymDVfF
 m1jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Qh+Ta1S1fpLiR/qxOoRTJEsN2xZx8MgQiasnAqhdpKI=;
 b=hdWzsvgFZhsjOSzer+GFnHXUuRDKb2rw4QSjiYDTlfz2CzCk2ijw3DIiMPTCu7S+N6
 hAHKDYKQptpZaV7HcixyL2F3/cUTzhuQJdFR2ZbJJc792Pny+9TZqgB5AbXDzRIp6fNg
 DTWWIU0dvHP4pEJeD/V/ms4xDbVeDSCcccfhBlK9Bdaoq7x02dFWnfeI+ezyNuafpicQ
 sRZ5ShLnoniSVr4+sPmMZy20CJYG05n03LelH6eNYxD0rJqPlaEu3rMXlS6fGqbQcOP+
 Z6W+YiYpOCwbGnuk2KjftPDMfkm0Q9VhuslS5JG8+JYGxe1Uwl++5yXkSp3ir3c29t4U
 8evQ==
X-Gm-Message-State: AOAM530p0XOnfp71GR+H62/9fGoTyaAp62ujyBFVGR4dBfNILiGiOG6U
 YGLycrf1toyd2djLzC73ZMy0NylOB/BZ
X-Google-Smtp-Source: ABdhPJzEcOK1lKVsqRgejas/1/ODbiZ6XD+PSPqokzg/dQ4xnV0fHqas6nJzWvta/wCbrQlVjD2PNFNdskdz
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:aa7:9f09:0:b0:4bc:683b:439 with SMTP id
 g9-20020aa79f09000000b004bc683b0439mr22142412pfr.86.1641325790162; Tue, 04
 Jan 2022 11:49:50 -0800 (PST)
Date: Tue,  4 Jan 2022 19:49:16 +0000
In-Reply-To: <20220104194918.373612-1-rananta@google.com>
Message-Id: <20220104194918.373612-10-rananta@google.com>
Mime-Version: 1.0
References: <20220104194918.373612-1-rananta@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [RFC PATCH v3 09/11] tools: Import ARM SMCCC definitions
From: Raghavendra Rao Ananta <rananta@google.com>
To: Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>, 
 James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Import the standard SMCCC definitions from include/linux/arm-smccc.h.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 tools/include/linux/arm-smccc.h | 188 ++++++++++++++++++++++++++++++++
 1 file changed, 188 insertions(+)
 create mode 100644 tools/include/linux/arm-smccc.h

diff --git a/tools/include/linux/arm-smccc.h b/tools/include/linux/arm-smccc.h
new file mode 100644
index 000000000000..a11c0bbabd5b
--- /dev/null
+++ b/tools/include/linux/arm-smccc.h
@@ -0,0 +1,188 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2015, Linaro Limited
+ */
+#ifndef __LINUX_ARM_SMCCC_H
+#define __LINUX_ARM_SMCCC_H
+
+#include <linux/const.h>
+
+/*
+ * This file provides common defines for ARM SMC Calling Convention as
+ * specified in
+ * https://developer.arm.com/docs/den0028/latest
+ *
+ * This code is up-to-date with version DEN 0028 C
+ */
+
+#define ARM_SMCCC_STD_CALL	        _AC(0,U)
+#define ARM_SMCCC_FAST_CALL	        _AC(1,U)
+#define ARM_SMCCC_TYPE_SHIFT		31
+
+#define ARM_SMCCC_SMC_32		0
+#define ARM_SMCCC_SMC_64		1
+#define ARM_SMCCC_CALL_CONV_SHIFT	30
+
+#define ARM_SMCCC_OWNER_MASK		0x3F
+#define ARM_SMCCC_OWNER_SHIFT		24
+
+#define ARM_SMCCC_FUNC_MASK		0xFFFF
+
+#define ARM_SMCCC_IS_FAST_CALL(smc_val)	\
+	((smc_val) & (ARM_SMCCC_FAST_CALL << ARM_SMCCC_TYPE_SHIFT))
+#define ARM_SMCCC_IS_64(smc_val) \
+	((smc_val) & (ARM_SMCCC_SMC_64 << ARM_SMCCC_CALL_CONV_SHIFT))
+#define ARM_SMCCC_FUNC_NUM(smc_val)	((smc_val) & ARM_SMCCC_FUNC_MASK)
+#define ARM_SMCCC_OWNER_NUM(smc_val) \
+	(((smc_val) >> ARM_SMCCC_OWNER_SHIFT) & ARM_SMCCC_OWNER_MASK)
+
+#define ARM_SMCCC_CALL_VAL(type, calling_convention, owner, func_num) \
+	(((type) << ARM_SMCCC_TYPE_SHIFT) | \
+	((calling_convention) << ARM_SMCCC_CALL_CONV_SHIFT) | \
+	(((owner) & ARM_SMCCC_OWNER_MASK) << ARM_SMCCC_OWNER_SHIFT) | \
+	((func_num) & ARM_SMCCC_FUNC_MASK))
+
+#define ARM_SMCCC_OWNER_ARCH		0
+#define ARM_SMCCC_OWNER_CPU		1
+#define ARM_SMCCC_OWNER_SIP		2
+#define ARM_SMCCC_OWNER_OEM		3
+#define ARM_SMCCC_OWNER_STANDARD	4
+#define ARM_SMCCC_OWNER_STANDARD_HYP	5
+#define ARM_SMCCC_OWNER_VENDOR_HYP	6
+#define ARM_SMCCC_OWNER_TRUSTED_APP	48
+#define ARM_SMCCC_OWNER_TRUSTED_APP_END	49
+#define ARM_SMCCC_OWNER_TRUSTED_OS	50
+#define ARM_SMCCC_OWNER_TRUSTED_OS_END	63
+
+#define ARM_SMCCC_FUNC_QUERY_CALL_UID  0xff01
+
+#define ARM_SMCCC_QUIRK_NONE		0
+#define ARM_SMCCC_QUIRK_QCOM_A6		1 /* Save/restore register a6 */
+
+#define ARM_SMCCC_VERSION_1_0		0x10000
+#define ARM_SMCCC_VERSION_1_1		0x10001
+#define ARM_SMCCC_VERSION_1_2		0x10002
+#define ARM_SMCCC_VERSION_1_3		0x10003
+
+#define ARM_SMCCC_1_3_SVE_HINT		0x10000
+
+#define ARM_SMCCC_VERSION_FUNC_ID					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   0, 0)
+
+#define ARM_SMCCC_ARCH_FEATURES_FUNC_ID					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   0, 1)
+
+#define ARM_SMCCC_ARCH_SOC_ID						\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   0, 2)
+
+#define ARM_SMCCC_ARCH_WORKAROUND_1					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   0, 0x8000)
+
+#define ARM_SMCCC_ARCH_WORKAROUND_2					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   0, 0x7fff)
+
+#define ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID				\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
+			   ARM_SMCCC_FUNC_QUERY_CALL_UID)
+
+/* KVM UID value: 28b46fb6-2ec5-11e9-a9ca-4b564d003a74 */
+#define ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_0	0xb66fb428U
+#define ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_1	0xe911c52eU
+#define ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_2	0x564bcaa9U
+#define ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_3	0x743a004dU
+
+/* KVM "vendor specific" services */
+#define ARM_SMCCC_KVM_FUNC_FEATURES		0
+#define ARM_SMCCC_KVM_FUNC_PTP			1
+#define ARM_SMCCC_KVM_FUNC_FEATURES_2		127
+#define ARM_SMCCC_KVM_NUM_FUNCS			128
+
+#define ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID			\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
+			   ARM_SMCCC_KVM_FUNC_FEATURES)
+
+#define SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED	1
+
+/*
+ * ptp_kvm is a feature used for time sync between vm and host.
+ * ptp_kvm module in guest kernel will get service from host using
+ * this hypercall ID.
+ */
+#define ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID				\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
+			   ARM_SMCCC_KVM_FUNC_PTP)
+
+/* ptp_kvm counter type ID */
+#define KVM_PTP_VIRT_COUNTER			0
+#define KVM_PTP_PHYS_COUNTER			1
+
+/* Paravirtualised time calls (defined by ARM DEN0057A) */
+#define ARM_SMCCC_HV_PV_TIME_FEATURES				\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
+			   ARM_SMCCC_SMC_64,			\
+			   ARM_SMCCC_OWNER_STANDARD_HYP,	\
+			   0x20)
+
+#define ARM_SMCCC_HV_PV_TIME_ST					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
+			   ARM_SMCCC_SMC_64,			\
+			   ARM_SMCCC_OWNER_STANDARD_HYP,	\
+			   0x21)
+
+/* TRNG entropy source calls (defined by ARM DEN0098) */
+#define ARM_SMCCC_TRNG_VERSION					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
+			   ARM_SMCCC_SMC_32,			\
+			   ARM_SMCCC_OWNER_STANDARD,		\
+			   0x50)
+
+#define ARM_SMCCC_TRNG_FEATURES					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
+			   ARM_SMCCC_SMC_32,			\
+			   ARM_SMCCC_OWNER_STANDARD,		\
+			   0x51)
+
+#define ARM_SMCCC_TRNG_GET_UUID					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
+			   ARM_SMCCC_SMC_32,			\
+			   ARM_SMCCC_OWNER_STANDARD,		\
+			   0x52)
+
+#define ARM_SMCCC_TRNG_RND32					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
+			   ARM_SMCCC_SMC_32,			\
+			   ARM_SMCCC_OWNER_STANDARD,		\
+			   0x53)
+
+#define ARM_SMCCC_TRNG_RND64					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
+			   ARM_SMCCC_SMC_64,			\
+			   ARM_SMCCC_OWNER_STANDARD,		\
+			   0x53)
+
+/*
+ * Return codes defined in ARM DEN 0070A
+ * ARM DEN 0070A is now merged/consolidated into ARM DEN 0028 C
+ */
+#define SMCCC_RET_SUCCESS			0
+#define SMCCC_RET_NOT_SUPPORTED			-1
+#define SMCCC_RET_NOT_REQUIRED			-2
+#define SMCCC_RET_INVALID_PARAMETER		-3
+
+#endif /*__LINUX_ARM_SMCCC_H*/
-- 
2.34.1.448.ga2b2bfdf31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
