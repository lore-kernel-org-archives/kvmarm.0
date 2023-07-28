Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88071641C
	for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 18:19:43 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d087ffcc43cso2270752276.3
        for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 11:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690568382; x=1691173182;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=H7xJDFLue/NvwsOlwF0hcWMCcGztcwcVHo0aL0oqpCk=;
        b=MFangAmRBbh+y81QRDLHlnYWDvQam6hXRtl/9i9dvGTHWjQTWrcGvnSxU9nQj+bhLG
         KRzv3Uowtaa75RT4RISVnvfwip8juIdbGophEv79/46AnMKYkzKWTLmfmSb9gPbKid6h
         8Oini5a6yFzTlXor1VJxSgWUyPvlprvZwBtZPz1MUdZ57CLfM+BtzFhXwkC21T49fiVF
         A+nu0DCxaly6SaU567uP7eaLYDtse4zpLotilYTpvJ6AKUHYJTxTOuqmNKajw70r18aV
         6VN4k0AIJtA32vvNG2KjElxBrD4g+cVb19koF09jjMuPCmV4GVAmWnlzFJUOqw0GW2kw
         DoLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690568382; x=1691173182;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H7xJDFLue/NvwsOlwF0hcWMCcGztcwcVHo0aL0oqpCk=;
        b=cBlhNP2DhzpIu1k0R6zQh1lJT3h3/7j9tsmBVMcKfPZtpt34hT3kHWNtMZw120CLM/
         YLHQu5ll8b9OHktQoYyEJneHDPs1s047qPlanpZzGw4woYqBwyefiKwjTbLsvX9M1Fpe
         MAToukZBdBjzttEBh9e9AP4Yd0liQaPDSBiwO9So9rpaXUSlrpAcdVOcSrbMoiLiRf+k
         ithXhRFg89P5ZqTpqtk2YR/wVNKaRhkT5R4navulCCAA/f9vobzKiO60iQATT60scXkW
         0DJ+9aowvq992C4jM4RXydWoc3tht15U4oymAHnYRi7bY/tXouXBrGcWIbJQyHd1C+pQ
         zvQA==
X-Gm-Message-State: ABy/qLbgj042WoFrV0Ig7euV2ufhgOmgBn7TrQ9n5ZrWaYiXwidqzIzp
	Oq3YRRjFF/alkJouiBDiO4yq1VEsnjI=
X-Google-Smtp-Source: APBJJlHLtcHDyqcq9MQ6CU4noYTnxBVY9xSNarpOt7Z38zw5Zg3c+tHSZBL/SzA6OvcKskJwpb9P4Vgnm9I=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:ae0c:0:b0:d05:38ba:b616 with SMTP id
 a12-20020a25ae0c000000b00d0538bab616mr13044ybj.6.1690568382652; Fri, 28 Jul
 2023 11:19:42 -0700 (PDT)
Date: Fri, 28 Jul 2023 11:19:04 -0700
In-Reply-To: <20230728181907.1759513-1-reijiw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230728181907.1759513-1-reijiw@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230728181907.1759513-3-reijiw@google.com>
Subject: [PATCH v2 2/5] KVM: arm64: PMU: Disallow vPMU on non-uniform PMUVer systems
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Jing Zhang <jingzhangos@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"

Disallow userspace from configuring vPMU for guests on systems
where the PMUVer is not uniform across all PEs.
KVM has not been advertising PMUv3 to the guests with vPMU on
such systems anyway, and such systems would be extremely
uncommon and unlikely to even use KVM.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/arm.c      |  1 +
 arch/arm64/kvm/pmu-emul.c | 11 ++++++++---
 include/kvm/arm_pmu.h     |  3 +++
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 72dc53a75d1c..1d410dea21ac 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2053,6 +2053,7 @@ static int __init init_subsystems(void)
 		goto out;
 
 	kvm_register_perf_callbacks(NULL);
+	kvm_pmu_init();
 
 out:
 	if (err)
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index dee83119e112..6fb5c59948a8 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -685,9 +685,6 @@ void kvm_host_pmu_init(struct arm_pmu *pmu)
 	entry->arm_pmu = pmu;
 	list_add_tail(&entry->entry, &arm_pmus);
 
-	if (list_is_singular(&arm_pmus))
-		static_branch_enable(&kvm_arm_pmu_available);
-
 out_unlock:
 	mutex_unlock(&arm_pmus_lock);
 }
@@ -1057,3 +1054,11 @@ u8 kvm_arm_pmu_get_pmuver_limit(void)
 					      ID_AA64DFR0_EL1_PMUVer_V3P5);
 	return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), tmp);
 }
+
+void kvm_pmu_init(void)
+{
+	u8 pmuver = kvm_arm_pmu_get_pmuver_limit();
+
+	if (pmuv3_implemented(pmuver))
+		static_branch_enable(&kvm_arm_pmu_available);
+}
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 847da6fc2713..9cf50e16305a 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -74,6 +74,7 @@ int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu);
 struct kvm_pmu_events *kvm_get_pmu_events(void);
 void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu);
 void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
+void kvm_pmu_init(void);
 
 #define kvm_vcpu_has_pmu(vcpu)					\
 	(test_bit(KVM_ARM_VCPU_PMU_V3, (vcpu)->arch.features))
@@ -110,6 +111,8 @@ static inline bool kvm_arm_support_pmu_v3(void)
 	return false;
 }
 
+static inline void kvm_pmu_init(void) {};
+
 #define kvm_arm_pmu_irq_initialized(v)	(false)
 static inline u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu,
 					    u64 select_idx)
-- 
2.41.0.585.gd2178a4bd4-goog

