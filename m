Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04D63219D
	for <kvmarm@lists.linux.dev>; Fri, 20 Oct 2023 21:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="z1fM7Mm1"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-59b5a586da6so10659067b3.1
        for <kvmarm@lists.linux.dev>; Fri, 20 Oct 2023 14:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697838068; x=1698442868; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6wxdPIo7k8IJbvmMmlNhkE3/rZQV8LNj5jffuDILKrU=;
        b=z1fM7Mm1p72wyennYvdJqw3PGxakFmeMWofLsu6Tg8ziDRn9zpMcx1OYA9snBRAgM+
         /TdnZ54pSdg9vUCh+7pO9Qp1MHnWLcyKQ7M6ktBKBadlmbffImHzYbRIr0GushJM3zJw
         hJG7CGe2ZSb1ab2c6prn3ljNhnSPxSdV5H20Umfa+9/j3sdrpmwYYAFX47l01nG12Z7b
         41QwnJ9CHcOwdCy1QVw0VQ2XvdF7TGkOOU/xJuwXGxxdugU9kiq+PXidyxjggAsEEaoU
         izGILB7/IFoagRlNy69DISwEQNzMVAcqlGBPL+4RWLz2dXKzf7UY11+ZEbRRalmQQifF
         T5WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697838068; x=1698442868;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6wxdPIo7k8IJbvmMmlNhkE3/rZQV8LNj5jffuDILKrU=;
        b=WUO2+utvnk6MzPteVUR6WGPdbepT9Ob1Hhf2DMgywar/msNw6ZUQR5iOB8Kcj25NyD
         hdWDUJ5l/jg6qe887V/Vuv1vAgSspk/p8lkMSOt4gFACVKMwLhQd3d8JvkhRnD1KGXzj
         Yv0ev4j65jeGutf7Z+ZDDwB/iu4syul2+EfIuxsKUfzH7hmVDssNq1z+nwPfTUUAPXlv
         sbIAZxgcQeM1mvatDqMDBCnYfYMHnO92au2Y0oh3rk9sIPSc3AmU8/LbiwSUqRtR8ZIy
         sitpvCtCiCBTN4TeqDKg8X/JJWQVRIaGFZZro8CxK5ebJkRQQWqT6r9YlkouLx3xiryw
         q7Dg==
X-Gm-Message-State: AOJu0YymKLB2ls3OXVZO8cPUYhhOLVQVZcyT7dO3vBr7Ye3lN/+I5/C3
	zjsrlC0DykhCLhChb8B5rJhfhqdS+nsL
X-Google-Smtp-Source: AGHT+IEULiFO21+dHH0b0ROgjE4Z7TEImGseE8FLXI46Z1/spsev4ZP3rz8+bMFoLN226OvPc4WV10YeF0cN
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:20a1])
 (user=rananta job=sendgmr) by 2002:a81:4852:0:b0:5a4:fd03:2516 with SMTP id
 v79-20020a814852000000b005a4fd032516mr87740ywa.1.1697838068747; Fri, 20 Oct
 2023 14:41:08 -0700 (PDT)
Date: Fri, 20 Oct 2023 21:40:52 +0000
In-Reply-To: <20231020214053.2144305-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231020214053.2144305-1-rananta@google.com>
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
Message-ID: <20231020214053.2144305-13-rananta@google.com>
Subject: [PATCH v8 12/13] KVM: selftests: aarch64: vPMU test for validating
 user accesses
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

Add a vPMU test scenario to validate the userspace accesses for
the registers PM{C,I}NTEN{SET,CLR} and PMOVS{SET,CLR} to ensure
that KVM honors the architectural definitions of these registers
for a given PMCR.N.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../kvm/aarch64/vpmu_counter_access.c         | 87 ++++++++++++++++++-
 1 file changed, 86 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
index d5143925690db..2b697b144e677 100644
--- a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
+++ b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
@@ -8,6 +8,8 @@
  * counters (PMCR_EL0.N) that userspace sets, if the guest can access
  * those counters, and if the guest is prevented from accessing any
  * other counters.
+ * It also checks if the userspace accesses to the PMU regsisters honor the
+ * PMCR.N value that's set for the guest.
  * This test runs only when KVM_CAP_ARM_PMU_V3 is supported on the host.
  */
 #include <kvm_util.h>
@@ -20,6 +22,9 @@
 /* The max number of the PMU event counters (excluding the cycle counter) */
 #define ARMV8_PMU_MAX_GENERAL_COUNTERS	(ARMV8_PMU_MAX_COUNTERS - 1)
 
+/* The cycle counter bit position that's common among the PMU registers */
+#define ARMV8_PMU_CYCLE_IDX		31
+
 struct vpmu_vm {
 	struct kvm_vm *vm;
 	struct kvm_vcpu *vcpu;
@@ -28,6 +33,13 @@ struct vpmu_vm {
 
 static struct vpmu_vm vpmu_vm;
 
+struct pmreg_sets {
+	uint64_t set_reg_id;
+	uint64_t clr_reg_id;
+};
+
+#define PMREG_SET(set, clr) {.set_reg_id = set, .clr_reg_id = clr}
+
 static uint64_t get_pmcr_n(uint64_t pmcr)
 {
 	return (pmcr >> ARMV8_PMU_PMCR_N_SHIFT) & ARMV8_PMU_PMCR_N_MASK;
@@ -39,6 +51,15 @@ static void set_pmcr_n(uint64_t *pmcr, uint64_t pmcr_n)
 	*pmcr |= (pmcr_n << ARMV8_PMU_PMCR_N_SHIFT);
 }
 
+static uint64_t get_counters_mask(uint64_t n)
+{
+	uint64_t mask = BIT(ARMV8_PMU_CYCLE_IDX);
+
+	if (n)
+		mask |= GENMASK(n - 1, 0);
+	return mask;
+}
+
 /* Read PMEVTCNTR<n>_EL0 through PMXEVCNTR_EL0 */
 static inline unsigned long read_sel_evcntr(int sel)
 {
@@ -552,6 +573,68 @@ static void run_access_test(uint64_t pmcr_n)
 	destroy_vpmu_vm();
 }
 
+static struct pmreg_sets validity_check_reg_sets[] = {
+	PMREG_SET(SYS_PMCNTENSET_EL0, SYS_PMCNTENCLR_EL0),
+	PMREG_SET(SYS_PMINTENSET_EL1, SYS_PMINTENCLR_EL1),
+	PMREG_SET(SYS_PMOVSSET_EL0, SYS_PMOVSCLR_EL0),
+};
+
+/*
+ * Create a VM, and check if KVM handles the userspace accesses of
+ * the PMU register sets in @validity_check_reg_sets[] correctly.
+ */
+static void run_pmregs_validity_test(uint64_t pmcr_n)
+{
+	int i;
+	struct kvm_vcpu *vcpu;
+	uint64_t set_reg_id, clr_reg_id, reg_val;
+	uint64_t valid_counters_mask, max_counters_mask;
+
+	test_create_vpmu_vm_with_pmcr_n(pmcr_n, false);
+	vcpu = vpmu_vm.vcpu;
+
+	valid_counters_mask = get_counters_mask(pmcr_n);
+	max_counters_mask = get_counters_mask(ARMV8_PMU_MAX_COUNTERS);
+
+	for (i = 0; i < ARRAY_SIZE(validity_check_reg_sets); i++) {
+		set_reg_id = validity_check_reg_sets[i].set_reg_id;
+		clr_reg_id = validity_check_reg_sets[i].clr_reg_id;
+
+		/*
+		 * Test if the 'set' and 'clr' variants of the registers
+		 * are initialized based on the number of valid counters.
+		 */
+		vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(set_reg_id), &reg_val);
+		TEST_ASSERT((reg_val & (~valid_counters_mask)) == 0,
+			    "Initial read of set_reg: 0x%llx has unimplemented counters enabled: 0x%lx\n",
+			    KVM_ARM64_SYS_REG(set_reg_id), reg_val);
+
+		vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(clr_reg_id), &reg_val);
+		TEST_ASSERT((reg_val & (~valid_counters_mask)) == 0,
+			    "Initial read of clr_reg: 0x%llx has unimplemented counters enabled: 0x%lx\n",
+			    KVM_ARM64_SYS_REG(clr_reg_id), reg_val);
+
+		/*
+		 * Using the 'set' variant, force-set the register to the
+		 * max number of possible counters and test if KVM discards
+		 * the bits for unimplemented counters as it should.
+		 */
+		vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(set_reg_id), max_counters_mask);
+
+		vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(set_reg_id), &reg_val);
+		TEST_ASSERT((reg_val & (~valid_counters_mask)) == 0,
+			    "Read of set_reg: 0x%llx has unimplemented counters enabled: 0x%lx\n",
+			    KVM_ARM64_SYS_REG(set_reg_id), reg_val);
+
+		vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(clr_reg_id), &reg_val);
+		TEST_ASSERT((reg_val & (~valid_counters_mask)) == 0,
+			    "Read of clr_reg: 0x%llx has unimplemented counters enabled: 0x%lx\n",
+			    KVM_ARM64_SYS_REG(clr_reg_id), reg_val);
+	}
+
+	destroy_vpmu_vm();
+}
+
 /*
  * Create a guest with one vCPU, and attempt to set the PMCR_EL0.N for
  * the vCPU to @pmcr_n, which is larger than the host value.
@@ -586,8 +669,10 @@ int main(void)
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_ARM_PMU_V3));
 
 	pmcr_n = get_pmcr_n_limit();
-	for (i = 0; i <= pmcr_n; i++)
+	for (i = 0; i <= pmcr_n; i++) {
 		run_access_test(i);
+		run_pmregs_validity_test(i);
+	}
 
 	for (i = pmcr_n + 1; i < ARMV8_PMU_MAX_COUNTERS; i++)
 		run_error_test(i);
-- 
2.42.0.655.g421f12c284-goog

