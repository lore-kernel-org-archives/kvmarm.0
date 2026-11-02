Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793648769;
	b=Svh+a2upM/3oFzSS5UudLNoNG9OyDwgDR7Gq5iugbyhEXhZGTRAvkdaEEh90A0mdvRlu
	 dLWVPXzrUlStoGKsB0wLYbm95MghkQlB3lkT7ZrP821ftNt1HFwol+DbK6gwDRxJBWLnn
	 cg9tkPRltfpVxOf9AzK+Qgb0ldZDFtP2kcwM6PQzdbqXxjpBOXfs5bqxOnuI+saob5uqJ
	 jpX8N5ciojolhhj/eerEoYHBjh0/Kus53lnAg2sDhpDo7yWrHOHvF1JWB3MxitC4nRMGG
	 AhHvDHAIe9Jh994G6kssMWnH7IQffamm9VUmmi8NWJBbrLs6RCvQYsgADClNb4ZugNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793648769;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=a4gDNewOQFoAH1frVRPOXhtWdDzLzBicCWaO5yRv+hA=;
	b=QTUhxj86ojxapjvyeyP2jl5UfE/vDFdoy4tsc5a5TRi4ORq+k5xY63fLPYXCltSiiM3J
	 OD2zYKGsWQtMzGFQKA9Mi0xZRz3CDkxvql6lfTBiYvPDksVHgY5ZsMlS9PIgHK35KzDFy
	 CXwSJf43jki3M+bkQczJWVldcxA74Fc+j2vUvyJPKbLJvmJMwr9bjBgxWG0VI+ce6qDPb
	 mj3HL8CJ0e0jdEmYQJwqbraIonZJ9jbrytP/uhoWro4IuMZhDTnudY0YQsVmB7+H0T96C
	 uEj3OCAsiENfYPsn66Xb1ymBHJ0YYIuw2vkZ/yaXcvwQqp0V2p5FwoJEYfNPcdDbs3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Un6YYxUt;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 677CC606EEAB
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 19:46:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 677CC606EEAB
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Un6YYxUt
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9DA5A16A3;
	Mon,  2 Nov 2026 11:46:04 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A4CC63F673;
	Mon,  2 Nov 2026 11:46:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793648767; bh=c6ZkN1GTIQBiBRc1+BUN0cZxnKnbdGlfYPwYLrN3iAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Un6YYxUtAdf3/86f/KbaRcmOEO+QBw/W3SYqbCjbnPilIUCPu5BBW8dgthPkuA0wq
	 dMuCvFccHhFO4ZMzVIqGIXSNA/LoX6AHNw73YtIgIwRcE7w8Kw0L6XrPWzaY5k9KEs
	 jQNdgpa0RQff5oWyr+rAQfeViHBab/iRjcKYQWLk=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Cc: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	peter.maydell@linaro.org,
	lpieralisi@kernel.org,
	timothy.hayes@arm.com,
	fuad.tabba@linux.dev
Subject: [PATCH v2 14/16] KVM: selftests: Add VGICv5 ITS attribute tests
Date: Mon,  2 Nov 2026 19:44:52 +0000
Message-Id: <20261102194454.4086911-15-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261102194454.4086911-1-sascha.bischoff@arm.com>
References: <20261102194454.4086911-1-sascha.bischoff@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add coverage for the VGICv5 ITS device address and ITS_REGS attribute
groups. Userspace needs to be able to discover and save the virtual
ITS register state, while KVM must reject invalid address placement
and malformed register accesses.

Verify that the ITS device exposes only the ITS address type, reports
VGIC_ADDR_UNDEF before configuration, rejects misaligned and
out-of-IPA bases, accepts a valid 64K-aligned base, reports it back,
and rejects a second base assignment.

Exercise ITS_REGS after the ITS base is configured by checking all
exposed offsets, read/write-back access, bad offsets, bad alignment,
and bad userspace pointers. Also initialise the shared VM wrapper so
non-ITS tests safely ignore the optional ITS fd during cleanup.

Verify that nonzero IDR0-IDR2, READ_EVENT_DATAR and DT_BASER values
round-trip through ITS_REGS, and reject unsupported ID register
values.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 tools/testing/selftests/kvm/arm64/vgic_v5.c   | 364 +++++++++++++++++-
 .../selftests/kvm/include/arm64/gic_v5.h      |  71 ++++
 2 files changed, 424 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/selftests/kvm/arm64/vgic_v5.c
index 5bf7d99d29147..92da9753ce8e6 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
@@ -43,6 +43,7 @@ static u64 max_phys_size;
 struct vm_gic {
 	struct kvm_vm *vm;
 	int gic_fd;
+	int its_fd;
 	u32 gic_dev_type;
 };
 
@@ -581,9 +582,20 @@ static int run_vcpu(struct kvm_vcpu *vcpu)
 	return __vcpu_run(vcpu) ? -errno : 0;
 }
 
+static void vm_gic_init(struct vm_gic *v)
+{
+	v->vm = NULL;
+	v->gic_fd = -1;
+	v->its_fd = -1;
+	v->gic_dev_type = KVM_DEV_TYPE_ARM_VGIC_V5;
+}
+
 static void vm_gic_destroy(struct vm_gic *v)
 {
-	close(v->gic_fd);
+	if (v->its_fd >= 0)
+		close(v->its_fd);
+	if (v->gic_fd >= 0)
+		close(v->gic_fd);
 	kvm_vm_free(v->vm);
 }
 
@@ -623,7 +635,7 @@ static void vgic_v5_spi_line_vm_create(struct vm_gic *v,
 {
 	u64 attr;
 
-	v->gic_dev_type = KVM_DEV_TYPE_ARM_VGIC_V5;
+	vm_gic_init(v);
 	v->vm = __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
 	v->gic_fd = kvm_create_device(v->vm, v->gic_dev_type);
 	*vcpu = vm_vcpu_add(v->vm, 0, guest_spi_line_code);
@@ -654,7 +666,7 @@ static void vgic_v5_lpi_ist_vm_create(struct vm_gic *v,
 	u64 attr;
 	int i;
 
-	v->gic_dev_type = KVM_DEV_TYPE_ARM_VGIC_V5;
+	vm_gic_init(v);
 	v->vm = __vm_create(VM_SHAPE_DEFAULT, VGIC_V5_LPI_NR_VCPUS, 0);
 	v->gic_fd = kvm_create_device(v->vm, v->gic_dev_type);
 
@@ -779,6 +791,12 @@ static const struct vgic_region_attr gic_v5_irs_region = {
 	.alignment = GICV5_IRS_ALIGN,
 };
 
+static const struct vgic_region_attr gic_v5_its_region = {
+	.attr = KVM_VGIC_V5_ADDR_TYPE_ITS,
+	.size = GICV5_ITS_SIZE,
+	.alignment = GICV5_ITS_ALIGN,
+};
+
 struct vgic_sysreg_attr {
 	const char	*name;
 	u32		encoding;
@@ -863,6 +881,39 @@ static const struct vgic_irs_reg_attr gic_v5_irs_regs[] = {
 	IRS_REG(GICV5_IRS_SWERR_SYNDROMER1),
 };
 
+static const struct vgic_irs_reg_attr gic_v5_its_regs[] = {
+	IRS_REG(GICV5_ITS_IDR0),
+	IRS_REG(GICV5_ITS_IDR1),
+	IRS_REG(GICV5_ITS_IDR2),
+	IRS_REG(GICV5_ITS_IIDR),
+	IRS_REG(GICV5_ITS_AIDR),
+	IRS_REG(GICV5_ITS_CR0),
+	IRS_REG(GICV5_ITS_CR1),
+	IRS_REG(GICV5_ITS_DT_BASER),
+	IRS_REG(GICV5_ITS_DT_CFGR),
+	IRS_REG(GICV5_ITS_DIDR),
+	IRS_REG(GICV5_ITS_EIDR),
+	IRS_REG(GICV5_ITS_INV_EVENTR),
+	IRS_REG(GICV5_ITS_INV_DEVICER),
+	IRS_REG(GICV5_ITS_READ_EVENTR),
+	IRS_REG(GICV5_ITS_READ_EVENT_DATAR),
+	IRS_REG(GICV5_ITS_STATUSR),
+	IRS_REG(GICV5_ITS_SYNCR),
+	IRS_REG(GICV5_ITS_SYNC_STATUSR),
+	IRS_REG(GICV5_ITS_GEN_EVENT_DIDR),
+	IRS_REG(GICV5_ITS_GEN_EVENT_EIDR),
+	IRS_REG(GICV5_ITS_GEN_EVENTR),
+	IRS_REG(GICV5_ITS_GEN_EVENT_STATUSR),
+	IRS_REG(GICV5_ITS_MEC_IDR),
+	IRS_REG(GICV5_ITS_MEC_MECID_R),
+	IRS_REG(GICV5_ITS_MPAM_IDR),
+	IRS_REG(GICV5_ITS_MPAM_PARTID_R),
+	IRS_REG(GICV5_ITS_SWERR_STATUSR),
+	IRS_REG(GICV5_ITS_SWERR_SYNDROMER0),
+	IRS_REG(GICV5_ITS_SWERR_SYNDROMER1),
+	IRS_REG(GICV5_ITS_MPAM_PMGR),
+};
+
 static const struct vgic_sysreg_attr gic_v5_cpu_sysregs[] = {
 	SR(SYS_ICC_ICSR_EL1),
 	SR(SYS_ICC_PPI_ENABLER0_EL1),
@@ -945,7 +996,7 @@ static void test_vgic_v5_addr_attrs(void)
 	u64 addr;
 	int ret;
 
-	v.gic_dev_type = KVM_DEV_TYPE_ARM_VGIC_V5;
+	vm_gic_init(&v);
 	v.vm = __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
 	v.gic_fd = kvm_create_device(v.vm, v.gic_dev_type);
 
@@ -1001,6 +1052,7 @@ static void test_vgic_v5_addr_attrs(void)
 	vm_gic_destroy(&v);
 
 	/* Try running a VM without ever setting the IRS base addr */
+	vm_gic_init(&v);
 	v.vm = __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
 	v.gic_fd = kvm_create_device(v.vm, v.gic_dev_type);
 	vcpu = vm_vcpu_add(v.vm, 0, NULL);
@@ -1019,7 +1071,7 @@ static void test_vgic_v5_nr_irqs_attrs(void)
 	u32 nr_irqs;
 	int ret;
 
-	v.gic_dev_type = KVM_DEV_TYPE_ARM_VGIC_V5;
+	vm_gic_init(&v);
 	v.vm = __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
 	v.gic_fd = kvm_create_device(v.vm, v.gic_dev_type);
 
@@ -1077,6 +1129,7 @@ static void test_vgic_v5_nr_irqs_attrs(void)
 	vm_gic_destroy(&v);
 
 	/* If userspace does not set NR_IRQS, init selects the default. */
+	vm_gic_init(&v);
 	v.vm = __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
 	v.gic_fd = kvm_create_device(v.vm, v.gic_dev_type);
 	vcpu = vm_vcpu_add(v.vm, 0, NULL);
@@ -1096,7 +1149,6 @@ static void test_vgic_v5_nr_irqs_attrs(void)
 	TEST_ASSERT(ret && errno == EBUSY, "GICv5 NR_IRQS set after init");
 
 	vm_gic_destroy(&v);
-
 }
 
 static void test_vgic_v5_irs_regs_attrs(void)
@@ -1106,7 +1158,7 @@ static void test_vgic_v5_irs_regs_attrs(void)
 	u64 attr, val;
 	int ret, i;
 
-	v.gic_dev_type = KVM_DEV_TYPE_ARM_VGIC_V5;
+	vm_gic_init(&v);
 	v.vm = __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
 	v.gic_fd = kvm_create_device(v.vm, v.gic_dev_type);
 	vcpu = vm_vcpu_add(v.vm, 0, NULL);
@@ -1287,6 +1339,290 @@ static void test_vgic_v5_irs_regs_attrs(void)
 	vm_gic_destroy(&v);
 }
 
+static void test_vgic_v5_its_attrs(void)
+{
+	struct vm_gic v;
+	u64 attr, val;
+	int ret, i;
+
+	vm_gic_init(&v);
+	v.vm = __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
+	v.gic_fd = kvm_create_device(v.vm, v.gic_dev_type);
+	v.its_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V5_ITS);
+
+	kvm_has_device_attr(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			    gic_v5_its_region.attr);
+
+	/* We should have the ITS Address attr */
+	ret = __kvm_has_device_attr(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V5_ADDR_TYPE_ITS);
+	TEST_ASSERT(!ret, "GICv5 ITS address attr missing");
+
+	/* But not the IRS one */
+	ret = __kvm_has_device_attr(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V5_ADDR_TYPE_IRS);
+	TEST_ASSERT(ret && errno == ENXIO, "GICv5 ITS accepted IRS address attr");
+
+	/* Default address is undefined */
+	ret = __kvm_device_attr_get(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V5_ADDR_TYPE_ITS, &attr);
+	TEST_ASSERT(!ret && attr == (-1ULL),
+		    "GICv5 ITS returns VGIC_ADDR_UNDEF");
+
+	/* Misaligned address */
+	attr = gic_v5_its_region.alignment / 0x10;
+	ret = __kvm_device_attr_set(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V5_ADDR_TYPE_ITS, &attr);
+	TEST_ASSERT(ret && errno == EINVAL, "GICv5 ITS base not aligned");
+
+	/* Address out of PA range */
+	attr = max_phys_size;
+	ret = __kvm_device_attr_set(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V5_ADDR_TYPE_ITS, &attr);
+	TEST_ASSERT(ret && errno == E2BIG, "GICv5 ITS address beyond IPA limit");
+
+	/* Address + size too big to fit in PA range */
+	attr = max_phys_size - gic_v5_its_region.alignment;
+	ret = __kvm_device_attr_set(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V5_ADDR_TYPE_ITS, &attr);
+	TEST_ASSERT(ret && errno == E2BIG,
+		    "half of the ITS is beyond IPA limit");
+
+	/* Set a valid address */
+	attr = GICV5_ITS_BASE_GPA;
+	ret = __kvm_device_attr_set(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V5_ADDR_TYPE_ITS, &attr);
+	TEST_ASSERT(!ret, "GICv5 ITS base correctly set");
+
+	/* Read back the set address */
+	attr = 0xbad;
+	ret = __kvm_device_attr_get(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V5_ADDR_TYPE_ITS, &attr);
+	TEST_ASSERT(!ret && attr == GICV5_ITS_BASE_GPA,
+		    "GICv5 ITS base readback mismatch");
+
+	/* Attempt to set the address again */
+	attr = GICV5_ITS_BASE_GPA + gic_v5_its_region.alignment;
+	ret = __kvm_device_attr_set(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V5_ADDR_TYPE_ITS, &attr);
+	TEST_ASSERT(ret && errno == EEXIST, "GICv5 ITS base set again");
+
+	/* Check existing group/attribute */
+	kvm_has_device_attr(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
+			    GICV5_ITS_IDR0);
+
+	/* Check MMIO by checking if present, reading, then writing back */
+	for (i = 0; i < ARRAY_SIZE(gic_v5_its_regs); i++) {
+		attr = gic_v5_its_regs[i].attr;
+		ret = __kvm_has_device_attr(v.its_fd,
+					    KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
+					    attr);
+		TEST_ASSERT(!ret, "GICv5 ITS_REGS missing %s",
+			    gic_v5_its_regs[i].name);
+
+		val = 0xbad;
+		ret = __kvm_device_attr_get(v.its_fd,
+					    KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
+					    attr, &val);
+		TEST_ASSERT(!ret, "GICv5 ITS_REGS get failed for %s",
+			    gic_v5_its_regs[i].name);
+
+		ret = __kvm_device_attr_set(v.its_fd,
+					    KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
+					    attr, &val);
+		TEST_ASSERT(!ret, "GICv5 ITS_REGS set failed for %s",
+			    gic_v5_its_regs[i].name);
+	}
+
+	/* ID registers are guest read-only, but userspace can restore sane values. */
+	ret = __kvm_device_attr_get(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
+				    GICV5_ITS_IDR0, &val);
+	TEST_ASSERT(!ret, "GICv5 ITS_REGS get IDR0 failed");
+	val |= FIELD_PREP(GICV5_ITS_IDR0_ITSID, 1);
+	ret = __kvm_device_attr_set(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
+				    GICV5_ITS_IDR0, &val);
+	TEST_ASSERT(!ret, "GICv5 ITS_REGS rejected IDR0 restore");
+	ret = __kvm_device_attr_get(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
+				    GICV5_ITS_IDR0, &attr);
+	TEST_ASSERT(!ret && attr == val, "GICv5 ITS_REGS IDR0 restore mismatch");
+	attr = (val & ~GICV5_ITS_IDR0_DOM) |
+		FIELD_PREP(GICV5_ITS_IDR0_DOM, GICV5_ITS_IDR0_DOMAIN_SECURE);
+	ret = __kvm_device_attr_set(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
+				    GICV5_ITS_IDR0, &attr);
+	TEST_ASSERT(ret && errno == EINVAL, "GICv5 ITS_REGS accepted secure IDR0");
+	attr = val | GICV5_ITS_IDR0_SWE;
+	ret = __kvm_device_attr_set(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
+				    GICV5_ITS_IDR0, &attr);
+	TEST_ASSERT(ret && errno == EINVAL, "GICv5 ITS_REGS accepted SWE");
+	attr = (val & ~GICV5_ITS_IDR0_PA_RANGE) |
+		FIELD_PREP(GICV5_ITS_IDR0_PA_RANGE, 0xf);
+	ret = __kvm_device_attr_set(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
+				    GICV5_ITS_IDR0, &attr);
+	TEST_ASSERT(ret && errno == EINVAL, "GICv5 ITS_REGS accepted PA range");
+	attr = val | BIT(9);
+	ret = __kvm_device_attr_set(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
+				    GICV5_ITS_IDR0, &attr);
+	TEST_ASSERT(ret && errno == EINVAL, "GICv5 ITS_REGS accepted IDR0 reserved bit");
+	attr = val | BIT_ULL(32);
+	ret = __kvm_device_attr_set(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
+				    GICV5_ITS_IDR0, &attr);
+	TEST_ASSERT(ret && errno == EINVAL, "GICv5 ITS_REGS accepted IDR0 upper bit");
+
+	ret = __kvm_device_attr_get(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
+				    GICV5_ITS_IDR1, &val);
+	TEST_ASSERT(!ret, "GICv5 ITS_REGS get IDR1 failed");
+	val = (val & ~GICV5_ITS_IDR1_DEVICEID_BITS) |
+	      FIELD_PREP(GICV5_ITS_IDR1_DEVICEID_BITS, 8);
+	ret = __kvm_device_attr_set(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
+				    GICV5_ITS_IDR1, &val);
+	TEST_ASSERT(!ret, "GICv5 ITS_REGS rejected IDR1 restore");
+	ret = __kvm_device_attr_get(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
+				    GICV5_ITS_IDR1, &attr);
+	TEST_ASSERT(!ret && attr == val, "GICv5 ITS_REGS IDR1 restore mismatch");
+	attr = (val & ~GICV5_ITS_IDR1_DEVICEID_BITS) |
+		FIELD_PREP(GICV5_ITS_IDR1_DEVICEID_BITS, 17);
+	ret = __kvm_device_attr_set(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
+				    GICV5_ITS_IDR1, &attr);
+	TEST_ASSERT(ret && errno == EINVAL, "GICv5 ITS_REGS accepted bad IDR1");
+	attr = val | BIT(11);
+	ret = __kvm_device_attr_set(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
+				    GICV5_ITS_IDR1, &attr);
+	TEST_ASSERT(ret && errno == EINVAL, "GICv5 ITS_REGS accepted IDR1 reserved bit");
+
+	ret = __kvm_device_attr_get(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
+				    GICV5_ITS_IDR2, &val);
+	TEST_ASSERT(!ret, "GICv5 ITS_REGS get IDR2 failed");
+	val = (val & ~GICV5_ITS_IDR2_EVENTID_BITS) |
+	      FIELD_PREP(GICV5_ITS_IDR2_EVENTID_BITS, 8);
+	ret = __kvm_device_attr_set(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
+				    GICV5_ITS_IDR2, &val);
+	TEST_ASSERT(!ret, "GICv5 ITS_REGS rejected IDR2 restore");
+	ret = __kvm_device_attr_get(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
+				    GICV5_ITS_IDR2, &attr);
+	TEST_ASSERT(!ret && attr == val, "GICv5 ITS_REGS IDR2 restore mismatch");
+	attr = val | GICV5_ITS_IDR2_XDMN_EVENTS;
+	ret = __kvm_device_attr_set(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
+				    GICV5_ITS_IDR2, &attr);
+	TEST_ASSERT(ret && errno == EINVAL, "GICv5 ITS_REGS accepted XDMN events");
+	attr = (val & ~GICV5_ITS_IDR2_EVENTID_BITS) |
+		FIELD_PREP(GICV5_ITS_IDR2_EVENTID_BITS, 17);
+	ret = __kvm_device_attr_set(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
+				    GICV5_ITS_IDR2, &attr);
+	TEST_ASSERT(ret && errno == EINVAL, "GICv5 ITS_REGS accepted bad IDR2");
+	attr = val | BIT(7);
+	ret = __kvm_device_attr_set(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
+				    GICV5_ITS_IDR2, &attr);
+	TEST_ASSERT(ret && errno == EINVAL, "GICv5 ITS_REGS accepted IDR2 reserved bit");
+
+	/* Userspace can restore the complete read-event result. */
+	val = GICV5_ITS_READ_EVENT_DATAR_VIRT |
+	      GICV5_ITS_READ_EVENT_DATAR_VALID |
+	      FIELD_PREP(GICV5_ITS_READ_EVENT_DATAR_VM_ID, 0x1234) |
+	      FIELD_PREP(GICV5_ITS_READ_EVENT_DATAR_LPI_ID, 0x12345);
+	ret = __kvm_device_attr_set(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
+				    GICV5_ITS_READ_EVENT_DATAR, &val);
+	TEST_ASSERT(!ret, "GICv5 ITS_REGS rejected READ_EVENT_DATAR restore");
+	ret = __kvm_device_attr_get(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
+				    GICV5_ITS_READ_EVENT_DATAR, &attr);
+	TEST_ASSERT(!ret && attr == val,
+		    "GICv5 ITS_REGS READ_EVENT_DATAR restore mismatch");
+
+	/* DT_BASER uses a full-width userspace access. */
+	val = BIT_ULL(40) | BIT_ULL(16);
+	ret = __kvm_device_attr_set(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
+				    GICV5_ITS_DT_BASER, &val);
+	TEST_ASSERT(!ret, "GICv5 ITS_REGS rejected DT_BASER update");
+	ret = __kvm_device_attr_get(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
+				    GICV5_ITS_DT_BASER, &attr);
+	TEST_ASSERT(!ret && attr == val,
+		    "GICv5 ITS_REGS DT_BASER update mismatch");
+
+	/* Check setting and getting an out-of-range offset */
+	attr = GICV5_ITS_SIZE;
+	ret = __kvm_has_device_attr(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
+				    attr);
+	TEST_ASSERT(ret && errno == ENXIO, "GICv5 ITS_REGS accepted bad offset");
+
+	ret = __kvm_device_attr_get(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
+				    attr, &val);
+	TEST_ASSERT(ret && errno == ENXIO, "GICv5 ITS_REGS get bad offset");
+
+	/* Check (mis)alignment */
+	attr = GICV5_ITS_IDR0 + 2;
+	ret = __kvm_has_device_attr(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
+				    attr);
+	TEST_ASSERT(ret && errno == EINVAL,
+		    "GICv5 ITS_REGS accepted unaligned 32-bit attr");
+
+	attr = GICV5_ITS_DT_BASER + 4;
+	ret = __kvm_has_device_attr(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
+				    attr);
+	TEST_ASSERT(ret && errno == EINVAL,
+		    "GICv5 ITS_REGS accepted unaligned 64-bit attr");
+
+	/* Fail to provide attr pointer */
+	ret = __kvm_device_attr_get(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
+				    GICV5_ITS_IDR0, NULL);
+	TEST_ASSERT(ret && errno == EFAULT, "GICv5 ITS_REGS get with bad pointer");
+
+	ret = __kvm_device_attr_set(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
+				    GICV5_ITS_IDR0, NULL);
+	TEST_ASSERT(ret && errno == EFAULT, "GICv5 ITS_REGS set with bad pointer");
+
+	/* Make sure we can restore the vITS's enable state */
+	val = GICV5_ITS_CR0_ITSEN;
+	ret = __kvm_device_attr_set(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
+				    GICV5_ITS_CR0, &val);
+	TEST_ASSERT(!ret, "GICv5 ITS_REGS failed to enable ITS");
+	ret = __kvm_device_attr_get(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
+				    GICV5_ITS_CR0, &attr);
+	TEST_ASSERT(!ret && (attr & GICV5_ITS_CR0_ITSEN),
+		    "GICv5 ITS_REGS did not enable ITS");
+
+	/* And DT CFGR/BASER */
+	val = FIELD_PREP(GICV5_ITS_DT_CFGR_DEVICEID_BITS, 8);
+	ret = __kvm_device_attr_set(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
+				    GICV5_ITS_DT_CFGR, &val);
+	TEST_ASSERT(!ret, "GICv5 ITS_REGS rejected enabled DT_CFGR update");
+	ret = __kvm_device_attr_get(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
+				    GICV5_ITS_DT_CFGR, &attr);
+	TEST_ASSERT(!ret && attr == val,
+		    "GICv5 ITS_REGS DT_CFGR restore mismatch");
+
+	val = 0;
+	ret = __kvm_device_attr_set(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
+				    GICV5_ITS_DT_BASER, &val);
+	TEST_ASSERT(!ret, "GICv5 ITS_REGS rejected enabled DT_BASER update");
+	ret = __kvm_device_attr_get(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
+				    GICV5_ITS_DT_BASER, &val);
+	TEST_ASSERT(!ret && !val, "GICv5 ITS_REGS DT_BASER restore mismatch");
+
+	vm_gic_destroy(&v);
+
+	vm_gic_init(&v);
+	v.vm = __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
+	v.gic_fd = kvm_create_device(v.vm, v.gic_dev_type);
+	v.its_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V5_ITS);
+
+	/* The registers exist before setting the ITS address. */
+	ret = __kvm_has_device_attr(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
+				    GICV5_ITS_IDR0);
+	TEST_ASSERT(!ret, "GICv5 ITS_REGS missing without ITS base");
+
+	/* Accessing them still requires the ITS address. */
+	val = 0;
+	ret = __kvm_device_attr_get(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
+				    GICV5_ITS_IDR0, &val);
+	TEST_ASSERT(ret && errno == ENXIO,
+		    "GICv5 ITS_REGS get accepted without ITS base");
+	ret = __kvm_device_attr_set(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
+				    GICV5_ITS_IDR0, &val);
+	TEST_ASSERT(ret && errno == ENXIO,
+		    "GICv5 ITS_REGS set accepted without ITS base");
+
+	vm_gic_destroy(&v);
+}
+
 static void test_vgic_v5_ist_attrs(void)
 {
 	struct kvm_vgic_v5_ist ist_attr;
@@ -1296,7 +1632,7 @@ static void test_vgic_v5_ist_attrs(void)
 	u64 attr;
 	int ret;
 
-	v.gic_dev_type = KVM_DEV_TYPE_ARM_VGIC_V5;
+	vm_gic_init(&v);
 	v.vm = __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
 	v.gic_fd = kvm_create_device(v.vm, v.gic_dev_type);
 	vcpu = vm_vcpu_add(v.vm, 0, NULL);
@@ -1383,6 +1719,7 @@ static void test_vgic_v5_ist_attrs(void)
 	vm_gic_destroy(&v);
 
 	/* IST restore is rejected after the VM has run. */
+	vm_gic_init(&v);
 	v.vm = __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
 	v.gic_fd = kvm_create_device(v.vm, v.gic_dev_type);
 	vcpu = vm_vcpu_add(v.vm, 0, guest_code);
@@ -1411,7 +1748,7 @@ static void test_vgic_v5_userspace_ppis_attrs(void)
 	u64 user_ppis[2];
 	int ret;
 
-	v.gic_dev_type = KVM_DEV_TYPE_ARM_VGIC_V5;
+	vm_gic_init(&v);
 	v.vm = __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
 	v.gic_fd = kvm_create_device(v.vm, v.gic_dev_type);
 	vcpu = vm_vcpu_add(v.vm, 0, NULL);
@@ -1452,7 +1789,7 @@ static void test_vgic_v5_cpu_sysreg_attrs(void)
 	u64 attr, val;
 	int ret, i;
 
-	v.gic_dev_type = KVM_DEV_TYPE_ARM_VGIC_V5;
+	vm_gic_init(&v);
 	v.vm = __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
 	v.gic_fd = kvm_create_device(v.vm, v.gic_dev_type);
 	vcpu = vm_vcpu_add(v.vm, 0, NULL);
@@ -1544,7 +1881,7 @@ static void test_vgic_v5_sparse_vcpu_ids(void)
 	struct vm_gic v;
 	u64 attr;
 
-	v.gic_dev_type = KVM_DEV_TYPE_ARM_VGIC_V5;
+	vm_gic_init(&v);
 	v.vm = __vm_create(VM_SHAPE_DEFAULT, VGIC_V5_SPARSE_NR_VCPUS, 0);
 	v.gic_fd = kvm_create_device(v.vm, v.gic_dev_type);
 
@@ -1588,6 +1925,7 @@ static void test_vgic_v5_ppis(u32 gic_dev_type)
 	uint64_t attr;
 	int ret, i;
 
+	vm_gic_init(&v);
 	v.gic_dev_type = gic_dev_type;
 	v.vm = __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
 
@@ -1983,6 +2321,7 @@ int test_kvm_device(u32 gic_dev_type)
 	struct vm_gic v;
 	int ret;
 
+	vm_gic_init(&v);
 	v.vm = vm_create_with_vcpus(NR_VCPUS, guest_code, vcpus);
 
 	/* try to create a non existing KVM device */
@@ -2046,6 +2385,9 @@ void run_tests(u32 gic_dev_type)
 	pr_info("Test VGICv5 IRS_REGS attrs\n");
 	test_vgic_v5_irs_regs_attrs();
 
+	pr_info("Test VGICv5 ITS attrs\n");
+	test_vgic_v5_its_attrs();
+
 	pr_info("Test VGICv5 IST attrs\n");
 	test_vgic_v5_ist_attrs();
 
diff --git a/tools/testing/selftests/kvm/include/arm64/gic_v5.h b/tools/testing/selftests/kvm/include/arm64/gic_v5.h
index 2d455515563e0..2e4472489601c 100644
--- a/tools/testing/selftests/kvm/include/arm64/gic_v5.h
+++ b/tools/testing/selftests/kvm/include/arm64/gic_v5.h
@@ -13,6 +13,8 @@
 /* GIC component base address is guest PA space */
 #define GICV5_IRS_CONFIG_BASE_GPA	0x8000000ULL
 #define GICV5_IRS_CONFIG_BASE_GVA	((volatile void *)GICV5_IRS_CONFIG_BASE_GPA)
+#define GICV5_ITS_BASE_GPA		0x8030000ULL
+#define GICV5_ITS_BASE_GVA		((volatile void *)GICV5_ITS_BASE_GPA)
 
 #define GICV5_IRS_SIZE			0x20000
 #define GICV5_IRS_ALIGN			0x10000
@@ -74,6 +76,75 @@
 #define GICV5_IRS_SWERR_SYNDROMER0	0x03c8
 #define GICV5_IRS_SWERR_SYNDROMER1	0x03d0
 
+/*
+ * ITS register offsets and fields used by the GICv5 ITS selftests.
+ */
+#define GICV5_ITS_IDR0			0x0000
+#define GICV5_ITS_IDR1			0x0004
+#define GICV5_ITS_IDR2			0x0008
+#define GICV5_ITS_IIDR			0x0040
+#define GICV5_ITS_AIDR			0x0044
+#define GICV5_ITS_CR0			0x0080
+#define GICV5_ITS_CR1			0x0084
+#define GICV5_ITS_DT_BASER		0x00c0
+#define GICV5_ITS_DT_CFGR		0x00d0
+#define GICV5_ITS_DIDR			0x0100
+#define GICV5_ITS_EIDR			0x0108
+#define GICV5_ITS_INV_EVENTR		0x010c
+#define GICV5_ITS_INV_DEVICER		0x0110
+#define GICV5_ITS_READ_EVENTR		0x0114
+#define GICV5_ITS_READ_EVENT_DATAR	0x0118
+#define GICV5_ITS_STATUSR		0x0120
+#define GICV5_ITS_SYNCR			0x0140
+#define GICV5_ITS_SYNC_STATUSR		0x0148
+#define GICV5_ITS_GEN_EVENT_DIDR	0x0180
+#define GICV5_ITS_GEN_EVENT_EIDR	0x0188
+#define GICV5_ITS_GEN_EVENTR		0x018c
+#define GICV5_ITS_GEN_EVENT_STATUSR	0x0190
+#define GICV5_ITS_MEC_IDR		0x01c0
+#define GICV5_ITS_MEC_MECID_R		0x01c4
+#define GICV5_ITS_MPAM_IDR		0x0200
+#define GICV5_ITS_MPAM_PARTID_R		0x0204
+#define GICV5_ITS_SWERR_STATUSR		0x0240
+#define GICV5_ITS_SWERR_SYNDROMER0	0x0248
+#define GICV5_ITS_SWERR_SYNDROMER1	0x0250
+#define GICV5_ITS_MPAM_PMGR		0x0258
+#define GICV5_ITS_TRANSLATER		0x10000
+#define GICV5_ITS_RL_TRANSLATER		0x10008
+
+#define GICV5_ITS_SIZE			0x20000
+#define GICV5_ITS_ALIGN			0x10000
+#define GICV5_ITS_IDR0_ITSID		GENMASK(31, 16)
+#define GICV5_ITS_IDR0_SWE		BIT(8)
+#define GICV5_ITS_IDR0_PA_RANGE		GENMASK(5, 2)
+#define GICV5_ITS_IDR0_DOM		GENMASK(1, 0)
+#define GICV5_ITS_IDR0_DOMAIN_SECURE	0b00
+#define GICV5_ITS_IDR1_DEVICEID_BITS	GENMASK(5, 0)
+#define GICV5_ITS_IDR2_XDMN_EVENTS	GENMASK(6, 5)
+#define GICV5_ITS_IDR2_EVENTID_BITS	GENMASK(4, 0)
+
+#define GICV5_ITS_CR0_ITSEN		BIT(0)
+#define GICV5_ITS_DT_BASER_ADDR_MASK	GENMASK_ULL(55, 3)
+#define GICV5_ITS_DT_BASER_ADDR_SHIFT	3ULL
+#define GICV5_ITS_DT_CFGR_STRUCTURE	BIT(16)
+#define GICV5_ITS_DT_CFGR_L2SZ		GENMASK(7, 6)
+#define GICV5_ITS_DT_CFGR_DEVICEID_BITS	GENMASK(5, 0)
+#define GICV5_ITS_DIDR_DEVICEID		GENMASK_ULL(31, 0)
+#define GICV5_ITS_EIDR_EVENTID		GENMASK(15, 0)
+#define GICV5_ITS_INV_EVENTR_I		BIT(31)
+#define GICV5_ITS_INV_EVENTR_ITT_L2SZ	GENMASK(2, 1)
+#define GICV5_ITS_INV_EVENTR_L1		BIT(0)
+#define GICV5_ITS_INV_DEVICER_I		BIT(31)
+#define GICV5_ITS_INV_DEVICER_EVENTID_BITS GENMASK(5, 1)
+#define GICV5_ITS_INV_DEVICER_L1	BIT(0)
+#define GICV5_ITS_READ_EVENT_DATAR_VIRT	BIT_ULL(63)
+#define GICV5_ITS_READ_EVENT_DATAR_VM_ID GENMASK_ULL(47, 32)
+#define GICV5_ITS_READ_EVENT_DATAR_VALID BIT_ULL(31)
+#define GICV5_ITS_READ_EVENT_DATAR_LPI_ID GENMASK_ULL(23, 0)
+#define GICV5_ITS_STATUSR_IDLE		BIT(0)
+#define GICV5_ITS_SYNC_STATUSR_IDLE	BIT(0)
+#define GICV5_ITS_GEN_EVENT_STATUSR_IDLE BIT(0)
+
 #define GICV5_IRS_IDR0_SETLPI		BIT(9)
 #define GICV5_IRS_IDR0_INT_DOM		GENMASK(1, 0)
 #define GICV5_IRS_IDR0_INT_DOM_SECURE		0b00
-- 
2.34.1

