Return-Path: <SRS0=oqs1=OD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C253C433FE
	for <kvmarm@archiver.kernel.org>; Mon, 13 Sep 2021 20:49:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B1D596112D
	for <kvmarm@archiver.kernel.org>; Mon, 13 Sep 2021 20:49:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B1D596112D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 65F214B1B0;
	Mon, 13 Sep 2021 16:49:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 32K0oFFvPqOS; Mon, 13 Sep 2021 16:49:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 405C34B1C8;
	Mon, 13 Sep 2021 16:49:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 292734B1AC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 16:49:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xDxMq9rzOV8M for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Sep 2021 16:49:50 -0400 (EDT)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 19DA44B13A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 16:49:50 -0400 (EDT)
Received: by mail-pg1-f201.google.com with SMTP id
 u5-20020a63d3450000b029023a5f6e6f9bso8001494pgi.21
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 13:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=z0+JpyYfhLSjBcBB8p9fMALyI9F5+XNuowwy7CcZMnQ=;
 b=UTByguEDslH6iAVfogjn3qnb8AWd+6tBKg0378q6FR9CLexbMhAnEh1UmUSMKERHbE
 a3ifJ3I8atl6Ms7aJMzTLErHT23zkHSkFKuRSx6888qG/LQ8t6vw6f8KCmh8wHjY/OMM
 KV8vr/UUoCyc4W0Joaq7y/WnkzncmJrzysCECKRnBV8IyTrSnlXUI6xhNgaI3i3rQFPW
 9vyDUa0JhT650jjBpR2WbLp5q/vL7InCsSkIQW1cZJg7FyZliV3DV+oPBSWc36Fmui8b
 k1ecqd3g1Fedlxj5dtMhDkJA5XSNQyNToGFwYFgqAQVH9ABLx2PRkZ44ow5GtSoL2JVn
 bO8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=z0+JpyYfhLSjBcBB8p9fMALyI9F5+XNuowwy7CcZMnQ=;
 b=jgcCAZX2F40MzqWSvE1AGymZyILgqTs5wUDV3MFpoX5LIltcvBvINCtdtKkFkYrAoX
 WkXpdNWCwhM0MXZ0vkLvNRp7dw/iHG0LbxLQ1mgLE/J0Wi0ZMptTus6rFEHtikZLV+XD
 si+oB2QGYarp7p3BsQTxUXj3O9xjyC1RwVhRptyGS75uULT8VfM3PT+W38aGq44vjoJD
 r/q65tsPYMDr+dviYSXZAN7yal0JpReZ1LN3BUDBd9GDI1UKqfGzqRXyB6NgcE2WXJjN
 T/Iim2xvVvkNv9+OTKbW03GSmWBFD4WjASWtdCD6Bv175moEZqWVgnHORoGU0xe2f7+l
 /kQQ==
X-Gm-Message-State: AOAM533IuGyjm542RvjD/2L2Ht90RE0BegoN7PMYu79qM/1KE9PY0FY8
 Z8AUjyUGGpSdo8nQhkthTcxVtXWHnIBA
X-Google-Smtp-Source: ABdhPJyKu7ncprozIHJ0z1BZxP0TRGCJwO7KxcZgSVnDKki6dwTjJwMcki3jTQOnPHBtNg6lhzG8oD9W/orG
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:90a:a513:: with SMTP id
 a19mr1632405pjq.26.1631566189354; Mon, 13 Sep 2021 13:49:49 -0700 (PDT)
Date: Mon, 13 Sep 2021 20:49:19 +0000
In-Reply-To: <20210913204930.130715-1-rananta@google.com>
Message-Id: <20210913204930.130715-4-rananta@google.com>
Mime-Version: 1.0
References: <20210913204930.130715-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH v5 03/14] KVM: arm64: selftests: Use read/write definitions
 from sysreg.h
From: Raghavendra Rao Ananta <rananta@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
 Andrew Jones <drjones@redhat.com>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

Make use of the register read/write definitions from
sysreg.h, instead of the existing definitions. A syntax
correction is needed for the files that use write_sysreg()
to make it compliant with the new (kernel's) syntax.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 .../selftests/kvm/aarch64/debug-exceptions.c  | 28 +++++++++----------
 .../selftests/kvm/include/aarch64/processor.h | 13 +--------
 2 files changed, 15 insertions(+), 26 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index e5e6c92b60da..11fd23e21cb4 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -34,16 +34,16 @@ static void reset_debug_state(void)
 {
 	asm volatile("msr daifset, #8");
 
-	write_sysreg(osdlr_el1, 0);
-	write_sysreg(oslar_el1, 0);
+	write_sysreg(0, osdlr_el1);
+	write_sysreg(0, oslar_el1);
 	isb();
 
-	write_sysreg(mdscr_el1, 0);
+	write_sysreg(0, mdscr_el1);
 	/* This test only uses the first bp and wp slot. */
-	write_sysreg(dbgbvr0_el1, 0);
-	write_sysreg(dbgbcr0_el1, 0);
-	write_sysreg(dbgwcr0_el1, 0);
-	write_sysreg(dbgwvr0_el1, 0);
+	write_sysreg(0, dbgbvr0_el1);
+	write_sysreg(0, dbgbcr0_el1);
+	write_sysreg(0, dbgwcr0_el1);
+	write_sysreg(0, dbgwvr0_el1);
 	isb();
 }
 
@@ -53,14 +53,14 @@ static void install_wp(uint64_t addr)
 	uint32_t mdscr;
 
 	wcr = DBGWCR_LEN8 | DBGWCR_RD | DBGWCR_WR | DBGWCR_EL1 | DBGWCR_E;
-	write_sysreg(dbgwcr0_el1, wcr);
-	write_sysreg(dbgwvr0_el1, addr);
+	write_sysreg(wcr, dbgwcr0_el1);
+	write_sysreg(addr, dbgwvr0_el1);
 	isb();
 
 	asm volatile("msr daifclr, #8");
 
 	mdscr = read_sysreg(mdscr_el1) | MDSCR_KDE | MDSCR_MDE;
-	write_sysreg(mdscr_el1, mdscr);
+	write_sysreg(mdscr, mdscr_el1);
 	isb();
 }
 
@@ -70,14 +70,14 @@ static void install_hw_bp(uint64_t addr)
 	uint32_t mdscr;
 
 	bcr = DBGBCR_LEN8 | DBGBCR_EXEC | DBGBCR_EL1 | DBGBCR_E;
-	write_sysreg(dbgbcr0_el1, bcr);
-	write_sysreg(dbgbvr0_el1, addr);
+	write_sysreg(bcr, dbgbcr0_el1);
+	write_sysreg(addr, dbgbvr0_el1);
 	isb();
 
 	asm volatile("msr daifclr, #8");
 
 	mdscr = read_sysreg(mdscr_el1) | MDSCR_KDE | MDSCR_MDE;
-	write_sysreg(mdscr_el1, mdscr);
+	write_sysreg(mdscr, mdscr_el1);
 	isb();
 }
 
@@ -88,7 +88,7 @@ static void install_ss(void)
 	asm volatile("msr daifclr, #8");
 
 	mdscr = read_sysreg(mdscr_el1) | MDSCR_KDE | MDSCR_SS;
-	write_sysreg(mdscr_el1, mdscr);
+	write_sysreg(mdscr, mdscr_el1);
 	isb();
 }
 
diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 96578bd46a85..7989e832cafb 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -10,6 +10,7 @@
 #include "kvm_util.h"
 #include <linux/stringify.h>
 #include <linux/types.h>
+#include <asm/sysreg.h>
 
 
 #define ARM64_CORE_REG(x) (KVM_REG_ARM64 | KVM_REG_SIZE_U64 | \
@@ -119,18 +120,6 @@ void vm_install_exception_handler(struct kvm_vm *vm,
 void vm_install_sync_handler(struct kvm_vm *vm,
 		int vector, int ec, handler_fn handler);
 
-#define write_sysreg(reg, val)						  \
-({									  \
-	u64 __val = (u64)(val);						  \
-	asm volatile("msr " __stringify(reg) ", %x0" : : "rZ" (__val));	  \
-})
-
-#define read_sysreg(reg)						  \
-({	u64 val;							  \
-	asm volatile("mrs %0, "__stringify(reg) : "=r"(val) : : "memory");\
-	val;								  \
-})
-
 #define isb()		asm volatile("isb" : : : "memory")
 #define dsb(opt)	asm volatile("dsb " #opt : : : "memory")
 #define dmb(opt)	asm volatile("dmb " #opt : : : "memory")
-- 
2.33.0.309.g3052b89438-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
