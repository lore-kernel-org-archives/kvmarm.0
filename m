Return-Path: <SRS0=xhzu=LJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D54AC49EA3
	for <kvmarm@archiver.kernel.org>; Tue, 15 Jun 2021 13:40:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0025061477
	for <kvmarm@archiver.kernel.org>; Tue, 15 Jun 2021 13:40:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0025061477
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A41324B0F1;
	Tue, 15 Jun 2021 09:40:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DijT68otK4t6; Tue, 15 Jun 2021 09:40:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 706324B112;
	Tue, 15 Jun 2021 09:40:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 17C3C4B0DE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 09:40:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WhQ-bUdqjlqh for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Jun 2021 09:40:08 -0400 (EDT)
Received: from mail-qt1-f202.google.com (mail-qt1-f202.google.com
 [209.85.160.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5127B4B0D2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 09:40:08 -0400 (EDT)
Received: by mail-qt1-f202.google.com with SMTP id
 z17-20020ac86b910000b0290244cba55754so9399896qts.19
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 06:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=VfQdAQ7uIcnnol8WP3MAJ1Qz658s3J1UAqg2ZESplQg=;
 b=GB/OvLpHWQYkKpx5cgIPjSsgiCO/0SeHHg00IV+R5EwwGvpPUuJ3NyWsINgNyYiLdN
 mlosuQ5GgTlh/ZcIpP+badUaqisRGZC2wpy9jO/4zvpbzRgJbl4PbzOcCG2RCFZe60d1
 Qr/RiVEUELDt7POppvOCqJWRfXeT9spPt802g4JxuiCMJvc8RpbjYWNU0liaknwaxKuL
 6EKmTmWVU3arkrg0YeIB9RUg3H4ErXxDjyw1IZuhm0sOT1kg/ptyaR86/nKC7qJbkACd
 m7eihAKvPfx3vCyQ4Ji7W6wzuN2vBQb06Qo9agdogEOTRo+KJba8K4R1anCGuQJdk8Fl
 exAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=VfQdAQ7uIcnnol8WP3MAJ1Qz658s3J1UAqg2ZESplQg=;
 b=VVK/xTGX4+LkWocvluuiGfk6nxlZF+tGP6YnEAzBovC6mEp9taoikJDFMmfS8el/i5
 7sHdbj+W0C9dWyxMOho8QQep+xU7NbzHZIPpgwBgPvc/J/WNpn7sTUUn1SK9fm79vY0s
 OsNvzBItdtOyxc6ZkBfOdKyx5rm9IY8BypLb+DdLENSy/F2l5hrPwYSzCf3S8xJvsWMc
 9PegmG52rA772AniFYHVKkLwFE/s2N2k84AiOUkxtZSlvPvoyYpxssNz8mbFXiyZ5t5M
 b6p0jGTexea6R0kRxluBm9Ns+7B7xVKAPI4IjFMQ34LkQVUjDV16Un8KJfHIeHzYjLwV
 bN1w==
X-Gm-Message-State: AOAM531HqEcyHyEDgR6E3t/5JItLlLQfpXk55oNgqOzUjAgrahMJ5yGg
 +tpgdmJObKAfWd+kBWVURegaufw52QysN3i0x4KcUCThysvtc2YmKDUCITkV4gSHUkwQTR19AS6
 Pfs0YKD2mjqut0rtW9Il6kV/exfibeUbXpXV3uhAuTbJHnZwja9/nZiwF7o4i0CrfUH0=
X-Google-Smtp-Source: ABdhPJw8Gldeq6H0br2wzbB7/Hq61EgLe84lN0RJB8PupfGJ53qUB5Sd72DFkV2IO1ScQLocofjUKZqheg==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:ad4:450b:: with SMTP id
 k11mr4520634qvu.0.1623764407702; 
 Tue, 15 Jun 2021 06:40:07 -0700 (PDT)
Date: Tue, 15 Jun 2021 14:39:44 +0100
In-Reply-To: <20210615133950.693489-1-tabba@google.com>
Message-Id: <20210615133950.693489-8-tabba@google.com>
Mime-Version: 1.0
References: <20210615133950.693489-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH v2 07/13] KVM: arm64: Add config register bit definitions
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
 arch/arm64/include/asm/kvm_arm.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index bee1ba6773fb..a78090071f1f 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -12,7 +12,11 @@
 #include <asm/types.h>
 
 /* Hyp Configuration Register (HCR) bits */
+#define HCR_TID5	(UL(1) << 58)
+#define HCR_DCT		(UL(1) << 57)
 #define HCR_ATA		(UL(1) << 56)
+#define HCR_AMVOFFEN	(UL(1) << 51)
+#define HCR_FIEN	(UL(1) << 47)
 #define HCR_FWB		(UL(1) << 46)
 #define HCR_API		(UL(1) << 41)
 #define HCR_APK		(UL(1) << 40)
@@ -55,6 +59,7 @@
 #define HCR_PTW		(UL(1) << 2)
 #define HCR_SWIO	(UL(1) << 1)
 #define HCR_VM		(UL(1) << 0)
+#define HCR_RES0	((UL(1) << 48) | (UL(1) << 39))
 
 /*
  * The bits we set in HCR:
@@ -276,11 +281,21 @@
 #define CPTR_EL2_TZ	(1 << 8)
 #define CPTR_NVHE_EL2_RES1	0x000032ff /* known RES1 bits in CPTR_EL2 (nVHE) */
 #define CPTR_EL2_DEFAULT	CPTR_NVHE_EL2_RES1
+#define CPTR_NVHE_EL2_RES0	(GENMASK_ULL(63, 32) |	\
+				 GENMASK_ULL(29, 21) |	\
+				 GENMASK_ULL(19, 14) |	\
+				 (UL(1) << 11))
 
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
@@ -292,6 +307,12 @@
 #define MDCR_EL2_TPM		(UL(1) << 6)
 #define MDCR_EL2_TPMCR		(UL(1) << 5)
 #define MDCR_EL2_HPMN_MASK	(UL(0x1F))
+#define MDCR_EL2_RES0		(GENMASK_ULL(63, 37) |	\
+				 GENMASK_ULL(35, 30) |	\
+				 GENMASK_ULL(25, 24) |	\
+				 GENMASK_ULL(22, 20) |	\
+				 (UL(1) << 18) |	\
+				 GENMASK_ULL(16, 15))
 
 /* For compatibility with fault code shared with 32-bit */
 #define FSC_FAULT	ESR_ELx_FSC_FAULT
-- 
2.32.0.272.g935e593368-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
