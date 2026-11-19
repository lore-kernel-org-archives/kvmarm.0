Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795114370;
	b=k3tgT05UocRRU8LifNO01koQiobhhlRVzRqa9PObmVA3nV6gX+j2Umo7KAwQ0j8gcKl1
	 KgYajM1v+eeYtE6yD+Z3L5v64JBQvoqT46n56hARch8XyjsiI/WL8fljx8yGybZlyL41n
	 3Z0HcItZ56Rqe89cY9h94MyXvDe9U5Fvz5p1xgyu3FCOsNL4+19AMzU3x5UIrOKidrFtQ
	 G9biSLtEUDKHhuUGurn+1Wc1nSyTZH8iXqfRCLL02BrP1HYZS6/vhhD4K5kRe/W2HktYk
	 0wd8jraotBQiRNQmJxr9HEucn8chkonudyo+xHO3VGRaAVIhh0V33gToJVebpo73Oww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795114370;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=H3zUx8HoqKFHPeFVX0OdNx2iv8LR8ny79LxRfFBxaR4=;
	b=SGsstFW12QhXwlcB/g3VvGMNgztUaf4euQAyQtWdFGSG2uSQN6Pn5ORNunmF+o9OHCVh
	 T6C66DV3d9LZJIVLwj9lkElYh4cn9gxZNulLbpEFzvxy6MhgYHyzsftsbLEy8IQ73sCGg
	 saJKUoBAQye2Ky7mKidr3LAqWegZI6R50Wz9XCvJiqHrmTwGUobx3mjjB1cRuVBwQetYM
	 azuIIZfIO+MbtnV0ntcWWcDppxjJdBuPY6UgYX4eSOiHyNVKSVJnyNtIKpUV56xUWOxhi
	 9W7VlsTM9wrFioXzRQUDvOVMmtVr/7choBF6FS3qe3CpgvtPKAyLUMisunjX0x5MtUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=A6cOrpHj;
	arc=none smtp.remote-ip=209.85.167.198
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290016073ECE
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 18:52:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 290016073ECE
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=A6cOrpHj
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-57289376805so188936b6e.1
        for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 10:52:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795114368; x=1795719168; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=H3zUx8HoqKFHPeFVX0OdNx2iv8LR8ny79LxRfFBxaR4=;
        b=A6cOrpHjRNUdLHVCVy62Pco8ilHmr/Yzf8EUBMERDyGi9OKktcoSB86wMIIlh3ZGNw
         4yZ/DaUN/qlmfTY8kpz7LVn6OnFzXLMx6I+237MAFTfW9xQdFgJorOxqR5kAmiFWOdrA
         p2SJA4Oz0/zKL+wBU42YUMK1hR9LI1OpQ7gQOhu1Vz80QqsdyGjdwhcOL9k7ppVEwouC
         8+28uPx4HIuPvHxR4LD8vh7OJYsd4OducezvLSxTLFwxc1Fceu3i1FG1gFrVFo8MLX1R
         ert5buxhqaueHDZ+XsoN572wZ/jXVTy7rfylapaqk8IsQI+Q/W5Y5wXY6D+6Y6WXI23j
         KvBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795114368; x=1795719168;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=H3zUx8HoqKFHPeFVX0OdNx2iv8LR8ny79LxRfFBxaR4=;
        b=qrZYmUHR5+D7AmaF6mQ9vQCFBytLS3tyoDjNSrGCwPFsfH4B6feYIxUjqd4vkSL9xV
         0j+t5fBrz7Gl0JFgZZaSwVH2bepyvkN4K3RxtZ243j2WGfNiO/9KI7s3nXBdQJvNIXDV
         thAo6tezzsyv8VIvj83I8TXCyNrz5A6JtiwpuSFlk2w6ocnuG0BBLWaA1rfMSISENRZJ
         9+tiYo1CLFTJb6g/0cNJttcMTZnmpa1NogNS+AGmmhKkjimkDy9griFi9gAi2nYaXrr4
         L5jE0HNRNIgWahKo86eRnBM9XtpdVWuaJRg8YtJvEtrTYl9QTK82pp8ewc3jgb41v75/
         Z3tg==
X-Forwarded-Encrypted: i=1; AL+hErFo8z4mYAQvfCZgWfe9YYsajVyaz5OvvnmVjYXwyb/I/UtSrkU5QBCXHi+4afDnl67w6RavfiE=@lists.linux.dev
X-Gm-Message-State: APuU4Z+0Syd84YhGT4gM+4cDVAYMvTnQxVy9J3oG3kTEkAYNrTxdLz6p
	yskukO0TbIFIc2bG2qpXPmqVldCAaMsrhvbpwkHOZlCJaxqMbk7UkWUAMApBDp/8z2FlvzbK3M6
	FaZhByiNxGY3EZz0SBpxQibfwzw==
X-Received: from ilbdx25-n2.prod.google.com ([2002:a05:6e02:4219:20b0:51a:af50:87cd])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1916:b0:4f4:6421:5efe with SMTP id 5614622812f47-57a0ba53122mr998840b6e.36.1795114367800;
 Thu, 19 Nov 2026 10:52:47 -0800 (PST)
Date: Thu, 19 Nov 2026 18:52:15 +0000
In-Reply-To: <20261119185215.632334-1-coltonlewis@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261119185215.632334-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261119185215.632334-34-coltonlewis@google.com>
Subject: [PATCH v10 33/33] KVM: arm64: selftests: Add test case for
 Partitioned PMU
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Russell King <linux@armlinux.org.uk>, Jonathan Corbet <corbet@lwn.net>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, James Clark <james.clark@linaro.org>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Mingwei Zhang <mizhang@google.com>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Extend arm64/vpmu_counter_access to run all PMU counter access,
PMCR.N validation, and overflow interrupt tests against both the
emulated vPMU and the Partitioned PMU.

Introduce enum pmu_impl (EMULATED vs. PARTITIONED) and thread it
through the test setup helpers to configure
KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION and
KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS when testing the Partitioned PMU.

Exercise PMCCFILTR_EL0 and live PMCCNTR_EL0 counting before validating
unimplemented counters so that Partitioned PMU vCPUs transition to
VCPU_PMU_ACCESS_GUEST_OWNED even when PMCR_EL0.N == 0. On hosts without
FEAT_HPMN0, allow n == 0 whenever max_counters >= 2 and verify that
counter 0 (hidden behind traps while physical MDCR_EL2.HPMN == 1) still
raises UNDEFINED on direct and indirect accesses and is RAZ/WI in the
bitmap and software-increment registers.

Skip out-of-bounds counter access exception tests for other counters
when the PMU is partitioned, as hardware does not guarantee an UNDEFINED
exception on accesses to counters >= MDCR_EL2.HPMN.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 .../selftests/kvm/arm64/vpmu_counter_access.c | 217 +++++++++++++++---
 1 file changed, 181 insertions(+), 36 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
index 22223395969e0..9028d08806540 100644
--- a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
+++ b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
@@ -25,12 +25,28 @@
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
+	bool has_hpmn0;
+};
+
 static struct vpmu_vm vpmu_vm;
+static struct guest_context guest_context;
 
 struct pmreg_sets {
 	u64 set_reg_id;
@@ -331,19 +347,78 @@ static void test_access_invalid_pmc_regs(struct pmc_accessor *acc, int pmc_idx)
 	/*
 	 * Reading/writing the event count/type registers should cause
 	 * an UNDEFINED exception.
+	 *
+	 * On a Partitioned PMU hardware does not guarantee UNDEFINED for
+	 * counters >= MDCR_EL2.HPMN. However, when PMCR_EL0.N == 0 on a host
+	 * without FEAT_HPMN0, KVM programs HPMN = 1 and hides counter 0 behind
+	 * traps, so accessing counter 0 must still raise UNDEFINED.
 	 */
-	TEST_EXCEPTION(ESR_ELx_EC_UNKNOWN, acc->read_cntr(pmc_idx));
-	TEST_EXCEPTION(ESR_ELx_EC_UNKNOWN, acc->write_cntr(pmc_idx, 0));
-	TEST_EXCEPTION(ESR_ELx_EC_UNKNOWN, acc->read_typer(pmc_idx));
-	TEST_EXCEPTION(ESR_ELx_EC_UNKNOWN, acc->write_typer(pmc_idx, 0));
+	if (!guest_context.pmu_partitioned ||
+	    (!guest_context.has_hpmn0 && pmc_idx == 0)) {
+		TEST_EXCEPTION(ESR_ELx_EC_UNKNOWN, acc->read_cntr(pmc_idx));
+		TEST_EXCEPTION(ESR_ELx_EC_UNKNOWN, acc->write_cntr(pmc_idx, 0));
+		TEST_EXCEPTION(ESR_ELx_EC_UNKNOWN, acc->read_typer(pmc_idx));
+		TEST_EXCEPTION(ESR_ELx_EC_UNKNOWN, acc->write_typer(pmc_idx, 0));
+	}
 	/*
-	 * The bit corresponding to the (unimplemented) counter in
-	 * {PMCNTEN,PMINTEN,PMOVS}{SET,CLR} registers should be RAZ.
+	 * Software increment on an unimplemented counter should be WI, and the
+	 * bit corresponding to the counter in {PMCNTEN,PMINTEN,PMOVS}{SET,CLR}
+	 * registers should be RAZ.
 	 */
+	write_sysreg(BIT(pmc_idx), pmswinc_el0);
+	isb();
 	test_bitmap_pmu_regs(pmc_idx, 1);
 	test_bitmap_pmu_regs(pmc_idx, 0);
 }
 
+static void test_cycle_counter(u64 expected_pmcr_n)
+{
+	u64 filtr = ARMV8_PMU_EXCLUDE_EL0;
+	u64 pmcr, val;
+	int i;
+
+	if (get_current_el() == 2)
+		filtr |= ARMV8_PMU_INCLUDE_EL2;
+
+	/*
+	 * Verify PMCCFILTR_EL0 read/write and live PMCCNTR_EL0 counting.
+	 * On Partitioned PMU this also transitions the vCPU to
+	 * VCPU_PMU_ACCESS_GUEST_OWNED even when expected_pmcr_n == 0 so
+	 * subsequent unimplemented counter checks exercise hardware traps.
+	 */
+	write_sysreg(filtr, pmccfiltr_el0);
+	isb();
+	val = read_sysreg(pmccfiltr_el0);
+	__GUEST_ASSERT(val == filtr,
+		       "Unexpected PMCCFILTR_EL0: 0x%lx (expected 0x%lx)",
+		       val, filtr);
+
+	pmcr = read_sysreg(pmcr_el0) & ~ARMV8_PMU_PMCR_E;
+	write_sysreg(pmcr, pmcr_el0);
+	write_sysreg(0, pmccntr_el0);
+	write_sysreg(BIT(ARMV8_PMU_CYCLE_IDX), pmcntenset_el0);
+	isb();
+
+	write_sysreg(pmcr | ARMV8_PMU_PMCR_E, pmcr_el0);
+	isb();
+
+	__GUEST_ASSERT(get_pmcr_n(read_sysreg(pmcr_el0)) == expected_pmcr_n,
+		       "Expected PMCR.N: 0x%lx, PMCR.N: 0x%lx",
+		       expected_pmcr_n, get_pmcr_n(read_sysreg(pmcr_el0)));
+
+	for (i = 0; i < 10000; i++)
+		asm volatile("nop");
+	isb();
+
+	val = read_sysreg(pmccntr_el0);
+	__GUEST_ASSERT(val > 0, "Cycle counter did not advance (0x%lx)", val);
+
+	write_sysreg(pmcr, pmcr_el0);
+	write_sysreg(BIT(ARMV8_PMU_CYCLE_IDX), pmcntenclr_el0);
+	write_sysreg(BIT(ARMV8_PMU_CYCLE_IDX), pmovsclr_el0);
+	isb();
+}
+
 /*
  * The guest is configured with PMUv3 with @expected_pmcr_n number of
  * event counters.
@@ -386,6 +461,8 @@ static void guest_code(u64 expected_pmcr_n)
 			test_access_pmc_regs(&pmc_accessors[i], pmc);
 	}
 
+	test_cycle_counter(expected_pmcr_n);
+
 	/*
 	 * Tests for reading/writing PMU registers for unimplemented counters.
 	 * Use each combination of PMEV{CNTR,TYPER}<n>_EL0 accessor functions.
@@ -399,7 +476,7 @@ static void guest_code(u64 expected_pmcr_n)
 }
 
 /* Create a VM that has one vCPU with PMUv3 configured. */
-static void create_vpmu_vm(void *guest_code)
+static void create_vpmu_vm(void *guest_code, enum pmu_impl impl)
 {
 	struct kvm_vcpu_init init;
 	u8 pmuver, ec;
@@ -409,6 +486,13 @@ static void create_vpmu_vm(void *guest_code)
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
@@ -434,8 +518,19 @@ static void create_vpmu_vm(void *guest_code)
 	TEST_ASSERT(pmuver != ID_AA64DFR0_EL1_PMUVer_IMP_DEF &&
 		    pmuver >= ID_AA64DFR0_EL1_PMUVer_IMP,
 		    "Unexpected PMUVER (0x%x) on the vCPU with PMUv3", pmuver);
+	guest_context.has_hpmn0 = FIELD_GET(ID_AA64DFR0_EL1_HPMN0, dfr0) >=
+				  ID_AA64DFR0_EL1_HPMN0_IMP;
 
 	vcpu_ioctl(vpmu_vm.vcpu, KVM_SET_DEVICE_ATTR, &irq_attr);
+
+	ret = __vcpu_has_device_attr(vpmu_vm.vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
+				     KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION);
+	if (!ret) {
+		vcpu_ioctl(vpmu_vm.vcpu, KVM_SET_DEVICE_ATTR, &part_attr);
+		guest_context.pmu_partitioned = partition;
+		pr_debug("Set PMU partitioning: %d\n", partition);
+	}
+
 }
 
 static void destroy_vpmu_vm(void)
@@ -461,13 +556,15 @@ static void run_vcpu(struct kvm_vcpu *vcpu, u64 pmcr_n)
 	}
 }
 
-static void test_create_vpmu_vm_with_nr_counters(unsigned int nr_counters, bool expect_fail)
+static void test_create_vpmu_vm_with_nr_counters(unsigned int nr_counters,
+						 enum pmu_impl impl,
+						 bool expect_fail)
 {
 	struct kvm_vcpu *vcpu;
 	unsigned int prev;
 	int ret;
 
-	create_vpmu_vm(guest_code);
+	create_vpmu_vm(guest_code, impl);
 	vcpu = vpmu_vm.vcpu;
 
 	prev = get_pmcr_n(vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0)));
@@ -475,21 +572,24 @@ static void test_create_vpmu_vm_with_nr_counters(unsigned int nr_counters, bool
 	ret = __vcpu_device_attr_set(vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
 				     KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS, &nr_counters);
 
-	if (expect_fail)
+	if (expect_fail) {
 		TEST_ASSERT(ret && errno == EINVAL,
-			    "Setting more PMU counters (%u) than available (%u) unexpectedly succeeded",
+			    "Setting invalid PMU counter count (%u, default %u) unexpectedly succeeded",
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
@@ -497,7 +597,7 @@ static void run_access_test(u64 pmcr_n)
 
 	pr_debug("Test with pmcr_n %lu\n", pmcr_n);
 
-	test_create_vpmu_vm_with_nr_counters(pmcr_n, false);
+	test_create_vpmu_vm_with_nr_counters(pmcr_n, impl, false);
 	vcpu = vpmu_vm.vcpu;
 
 	/* Save the initial sp to restore them later to run the guest again */
@@ -531,14 +631,14 @@ static struct pmreg_sets validity_check_reg_sets[] = {
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
@@ -585,14 +685,13 @@ static void run_pmregs_validity_test(u64 pmcr_n)
 
 /*
  * Create a guest with one vCPU, and attempt to set the PMCR_EL0.N for
- * the vCPU to @pmcr_n, which is larger than the host value.
- * The attempt should fail as @pmcr_n is too big to set for the vCPU.
+ * the vCPU to an invalid @pmcr_n value.
  */
-static void run_error_test(u64 pmcr_n)
+static void run_error_test(u64 pmcr_n, enum pmu_impl impl)
 {
-	pr_debug("Error test with pmcr_n %lu (larger than the host)\n", pmcr_n);
+	pr_debug("Error test with pmcr_n %lu\n", pmcr_n);
 
-	test_create_vpmu_vm_with_nr_counters(pmcr_n, true);
+	test_create_vpmu_vm_with_nr_counters(pmcr_n, impl, true);
 	destroy_vpmu_vm();
 }
 
@@ -600,21 +699,26 @@ static void run_error_test(u64 pmcr_n)
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
@@ -622,22 +726,63 @@ static bool kvm_supports_nr_counters_attr(void)
 	return supported;
 }
 
-int main(void)
+static bool kvm_supports_partition_attr(void)
 {
-	u64 i, pmcr_n;
+	bool supported;
 
+	create_vpmu_vm(NULL, EMULATED);
+	supported = !__vcpu_has_device_attr(vpmu_vm.vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
+					    KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION);
+	destroy_vpmu_vm();
+
+	return supported;
+}
+
+static bool kvm_supports_hpmn0(void)
+{
+	u64 dfr0;
+
+	create_vpmu_vm(NULL, EMULATED);
+	dfr0 = vcpu_get_reg(vpmu_vm.vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1));
+	destroy_vpmu_vm();
+
+	return FIELD_GET(ID_AA64DFR0_EL1_HPMN0, dfr0) >= ID_AA64DFR0_EL1_HPMN0_IMP;
+}
+
+void test_pmu(enum pmu_impl impl)
+{
+	u64 i, min_n = 0, pmcr_n;
+
+	pr_info("Testing PMU: Implementation = %s\n", pmu_impl_str[impl]);
+
+	pmcr_n = get_pmcr_n_limit(impl);
+	pr_debug("PMCR_EL0.N: Limit = %lu\n", pmcr_n);
+
+	if (impl == PARTITIONED && !kvm_supports_hpmn0() &&
+	    get_pmcr_n_limit(EMULATED) < 2) {
+		run_error_test(0, impl);
+		min_n = 1;
+	}
+
+	for (i = min_n; i <= pmcr_n; i++) {
+		run_access_test(i, impl);
+		run_pmregs_validity_test(i, impl);
+	}
+
+	for (i = pmcr_n + 1; i < ARMV8_PMU_MAX_COUNTERS; i++)
+		run_error_test(i, impl);
+}
+
+int main(void)
+{
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_ARM_PMU_V3));
 	TEST_REQUIRE(kvm_supports_vgic_v3());
 	TEST_REQUIRE(kvm_supports_nr_counters_attr());
 
-	pmcr_n = get_pmcr_n_limit();
-	for (i = 0; i <= pmcr_n; i++) {
-		run_access_test(i);
-		run_pmregs_validity_test(i);
-	}
+	test_pmu(EMULATED);
 
-	for (i = pmcr_n + 1; i < ARMV8_PMU_MAX_COUNTERS; i++)
-		run_error_test(i);
+	if (kvm_supports_partition_attr() && get_pmcr_n_limit(EMULATED) > 0)
+		test_pmu(PARTITIONED);
 
 	return 0;
 }
-- 
2.56.1.708.g77570a6a1d-goog

