Received: from mail-oi1-f201.google.com (mail-oi1-f201.google.com [209.85.167.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2BF3002B4
	for <kvmarm@lists.linux.dev>; Tue,  9 Dec 2025 20:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765313582; cv=none; b=sM3Wf8Uy3C3TYhNE8/d0ndUF1aTdWApjTe4s2lmdIEpuK/w6uF7Nkf8H3zpevFuR4zCxr1e69m053lLeefs+jHtQSWV7fheChXfShWyZioBEDr8Dgm6wAFpxe3Cfcgxfb5BSYqJev/A8ukOy7VBjsP/4OGkeMpLx/bf+DIiyugk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765313582; c=relaxed/simple;
	bh=Ovdb4lVvItfJ3Rv6cYdLAQWvS+U6STJuj9GjRFXJ9SM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JXL+aeuZnYOoWiXnDLm5aH2GkpOYoIomVc7r48yeHBnQNamXKHuCJPUQiYO/W/RG2YWsxL4Gp2pRrzxctNt8GeUGBzcWOd2fJskvwwiKczNt9TEcy24YbKIRHKvYAPbBB8VlBnxDdiN/cq48Hkf5EdFQfRxEbIQP9Q2xaMTJ1Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HnXGuHth; arc=none smtp.client-ip=209.85.167.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HnXGuHth"
Received: by mail-oi1-f201.google.com with SMTP id 5614622812f47-453799e65bbso7447150b6e.1
        for <kvmarm@lists.linux.dev>; Tue, 09 Dec 2025 12:52:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765313571; x=1765918371; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9TQM9hbEKY4h1TXZBEY6y+aDCak1RQ1iwoKxBpJfd80=;
        b=HnXGuHth0yrrAvDx1yMj+ikwDcKk/pfG733EmDTdvYHPGk1KOmfvhEKdcFJAGISfpi
         KsAoGhz5X8yuZf3W+Ik4tRL7PgLlZT460rzKL8tMi08cWrzIvFjCAjufOPzuWHvNhSX+
         Yn3CsDMEjwKh0K/vJ3mKNyWKUvDqPOz22CnSKg/unKWhHhrgeXozpy5Xo6Qpmx+2AyiS
         k1zjTJ3Jc+G01tuS4SbqQ3dL5Bc/HLbFIS1Rpm4i/2b8vfLzDY/36I934na2ozsY0twt
         psxMMdvjJr2G2bK3f6KVTBFOD71L97qaZY6m8Bm8M/IF0awhc4/l4obA7o9WVL8wb9xZ
         CHgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765313571; x=1765918371;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9TQM9hbEKY4h1TXZBEY6y+aDCak1RQ1iwoKxBpJfd80=;
        b=G27i522nkyxaxAcSV5pOjYvHkSmnImDciyc9i4GSqx9SLTK/BqcDt9ysJtR5vhpXss
         zvC7V0cPA7vWXYnGPgoqUrlHAM9kaS00fi4tkWTrA4Sx/1qesacR8M79q3J7iIomiuu4
         HcDuTYBVzow0bep8SPP7Cepx8STCUBOxcgvp8b9DMtleWzIM/I945bAmN4eGDvYi2C5O
         kk1Fk/UFE1xQaASmUmy1zJFZmHnx0j+YdLgysmloapIRe6fi0xu/YT6WH4e2CYEq+WCq
         4NZCk3pjkAUgmEvKR0NPF1e6sluP7Z0Likd4JkQbbCvmlx+rB2sdfdqDGeIVqTFvNF9H
         aDnw==
X-Forwarded-Encrypted: i=1; AJvYcCVEOrzWS924lBZL0PIaXKuBQ/YV9bW/CgVIJ+DHV+9SojZKJLdY6BsgWxNc6AwKAq7h4zCcC5U=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy3ctlmAmEbBLsfHckYuv5aqj6llkw4h3fJt7dlOboVuNmeutEe
	sZ+iby6g8N4pSfeLACCyl+2Q0tlmJSRZEiFGSXaAXHJfwPweJw00f65D8f6RRppWAOkWiqVo78o
	QgdVwWjCVvoCKaKF8H+y1XLwOsA==
X-Google-Smtp-Source: AGHT+IHWcIE4lg0T6ePDVQb/sbhJCa/b57rBLjAAg31xKxOUUm8LB/AXhfBedLziDTfhcJmhpwXWgmPZUFcO0YaxEw==
X-Received: from oifn25-n1.prod.google.com ([2002:a05:6808:8859:10b0:450:63b:b0dd])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1441:b0:44f:6a32:5364 with SMTP id 5614622812f47-455865ceac4mr180351b6e.24.1765313570670;
 Tue, 09 Dec 2025 12:52:50 -0800 (PST)
Date: Tue,  9 Dec 2025 20:51:21 +0000
In-Reply-To: <20251209205121.1871534-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251209205121.1871534-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251209205121.1871534-25-coltonlewis@google.com>
Subject: [PATCH v5 24/24] KVM: arm64: selftests: Add test case for partitioned PMU
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Mark Rutland <mark.rutland@arm.com>, Shuah Khan <shuah@kernel.org>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Rerun all tests for a partitioned PMU in vpmu_counter_access.

Create an enum specifying whether we are testing the emulated or
partitioned PMU and all the test functions are modified to take the
implementation as an argument and make the difference in setup
appropriately.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 tools/include/uapi/linux/kvm.h                |  1 +
 .../selftests/kvm/arm64/vpmu_counter_access.c | 77 ++++++++++++++-----
 2 files changed, 57 insertions(+), 21 deletions(-)

diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index 52f6000ab0208..2bb2f234df0e6 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -963,6 +963,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_RISCV_MP_STATE_RESET 242
 #define KVM_CAP_ARM_CACHEABLE_PFNMAP_SUPPORTED 243
 #define KVM_CAP_GUEST_MEMFD_FLAGS 244
+#define KVM_CAP_ARM_PARTITION_PMU 245
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
diff --git a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
index ae36325c022fb..e68072e3e1326 100644
--- a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
+++ b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
@@ -25,9 +25,20 @@
 /* The cycle counter bit position that's common among the PMU registers */
 #define ARMV8_PMU_CYCLE_IDX		31
 
+enum pmu_impl {
+	EMULATED,
+	PARTITIONED
+};
+
+const char *pmu_impl_str[] = {
+	"Emulated",
+	"Partitioned"
+};
+
 struct vpmu_vm {
 	struct kvm_vm *vm;
 	struct kvm_vcpu *vcpu;
+	bool pmu_partitioned;
 };
 
 static struct vpmu_vm vpmu_vm;
@@ -399,7 +410,7 @@ static void guest_code(uint64_t expected_pmcr_n)
 }
 
 /* Create a VM that has one vCPU with PMUv3 configured. */
-static void create_vpmu_vm(void *guest_code)
+static void create_vpmu_vm(void *guest_code, enum pmu_impl impl)
 {
 	struct kvm_vcpu_init init;
 	uint8_t pmuver, ec;
@@ -409,6 +420,11 @@ static void create_vpmu_vm(void *guest_code)
 		.attr = KVM_ARM_VCPU_PMU_V3_IRQ,
 		.addr = (uint64_t)&irq,
 	};
+	bool partition = (impl == PARTITIONED);
+	struct kvm_enable_cap partition_cap = {
+		.cap = KVM_CAP_ARM_PARTITION_PMU,
+		.args[0] = partition,
+	};
 
 	/* The test creates the vpmu_vm multiple times. Ensure a clean state */
 	memset(&vpmu_vm, 0, sizeof(vpmu_vm));
@@ -420,6 +436,12 @@ static void create_vpmu_vm(void *guest_code)
 					guest_sync_handler);
 	}
 
+	if (kvm_has_cap(KVM_CAP_ARM_PARTITION_PMU)) {
+		vm_ioctl(vpmu_vm.vm, KVM_ENABLE_CAP, &partition_cap);
+		vpmu_vm.pmu_partitioned = partition;
+		pr_debug("Set PMU partitioning: %d\n", partition);
+	}
+
 	/* Create vCPU with PMUv3 */
 	kvm_get_default_vcpu_target(vpmu_vm.vm, &init);
 	init.features[0] |= (1 << KVM_ARM_VCPU_PMU_V3);
@@ -461,13 +483,14 @@ static void run_vcpu(struct kvm_vcpu *vcpu, uint64_t pmcr_n)
 	}
 }
 
-static void test_create_vpmu_vm_with_nr_counters(unsigned int nr_counters, bool expect_fail)
+static void test_create_vpmu_vm_with_nr_counters(
+	unsigned int nr_counters, enum pmu_impl impl, bool expect_fail)
 {
 	struct kvm_vcpu *vcpu;
 	unsigned int prev;
 	int ret;
 
-	create_vpmu_vm(guest_code);
+	create_vpmu_vm(guest_code, impl);
 	vcpu = vpmu_vm.vcpu;
 
 	prev = get_pmcr_n(vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0)));
@@ -489,7 +512,7 @@ static void test_create_vpmu_vm_with_nr_counters(unsigned int nr_counters, bool
  * Create a guest with one vCPU, set the PMCR_EL0.N for the vCPU to @pmcr_n,
  * and run the test.
  */
-static void run_access_test(uint64_t pmcr_n)
+static void run_access_test(uint64_t pmcr_n, enum pmu_impl impl)
 {
 	uint64_t sp;
 	struct kvm_vcpu *vcpu;
@@ -497,7 +520,7 @@ static void run_access_test(uint64_t pmcr_n)
 
 	pr_debug("Test with pmcr_n %lu\n", pmcr_n);
 
-	test_create_vpmu_vm_with_nr_counters(pmcr_n, false);
+	test_create_vpmu_vm_with_nr_counters(pmcr_n, impl, false);
 	vcpu = vpmu_vm.vcpu;
 
 	/* Save the initial sp to restore them later to run the guest again */
@@ -531,14 +554,14 @@ static struct pmreg_sets validity_check_reg_sets[] = {
  * Create a VM, and check if KVM handles the userspace accesses of
  * the PMU register sets in @validity_check_reg_sets[] correctly.
  */
-static void run_pmregs_validity_test(uint64_t pmcr_n)
+static void run_pmregs_validity_test(uint64_t pmcr_n, enum pmu_impl impl)
 {
 	int i;
 	struct kvm_vcpu *vcpu;
 	uint64_t set_reg_id, clr_reg_id, reg_val;
 	uint64_t valid_counters_mask, max_counters_mask;
 
-	test_create_vpmu_vm_with_nr_counters(pmcr_n, false);
+	test_create_vpmu_vm_with_nr_counters(pmcr_n, impl, false);
 	vcpu = vpmu_vm.vcpu;
 
 	valid_counters_mask = get_counters_mask(pmcr_n);
@@ -588,11 +611,11 @@ static void run_pmregs_validity_test(uint64_t pmcr_n)
  * the vCPU to @pmcr_n, which is larger than the host value.
  * The attempt should fail as @pmcr_n is too big to set for the vCPU.
  */
-static void run_error_test(uint64_t pmcr_n)
+static void run_error_test(uint64_t pmcr_n, enum pmu_impl impl)
 {
-	pr_debug("Error test with pmcr_n %lu (larger than the host)\n", pmcr_n);
+	pr_debug("Error test with pmcr_n %lu (larger than the host allows)\n", pmcr_n);
 
-	test_create_vpmu_vm_with_nr_counters(pmcr_n, true);
+	test_create_vpmu_vm_with_nr_counters(pmcr_n, impl, true);
 	destroy_vpmu_vm();
 }
 
@@ -600,11 +623,11 @@ static void run_error_test(uint64_t pmcr_n)
  * Return the default number of implemented PMU event counters excluding
  * the cycle counter (i.e. PMCR_EL0.N value) for the guest.
  */
-static uint64_t get_pmcr_n_limit(void)
+static uint64_t get_pmcr_n_limit(enum pmu_impl impl)
 {
 	uint64_t pmcr;
 
-	create_vpmu_vm(guest_code);
+	create_vpmu_vm(guest_code, impl);
 	pmcr = vcpu_get_reg(vpmu_vm.vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0));
 	destroy_vpmu_vm();
 	return get_pmcr_n(pmcr);
@@ -614,7 +637,7 @@ static bool kvm_supports_nr_counters_attr(void)
 {
 	bool supported;
 
-	create_vpmu_vm(NULL);
+	create_vpmu_vm(NULL, EMULATED);
 	supported = !__vcpu_has_device_attr(vpmu_vm.vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
 					    KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS);
 	destroy_vpmu_vm();
@@ -622,22 +645,34 @@ static bool kvm_supports_nr_counters_attr(void)
 	return supported;
 }
 
-int main(void)
+void test_pmu(enum pmu_impl impl)
 {
 	uint64_t i, pmcr_n;
 
-	TEST_REQUIRE(kvm_has_cap(KVM_CAP_ARM_PMU_V3));
-	TEST_REQUIRE(kvm_supports_vgic_v3());
-	TEST_REQUIRE(kvm_supports_nr_counters_attr());
+	pr_info("Testing PMU: Implementation = %s\n", pmu_impl_str[impl]);
+
+	pmcr_n = get_pmcr_n_limit(impl);
+	pr_debug("PMCR_EL0.N: Limit = %lu\n", pmcr_n);
 
-	pmcr_n = get_pmcr_n_limit();
 	for (i = 0; i <= pmcr_n; i++) {
-		run_access_test(i);
-		run_pmregs_validity_test(i);
+		run_access_test(i, impl);
+		run_pmregs_validity_test(i, impl);
 	}
 
 	for (i = pmcr_n + 1; i < ARMV8_PMU_MAX_COUNTERS; i++)
-		run_error_test(i);
+		run_error_test(i, impl);
+}
+
+int main(void)
+{
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_ARM_PMU_V3));
+	TEST_REQUIRE(kvm_supports_vgic_v3());
+	TEST_REQUIRE(kvm_supports_nr_counters_attr());
+
+	test_pmu(EMULATED);
+
+	if (kvm_has_cap(KVM_CAP_ARM_PARTITION_PMU))
+		test_pmu(PARTITIONED);
 
 	return 0;
 }
-- 
2.52.0.239.gd5f0c6e74e-goog

