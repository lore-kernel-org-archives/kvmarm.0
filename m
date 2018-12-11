From: Andrew Murray <andrew.murray@arm.com>
Subject: [PATCH v7 3/5] arm64: KVM: add accessors to track guest/host only
 counters
Date: Tue, 11 Dec 2018 12:13:38 +0000
Message-ID: <1544530420-1477-4-git-send-email-andrew.murray@arm.com>
References: <1544530420-1477-1-git-send-email-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E135F4A334
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 07:14:12 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JSvVKdfixkmG for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Dec 2018 07:14:11 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D27B24A1DF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 07:14:11 -0500 (EST)
In-Reply-To: <1544530420-1477-1-git-send-email-andrew.murray@arm.com>
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

In order to effeciently enable/disable guest/host only perf counters
at guest entry/exit we add bitfields to kvm_cpu_context for guest and
host events as well as accessors for updating them.

Signed-off-by: Andrew Murray <andrew.murray@arm.com>
---
 arch/arm64/include/asm/kvm_host.h | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index bcf9d60..8c0c694 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -205,8 +205,14 @@ struct kvm_cpu_context {
 	struct kvm_vcpu *__hyp_running_vcpu;
 };
 
+struct kvm_pmu_events {
+	u32 events_host;
+	u32 events_guest;
+};
+
 struct kvm_host_data {
 	struct kvm_cpu_context __kvm_cpu_state;
+	struct kvm_pmu_events pmu_events;
 };
 
 typedef struct kvm_host_data kvm_cpu_context_t;
@@ -471,11 +477,33 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu);
 
+#define KVM_PMU_EVENTS_HOST	1
+#define KVM_PMU_EVENTS_GUEST	2
+
 #ifdef CONFIG_KVM /* Avoid conflicts with core headers if CONFIG_KVM=n */
 static inline int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 {
 	return kvm_arch_vcpu_run_map_fp(vcpu);
 }
+static inline void kvm_set_pmu_events(u32 set, int flags)
+{
+	struct kvm_host_data *ctx = this_cpu_ptr(&kvm_host_cpu_state);
+
+	if (flags & KVM_PMU_EVENTS_HOST)
+		ctx->pmu_events.events_host |= set;
+	if (flags & KVM_PMU_EVENTS_GUEST)
+		ctx->pmu_events.events_guest |= set;
+}
+static inline void kvm_clr_pmu_events(u32 clr)
+{
+	struct kvm_host_data *ctx = this_cpu_ptr(&kvm_host_cpu_state);
+
+	ctx->pmu_events.events_host &= ~clr;
+	ctx->pmu_events.events_guest &= ~clr;
+}
+#else
+static inline void kvm_set_pmu_events(u32 set, int flags) {}
+static inline void kvm_clr_pmu_events(u32 clr) {}
 #endif
 
 static inline void kvm_arm_vhe_guest_enter(void)
-- 
2.7.4
