Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87973C4B72
	for <kvmarm@lists.linux.dev>; Sat, 22 Aug 2026 09:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787392453; cv=none; b=T3QinkljBKQ94C7ABOXhJHT2X8KUStokBEW43nw02hGbJDCw2Zs7olM4lya7JYDlmRA8osSu4EZ0MN70b5QA0HFaUuPNXF7+pUq/ifO2DlIxoF/8zJdOgVrzzPqBg2Idge3u2Q6qIfHCA6GfRCDfMxSYuhc/ynkBukowmggWKeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787392453; c=relaxed/simple;
	bh=rv7xXdolg6NQjjtjnJt7VT86OJEL0RCm3VxCHe4ILRc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ozpgokxbm92BACJQ+ycaCLwocCPJUgIFZAOYNxXBJWnOMoO8OpULNXNpK3CJsETazjeluHnactXBPpYeIxqE3jI8nCEMVJAWcOK9YWaHuHccDvFk9iA9L9sJvRgdwcpkO+GPAw16Pn8fPAA+xgMDP6m79UJsM6U6X//4++Bg/ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=er1di644; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="er1di644"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-698ae09e356so2840926a12.2
        for <kvmarm@lists.linux.dev>; Sat, 22 Aug 2026 02:54:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787392446; x=1787997246; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1GYqiFSBk6xbMl7ANfKl+0h07k1nsbqa00/KuNdgbGU=;
        b=er1di644tEartRiBeAg58aBZJnl9jk12MY/Vp9GM9X54mxns4qOTqQRZ6OiMWfN4mU
         YHd5QgDwQ+P9t1ZRV6LffoCddOHHL0Ja9hAch/prhf/BMe16zB3OoBZ9ArpWJ8jNiipZ
         dY3pH2S6ubM+nPBRfeBTWSUSBZtkATVp5FLMEvDfgJAYATLIV/7o1ItTeXqZhu7AoPef
         9yI9GWVAKw8wggmXWcKHBnRnpiHDy/VFbKJ9TudEBK/sKRD+lIDsJonFOI5yI3BBpid1
         AolFRCJ/A66c+EE/xpWkASNCJz2UmZkg8aa9LGm5mBTEpS2xWp9hOrCdh14+Ybth1RlS
         Hp9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787392446; x=1787997246;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1GYqiFSBk6xbMl7ANfKl+0h07k1nsbqa00/KuNdgbGU=;
        b=r55dsVwhPSB5tcFEz9CdOg4akHGk4OzHLeYwOQyKlq7lcAVTJqCQ5TUlnoz+ndXM1P
         IjK5y5gmhWOyu6GcGIAwoW+Nt234BXR2LZFongQEiV5D5U6bv6qrKRaVfgHNdkmEb9XO
         tmrqe5oJprR2or/bdz2a/3Xnp95ogZ3HGFbiWfvTh1ZHTjj6tqSaLVIy/ntG7mC3iNj/
         Jw+tfY3sgTgRUSdcIXJL2TNXXS7xmVw31ms0kIKbdq0ccyQpvXSpndjEIwTve6kEdn36
         iM1CC4CuPeuKwc9PaGj1VaOhYeBsSKlPkn7HcoKOeja4nH9kdU6JYRTK9pBgU8FRexih
         G+0Q==
X-Forwarded-Encrypted: i=1; AHgh+RrtKswKIrNb5UgLo1fpojJ6LfrdKWnlpaPJx0DSdSHvG+DjSoVGB0JucU+TOyU6TqG/WCWP61E=@lists.linux.dev
X-Gm-Message-State: AFuF++nfLZooudPa0okG7pVgvk3wHh5V7aKwGnGqY0y6X/T14xnL0cvq
	d8TdXsurElrp7iQAHIhEjJxfSDoptuvQrL6M1OEmjYnau0CmD9k/Z4Ec
X-Gm-Gg: AR+sD13FjnHMDUTS28PSzuAktStxjUunkdYPpkyAA0qBZRq1pFoGY2I8dPfp2YVjVWY
	+r8VgcgN5IbiEHeOGiomBUpWeLNtnbulAEDk19A5KeR5TzPIcJVV8nZDfRGpaApfr5YtFMHg1Dc
	q/0rWrvCA+BgS8R7+Y7vjt4ri6BVUnDC2plVPfyX2lR2ob98WOWeYkzvypCXONXXz/WapwY9Ybl
	sOhZVY9Ms9pb+B6mQTJd58jlY7652qUFhbQ1iPIoW7NtK5w4A18U8549MubCBxbY2PUCU2Sepzm
	745bc8EiiKdXfSMWXxHZMHu42ZQ3mZlwx2mguoGcSmBxOG1lVzgn0fDpENiLYhZbIlioa/SfMv5
	H85trzvbdYbcy1tuaw/NNDC9jE4P0FaPCUceEh8iaGYwYm1z63phqxQTXXDGsOhEa8ahkazqQEm
	R3uhu0/sNNTtpqjEEOR5wDWNKNMe9WG6eRnQOFkFHUjsgPHqTFy+ScZsc4Oz8kLjfLz3Enn5wCy
	ULbRqFqID4ZRjAefFuSYmUicmD3pKKSssgfO55yeuyT2HPfO1u2OtyIJ/MS6DSqkIcqKCUNzwkU
	VNBtPCdPVyYuMzJ739jgatn+DJWZybAtHDOyn/hYhnb0L06EdNgd4vsbIrrslkdeaUUC
X-Received: by 2002:a05:6402:42c4:b0:6a3:e813:8457 with SMTP id 4fb4d7f45d1cf-6a42f1f9e90mr13698572a12.12.1787392446101;
        Sat, 22 Aug 2026 02:54:06 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a0f5-8c01-3de3-cd62-aa6f-2fb0.310.pool.telefonica.de. [2a02:3100:a0f5:8c01:3de3:cd62:aa6f:2fb0])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a3ff0c327asm11151586a12.8.2026.08.22.02.54.04
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 22 Aug 2026 02:54:05 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
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
Subject: [PATCH v3 5/5] KVM: arm64: selftests: Test VGICv3 redistributor region retry
Date: Sat, 22 Aug 2026 11:53:46 +0200
Message-Id: <20260822095346.53882-6-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260822095346.53882-1-kmehltretter@gmail.com>
References: <20260822095346.53882-1-kmehltretter@gmail.com>
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
 tools/testing/selftests/kvm/arm64/vgic_init.c | 92 +++++++++++++++++++
 1 file changed, 92 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_init.c b/tools/testing/selftests/kvm/arm64/vgic_init.c
index 84aa97204b7f..5a30f3cb039b 100644
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
@@ -65,6 +75,23 @@ static void guest_code(void)
 	GUEST_DONE();
 }
 
+static void guest_check_redist_retry(void)
+{
+	unsigned int i;
+
+	/* The first three redistributors span adjacent regions 0 and 1. */
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
@@ -462,6 +489,70 @@ static void test_v3_new_redist_regions(void)
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
@@ -986,6 +1077,7 @@ void run_tests(u32 gic_dev_type)
 
 	if (VGIC_DEV_IS_V3(gic_dev_type)) {
 		test_v3_new_redist_regions();
+		test_v3_redist_region_retry();
 		test_v3_typer_accesses();
 		test_v3_last_bit_redist_regions();
 		test_v3_last_bit_single_rdist();
-- 
2.39.5 (Apple Git-154)

