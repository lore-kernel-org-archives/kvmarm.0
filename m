Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EFCFDDDB
	for <kvmarm@lists.linux.dev>; Thu, 17 Aug 2023 00:30:35 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-58daaa2ba65so6491837b3.1
        for <kvmarm@lists.linux.dev>; Wed, 16 Aug 2023 17:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692232234; x=1692837034;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mex/dnvNjwvv3cz9/YanI8OBgPSgiYyAz0HGHhAeol4=;
        b=pv1Q5St4yi9vCvJ/2N8qASCe/iqlLZhX0iyo78sYkUa3vd6I0xqei3JV5Hwtn4I1ch
         XeBIJCcDJMQ02vTKYh31FX58dsTQvl/NRk+qQa4Q0gPmhj20Zi9Bh87LTByxzj59qr2O
         RyNAuWbOg7Txw4ZGldZ5Yu+uVjq52gtJbPD3ddaQJvwx+9UkigBCDCNcOdRWdSCWqoV5
         cfH8j+nqb6L5pvjjWFNxf37U5roRbFx+fgmZpPmFps4YewwbW1rgB9x56cXO812IoRFp
         TzbxNTuOYL+55lYB9EyObL16fOHJYNkfio1B9EnPrFwGU+WRdPuprxTPF3LR3I4eMtLF
         WUKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692232234; x=1692837034;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mex/dnvNjwvv3cz9/YanI8OBgPSgiYyAz0HGHhAeol4=;
        b=VOvsg7Wwkw/W1yX1D8tAyDWwulwmlzzdYZZ11J5bdzG1IdL5THwQNS4qWbfLt85geG
         C9BGO+wndfPrh6ge4czRzFj95XZskHwsMmBUYyqUVKxaLmETrllMAl5T+DPE7Ro9Nxy3
         SOKAefIVdeQ8Ii3YNYPSa1EozDZ4TJDrJlBiBOq2g+S2L+R5ZnmrSrIj7MW5Sa1Set0u
         Jy8irrfz4LRB5ZzfIW1wU5vMpS6jD6ondzXHbKJQEFv2NQqq6hHgJ2Cr3O0Xq0AIzd5h
         6HHEp+/RnLUKbGnTxCZch1XN8xyE43u2oxWVY8uTqFgvlVQcVyu+GF0Y+tdXEtHZeEog
         QQ+w==
X-Gm-Message-State: AOJu0YxNzEtAmGlhVpqajHHqsGfUc/LUpe2wdrUkmDMDiKBwMrMwYOKc
	1C2Jq9EyN/hby2Py+H+T/s2+6Y8nV6m7
X-Google-Smtp-Source: AGHT+IEGmTZ+oaTOH/In34DFDperlCh3+zJ9gyAHYMSQVXUAWM3r/4BOJL9eO8DWsHoD00EhvU/ijFUXAjR8
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a81:c70c:0:b0:57a:118a:f31 with SMTP id
 m12-20020a81c70c000000b0057a118a0f31mr46286ywi.7.1692232234354; Wed, 16 Aug
 2023 17:30:34 -0700 (PDT)
Date: Thu, 17 Aug 2023 00:30:19 +0000
In-Reply-To: <20230817003029.3073210-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230817003029.3073210-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
Message-ID: <20230817003029.3073210-3-rananta@google.com>
Subject: [PATCH v5 02/12] KVM: arm64: PMU: Set the default PMU for the guest
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
 arch/arm64/kvm/pmu-emul.c |  9 +--------
 arch/arm64/kvm/reset.c    | 18 +++++++++++++-----
 include/kvm/arm_pmu.h     |  6 ++++++
 3 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 0ffd1efa90c07..b87822024828a 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -865,7 +865,7 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
 	return true;
 }
 
-static int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
+int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
 {
 	lockdep_assert_held(&kvm->arch.config_lock);
 
@@ -937,13 +937,6 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	if (vcpu->arch.pmu.created)
 		return -EBUSY;
 
-	if (!kvm->arch.arm_pmu) {
-		int ret = kvm_arm_set_vm_pmu(kvm, NULL);
-
-		if (ret)
-			return ret;
-	}
-
 	switch (attr->attr) {
 	case KVM_ARM_VCPU_PMU_V3_IRQ: {
 		int __user *uaddr = (int __user *)(long)attr->addr;
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index bc8556b6f4590..4c20f1ccd0789 100644
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
 
+	/*
+	 * When the vCPU has a PMU, but no PMU is set for the guest
+	 * yet, set the default one.
+	 */
+	if (kvm_vcpu_has_pmu(vcpu) && unlikely(!kvm->arch.arm_pmu)) {
+		ret = -EINVAL;
+		if (kvm_arm_support_pmu_v3())
+			ret = kvm_arm_set_vm_pmu(kvm, NULL);
+		if (ret)
+			return ret;
+	}
+
 	/* Reset PMU outside of the non-preemptible section */
 	kvm_pmu_vcpu_reset(vcpu);
 
@@ -257,11 +270,6 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 		} else {
 			pstate = VCPU_RESET_PSTATE_EL1;
 		}
-
-		if (kvm_vcpu_has_pmu(vcpu) && !kvm_arm_support_pmu_v3()) {
-			ret = -EINVAL;
-			goto out;
-		}
 		break;
 	}
 
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 847da6fc27139..66a2f8477641e 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -100,6 +100,7 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
 })
 
 u8 kvm_arm_pmu_get_pmuver_limit(void);
+int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu);
 
 #else
 struct kvm_pmu {
@@ -172,6 +173,11 @@ static inline u8 kvm_arm_pmu_get_pmuver_limit(void)
 	return 0;
 }
 
+static inline int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
+{
+	return -ENODEV;
+}
+
 #endif
 
 #endif
-- 
2.41.0.694.ge786442a9b-goog

