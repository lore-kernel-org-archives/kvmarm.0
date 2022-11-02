Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72F1CC43219
	for <kvmarm@archiver.kernel.org>; Wed,  2 Nov 2022 16:49:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CA184B95A;
	Wed,  2 Nov 2022 12:49:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@bytedance-com.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id c2mNYAC4VyEc; Wed,  2 Nov 2022 12:49:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 89C7F4B9AF;
	Wed,  2 Nov 2022 12:49:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C97E4B964
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2022 12:14:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qeC+FaxoOloH for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Nov 2022 12:14:21 -0400 (EDT)
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com
 [209.85.221.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6241E4B93C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2022 12:14:21 -0400 (EDT)
Received: by mail-wr1-f44.google.com with SMTP id k8so25293423wrh.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Nov 2022 09:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=bytedance-com.20210112.gappssmtp.com; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=r6tj+7sNHNnTbkzs8ZeKL5miL5fHgtHHC3d2WQTSFbE=;
 b=KuAbtL9XTBizhGI/s9UKTASCs9n5mCuzpUBAjDKPpPPbTBikgNbBtzoyDhdJz3rdNU
 mmnuIzpAEBxAKkL+DSU3LgSNMu7c5yAJmdwZrv3aqDlQYsO7Ila4V+71ZfNrywCdFHeQ
 qz+K94xhrzF57uJqLYDnlI27OVmAWXosKtVna3HQNbDzOffVPx8/KVkDFCHIYs+85RoB
 2pIindGfcIhgS8XCYFTKhsqqN5wJwSPlJEbGfiTQOJ2fr0OI9nBwpHz9KNF4c4QZfMYH
 1imRxckHe24zPJoQfARJnpU3RhMO+dr1NG35zgb/SwU0IahY+x1Gdzd60NEOPYSKZ5Il
 VTRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=r6tj+7sNHNnTbkzs8ZeKL5miL5fHgtHHC3d2WQTSFbE=;
 b=y5Mfd8QR+RsIOcHwPwg1FvkdTmtp0eixDRnVm2konGNqXbiovDDZYg9/mzZ9g2Gnhg
 pVRZVXyBfl0jKdLkfkL3OKiUwqf+omwQlNamEH8ZdVO3Ri/BgmOhlETghmiFiBN183Sv
 wpNEnI66P3Ceii6yfmDV2N5V9ep00m9x7tXyehWac0fF1uH01durgnxvk//Zjtz/+vgI
 DhSxyFDnpMzYFcf3hZ42nXqGp0/tBmmlTb9AFtMh7blG+6xYJ7zKbmwgABg5qFDMG0Mh
 r4uZ1Miyu3Cv7uvRphYSSIwLqM5L9iI52L1u5vxR2L5CbaRFgZ5ivhGe64EHUKrhNq4a
 8ZZA==
X-Gm-Message-State: ACrzQf1FQz3CUTwfOJZnG6k+YfYpNyMdzo0oA8Z/wQQUyvPSCbFV6ywS
 ertr+mPHmfE01LHH373Gj6Utyw==
X-Google-Smtp-Source: AMsMyM7D3GBwOzz5QAuoLmf+oB2TmG0p9ILQukZoZQKCpczeNQrlwRKtrJtUrLcSObIcUbD2rOZ3WQ==
X-Received: by 2002:a5d:5410:0:b0:236:fe1:bb74 with SMTP id
 g16-20020a5d5410000000b002360fe1bb74mr15694845wrv.512.1667405660181; 
 Wed, 02 Nov 2022 09:14:20 -0700 (PDT)
Received: from usaari01.cust.communityfibre.co.uk
 ([2a02:6b6a:b4d7:0:6a08:9b26:ab04:7065])
 by smtp.gmail.com with ESMTPSA id
 m17-20020a5d56d1000000b0022cc6b8df5esm13230923wrw.7.2022.11.02.09.14.19
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 02 Nov 2022 09:14:19 -0700 (PDT)
From: Usama Arif <usama.arif@bytedance.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux@armlinux.org.uk, yezengruan@huawei.com, catalin.marinas@arm.com,
 will@kernel.org, maz@kernel.org, steven.price@arm.com, mark.rutland@arm.com
Subject: [RFC 2/6] KVM: arm64: Add SMCCC paravirtualised lock calls
Date: Wed,  2 Nov 2022 16:13:36 +0000
Message-Id: <20221102161340.2982090-3-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221102161340.2982090-1-usama.arif@bytedance.com>
References: <20221102161340.2982090-1-usama.arif@bytedance.com>
MIME-Version: 1.0
X-Mailman-Approved-At: Wed, 02 Nov 2022 12:49:29 -0400
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

Add two new SMCCC compatible hypercalls for PV lock features:
  PV_LOCK_FEATURES:   0xC6000020
  PV_LOCK_PREEMPTED:  0xC6000021

Also add the header file which defines the ABI for the paravirtualized
lock features we're about to add.

Signed-off-by: Zengruan Ye <yezengruan@huawei.com>
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
---
 arch/arm64/include/asm/pvlock-abi.h | 17 +++++++++++++++++
 include/linux/arm-smccc.h           | 13 +++++++++++++
 2 files changed, 30 insertions(+)
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
index 220c8c60e021..6360333e0f64 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -151,6 +151,19 @@
 			   ARM_SMCCC_OWNER_STANDARD_HYP,	\
 			   0x21)
 
+/* Paravirtualised lock calls */
+#define ARM_SMCCC_HV_PV_LOCK_FEATURES				\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
+			   ARM_SMCCC_SMC_64,			\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,		\
+			   0x20)
+
+#define ARM_SMCCC_HV_PV_LOCK_PREEMPTED				\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
+			   ARM_SMCCC_SMC_64,			\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,		\
+			   0x21)
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
