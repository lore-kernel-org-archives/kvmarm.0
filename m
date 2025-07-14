Received: from mail-oa1-f73.google.com (mail-oa1-f73.google.com [209.85.160.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D2C29B213
	for <kvmarm@lists.linux.dev>; Mon, 14 Jul 2025 22:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752533999; cv=none; b=TGjlkUGH60rNXbb+J0466ViGZc99RILh0GcMeogJexTpzgGYBhvlVKFk/sYZHKmXiSDCCm7uhhkvxdsmXmRZ2Zh/9x91VqlbXufKHZE0k+VbuX/jeGmjgdafGNHZzOzHSQzgsfdFaisqBkbnb/hXEsAQHsuy96wIACfeI5ft6Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752533999; c=relaxed/simple;
	bh=9eSwVawIpIf46LRehZWFLyWPO8/7v6TDvCTZI7UPgOU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZKVsrngkY+Ikv4Em3cwX9rE/OV1f7S+4pyRae7YOAy9DyN2EW7oaS23V1eTAAmyqoQmwbkpY5eifMOjcmEslgME0cD/XICl9RQrW5B0cfVrQ55mgf7el2OoEw6P9Bnroj8NpGoss9wpwX7JSAk2tYPPpqSqiSrfmYlgiZe7y3O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HQ8BK8Rc; arc=none smtp.client-ip=209.85.160.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HQ8BK8Rc"
Received: by mail-oa1-f73.google.com with SMTP id 586e51a60fabf-2e926f54767so4978511fac.0
        for <kvmarm@lists.linux.dev>; Mon, 14 Jul 2025 15:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752533994; x=1753138794; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xdZdMkXachOTBLhsNs+TRwK+/iArlUH+VMAh4h7bRTc=;
        b=HQ8BK8Rcs+QJaYJ0DbYtQyEpGedzNpCDz8I9seUEseA6xC+MtayEP8kvL08/EJyZRu
         crTsSj1eg4xsSHxJXPChnOmG2VKZRcu7EhurHleuO9x1YSYBYWCdUViRyuQLaVuYLczx
         e/+BtI59baRLt5vfVj4YH7m1jWInEZmQ9JPdztKKLffGp0ECfGxRNVF7TG3xbI5VXXx5
         MpUd9LZVMGPcOVG5RWio0UlZZson0vpf5em9tE+aSWkejMVfxnDTYofaosYaKjFoXRt8
         QjZUzrUAQpaR6SjpciUqHW8HC7BELe5qqCAIaBQNP+Q9PV9sChjCNNvysmVj6StRMS76
         Oigw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752533994; x=1753138794;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xdZdMkXachOTBLhsNs+TRwK+/iArlUH+VMAh4h7bRTc=;
        b=Stv0RJJIooArImbm2DY6EyTJoHw4w1/u/7lpDdRz8eBSmhVlOUsS8zUmtP1KPTYaR0
         eJioaCxLlDkNVMhcJb48DCGGvfXaFhbDOiumvrEDPQMi3HR6X3wjc4rYr2paIHI5+zeS
         VBx2iQf5du2MQzzvwbaAtNo4vc9RUkkQz2H1zn9pMTmywYPkUFk2DqKoUToaGzLDim2R
         ddaL38SIYGnKFrokEtYGcMGar0I7VoYhiDYtU7DetShNhjjuPQ9/bdj67n1M2gxGXhyZ
         RB+icEzbLzpyXxR8S0kJd+OemoqNIjQk17sC2Fu2ZxPJDtT4gBsGN1zbhbs8d4yg+6gL
         swQQ==
X-Forwarded-Encrypted: i=1; AJvYcCWGXy+nu2sjC5zZtFiwn4XAiC8/ExDhXdHdTCZCDyMCEhwT9C2cZJ7gY/LBZcnAx6ZnODPEkqU=@lists.linux.dev
X-Gm-Message-State: AOJu0YzK/n2o1gNbD+DM4RTSVxQZoLt41qvd5CfVFEFUYpm/x9nlsXXv
	MTjiNEXMVuxxrekt+DJf/7F8Gkhy48/BQVIeEY2GIauYUxsQw+7WJbn9iOvvxTWsx72BlLlnURE
	cWWhQWRsMEP1Y9wFofsOAG2ptww==
X-Google-Smtp-Source: AGHT+IGtkxxQNHPtdv9dL4s2nR5Wc47eOMAPls/NeDgscE/f3Xbi3rgYw/AG5E5sUgk4Wnfo1XJ8ubTDhh1qfxOcFg==
X-Received: from oabuj12.prod.google.com ([2002:a05:6871:4e4c:b0:2c2:2bad:1512])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6871:3584:b0:2e9:925b:206f with SMTP id 586e51a60fabf-2ff8fc725d6mr1109775fac.17.1752533994367;
 Mon, 14 Jul 2025 15:59:54 -0700 (PDT)
Date: Mon, 14 Jul 2025 22:59:17 +0000
In-Reply-To: <20250714225917.1396543-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250714225917.1396543-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250714225917.1396543-24-coltonlewis@google.com>
Subject: [PATCH v4 23/23] KVM: arm64: selftests: Add test case for partitioned PMU
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

