Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EED30C4332F
	for <kvmarm@archiver.kernel.org>; Fri,  4 Nov 2022 06:21:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C2F24B1B7;
	Fri,  4 Nov 2022 02:21:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@bytedance-com.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Lwe92a7Ha6Ig; Fri,  4 Nov 2022 02:21:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D1C04B092;
	Fri,  4 Nov 2022 02:21:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 96BAA40EEF
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 02:21:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7iK9rdzuR7nR for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Nov 2022 02:21:17 -0400 (EDT)
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com
 [209.85.128.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 38B4449F3B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 02:21:16 -0400 (EDT)
Received: by mail-wm1-f49.google.com with SMTP id
 ja4-20020a05600c556400b003cf6e77f89cso4889338wmb.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Nov 2022 23:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=bytedance-com.20210112.gappssmtp.com; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=3gm+CCMBzGV2wY5tpR1ywTaFubhsMnT6RUSMviBRIrA=;
 b=2tmx0ZEzKlapeA40O0da60uijCZiQnnvovriTJgT3C3YW39LcGgvxSgN7m0Ms0JXRr
 D92XuuUCup3qht8mttWG9ecOOEurQnH46+r4Oaj2PNwPaCuW57yvPYegBdCMNT8MnSoU
 NOlY3X6PELYB51vtQkE4j/wGUNXLmEKjmPzkuW9/jS+OiQ316dllc8FPxAsGI0rzGUTU
 5q2tEAFlf54tRihF1fQBaPZ+jK4//Gke9zNI4MbzwaxlCrgaYBonTRPX25KVZrENs1J3
 Xow0dCWTcpfW0PdaLQ/uzBW2WBuW1Aegf7XTWh65W1L5iuGy79EZUOzhsxIypYrmCsE+
 u/Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=3gm+CCMBzGV2wY5tpR1ywTaFubhsMnT6RUSMviBRIrA=;
 b=50hjsbvryWDKSSaycw2kOBshGcElIQP5DhHf3ash3Z6tGVlDzQim6mDy0kRnGePgjY
 RoHCbFJMlqm48pZUwOPm/syDOHBPSKiRFB6MXDB7K46t40UH7wZ6iGCVYBvn/F7pfKDq
 +QMachCi+eH54uffDLfPzjDh31S0GfvTOjXY16ewOO7MVegmzgDGf3q17hFvu3u9olJT
 wTeFZGsSHCXaDokMPrjotGFJ9jw7FUbE5RHEcviRhICZUW4mjkSCX4ohwhVRNEfqjo9w
 S+DAQWpE1GrX3U1SZJGLQC0smsaOMAR2Oe2Xwpk3m04HfV8Qjzid77rbsMwaRb/gvuCP
 a9bQ==
X-Gm-Message-State: ACrzQf3wb+a7EqV8teUzRqiE7DvvBupBxDZ2TlP+nGyGghXZFuRPnFmn
 Y7tgkGEYSJIk+qKTg1oTjfoX8Q==
X-Google-Smtp-Source: AMsMyM7cP7o2Mb3eYYy1AVu03sQGOtx3okUtdbwIqzpIe6O5ZDxr+oIbMBpI7JrFVBYNndSa4ueUzw==
X-Received: by 2002:a05:600c:3b87:b0:3cf:59ea:ea26 with SMTP id
 n7-20020a05600c3b8700b003cf59eaea26mr26647184wms.159.1667542875338; 
 Thu, 03 Nov 2022 23:21:15 -0700 (PDT)
Received: from usaari01.cust.communityfibre.co.uk
 ([2a02:6b6a:b4d7:0:c7c:f931:dd4c:1ea6])
 by smtp.gmail.com with ESMTPSA id
 w11-20020a5d608b000000b002366f9bd717sm3099924wrt.45.2022.11.03.23.21.14
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 03 Nov 2022 23:21:14 -0700 (PDT)
From: Usama Arif <usama.arif@bytedance.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux@armlinux.org.uk, yezengruan@huawei.com, catalin.marinas@arm.com,
 will@kernel.org, maz@kernel.org, steven.price@arm.com,
 mark.rutland@arm.com, bagasdotme@gmail.com
Subject: [v2 2/6] KVM: arm64: Add SMCCC paravirtualised lock calls
Date: Fri,  4 Nov 2022 06:21:01 +0000
Message-Id: <20221104062105.4119003-3-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221104062105.4119003-1-usama.arif@bytedance.com>
References: <20221104062105.4119003-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Cc: punit.agrawal@bytedance.com, fam.zheng@bytedance.com, liangma@liangbit.com,
 Usama Arif <usama.arif@bytedance.com>
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

Add a new SMCCC compatible hypercalls for PV lock features:
  ARM_SMCCC_KVM_FUNC_PV_LOCK:   0xC6000002

Also add the header file which defines the ABI for the paravirtualized
lock features we're about to add.

Signed-off-by: Zengruan Ye <yezengruan@huawei.com>
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
---
 arch/arm64/include/asm/pvlock-abi.h | 17 +++++++++++++++++
 include/linux/arm-smccc.h           |  8 ++++++++
 tools/include/linux/arm-smccc.h     |  8 ++++++++
 3 files changed, 33 insertions(+)
 create mode 100644 arch/arm64/include/asm/pvlock-abi.h

diff --git a/arch/arm64/include/asm/pvlock-abi.h b/arch/arm64/include/asm/pvlock-abi.h
new file mode 100644
index 000000000000..3f4574071679
--- /dev/null
+++ b/arch/arm64/include/asm/pvlock-abi.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright(c) 2019 Huawei Technologies Co., Ltd
+ * Author: Zengruan Ye <yezengruan@huawei.com>
+ *         Usama Arif <usama.arif@bytedance.com>
+ */
+
+#ifndef __ASM_PVLOCK_ABI_H
+#define __ASM_PVLOCK_ABI_H
+
+struct pvlock_vcpu_state {
+	__le64 preempted;
+	/* Structure must be 64 byte aligned, pad to that size */
+	u8 padding[56];
+} __packed;
+
+#endif
diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index 220c8c60e021..104c10035b10 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -112,6 +112,7 @@
 /* KVM "vendor specific" services */
 #define ARM_SMCCC_KVM_FUNC_FEATURES		0
 #define ARM_SMCCC_KVM_FUNC_PTP			1
+#define ARM_SMCCC_KVM_FUNC_PV_LOCK		2
 #define ARM_SMCCC_KVM_FUNC_FEATURES_2		127
 #define ARM_SMCCC_KVM_NUM_FUNCS			128
 
@@ -151,6 +152,13 @@
 			   ARM_SMCCC_OWNER_STANDARD_HYP,	\
 			   0x21)
 
+/* Paravirtualised lock calls */
+#define ARM_SMCCC_VENDOR_HYP_KVM_PV_LOCK_FUNC_ID		\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
+			   ARM_SMCCC_SMC_64,			\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,		\
+			   ARM_SMCCC_KVM_FUNC_PV_LOCK)
+
 /* TRNG entropy source calls (defined by ARM DEN0098) */
 #define ARM_SMCCC_TRNG_VERSION					\
 	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
diff --git a/tools/include/linux/arm-smccc.h b/tools/include/linux/arm-smccc.h
index 63ce9bebccd3..c21e539c0228 100644
--- a/tools/include/linux/arm-smccc.h
+++ b/tools/include/linux/arm-smccc.h
@@ -111,6 +111,7 @@
 /* KVM "vendor specific" services */
 #define ARM_SMCCC_KVM_FUNC_FEATURES		0
 #define ARM_SMCCC_KVM_FUNC_PTP			1
+#define ARM_SMCCC_KVM_FUNC_PV_LOCK		2
 #define ARM_SMCCC_KVM_FUNC_FEATURES_2		127
 #define ARM_SMCCC_KVM_NUM_FUNCS			128
 
@@ -150,6 +151,13 @@
 			   ARM_SMCCC_OWNER_STANDARD_HYP,	\
 			   0x21)
 
+/* Paravirtualised lock calls */
+#define ARM_SMCCC_VENDOR_HYP_KVM_PV_LOCK_FUNC_ID		\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
+			   ARM_SMCCC_SMC_64,			\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,		\
+			   ARM_SMCCC_KVM_FUNC_PV_LOCK)
+
 /* TRNG entropy source calls (defined by ARM DEN0098) */
 #define ARM_SMCCC_TRNG_VERSION					\
 	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
