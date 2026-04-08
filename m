Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59BCE2E8DE3;
	Wed,  8 Apr 2026 11:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775647991; cv=none; b=BVsTbHACt1XsBCm4fFmUuYy3QfoIXJXDaFC0q5Ji3qx7hbu6Uhc1GvJa80EMtiKTYldFU0Bo/qnJl/9dgWqy1wPb/qCZnc2fJ5LnFnGftzuHCOB/VmpNR+nYNnKG3ihufBIMFYi0bFYjPZZFgcXY3KkOCswGYBZG9c8PsZTBlig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775647991; c=relaxed/simple;
	bh=DacAqcfduWyj/aS4RWnHzMEY/lLoTlC8K+I0m3gZm0Y=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A+iVEhYUvrKUnELJXHPmv/xy6xme6CHLybSyzlUvMj65aEMH8f/fLZdlhRwWMM19MvNxWyKj3JzZAydmGCc0bRMpt43x48GKsOOKC9Az8eD5fYVbsnfmz9sDCh2h79OCsn3XHVQ4NLwAw6gOIWYcaWe/RdX8ZFITkci16G/jLWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jlFbUY2u; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jlFbUY2u"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:To:From:Reply-To:
	Cc:Content-Type:Content-ID:Content-Description;
	bh=bcqQMrxxKYQUXqVeEJ+byVUBupaFtS4CPNzU+VH1H1I=; b=jlFbUY2uPjHD3z2+ZnIseMILF9
	ybd8LlT6ceMuU0QiFqh4Dp7Zrw1D6x5jE1Sx7FxryK/6VJl2BxH6hLsAPVPyJrNno9OavwThoxW2m
	ODN7hmdHa790+VkUjye7t+rh6eea2E30aO+D8b8XTvi0uAIl+hgi+3EPJPMLyX0mfTAu5TjgfF8q5
	wR3naSEbbt6Z8RpKISuu/JLPKc5p+wPdbtulyJGr5IgqTyKoGT1MQVLSsMIk1hMvUXnIl4dgnCfds
	VBrLLqZk2dgV+CnPxDJsJTVpBzZhNvdi8Jd2oHaU+R1jAzOTaYyhB3cbvbLrlKMU1gYMeBSTUd6jC
	VhvTIE5w==;
Received: from [2001:8b0:10b:1::425] (helo=i7.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wAR9V-00000005Iet-2y5o;
	Wed, 08 Apr 2026 11:32:57 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wAR9V-00000008nAG-2507;
	Wed, 08 Apr 2026 12:32:57 +0100
From: David Woodhouse <dwmw2@infradead.org>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Eric Auger <eric.auger@redhat.com>,
	Kees Cook <kees@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Nathan Chancellor <nathan@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v2 5/5] KVM: arm64: selftests: Add GICv2 IGROUPR writability test
Date: Wed,  8 Apr 2026 12:30:36 +0100
Message-ID: <20260408113256.2095505-6-dwmw2@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260408113256.2095505-1-dwmw2@infradead.org>
References: <20260408113256.2095505-1-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

From: David Woodhouse <dwmw@amazon.co.uk>

Test that GICv2 IGROUPR writability is consistently gated by the IIDR
implementation revision for both guest and userspace paths:

  Default (no IIDR write): implementation_rev defaults to 3, groups
    writable from both guest and userspace.
  Rev 1: IGROUPR reads as zero (group 0), writes ignored from both
    guest and userspace.
  Rev 2: IGROUPR is writable from both guest and userspace.

This test requires GICv2 emulation support (GICv3 with GICv2 compat
CPU interface) and will be skipped on hardware without it.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/arm64/vgic_group_v2.c       | 168 ++++++++++++++++++
 2 files changed, 169 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/arm64/vgic_group_v2.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index df729a70124f..878d7cb92555 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -178,6 +178,7 @@ TEST_GEN_PROGS_arm64 += arm64/vgic_init
 TEST_GEN_PROGS_arm64 += arm64/vgic_irq
 TEST_GEN_PROGS_arm64 += arm64/vgic_lpi_stress
 TEST_GEN_PROGS_arm64 += arm64/vgic_group_iidr
+TEST_GEN_PROGS_arm64 += arm64/vgic_group_v2
 TEST_GEN_PROGS_arm64 += arm64/vpmu_counter_access
 TEST_GEN_PROGS_arm64 += arm64/no-vgic-v3
 TEST_GEN_PROGS_arm64 += arm64/idreg-idst
diff --git a/tools/testing/selftests/kvm/arm64/vgic_group_v2.c b/tools/testing/selftests/kvm/arm64/vgic_group_v2.c
new file mode 100644
index 000000000000..6d4bad44bae7
--- /dev/null
+++ b/tools/testing/selftests/kvm/arm64/vgic_group_v2.c
@@ -0,0 +1,168 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * vgic_group_v2.c - Test GICv2 IGROUPR behaviour across IIDR revisions
+ *
+ * Validate that the GICD_IIDR implementation revision controls GICv2
+ * IGROUPR writability for both guest and userspace:
+ *   Default (no IIDR write): groups writable (implementation_rev defaults to 3)
+ *   Rev 1: IGROUPR reads as zero (group 0), writes ignored
+ *   Rev 2: IGROUPR is guest and userspace configurable
+ */
+#include <linux/sizes.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+#include "gic.h"
+#include "gic_v3.h"
+#include "vgic.h"
+
+#define NR_IRQS		64
+
+#define V2_DIST_BASE	0x8000000ULL
+#define V2_CPU_BASE	0x8010000ULL
+#define V2_DIST_GVA	((volatile void *)V2_DIST_BASE)
+
+#define SPI_IGROUPR	(GICD_IGROUPR + (32 / 32) * 4)
+
+static uint64_t shared_rev;
+static uint64_t guest_result;
+
+static void guest_code(void)
+{
+	uint32_t before, after;
+
+	before = readl(V2_DIST_GVA + SPI_IGROUPR);
+	writel(0x5a5a5a5a, V2_DIST_GVA + SPI_IGROUPR);
+	after = readl(V2_DIST_GVA + SPI_IGROUPR);
+
+	guest_result = ((uint64_t)before << 32) | after;
+	GUEST_DONE();
+}
+
+static int create_v2_gic(struct kvm_vm *vm)
+{
+	uint32_t nr_irqs = NR_IRQS;
+	uint64_t addr;
+	int gic_fd;
+
+	gic_fd = __kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V2);
+	if (gic_fd < 0)
+		return gic_fd;
+
+	addr = V2_DIST_BASE;
+	kvm_device_attr_set(gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			    KVM_VGIC_V2_ADDR_TYPE_DIST, &addr);
+	addr = V2_CPU_BASE;
+	kvm_device_attr_set(gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			    KVM_VGIC_V2_ADDR_TYPE_CPU, &addr);
+
+	virt_map(vm, V2_DIST_BASE, V2_DIST_BASE,
+		 vm_calc_num_guest_pages(vm->mode, SZ_64K));
+	virt_map(vm, V2_CPU_BASE, V2_CPU_BASE,
+		 vm_calc_num_guest_pages(vm->mode, SZ_64K));
+
+	kvm_device_attr_set(gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
+			    0, &nr_irqs);
+	return gic_fd;
+}
+
+static void run_test(int set_iidr_rev)
+{
+	struct kvm_vcpu *vcpus[1];
+	struct kvm_vm *vm;
+	struct ucall uc;
+	uint32_t before, after, igroupr, iidr;
+	int gic_fd;
+	bool expect_writable;
+
+	if (set_iidr_rev >= 0)
+		pr_info("Testing GICv2 IIDR revision %d\n", set_iidr_rev);
+	else
+		pr_info("Testing GICv2 IIDR default (no write)\n");
+
+	test_disable_default_vgic();
+	vm = vm_create_with_vcpus(1, guest_code, vcpus);
+
+	gic_fd = create_v2_gic(vm);
+	TEST_REQUIRE(gic_fd >= 0);
+
+	if (set_iidr_rev >= 0) {
+		kvm_device_attr_get(gic_fd, KVM_DEV_ARM_VGIC_GRP_DIST_REGS,
+				    GICD_IIDR, &iidr);
+		iidr &= ~GICD_IIDR_REVISION_MASK;
+		iidr |= set_iidr_rev << GICD_IIDR_REVISION_SHIFT;
+		kvm_device_attr_set(gic_fd, KVM_DEV_ARM_VGIC_GRP_DIST_REGS,
+				    GICD_IIDR, &iidr);
+	}
+
+	kvm_device_attr_set(gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
+
+	/*
+	 * Default (no IIDR write) gets implementation_rev=3 from vgic_init(),
+	 * so groups should be writable. Rev 1 = not writable. Rev 2+ = writable.
+	 */
+	expect_writable = (set_iidr_rev != 1);
+
+	/* Test userspace IGROUPR write */
+	igroupr = 0xa5a5a5a5;
+	kvm_device_attr_set(gic_fd, KVM_DEV_ARM_VGIC_GRP_DIST_REGS,
+			    SPI_IGROUPR, &igroupr);
+	igroupr = 0;
+	kvm_device_attr_get(gic_fd, KVM_DEV_ARM_VGIC_GRP_DIST_REGS,
+			    SPI_IGROUPR, &igroupr);
+
+	if (expect_writable)
+		TEST_ASSERT(igroupr == 0xa5a5a5a5,
+			    "Userspace write should succeed: got 0x%08x", igroupr);
+	else
+		TEST_ASSERT(igroupr == 0x00000000,
+			    "Userspace write should be ignored: got 0x%08x", igroupr);
+
+	/* Reset IGROUPR to 0 via userspace for rev 2+ before guest test */
+	if (expect_writable) {
+		igroupr = 0;
+		kvm_device_attr_set(gic_fd, KVM_DEV_ARM_VGIC_GRP_DIST_REGS,
+				    SPI_IGROUPR, &igroupr);
+	}
+
+	/* Test guest IGROUPR write */
+	sync_global_to_guest(vm, guest_result);
+	vcpu_run(vcpus[0]);
+
+	switch (get_ucall(vcpus[0], &uc)) {
+	case UCALL_ABORT:
+		REPORT_GUEST_ASSERT(uc);
+		break;
+	case UCALL_DONE:
+		break;
+	default:
+		TEST_FAIL("Unexpected ucall %lu", uc.cmd);
+	}
+
+	sync_global_from_guest(vm, guest_result);
+	before = guest_result >> 32;
+	after = guest_result & 0xffffffff;
+
+	TEST_ASSERT(before == 0x00000000,
+		    "Initial IGROUPR should be 0 (group 0): got 0x%08x", before);
+
+	if (expect_writable)
+		TEST_ASSERT(after == 0x5a5a5a5a,
+			    "Guest write should succeed: got 0x%08x", after);
+	else
+		TEST_ASSERT(after == 0x00000000,
+			    "Guest write should be ignored: got 0x%08x", after);
+
+	close(gic_fd);
+	kvm_vm_free(vm);
+}
+
+int main(int argc, char *argv[])
+{
+	run_test(-1);  /* default */
+	run_test(1);   /* rev 1 */
+	run_test(2);   /* rev 2 */
+	return 0;
+}
-- 
2.51.0

