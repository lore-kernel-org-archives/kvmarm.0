Return-Path: <SRS0=6VsV=NI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2215EC4320A
	for <kvmarm@archiver.kernel.org>; Tue, 17 Aug 2021 08:12:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CC94660F58
	for <kvmarm@archiver.kernel.org>; Tue, 17 Aug 2021 08:12:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CC94660F58
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 81B834B13E;
	Tue, 17 Aug 2021 04:12:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IUigqM1mEHUj; Tue, 17 Aug 2021 04:12:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E7864B18B;
	Tue, 17 Aug 2021 04:12:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CFFC4B15F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Aug 2021 04:12:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QDR+vh6NtQEl for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Aug 2021 04:12:09 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D35484B181
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Aug 2021 04:11:57 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id
 r14-20020a0c8d0e0000b02902e82df307f0so14314407qvb.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Aug 2021 01:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=a1FkHacsvxlpxAzLdiQ+8Ppyqt1oFw+G4RPgD2elyDM=;
 b=t0d/tLo4vOpJ97R2R+WJ7E/Mn4CRyatYvLNI5+XDc6d/D+D+iLgcP9l1mJgMMW9YmC
 kVwXzlYCgOVFk41QkuGxihN3Ogbvf8N7scHCRdnhB4nAXWmv7IzXURY2zHD/BEaiAYQ6
 TjllHsJE6UJZxmu5jPld1CQCptRH4i9F1tLftMV5Up+OoJBqprQPLjcmAPDwjY/fPrPm
 MgayAcPlA5qUJ9BfoFBR4cwAWBAWBStqE38TrSHqPxMV2Y/TZ/+xqz54kWQ1t5U7JoFY
 tyqZiyJQxEAJV5Ngl04xPkh8FINI1IP4yATCktZ30SJa5aIxa3ns9CXj2hbSkYio9nU2
 0ZrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=a1FkHacsvxlpxAzLdiQ+8Ppyqt1oFw+G4RPgD2elyDM=;
 b=tlah8/wie9WX7k9wIdT2SZf4kmm5tB+ArGCSWwkxcIQGbxTlKmbbbemduCcxA4JZqR
 7k5rxUI7XWFgVVdspasp5xByV8N73cwSs08BlDxjZDxnacV5kHXIXN9m8T9H626ZC5v9
 lYVhovee2Xobyzf1JI5mdhZgC6NsZnTD0E6x7F1k9QI/T59KTJFCVymNcsnN0XlCoaW8
 kvPYugPYpsBxfcMEuuRnUW0B0i7nOC3hu/oq67HTIOco4pQFZcWlFBF9pUokjuCgV8oN
 y5vIbxyGyhXgyrJy6Av6u9lrtCxFjuR9aRj3FRFRKCvi7tdo8y2BVkkYTPUQXjcTBXnq
 9VXg==
X-Gm-Message-State: AOAM532KfJFyp3I1SlXEmL7dOIiH1qVXHxcR/MRoIIFUJiL7jYam6h6r
 /Eqii2qjT1tb3VrKHKZI/lb4nwEITV3HM4UChcktuMKqRaGvFJdIEdEsIot/yb4h9nFHHZ6iNcG
 J100CyLnFQrjbmYnBBRJwUldrZ/TLNhWh7ynkHkJmb5ZjsC32N7X0TFTSiD+J2a30Ew4=
X-Google-Smtp-Source: ABdhPJxzcsyia+26TWJ1TMac1dWdSAXLmVDa71Pii4xoLoi/YWFmQv5nVNTZT9RkOEJvlwiLzHDZH4e6Ug==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:6214:10c4:: with SMTP id
 r4mr2134444qvs.58.1629187917427; Tue, 17 Aug 2021 01:11:57 -0700 (PDT)
Date: Tue, 17 Aug 2021 09:11:29 +0100
In-Reply-To: <20210817081134.2918285-1-tabba@google.com>
Message-Id: <20210817081134.2918285-11-tabba@google.com>
Mime-Version: 1.0
References: <20210817081134.2918285-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v4 10/15] KVM: arm64: Add config register bit definitions
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

Acked-by: Will Deacon <will@kernel.org>
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
2.33.0.rc1.237.g0d66db33f3-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
