Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6783ADB92
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 10:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783332262; cv=none; b=scJCzrNTbJP1EgCH82LeYQ7MkDlVAcCV9YOhvrqQzl9GKdsjMUyJrwy9+hUqEQHQw1p5d7tekt93732AqdqYwm7xp6XCp3VeHnA6hv/k6R4y/oswNMWewMMwa5gWEv9ucwJ6ixe8YNO8apGGY+4USM4s8XsqN5yHH4AyRGCpDhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783332262; c=relaxed/simple;
	bh=wgOvy5ria+dscgHM6rKV0CfDACxNL9lksXqPz2aE+v8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=b8PqOQVp8wb0dbG8pquPI+Fb6HPYiqEeXL1HN7yAR+O8QAFLNQ1LUxmgqUyWbtE4Zm5RelvaU6KAVA0oTilze6RGIWBXuD2bNsASQ5+hYr9MlE957udCe5UvsYKfilkzi6y5qyqcGXLWQPTiuOGQuFhCOPVXyCcNjyRSYK5GBu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=FOqTvUIS reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="FOqTvUIS"
Received: from h183.csg.ci.i.u-tokyo.ac.jp (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 666A3TQA013128
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 6 Jul 2026 19:03:45 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=3WO+OdeQTjRWyRYxsGSWAfYQ2+Ma9SPAXZJGrHnRJ30=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-Id:To:Subject:Date;
        s=rs20250326; t=1783332225; v=1;
        b=FOqTvUISYr1lsOL2cDSTD54+Q1EpF6bKxR7bkZ7fUXeZaDty97toz579aXYj+cl/
         L2vFR/bLbCh3M0TtbGXLSjWVMFacSdJnTfl2zrFKt5bViBM6omG3vuot2iAh2O+f
         pcn1lmeg6AEJdX+AceM6OHDoAdEv4ljwKemEHxnbq42qFEjoODosYWnmk65MK1EY
         wql06b/anPX+k41K/+eOYxQdRWCIkz9g69esGTCexDlSM5o/r3IhtIrD/99Jts/P
         0RGqRBu2qM1JqXDN6xXzBdBO35FTC52KebD1JdYck2LdMcj58eMm2jApTfzNCnas
         fKTIO3McUvMV7WKBnIN0Pg==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Mon, 06 Jul 2026 19:03:30 +0900
Subject: [PATCH v8 7/7] KVM: arm64: selftests: Test
 PMU_V3_FIXED_COUNTERS_ONLY
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260706-hybrid-v8-7-de459617b59d@rsg.ci.i.u-tokyo.ac.jp>
References: <20260706-hybrid-v8-0-de459617b59d@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260706-hybrid-v8-0-de459617b59d@rsg.ci.i.u-tokyo.ac.jp>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
        Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
X-Mailer: b4 0.16-dev-925f5

Assert the following:
- FIXED_COUNTERS_ONLY is unset at initialization.
- FIXED_COUNTERS_ONLY can be set.
- Setting an event filter when FIXED_COUNTERS_ONLY has already been set
  results in EBUSY.
- Setting FIXED_COUNTERS_ONLY when an event filter has already been set
  results in EBUSY.
- Setting FIXED_COUNTERS_ONLY when a VCPU has already run results in
  EBUSY.

Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
---
 .../selftests/kvm/arm64/vpmu_counter_access.c      | 152 +++++++++++++++++----
 1 file changed, 126 insertions(+), 26 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
index 22223395969e..eb8352a6e2f6 100644
--- a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
+++ b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
@@ -403,12 +403,7 @@ static void create_vpmu_vm(void *guest_code)
 {
 	struct kvm_vcpu_init init;
 	u8 pmuver, ec;
-	u64 dfr0, irq = 23;
-	struct kvm_device_attr irq_attr = {
-		.group = KVM_ARM_VCPU_PMU_V3_CTRL,
-		.attr = KVM_ARM_VCPU_PMU_V3_IRQ,
-		.addr = (u64)&irq,
-	};
+	u64 dfr0;
 
 	/* The test creates the vpmu_vm multiple times. Ensure a clean state */
 	memset(&vpmu_vm, 0, sizeof(vpmu_vm));
@@ -434,8 +429,6 @@ static void create_vpmu_vm(void *guest_code)
 	TEST_ASSERT(pmuver != ID_AA64DFR0_EL1_PMUVer_IMP_DEF &&
 		    pmuver >= ID_AA64DFR0_EL1_PMUVer_IMP,
 		    "Unexpected PMUVER (0x%x) on the vCPU with PMUv3", pmuver);
-
-	vcpu_ioctl(vpmu_vm.vcpu, KVM_SET_DEVICE_ATTR, &irq_attr);
 }
 
 static void destroy_vpmu_vm(void)
@@ -461,15 +454,30 @@ static void run_vcpu(struct kvm_vcpu *vcpu, u64 pmcr_n)
 	}
 }
 
-static void test_create_vpmu_vm_with_nr_counters(unsigned int nr_counters, bool expect_fail)
+static void guest_code_done(void)
+{
+	GUEST_DONE();
+}
+
+static void test_create_vpmu_vm_with_nr_counters(unsigned int nr_counters,
+						 bool fixed_counters_only,
+						 bool expect_fail)
 {
 	struct kvm_vcpu *vcpu;
 	unsigned int prev;
 	int ret;
+	u64 irq = 23;
 
 	create_vpmu_vm(guest_code);
 	vcpu = vpmu_vm.vcpu;
 
+	if (fixed_counters_only)
+		vcpu_device_attr_set(vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
+				     KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY, NULL);
+
+	vcpu_device_attr_set(vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
+			     KVM_ARM_VCPU_PMU_V3_IRQ, &irq);
+
 	prev = get_pmcr_n(vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0)));
 
 	ret = __vcpu_device_attr_set(vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
@@ -489,15 +497,15 @@ static void test_create_vpmu_vm_with_nr_counters(unsigned int nr_counters, bool
  * Create a guest with one vCPU, set the PMCR_EL0.N for the vCPU to @pmcr_n,
  * and run the test.
  */
-static void run_access_test(u64 pmcr_n)
+static void run_access_test(u64 pmcr_n, bool fixed_counters_only)
 {
 	u64 sp;
 	struct kvm_vcpu *vcpu;
 	struct kvm_vcpu_init init;
 
-	pr_debug("Test with pmcr_n %lu\n", pmcr_n);
+	pr_debug("Test with pmcr_n %lu, fixed_counters_only %d\n", pmcr_n, fixed_counters_only);
 
-	test_create_vpmu_vm_with_nr_counters(pmcr_n, false);
+	test_create_vpmu_vm_with_nr_counters(pmcr_n, fixed_counters_only, false);
 	vcpu = vpmu_vm.vcpu;
 
 	/* Save the initial sp to restore them later to run the guest again */
@@ -531,14 +539,14 @@ static struct pmreg_sets validity_check_reg_sets[] = {
  * Create a VM, and check if KVM handles the userspace accesses of
  * the PMU register sets in @validity_check_reg_sets[] correctly.
  */
-static void run_pmregs_validity_test(u64 pmcr_n)
+static void run_pmregs_validity_test(u64 pmcr_n, bool fixed_counters_only)
 {
 	int i;
 	struct kvm_vcpu *vcpu;
 	u64 set_reg_id, clr_reg_id, reg_val;
 	u64 valid_counters_mask, max_counters_mask;
 
-	test_create_vpmu_vm_with_nr_counters(pmcr_n, false);
+	test_create_vpmu_vm_with_nr_counters(pmcr_n, fixed_counters_only, false);
 	vcpu = vpmu_vm.vcpu;
 
 	valid_counters_mask = get_counters_mask(pmcr_n);
@@ -588,11 +596,11 @@ static void run_pmregs_validity_test(u64 pmcr_n)
  * the vCPU to @pmcr_n, which is larger than the host value.
  * The attempt should fail as @pmcr_n is too big to set for the vCPU.
  */
-static void run_error_test(u64 pmcr_n)
+static void run_error_test(u64 pmcr_n, bool fixed_counters_only)
 {
 	pr_debug("Error test with pmcr_n %lu (larger than the host)\n", pmcr_n);
 
-	test_create_vpmu_vm_with_nr_counters(pmcr_n, true);
+	test_create_vpmu_vm_with_nr_counters(pmcr_n, fixed_counters_only, true);
 	destroy_vpmu_vm();
 }
 
@@ -622,22 +630,114 @@ static bool kvm_supports_nr_counters_attr(void)
 	return supported;
 }
 
-int main(void)
+static void test_config(u64 pmcr_n, bool fixed_counters_only)
 {
-	u64 i, pmcr_n;
-
-	TEST_REQUIRE(kvm_has_cap(KVM_CAP_ARM_PMU_V3));
-	TEST_REQUIRE(kvm_supports_vgic_v3());
-	TEST_REQUIRE(kvm_supports_nr_counters_attr());
+	u64 i;
 
-	pmcr_n = get_pmcr_n_limit();
 	for (i = 0; i <= pmcr_n; i++) {
-		run_access_test(i);
-		run_pmregs_validity_test(i);
+		run_access_test(i, fixed_counters_only);
+		run_pmregs_validity_test(i, fixed_counters_only);
 	}
 
 	for (i = pmcr_n + 1; i < ARMV8_PMU_MAX_COUNTERS; i++)
-		run_error_test(i);
+		run_error_test(i, fixed_counters_only);
+}
+
+static void test_fixed_counters_only(void)
+{
+	struct kvm_pmu_event_filter filter = { .nevents = 0 };
+	struct kvm_vm *vm;
+	struct kvm_vcpu *running_vcpu;
+	struct kvm_vcpu *stopped_vcpu;
+	struct kvm_vcpu_init init;
+	int ret;
+	u64 irq = 23;
+
+	create_vpmu_vm(guest_code);
+	ret = __vcpu_has_device_attr(vpmu_vm.vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
+				     KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY);
+	if (ret) {
+		TEST_ASSERT(ret == -1 && errno == ENXIO,
+			    KVM_IOCTL_ERROR(KVM_HAS_DEVICE_ATTR, ret));
+		destroy_vpmu_vm();
+		return;
+	}
+
+	/* Assert that FIXED_COUNTERS_ONLY is unset at initialization. */
+	ret = __vcpu_device_attr_get(vpmu_vm.vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
+				     KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY, NULL);
+	TEST_ASSERT(ret == -1 && errno == ENXIO,
+		    KVM_IOCTL_ERROR(KVM_GET_DEVICE_ATTR, ret));
+
+	/* Assert that setting FIXED_COUNTERS_ONLY succeeds. */
+	vcpu_device_attr_set(vpmu_vm.vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
+			     KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY, NULL);
+
+	/* Assert that FIXED_COUNTERS_ONLY is set. */
+	vcpu_device_attr_get(vpmu_vm.vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
+			     KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY, NULL);
+
+	/*
+	 * Setting an event filter when FIXED_COUNTERS_ONLY has already been set
+	 * results in EBUSY.
+	 */
+	ret = __vcpu_device_attr_set(vpmu_vm.vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
+				     KVM_ARM_VCPU_PMU_V3_FILTER, &filter);
+	TEST_ASSERT(ret == -1 && errno == EBUSY,
+		    KVM_IOCTL_ERROR(KVM_SET_DEVICE_ATTR, ret));
+
+	destroy_vpmu_vm();
+
+	create_vpmu_vm(guest_code);
+
+	/*
+	 * Assert that setting FIXED_COUNTERS_ONLY when an event filter has
+	 * already been set results in EBUSY.
+	 */
+	vcpu_device_attr_set(vpmu_vm.vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
+			     KVM_ARM_VCPU_PMU_V3_FILTER, &filter);
+
+	ret = __vcpu_device_attr_set(vpmu_vm.vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
+				     KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY, NULL);
+	TEST_ASSERT(ret == -1 && errno == EBUSY,
+		    KVM_IOCTL_ERROR(KVM_SET_DEVICE_ATTR, ret));
+
+	destroy_vpmu_vm();
+
+	/*
+	 * Assert that setting FIXED_COUNTERS_ONLY when a VCPU has already run
+	 * results in EBUSY.
+	 */
+	vm = vm_create(2);
+	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
+	init.features[0] |= (1 << KVM_ARM_VCPU_PMU_V3);
+	running_vcpu = aarch64_vcpu_add(vm, 0, &init, guest_code_done);
+	stopped_vcpu = aarch64_vcpu_add(vm, 1, &init, guest_code_done);
+	kvm_arch_vm_finalize_vcpus(vm);
+	vcpu_device_attr_set(running_vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
+			     KVM_ARM_VCPU_PMU_V3_IRQ, &irq);
+	vcpu_device_attr_set(running_vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
+			     KVM_ARM_VCPU_PMU_V3_INIT, NULL);
+	vcpu_run(running_vcpu);
+
+	ret = __vcpu_device_attr_set(stopped_vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
+				     KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY, NULL);
+	TEST_ASSERT(ret == -1 && errno == EBUSY,
+		    KVM_IOCTL_ERROR(KVM_SET_DEVICE_ATTR, ret));
+
+	kvm_vm_free(vm);
+
+	test_config(0, true);
+}
+
+int main(void)
+{
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_ARM_PMU_V3));
+	TEST_REQUIRE(kvm_supports_vgic_v3());
+	TEST_REQUIRE(kvm_supports_nr_counters_attr());
+
+	test_config(get_pmcr_n_limit(), false);
+	test_fixed_counters_only();
 
 	return 0;
 }

-- 
2.55.0

