Return-Path: <SRS0=FmU0=ML=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3806FC07E95
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 16:04:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DF3E66146D
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 16:04:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DF3E66146D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 93B354AED4;
	Mon, 19 Jul 2021 12:04:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4LoT7my1txM2; Mon, 19 Jul 2021 12:04:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 98DD64A00B;
	Mon, 19 Jul 2021 12:04:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA74C49F5F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 12:04:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YoypQAxWzLwU for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Jul 2021 12:04:08 -0400 (EDT)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BA7C64A5A0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 12:04:07 -0400 (EDT)
Received: by mail-wm1-f74.google.com with SMTP id
 z127-20020a1c7e850000b02901e46e4d52c0so4131849wmc.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 09:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=vw+9k8TKpKtQTjxQwt2hnUGZ2NjHx/OJWiEJkCkz1N4=;
 b=sLPNtiMKmja20KaICWALYJ4ofuflIkIOE7nOQiX2tSdy3n44fa65SqsexcWWzl79/k
 Z7NBRtSnzz84wnQ6qLdJBL9GKE6UqQRfIh9ZD/Zoc8s71akMHsfvR8BYC9nCYfsXApFF
 MIS5H9GeVm2hzhNrZefd/v7Iq5w9JKQ+ZNYm981SW4oHqDsDNDynCD92CM8+0qbF0RdZ
 6XxEFgfBgwlbMM19NhgJBIln16v5px7eZiRLqfqSDmJiQl05wtPSSWN7FF6W6wdd5xTW
 PJBOFw3SNSRE5rRfXYRnucerBoTwqihx1C3ukxGoX4Azbb2q1755m61BUT1R25v9ql7K
 3rpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=vw+9k8TKpKtQTjxQwt2hnUGZ2NjHx/OJWiEJkCkz1N4=;
 b=NUhPD90Vt3HQl3bHCEnLO4D0wqLtoAHKxlU2OePILQwIPJi+B6szCfjIz57y2nBFKc
 LtVLYkv0I//dGRD3MFl1GK3oRL3eUKQfpmiciy4ebApVJDpn9B/0YJS7gRwvxLLS1+no
 rTRnarA/IttU4vdux/LMB3muhuzpnLlgmoYFWwX4f3Xv17pq+xxtQqk7dvuHMF/2Ts4f
 6iB+ZlOc6VhR5Kn8H+to2UCPIc3Af8tF3GRbO3SB9aeOslHUyz9Ov/C4LLo5xG8QUmbf
 LSM+gI4FeZriFR6C41KE4sL9qwdS7nrWXgvHUVZB8MwwklpvCpP1FVBWkTelvt2PcAao
 kZ/Q==
X-Gm-Message-State: AOAM532my7KNYPGpeMp9g1wbR747y3Ld90YHAZ4kWUUN3mlZHnl2SpJB
 6AT/4ZYnf0JPlQ9ftqtp4Kb4wNfmrssBaMixyD8sHeWAwZKBiNd77lXcMKdpolyb49JHsuwd6Bo
 N2li1mIF8IPZmGObn3gkM+5q1P2Non8LFqDeAjoRJ5e+n1ASs0lZ2mRdWY/Q5sFPtP4Y=
X-Google-Smtp-Source: ABdhPJwqgGr1dc9ElvS+DtbtyF4398Jwb9HePJzbzjhsmwOOPQEhoV8D79HvGRx3Y9ug0QbreOeQr0qtmQ==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:adf:ea0f:: with SMTP id
 q15mr30547671wrm.145.1626710646765; 
 Mon, 19 Jul 2021 09:04:06 -0700 (PDT)
Date: Mon, 19 Jul 2021 17:03:40 +0100
In-Reply-To: <20210719160346.609914-1-tabba@google.com>
Message-Id: <20210719160346.609914-10-tabba@google.com>
Mime-Version: 1.0
References: <20210719160346.609914-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v3 09/15] KVM: arm64: Add config register bit definitions
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, will@kernel.org, linux-arm-kernel@lists.infradead.org
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

Add hardware configuration register bit definitions for HCR_EL2
and MDCR_EL2. Future patches toggle these hyp configuration
register bits to trap on certain accesses.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_arm.h | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index a928b2dc0b0f..327120c0089f 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -12,8 +12,13 @@
 #include <asm/types.h>
 
 /* Hyp Configuration Register (HCR) bits */
+
+#define HCR_TID5	(UL(1) << 58)
+#define HCR_DCT		(UL(1) << 57)
 #define HCR_ATA_SHIFT	56
 #define HCR_ATA		(UL(1) << HCR_ATA_SHIFT)
+#define HCR_AMVOFFEN	(UL(1) << 51)
+#define HCR_FIEN	(UL(1) << 47)
 #define HCR_FWB		(UL(1) << 46)
 #define HCR_API		(UL(1) << 41)
 #define HCR_APK		(UL(1) << 40)
@@ -56,6 +61,7 @@
 #define HCR_PTW		(UL(1) << 2)
 #define HCR_SWIO	(UL(1) << 1)
 #define HCR_VM		(UL(1) << 0)
+#define HCR_RES0	((UL(1) << 48) | (UL(1) << 39))
 
 /*
  * The bits we set in HCR:
@@ -277,11 +283,21 @@
 #define CPTR_EL2_TZ	(1 << 8)
 #define CPTR_NVHE_EL2_RES1	0x000032ff /* known RES1 bits in CPTR_EL2 (nVHE) */
 #define CPTR_EL2_DEFAULT	CPTR_NVHE_EL2_RES1
+#define CPTR_NVHE_EL2_RES0	(GENMASK(63, 32) |	\
+				 GENMASK(29, 21) |	\
+				 GENMASK(19, 14) |	\
+				 BIT(11))
 
 /* Hyp Debug Configuration Register bits */
 #define MDCR_EL2_E2TB_MASK	(UL(0x3))
 #define MDCR_EL2_E2TB_SHIFT	(UL(24))
+#define MDCR_EL2_HPMFZS		(UL(1) << 36)
+#define MDCR_EL2_HPMFZO		(UL(1) << 29)
+#define MDCR_EL2_MTPME		(UL(1) << 28)
+#define MDCR_EL2_TDCC		(UL(1) << 27)
+#define MDCR_EL2_HCCD		(UL(1) << 23)
 #define MDCR_EL2_TTRF		(UL(1) << 19)
+#define MDCR_EL2_HPMD		(UL(1) << 17)
 #define MDCR_EL2_TPMS		(UL(1) << 14)
 #define MDCR_EL2_E2PB_MASK	(UL(0x3))
 #define MDCR_EL2_E2PB_SHIFT	(UL(12))
@@ -293,6 +309,12 @@
 #define MDCR_EL2_TPM		(UL(1) << 6)
 #define MDCR_EL2_TPMCR		(UL(1) << 5)
 #define MDCR_EL2_HPMN_MASK	(UL(0x1F))
+#define MDCR_EL2_RES0		(GENMASK(63, 37) |	\
+				 GENMASK(35, 30) |	\
+				 GENMASK(25, 24) |	\
+				 GENMASK(22, 20) |	\
+				 BIT(18) |		\
+				 GENMASK(16, 15))
 
 /* For compatibility with fault code shared with 32-bit */
 #define FSC_FAULT	ESR_ELx_FSC_FAULT
-- 
2.32.0.402.g57bb445576-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
