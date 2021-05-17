Return-Path: <SRS0=zR8f=KM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE84AC433B4
	for <kvmarm@archiver.kernel.org>; Mon, 17 May 2021 16:05:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 69AB061042
	for <kvmarm@archiver.kernel.org>; Mon, 17 May 2021 16:05:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 69AB061042
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB8954B44A;
	Mon, 17 May 2021 12:05:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IfBNGQz8iI3e; Mon, 17 May 2021 12:05:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 772E24B3A1;
	Mon, 17 May 2021 12:05:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FB344B22A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 May 2021 12:05:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LFEhfpU4Vtbn for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 May 2021 12:05:15 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 42D1A4B228
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 May 2021 12:05:15 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8211E106F;
 Mon, 17 May 2021 09:05:14 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9C2B23F73D;
 Mon, 17 May 2021 09:05:13 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
Subject: [PATCH] KVM: arm64: Consolidate functions to skip an instruction into
 skip_instr.h
Date: Mon, 17 May 2021 17:05:45 +0100
Message-Id: <20210517160545.699995-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
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

The function prototype kvm_skip_instr32() is used only by the hyp code, so
it makes more sense to live in the hyp specific header file adjust_pc.h.
Since __adjust_pc() has been moved to kvm_asm.h so it can be used by the
generic code, rename adjust_pc.h -> skip_instr.h to avoid confusion and to
better reflect the purpose of the remaining functions.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
Based on git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git
tags/kvmarm-fixes-5.13-1

 arch/arm64/include/asm/kvm_emulate.h                        | 1 -
 arch/arm64/kvm/hyp/aarch32.c                                | 1 +
 arch/arm64/kvm/hyp/exception.c                              | 2 +-
 .../arm64/kvm/hyp/include/hyp/{adjust_pc.h => skip_instr.h} | 6 ++++--
 arch/arm64/kvm/hyp/include/hyp/switch.h                     | 2 +-
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c                    | 2 +-
 arch/arm64/kvm/hyp/vgic-v3-sr.c                             | 2 +-
 7 files changed, 9 insertions(+), 7 deletions(-)
 rename arch/arm64/kvm/hyp/include/hyp/{adjust_pc.h => skip_instr.h} (90%)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index f612c090f2e4..436b77e6d1e8 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -34,7 +34,6 @@ enum exception_type {
 };
 
 bool kvm_condition_valid32(const struct kvm_vcpu *vcpu);
-void kvm_skip_instr32(struct kvm_vcpu *vcpu);
 
 void kvm_inject_undefined(struct kvm_vcpu *vcpu);
 void kvm_inject_vabt(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/hyp/aarch32.c b/arch/arm64/kvm/hyp/aarch32.c
index f98cbe2626a1..65ea395d81f3 100644
--- a/arch/arm64/kvm/hyp/aarch32.c
+++ b/arch/arm64/kvm/hyp/aarch32.c
@@ -10,6 +10,7 @@
  * Author: Christoffer Dall <c.dall@virtualopensystems.com>
  */
 
+#include <hyp/skip_instr.h>
 #include <linux/kvm_host.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
index 11541b94b328..ac03ad63c1b4 100644
--- a/arch/arm64/kvm/hyp/exception.c
+++ b/arch/arm64/kvm/hyp/exception.c
@@ -10,7 +10,7 @@
  * Author: Christoffer Dall <c.dall@virtualopensystems.com>
  */
 
-#include <hyp/adjust_pc.h>
+#include <hyp/skip_instr.h>
 #include <linux/kvm_host.h>
 #include <asm/kvm_emulate.h>
 
diff --git a/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h b/arch/arm64/kvm/hyp/include/hyp/skip_instr.h
similarity index 90%
rename from arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
rename to arch/arm64/kvm/hyp/include/hyp/skip_instr.h
index 4fdfeabefeb4..d3ece9a90751 100644
--- a/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
+++ b/arch/arm64/kvm/hyp/include/hyp/skip_instr.h
@@ -7,12 +7,14 @@
  * Author: Marc Zyngier <maz@kernel.org>
  */
 
-#ifndef __ARM64_KVM_HYP_ADJUST_PC_H__
-#define __ARM64_KVM_HYP_ADJUST_PC_H__
+#ifndef __ARM64_KVM_HYP_SKIP_INSTR_H__
+#define __ARM64_KVM_HYP_SKIP_INSTR_H__
 
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_host.h>
 
+void kvm_skip_instr32(struct kvm_vcpu *vcpu);
+
 static inline void kvm_skip_instr(struct kvm_vcpu *vcpu)
 {
 	if (vcpu_mode_is_32bit(vcpu)) {
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index e4a2f295a394..13578c1e91a6 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -7,7 +7,7 @@
 #ifndef __ARM64_KVM_HYP_SWITCH_H__
 #define __ARM64_KVM_HYP_SWITCH_H__
 
-#include <hyp/adjust_pc.h>
+#include <hyp/skip_instr.h>
 
 #include <linux/arm-smccc.h>
 #include <linux/kvm_host.h>
diff --git a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
index 87a54375bd6e..a11790cc42b4 100644
--- a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
+++ b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
@@ -4,7 +4,7 @@
  * Author: Marc Zyngier <marc.zyngier@arm.com>
  */
 
-#include <hyp/adjust_pc.h>
+#include <hyp/skip_instr.h>
 
 #include <linux/compiler.h>
 #include <linux/irqchip/arm-gic.h>
diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index 39f8f7f9227c..756cde8125ef 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -4,7 +4,7 @@
  * Author: Marc Zyngier <marc.zyngier@arm.com>
  */
 
-#include <hyp/adjust_pc.h>
+#include <hyp/skip_instr.h>
 
 #include <linux/compiler.h>
 #include <linux/irqchip/arm-gic-v3.h>
-- 
2.31.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
