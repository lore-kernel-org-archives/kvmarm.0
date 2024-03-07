Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8305D133980
	for <kvmarm@lists.linux.dev>; Thu,  7 Mar 2024 18:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709836798; cv=none; b=e5ieJhM0gOBgmUMTHe272+8MKpFlfqifvEmLkWtEVfEtCgEtnwGtyMIFvg3cLEXieklpXgF0TIywDzCs5j+euxMEqH5Tm/aF/lp1N3aOy9rboJbEX9RSw3t9wk/PUSL97av5xIv/1du1AU1x/aLJaqBBrBG7iVOotAawvgmhUro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709836798; c=relaxed/simple;
	bh=9ITPmfwnN/lGNrMGxS63ywvaBoj6/bA8sXvoj3QG3eo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Fws4vH6SeBdJImns0Y+xJj5Dz/GbxlSi9ajS5v8JUSfB+JNwLIYCiymJIZ5Crm9aLcbBv/lCIvdTIb4U6o95TqELsNxs0cwto3FAeBuaRIbxeY4PBG2S5ts7E5drMqoG7ZajZL48lleKxW4y3ojtZP9qFBW7LJIwYmP3QDDvaDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3slEGw88; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3slEGw88"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-609a1063919so22678137b3.0
        for <kvmarm@lists.linux.dev>; Thu, 07 Mar 2024 10:39:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709836795; x=1710441595; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7feiJcUDKCsoX/GY5X7oEbuwAq5m1wwJvmpcS3YmBNc=;
        b=3slEGw88sNFzcJZk2LlGZjWS3Z0g4LcKQ0vzLLpRrtceJD6hXdabE9NAU5vqfq6yfF
         eWH1qYdCaEJTN4tLECjqbbNOkL9XT92Da701pdYEhFO3k+39C0Nhnxef10UIea/ac2jP
         rUGGPP8lnCXEHQOsQ8LdBqjxnxIee5Z5QL0FmqjFaRDgE1NsLpwAQLWGv+SWpLQKnhtm
         RODF4vMyQM7C8czLNnvZ9SaxmdAWuCdVKx67gRd9TQW0SXU2j69tKN8UIaGypiSEGQ90
         Qqpba8mJG6iWOVimLqQWBG+cPc6bgOpkOZqD41sLc0r+ehxkNvsH6t1IybbrO0bIA9rn
         aY8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709836795; x=1710441595;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7feiJcUDKCsoX/GY5X7oEbuwAq5m1wwJvmpcS3YmBNc=;
        b=aXLmfdTtqolEehGDvgilSULMx5aAIVyx5r8R/Tptv+865m1SAz8USmt3crq91bu1Ui
         PriAc3SvSOiXXdCYFBnMgJkqGi8Ssu6kLpPxD4ZjcgtXYlp/M8EDmrNhMFnmS/kwxNaL
         fLXnD5vkpDoaBWW5LRYzj0iPNJTCMkQRq/Bv+DMHf+o7nWebLS1Vwr74KniuDIH6bxWF
         VDXEu0jUnqqgD8YfiaexHEUDMqL91I7jo/oS3nr+mFP5QXDJSjq1+opS/Zc/SXQ7mYB4
         YuZ6CB0K7aBNUXpMQlAHR0SgjkHfr+BRVvn1f4RkqmJgD+/WMD8gXQl1kUsmCxYYdizB
         pxDQ==
X-Forwarded-Encrypted: i=1; AJvYcCXz7ZDvbvuJ1+ZSJ597juJEoiKvX5DnZoW1urHiI0e+Bf4yyBsHICYCy7nsIsdVZnchkGGJSMJcSFyDNHqPbK+gpnCSMwUd
X-Gm-Message-State: AOJu0YyPkqlIhnwRUxLoALHLwMAycbm67bN9ZXYZkmXuxlW9NcBTCNIm
	2EJ4hm4FHAZlusI2VwF4hmKCRxOgQkF9SgTuzeP1ODHKiqlKxdSni2z4MNViUWBg/5x0SeDT8Jv
	B0+0k7rR1k95dlhIrjqVfcg==
X-Google-Smtp-Source: AGHT+IEbjD4WndardWCeHPl0rY+T0nvVYa16e76LqrrVqOgjYkDCeLF2wHecoJ3e95zCkEUlT039xvGdTcOA1Ieg9g==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:690c:3702:b0:608:1b39:245c with
 SMTP id fv2-20020a05690c370200b006081b39245cmr5316810ywb.9.1709836795524;
 Thu, 07 Mar 2024 10:39:55 -0800 (PST)
Date: Thu,  7 Mar 2024 18:39:05 +0000
In-Reply-To: <20240307183907.1184775-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240307183907.1184775-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240307183907.1184775-2-coltonlewis@google.com>
Subject: [PATCH v4 1/3] KVM: arm64: selftests: Standardize GIC base addresses
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Ricardo Koller <ricarkol@google.com>, kvmarm@lists.linux.dev, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Use default values during GIC initialization and setup to avoid
multiple tests needing to decide and declare base addresses for GICD
and GICR. Remove the repeated definitions of these addresses across
tests.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 tools/testing/selftests/kvm/aarch64/arch_timer.c      |  8 ++------
 tools/testing/selftests/kvm/aarch64/vgic_irq.c        | 11 ++---------
 .../selftests/kvm/aarch64/vpmu_counter_access.c       |  3 +--
 tools/testing/selftests/kvm/dirty_log_perf_test.c     |  5 +----
 tools/testing/selftests/kvm/include/aarch64/gic.h     |  5 ++++-
 tools/testing/selftests/kvm/include/aarch64/vgic.h    |  3 ++-
 tools/testing/selftests/kvm/lib/aarch64/gic.c         |  7 ++++++-
 tools/testing/selftests/kvm/lib/aarch64/vgic.c        |  7 ++++++-
 8 files changed, 24 insertions(+), 25 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
index 2cb8dd1f8275..01c359eea1d6 100644
--- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
+++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
@@ -59,9 +59,6 @@ static struct test_args test_args = {
 
 #define msecs_to_usecs(msec)		((msec) * 1000LL)
 
-#define GICD_BASE_GPA			0x8000000ULL
-#define GICR_BASE_GPA			0x80A0000ULL
-
 enum guest_stage {
 	GUEST_STAGE_VTIMER_CVAL = 1,
 	GUEST_STAGE_VTIMER_TVAL,
@@ -204,8 +201,7 @@ static void guest_code(void)
 
 	local_irq_disable();
 
-	gic_init(GIC_V3, test_args.nr_vcpus,
-		(void *)GICD_BASE_GPA, (void *)GICR_BASE_GPA);
+	gic_init(GIC_V3, test_args.nr_vcpus);
 
 	timer_set_ctl(VIRTUAL, CTL_IMASK);
 	timer_set_ctl(PHYSICAL, CTL_IMASK);
@@ -391,7 +387,7 @@ static struct kvm_vm *test_vm_create(void)
 		vcpu_init_descriptor_tables(vcpus[i]);
 
 	test_init_timer_irq(vm);
-	gic_fd = vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
+	gic_fd = vgic_v3_setup(vm, nr_vcpus, 64);
 	__TEST_REQUIRE(gic_fd >= 0, "Failed to create vgic-v3");
 
 	/* Make all the test's cmdline args visible to the guest */
diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index 2e64b4856e38..d3bf584d2cc1 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -19,9 +19,6 @@
 #include "gic_v3.h"
 #include "vgic.h"
 
-#define GICD_BASE_GPA		0x08000000ULL
-#define GICR_BASE_GPA		0x080A0000ULL
-
 /*
  * Stores the user specified args; it's passed to the guest and to every test
  * function.
@@ -49,9 +46,6 @@ struct test_args {
 #define IRQ_DEFAULT_PRIO	(LOWEST_PRIO - 1)
 #define IRQ_DEFAULT_PRIO_REG	(IRQ_DEFAULT_PRIO << KVM_PRIO_SHIFT) /* 0xf0 */
 
-static void *dist = (void *)GICD_BASE_GPA;
-static void *redist = (void *)GICR_BASE_GPA;
-
 /*
  * The kvm_inject_* utilities are used by the guest to ask the host to inject
  * interrupts (e.g., using the KVM_IRQ_LINE ioctl).
@@ -478,7 +472,7 @@ static void guest_code(struct test_args *args)
 	bool level_sensitive = args->level_sensitive;
 	struct kvm_inject_desc *f, *inject_fns;
 
-	gic_init(GIC_V3, 1, dist, redist);
+	gic_init(GIC_V3, 1);
 
 	for (i = 0; i < nr_irqs; i++)
 		gic_irq_enable(i);
@@ -764,8 +758,7 @@ static void test_vgic(uint32_t nr_irqs, bool level_sensitive, bool eoi_split)
 	memcpy(addr_gva2hva(vm, args_gva), &args, sizeof(args));
 	vcpu_args_set(vcpu, 1, args_gva);
 
-	gic_fd = vgic_v3_setup(vm, 1, nr_irqs,
-			GICD_BASE_GPA, GICR_BASE_GPA);
+	gic_fd = vgic_v3_setup(vm, 1, nr_irqs);
 	__TEST_REQUIRE(gic_fd >= 0, "Failed to create vgic-v3, skipping");
 
 	vm_install_exception_handler(vm, VECTOR_IRQ_CURRENT,
diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
index 5f9713364693..7007cc424bf0 100644
--- a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
+++ b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
@@ -454,8 +454,7 @@ static void create_vpmu_vm(void *guest_code)
 	init.features[0] |= (1 << KVM_ARM_VCPU_PMU_V3);
 	vpmu_vm.vcpu = aarch64_vcpu_add(vpmu_vm.vm, 0, &init, guest_code);
 	vcpu_init_descriptor_tables(vpmu_vm.vcpu);
-	vpmu_vm.gic_fd = vgic_v3_setup(vpmu_vm.vm, 1, 64,
-					GICD_BASE_GPA, GICR_BASE_GPA);
+	vpmu_vm.gic_fd = vgic_v3_setup(vpmu_vm.vm, 1, 64);
 	__TEST_REQUIRE(vpmu_vm.gic_fd >= 0,
 		       "Failed to create vgic-v3, skipping");
 
diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 504f6fe980e8..61535c4f3405 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -22,9 +22,6 @@
 #ifdef __aarch64__
 #include "aarch64/vgic.h"
 
-#define GICD_BASE_GPA			0x8000000ULL
-#define GICR_BASE_GPA			0x80A0000ULL
-
 static int gic_fd;
 
 static void arch_setup_vm(struct kvm_vm *vm, unsigned int nr_vcpus)
@@ -33,7 +30,7 @@ static void arch_setup_vm(struct kvm_vm *vm, unsigned int nr_vcpus)
 	 * The test can still run even if hardware does not support GICv3, as it
 	 * is only an optimization to reduce guest exits.
 	 */
-	gic_fd = vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
+	gic_fd = vgic_v3_setup(vm, nr_vcpus, 64);
 }
 
 static void arch_cleanup_vm(struct kvm_vm *vm)
diff --git a/tools/testing/selftests/kvm/include/aarch64/gic.h b/tools/testing/selftests/kvm/include/aarch64/gic.h
index b217ea17cac5..9043eaef1076 100644
--- a/tools/testing/selftests/kvm/include/aarch64/gic.h
+++ b/tools/testing/selftests/kvm/include/aarch64/gic.h
@@ -16,13 +16,16 @@ enum gic_type {
 #define MIN_SPI			32
 #define MAX_SPI			1019
 #define IAR_SPURIOUS		1023
+#define GICD_BASE_GPA			0x8000000ULL
+#define GICR_BASE_GPA			0x80A0000ULL
 
 #define INTID_IS_SGI(intid)	(0       <= (intid) && (intid) < MIN_PPI)
 #define INTID_IS_PPI(intid)	(MIN_PPI <= (intid) && (intid) < MIN_SPI)
 #define INTID_IS_SPI(intid)	(MIN_SPI <= (intid) && (intid) <= MAX_SPI)
 
-void gic_init(enum gic_type type, unsigned int nr_cpus,
+void _gic_init(enum gic_type type, unsigned int nr_cpus,
 		void *dist_base, void *redist_base);
+void gic_init(enum gic_type type, unsigned int nr_cpus);
 void gic_irq_enable(unsigned int intid);
 void gic_irq_disable(unsigned int intid);
 unsigned int gic_get_and_ack_irq(void);
diff --git a/tools/testing/selftests/kvm/include/aarch64/vgic.h b/tools/testing/selftests/kvm/include/aarch64/vgic.h
index 0ac6f05c63f9..e116a815964a 100644
--- a/tools/testing/selftests/kvm/include/aarch64/vgic.h
+++ b/tools/testing/selftests/kvm/include/aarch64/vgic.h
@@ -16,8 +16,9 @@
 	((uint64_t)(flags) << 12) | \
 	index)
 
-int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus, uint32_t nr_irqs,
+int _vgic_v3_setup(struct kvm_vm *vm, uint32_t nr_vcpus, uint32_t nr_irqs,
 		uint64_t gicd_base_gpa, uint64_t gicr_base_gpa);
+int vgic_v3_setup(struct kvm_vm *vm, uint32_t nr_vcpus, uint32_t nr_irqs);
 
 #define VGIC_MAX_RESERVED	1023
 
diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic.c b/tools/testing/selftests/kvm/lib/aarch64/gic.c
index 55668631d546..9d15598d4e34 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/gic.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/gic.c
@@ -49,7 +49,7 @@ gic_dist_init(enum gic_type type, unsigned int nr_cpus, void *dist_base)
 	spin_unlock(&gic_lock);
 }
 
-void gic_init(enum gic_type type, unsigned int nr_cpus,
+void _gic_init(enum gic_type type, unsigned int nr_cpus,
 		void *dist_base, void *redist_base)
 {
 	uint32_t cpu = guest_get_vcpuid();
@@ -63,6 +63,11 @@ void gic_init(enum gic_type type, unsigned int nr_cpus,
 	gic_cpu_init(cpu, redist_base);
 }
 
+void gic_init(enum gic_type type, unsigned int nr_cpus)
+{
+	_gic_init(type, nr_cpus, (void *)GICD_BASE_GPA, (void *)GICR_BASE_GPA);
+}
+
 void gic_irq_enable(unsigned int intid)
 {
 	GUEST_ASSERT(gic_common_ops);
diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
index 184378d593e9..3fdb568a47df 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/vgic.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
@@ -30,7 +30,7 @@
  * redistributor regions of the guest. Since it depends on the number of
  * vCPUs for the VM, it must be called after all the vCPUs have been created.
  */
-int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus, uint32_t nr_irqs,
+int _vgic_v3_setup(struct kvm_vm *vm, uint32_t nr_vcpus, uint32_t nr_irqs,
 		uint64_t gicd_base_gpa, uint64_t gicr_base_gpa)
 {
 	int gic_fd;
@@ -79,6 +79,11 @@ int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus, uint32_t nr_irqs,
 	return gic_fd;
 }
 
+int vgic_v3_setup(struct kvm_vm *vm, uint32_t nr_vcpus, uint32_t nr_irqs)
+{
+	return _vgic_v3_setup(vm, nr_vcpus, nr_irqs, GICD_BASE_GPA, GICR_BASE_GPA);
+}
+
 /* should only work for level sensitive interrupts */
 int _kvm_irq_set_level_info(int gic_fd, uint32_t intid, int level)
 {
-- 
2.44.0.278.ge034bb2e1d-goog

