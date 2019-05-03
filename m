Return-Path: <SRS0=WQmE=TD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37F31C004C9
	for <kvmarm@archiver.kernel.org>; Fri,  3 May 2019 12:47:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EBDB42075E
	for <kvmarm@archiver.kernel.org>; Fri,  3 May 2019 12:47:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EBDB42075E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A34C54A57E;
	Fri,  3 May 2019 08:47:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Og87AVAFGKUt; Fri,  3 May 2019 08:47:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 408954A538;
	Fri,  3 May 2019 08:47:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2054D4A4D5
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 May 2019 08:47:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RZmXQhwHlw0X for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 May 2019 08:47:35 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 15C674A569
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 May 2019 08:47:35 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B0D4B165C;
 Fri,  3 May 2019 05:47:34 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com
 (filthy-habits.cambridge.arm.com [10.1.197.61])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 78DC23F220;
 Fri,  3 May 2019 05:47:31 -0700 (PDT)
From: Marc Zyngier <marc.zyngier@arm.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 49/56] arm64: KVM: Add accessors to track guest/host only
 counters
Date: Fri,  3 May 2019 13:44:20 +0100
Message-Id: <20190503124427.190206-50-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190503124427.190206-1-marc.zyngier@arm.com>
References: <20190503124427.190206-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
 Kristina Martsenko <kristina.martsenko@arm.com>,
 "zhang . lei" <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>,
 kvmarm@lists.cs.columbia.edu, Amit Daniel Kachhap <amit.kachhap@arm.com>,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org
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

From: Andrew Murray <andrew.murray@arm.com>

In order to effeciently switch events_{guest,host} perf counters at
guest entry/exit we add bitfields to kvm_cpu_context for guest and host
events as well as accessors for updating them.

A function is also provided which allows the PMU driver to determine
if a counter should start counting when it is enabled. With exclude_host,
we may only start counting when entering the guest.

Signed-off-by: Andrew Murray <andrew.murray@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_host.h | 17 ++++++++++++
 arch/arm64/kvm/Makefile           |  2 +-
 arch/arm64/kvm/pmu.c              | 45 +++++++++++++++++++++++++++++++
 3 files changed, 63 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/kvm/pmu.c

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 9ba59832b71a..655ad08edc3a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -233,8 +233,14 @@ struct kvm_cpu_context {
 	struct kvm_vcpu *__hyp_running_vcpu;
 };
 
+struct kvm_pmu_events {
+	u32 events_host;
+	u32 events_guest;
+};
+
 struct kvm_host_data {
 	struct kvm_cpu_context host_ctxt;
+	struct kvm_pmu_events pmu_events;
 };
 
 typedef struct kvm_host_data kvm_host_data_t;
@@ -572,11 +578,22 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu);
 
+static inline bool kvm_pmu_counter_deferred(struct perf_event_attr *attr)
+{
+	return attr->exclude_host;
+}
+
 #ifdef CONFIG_KVM /* Avoid conflicts with core headers if CONFIG_KVM=n */
 static inline int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 {
 	return kvm_arch_vcpu_run_map_fp(vcpu);
 }
+
+void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr);
+void kvm_clr_pmu_events(u32 clr);
+#else
+static inline void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr) {}
+static inline void kvm_clr_pmu_events(u32 clr) {}
 #endif
 
 static inline void kvm_arm_vhe_guest_enter(void)
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 690e033a91c0..3ac1a64d2fb9 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -17,7 +17,7 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/psci.o $(KVM)/arm/perf.o
 kvm-$(CONFIG_KVM_ARM_HOST) += inject_fault.o regmap.o va_layout.o
 kvm-$(CONFIG_KVM_ARM_HOST) += hyp.o hyp-init.o handle_exit.o
 kvm-$(CONFIG_KVM_ARM_HOST) += guest.o debug.o reset.o sys_regs.o sys_regs_generic_v8.o
-kvm-$(CONFIG_KVM_ARM_HOST) += vgic-sys-reg-v3.o fpsimd.o
+kvm-$(CONFIG_KVM_ARM_HOST) += vgic-sys-reg-v3.o fpsimd.o pmu.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/aarch32.o
 
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic.o
diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
new file mode 100644
index 000000000000..5414b134f99a
--- /dev/null
+++ b/arch/arm64/kvm/pmu.c
@@ -0,0 +1,45 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright 2019 Arm Limited
+ * Author: Andrew Murray <Andrew.Murray@arm.com>
+ */
+#include <linux/kvm_host.h>
+#include <linux/perf_event.h>
+
+/*
+ * Given the exclude_{host,guest} attributes, determine if we are going
+ * to need to switch counters at guest entry/exit.
+ */
+static bool kvm_pmu_switch_needed(struct perf_event_attr *attr)
+{
+	/* Only switch if attributes are different */
+	return (attr->exclude_host != attr->exclude_guest);
+}
+
+/*
+ * Add events to track that we may want to switch at guest entry/exit
+ * time.
+ */
+void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr)
+{
+	struct kvm_host_data *ctx = this_cpu_ptr(&kvm_host_data);
+
+	if (!kvm_pmu_switch_needed(attr))
+		return;
+
+	if (!attr->exclude_host)
+		ctx->pmu_events.events_host |= set;
+	if (!attr->exclude_guest)
+		ctx->pmu_events.events_guest |= set;
+}
+
+/*
+ * Stop tracking events
+ */
+void kvm_clr_pmu_events(u32 clr)
+{
+	struct kvm_host_data *ctx = this_cpu_ptr(&kvm_host_data);
+
+	ctx->pmu_events.events_host &= ~clr;
+	ctx->pmu_events.events_guest &= ~clr;
+}
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
