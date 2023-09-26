Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2715A4E
	for <kvmarm@lists.linux.dev>; Tue, 26 Sep 2023 23:40:14 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-d868842eda1so11016135276.0
        for <kvmarm@lists.linux.dev>; Tue, 26 Sep 2023 16:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695771614; x=1696376414; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BFZ3oRaktvjpak7EYQ8bhPZASUfW0XMcRMU08mfnD9k=;
        b=B8sxPIQ1FIaKRJeyg3WkfDYAaeHB2+opx0PYjYufrJf2I9GyVkns4BJgPF8sXK2I+p
         4GxWLPP7XAwzyEVa0geff+MGVj9g2ZILb1R4FJLvmwPs5ileRHbPCnxsK6GbcKm08dDb
         004qmmy/9zo30Ng2faMGsbS9iEbz4lIPHWekK1Kr/4OzF2pEAksDFP5+ubhNTF4NNDTv
         oxhDpcq2hBN+wx9v41pBC+w7twhblJBG3HNdaNXKmgQIlZELyD9VE8eJBGYSMzSNluN8
         K1JB1qHib9AQ1aBpShBpBTBDxyT461HqlksPR02tM/4GJX9CUi9wE6K92OCTVcBrCDPm
         6Suw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695771614; x=1696376414;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BFZ3oRaktvjpak7EYQ8bhPZASUfW0XMcRMU08mfnD9k=;
        b=H1l1npIYiHw88yA7FWmZ4ZJXuZIxTMBmGRsMU7GrF3LK5OmcNwVJpXFJvXSQR6DEno
         w29qtIFJwcEH3xg91wAtoKPif03EnHhztCD/psdtksdnYI+CgS2P910tnkbiP/F39xLw
         uFw79BQlxdX/dXbl8NAWgTSs0qXYZv8CJDMOlQoO4IoZKb9dV0tuNlTD/il/e2OuBWfm
         w4eyJVnHdixJepBzpqfJZz/C2h56MWkucNfwkXnUwJhE5WSEqvmKW3jtAQQoE9e4enoe
         Eyr8fryvdZ85A9cUpnKoTJ428nuHtEqEso7kSBvBZRXhbdoJCvsEIAOPhkCYcZN9e0pk
         lmAA==
X-Gm-Message-State: AOJu0YwcGPGQUdxnk+LxiRBaeTqARdbk7vjkC+0M7JF0UxqSufPMmv5y
	KoPE05bT15lD/vn8G7GXYi0hg6CsuAYb
X-Google-Smtp-Source: AGHT+IFN5HNodPoGlToxTiiSd7fvpfXOrzUL/D9RDPBlHqgEooH+ChekIwrgR4jDdec6AG78NEq0auXsSQym
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:20a1])
 (user=rananta job=sendgmr) by 2002:a25:9289:0:b0:d89:425b:77bd with SMTP id
 y9-20020a259289000000b00d89425b77bdmr4669ybl.1.1695771613788; Tue, 26 Sep
 2023 16:40:13 -0700 (PDT)
Date: Tue, 26 Sep 2023 23:39:59 +0000
In-Reply-To: <20230926234008.2348607-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230926234008.2348607-1-rananta@google.com>
X-Mailer: git-send-email 2.42.0.582.g8ccd20d70d-goog
Message-ID: <20230926234008.2348607-3-rananta@google.com>
Subject: [PATCH v6 02/11] KVM: arm64: PMU: Set the default PMU for the guest
 on vCPU reset
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Reiji Watanabe <reijiw@google.com>

The following patches will use the number of counters information
from the arm_pmu and use this to set the PMCR.N for the guest
during vCPU reset. However, since the guest is not associated
with any arm_pmu until userspace configures the vPMU device
attributes, and a reset can happen before this event, call
kvm_arm_support_pmu_v3() just before doing the reset.

No functional change intended.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/kvm/pmu-emul.c | 12 ++----------
 arch/arm64/kvm/reset.c    | 18 +++++++++++++-----
 include/kvm/arm_pmu.h     |  6 ++++++
 3 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index fb9817bdfeb57..998e1bbd5310d 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -717,8 +717,7 @@ static struct arm_pmu *kvm_pmu_probe_armpmu(void)
 	 * It is still necessary to get a valid cpu, though, to probe for the
 	 * default PMU instance as userspace is not required to specify a PMU
 	 * type. In order to uphold the preexisting behavior KVM selects the
-	 * PMU instance for the core where the first call to the
-	 * KVM_ARM_VCPU_PMU_V3_CTRL attribute group occurs. A dependent use case
+	 * PMU instance for the core during the vcpu reset. A dependent use case
 	 * would be a user with disdain of all things big.LITTLE that affines
 	 * the VMM to a particular cluster of cores.
 	 *
@@ -893,7 +892,7 @@ static void kvm_arm_set_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
  * where vCPUs can be scheduled on any core but the guest
  * counters could stop working.
  */
-static int kvm_arm_set_default_pmu(struct kvm *kvm)
+int kvm_arm_set_default_pmu(struct kvm *kvm)
 {
 	struct arm_pmu *arm_pmu = kvm_pmu_probe_armpmu();
 
@@ -946,13 +945,6 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	if (vcpu->arch.pmu.created)
 		return -EBUSY;
 
-	if (!kvm->arch.arm_pmu) {
-		int ret = kvm_arm_set_default_pmu(kvm);
-
-		if (ret)
-			return ret;
-	}
-
 	switch (attr->attr) {
 	case KVM_ARM_VCPU_PMU_V3_IRQ: {
 		int __user *uaddr = (int __user *)(long)attr->addr;
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 7a65a35ee4ac4..6912832b44b6d 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -206,6 +206,7 @@ static int kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
  */
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 {
+	struct kvm *kvm = vcpu->kvm;
 	struct vcpu_reset_state reset_state;
 	int ret;
 	bool loaded;
@@ -216,6 +217,18 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	vcpu->arch.reset_state.reset = false;
 	spin_unlock(&vcpu->arch.mp_state_lock);
 
+	if (kvm_vcpu_has_pmu(vcpu)) {
+		if (!kvm_arm_support_pmu_v3())
+			return -EINVAL;
+
+		/*
+		 * When the vCPU has a PMU, but no PMU is set for the guest
+		 * yet, set the default one.
+		 */
+		if (unlikely(!kvm->arch.arm_pmu) && kvm_arm_set_default_pmu(kvm))
+			return -EINVAL;
+	}
+
 	/* Reset PMU outside of the non-preemptible section */
 	kvm_pmu_vcpu_reset(vcpu);
 
@@ -255,11 +268,6 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	else
 		pstate = VCPU_RESET_PSTATE_EL1;
 
-	if (kvm_vcpu_has_pmu(vcpu) && !kvm_arm_support_pmu_v3()) {
-		ret = -EINVAL;
-		goto out;
-	}
-
 	/* Reset core registers */
 	memset(vcpu_gp_regs(vcpu), 0, sizeof(*vcpu_gp_regs(vcpu)));
 	memset(&vcpu->arch.ctxt.fp_regs, 0, sizeof(vcpu->arch.ctxt.fp_regs));
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 31029f4f7be85..b80c75d80886b 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -101,6 +101,7 @@ void kvm_vcpu_pmu_resync_el0(void);
 })
 
 u8 kvm_arm_pmu_get_pmuver_limit(void);
+int kvm_arm_set_default_pmu(struct kvm *kvm);
 
 #else
 struct kvm_pmu {
@@ -174,6 +175,11 @@ static inline u8 kvm_arm_pmu_get_pmuver_limit(void)
 }
 static inline void kvm_vcpu_pmu_resync_el0(void) {}
 
+static inline int kvm_arm_set_default_pmu(struct kvm *kvm)
+{
+	return -ENODEV;
+}
+
 #endif
 
 #endif
-- 
2.42.0.582.g8ccd20d70d-goog

