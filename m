Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 262814E781A
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 16:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792166404; cv=none; b=Pu8EvEJQScCv0WUX+fs4rc5dfnEpw6aKCet4BFca4/WFfFAUDCEUUqWtvAXaeC45St3dw44uaGtY4NdkG2kBnB6bNQ1e7QYC1yrFTo5mUSD1E1kL0imraFu7sabev/mCWRgBNkVRX9og7xCyqMl3WTbUN73dj5xsCCPRMK1W92s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792166404; c=relaxed/simple;
	bh=u5/KZKIHA8y62rQQ1Rpijsg+k1sPz3TWetni1OPIk14=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HjJO/L5YY7N8e+kbiNcV+9t6Ptj1ZUr0QRamGv8iJF+WFjMB5oRQ8AFdhmQS6lhXsBywhG0k8N+o1RyPisNcFySeb8rJ5mo38u7k0PkM0vp5V1FVP0F9j0NErnywH6Qp5jBVoM1zBwEI6UE13Btj81a7jgYKDEX/lsdHPEJMJWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=S/ae/Lz9; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="S/ae/Lz9"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7EB181516;
	Fri, 16 Oct 2026 08:59:59 -0700 (PDT)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1CCD63F673;
	Fri, 16 Oct 2026 09:00:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792166402; bh=u5/KZKIHA8y62rQQ1Rpijsg+k1sPz3TWetni1OPIk14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S/ae/Lz9Cs/fwv8XMGKGgZcY16qYgPsScAtxKCn2HnfGFKbxN0ZAYG6Hf7pSOU6dc
	 oWOKmYJ/ZFxKzkireJkU+o3RDARxTIdvTv6x57bYrfnc7gqXqnps18EZaRfyL4VX1p
	 T50Uh6ZrnWWtJ8P2kE2X06RUBHKTlcVCHCJAE9mA=
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
Subject: [PATCH 14/16] KVM: selftests: Add VGICv5 ITS attribute tests
Date: Fri, 16 Oct 2026 16:57:39 +0100
Message-Id: <20261016155741.979985-15-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261016155741.979985-1-sascha.bischoff@arm.com>
References: <20261016155741.979985-1-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
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
bad userspace pointers and idle status register values. Also
initialise the shared VM wrapper so non-ITS tests safely ignore the
optional ITS fd during cleanup.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 tools/testing/selftests/kvm/arm64/vgic_v5.c   | 251 +++++++++++++++++-
 .../selftests/kvm/include/arm64/gic_v5.h      |  60 +++++
 2 files changed, 300 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/selftests/kvm/arm64/vgic_v5.c
index d5df742b23001..b7fb002a64f6c 100644
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
@@ -1287,6 +1339,177 @@ static void test_vgic_v5_irs_regs_attrs(void)
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
+
+	/* And DT CFGR/BASER */
+	val = 0;
+	ret = __kvm_device_attr_set(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
+				    GICV5_ITS_DT_CFGR, &val);
+	TEST_ASSERT(!ret, "GICv5 ITS_REGS rejected enabled DT_CFGR update");
+	ret = __kvm_device_attr_get(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
+				    GICV5_ITS_DT_CFGR, &val);
+	TEST_ASSERT(!ret && !val, "GICv5 ITS_REGS DT_CFGR restore mismatch");
+
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
+	/* Try to access MMIO before setting ITS address */
+	ret = __kvm_has_device_attr(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
+				    GICV5_ITS_IDR0);
+	TEST_ASSERT(ret && errno == ENXIO,
+		    "GICv5 ITS_REGS accepted without ITS base");
+
+	val = 0;
+	ret = __kvm_device_attr_get(v.its_fd, KVM_DEV_ARM_VGIC_GRP_ITS_REGS,
+				    GICV5_ITS_IDR0, &val);
+	TEST_ASSERT(ret && errno == ENXIO,
+		    "GICv5 ITS_REGS get accepted without ITS base");
+
+	vm_gic_destroy(&v);
+}
+
 static void test_vgic_v5_ist_attrs(void)
 {
 	struct kvm_vgic_v5_ist ist_attr;
@@ -1296,7 +1519,7 @@ static void test_vgic_v5_ist_attrs(void)
 	u64 attr;
 	int ret;
 
-	v.gic_dev_type = KVM_DEV_TYPE_ARM_VGIC_V5;
+	vm_gic_init(&v);
 	v.vm = __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
 	v.gic_fd = kvm_create_device(v.vm, v.gic_dev_type);
 	vcpu = vm_vcpu_add(v.vm, 0, NULL);
@@ -1383,6 +1606,7 @@ static void test_vgic_v5_ist_attrs(void)
 	vm_gic_destroy(&v);
 
 	/* IST restore is rejected after the VM has run. */
+	vm_gic_init(&v);
 	v.vm = __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
 	v.gic_fd = kvm_create_device(v.vm, v.gic_dev_type);
 	vcpu = vm_vcpu_add(v.vm, 0, guest_code);
@@ -1411,7 +1635,7 @@ static void test_vgic_v5_userspace_ppis_attrs(void)
 	u64 user_ppis[2];
 	int ret;
 
-	v.gic_dev_type = KVM_DEV_TYPE_ARM_VGIC_V5;
+	vm_gic_init(&v);
 	v.vm = __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
 	v.gic_fd = kvm_create_device(v.vm, v.gic_dev_type);
 	vcpu = vm_vcpu_add(v.vm, 0, NULL);
@@ -1452,7 +1676,7 @@ static void test_vgic_v5_cpu_sysreg_attrs(void)
 	u64 attr, val;
 	int ret, i;
 
-	v.gic_dev_type = KVM_DEV_TYPE_ARM_VGIC_V5;
+	vm_gic_init(&v);
 	v.vm = __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
 	v.gic_fd = kvm_create_device(v.vm, v.gic_dev_type);
 	vcpu = vm_vcpu_add(v.vm, 0, NULL);
@@ -1544,7 +1768,7 @@ static void test_vgic_v5_sparse_vcpu_ids(void)
 	struct vm_gic v;
 	u64 attr;
 
-	v.gic_dev_type = KVM_DEV_TYPE_ARM_VGIC_V5;
+	vm_gic_init(&v);
 	v.vm = __vm_create(VM_SHAPE_DEFAULT, VGIC_V5_SPARSE_NR_VCPUS, 0);
 	v.gic_fd = kvm_create_device(v.vm, v.gic_dev_type);
 
@@ -1588,6 +1812,7 @@ static void test_vgic_v5_ppis(u32 gic_dev_type)
 	uint64_t attr;
 	int ret, i;
 
+	vm_gic_init(&v);
 	v.gic_dev_type = gic_dev_type;
 	v.vm = __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
 
@@ -1983,6 +2208,7 @@ int test_kvm_device(u32 gic_dev_type)
 	struct vm_gic v;
 	int ret;
 
+	vm_gic_init(&v);
 	v.vm = vm_create_with_vcpus(NR_VCPUS, guest_code, vcpus);
 
 	/* try to create a non existing KVM device */
@@ -2014,6 +2240,9 @@ void run_tests(u32 gic_dev_type)
 	pr_info("Test VGICv5 IRS_REGS attrs\n");
 	test_vgic_v5_irs_regs_attrs();
 
+	pr_info("Test VGICv5 ITS attrs\n");
+	test_vgic_v5_its_attrs();
+
 	pr_info("Test VGICv5 IST attrs\n");
 	test_vgic_v5_ist_attrs();
 
diff --git a/tools/testing/selftests/kvm/include/arm64/gic_v5.h b/tools/testing/selftests/kvm/include/arm64/gic_v5.h
index 2d455515563e0..22ab78626af5a 100644
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
@@ -74,6 +76,64 @@
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
+
+#define GICV5_ITS_CR0_IDLE		BIT(1)
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
+#define GICV5_ITS_STATUSR_IDLE		BIT(0)
+#define GICV5_ITS_SYNC_STATUSR_IDLE	BIT(0)
+#define GICV5_ITS_GEN_EVENT_STATUSR_IDLE BIT(0)
+
 #define GICV5_IRS_IDR0_SETLPI		BIT(9)
 #define GICV5_IRS_IDR0_INT_DOM		GENMASK(1, 0)
 #define GICV5_IRS_IDR0_INT_DOM_SECURE		0b00
-- 
2.34.1

