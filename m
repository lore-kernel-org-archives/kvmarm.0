Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0FEBA20
	for <kvmarm@lists.linux.dev>; Sat, 27 May 2023 04:04:39 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-bad06cc7fb7so3278888276.3
        for <kvmarm@lists.linux.dev>; Fri, 26 May 2023 21:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685160278; x=1687752278;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uUrVHxQ1VjsIKZJ0cYmjatxxlv1RidcUPcAwfkxMDeQ=;
        b=mnKD5djePan6cHUiRAmZh38Jmo+ropUJ0h0VmSE6uXDB/X12f01Q1L295u/FPmsJe7
         psC4a9zcrCkyAa0xQFqKrV9FLzwyA7ATKehSlM0c7ERZJii79G9dsfEwowCoo0nNDTF3
         5NCRrlT59GgmTp/pVXGlfeSkIkv5YFtnrW0wlZi2s2rqz21oT09bP6qfK4fb5hBCSC09
         PxuvQeOOnXn4blCcFNbFRNEXN7GPF+KeUXP2ym9XDgMEyPD8icS7IKN2yqxz5oVLyYu7
         cUUYIHqVISmSIVQvx8JAolK7vvPmc8Lg/sCVUk2mHRfx0V9b2DSRQEcl4CWhrALeA4cm
         HmOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685160278; x=1687752278;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uUrVHxQ1VjsIKZJ0cYmjatxxlv1RidcUPcAwfkxMDeQ=;
        b=WK9zVr+0rcgqTRBPd3L/jHWhy3+UW3+JeCuI0LIoqCeZwe2TPVojlKw1mAjAxGZ9SJ
         xgSY+B/aTnZ4Lr20Hq9O631NjnWitL7sTmihl2imEs+H/s2YMOgrmM9hpXAIEYvfh0aq
         CUq/HmsvRwggrP5Onxwk4cTXeMECF5uw42Ui74atetdAauvwRqKRwXoP+WcyMBcHyaAG
         K1eol0blN0OsI3e1QqkLBTx6aRDlcfF35wfniyut1D/zkqK3KcRoxtMJRlYKe5+Ui4+c
         vkCyjkkak635eR9ipBzt1BhwfvbfYLs9beF+xXe8ieDBdxLbp3nzj4ziFy++pe9LJ/i3
         Y9dw==
X-Gm-Message-State: AC+VfDyuiiXO6FNGybo/JE5eCCVgChCzSkGupPAklh6Iv/+nk8T3fBxs
	6p+mlezrwGR4wloTh6NECRdxMj7L2dY=
X-Google-Smtp-Source: ACHHUZ40X1JtVnbU0yW1OlIarBd66lox6g/g0byncu954rsHLASWFxfD7mYTWnHgIRpIDTHXydpwbi5LsS4=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:2646:0:b0:bac:f582:ef18 with SMTP id
 m67-20020a252646000000b00bacf582ef18mr2153443ybm.5.1685160278549; Fri, 26 May
 2023 21:04:38 -0700 (PDT)
Date: Fri, 26 May 2023 21:02:34 -0700
In-Reply-To: <20230527040236.1875860-1-reijiw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230527040236.1875860-1-reijiw@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230527040236.1875860-3-reijiw@google.com>
Subject: [PATCH 2/4] KVM: arm64: PMU: Set the default PMU for the guest on
 vCPU reset
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Jing Zhang <jingzhangos@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	Will Deacon <will@kernel.org>, Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"

Set the default PMU for the guest on the first vCPU reset,
not when userspace initially uses KVM_ARM_VCPU_PMU_V3_CTRL.
The following patches will use the PMUVer of the PMU as the
default value of the ID_AA64DFR0_EL1.PMUVer for vCPUs with
PMU configured.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/pmu-emul.c | 10 +---------
 arch/arm64/kvm/reset.c    | 20 +++++++++++++-------
 include/kvm/arm_pmu.h     |  6 ++++++
 3 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index d50c8f7a2410..0194a94c4bae 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -869,7 +869,7 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
 	return true;
 }
 
-static int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
+int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
 {
 	lockdep_assert_held(&kvm->arch.config_lock);
 
@@ -926,14 +926,6 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	if (vcpu->arch.pmu.created)
 		return -EBUSY;
 
-	if (!kvm->arch.arm_pmu) {
-		/* No PMU set, get the default one */
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
index b5dee8e57e77..f5e24492926c 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -258,13 +258,24 @@ static int kvm_set_vm_width(struct kvm_vcpu *vcpu)
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_reset_state reset_state;
+	struct kvm *kvm = vcpu->kvm;
 	int ret;
 	bool loaded;
 	u32 pstate;
 
-	mutex_lock(&vcpu->kvm->arch.config_lock);
+	mutex_lock(&kvm->arch.config_lock);
 	ret = kvm_set_vm_width(vcpu);
-	mutex_unlock(&vcpu->kvm->arch.config_lock);
+	if (!ret && kvm_vcpu_has_pmu(vcpu)) {
+		if (!kvm_arm_support_pmu_v3())
+			ret = -EINVAL;
+		else if (unlikely(!kvm->arch.arm_pmu))
+			/*
+			 * As no PMU is set for the guest yet,
+			 * set the default one.
+			 */
+			ret = kvm_arm_set_vm_pmu(kvm, NULL);
+	}
+	mutex_unlock(&kvm->arch.config_lock);
 
 	if (ret)
 		return ret;
@@ -315,11 +326,6 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
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
index 1a6a695ca67a..5ece2a3c1858 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -96,6 +96,7 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
 	(vcpu->kvm->arch.dfr0_pmuver.imp >= ID_AA64DFR0_EL1_PMUVer_V3P5)
 
 u8 kvm_arm_pmu_get_pmuver_limit(void);
+int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu);
 
 #else
 struct kvm_pmu {
@@ -168,6 +169,11 @@ static inline u8 kvm_arm_pmu_get_pmuver_limit(void)
 	return 0;
 }
 
+static inline int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
+{
+	return 0;
+}
+
 #endif
 
 #endif
-- 
2.41.0.rc0.172.g3f132b7071-goog

