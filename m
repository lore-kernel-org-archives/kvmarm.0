Return-Path: <SRS0=FmU0=ML=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEF74C07E9D
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 16:03:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4D0226147D
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 16:03:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4D0226147D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E769149FB7;
	Mon, 19 Jul 2021 12:03:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7uYQh4Io4iGd; Mon, 19 Jul 2021 12:03:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C26B84B0A3;
	Mon, 19 Jul 2021 12:03:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7ECCF49FB7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 12:03:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kP-qOWmcDs7V for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Jul 2021 12:03:55 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 26ED340667
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 12:03:55 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 z64-20020a257e430000b0290550b1931c8dso25802703ybc.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 09:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=gj5azJ/ULXVcRTckLTYz4tzYt46atrxa1NlVggC1Nmc=;
 b=LHtfRYwLX9nQwkfUKOswjmlWdg5rsMjtYduQo4pdQJPUIUGISuTCceoDTnWBdXbtKY
 PcF5qwXUmbJQ3xFqiQrZancOO9Kye/UKkIIUd+uqStOA+EbRjShQ2VT1U/VHALXwB/Yr
 bCt/x2uRgW63pw34dMXL7ENNzIYkf8O0kM12GdNvSZEQ3nU5gY+Zzco0i+kj1xrCg1rI
 z4hgo9VtaoncdacrrY8f+3APWGzbakN+pQ7zLc5kTSUXNZWYQDT1AnOoDB4l3287TbUu
 7H+GP9/co87qpbeGNDVnwjsd1RB/P+ES/zJp9dsnmCQSa97toNB2NUKNfnI8w3MLB0AU
 rXDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=gj5azJ/ULXVcRTckLTYz4tzYt46atrxa1NlVggC1Nmc=;
 b=nxVYXNQrTkFVrURGoaQhrhUyyp6P9XJCqBGATySB+9FAkdgQRZnhGG5yvoQ+ryPZ4h
 hmRaan1VGfNblY6MY/8wOQUOh5l0R3qBXi8mdENhR47kDHbRcinw+3EdjODTnRBTqurN
 L1tvmehOxh+HCrHOJMv/JHEnwbnfZ6HCyC1CpPK3HXfbP/7NeqJ009Rco4xYRM5cExOM
 7wiDnZjT4Krt/aALGpkhhAXvFFxHk6kjiTDzbeFRo1Uvui6ndpuiL7YfTCbpqrYw8DAT
 D0xVjHopAjZpHBrgwT2it4kdFU+dRbNSFa6EJRfc4JnrvqVU+DxnWAogo+AwszfjvE98
 V+eg==
X-Gm-Message-State: AOAM531Jq4Pb2HSYkokGesgi8Hr6v2+Kd37tJbG2fIf6azMySZAzU9U8
 bmh3ZLK+1ls+iFcRq2UCxkAAAdbPr4lm0BBKFZT5LZdFI3gxP5Kz+QJokxpp7y8M5Z2lxrQ/DYU
 xyosnePbRVFYkaFvFqA4XYfe8ZlnQM4V1icL3POYyw+m8SPnVmxlfg06hffUjWcoLG2g=
X-Google-Smtp-Source: ABdhPJyvBo0xrNE2JiKYrS+c1sAe20vSLOrHLMh9ty2cNjsLsVeW9KuuuUUBMIH7s3qqfMMxGZ4+xHb/7g==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a25:e08a:: with SMTP id
 x132mr33206480ybg.511.1626710634535; 
 Mon, 19 Jul 2021 09:03:54 -0700 (PDT)
Date: Mon, 19 Jul 2021 17:03:34 +0100
In-Reply-To: <20210719160346.609914-1-tabba@google.com>
Message-Id: <20210719160346.609914-4-tabba@google.com>
Mime-Version: 1.0
References: <20210719160346.609914-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v3 03/15] KVM: arm64: MDCR_EL2 is a 64-bit register
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

Fix the places in KVM that treat MDCR_EL2 as a 32-bit register.
More recent features (e.g., FEAT_SPEv1p2) use bits above 31.

No functional change intended.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_arm.h   | 20 ++++++++++----------
 arch/arm64/include/asm/kvm_asm.h   |  2 +-
 arch/arm64/include/asm/kvm_host.h  |  2 +-
 arch/arm64/kvm/debug.c             |  2 +-
 arch/arm64/kvm/hyp/nvhe/debug-sr.c |  2 +-
 arch/arm64/kvm/hyp/vhe/debug-sr.c  |  2 +-
 6 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index d436831dd706..6a523ec83415 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -281,18 +281,18 @@
 /* Hyp Debug Configuration Register bits */
 #define MDCR_EL2_E2TB_MASK	(UL(0x3))
 #define MDCR_EL2_E2TB_SHIFT	(UL(24))
-#define MDCR_EL2_TTRF		(1 << 19)
-#define MDCR_EL2_TPMS		(1 << 14)
+#define MDCR_EL2_TTRF		(UL(1) << 19)
+#define MDCR_EL2_TPMS		(UL(1) << 14)
 #define MDCR_EL2_E2PB_MASK	(UL(0x3))
 #define MDCR_EL2_E2PB_SHIFT	(UL(12))
-#define MDCR_EL2_TDRA		(1 << 11)
-#define MDCR_EL2_TDOSA		(1 << 10)
-#define MDCR_EL2_TDA		(1 << 9)
-#define MDCR_EL2_TDE		(1 << 8)
-#define MDCR_EL2_HPME		(1 << 7)
-#define MDCR_EL2_TPM		(1 << 6)
-#define MDCR_EL2_TPMCR		(1 << 5)
-#define MDCR_EL2_HPMN_MASK	(0x1F)
+#define MDCR_EL2_TDRA		(UL(1) << 11)
+#define MDCR_EL2_TDOSA		(UL(1) << 10)
+#define MDCR_EL2_TDA		(UL(1) << 9)
+#define MDCR_EL2_TDE		(UL(1) << 8)
+#define MDCR_EL2_HPME		(UL(1) << 7)
+#define MDCR_EL2_TPM		(UL(1) << 6)
+#define MDCR_EL2_TPMCR		(UL(1) << 5)
+#define MDCR_EL2_HPMN_MASK	(UL(0x1F))
 
 /* For compatibility with fault code shared with 32-bit */
 #define FSC_FAULT	ESR_ELx_FSC_FAULT
diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 9f0bf2109be7..63ead9060ab5 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -210,7 +210,7 @@ extern u64 __vgic_v3_read_vmcr(void);
 extern void __vgic_v3_write_vmcr(u32 vmcr);
 extern void __vgic_v3_init_lrs(void);
 
-extern u32 __kvm_get_mdcr_el2(void);
+extern u64 __kvm_get_mdcr_el2(void);
 
 #define __KVM_EXTABLE(from, to)						\
 	"	.pushsection	__kvm_ex_table, \"a\"\n"		\
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 347781f99b6a..4d2d974c1522 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -289,7 +289,7 @@ struct kvm_vcpu_arch {
 
 	/* HYP configuration */
 	u64 hcr_el2;
-	u32 mdcr_el2;
+	u64 mdcr_el2;
 
 	/* Exception Information */
 	struct kvm_vcpu_fault_info fault;
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index d5e79d7ee6e9..db9361338b2a 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -21,7 +21,7 @@
 				DBG_MDSCR_KDE | \
 				DBG_MDSCR_MDE)
 
-static DEFINE_PER_CPU(u32, mdcr_el2);
+static DEFINE_PER_CPU(u64, mdcr_el2);
 
 /**
  * save/restore_guest_debug_regs
diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
index 7d3f25868cae..df361d839902 100644
--- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
@@ -109,7 +109,7 @@ void __debug_switch_to_host(struct kvm_vcpu *vcpu)
 	__debug_switch_to_host_common(vcpu);
 }
 
-u32 __kvm_get_mdcr_el2(void)
+u64 __kvm_get_mdcr_el2(void)
 {
 	return read_sysreg(mdcr_el2);
 }
diff --git a/arch/arm64/kvm/hyp/vhe/debug-sr.c b/arch/arm64/kvm/hyp/vhe/debug-sr.c
index f1e2e5a00933..289689b2682d 100644
--- a/arch/arm64/kvm/hyp/vhe/debug-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/debug-sr.c
@@ -20,7 +20,7 @@ void __debug_switch_to_host(struct kvm_vcpu *vcpu)
 	__debug_switch_to_host_common(vcpu);
 }
 
-u32 __kvm_get_mdcr_el2(void)
+u64 __kvm_get_mdcr_el2(void)
 {
 	return read_sysreg(mdcr_el2);
 }
-- 
2.32.0.402.g57bb445576-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
