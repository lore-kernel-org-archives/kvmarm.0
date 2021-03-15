Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 526EBC433DB
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 14:36:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D00BD65012
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 14:36:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D00BD65012
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7257F4B60B;
	Mon, 15 Mar 2021 10:36:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4w9ZxmX+Zdph; Mon, 15 Mar 2021 10:36:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 090804B71E;
	Mon, 15 Mar 2021 10:36:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 725C44B316
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 10:36:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wawY5wy2BP0W for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 10:36:51 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 67A604B70B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 10:36:51 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id 75so15079992wrl.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 07:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=AA7WNBlUpAMSn2MPgzLs0H4xGSlUKHXKOJZW0a7DVr8=;
 b=HeeWafaKs1HfgyYwhqnBsqj7EK/JP92Y1I97LGu+XsaGNx4whjki/w/Xz28ogNllvE
 b0nYVRKWRncPCFEbY0JXosEAosQURum1lxLWf6JY4ooTP7CEqSoUkpG+z3FsL8xKO4sn
 V85Ha8YcUJ/k28GR12KlKLEz8Uz4W6Vf2vyEBz9epFHY6S1Q+U4MS8mR1c6sD/QWlCgc
 I8wdtWxIEQ2QqVHUVh1zepYacBo20vrjz7i8tIJOsNoqxBx0JdsK4KZksiihTA39E4SJ
 8Of/8rpeQD6QG4DxY7Qa3HgzKToUx87gJXhwQx0yE97b3VWUmrjYUOymLfDY67HKJcmu
 D7QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=AA7WNBlUpAMSn2MPgzLs0H4xGSlUKHXKOJZW0a7DVr8=;
 b=FnZgGGvvLLxtQxyeVMtPD/S3bPAe4/u9cBDumzKQLzb67Nq2cAkFAfl5Tk3KEz/r+e
 kpTr5Rw+H06rLbo0ThbnrI1eJ8NFPzu1d0UDo4quANoiSt4U19l1e2Yn6cqE8MF0Vko+
 YURVqIyuTjgFgOsdPSgYh2OylBWZn1Dtm7k514agJ5HEoYKjyY2nqfQNug+ilgsJk7qt
 kCTXJV/cLPFwwnti5S+P78tl4+5l4Y++Tv4XX+rV+5BrBhA/+b2BQR/J53LJLPI6Ue9P
 6AHRib9N98Ow6PXceZKBnOS3l88AclNK0jr+h6tY3u5UruhkwrgdJY0m0vprKqLpvWhn
 I1Fg==
X-Gm-Message-State: AOAM532kb2UUPUXpNEhshzpBg9GxEVPNn0bkOVEccPDBSTDfgPfbaRkR
 D97Ce400wZpSDnEsRAY5cBf+3QushVCx
X-Google-Smtp-Source: ABdhPJxAvSUEErjsvOYHEMkOG9WC8BDpEz7C+7gjZsMj3MWQ0vfpsnAIsGPSV9GXjDX/nZy7FrSUOvIbWZvo
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a05:600c:b57:: with SMTP id
 k23mr14700303wmr.145.1615819010555; Mon, 15 Mar 2021 07:36:50 -0700 (PDT)
Date: Mon, 15 Mar 2021 14:35:34 +0000
In-Reply-To: <20210315143536.214621-1-qperret@google.com>
Message-Id: <20210315143536.214621-35-qperret@google.com>
Mime-Version: 1.0
References: <20210315143536.214621-1-qperret@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v5 34/36] KVM: arm64: Page-align the .hyp sections
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
