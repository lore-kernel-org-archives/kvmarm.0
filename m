From: Andrew Murray <andrew.murray@arm.com>
Subject: [PATCH v12 7/8] arm64: KVM: avoid isb's by using direct pmxevtyper
 sysreg
Date: Thu, 28 Mar 2019 10:37:30 +0000
Message-ID: <20190328103731.27264-8-andrew.murray@arm.com>
References: <20190328103731.27264-1-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E1B24A43E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Mar 2019 06:37:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3voJS8EUwrO7 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Mar 2019 06:37:53 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C81894A426
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Mar 2019 06:37:53 -0400 (EDT)
In-Reply-To: <20190328103731.27264-1-andrew.murray@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

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
