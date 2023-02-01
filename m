Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DBA47E2
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 02:51:43 +0000 (UTC)
Received: by mail-pl1-f202.google.com with SMTP id z9-20020a170902d54900b00196680ec8bbso5671818plf.16
        for <kvmarm@lists.linux.dev>; Tue, 31 Jan 2023 18:51:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0IGgYlV2YluUk+TGyAtX4/ZqYNoaZrpYTz1eulwaqT8=;
        b=VcLoRzYY0W+13Iaj7GikG+aDb3dgA5DAOAlmQ4R+sUyYDMkMd9yoh+vwjm6EuSQJds
         v+TVKjRtu8fukcsAAj7W9HgrReSAKo6m8GsE9Zg4l97op8zc+/p2gdzJZZ91u6m0tWq8
         T1xV1i4edK+hEhAMHmhTDc9lJECMDmZAo905zpi5tJQ1RdVStCBh1BEruj7Kq65eHqRl
         ygM59xlBQFZFAUM15WUnkhe+2Q1eBA8Pe2KeWb1XVtAMq4xv6ZR3HS2Wldk92CyBEd6V
         2IP7RQ11eBpTCklHGeMXqZsl+p+m6XxXhVS2hP2qmCbkYm7n/XS94jgL8KvAs8t+mpZf
         aU5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0IGgYlV2YluUk+TGyAtX4/ZqYNoaZrpYTz1eulwaqT8=;
        b=hnmWBhVI0MyJGkL4MKmIuVoxebowmkQUBWly0GsHxyGRhUWqZhCexoacnBdEkRC5Sw
         6/dwHlAVArv4QFy8VmZq+IJj69QktfE3I0nCJi3abxvPna7DX0fiu+ti0PhHRNq50sVC
         oIwXWfyPvMMkV+58LFac9RBE0LLo0LZFllu6XUrlsres/RAraetluNq3jmaj0nTI9w+R
         rvG2m/uw0jBmGCBhc9w4eK2KP8esabbDkXTGptKkP4KmZHlEcMdUVzUMMndnLZh31bQD
         LI8KcM1BNnFlMtITUOpCZFoapfUV1Q1Kb4oA9sqRYx7NdhfDFhNMzc6uMcroVj0j5GPm
         ciQg==
X-Gm-Message-State: AO0yUKVoEe6uY1fKiVQ7/YKWYAR6lyLoDc+jEcdRL/yheXSVNqBkGWI+
	bHCLa4PAvGNfDBXEeYiqnGVl7Koa3OESlrqXvw==
X-Google-Smtp-Source: AK7set8e2JuOfVBvSZJmYExBOgRlUp7Xahi/nXUWFlbzYF8wyTA3Q48u3OKL1YWSNbb9Wy4LL8UriodvIhb/sR4KyA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6a00:148e:b0:58d:b5d2:fce2 with
 SMTP id v14-20020a056a00148e00b0058db5d2fce2mr160711pfu.52.1675219902773;
 Tue, 31 Jan 2023 18:51:42 -0800 (PST)
Date: Wed,  1 Feb 2023 02:50:46 +0000
In-Reply-To: <20230201025048.205820-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230201025048.205820-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230201025048.205820-5-jingzhangos@google.com>
Subject: [PATCH v1 4/6] KVM: arm64: Use per guest ID register for ID_AA64DFR0_EL1.PMUVer
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
 arch/arm64/include/asm/kvm_host.h |  5 -----
 arch/arm64/kvm/arm.c              |  6 ------
 arch/arm64/kvm/id_regs.c          | 33 ++++++++++++++++++++-----------
 include/kvm/arm_pmu.h             |  6 ++++--
 4 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index fabb30185a4a..1ab443b52c46 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -225,11 +225,6 @@ struct kvm_arch {
 
 	cpumask_var_t supported_cpus;
 
-	struct {
-		u8 imp:4;
-		u8 unimp:4;
-	} dfr0_pmuver;
-
 	/* Hypercall features firmware registers' descriptor */
 	struct kvm_smccc_features smccc_feat;
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index d8ba5106bf51..25bd95650223 100644
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
index bc5d9bc84eb1..5eade7d380af 100644
--- a/arch/arm64/kvm/id_regs.c
+++ b/arch/arm64/kvm/id_regs.c
@@ -19,10 +19,12 @@
 
 static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
 {
-	if (kvm_vcpu_has_pmu(vcpu))
-		return vcpu->kvm->arch.dfr0_pmuver.imp;
-
-	return vcpu->kvm->arch.dfr0_pmuver.unimp;
+	u8 pmuver = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
+			IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1));
+	if (kvm_vcpu_has_pmu(vcpu) || pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF)
+		return pmuver;
+	else
+		return 0;
 }
 
 static u8 perfmon_to_pmuver(u8 perfmon)
@@ -263,10 +265,9 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 	if (val)
 		return -EINVAL;
 
-	if (valid_pmu)
-		vcpu->kvm->arch.dfr0_pmuver.imp = pmuver;
-	else
-		vcpu->kvm->arch.dfr0_pmuver.unimp = pmuver;
+	IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
+	IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |=
+		FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), pmuver);
 
 	return 0;
 }
@@ -303,10 +304,9 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	if (val)
 		return -EINVAL;
 
-	if (valid_pmu)
-		vcpu->kvm->arch.dfr0_pmuver.imp = perfmon_to_pmuver(perfmon);
-	else
-		vcpu->kvm->arch.dfr0_pmuver.unimp = perfmon_to_pmuver(perfmon);
+	IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
+	IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) |=
+		FIELD_PREP(ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon), perfmon_to_pmuver(perfmon));
 
 	return 0;
 }
@@ -530,4 +530,13 @@ void kvm_arm_set_default_id_regs(struct kvm *kvm)
 	}
 
 	IDREG(kvm, SYS_ID_AA64PFR0_EL1) = val;
+
+	/*
+	 * Initialise the default PMUver before there is a chance to
+	 * create an actual PMU.
+	 */
+	IDREG(kvm, SYS_ID_AA64DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
+	IDREG(kvm, SYS_ID_AA64DFR0_EL1) |=
+		FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
+			   kvm_arm_pmu_get_pmuver_limit());
 }
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 628775334d5e..eef67b7d9751 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -92,8 +92,10 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
 /*
  * Evaluates as true when emulating PMUv3p5, and false otherwise.
  */
-#define kvm_pmu_is_3p5(vcpu)						\
-	(vcpu->kvm->arch.dfr0_pmuver.imp >= ID_AA64DFR0_EL1_PMUVer_V3P5)
+#define kvm_pmu_is_3p5(vcpu)									\
+	(kvm_vcpu_has_pmu(vcpu) &&								\
+	 FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),					\
+		 IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1)) >= ID_AA64DFR0_EL1_PMUVer_V3P5)
 
 u8 kvm_arm_pmu_get_pmuver_limit(void);
 
-- 
2.39.1.456.gfc5497dd1b-goog

