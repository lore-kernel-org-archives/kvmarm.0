Return-Path: <SRS0=SHPB=CL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AE26C433E7
	for <kvmarm@archiver.kernel.org>; Wed,  2 Sep 2020 16:29:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A0ED52067C
	for <kvmarm@archiver.kernel.org>; Wed,  2 Sep 2020 16:29:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="R4c4UQ0m"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A0ED52067C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 388704B1AD;
	Wed,  2 Sep 2020 12:29:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5J9zFOKNat5A; Wed,  2 Sep 2020 12:29:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C2884B19B;
	Wed,  2 Sep 2020 12:29:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D875E4B16C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2020 12:29:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zy9jba7XkMMW for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Sep 2020 12:29:54 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AC0214B164
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2020 12:29:54 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 913322067C;
 Wed,  2 Sep 2020 16:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599064193;
 bh=s0F7PAbC+yoQdcg15XaoZ2LDOt447Zu030ih7wL1crA=;
 h=From:To:Cc:Subject:Date:From;
 b=R4c4UQ0mwmOAYAnEmg2X+s8JF7QSauZpg0SQ5D8zrIK0UgEPbtbJyFvxTARozCNOC
 DhUF/oE8XY2Luxw2i9zcredZwfkx6CU4zmyuJhDPpdugHioYY7M1V3gZWVh7jf+2b+
 ZXJnHvHkvqOGz/g4aW6DKx3d8ZhqFuX+OztU3ei4=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=hot-poop.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1kDVdv-008fpH-Ux; Wed, 02 Sep 2020 17:29:52 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH] KVM: arm64: Fix address truncation in traces
Date: Wed,  2 Sep 2020 17:29:34 +0100
Message-Id: <20200902162934.151894-1-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com
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

Owing to their ARMv7 origins, the trace events are truncating most
address values to 32bits. That's not really helpful.

Expand the printing of such values to their full glory.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/trace_arm.h         | 16 ++++++++--------
 arch/arm64/kvm/trace_handle_exit.h |  6 +++---
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/trace_arm.h b/arch/arm64/kvm/trace_arm.h
index 4691053c5ee4..ff0444352bba 100644
--- a/arch/arm64/kvm/trace_arm.h
+++ b/arch/arm64/kvm/trace_arm.h
@@ -23,7 +23,7 @@ TRACE_EVENT(kvm_entry,
 		__entry->vcpu_pc		= vcpu_pc;
 	),
 
-	TP_printk("PC: 0x%08lx", __entry->vcpu_pc)
+	TP_printk("PC: 0x%016lx", __entry->vcpu_pc)
 );
 
 TRACE_EVENT(kvm_exit,
@@ -42,7 +42,7 @@ TRACE_EVENT(kvm_exit,
 		__entry->vcpu_pc		= vcpu_pc;
 	),
 
-	TP_printk("%s: HSR_EC: 0x%04x (%s), PC: 0x%08lx",
+	TP_printk("%s: HSR_EC: 0x%04x (%s), PC: 0x%016lx",
 		  __print_symbolic(__entry->ret, kvm_arm_exception_type),
 		  __entry->esr_ec,
 		  __print_symbolic(__entry->esr_ec, kvm_arm_exception_class),
@@ -69,7 +69,7 @@ TRACE_EVENT(kvm_guest_fault,
 		__entry->ipa			= ipa;
 	),
 
-	TP_printk("ipa %#llx, hsr %#08lx, hxfar %#08lx, pc %#08lx",
+	TP_printk("ipa %#llx, hsr %#08lx, hxfar %#08lx, pc %#016lx",
 		  __entry->ipa, __entry->hsr,
 		  __entry->hxfar, __entry->vcpu_pc)
 );
@@ -131,7 +131,7 @@ TRACE_EVENT(kvm_mmio_emulate,
 		__entry->cpsr			= cpsr;
 	),
 
-	TP_printk("Emulate MMIO at: 0x%08lx (instr: %08lx, cpsr: %08lx)",
+	TP_printk("Emulate MMIO at: 0x%016lx (instr: %08lx, cpsr: %08lx)",
 		  __entry->vcpu_pc, __entry->instr, __entry->cpsr)
 );
 
@@ -149,7 +149,7 @@ TRACE_EVENT(kvm_unmap_hva_range,
 		__entry->end		= end;
 	),
 
-	TP_printk("mmu notifier unmap range: %#08lx -- %#08lx",
+	TP_printk("mmu notifier unmap range: %#016lx -- %#016lx",
 		  __entry->start, __entry->end)
 );
 
@@ -165,7 +165,7 @@ TRACE_EVENT(kvm_set_spte_hva,
 		__entry->hva		= hva;
 	),
 
-	TP_printk("mmu notifier set pte hva: %#08lx", __entry->hva)
+	TP_printk("mmu notifier set pte hva: %#016lx", __entry->hva)
 );
 
 TRACE_EVENT(kvm_age_hva,
@@ -182,7 +182,7 @@ TRACE_EVENT(kvm_age_hva,
 		__entry->end		= end;
 	),
 
-	TP_printk("mmu notifier age hva: %#08lx -- %#08lx",
+	TP_printk("mmu notifier age hva: %#016lx -- %#016lx",
 		  __entry->start, __entry->end)
 );
 
@@ -198,7 +198,7 @@ TRACE_EVENT(kvm_test_age_hva,
 		__entry->hva		= hva;
 	),
 
-	TP_printk("mmu notifier test age hva: %#08lx", __entry->hva)
+	TP_printk("mmu notifier test age hva: %#016lx", __entry->hva)
 );
 
 TRACE_EVENT(kvm_set_way_flush,
diff --git a/arch/arm64/kvm/trace_handle_exit.h b/arch/arm64/kvm/trace_handle_exit.h
index 2c56d1e0f5bd..8d78acc4fba7 100644
--- a/arch/arm64/kvm/trace_handle_exit.h
+++ b/arch/arm64/kvm/trace_handle_exit.h
@@ -22,7 +22,7 @@ TRACE_EVENT(kvm_wfx_arm64,
 		__entry->is_wfe  = is_wfe;
 	),
 
-	TP_printk("guest executed wf%c at: 0x%08lx",
+	TP_printk("guest executed wf%c at: 0x%016lx",
 		  __entry->is_wfe ? 'e' : 'i', __entry->vcpu_pc)
 );
 
@@ -42,7 +42,7 @@ TRACE_EVENT(kvm_hvc_arm64,
 		__entry->imm = imm;
 	),
 
-	TP_printk("HVC at 0x%08lx (r0: 0x%08lx, imm: 0x%lx)",
+	TP_printk("HVC at 0x%016lx (r0: 0x%016lx, imm: 0x%lx)",
 		  __entry->vcpu_pc, __entry->r0, __entry->imm)
 );
 
@@ -135,7 +135,7 @@ TRACE_EVENT(trap_reg,
 		__entry->write_value = write_value;
 	),
 
-	TP_printk("%s %s reg %d (0x%08llx)", __entry->fn,  __entry->is_write?"write to":"read from", __entry->reg, __entry->write_value)
+	TP_printk("%s %s reg %d (0x%016llx)", __entry->fn,  __entry->is_write?"write to":"read from", __entry->reg, __entry->write_value)
 );
 
 TRACE_EVENT(kvm_handle_sys_reg,
-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
