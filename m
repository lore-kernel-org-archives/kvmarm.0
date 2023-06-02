Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8CA10E9
	for <kvmarm@lists.linux.dev>; Fri,  2 Jun 2023 00:51:27 +0000 (UTC)
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-64d1cbfb240so836432b3a.0
        for <kvmarm@lists.linux.dev>; Thu, 01 Jun 2023 17:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685667087; x=1688259087;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KjUVKn3WM1t8CFRIsXlW7hvHuGxqxUApduT+GCm19kQ=;
        b=ZoZdevxvKJCdxbbhQAuDEHEU0MJaJUiZg9vQb5YUp7RKRbK3fzBIaKrprs/LacF2kX
         +oQiAHkLXfWrKamZOJYmYhRzYEPoUfsi7El/Y3GeCDYO3Oz6EyE4MXVnXeGaYAg/cihF
         M/GnNz0hSkmz0diOh7vtMwMOR7s0Yy3oNmUFkhha7NkCxc/w+twZBQ8z4MssuuabdxAw
         UzS2d53ecjZ8bDLOo6MypB0i7g615tgd3U35fDxb9Ds9WXAfrxkf6T262SOwzJwqJ5cj
         cZYqGGeL+0IL9FdQ6sQOCRb9scao1140gZNbeKw1FC0X1q52UtohVATi8BeLt9Megcuw
         nlpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685667087; x=1688259087;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KjUVKn3WM1t8CFRIsXlW7hvHuGxqxUApduT+GCm19kQ=;
        b=dFWDwy9eHisE8Z79hD3PMIRloeP74QJ7G9XcRifvr7HIOjDyXB2qU2pwOfkECO0hGp
         gyBX9HSsZIPryYxpTWcp/3IwCwptB2n21e4wTTPyx5O67B+6Q+qheXbr7jh+rBS4QYmL
         YvQKIHNDuWlMdXuvjXlbwmRmLy12/Erhr3fHl2lvmiaXZLLn3AGaIU7BOpU2T1/S8A0U
         OHf+w7oHiueBL1RXmyrsQyq7/0ueZuMEyMd1uSKWrLPao31RynBN0Bhgve2mM75bHewP
         pgxhDOCgmsHrUs1DE/SG+rEU1AZSa9T3Ucj2LUw9vavGktdZKo0kysfY0XY/qKrtXgCV
         96Ww==
X-Gm-Message-State: AC+VfDyq6I3f3xaTSCe/++mu4qRUV9a09Xu7BeXHmEPWtGAt4mvj2E6z
	ikrmr3ZYZRCiULE/nAX8nj9PsgkCOSXul+cklA==
X-Google-Smtp-Source: ACHHUZ5UFZT209LQPbKD0VJCWRUJlePpZTIe7Uu8xjezghs90E8vZEIgeCw8S/KYUyV0ZfCuLBO1KvQk2ih1FVjmUQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6a00:2e24:b0:64d:2cb0:c60c with
 SMTP id fc36-20020a056a002e2400b0064d2cb0c60cmr4022318pfb.5.1685667086955;
 Thu, 01 Jun 2023 17:51:26 -0700 (PDT)
Date: Fri,  2 Jun 2023 00:51:15 +0000
In-Reply-To: <20230602005118.2899664-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230602005118.2899664-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602005118.2899664-4-jingzhangos@google.com>
Subject: [PATCH v11 3/5] KVM: arm64: Use per guest ID register for ID_AA64DFR0_EL1.PMUVer
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@google.com>
Cc: Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

With per guest ID registers, PMUver settings from userspace
can be stored in its corresponding ID register.

No functional change intended.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 12 ++++----
 arch/arm64/kvm/arm.c              |  6 ----
 arch/arm64/kvm/sys_regs.c         | 50 +++++++++++++++++++++++--------
 include/kvm/arm_pmu.h             |  9 ++++--
 4 files changed, 52 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8a2fde6c04c4..7b0f43373dbe 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -246,6 +246,13 @@ struct kvm_arch {
 #define KVM_ARCH_FLAG_TIMER_PPIS_IMMUTABLE		7
 	/* SMCCC filter initialized for the VM */
 #define KVM_ARCH_FLAG_SMCCC_FILTER_CONFIGURED		8
+	/*
+	 * AA64DFR0_EL1.PMUver was set as ID_AA64DFR0_EL1_PMUVer_IMP_DEF
+	 * or DFR0_EL1.PerfMon was set as ID_DFR0_EL1_PerfMon_IMPDEF from
+	 * userspace for VCPUs without PMU.
+	 */
+#define KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU		9
+
 	unsigned long flags;
 
 	/*
@@ -257,11 +264,6 @@ struct kvm_arch {
 
 	cpumask_var_t supported_cpus;
 
-	struct {
-		u8 imp:4;
-		u8 unimp:4;
-	} dfr0_pmuver;
-
 	/* Hypercall features firmware registers' descriptor */
 	struct kvm_smccc_features smccc_feat;
 	struct maple_tree smccc_filter;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 5114521ace60..ca18c09ccf82 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -148,12 +148,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm_arm_init_hypercalls(kvm);
 	kvm_arm_init_id_regs(kvm);
 
-	/*
-	 * Initialise the default PMUver before there is a chance to
-	 * create an actual PMU.
-	 */
-	kvm->arch.dfr0_pmuver.imp = kvm_arm_pmu_get_pmuver_limit();
-
 	return 0;
 
 err_free_cpumask:
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index f043811a6725..0179df50fcf5 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1178,9 +1178,12 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
 static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
 {
 	if (kvm_vcpu_has_pmu(vcpu))
-		return vcpu->kvm->arch.dfr0_pmuver.imp;
+		return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
+				 IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1));
+	else if (test_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags))
+		return ID_AA64DFR0_EL1_PMUVer_IMP_DEF;
 
-	return vcpu->kvm->arch.dfr0_pmuver.unimp;
+	return 0;
 }
 
 static u8 perfmon_to_pmuver(u8 perfmon)
@@ -1209,6 +1212,26 @@ static u8 pmuver_to_perfmon(u8 pmuver)
 	}
 }
 
+static void pmuver_update(struct kvm_vcpu *vcpu, u8 pmuver, bool valid_pmu)
+{
+	u64 val;
+
+	if (valid_pmu) {
+		val = IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1);
+		val &= ~ID_AA64DFR0_EL1_PMUVer_MASK;
+		val |= FIELD_PREP(ID_AA64DFR0_EL1_PMUVer_MASK, pmuver);
+		IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) = val;
+
+		val = IDREG(vcpu->kvm, SYS_ID_DFR0_EL1);
+		val &= ~ID_DFR0_EL1_PerfMon_MASK;
+		val |= FIELD_PREP(ID_DFR0_EL1_PerfMon_MASK, pmuver_to_perfmon(pmuver));
+		IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) = val;
+	} else {
+		assign_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags,
+			   pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF);
+	}
+}
+
 static u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 encoding)
 {
 	u64 val = IDREG(vcpu->kvm, encoding);
@@ -1416,11 +1439,7 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 	if (val)
 		return -EINVAL;
 
-	if (valid_pmu)
-		vcpu->kvm->arch.dfr0_pmuver.imp = pmuver;
-	else
-		vcpu->kvm->arch.dfr0_pmuver.unimp = pmuver;
-
+	pmuver_update(vcpu, pmuver, valid_pmu);
 	return 0;
 }
 
@@ -1456,11 +1475,7 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	if (val)
 		return -EINVAL;
 
-	if (valid_pmu)
-		vcpu->kvm->arch.dfr0_pmuver.imp = perfmon_to_pmuver(perfmon);
-	else
-		vcpu->kvm->arch.dfr0_pmuver.unimp = perfmon_to_pmuver(perfmon);
-
+	pmuver_update(vcpu, perfmon_to_pmuver(perfmon), valid_pmu);
 	return 0;
 }
 
@@ -3417,6 +3432,17 @@ void kvm_arm_init_id_regs(struct kvm *kvm)
 	}
 
 	IDREG(kvm, SYS_ID_AA64PFR0_EL1) = val;
+	/*
+	 * Initialise the default PMUver before there is a chance to
+	 * create an actual PMU.
+	 */
+	val = IDREG(kvm, SYS_ID_AA64DFR0_EL1);
+
+	val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
+	val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
+			  kvm_arm_pmu_get_pmuver_limit());
+
+	IDREG(kvm, SYS_ID_AA64DFR0_EL1) = val;
 }
 
 int __init kvm_sys_reg_table_init(void)
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 1a6a695ca67a..5300d91b1e9b 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -92,8 +92,13 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
 /*
  * Evaluates as true when emulating PMUv3p5, and false otherwise.
  */
-#define kvm_pmu_is_3p5(vcpu)						\
-	(vcpu->kvm->arch.dfr0_pmuver.imp >= ID_AA64DFR0_EL1_PMUVer_V3P5)
+#define kvm_pmu_is_3p5(vcpu) ({							\
+		u64 val = IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1);		\
+		u8 v;								\
+										\
+		v = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), val);	\
+		v >= ID_AA64DFR0_EL1_PMUVer_V3P5;				\
+})
 
 u8 kvm_arm_pmu_get_pmuver_limit(void);
 
-- 
2.41.0.rc0.172.g3f132b7071-goog

