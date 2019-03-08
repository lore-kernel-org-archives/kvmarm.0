From: Andrew Murray <andrew.murray@arm.com>
Subject: [PATCH v11 6/8] arm64: KVM: Enable VHE support for :G/:H perf event
 modifiers
Date: Fri,  8 Mar 2019 12:07:44 +0000
Message-ID: <20190308120746.56897-7-andrew.murray@arm.com>
References: <20190308120746.56897-1-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 277174A4DD
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Mar 2019 07:08:10 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id K2FNif3jXH4m for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Mar 2019 07:08:07 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C87C34A47D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Mar 2019 07:08:07 -0500 (EST)
In-Reply-To: <20190308120746.56897-1-andrew.murray@arm.com>
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

With VHE different exception levels are used between the host (EL2) and
guest (EL1) with a shared exception level for userpace (EL0). We can take
advantage of this and use the PMU's exception level filtering to avoid
enabling/disabling counters in the world-switch code. Instead we just
modify the counter type to include or exclude EL0 at vcpu_{load,put} time.

We also ensure that trapped PMU system register writes do not re-enable
EL0 when reconfiguring the backing perf events.

This approach completely avoids blackout windows seen with !VHE.

Suggested-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Andrew Murray <andrew.murray@arm.com>
---
 arch/arm/include/asm/kvm_host.h   |  3 ++
 arch/arm64/include/asm/kvm_host.h |  5 +-
 arch/arm64/kernel/perf_event.c    |  6 ++-
 arch/arm64/kvm/pmu.c              | 87 ++++++++++++++++++++++++++++++-
 arch/arm64/kvm/sys_regs.c         |  3 ++
 virt/kvm/arm/arm.c                |  2 +
 6 files changed, 102 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index a358cb15bb0d..3ce429954306 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -326,6 +326,9 @@ static inline void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu) {}
 
+static inline void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu) {}
+static inline void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu) {}
+
 static inline void kvm_arm_vhe_guest_enter(void) {}
 static inline void kvm_arm_vhe_guest_exit(void) {}
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7ca4e094626d..d631528898b5 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -487,7 +487,7 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu);
 
 static inline bool kvm_pmu_counter_defered(struct perf_event_attr *attr)
 {
-	return attr->exclude_host;
+	return (!has_vhe() && attr->exclude_host);
 }
 
 #ifdef CONFIG_KVM /* Avoid conflicts with core headers if CONFIG_KVM=n */
@@ -501,6 +501,9 @@ void kvm_clr_pmu_events(u32 clr);
 
 void __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt);
 bool __pmu_switch_to_guest(struct kvm_cpu_context *host_ctxt);
+
+void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu);
+void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
 #else
 static inline void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr) {}
 static inline void kvm_clr_pmu_events(u32 clr) {}
diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
index 64f02a9fd7cd..a121a82fc54c 100644
--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@ -847,8 +847,12 @@ static int armv8pmu_set_event_filter(struct hw_perf_event *event,
 	 * with other architectures (x86 and Power).
 	 */
 	if (is_kernel_in_hyp_mode()) {
-		if (!attr->exclude_kernel)
+		if (!attr->exclude_kernel && !attr->exclude_host)
 			config_base |= ARMV8_PMU_INCLUDE_EL2;
+		if (attr->exclude_guest)
+			config_base |= ARMV8_PMU_EXCLUDE_EL1;
+		if (attr->exclude_host)
+			config_base |= ARMV8_PMU_EXCLUDE_EL0;
 	} else {
 		if (!attr->exclude_hv && !attr->exclude_host)
 			config_base |= ARMV8_PMU_INCLUDE_EL2;
diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index a1cee7919953..a0830c70ece5 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -12,11 +12,19 @@
 DECLARE_PER_CPU(kvm_host_data_t, kvm_host_data);
 
 /*
- * Given the exclude_{host,guest} attributes, determine if we are going
- * to need to switch counters at guest entry/exit.
+ * Given the perf event attributes and system type, determine
+ * if we are going to need to switch counters at guest entry/exit.
  */
 static bool kvm_pmu_switch_needed(struct perf_event_attr *attr)
 {
+	/**
+	 * With VHE the guest kernel runs at EL1 and the host at EL2,
+	 * where user (EL0) is excluded then we have no reason to switch
+	 * counters.
+	 */
+	if (has_vhe() && attr->exclude_user)
+		return false;
+
 	/* Only switch if attributes are different */
 	return (attr->exclude_host ^ attr->exclude_guest);
 }
@@ -87,3 +95,78 @@ void __hyp_text __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
 		write_sysreg(pmu->events_host, pmcntenset_el0);
 }
 
+/*
+ * Modify ARMv8 PMU events to include EL0 counting
+ */
+static void kvm_vcpu_pmu_enable_el0(unsigned long events)
+{
+	u64 typer;
+	u32 counter;
+
+	for_each_set_bit(counter, &events, 32) {
+		write_sysreg(counter, pmselr_el0);
+		isb();
+		typer = read_sysreg(pmxevtyper_el0) & ~ARMV8_PMU_EXCLUDE_EL0;
+		write_sysreg(typer, pmxevtyper_el0);
+		isb();
+	}
+}
+
+/*
+ * Modify ARMv8 PMU events to exclude EL0 counting
+ */
+static void kvm_vcpu_pmu_disable_el0(unsigned long events)
+{
+	u64 typer;
+	u32 counter;
+
+	for_each_set_bit(counter, &events, 32) {
+		write_sysreg(counter, pmselr_el0);
+		isb();
+		typer = read_sysreg(pmxevtyper_el0) | ARMV8_PMU_EXCLUDE_EL0;
+		write_sysreg(typer, pmxevtyper_el0);
+		isb();
+	}
+}
+
+/*
+ * On VHE ensure that only guest events have EL0 counting enabled
+ */
+void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpu_context *host_ctxt;
+	struct kvm_host_data *host;
+	u32 events_guest, events_host;
+
+	if (!has_vhe())
+		return;
+
+	host_ctxt = vcpu->arch.host_cpu_context;
+	host = container_of(host_ctxt, struct kvm_host_data, host_ctxt);
+	events_guest = host->pmu_events.events_guest;
+	events_host = host->pmu_events.events_host;
+
+	kvm_vcpu_pmu_enable_el0(events_guest);
+	kvm_vcpu_pmu_disable_el0(events_host);
+}
+
+/*
+ * On VHE ensure that only guest host have EL0 counting enabled
+ */
+void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpu_context *host_ctxt;
+	struct kvm_host_data *host;
+	u32 events_guest, events_host;
+
+	if (!has_vhe())
+		return;
+
+	host_ctxt = vcpu->arch.host_cpu_context;
+	host = container_of(host_ctxt, struct kvm_host_data, host_ctxt);
+	events_guest = host->pmu_events.events_guest;
+	events_host = host->pmu_events.events_host;
+
+	kvm_vcpu_pmu_enable_el0(events_host);
+	kvm_vcpu_pmu_disable_el0(events_guest);
+}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c936aa40c3f4..209f9dd97bcb 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -695,6 +695,7 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		val |= p->regval & ARMV8_PMU_PMCR_MASK;
 		__vcpu_sys_reg(vcpu, PMCR_EL0) = val;
 		kvm_pmu_handle_pmcr(vcpu, val);
+		kvm_vcpu_pmu_restore_guest(vcpu);
 	} else {
 		/* PMCR.P & PMCR.C are RAZ */
 		val = __vcpu_sys_reg(vcpu, PMCR_EL0)
@@ -850,6 +851,7 @@ static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	if (p->is_write) {
 		kvm_pmu_set_counter_event_type(vcpu, p->regval, idx);
 		__vcpu_sys_reg(vcpu, reg) = p->regval & ARMV8_PMU_EVTYPE_MASK;
+		kvm_vcpu_pmu_restore_guest(vcpu);
 	} else {
 		p->regval = __vcpu_sys_reg(vcpu, reg) & ARMV8_PMU_EVTYPE_MASK;
 	}
@@ -875,6 +877,7 @@ static bool access_pmcnten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			/* accessing PMCNTENSET_EL0 */
 			__vcpu_sys_reg(vcpu, PMCNTENSET_EL0) |= val;
 			kvm_pmu_enable_counter(vcpu, val);
+			kvm_vcpu_pmu_restore_guest(vcpu);
 		} else {
 			/* accessing PMCNTENCLR_EL0 */
 			__vcpu_sys_reg(vcpu, PMCNTENSET_EL0) &= ~val;
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 6958b98b8d52..1306bf0ad025 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -385,6 +385,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	kvm_timer_vcpu_load(vcpu);
 	kvm_vcpu_load_sysregs(vcpu);
 	kvm_arch_vcpu_load_fp(vcpu);
+	kvm_vcpu_pmu_restore_guest(vcpu);
 
 	if (single_task_running())
 		vcpu_clear_wfe_traps(vcpu);
@@ -398,6 +399,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	kvm_vcpu_put_sysregs(vcpu);
 	kvm_timer_vcpu_put(vcpu);
 	kvm_vgic_put(vcpu);
+	kvm_vcpu_pmu_restore_host(vcpu);
 
 	vcpu->cpu = -1;
 
-- 
2.21.0
