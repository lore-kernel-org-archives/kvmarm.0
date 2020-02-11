Return-Path: <SRS0=XaYj=37=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CF41C35242
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 17:52:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4FE1320578
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 17:52:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="nhZ5Wq0N"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4FE1320578
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 079424AE95;
	Tue, 11 Feb 2020 12:52:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id k2HYnFXp992h; Tue, 11 Feb 2020 12:52:48 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F2FA74AEE9;
	Tue, 11 Feb 2020 12:52:47 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 856E04AC68
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 12:52:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9rrBpAJF+MGF for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Feb 2020 12:52:45 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9966540456
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 12:52:44 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id B6D2220848;
 Tue, 11 Feb 2020 17:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1581443563;
 bh=Ft3LS22pw1Kczdq6lr0DMRdJJ3bt2weBSDVOe2zbADY=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=nhZ5Wq0N2gKx2XcrZ+FaYLw48Lsw4mbJkFYC31jYwpaq16ETNX+cQ7rTCJGTZ567G
 GQ9oWQ+ayDUcBA2+dwCTZdgqgNsulwyXTepqpj9g4kzWSC7K5wwAS7DCiDcBlTIP3+
 5UV/5pcuWDwuBLAdGWO4OuUhVKRMdtC84JT6ufJo=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1j1Zg2-004O7k-D6; Tue, 11 Feb 2020 17:50:26 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH v2 56/94] KVM: arm64: nv: Add nested GICv3 tracepoints
Date: Tue, 11 Feb 2020 17:49:00 +0000
Message-Id: <20200211174938.27809-57-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200211174938.27809-1-maz@kernel.org>
References: <20200211174938.27809-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com,
 christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu,
 alexandru.elisei@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Andre Przywara <andre.przywara@arm.com>, Dave Martin <Dave.Martin@arm.com>
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

From: Christoffer Dall <christoffer.dall@arm.com>

Adding tracepoints to be able to peek into the shadow LRs used when
running a guest guest.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 virt/kvm/arm/vgic/vgic-nested-trace.h | 137 ++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-v3-nested.c    |  13 ++-
 2 files changed, 149 insertions(+), 1 deletion(-)
 create mode 100644 virt/kvm/arm/vgic/vgic-nested-trace.h

diff --git a/virt/kvm/arm/vgic/vgic-nested-trace.h b/virt/kvm/arm/vgic/vgic-nested-trace.h
new file mode 100644
index 000000000000..69f4ec031e7c
--- /dev/null
+++ b/virt/kvm/arm/vgic/vgic-nested-trace.h
@@ -0,0 +1,137 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#if !defined(_TRACE_VGIC_NESTED_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_VGIC_NESTED_H
+
+#include <linux/tracepoint.h>
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM kvm
+
+#define SLR_ENTRY_VALS(x)							\
+	" ",									\
+	!!(__entry->lrs[x] & ICH_LR_HW),		   			\
+	!!(__entry->lrs[x] & ICH_LR_PENDING_BIT),	   			\
+	!!(__entry->lrs[x] & ICH_LR_ACTIVE_BIT),	   			\
+	__entry->lrs[x] & ICH_LR_VIRTUAL_ID_MASK,				\
+	(__entry->lrs[x] & ICH_LR_PHYS_ID_MASK) >> ICH_LR_PHYS_ID_SHIFT,	\
+	(__entry->orig_lrs[x] & ICH_LR_PHYS_ID_MASK) >> ICH_LR_PHYS_ID_SHIFT
+
+TRACE_EVENT(vgic_create_shadow_lrs,
+	TP_PROTO(struct kvm_vcpu *vcpu, int nr_lr, u64 *lrs, u64 *orig_lrs),
+	TP_ARGS(vcpu, nr_lr, lrs, orig_lrs),
+
+	TP_STRUCT__entry(
+		__field(	int,	nr_lr			)
+		__array(	u64,	lrs,		16	)
+		__array(	u64,	orig_lrs,	16	)
+	),
+
+	TP_fast_assign(
+		__entry->nr_lr		= nr_lr;
+		memcpy(__entry->lrs, lrs, 16 * sizeof(u64));
+		memcpy(__entry->orig_lrs, orig_lrs, 16 * sizeof(u64));
+	),
+
+	TP_printk("nr_lr: %d\n"
+		  "%50sLR[ 0]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu (%5llu)\n"
+		  "%50sLR[ 1]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu (%5llu)\n"
+		  "%50sLR[ 2]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu (%5llu)\n"
+		  "%50sLR[ 3]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu (%5llu)\n"
+		  "%50sLR[ 4]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu (%5llu)\n"
+		  "%50sLR[ 5]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu (%5llu)\n"
+		  "%50sLR[ 6]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu (%5llu)\n"
+		  "%50sLR[ 7]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu (%5llu)\n"
+		  "%50sLR[ 8]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu (%5llu)\n"
+		  "%50sLR[ 9]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu (%5llu)\n"
+		  "%50sLR[10]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu (%5llu)\n"
+		  "%50sLR[11]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu (%5llu)\n"
+		  "%50sLR[12]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu (%5llu)\n"
+		  "%50sLR[13]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu (%5llu)\n"
+		  "%50sLR[14]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu (%5llu)\n"
+		  "%50sLR[15]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu (%5llu)",
+		  __entry->nr_lr,
+		  SLR_ENTRY_VALS(0), SLR_ENTRY_VALS(1), SLR_ENTRY_VALS(2),
+		  SLR_ENTRY_VALS(3), SLR_ENTRY_VALS(4), SLR_ENTRY_VALS(5),
+		  SLR_ENTRY_VALS(6), SLR_ENTRY_VALS(7), SLR_ENTRY_VALS(8),
+		  SLR_ENTRY_VALS(9), SLR_ENTRY_VALS(10), SLR_ENTRY_VALS(11),
+		  SLR_ENTRY_VALS(12), SLR_ENTRY_VALS(13), SLR_ENTRY_VALS(14),
+		  SLR_ENTRY_VALS(15))
+);
+
+#define LR_ENTRY_VALS(x)							\
+	" ",									\
+	!!(__entry->lrs[x] & ICH_LR_HW),		   			\
+	!!(__entry->lrs[x] & ICH_LR_PENDING_BIT),	   			\
+	!!(__entry->lrs[x] & ICH_LR_ACTIVE_BIT),	   			\
+	__entry->lrs[x] & ICH_LR_VIRTUAL_ID_MASK,				\
+	(__entry->lrs[x] & ICH_LR_PHYS_ID_MASK) >> ICH_LR_PHYS_ID_SHIFT
+
+TRACE_EVENT(vgic_put_nested,
+	TP_PROTO(struct kvm_vcpu *vcpu, int nr_lr, u64 *lrs),
+	TP_ARGS(vcpu, nr_lr, lrs),
+
+	TP_STRUCT__entry(
+		__field(	int,	nr_lr			)
+		__array(	u64,	lrs,		16	)
+	),
+
+	TP_fast_assign(
+		__entry->nr_lr		= nr_lr;
+		memcpy(__entry->lrs, lrs, 16 * sizeof(u64));
+	),
+
+	TP_printk("nr_lr: %d\n"
+		  "%50sLR[ 0]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu\n"
+		  "%50sLR[ 1]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu\n"
+		  "%50sLR[ 2]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu\n"
+		  "%50sLR[ 3]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu\n"
+		  "%50sLR[ 4]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu\n"
+		  "%50sLR[ 5]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu\n"
+		  "%50sLR[ 6]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu\n"
+		  "%50sLR[ 7]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu\n"
+		  "%50sLR[ 8]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu\n"
+		  "%50sLR[ 9]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu\n"
+		  "%50sLR[10]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu\n"
+		  "%50sLR[11]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu\n"
+		  "%50sLR[12]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu\n"
+		  "%50sLR[13]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu\n"
+		  "%50sLR[14]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu\n"
+		  "%50sLR[15]: HW: %d P: %d: A: %d vINTID: %5llu pINTID: %5llu",
+		  __entry->nr_lr,
+		  LR_ENTRY_VALS(0), LR_ENTRY_VALS(1), LR_ENTRY_VALS(2),
+		  LR_ENTRY_VALS(3), LR_ENTRY_VALS(4), LR_ENTRY_VALS(5),
+		  LR_ENTRY_VALS(6), LR_ENTRY_VALS(7), LR_ENTRY_VALS(8),
+		  LR_ENTRY_VALS(9), LR_ENTRY_VALS(10), LR_ENTRY_VALS(11),
+		  LR_ENTRY_VALS(12), LR_ENTRY_VALS(13), LR_ENTRY_VALS(14),
+		  LR_ENTRY_VALS(15))
+);
+
+TRACE_EVENT(vgic_nested_hw_emulate,
+	TP_PROTO(int lr, u64 lr_val, u32 l1_intid),
+	TP_ARGS(lr, lr_val, l1_intid),
+
+	TP_STRUCT__entry(
+		__field(	int,	lr		)
+		__field(	u64,	lr_val		)
+		__field(	u32,	l1_intid	)
+	),
+
+	TP_fast_assign(
+		__entry->lr		= lr;
+		__entry->lr_val		= lr_val;
+		__entry->l1_intid	= l1_intid;
+	),
+
+	TP_printk("lr: %d LR %llx L1 INTID: %u\n",
+		  __entry->lr, __entry->lr_val, __entry->l1_intid)
+);
+
+#endif /* _TRACE_VGIC_NESTED_H */
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH ../../../virt/kvm/arm/vgic
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE vgic-nested-trace
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/virt/kvm/arm/vgic/vgic-v3-nested.c b/virt/kvm/arm/vgic/vgic-v3-nested.c
index 4ba426e2324d..94b1edb67011 100644
--- a/virt/kvm/arm/vgic/vgic-v3-nested.c
+++ b/virt/kvm/arm/vgic/vgic-v3-nested.c
@@ -13,6 +13,9 @@
 
 #include "vgic.h"
 
+#define CREATE_TRACE_POINTS
+#include "vgic-nested-trace.h"
+
 static inline struct vgic_v3_cpu_if *vcpu_nested_if(struct kvm_vcpu *vcpu)
 {
 	return &vcpu->arch.vgic_cpu.nested_vgic_v3;
@@ -119,6 +122,9 @@ static void vgic_v3_create_shadow_lr(struct kvm_vcpu *vcpu)
 		used_lrs = i + 1;
 	}
 
+	trace_vgic_create_shadow_lrs(vcpu, kvm_vgic_global_state.nr_lr,
+				     s_cpu_if->vgic_lr, cpu_if->vgic_lr);
+
 	s_cpu_if->used_lrs = used_lrs;
 }
 
@@ -163,8 +169,10 @@ void vgic_v3_sync_nested(struct kvm_vcpu *vcpu)
 			continue; /* oh well, the guest hyp is broken */
 
 		lr = __gic_v3_get_lr(i);
-		if (!(lr & ICH_LR_STATE))
+		if (!(lr & ICH_LR_STATE)) {
+			trace_vgic_nested_hw_emulate(i, lr, l1_irq);
 			irq->active = false;
+		}
 
 		vgic_put_irq(vcpu->kvm, irq);
 	}
@@ -195,6 +203,9 @@ void vgic_v3_put_nested(struct kvm_vcpu *vcpu)
 
 	__vgic_v3_save_state(vcpu_shadow_if(vcpu));
 
+	trace_vgic_put_nested(vcpu, kvm_vgic_global_state.nr_lr,
+			      vcpu_shadow_if(vcpu)->vgic_lr);
+
 	/*
 	 * Translate the shadow state HW fields back to the virtual ones
 	 * before copying the shadow struct back to the nested one.
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
