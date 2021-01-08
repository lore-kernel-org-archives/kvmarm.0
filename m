Return-Path: <SRS0=HOrx=GL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACF3FC433E6
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jan 2021 12:15:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2AD8C238E4
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jan 2021 12:15:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2AD8C238E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BA5644B388;
	Fri,  8 Jan 2021 07:15:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zAp0exUs+7Sd; Fri,  8 Jan 2021 07:15:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA2BA4B408;
	Fri,  8 Jan 2021 07:15:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E17184B230
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2021 07:15:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ET9MyaN4xonB for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Jan 2021 07:15:41 -0500 (EST)
Received: from mail-qt1-f202.google.com (mail-qt1-f202.google.com
 [209.85.160.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A91314B401
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2021 07:15:41 -0500 (EST)
Received: by mail-qt1-f202.google.com with SMTP id f33so8154866qtb.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Jan 2021 04:15:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=U7Ezu9BWvQQl3+odVqPz50z5xQDmhHP5/rCWfk/q+sQ=;
 b=JHhFj4U2WS5haunZ3iuTJrcTb98S1QwYxWw5N+fvVur6ZGQbm7UhHohf61X1JkhbvN
 ut1SdfYZaSpOoVkcidF1ynuHx36dawwj2Gbagonl4g9CuoJhsoZx83BLUtCuoSSj79Nq
 0CHi+rHOysdgysr2eOTDf8XaTtXlVmnwQ9nexay8EII07X792gzrdWracJ7x6cF1lEby
 g7tzoDCqDeBWnKLlXPYVbZdtqmn+8mMCzYFdIVDyl9nXxq8RoWXQWYk4umkpgEsfawg4
 DO6ggtYvRaWrEpyavTe+Zl2yBGcF3nwhiM43yVnP5jQt/iX8hnpGBGEStyzwV2zwYtRt
 E94g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=U7Ezu9BWvQQl3+odVqPz50z5xQDmhHP5/rCWfk/q+sQ=;
 b=mY8kuxjQObwrg2hTDwBS3ERX5p1Dpq8EGbFp/nK3sQd0j/SChQ6CnIu/5ZyG/goLBd
 bEm0QWonEguzQ0FDMRsEuMw9xgycJLw4+snFjq09GTH/zpeqBNApHefAYzA1LcmCYbUa
 kmItRAqEmAWnVH4/ibPsZRfM81soR+KspTEYEBVLI/mun6I18OGicqQm6RAFufRY9cOB
 leee5kajK6n6AA8nTaMEqQA25Cau33JtNVft5Z8cqQ2Su93DrLogo2OJjcvPDtwvDJKh
 oUinflroBRgyhzrfIfQrzLBQJujPgcdbkJjHYEjVwA2AupEYfai93/f30ef+PVat2RW8
 eaog==
X-Gm-Message-State: AOAM530f0jGZFnFQqqkrs9tu2hgRip8SU36xIYiCyvhr/CnHwxVeuaG0
 +TrX7jp0Zcjqpl0ES+I81KBMstHqcTKs
X-Google-Smtp-Source: ABdhPJw/4cr8P48R7RVf1xArteNINTq8P74DXyz+B4OUiC/ZzBFlkO7kRqbd09zSVKPjQ4dVKp1TcQnazFJK
X-Received: from r2d2-qp.c.googlers.com
 ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a0c:ea34:: with SMTP id
 t20mr3195107qvp.5.1610108141217; Fri, 08 Jan 2021 04:15:41 -0800 (PST)
Date: Fri,  8 Jan 2021 12:15:05 +0000
In-Reply-To: <20210108121524.656872-1-qperret@google.com>
Message-Id: <20210108121524.656872-8-qperret@google.com>
Mime-Version: 1.0
References: <20210108121524.656872-1-qperret@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [RFC PATCH v2 07/26] KVM: arm64: Introduce a BSS section for use at
 Hyp
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

Currently, the hyp code cannot make full use of a bss, as the kernel
section is mapped read-only.

While this mapping could simply be changed to read-write, it would
intermingle even more the hyp and kernel state than they currently are.
Instead, introduce a __hyp_bss section, that uses reserved pages, and
create the appropriate RW hyp mappings during KVM init.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/sections.h |  1 +
 arch/arm64/kernel/vmlinux.lds.S   |  7 +++++++
 arch/arm64/kvm/arm.c              | 11 +++++++++++
 arch/arm64/kvm/hyp/nvhe/hyp.lds.S |  1 +
 4 files changed, 20 insertions(+)

diff --git a/arch/arm64/include/asm/sections.h b/arch/arm64/include/asm/sections.h
index 8ff579361731..f58cf493de16 100644
--- a/arch/arm64/include/asm/sections.h
+++ b/arch/arm64/include/asm/sections.h
@@ -12,6 +12,7 @@ extern char __hibernate_exit_text_start[], __hibernate_exit_text_end[];
 extern char __hyp_idmap_text_start[], __hyp_idmap_text_end[];
 extern char __hyp_text_start[], __hyp_text_end[];
 extern char __hyp_data_ro_after_init_start[], __hyp_data_ro_after_init_end[];
+extern char __hyp_bss_start[], __hyp_bss_end[];
 extern char __idmap_text_start[], __idmap_text_end[];
 extern char __initdata_begin[], __initdata_end[];
 extern char __inittext_begin[], __inittext_end[];
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 43af13968dfd..3eca35d5a7cf 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -8,6 +8,13 @@
 #define RO_EXCEPTION_TABLE_ALIGN	8
 #define RUNTIME_DISCARD_EXIT
 
+#define BSS_FIRST_SECTIONS				\
+	. = ALIGN(PAGE_SIZE);				\
+	__hyp_bss_start = .;				\
+	*(.hyp.bss)					\
+	. = ALIGN(PAGE_SIZE);				\
+	__hyp_bss_end = .;
+
 #include <asm-generic/vmlinux.lds.h>
 #include <asm/cache.h>
 #include <asm/hyp_image.h>
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3ac0f3425833..51b53ca36dc5 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1770,7 +1770,18 @@ static int init_hyp_mode(void)
 		goto out_err;
 	}
 
+	/*
+	 * .hyp.bss is placed at the beginning of the .bss section, so map that
+	 * part RW, and the rest RO as the hyp shouldn't be touching it.
+	 */
 	err = create_hyp_mappings(kvm_ksym_ref(__bss_start),
+				  kvm_ksym_ref(__hyp_bss_end), PAGE_HYP);
+	if (err) {
+		kvm_err("Cannot map hyp bss section: %d\n", err);
+		goto out_err;
+	}
+
+	err = create_hyp_mappings(kvm_ksym_ref(__hyp_bss_end),
 				  kvm_ksym_ref(__bss_stop), PAGE_HYP_RO);
 	if (err) {
 		kvm_err("Cannot map bss section\n");
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp.lds.S b/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
index 5d76ff2ba63e..dc281d90063e 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
@@ -17,4 +17,5 @@ SECTIONS {
 		PERCPU_INPUT(L1_CACHE_BYTES)
 	}
 	HYP_SECTION(.data..ro_after_init)
+	HYP_SECTION(.bss)
 }
-- 
2.30.0.284.gd98b1dd5eaa7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
