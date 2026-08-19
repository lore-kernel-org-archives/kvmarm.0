Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43BA3EF0D7
	for <kvmarm@lists.linux.dev>; Wed, 19 Aug 2026 22:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787179394; cv=none; b=foZNnHhber0xZf0e5jKBNDAdC71FxdBv7+6fN2PHpNFmhX8zYBIEOMT50wfAgWW91lNUcWidctwJp1aDrD2Sl8UFahm3cQpJF+ZQQnxDjyw0VihxH5VsN4CBVrHuTyzxgmIbKpFF3irZDY9D8wVtXCFSjZ6C0LwLD/DucS3sAas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787179394; c=relaxed/simple;
	bh=JsaezUgZuqyAGhX1M6QEu1MJ3MJycvUa7dNttqCPacs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Vq5N91iqouOWkHkRJOSjSH73hhtSGdux2qUEuDLUni13yNcS/vyvhXBz5UpWUz2ygBc4wuVmk+rGtcaFZKA9nP6micAAWJJQ6C3t8Fm2N93X1cmFLjCJnoXUG0NvJbeHxIWZykKLsxUQuSt49Cbt+C3NcTCjLLNsxsa146BJbXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OkJAW/bc; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OkJAW/bc"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-47fe377a217so920404f8f.1
        for <kvmarm@lists.linux.dev>; Wed, 19 Aug 2026 15:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787179391; x=1787784191; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8yRbZXjon4rpFYxflr/N9botiLzLz0TZjPgpbneMm6g=;
        b=OkJAW/bckLHCKWyUgpOz363eqHUflkKQzR0kyO7DsaDREY8BUTMefkfghUCeTT+mGH
         OXNk2OFBadOTgNUM7Vvpb5LdFXwbPwTCG65XV3DIFrs48lCaxWvUDi4Est7C3NJ5dDAW
         vpPLrYJ1ZdVU5+GDEMYliHrh65uptdwR5HvgOUwR4vIXbmh76CGXlPUPKM8EHI2+uyvC
         cjNhg2tKEpO/NDGlB+X/X5O2sbWaJ14OUp7HAaUNx/HMV3lHu2qb1ooJ1dtKItwl0CuO
         deYvlGfVcUA5X2bw9r16ic0iC29wckvCElI7T8VpG4XAzMVZmm+aN/Z0fhNa1V5E+hfG
         +U4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787179391; x=1787784191;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8yRbZXjon4rpFYxflr/N9botiLzLz0TZjPgpbneMm6g=;
        b=fDTJXFStyP+XCuYwDg8Ux7h3Dt/OA5SS3aB5Q/stfbgG0TyMXEEI4q+NXosAWxR2uY
         sEmutM8HesjopTakOshM8iIBjyE5g2A7LoBWHzfmG5pMY4wP4poKAmP8AGHCZTOQPllq
         tmwR//FHMpqbbxw1YHsroNrtquG0r0AaLYIR6tKG5Ucn/fVRmBJ3XgH4/2ZthPJjQIFg
         E3GTO6+otZbGDFcm4PTW6rd5suaqRl5w6Bv3L8xUwYw7TjYrg4CWfcG0btGQOong50xN
         DvMIdzZ3CdHhZXatj1CRs4GBsViom62elI/ivh+5mM2gWGR1q6OJ40An/gR27MfBK5S4
         fOhA==
X-Forwarded-Encrypted: i=1; AHgh+Rp9od4jVoa1VH6HbGhnJGnQN657SppkCFOaja/+txW1ro6KTjDNa5Wec6eAfMVu/UX210T8t08=@lists.linux.dev
X-Gm-Message-State: AFuF++lAp7Eh0M1diqTko+8YyAJONDTjVjgvhJVexDzK7IWZstr916/m
	PXIrdvAqaLSErO/X9W/fT4h6fhd+i2XC2rgyp9QHyR+3B0gA6+lFtL8X
X-Gm-Gg: AR+sD13MtrBghkKqywOtVbifTE+z6Eb7T+vRmEbs4l7RWyIXrM1XhTGOkwMVs5kvRzs
	FeYOjZDVNiHUsL71aMe7RSQ4cLiBrrhTJmuIJrmb0c6M3po6igMVmpdqv65lH83p92matH6AhFE
	rKfvS4bFS8tUmagKEo5DaPlftIF+JZWE545EOA9NwzYjNrigURpm6Mnu6yZIIHYvx9yS0a6U7Vz
	bQY7BMVNW/kyLtPyvUQO5+dCVOET+OGJP3qhsDLsa6GaNnNZ/2aiBvfETKfnDUoZAYsgpW+/x37
	HnbDW4GN9wjyaGQ+TQR/ens8uPB/WCTfAPG5pU/6UgSKmArNFy1F4gRNWBIG+H3G60omc8Yu2q4
	A5ey8MCeSzMLl0vUbkpKY5XZm7sIvTW6f5ncLqmL3R0rKV4djDazh9Bo2B0mbjcYHcYn1Fth48D
	JTf+w4oWGhaLZxwvDXpXZ7cW0ss6b1E3DkUN8TrxCoMvP2SuaYhSblEBAcQYv7Jyzw7BykmFfQT
	cCQOTgRAfUvlXQIi6WaYOJHaS+a54JDYg0dcHQxKe3c3sByzk7tMrdz1xmpJ/zfjgyKuVo7avJL
	8evZTTp1li8+rW05iB7ruh46iU1h1VT4MuhjWLdeKng0vO1O4LTG6WiGEehENFQgeIc=
X-Received: by 2002:a05:6000:715:b0:47f:86d5:d1d7 with SMTP id ffacd0b85a97d-482b1e957b9mr16809030f8f.6.1787179391108;
        Wed, 19 Aug 2026 15:43:11 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-ae9e-1d01-58d3-443d-4fa6-01cd.310.pool.telefonica.de. [2a02:3100:ae9e:1d01:58d3:443d:4fa6:1cd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482b1450e61sm8553317f8f.13.2026.08.19.15.43.09
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 19 Aug 2026 15:43:10 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v2 5/5] KVM: arm64: selftests: Test VGICv3 redistributor region retry
Date: Thu, 20 Aug 2026 00:42:29 +0200
Message-Id: <20260819224229.82948-6-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260819224229.82948-1-kmehltretter@gmail.com>
References: <20260819224229.82948-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A failed REDIST_REGION write can remove redistributor iodevs without
clearing their cached vCPU assignments. A retry then skips those
assignments and leaves the redistributors absent from the MMIO bus.

Create two partial regions, reject a third region that overlaps the
distributor, and retry at a valid address. After initializing the VGIC,
have the guest read GICR_TYPER from all four redistributors and check their
processor numbers. This verifies the final configuration without assuming
that assignments survive the failed write.

Keep the redistributor IPAs outside the guest RAM memslot and install only
the stage-1 mappings needed for the MMIO accesses. If an iodev is missing,
KVM_RUN therefore exits with KVM_EXIT_MMIO. Without the fix, the first
redistributor access exits at 0x8030008.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 tools/testing/selftests/kvm/arm64/vgic_init.c | 91 +++++++++++++++++++
 1 file changed, 91 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_init.c b/tools/testing/selftests/kvm/arm64/vgic_init.c
index 91484fd4f786..6d9998c764bc 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_init.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_init.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2020, Red Hat, Inc.
  */
 #include <linux/kernel.h>
+#include <linux/sizes.h>
 #include <sys/syscall.h>
 #include <asm/kvm.h>
 #include <asm/kvm_para.h>
@@ -13,12 +14,21 @@
 
 #include "test_util.h"
 #include "kvm_util.h"
+#include "gic.h"
 #include "processor.h"
 #include "vgic.h"
 #include "gic_v3.h"
 
 #define NR_VCPUS		4
 
+#define REDIST_RETRY_REGION0_BASE	GICR_BASE_GPA
+#define REDIST_RETRY_REGION1_BASE	\
+	(REDIST_RETRY_REGION0_BASE + 2 * KVM_VGIC_V3_REDIST_SIZE)
+#define REDIST_RETRY_DIST_BASE		\
+	(REDIST_RETRY_REGION1_BASE + KVM_VGIC_V3_REDIST_SIZE)
+#define REDIST_RETRY_REGION2_BASE	\
+	(REDIST_RETRY_DIST_BASE + KVM_VGIC_V3_DIST_SIZE)
+
 #define REG_OFFSET(vcpu, offset) (((u64)vcpu << 32) | offset)
 
 #define VGIC_DEV_IS_V2(_d) ((_d) == KVM_DEV_TYPE_ARM_VGIC_V2)
@@ -65,6 +75,22 @@ static void guest_code(void)
 	GUEST_DONE();
 }
 
+static void guest_check_redist_retry(void)
+{
+	unsigned int i;
+
+	for (i = 0; i < NR_VCPUS; i++) {
+		u64 base = i < 3 ? REDIST_RETRY_REGION0_BASE +
+				       i * KVM_VGIC_V3_REDIST_SIZE :
+				       REDIST_RETRY_REGION2_BASE;
+		u64 typer = readq((void *)(unsigned long)(base + GICR_TYPER));
+
+		GUEST_ASSERT_EQ(GICR_TYPER_CPU_NUMBER(typer), i);
+	}
+
+	GUEST_DONE();
+}
+
 /* we don't want to assert on run execution, hence that helper */
 static int run_vcpu(struct kvm_vcpu *vcpu)
 {
@@ -462,6 +488,70 @@ static void test_v3_new_redist_regions(void)
 	vm_gic_destroy(&v);
 }
 
+static void test_v3_redist_region_retry(void)
+{
+	struct kvm_vcpu *vcpus[NR_VCPUS];
+	struct vm_gic v;
+	struct ucall uc;
+	u64 addr;
+	int ret;
+
+	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS,
+				     guest_check_redist_retry, vcpus);
+
+	addr = REDIST_REGION_ATTR_ADDR(2, REDIST_RETRY_REGION0_BASE, 0, 0);
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr);
+
+	addr = REDIST_REGION_ATTR_ADDR(1, REDIST_RETRY_REGION1_BASE, 0, 1);
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr);
+
+	addr = REDIST_RETRY_DIST_BASE;
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			    KVM_VGIC_V3_ADDR_TYPE_DIST, &addr);
+
+	addr = REDIST_REGION_ATTR_ADDR(1, REDIST_RETRY_DIST_BASE, 0, 2);
+	ret = __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION,
+				    &addr);
+	TEST_ASSERT(ret && errno == EINVAL,
+		    "register redist region colliding with dist");
+
+	addr = REDIST_REGION_ATTR_ADDR(1, REDIST_RETRY_REGION2_BASE, 0, 2);
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr);
+
+	virt_map(v.vm, REDIST_RETRY_REGION0_BASE, REDIST_RETRY_REGION0_BASE,
+		 vm_calc_num_guest_pages(v.vm->mode,
+					 3 * KVM_VGIC_V3_REDIST_SIZE));
+	virt_map(v.vm, REDIST_RETRY_REGION2_BASE, REDIST_RETRY_REGION2_BASE,
+		 vm_calc_num_guest_pages(v.vm->mode,
+					 KVM_VGIC_V3_REDIST_SIZE));
+
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
+
+	vcpu_run(vcpus[0]);
+	switch (get_ucall(vcpus[0], &uc)) {
+	case UCALL_DONE:
+		break;
+	case UCALL_ABORT:
+		REPORT_GUEST_ASSERT(uc);
+		break;
+	case UCALL_NONE:
+		if (vcpus[0]->run->exit_reason == KVM_EXIT_MMIO)
+			TEST_FAIL("Unexpected MMIO exit at 0x%llx",
+				  vcpus[0]->run->mmio.phys_addr);
+		fallthrough;
+	default:
+		TEST_FAIL("Unexpected ucall %lu, exit_reason %u",
+			  uc.cmd, vcpus[0]->run->exit_reason);
+	}
+
+	vm_gic_destroy(&v);
+}
+
 static void test_v3_typer_accesses(void)
 {
 	struct vm_gic v;
@@ -986,6 +1076,7 @@ void run_tests(u32 gic_dev_type)
 
 	if (VGIC_DEV_IS_V3(gic_dev_type)) {
 		test_v3_new_redist_regions();
+		test_v3_redist_region_retry();
 		test_v3_typer_accesses();
 		test_v3_last_bit_redist_regions();
 		test_v3_last_bit_single_rdist();
-- 
2.39.5 (Apple Git-154)
