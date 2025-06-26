Received: from mail-il1-f202.google.com (mail-il1-f202.google.com [209.85.166.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 383B72FE36A
	for <kvmarm@lists.linux.dev>; Thu, 26 Jun 2025 20:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750968379; cv=none; b=oeBpgFoTKiJdflnQVSQUV3hKLEVNlSSuQ04u/PxZst1Rqn+oDo7cM+sPqi8z27tf40wDdn5EZphK+kixRWqaEWhsoUSaxNdqZtIJZJgMJeF0pSHJ+i3N8qyI/RjwYvlFDJ7nwmc847y9jcnXY9NQGJMCrSGbs7nBuzfuxFrMufE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750968379; c=relaxed/simple;
	bh=9eSwVawIpIf46LRehZWFLyWPO8/7v6TDvCTZI7UPgOU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=m7rm2sEjOTJn//2yKJ78bqK9SFFMSToLcTUb+i4wLweSEWUecl/in8TRva3LqrjiwOjHb2ymB2hXB76wRt+79j6UNJS16+blyZFYUxVpsLhwWwBabN4uIFUQjlhXLh8Nk2hiU6MMuI/kh7fbOmXtLZ2rvI2tsel8EubQ3oj157k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ehRkvihB; arc=none smtp.client-ip=209.85.166.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ehRkvihB"
Received: by mail-il1-f202.google.com with SMTP id e9e14a558f8ab-3ddc0a6d4bdso17350985ab.0
        for <kvmarm@lists.linux.dev>; Thu, 26 Jun 2025 13:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750968374; x=1751573174; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xdZdMkXachOTBLhsNs+TRwK+/iArlUH+VMAh4h7bRTc=;
        b=ehRkvihBjrX7/vlkRMzMiXCLoz9zdBHmVdpFgjWZm0InvooQiGxwd2jsEuE4fwmYwA
         aZSVbPjheoiZQwlEq3hZXQkw4bm06EIf5xAQQDZsddQdOSYmLhRDJ/cnfE8gAa9g3Odx
         BDAdGxrq8L2MO97V0K2wawIjI0q8Ygnn6JsQ4B7x9ewK1mHwrDe6/G/NP9R02hBS9eTz
         9rX+EHx93tk1/t0WxwDLCyty7J5UJ21pvOGtku7lSVkg7Cf/Y1Frfp5YgWcmQTXTaL55
         cLPJ2bjeLHJXhA/RzZ0bogZH05Srwz8QAWa+EjC4jMv46g2W6P8Mzy7+vpbgNrC3mg1r
         hmtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750968374; x=1751573174;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xdZdMkXachOTBLhsNs+TRwK+/iArlUH+VMAh4h7bRTc=;
        b=Pa78WmKbm86OHLQM0m5JHPfjMINtirjvdZ+fLohQRVaFYm6s1c3+CaSHuN+BJmlbuR
         7do76dKnqdxTTPs3Ofk74JM0ja4DCS8cjvp+oYQRG6yU/FxUCwasicM21DRuPMRwZnwf
         XPe2XoYrbQDYcy9YwEl11GBxMRvSgc52TnK6o2vkAGvnHEj6ueHJKldZU6zn4JjuICAP
         HdYyY3lJOWTx3QX1jwmLb4SE3/oin5XAEqn5vufYn+vftIAnu1fRcQo7euo6D/aN2oFl
         0NJONPH01CQW50iAIG9tqFs6GOsQjD33hr/QxuPn3w8i9TVQJNcmlVYHx+pJpVlczzdd
         i9nA==
X-Forwarded-Encrypted: i=1; AJvYcCUiinCyu8IStCDfK0C7dQW4S2RVKj2I9pnmIPRx4VDEuyzFsiH8YsNHbW9JKnZBOdVZ6YYoAtw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx/ZvtoOH8/YpB7iIc7cV4G6avBxpbNFbKGjmiCeeEWHNmNWoF4
	Qaw3jUAVVje8geyHRjzar1wp1fKhM4ZFB+5YAHOf/EOgogYAHfNokIcVPZx0aey+7QVe8obFskG
	+1zdR3dX03CCcJKWprwM9hqJIPA==
X-Google-Smtp-Source: AGHT+IGarWfmYd/DUQimhQezHE2YXV7tgZKjgPA1cETPrxi7OiBglxyD0Fcw3dSMp14kty4kT+yi3FezNyuiQsd4uQ==
X-Received: from ilbbs16.prod.google.com ([2002:a05:6e02:2410:b0:3df:30df:d2c4])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:1c23:b0:3dd:dd39:324c with SMTP id e9e14a558f8ab-3df4ab6d058mr11318515ab.9.1750968374502;
 Thu, 26 Jun 2025 13:06:14 -0700 (PDT)
Date: Thu, 26 Jun 2025 20:04:58 +0000
In-Reply-To: <20250626200459.1153955-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250626200459.1153955-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250626200459.1153955-23-coltonlewis@google.com>
Subject: [PATCH v3 22/22] KVM: arm64: selftests: Add test case for partitioned PMU
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Mark Rutland <mark.rutland@arm.com>, Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Run separate a test case for a partitioned PMU in vpmu_counter_access.

An enum is created specifying whether we are testing the emulated or
partitioned PMU and all the test functions are modified to take the
implementation as an argument and make the difference in setup
appropriately.

Because the test should still succeed even if we are on a machine
where we have the capability but the ioctl fails because the driver
was never configured properly, use __vcpu_ioctl to avoid checking the
return code.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 tools/include/uapi/linux/kvm.h                |  2 +
 .../selftests/kvm/arm64/vpmu_counter_access.c | 62 +++++++++++++------
 2 files changed, 46 insertions(+), 18 deletions(-)

diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index b6ae8ad8934b..21a2c37528c8 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -930,6 +930,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
 #define KVM_CAP_X86_GUEST_MODE 238
 #define KVM_CAP_ARM_WRITABLE_IMP_ID_REGS 239
+#define KVM_CAP_ARM_PARTITION_PMU 244
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
@@ -1356,6 +1357,7 @@ struct kvm_vfio_spapr_tce {
 #define KVM_S390_SET_CMMA_BITS      _IOW(KVMIO, 0xb9, struct kvm_s390_cmma_log)
 /* Memory Encryption Commands */
 #define KVM_MEMORY_ENCRYPT_OP      _IOWR(KVMIO, 0xba, unsigned long)
+#define KVM_ARM_PARTITION_PMU	_IOWR(KVMIO, 0xce, bool)
 
 struct kvm_enc_region {
 	__u64 addr;
diff --git a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
index f16b3b27e32e..92e665516bc8 100644
--- a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
+++ b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
@@ -25,6 +25,16 @@
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
@@ -405,7 +415,7 @@ static void guest_code(uint64_t expected_pmcr_n)
 }
 
 /* Create a VM that has one vCPU with PMUv3 configured. */
-static void create_vpmu_vm(void *guest_code)
+static void create_vpmu_vm(void *guest_code, enum pmu_impl impl)
 {
 	struct kvm_vcpu_init init;
 	uint8_t pmuver, ec;
@@ -419,6 +429,7 @@ static void create_vpmu_vm(void *guest_code)
 		.group = KVM_ARM_VCPU_PMU_V3_CTRL,
 		.attr = KVM_ARM_VCPU_PMU_V3_INIT,
 	};
+	bool partition = (impl == PARTITIONED);
 
 	/* The test creates the vpmu_vm multiple times. Ensure a clean state */
 	memset(&vpmu_vm, 0, sizeof(vpmu_vm));
@@ -449,6 +460,9 @@ static void create_vpmu_vm(void *guest_code)
 	/* Initialize vPMU */
 	vcpu_ioctl(vpmu_vm.vcpu, KVM_SET_DEVICE_ATTR, &irq_attr);
 	vcpu_ioctl(vpmu_vm.vcpu, KVM_SET_DEVICE_ATTR, &init_attr);
+
+	if (kvm_has_cap(KVM_CAP_ARM_PARTITION_PMU))
+		__vcpu_ioctl(vpmu_vm.vcpu, KVM_ARM_PARTITION_PMU, &partition);
 }
 
 static void destroy_vpmu_vm(void)
@@ -475,12 +489,12 @@ static void run_vcpu(struct kvm_vcpu *vcpu, uint64_t pmcr_n)
 	}
 }
 
-static void test_create_vpmu_vm_with_pmcr_n(uint64_t pmcr_n, bool expect_fail)
+static void test_create_vpmu_vm_with_pmcr_n(uint64_t pmcr_n, enum pmu_impl impl, bool expect_fail)
 {
 	struct kvm_vcpu *vcpu;
 	uint64_t pmcr, pmcr_orig;
 
-	create_vpmu_vm(guest_code);
+	create_vpmu_vm(guest_code, impl);
 	vcpu = vpmu_vm.vcpu;
 
 	pmcr_orig = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0));
@@ -508,7 +522,7 @@ static void test_create_vpmu_vm_with_pmcr_n(uint64_t pmcr_n, bool expect_fail)
  * Create a guest with one vCPU, set the PMCR_EL0.N for the vCPU to @pmcr_n,
  * and run the test.
  */
-static void run_access_test(uint64_t pmcr_n)
+static void run_access_test(uint64_t pmcr_n, enum pmu_impl impl)
 {
 	uint64_t sp;
 	struct kvm_vcpu *vcpu;
@@ -516,7 +530,7 @@ static void run_access_test(uint64_t pmcr_n)
 
 	pr_debug("Test with pmcr_n %lu\n", pmcr_n);
 
-	test_create_vpmu_vm_with_pmcr_n(pmcr_n, false);
+	test_create_vpmu_vm_with_pmcr_n(pmcr_n, impl, false);
 	vcpu = vpmu_vm.vcpu;
 
 	/* Save the initial sp to restore them later to run the guest again */
@@ -550,14 +564,14 @@ static struct pmreg_sets validity_check_reg_sets[] = {
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
 
-	test_create_vpmu_vm_with_pmcr_n(pmcr_n, false);
+	test_create_vpmu_vm_with_pmcr_n(pmcr_n, impl, false);
 	vcpu = vpmu_vm.vcpu;
 
 	valid_counters_mask = get_counters_mask(pmcr_n);
@@ -607,11 +621,11 @@ static void run_pmregs_validity_test(uint64_t pmcr_n)
  * the vCPU to @pmcr_n, which is larger than the host value.
  * The attempt should fail as @pmcr_n is too big to set for the vCPU.
  */
-static void run_error_test(uint64_t pmcr_n)
+static void run_error_test(uint64_t pmcr_n, enum pmu_impl impl)
 {
-	pr_debug("Error test with pmcr_n %lu (larger than the host)\n", pmcr_n);
+	pr_debug("Error test with pmcr_n %lu (larger than the host allows)\n", pmcr_n);
 
-	test_create_vpmu_vm_with_pmcr_n(pmcr_n, true);
+	test_create_vpmu_vm_with_pmcr_n(pmcr_n, impl, true);
 	destroy_vpmu_vm();
 }
 
@@ -619,30 +633,42 @@ static void run_error_test(uint64_t pmcr_n)
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
 }
 
-int main(void)
+void test_pmu(enum pmu_impl impl)
 {
 	uint64_t i, pmcr_n;
 
-	TEST_REQUIRE(kvm_has_cap(KVM_CAP_ARM_PMU_V3));
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
+
+	test_pmu(EMULATED);
+
+	if (kvm_has_cap(KVM_CAP_ARM_PARTITION_PMU))
+		test_pmu(PARTITIONED);
 
 	return 0;
 }
-- 
2.50.0.727.gbf7dc18ff4-goog

