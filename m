Return-Path: <SRS0=uW/I=UL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0743C31E46
	for <kvmarm@archiver.kernel.org>; Wed, 12 Jun 2019 09:12:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 834472063F
	for <kvmarm@archiver.kernel.org>; Wed, 12 Jun 2019 09:12:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 834472063F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 054934A510;
	Wed, 12 Jun 2019 05:12:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5li5aC9yJJg9; Wed, 12 Jun 2019 05:11:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C7BB44A515;
	Wed, 12 Jun 2019 05:11:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A43C04A510
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jun 2019 05:11:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VdLAc0g3FFpj for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Jun 2019 05:11:55 -0400 (EDT)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 179314A4FF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jun 2019 05:11:55 -0400 (EDT)
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id 2DDE0B6C3954A0597502;
 Wed, 12 Jun 2019 17:11:51 +0800 (CST)
Received: from HGHY2Y004646261.china.huawei.com (10.184.12.158) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.439.0; Wed, 12 Jun 2019 17:11:44 +0800
From: Zenghui Yu <yuzenghui@huawei.com>
To: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.cs.columbia.edu>,
 <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-perf-users@vger.kernel.org>
Subject: [PATCH v1 2/5] KVM: arm/arm64: Adjust entry/exit and trap related
 tracepoints
Date: Wed, 12 Jun 2019 09:08:43 +0000
Message-ID: <1560330526-15468-3-git-send-email-yuzenghui@huawei.com>
X-Mailer: git-send-email 2.6.4.windows.1
In-Reply-To: <1560330526-15468-1-git-send-email-yuzenghui@huawei.com>
References: <1560330526-15468-1-git-send-email-yuzenghui@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.184.12.158]
X-CFilter-Loop: Reflected
Cc: marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com,
 acme@kernel.org, linuxarm@huawei.com, acme@redhat.com, peterz@infradead.org,
 alexander.shishkin@linux.intel.com, mingo@redhat.com,
 ganapatrao.kulkarni@cavium.com, namhyung@kernel.org, jolsa@redhat.com,
 xiexiangyou@huawei.com
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

Currently, we use trace_kvm_exit() to report exception type (e.g.,
"IRQ", "TRAP") and exception class (ESR_ELx's bit[31:26]) together.
But hardware only saves the exit class to ESR_ELx on synchronous
exceptions, not on asynchronous exceptions. When the guest exits
due to external interrupts, we will get tracing output like:

	"kvm_exit: IRQ: HSR_EC: 0x0000 (UNKNOWN), PC: 0xffff87259e30"

Obviously, "HSR_EC" here is meaningless.

This patch splits "exit" and "trap" events by adding two tracepoints
explicitly in handle_trap_exceptions(). Let trace_kvm_exit() report VM
exit events, and trace_kvm_trap_exit() report VM trap events.

These tracepoints are adjusted also in preparation for supporting
'perf kvm stat' on arm64.

Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---
 arch/arm64/kvm/handle_exit.c |  3 +++
 arch/arm64/kvm/trace.h       | 35 +++++++++++++++++++++++++++++++++++
 virt/kvm/arm/arm.c           |  4 ++--
 virt/kvm/arm/trace.h         | 21 +++++++++++----------
 4 files changed, 51 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 516aead..af3c732 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -264,7 +264,10 @@ static int handle_trap_exceptions(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		exit_handle_fn exit_handler;
 
 		exit_handler = kvm_get_exit_handler(vcpu);
+		trace_kvm_trap_enter(vcpu->vcpu_id,
+				     kvm_vcpu_trap_get_class(vcpu));
 		handled = exit_handler(vcpu, run);
+		trace_kvm_trap_exit(vcpu->vcpu_id);
 	}
 
 	return handled;
diff --git a/arch/arm64/kvm/trace.h b/arch/arm64/kvm/trace.h
index eab91ad..6014c73 100644
--- a/arch/arm64/kvm/trace.h
+++ b/arch/arm64/kvm/trace.h
@@ -8,6 +8,41 @@
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM kvm
 
+TRACE_EVENT(kvm_trap_enter,
+	TP_PROTO(unsigned int vcpu_id, unsigned int esr_ec),
+	TP_ARGS(vcpu_id, esr_ec),
+
+	TP_STRUCT__entry(
+		__field(unsigned int,	vcpu_id)
+		__field(unsigned int,	esr_ec)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_id	= vcpu_id;
+		__entry->esr_ec		= esr_ec;
+	),
+
+	TP_printk("VCPU %u: HSR_EC=0x%04x (%s)",
+		  __entry->vcpu_id,
+		  __entry->esr_ec,
+		  __print_symbolic(__entry->esr_ec, kvm_arm_exception_class))
+);
+
+TRACE_EVENT(kvm_trap_exit,
+	TP_PROTO(unsigned int vcpu_id),
+	TP_ARGS(vcpu_id),
+
+	TP_STRUCT__entry(
+		__field(unsigned int,	vcpu_id)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_id	= vcpu_id;
+	),
+
+	TP_printk("VCPU %u", __entry->vcpu_id)
+);
+
 TRACE_EVENT(kvm_wfx_arm64,
 	TP_PROTO(unsigned long vcpu_pc, bool is_wfe),
 	TP_ARGS(vcpu_pc, is_wfe),
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 90cedeb..9f63fd9 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -758,7 +758,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		/**************************************************************
 		 * Enter the guest
 		 */
-		trace_kvm_entry(*vcpu_pc(vcpu));
+		trace_kvm_entry(vcpu->vcpu_id, *vcpu_pc(vcpu));
 		guest_enter_irqoff();
 
 		if (has_vhe()) {
@@ -822,7 +822,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		 * guest time.
 		 */
 		guest_exit();
-		trace_kvm_exit(ret, kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
+		trace_kvm_exit(vcpu->vcpu_id, ret, *vcpu_pc(vcpu));
 
 		/* Exit types that need handling before we can be preempted */
 		handle_exit_early(vcpu, run, ret);
diff --git a/virt/kvm/arm/trace.h b/virt/kvm/arm/trace.h
index 8b7dff2..edd9dae 100644
--- a/virt/kvm/arm/trace.h
+++ b/virt/kvm/arm/trace.h
@@ -12,40 +12,41 @@
  * Tracepoints for entry/exit to guest
  */
 TRACE_EVENT(kvm_entry,
-	TP_PROTO(unsigned long vcpu_pc),
-	TP_ARGS(vcpu_pc),
+	TP_PROTO(unsigned int vcpu_id, unsigned long vcpu_pc),
+	TP_ARGS(vcpu_id, vcpu_pc),
 
 	TP_STRUCT__entry(
+		__field(	unsigned int,	vcpu_id		)
 		__field(	unsigned long,	vcpu_pc		)
 	),
 
 	TP_fast_assign(
+		__entry->vcpu_id		= vcpu_id;
 		__entry->vcpu_pc		= vcpu_pc;
 	),
 
-	TP_printk("PC: 0x%08lx", __entry->vcpu_pc)
+	TP_printk("VCPU %u: PC=0x%08lx", __entry->vcpu_id, __entry->vcpu_pc)
 );
 
 TRACE_EVENT(kvm_exit,
-	TP_PROTO(int ret, unsigned int esr_ec, unsigned long vcpu_pc),
-	TP_ARGS(ret, esr_ec, vcpu_pc),
+	TP_PROTO(unsigned int vcpu_id, int ret, unsigned long vcpu_pc),
+	TP_ARGS(vcpu_id, ret, vcpu_pc),
 
 	TP_STRUCT__entry(
+		__field(	unsigned int,	vcpu_id		)
 		__field(	int,		ret		)
-		__field(	unsigned int,	esr_ec		)
 		__field(	unsigned long,	vcpu_pc		)
 	),
 
 	TP_fast_assign(
+		__entry->vcpu_id		= vcpu_id;
 		__entry->ret			= ARM_EXCEPTION_CODE(ret);
-		__entry->esr_ec = ARM_EXCEPTION_IS_TRAP(ret) ? esr_ec : 0;
 		__entry->vcpu_pc		= vcpu_pc;
 	),
 
-	TP_printk("%s: HSR_EC: 0x%04x (%s), PC: 0x%08lx",
+	TP_printk("VCPU %u: exit_type=%s, PC=0x%08lx",
+		  __entry->vcpu_id,
 		  __print_symbolic(__entry->ret, kvm_arm_exception_type),
-		  __entry->esr_ec,
-		  __print_symbolic(__entry->esr_ec, kvm_arm_exception_class),
 		  __entry->vcpu_pc)
 );
 
-- 
1.8.3.1


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
