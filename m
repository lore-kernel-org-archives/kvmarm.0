Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A608C433E0
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 14:36:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C2F6D64F91
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 14:36:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C2F6D64F91
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 75AFE4B525;
	Mon, 15 Mar 2021 10:36:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id b6799XQMtK1f; Mon, 15 Mar 2021 10:36:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 63C414B604;
	Mon, 15 Mar 2021 10:35:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 265104B5E7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 10:35:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id n1PySeZWSZTB for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 10:35:56 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 019244B5A3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 10:35:55 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id y5so15186588wrp.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 07:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=YZ/TJ8544r/cIimuF4tq7iBp2nvTUzw9xctrN4cslBs=;
 b=AY/u1mH3eVDmBX/B+MsmEGCoOU7pNrDV50CkR9fKMMsr+Oif7cI1ajXFxedjQgKt/y
 sKiDwfguHqTx0q/Po/HlIfnqyNAQTdKKW2E5vsN8bhGESmg93UAuYpr4HjO4SvTsyc5G
 tHC0QwzKY1MH3pP5UkPhiYZgiBC9cRJA9aW6QlewRpYeaC+X7iF7v2REapg7+u997Jpw
 Q22qFiPBqAkQeT2QBerbaxaG8Hb/3DA+TiUqF8ZhgqDi8fW7zTdp3FAVfpbmbGzBlw7X
 IRroZXfO5gNcib48xFvyRz+2ehEymI9c2D3If9a3IsT6iIiTA0NFfUy81HHOuCkLAhh8
 aaug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=YZ/TJ8544r/cIimuF4tq7iBp2nvTUzw9xctrN4cslBs=;
 b=lgyqZ7ZzxpdV5yZFaG2YI7X+/gJJ9UKY2A1j3bI8+fSNtbGZYbwoCNQEaUWazhJTge
 gPXjOF2SuL36LhNfEYhYsFgWHQNh6WVDUjqyM4olm9ubOqT6gE95UWShM+Tu4X1v3nPS
 y21zkAYATnXOgeE0Eb9tJkxKCIIi5BWE78OvZmTKJ/syy0PAXtlDNSLuPd4wHJKloH5h
 C3joY5SVG7s9/PXUvvn2om+6YkTpT9W9/JXxr5qQfKDMTaMXG8cgmYc0tZZuh55QHIeO
 xPAayUrzOrKJjkcBxEKk0z7f/mQWYrvF8MroaAwD8LeGyZtfPV0K7D3AH2nNxLSZCbbc
 X2qg==
X-Gm-Message-State: AOAM532dFUPaFs5yc4xMSnW0Rxjf4ljCWbcj0a0+7lg93bg3kSU27bxZ
 ZPF1z333Hm9JAnT6QXbqExJc/39z+PN+
X-Google-Smtp-Source: ABdhPJzAP8GDMniHB+e8vB07G0Y5zSCnWugrj1o8MSaeFFNRNtxQgBGxeuDVNS2WyBRWX3zDHwOC4aE58S0l
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a1c:df46:: with SMTP id
 w67mr12007wmg.176.1615818955131; Mon, 15 Mar 2021 07:35:55 -0700 (PDT)
Date: Mon, 15 Mar 2021 14:35:07 +0000
In-Reply-To: <20210315143536.214621-1-qperret@google.com>
Message-Id: <20210315143536.214621-8-qperret@google.com>
Mime-Version: 1.0
References: <20210315143536.214621-1-qperret@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v5 07/36] KVM: arm64: Introduce a BSS section for use at Hyp
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

Currently, the hyp code cannot make full use of a bss, as the kernel
section is mapped read-only.

While this mapping could simply be changed to read-write, it would
intermingle even more the hyp and kernel state than they currently are.
Instead, introduce a __hyp_bss section, that uses reserved pages, and
create the appropriate RW hyp mappings during KVM init.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/sections.h |  1 +
 arch/arm64/kernel/vmlinux.lds.S   | 52 ++++++++++++++++++++-----------
 arch/arm64/kvm/arm.c              | 14 ++++++++-
 arch/arm64/kvm/hyp/nvhe/hyp.lds.S |  1 +
 4 files changed, 49 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/include/asm/sections.h b/arch/arm64/include/asm/sections.h
index 2f36b16a5b5d..e4ad9db53af1 100644
--- a/arch/arm64/include/asm/sections.h
+++ b/arch/arm64/include/asm/sections.h
@@ -13,6 +13,7 @@ extern char __hyp_idmap_text_start[], __hyp_idmap_text_end[];
 extern char __hyp_text_start[], __hyp_text_end[];
 extern char __hyp_rodata_start[], __hyp_rodata_end[];
 extern char __hyp_reloc_begin[], __hyp_reloc_end[];
+extern char __hyp_bss_start[], __hyp_bss_end[];
 extern char __idmap_text_start[], __idmap_text_end[];
 extern char __initdata_begin[], __initdata_end[];
 extern char __inittext_begin[], __inittext_end[];
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 7eea7888bb02..e96173ce211b 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -5,24 +5,7 @@
  * Written by Martin Mares <mj@atrey.karlin.mff.cuni.cz>
  */
 
-#define RO_EXCEPTION_TABLE_ALIGN	8
-#define RUNTIME_DISCARD_EXIT
-
-#include <asm-generic/vmlinux.lds.h>
-#include <asm/cache.h>
 #include <asm/hyp_image.h>
-#include <asm/kernel-pgtable.h>
-#include <asm/memory.h>
-#include <asm/page.h>
-
-#include "image.h"
-
-OUTPUT_ARCH(aarch64)
-ENTRY(_text)
-
-jiffies = jiffies_64;
-
-
 #ifdef CONFIG_KVM
 #define HYPERVISOR_EXTABLE					\
 	. = ALIGN(SZ_8);					\
@@ -51,13 +34,43 @@ jiffies = jiffies_64;
 		__hyp_reloc_end = .;				\
 	}
 
+#define BSS_FIRST_SECTIONS					\
+	__hyp_bss_start = .;					\
+	*(HYP_SECTION_NAME(.bss))				\
+	. = ALIGN(PAGE_SIZE);					\
+	__hyp_bss_end = .;
+
+/*
+ * We require that __hyp_bss_start and __bss_start are aligned, and enforce it
+ * with an assertion. But the BSS_SECTION macro places an empty .sbss section
+ * between them, which can in some cases cause the linker to misalign them. To
+ * work around the issue, force a page alignment for __bss_start.
+ */
+#define SBSS_ALIGN			PAGE_SIZE
 #else /* CONFIG_KVM */
 #define HYPERVISOR_EXTABLE
 #define HYPERVISOR_DATA_SECTIONS
 #define HYPERVISOR_PERCPU_SECTION
 #define HYPERVISOR_RELOC_SECTION
+#define SBSS_ALIGN			0
 #endif
 
+#define RO_EXCEPTION_TABLE_ALIGN	8
+#define RUNTIME_DISCARD_EXIT
+
+#include <asm-generic/vmlinux.lds.h>
+#include <asm/cache.h>
+#include <asm/kernel-pgtable.h>
+#include <asm/memory.h>
+#include <asm/page.h>
+
+#include "image.h"
+
+OUTPUT_ARCH(aarch64)
+ENTRY(_text)
+
+jiffies = jiffies_64;
+
 #define HYPERVISOR_TEXT					\
 	/*						\
 	 * Align to 4 KB so that			\
@@ -276,7 +289,7 @@ SECTIONS
 	__pecoff_data_rawsize = ABSOLUTE(. - __initdata_begin);
 	_edata = .;
 
-	BSS_SECTION(0, 0, 0)
+	BSS_SECTION(SBSS_ALIGN, 0, 0)
 
 	. = ALIGN(PAGE_SIZE);
 	init_pg_dir = .;
@@ -324,6 +337,9 @@ ASSERT(__hibernate_exit_text_end - (__hibernate_exit_text_start & ~(SZ_4K - 1))
 ASSERT((__entry_tramp_text_end - __entry_tramp_text_start) == PAGE_SIZE,
 	"Entry trampoline text too big")
 #endif
+#ifdef CONFIG_KVM
+ASSERT(__hyp_bss_start == __bss_start, "HYP and Host BSS are misaligned")
+#endif
 /*
  * If padding is applied before .head.text, virt<->phys conversions will fail.
  */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 2d1e7ef69c04..3f8bcf8db036 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1770,7 +1770,19 @@ static int init_hyp_mode(void)
 		goto out_err;
 	}
 
-	err = create_hyp_mappings(kvm_ksym_ref(__bss_start),
+	/*
+	 * .hyp.bss is guaranteed to be placed at the beginning of the .bss
+	 * section thanks to an assertion in the linker script. Map it RW and
+	 * the rest of .bss RO.
+	 */
+	err = create_hyp_mappings(kvm_ksym_ref(__hyp_bss_start),
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
index cd119d82d8e3..f4562f417d3f 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp.lds.S
@@ -25,4 +25,5 @@ SECTIONS {
 	BEGIN_HYP_SECTION(.data..percpu)
 		PERCPU_INPUT(L1_CACHE_BYTES)
 	END_HYP_SECTION
+	HYP_SECTION(.bss)
 }
-- 
2.31.0.rc2.261.g7f71774620-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
