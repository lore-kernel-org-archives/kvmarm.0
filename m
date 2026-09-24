Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C054C7558
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 17:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790271011; cv=none; b=IKbGYRKrC4EdmRbzPkcZ8JQWT2JMIcE9d/RriGOhwIH64C6z8pkEnJLEM5hNRNOqprrQpScucjXZXcq5eND26xK7rqpciyvuJv/7Sm80mRWpn2EJwYgUj37HhG6i5tRDABN9R3Fzgz66O3cCIy07pq0VwLbuCF53sm8IAVe+/hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790271011; c=relaxed/simple;
	bh=KLtC1oI3NzGrURS0nY2zD3hDSDHmbXuCtQI4kY4XTQI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Yq/QjCQ43G5Y5Uzx3B9ipOn7SPh1Kj0gwOt7mFQgWCHnewSdpuZZYjPqtX1eI+QduzFwAaQVsyghQ0oFuylOTH6smsgajHFlk9RKMH915BNIE87yr4+p/yq72C15Pnq+Ossp1LJUPTycnUPGvJMjJTZEp/doG9YeuzZnklT14KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hoJ7eq/h; arc=none smtp.client-ip=209.85.210.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hoJ7eq/h"
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-81482599b3cso22876a34.2
        for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 10:30:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790271003; x=1790875803; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rWHVRrGfPke0mqexZS51GQxGuegr0moQYbkFD6OXnu0=;
        b=hoJ7eq/hE3R9H/elHd7hecw0wuMLMarmpnj1bVmNIEtpQmFMpqSbW+C3sgJgNv33+N
         cWCmbYYhc9c4B6u0/o/iZnQ8qTkB7DWU42NidekOMJwT1fTx9p6/PFp5BmpIsatbSvnZ
         oz3ft8fwrJCeQbJzcjE8CAbq0WPJtzWKQEak3kUXhJl0ZpwlMxoslJpMW2hqWljtQ+rL
         6F91tst+1uOxbIHbTKjJrXl6QjXzOqnI9DUwBuC9voSuilPTPhnxHwS0PXz30SWDLsys
         eqX7kctDDZBx8wJ8pk2ca4kg76wsqb0c/snqBL4FXvKJkyc4HMoAHtHeycDPErNPATUK
         kiOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790271003; x=1790875803;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rWHVRrGfPke0mqexZS51GQxGuegr0moQYbkFD6OXnu0=;
        b=Ow8R+C9ljdPH0TqKznZdZdjEQ1jXoAaFIjFSBC3y5/nO3yLBhe3Dd1Rsui5gisAH2w
         iAkODrG48f52waR2IuAdpBlcRBzoHl2XCeW+tKXnqElRU5PGPTZHBu/OEtE+attCEcLv
         PWXrZSmjOoDCLoy4WXtF1aETw6LMXp8pXaGbsF+euFrx2Xm9aUK/fwkPByPvECA+ucyR
         8/wVyADqInabdL0lPHQL/I6I0vzQ5QKC24pW/Vrdv7u0z4FyFeHN4dXHE+Vo6ugfaIKG
         c0JDctLR85uU0YtX0S2+ACnctpcvXd3FboPZ8GaebtBqGdTrT9YzAxy3Iz71zESIZnUx
         /qTw==
X-Forwarded-Encrypted: i=1; AKwUvBx4TqzuFzR04GeefpIZc/m5k8DK/uP+DVFyLEACreX4h2iM3X2fOlUbecOFHbDAMtRPZhK048Y=@lists.linux.dev
X-Gm-Message-State: AFuF++mGe0AM65mEGgcXGJq39d/6zgQyIDz3NtSpXXx/tU/ESeAjLcuz
	q8qjEcjMJXorChqUVusIwsRM5JvQVBr6KLEgerluo7woPrsI/xwKZvoEyDgfsYeB99Dg6W7kM+s
	U5Yl8LXQBLKQtVkgvQE0OCkImmw==
X-Received: from jaj22.prod.google.com ([2002:a05:6638:b116:b0:5f1:46fc:47de])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:448f:b0:4b9:a8ac:479 with SMTP id 5614622812f47-4d72c73e50cmr3041718b6e.23.1790271002398;
 Thu, 24 Sep 2026 10:30:02 -0700 (PDT)
Date: Thu, 24 Sep 2026 17:29:28 +0000
In-Reply-To: <20260924172928.2110956-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260924172928.2110956-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260924172928.2110956-23-coltonlewis@google.com>
Subject: [PATCH v9 22/22] KVM: arm64: selftests: Add test case for Partitioned PMU
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	James Clark <james.clark@linaro.org>, Robin Murphy <robin.murphy@arm.com>, 
	Zide Chen <zide.chen@intel.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Mingwei Zhang <mizhang@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, Shuah Khan <shuah@kernel.org>, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Extend arm64/vpmu_counter_access to run all PMU counter access,
PMCR.N validation, and overflow interrupt tests against both the
emulated vPMU and the Partitioned PMU.

Introduce enum vpmu_impl (EMULATED_VPMU vs. PARTITIONED_VPMU) and thread
it through the test setup helpers to configure
KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION and
KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS when testing the Partitioned PMU.

Skip out-of-bounds counter access exception tests when the PMU is
partitioned, as hardware does not guarantee an UNDEFINED exception on
accesses to unimplemented counters.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 .../selftests/kvm/arm64/vpmu_counter_access.c | 129 ++++++++++++++----
 1 file changed, 99 insertions(+), 30 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
index 22223395969e0..811f8156cea3c 100644
--- a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
+++ b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
@@ -25,12 +25,27 @@
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
 };
 
+struct guest_context {
+	bool pmu_partitioned;
+};
+
 static struct vpmu_vm vpmu_vm;
+static struct guest_context guest_context;
 
 struct pmreg_sets {
 	u64 set_reg_id;
@@ -331,11 +346,16 @@ static void test_access_invalid_pmc_regs(struct pmc_accessor *acc, int pmc_idx)
 	/*
 	 * Reading/writing the event count/type registers should cause
 	 * an UNDEFINED exception.
+	 *
+	 * If the pmu is partitioned, we can't guarantee it because
+	 * hardware doesn't.
 	 */
-	TEST_EXCEPTION(ESR_ELx_EC_UNKNOWN, acc->read_cntr(pmc_idx));
-	TEST_EXCEPTION(ESR_ELx_EC_UNKNOWN, acc->write_cntr(pmc_idx, 0));
-	TEST_EXCEPTION(ESR_ELx_EC_UNKNOWN, acc->read_typer(pmc_idx));
-	TEST_EXCEPTION(ESR_ELx_EC_UNKNOWN, acc->write_typer(pmc_idx, 0));
+	if (!guest_context.pmu_partitioned) {
+		TEST_EXCEPTION(ESR_ELx_EC_UNKNOWN, acc->read_cntr(pmc_idx));
+		TEST_EXCEPTION(ESR_ELx_EC_UNKNOWN, acc->write_cntr(pmc_idx, 0));
+		TEST_EXCEPTION(ESR_ELx_EC_UNKNOWN, acc->read_typer(pmc_idx));
+		TEST_EXCEPTION(ESR_ELx_EC_UNKNOWN, acc->write_typer(pmc_idx, 0));
+	}
 	/*
 	 * The bit corresponding to the (unimplemented) counter in
 	 * {PMCNTEN,PMINTEN,PMOVS}{SET,CLR} registers should be RAZ.
@@ -399,7 +419,7 @@ static void guest_code(u64 expected_pmcr_n)
 }
 
 /* Create a VM that has one vCPU with PMUv3 configured. */
-static void create_vpmu_vm(void *guest_code)
+static void create_vpmu_vm(void *guest_code, enum pmu_impl impl)
 {
 	struct kvm_vcpu_init init;
 	u8 pmuver, ec;
@@ -409,6 +429,13 @@ static void create_vpmu_vm(void *guest_code)
 		.attr = KVM_ARM_VCPU_PMU_V3_IRQ,
 		.addr = (u64)&irq,
 	};
+	u32 partition = (impl == PARTITIONED);
+	struct kvm_device_attr part_attr = {
+		.group = KVM_ARM_VCPU_PMU_V3_CTRL,
+		.attr = KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION,
+		.addr = (uint64_t)&partition
+	};
+	int ret;
 
 	/* The test creates the vpmu_vm multiple times. Ensure a clean state */
 	memset(&vpmu_vm, 0, sizeof(vpmu_vm));
@@ -436,6 +463,15 @@ static void create_vpmu_vm(void *guest_code)
 		    "Unexpected PMUVER (0x%x) on the vCPU with PMUv3", pmuver);
 
 	vcpu_ioctl(vpmu_vm.vcpu, KVM_SET_DEVICE_ATTR, &irq_attr);
+
+	ret = __vcpu_has_device_attr(
+		vpmu_vm.vcpu, KVM_ARM_VCPU_PMU_V3_CTRL, KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION);
+	if (!ret) {
+		vcpu_ioctl(vpmu_vm.vcpu, KVM_SET_DEVICE_ATTR, &part_attr);
+		guest_context.pmu_partitioned = partition;
+		pr_debug("Set PMU partitioning: %d\n", partition);
+	}
+
 }
 
 static void destroy_vpmu_vm(void)
@@ -461,13 +497,14 @@ static void run_vcpu(struct kvm_vcpu *vcpu, u64 pmcr_n)
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
@@ -475,21 +512,24 @@ static void test_create_vpmu_vm_with_nr_counters(unsigned int nr_counters, bool
 	ret = __vcpu_device_attr_set(vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
 				     KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS, &nr_counters);
 
-	if (expect_fail)
+	if (expect_fail) {
 		TEST_ASSERT(ret && errno == EINVAL,
 			    "Setting more PMU counters (%u) than available (%u) unexpectedly succeeded",
 			    nr_counters, prev);
-	else
-		TEST_ASSERT(!ret, KVM_IOCTL_ERROR(KVM_SET_DEVICE_ATTR, ret));
+		return;
+	}
+
+	TEST_ASSERT(!ret, KVM_IOCTL_ERROR(KVM_SET_DEVICE_ATTR, ret));
 
 	vcpu_device_attr_set(vcpu, KVM_ARM_VCPU_PMU_V3_CTRL, KVM_ARM_VCPU_PMU_V3_INIT, NULL);
+	sync_global_to_guest(vpmu_vm.vm, guest_context);
 }
 
 /*
  * Create a guest with one vCPU, set the PMCR_EL0.N for the vCPU to @pmcr_n,
  * and run the test.
  */
-static void run_access_test(u64 pmcr_n)
+static void run_access_test(u64 pmcr_n, enum pmu_impl impl)
 {
 	u64 sp;
 	struct kvm_vcpu *vcpu;
@@ -497,7 +537,7 @@ static void run_access_test(u64 pmcr_n)
 
 	pr_debug("Test with pmcr_n %lu\n", pmcr_n);
 
-	test_create_vpmu_vm_with_nr_counters(pmcr_n, false);
+	test_create_vpmu_vm_with_nr_counters(pmcr_n, impl, false);
 	vcpu = vpmu_vm.vcpu;
 
 	/* Save the initial sp to restore them later to run the guest again */
@@ -531,14 +571,14 @@ static struct pmreg_sets validity_check_reg_sets[] = {
  * Create a VM, and check if KVM handles the userspace accesses of
  * the PMU register sets in @validity_check_reg_sets[] correctly.
  */
-static void run_pmregs_validity_test(u64 pmcr_n)
+static void run_pmregs_validity_test(u64 pmcr_n, enum pmu_impl impl)
 {
 	int i;
 	struct kvm_vcpu *vcpu;
 	u64 set_reg_id, clr_reg_id, reg_val;
 	u64 valid_counters_mask, max_counters_mask;
 
-	test_create_vpmu_vm_with_nr_counters(pmcr_n, false);
+	test_create_vpmu_vm_with_nr_counters(pmcr_n, impl, false);
 	vcpu = vpmu_vm.vcpu;
 
 	valid_counters_mask = get_counters_mask(pmcr_n);
@@ -588,11 +628,11 @@ static void run_pmregs_validity_test(u64 pmcr_n)
  * the vCPU to @pmcr_n, which is larger than the host value.
  * The attempt should fail as @pmcr_n is too big to set for the vCPU.
  */
-static void run_error_test(u64 pmcr_n)
+static void run_error_test(u64 pmcr_n, enum pmu_impl impl)
 {
-	pr_debug("Error test with pmcr_n %lu (larger than the host)\n", pmcr_n);
+	pr_debug("Error test with pmcr_n %lu (larger than the host allows)\n", pmcr_n);
 
-	test_create_vpmu_vm_with_nr_counters(pmcr_n, true);
+	test_create_vpmu_vm_with_nr_counters(pmcr_n, impl, true);
 	destroy_vpmu_vm();
 }
 
@@ -600,21 +640,26 @@ static void run_error_test(u64 pmcr_n)
  * Return the default number of implemented PMU event counters excluding
  * the cycle counter (i.e. PMCR_EL0.N value) for the guest.
  */
-static u64 get_pmcr_n_limit(void)
+static u64 get_pmcr_n_limit(enum pmu_impl impl)
 {
-	u64 pmcr;
+	u64 pmcr, n;
 
-	create_vpmu_vm(guest_code);
+	create_vpmu_vm(guest_code, impl);
 	pmcr = vcpu_get_reg(vpmu_vm.vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0));
 	destroy_vpmu_vm();
-	return get_pmcr_n(pmcr);
+
+	n = get_pmcr_n(pmcr);
+	if (impl == PARTITIONED && n > 0)
+		return n - 1;
+
+	return n;
 }
 
 static bool kvm_supports_nr_counters_attr(void)
 {
 	bool supported;
 
-	create_vpmu_vm(NULL);
+	create_vpmu_vm(NULL, EMULATED);
 	supported = !__vcpu_has_device_attr(vpmu_vm.vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
 					    KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS);
 	destroy_vpmu_vm();
@@ -622,22 +667,46 @@ static bool kvm_supports_nr_counters_attr(void)
 	return supported;
 }
 
-int main(void)
+static bool kvm_supports_partition_attr(void)
+{
+	bool supported;
+
+	create_vpmu_vm(NULL, EMULATED);
+	supported = !__vcpu_has_device_attr(vpmu_vm.vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
+					    KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION);
+	destroy_vpmu_vm();
+
+	return supported;
+}
+
+void test_pmu(enum pmu_impl impl)
 {
 	u64 i, pmcr_n;
 
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
+	if (kvm_supports_partition_attr() && get_pmcr_n_limit(EMULATED) > 0)
+		test_pmu(PARTITIONED);
 
 	return 0;
 }
-- 
2.56.0.rc1.310.g51773c2048-goog

