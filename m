Return-Path: <SRS0=N2lg=SL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 055D6C282DA
	for <kvmarm@archiver.kernel.org>; Tue,  9 Apr 2019 19:22:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B535420820
	for <kvmarm@archiver.kernel.org>; Tue,  9 Apr 2019 19:22:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B535420820
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FC564A4BD;
	Tue,  9 Apr 2019 15:22:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id av2V-OVzwYGC; Tue,  9 Apr 2019 15:22:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 083444A482;
	Tue,  9 Apr 2019 15:22:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 76BE04A4B0
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Apr 2019 15:22:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wZTyjekuhfUl for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Apr 2019 15:22:41 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 08AF54A4C2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Apr 2019 15:22:41 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 94A781688;
 Tue,  9 Apr 2019 12:22:40 -0700 (PDT)
Received: from e119886-lin.cambridge.arm.com (unknown [10.37.6.20])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9C7803F59C;
 Tue,  9 Apr 2019 12:22:38 -0700 (PDT)
From: Andrew Murray <andrew.murray@arm.com>
To: Christoffer Dall <christoffer.dall@arm.com>,
 Marc Zyngier <marc.zyngier@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH v13 7/8] arm64: KVM: avoid isb's by using direct pmxevtyper
 sysreg
Date: Tue,  9 Apr 2019 20:22:16 +0100
Message-Id: <20190409192217.23459-8-andrew.murray@arm.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190409192217.23459-1-andrew.murray@arm.com>
References: <20190409192217.23459-1-andrew.murray@arm.com>
MIME-Version: 1.0
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190409192216.wuZILutxcT7fa8Tgsu7oUvY5McgJeGkOUzXQZNcGp1k@z>

Upon entering or exiting a guest we may modify multiple PMU counters to
enable of disable EL0 filtering. We presently do this via the indirect
PMXEVTYPER_EL0 system register (where the counter we modify is selected
by PMSELR). With this approach it is necessary to order the writes via
isb instructions such that we select the correct counter before modifying
it.

Let's avoid potentially expensive instruction barriers by using the
direct PMEVTYPER<n>_EL0 registers instead.

As the change to counter type relates only to EL0 filtering we can rely
on the implicit instruction barrier which occurs when we transition from
EL2 to EL1 on entering the guest. On returning to userspace we can, at the
latest, rely on the implicit barrier between EL2 and EL0. We can also
depend on the explicit isb in armv8pmu_select_counter to order our write
against any other kernel changes by the PMU driver to the type register as
a result of preemption.

Signed-off-by: Andrew Murray <andrew.murray@arm.com>
---
 arch/arm64/kvm/pmu.c | 84 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 74 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 3407a529e116..4d55193ccc71 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -91,6 +91,74 @@ void __hyp_text __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
 		write_sysreg(pmu->events_host, pmcntenset_el0);
 }
 
+#define PMEVTYPER_READ_CASE(idx)				\
+	case idx:						\
+		return read_sysreg(pmevtyper##idx##_el0)
+
+#define PMEVTYPER_WRITE_CASE(idx)				\
+	case idx:						\
+		write_sysreg(val, pmevtyper##idx##_el0);	\
+		break
+
+#define PMEVTYPER_CASES(readwrite)				\
+	PMEVTYPER_##readwrite##_CASE(0);			\
+	PMEVTYPER_##readwrite##_CASE(1);			\
+	PMEVTYPER_##readwrite##_CASE(2);			\
+	PMEVTYPER_##readwrite##_CASE(3);			\
+	PMEVTYPER_##readwrite##_CASE(4);			\
+	PMEVTYPER_##readwrite##_CASE(5);			\
+	PMEVTYPER_##readwrite##_CASE(6);			\
+	PMEVTYPER_##readwrite##_CASE(7);			\
+	PMEVTYPER_##readwrite##_CASE(8);			\
+	PMEVTYPER_##readwrite##_CASE(9);			\
+	PMEVTYPER_##readwrite##_CASE(10);			\
+	PMEVTYPER_##readwrite##_CASE(11);			\
+	PMEVTYPER_##readwrite##_CASE(12);			\
+	PMEVTYPER_##readwrite##_CASE(13);			\
+	PMEVTYPER_##readwrite##_CASE(14);			\
+	PMEVTYPER_##readwrite##_CASE(15);			\
+	PMEVTYPER_##readwrite##_CASE(16);			\
+	PMEVTYPER_##readwrite##_CASE(17);			\
+	PMEVTYPER_##readwrite##_CASE(18);			\
+	PMEVTYPER_##readwrite##_CASE(19);			\
+	PMEVTYPER_##readwrite##_CASE(20);			\
+	PMEVTYPER_##readwrite##_CASE(21);			\
+	PMEVTYPER_##readwrite##_CASE(22);			\
+	PMEVTYPER_##readwrite##_CASE(23);			\
+	PMEVTYPER_##readwrite##_CASE(24);			\
+	PMEVTYPER_##readwrite##_CASE(25);			\
+	PMEVTYPER_##readwrite##_CASE(26);			\
+	PMEVTYPER_##readwrite##_CASE(27);			\
+	PMEVTYPER_##readwrite##_CASE(28);			\
+	PMEVTYPER_##readwrite##_CASE(29);			\
+	PMEVTYPER_##readwrite##_CASE(30)
+
+/*
+ * Read a value direct from PMEVTYPER<idx>
+ */
+static u64 kvm_vcpu_pmu_read_evtype_direct(int idx)
+{
+	switch (idx) {
+	PMEVTYPER_CASES(READ);
+	default:
+		WARN_ON(1);
+	}
+
+	return 0;
+}
+
+/*
+ * Write a value direct to PMEVTYPER<idx>
+ */
+static void kvm_vcpu_pmu_write_evtype_direct(int idx, u32 val)
+{
+	switch (idx) {
+	PMEVTYPER_CASES(WRITE);
+	default:
+		WARN_ON(1);
+	}
+}
+
 /*
  * Modify ARMv8 PMU events to include EL0 counting
  */
@@ -100,11 +168,9 @@ static void kvm_vcpu_pmu_enable_el0(unsigned long events)
 	u32 counter;
 
 	for_each_set_bit(counter, &events, 32) {
-		write_sysreg(counter, pmselr_el0);
-		isb();
-		typer = read_sysreg(pmxevtyper_el0) & ~ARMV8_PMU_EXCLUDE_EL0;
-		write_sysreg(typer, pmxevtyper_el0);
-		isb();
+		typer = kvm_vcpu_pmu_read_evtype_direct(counter);
+		typer &= ~ARMV8_PMU_EXCLUDE_EL0;
+		kvm_vcpu_pmu_write_evtype_direct(counter, typer);
 	}
 }
 
@@ -117,11 +183,9 @@ static void kvm_vcpu_pmu_disable_el0(unsigned long events)
 	u32 counter;
 
 	for_each_set_bit(counter, &events, 32) {
-		write_sysreg(counter, pmselr_el0);
-		isb();
-		typer = read_sysreg(pmxevtyper_el0) | ARMV8_PMU_EXCLUDE_EL0;
-		write_sysreg(typer, pmxevtyper_el0);
-		isb();
+		typer = kvm_vcpu_pmu_read_evtype_direct(counter);
+		typer |= ARMV8_PMU_EXCLUDE_EL0;
+		kvm_vcpu_pmu_write_evtype_direct(counter, typer);
 	}
 }
 
-- 
2.21.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
