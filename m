Return-Path: <SRS0=QSSN=IR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A66EC433DB
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 10:03:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 059D964F6C
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 10:03:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 059D964F6C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FBD94B77F;
	Fri, 19 Mar 2021 06:03:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id R-NZIwTfvXec; Fri, 19 Mar 2021 06:03:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9260D4B78A;
	Fri, 19 Mar 2021 06:03:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B7AAD4B705
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 06:03:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xfFtUffDk1-8 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Mar 2021 06:03:08 -0400 (EDT)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A6EB74B78C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 06:03:08 -0400 (EDT)
Received: by mail-wm1-f73.google.com with SMTP id i14so12665111wmq.7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 03:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=AA7WNBlUpAMSn2MPgzLs0H4xGSlUKHXKOJZW0a7DVr8=;
 b=g6COKlYT+eckZdu5xAOckwGpUXKA9H6Qgud4TFedl+pq2YS9z0gDuP+KNGqmM+ZTED
 ht7R/jAxdq01sOoYtLegobcdL/BF4TLsBHewEY7qhv3/Ob2uLkuy/dFaqNWUtUxXPDW4
 Ik8ybK59zS1JZ/59bk91tr0PVu6Ab6kfoJ9TkSQ9a+LACl8aC1AXyL8bGVFi6TgxbhvP
 Re24YoLaRJt6Z1lunO6V0LZdNPjWpeRaLzn5ITQasNnPF5QzgNYAZYgsDY7EuS8jZmxz
 bjZ/pEV0OsrP0ehBWaOvArfR/BzilI9l9ZLsphurimgP4WEXDXAcfiqpC02XwUt1Ky9O
 KPRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=AA7WNBlUpAMSn2MPgzLs0H4xGSlUKHXKOJZW0a7DVr8=;
 b=O7v5W2Qm2SUqSqAeUvBXNhyPlVc/RkZhWcec14thnBe8CuC1VPNhw5s6ihJAOPMqhZ
 pu/9iedVeQmrDh+9oL6tqZevY47qM0BMVVWKbkliNlHO3QvAyNxg6hdUB8KWyNpDZ5xN
 j6SeseaL/xk7/rS8PB8jivJ3Do/+M77ZS3V4mfymKiJBHCmyAPEMhGEgN3k0tlOdgyM6
 JJJv3po3FDyx/ORVwwrfPrbnoZql0FudVLBtjSOwQJS1v2tQEb3veF4ApkkQrpTiomBg
 Jzl5vWBG9FU3LU1bSuwlNUzQDfHEw3g5J3DF6NlDgJeGn++CQbS/fhnIn+U8saVEOGEn
 kk5w==
X-Gm-Message-State: AOAM533cJZh8LGnYvkekAVlP95gyYOVhIqeEbfr/45v5R+0zLKNPjHt8
 B9el2HCZes5SHb6Tw8AztJpWepp54aAu
X-Google-Smtp-Source: ABdhPJxdoamqBPvUaIPZGeaUvK2O5XS8PpgugDa2anPwgCns8QoOGnR1vBU/siA6pmqWqUz4MxMaMhNseFSJ
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a7b:c18e:: with SMTP id
 y14mr1312625wmi.1.1616148187003; Fri, 19 Mar 2021 03:03:07 -0700 (PDT)
Date: Fri, 19 Mar 2021 10:01:44 +0000
In-Reply-To: <20210319100146.1149909-1-qperret@google.com>
Message-Id: <20210319100146.1149909-37-qperret@google.com>
Mime-Version: 1.0
References: <20210319100146.1149909-1-qperret@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v6 36/38] KVM: arm64: Page-align the .hyp sections
From: Quentin Perret <qperret@google.com>
To: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
Cc: android-kvm@google.com, seanjc@google.com, mate.toth-pal@arm.com,
 linux-kernel@vger.kernel.org, robh+dt@kernel.org, tabba@google.com,
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

We will soon unmap the .hyp sections from the host stage 2 in Protected
nVHE mode, which obviously works with at least page granularity, so make
sure to align them correctly.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kernel/vmlinux.lds.S | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index e96173ce211b..709d2c433c5e 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -15,9 +15,11 @@
 
 #define HYPERVISOR_DATA_SECTIONS				\
 	HYP_SECTION_NAME(.rodata) : {				\
+		. = ALIGN(PAGE_SIZE);				\
 		__hyp_rodata_start = .;				\
 		*(HYP_SECTION_NAME(.data..ro_after_init))	\
 		*(HYP_SECTION_NAME(.rodata))			\
+		. = ALIGN(PAGE_SIZE);				\
 		__hyp_rodata_end = .;				\
 	}
 
@@ -72,21 +74,14 @@ ENTRY(_text)
 jiffies = jiffies_64;
 
 #define HYPERVISOR_TEXT					\
-	/*						\
-	 * Align to 4 KB so that			\
-	 * a) the HYP vector table is at its minimum	\
-	 *    alignment of 2048 bytes			\
-	 * b) the HYP init code will not cross a page	\
-	 *    boundary if its size does not exceed	\
-	 *    4 KB (see related ASSERT() below)		\
-	 */						\
-	. = ALIGN(SZ_4K);				\
+	. = ALIGN(PAGE_SIZE);				\
 	__hyp_idmap_text_start = .;			\
 	*(.hyp.idmap.text)				\
 	__hyp_idmap_text_end = .;			\
 	__hyp_text_start = .;				\
 	*(.hyp.text)					\
 	HYPERVISOR_EXTABLE				\
+	. = ALIGN(PAGE_SIZE);				\
 	__hyp_text_end = .;
 
 #define IDMAP_TEXT					\
@@ -322,11 +317,12 @@ SECTIONS
 #include "image-vars.h"
 
 /*
- * The HYP init code and ID map text can't be longer than a page each,
- * and should not cross a page boundary.
+ * The HYP init code and ID map text can't be longer than a page each. The
+ * former is page-aligned, but the latter may not be with 16K or 64K pages, so
+ * it should also not cross a page boundary.
  */
-ASSERT(__hyp_idmap_text_end - (__hyp_idmap_text_start & ~(SZ_4K - 1)) <= SZ_4K,
-	"HYP init code too big or misaligned")
+ASSERT(__hyp_idmap_text_end - __hyp_idmap_text_start <= PAGE_SIZE,
+	"HYP init code too big")
 ASSERT(__idmap_text_end - (__idmap_text_start & ~(SZ_4K - 1)) <= SZ_4K,
 	"ID map text too big or misaligned")
 #ifdef CONFIG_HIBERNATION
-- 
2.31.0.rc2.261.g7f71774620-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
