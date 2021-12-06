Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60A7DC433EF
	for <kvmarm@archiver.kernel.org>; Mon,  6 Dec 2021 17:02:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E6DC94B0C2;
	Mon,  6 Dec 2021 12:02:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IHU1ym+KiinP; Mon,  6 Dec 2021 12:02:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 05C734B0BF;
	Mon,  6 Dec 2021 12:02:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9400C4A98B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Dec 2021 12:02:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MrSNuIvIS7dl for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Dec 2021 12:02:38 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C4774B0C3
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Dec 2021 12:02:38 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F1F7B1042;
 Mon,  6 Dec 2021 09:02:37 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 402093F73B;
 Mon,  6 Dec 2021 09:02:36 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 will@kernel.org, mark.rutland@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 2/4] KVM: arm64: Keep a list of probed PMUs
Date: Mon,  6 Dec 2021 17:02:21 +0000
Message-Id: <20211206170223.309789-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206170223.309789-1-alexandru.elisei@arm.com>
References: <20211206170223.309789-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Cc: tglx@linutronix.de, mingo@redhat.com
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

The ARM PMU driver calls kvm_host_pmu_init() after probing to tell KVM that
a hardware PMU is available for guest emulation. Heterogeneous systems can
have more than one PMU present, and the callback gets called multiple
times, once for each of them. Keep track of all the PMUs available to KVM,
as they're going to be needed later.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/kvm/pmu-emul.c | 26 ++++++++++++++++++++++++--
 include/kvm/arm_pmu.h     |  5 +++++
 2 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index a5e4bbf5e68f..eaaad4c06561 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -7,13 +7,18 @@
 #include <linux/cpu.h>
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
+#include <linux/list.h>
 #include <linux/perf_event.h>
 #include <linux/perf/arm_pmu.h>
+#include <linux/rwsem.h>
 #include <linux/uaccess.h>
 #include <asm/kvm_emulate.h>
 #include <kvm/arm_pmu.h>
 #include <kvm/arm_vgic.h>
 
+static LIST_HEAD(arm_pmus);
+static DEFINE_MUTEX(arm_pmus_lock);
+
 static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx);
 static void kvm_pmu_update_pmc_chained(struct kvm_vcpu *vcpu, u64 select_idx);
 static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc);
@@ -742,9 +747,26 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 
 void kvm_host_pmu_init(struct arm_pmu *pmu)
 {
-	if (pmu->pmuver != 0 && pmu->pmuver != ID_AA64DFR0_PMUVER_IMP_DEF &&
-	    !kvm_arm_support_pmu_v3() && !is_protected_kvm_enabled())
+	struct arm_pmu_entry *entry;
+
+	if (pmu->pmuver == 0 || pmu->pmuver == ID_AA64DFR0_PMUVER_IMP_DEF ||
+	    is_protected_kvm_enabled())
+		return;
+
+	mutex_lock(&arm_pmus_lock);
+
+	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		goto out_unlock;
+
+	if (list_empty(&arm_pmus))
 		static_branch_enable(&kvm_arm_pmu_available);
+
+	entry->arm_pmu = pmu;
+	list_add_tail(&entry->entry, &arm_pmus);
+
+out_unlock:
+	mutex_unlock(&arm_pmus_lock);
 }
 
 static int kvm_pmu_probe_pmuver(void)
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 90f21898aad8..e249c5f172aa 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -36,6 +36,11 @@ struct kvm_pmu {
 	struct irq_work overflow_work;
 };
 
+struct arm_pmu_entry {
+	struct list_head entry;
+	struct arm_pmu *arm_pmu;
+};
+
 #define kvm_arm_pmu_irq_initialized(v)	((v)->arch.pmu.irq_num >= VGIC_NR_SGIS)
 u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx);
 void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val);
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
