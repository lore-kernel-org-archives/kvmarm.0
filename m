Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F6F64A
	for <kvmarm@lists.linux.dev>; Fri, 17 Mar 2023 05:06:51 +0000 (UTC)
Received: by mail-pj1-f74.google.com with SMTP id nn7-20020a17090b38c700b0023d370b2cc4so1836188pjb.9
        for <kvmarm@lists.linux.dev>; Thu, 16 Mar 2023 22:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679029610;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OZEB1m53gFZBM6ivDePWUKW0Ym2zNIJxVqCGHxY2i+w=;
        b=CF5MV1cJGzGufvSokK74ZzZ55bn9uqhY6I8M9+PEMv3MqkhYT/vS60WO6niTJmxfEp
         PDX+4vmD9cMjBeg/20KVJ6PNsHE3+XZsKS8jan1GyBwzUwEICElIAqryQjTC5feADYQd
         Mkc/WmacfGt6YbxocAbUQ2uzvYeoyLa5ozWQvJ6v48EE6NFZFDeOESRGBFSUIBgOEDXW
         R22zqVhru+ec7IJJvqla7ZoqSNdnsj0sTohNn8UG4AMfZlG5Ua4AiUcRZqxT98Hnk6Un
         1FW+cnrkBcqCeUttGVKnp89ul4F7Ru1eG37tEGwzG7YHuv1Q+xl1Fe+awKImvtLgyIpi
         3aDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679029610;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OZEB1m53gFZBM6ivDePWUKW0Ym2zNIJxVqCGHxY2i+w=;
        b=c7C+ofLLOnO49DC8/AZOJqBcHr3Wsf3bcAD6LlUsNnA/bRyCrVWt2pn+4gB8ScEskv
         gif86Jy8+d91IRLc9/l2R3JlCy+KJs1dbwqLUARD+8SxLG+t+aT7uxO6WukLSGJcxSVg
         pHsJAnzm5rkOR589vjAqBGA9/Kw5BISQLt027JjhrWHVjE3UNnLIFgx+inwWyCg/7ClS
         wyprwRj7sfJ4wr1la0+mAvg+SZAwEHexO4VIU0OYvNSRwxe5bc6br09wUx0nkQbR9fYl
         NduwOHEGGfbqfvQLwhbj9xPD9/RZQj0u6oQmJRVq5YvbKKxjhX/p6RJjEF1Q5EQT/ebM
         fp3w==
X-Gm-Message-State: AO0yUKUVydJ//PvdGijEgie53HA8WYVYYrywgYOzcA3RIKrJCBZd9bfI
	TWwZFsaNuE3KCi4qaKD2naMA5mMYOV2Gs0SmSQ==
X-Google-Smtp-Source: AK7set/EHeJ/LpIi8CyeNWVjFfI5VAcbXWYcGoamGR0S/Cq6q3ioHjokpVjO2bipV8CRDfT9aK8+oOjF2kSH7Q4xQQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a65:6449:0:b0:507:4737:cdb5 with SMTP
 id s9-20020a656449000000b005074737cdb5mr1489502pgv.8.1679029610705; Thu, 16
 Mar 2023 22:06:50 -0700 (PDT)
Date: Fri, 17 Mar 2023 05:06:35 +0000
In-Reply-To: <20230317050637.766317-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230317050637.766317-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230317050637.766317-5-jingzhangos@google.com>
Subject: [PATCH v4 4/6] KVM: arm64: Use per guest ID register for ID_AA64DFR0_EL1.PMUVer
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@google.com>
Cc: Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Ricardo Koller <ricarkol@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

With per guest ID registers, PMUver settings from userspace
can be stored in its corresponding ID register.

No functional change intended.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 11 +++---
 arch/arm64/kvm/arm.c              |  6 ---
 arch/arm64/kvm/id_regs.c          | 61 +++++++++++++++++++++++++------
 include/kvm/arm_pmu.h             |  5 ++-
 4 files changed, 59 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e926ea91a73c..102860ba896d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -218,6 +218,12 @@ struct kvm_arch {
 #define KVM_ARCH_FLAG_EL1_32BIT				4
 	/* PSCI SYSTEM_SUSPEND enabled for the guest */
 #define KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED		5
+	/*
+	 * AA64DFR0_EL1.PMUver was set as ID_AA64DFR0_EL1_PMUVer_IMP_DEF
+	 * or DFR0_EL1.PerfMon was set as ID_DFR0_EL1_PerfMon_IMPDEF from
+	 * userspace for VCPUs without PMU.
+	 */
+#define KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU		6
 
 	unsigned long flags;
 
@@ -230,11 +236,6 @@ struct kvm_arch {
 
 	cpumask_var_t supported_cpus;
 
-	struct {
-		u8 imp:4;
-		u8 unimp:4;
-	} dfr0_pmuver;
-
 	/* Hypercall features firmware registers' descriptor */
 	struct kvm_smccc_features smccc_feat;
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index c78d68d011cb..fb2de2cb98cb 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -138,12 +138,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm_arm_set_default_id_regs(kvm);
 	kvm_arm_init_hypercalls(kvm);
 
-	/*
-	 * Initialise the default PMUver before there is a chance to
-	 * create an actual PMU.
-	 */
-	kvm->arch.dfr0_pmuver.imp = kvm_arm_pmu_get_pmuver_limit();
-
 	return 0;
 
 err_free_cpumask:
diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
index b60ca1058301..3a87a3d2390d 100644
--- a/arch/arm64/kvm/id_regs.c
+++ b/arch/arm64/kvm/id_regs.c
@@ -21,9 +21,12 @@
 static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
 {
 	if (kvm_vcpu_has_pmu(vcpu))
-		return vcpu->kvm->arch.dfr0_pmuver.imp;
-
-	return vcpu->kvm->arch.dfr0_pmuver.unimp;
+		return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
+				vcpu->kvm->arch.id_regs[IDREG_IDX(SYS_ID_AA64DFR0_EL1)]);
+	else if (test_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags))
+		return ID_AA64DFR0_EL1_PMUVer_IMP_DEF;
+	else
+		return 0;
 }
 
 static u8 perfmon_to_pmuver(u8 perfmon)
@@ -256,10 +259,23 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 	if (val)
 		return -EINVAL;
 
-	if (valid_pmu)
-		vcpu->kvm->arch.dfr0_pmuver.imp = pmuver;
-	else
-		vcpu->kvm->arch.dfr0_pmuver.unimp = pmuver;
+	if (valid_pmu) {
+		mutex_lock(&vcpu->kvm->lock);
+		vcpu->kvm->arch.id_regs[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] &=
+			~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
+		vcpu->kvm->arch.id_regs[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] |=
+			FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), pmuver);
+
+		vcpu->kvm->arch.id_regs[IDREG_IDX(SYS_ID_DFR0_EL1)] &=
+			~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
+		vcpu->kvm->arch.id_regs[IDREG_IDX(SYS_ID_DFR0_EL1)] |= FIELD_PREP(
+				ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon), pmuver_to_perfmon(pmuver));
+		mutex_unlock(&vcpu->kvm->lock);
+	} else if (pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF) {
+		set_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags);
+	} else {
+		clear_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags);
+	}
 
 	return 0;
 }
@@ -296,10 +312,23 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	if (val)
 		return -EINVAL;
 
-	if (valid_pmu)
-		vcpu->kvm->arch.dfr0_pmuver.imp = perfmon_to_pmuver(perfmon);
-	else
-		vcpu->kvm->arch.dfr0_pmuver.unimp = perfmon_to_pmuver(perfmon);
+	if (valid_pmu) {
+		mutex_lock(&vcpu->kvm->lock);
+		vcpu->kvm->arch.id_regs[IDREG_IDX(SYS_ID_DFR0_EL1)] &=
+			~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
+		vcpu->kvm->arch.id_regs[IDREG_IDX(SYS_ID_DFR0_EL1)] |= FIELD_PREP(
+			ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon), perfmon);
+
+		vcpu->kvm->arch.id_regs[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] &=
+			~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
+		vcpu->kvm->arch.id_regs[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] |= FIELD_PREP(
+			ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), perfmon_to_pmuver(perfmon));
+		mutex_unlock(&vcpu->kvm->lock);
+	} else if (perfmon == ID_DFR0_EL1_PerfMon_IMPDEF) {
+		set_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags);
+	} else {
+		clear_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags);
+	}
 
 	return 0;
 }
@@ -543,4 +572,14 @@ void kvm_arm_set_default_id_regs(struct kvm *kvm)
 	}
 
 	kvm->arch.id_regs[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = val;
+
+	/*
+	 * Initialise the default PMUver before there is a chance to
+	 * create an actual PMU.
+	 */
+	kvm->arch.id_regs[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] &=
+		~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
+	kvm->arch.id_regs[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] |=
+		FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
+			   kvm_arm_pmu_get_pmuver_limit());
 }
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 628775334d5e..51c7f3e7bdde 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -92,8 +92,9 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
 /*
  * Evaluates as true when emulating PMUv3p5, and false otherwise.
  */
-#define kvm_pmu_is_3p5(vcpu)						\
-	(vcpu->kvm->arch.dfr0_pmuver.imp >= ID_AA64DFR0_EL1_PMUVer_V3P5)
+#define kvm_pmu_is_3p5(vcpu)									\
+	 (FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),					\
+		 vcpu->kvm->arch.id_regs[IDREG_IDX(SYS_ID_AA64DFR0_EL1)]) >= ID_AA64DFR0_EL1_PMUVer_V3P5)
 
 u8 kvm_arm_pmu_get_pmuver_limit(void);
 
-- 
2.40.0.rc1.284.g88254d51c5-goog

