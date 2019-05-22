Return-Path: <SRS0=HUCa=TW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37E3CC282CE
	for <kvmarm@archiver.kernel.org>; Wed, 22 May 2019 17:47:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 003F720645
	for <kvmarm@archiver.kernel.org>; Wed, 22 May 2019 17:47:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 003F720645
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD0C34A4F2;
	Wed, 22 May 2019 13:47:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1LHFDvNEffNy; Wed, 22 May 2019 13:47:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F6714A4DF;
	Wed, 22 May 2019 13:47:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A2A94A496
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 May 2019 13:47:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e8BiRuPfHZ58 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 May 2019 13:47:25 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF8E94A4D5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 May 2019 13:47:24 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3D30E341;
 Wed, 22 May 2019 10:47:24 -0700 (PDT)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.105])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B75633F5AF;
 Wed, 22 May 2019 10:47:22 -0700 (PDT)
From: James Morse <james.morse@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 1/2] KVM: arm64: Move pmu hyp code under hyp's Makefile to
 avoid instrumentation
Date: Wed, 22 May 2019 18:47:04 +0100
Message-Id: <20190522174705.236469-2-james.morse@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522174705.236469-1-james.morse@arm.com>
References: <20190522174705.236469-1-james.morse@arm.com>
MIME-Version: 1.0
Cc: Marc Zyngier <marc.zyngier@arm.com>
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

KVM's pmu.c contains the __hyp_text needed to switch the pmu registers
between host and guest. Because this isn't covered by the 'hyp' Makefile,
it can be built with kasan and friends when these are enabled in Kconfig.

When starting a guest, this results in:
| Kernel panic - not syncing: HYP panic:
| PS:a00003c9 PC:000083000028ada0 ESR:86000007
| FAR:000083000028ada0 HPFAR:0000000029df5300 PAR:0000000000000000
| VCPU:000000004e10b7d6
| CPU: 0 PID: 3088 Comm: qemu-system-aar Not tainted 5.2.0-rc1 #11026
| Hardware name: ARM LTD ARM Juno Development Platform/ARM Juno Development Plat
| Call trace:
|  dump_backtrace+0x0/0x200
|  show_stack+0x20/0x30
|  dump_stack+0xec/0x158
|  panic+0x1ec/0x420
|  panic+0x0/0x420
| SMP: stopping secondary CPUs
| Kernel Offset: disabled
| CPU features: 0x002,25006082
| Memory Limit: none
| ---[ end Kernel panic - not syncing: HYP panic:

This is caused by functions in pmu.c calling the instrumented
code, which isn't mapped to hyp. From objdump -r:
| RELOCATION RECORDS FOR [.hyp.text]:
| OFFSET           TYPE              VALUE
| 0000000000000010 R_AARCH64_CALL26  __sanitizer_cov_trace_pc
| 0000000000000018 R_AARCH64_CALL26  __asan_load4_noabort
| 0000000000000024 R_AARCH64_CALL26  __asan_load4_noabort

Move the affected code to a new file under 'hyp's Makefile.

Fixes: 3d91befbb3a0 ("arm64: KVM: Enable !VHE support for :G/:H perf event modifiers")
Cc: Andrew Murray <Andrew.Murray@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
---
Changes since v1:
 * Made the two functions static in patch 1, removed the header entries.

 arch/arm64/include/asm/kvm_host.h |  3 ---
 arch/arm64/kvm/hyp/switch.c       | 39 +++++++++++++++++++++++++++++++
 arch/arm64/kvm/pmu.c              | 38 ------------------------------
 3 files changed, 39 insertions(+), 41 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 2a8d3f8ca22c..4bcd9c1291d5 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -592,9 +592,6 @@ static inline int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr);
 void kvm_clr_pmu_events(u32 clr);
 
-void __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt);
-bool __pmu_switch_to_guest(struct kvm_cpu_context *host_ctxt);
-
 void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu);
 void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
 #else
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 22b4c335e0b2..8799e0c267d4 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -16,6 +16,7 @@
  */
 
 #include <linux/arm-smccc.h>
+#include <linux/kvm_host.h>
 #include <linux/types.h>
 #include <linux/jump_label.h>
 #include <uapi/linux/psci.h>
@@ -505,6 +506,44 @@ static void __hyp_text __set_host_arch_workaround_state(struct kvm_vcpu *vcpu)
 #endif
 }
 
+/**
+ * Disable host events, enable guest events
+ */
+static bool __hyp_text __pmu_switch_to_guest(struct kvm_cpu_context *host_ctxt)
+{
+	struct kvm_host_data *host;
+	struct kvm_pmu_events *pmu;
+
+	host = container_of(host_ctxt, struct kvm_host_data, host_ctxt);
+	pmu = &host->pmu_events;
+
+	if (pmu->events_host)
+		write_sysreg(pmu->events_host, pmcntenclr_el0);
+
+	if (pmu->events_guest)
+		write_sysreg(pmu->events_guest, pmcntenset_el0);
+
+	return (pmu->events_host || pmu->events_guest);
+}
+
+/**
+ * Disable guest events, enable host events
+ */
+static void __hyp_text __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
+{
+	struct kvm_host_data *host;
+	struct kvm_pmu_events *pmu;
+
+	host = container_of(host_ctxt, struct kvm_host_data, host_ctxt);
+	pmu = &host->pmu_events;
+
+	if (pmu->events_guest)
+		write_sysreg(pmu->events_guest, pmcntenclr_el0);
+
+	if (pmu->events_host)
+		write_sysreg(pmu->events_host, pmcntenset_el0);
+}
+
 /* Switch to the guest for VHE systems running in EL2 */
 int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 3da94a5bb6b7..e71d00bb5271 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -53,44 +53,6 @@ void kvm_clr_pmu_events(u32 clr)
 	ctx->pmu_events.events_guest &= ~clr;
 }
 
-/**
- * Disable host events, enable guest events
- */
-bool __hyp_text __pmu_switch_to_guest(struct kvm_cpu_context *host_ctxt)
-{
-	struct kvm_host_data *host;
-	struct kvm_pmu_events *pmu;
-
-	host = container_of(host_ctxt, struct kvm_host_data, host_ctxt);
-	pmu = &host->pmu_events;
-
-	if (pmu->events_host)
-		write_sysreg(pmu->events_host, pmcntenclr_el0);
-
-	if (pmu->events_guest)
-		write_sysreg(pmu->events_guest, pmcntenset_el0);
-
-	return (pmu->events_host || pmu->events_guest);
-}
-
-/**
- * Disable guest events, enable host events
- */
-void __hyp_text __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
-{
-	struct kvm_host_data *host;
-	struct kvm_pmu_events *pmu;
-
-	host = container_of(host_ctxt, struct kvm_host_data, host_ctxt);
-	pmu = &host->pmu_events;
-
-	if (pmu->events_guest)
-		write_sysreg(pmu->events_guest, pmcntenclr_el0);
-
-	if (pmu->events_host)
-		write_sysreg(pmu->events_host, pmcntenset_el0);
-}
-
 #define PMEVTYPER_READ_CASE(idx)				\
 	case idx:						\
 		return read_sysreg(pmevtyper##idx##_el0)
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
