Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9548039A800
	for <kvmarm@lists.linux.dev>; Mon, 10 Aug 2026 06:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786344761; cv=none; b=fOunfmEgDSyoqO8x4gnSKPUebp6plN5WDG4/fI9fO4o3/vZNGSxtUZpcUnoglGz9EvLZMqJpFN9AMFgVhoNmtRC6ic+LoQNRQ9E4Xob7OQPsKMTSoPpnO6kJuijSgk8BA1Uemxf44xzpgjK5dUBHOAtR0i/QZ1yD+hyV6ytDezY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786344761; c=relaxed/simple;
	bh=J1h/VWHxwOYhzoUmA4coJqUbPUJQg3qvABZR8N3qWrI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=S5QoAogpkjIeTrl1nNrD4QI/cskSMEDlzPVWRzaHC8gaaifRNafHK+aUbys/9PSfcIudS1PsXyswBrdr4WqlGkchdzN5jSH9SmlW1T2W9NWHk11sh2Imss677jCSzGiUKBWCC6Dxlr8n8De4TY0b9naIYfUcxGIS30i5CyjpqZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BjNexTZ8; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BjNexTZ8"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4954a9e8490so21588385e9.1
        for <kvmarm@lists.linux.dev>; Sun, 09 Aug 2026 23:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786344758; x=1786949558; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bFy+Qxh8OeuJq/9T2myZ48PAmPlx9sX4LAljRqn7fVg=;
        b=BjNexTZ8SA1FZIggZX6XDOq5p5aEZnBP3wIvfSQyjyZxnDcTmmOF8WPEojUq5bsc4x
         /IaS5/3Fo0ADteN5q+xsGSr8Cz0jhFruPHVsZpc/XI0dUbRJivqo4mSk7nDaH9BxqNmj
         pu2nSOPsEYAUYrlRONZYJHPRSa8bnqTkrgPSRWHE/SI8yEaDkYPv9j+mPWB+4nQLFUBc
         34QOd/WSMv+c9XFKwAEZBG3WQek871VBtr71P9BXtN/zDcanYZUXz+uaHlKffJC0u75J
         2Ppp/w/0RVxtjiRRLq0PvLRliEbNDOU66m6conIBYetqrX3RAHZoRhAltmcBPFYbk3Ka
         aniw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786344758; x=1786949558;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bFy+Qxh8OeuJq/9T2myZ48PAmPlx9sX4LAljRqn7fVg=;
        b=Azu4z/DcWpljb5VEYLxxbZQF4vypFMTzGX1EDhLug5pEhgKhwc2nhKKIAr6bEX4bZ+
         UI7+tZnL8Km6QJeYb0zyVOUH1Th2HM7pKqj8RHgF6Us1q8gZKaSwJaxoIEgcjSZmgCyQ
         TIvn5YGYRDjykYNwUcBNFnBnuTwm3ogFneKiICre+e6rk923+ud6OEW/IAp59ZxbPGsd
         auODtKZcpVygdv8j4aaDsvAPQWxds3Lfbj7ENvbmM0NcG/zCWJfTTbYodMjpm7iE5nEc
         /63VbrxYsCBx71T78ezUkustOm67DymiZsH099EVLPb2ePLdXycrUUW4VbUt4zPd7uXe
         U67Q==
X-Forwarded-Encrypted: i=1; AHgh+RqsFj3I0pLM6lzPR5o4uA7d/P1s+9eGujI+bLFFYaacqubF0k4ARFpmJQJc0D6ggZ/qLe3jbvc=@lists.linux.dev
X-Gm-Message-State: AOJu0YyShlCDD3UwGO//6g/Bn883JMFOcV7UuYcivyMIFTD8k66Ecr1m
	107bamOglxpDcSz4AcI9EQcqvpg2OtyzKEsAKKi+F3DVh1L5TfJp7fdf
X-Gm-Gg: AR+sD113TrNLpAVgRBlag2gnB1h/InToq26fjXId2jP0rOP2FteSTn/cViJ6TN/qCCl
	zHLM1qTv7OG+cQ3i3a/hwA/O+ki0UgO9OdjmQOYVTG1CWV0lrIlPaVDKNz3RuVMhDl76pEHHIBk
	sTqdj99Ed3h0s7nmcfKo55iGZxdvwQqs12FOI4U1EseflmD4pbKJLNkbx2Prb70QzaExnUyU0LG
	5kXdC4bza4kpTGFr8xbxKSxBq+yDALp/01cdHaVScwY6Whhvnagwgp3lyPnbGD1z/SC5yBavRcv
	viYr4l5KiIzv8nNG0nCWcfqvcMHZBzivMvRi2H/dHZ5Ph9sGXhHNBcqUyw830pYHR+EjcLI+hn3
	/E8LCvKdpzp3yxbHV5+dz7n2n36U/3LDhteD/uJFshhUY2DquOoGsn0DFKHArq8M27hxs79Fw6a
	Scg9J7dJ9X6vgZM79gF6m0wUjch55kgEuUpu52R1VWetMp/PLI+OnDItLsndSbxCBLSu3271daL
	tkctvgw4qDjuA6br2Y5oZ7MnnMl/vQ2ceK3LAyIP88JnpFLOYLYB4uZSPFDSTXXImV385H7D/9z
	N1imDrncWh7dvzT/vLMyx7gslMS7UMIRzUx8kLBaEmYh9iNn/vAplpjYTLQY1tA3tase5wCb3dg
	IGQ==
X-Received: by 2002:a05:600c:3154:b0:495:3bc6:d381 with SMTP id 5b1f17b1804b1-49962453c45mr186359385e9.2.1786344757658;
        Sun, 09 Aug 2026 23:52:37 -0700 (PDT)
Received: from MBP-von-Karl.localdomain (dynamic-2a02-3100-a1e8-7401-78b1-a175-5d13-e92e.310.pool.telefonica.de. [2a02:3100:a1e8:7401:78b1:a175:5d13:e92e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4995420c68fsm358800705e9.1.2026.08.09.23.52.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 09 Aug 2026 23:52:37 -0700 (PDT)
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
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [RFC PATCH 2/2] KVM: arm64: selftests: Test VGICv3 redistributor region retry
Date: Mon, 10 Aug 2026 08:52:17 +0200
Message-Id: <1cf282aec3fff31e89bdb98f636b7027afcf129a.1786344511.git.kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <cover.1786344511.git.kmehltretter@gmail.com>
References: <cover.1786344511.git.kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The existing redistributor-region test already adds valid partial
regions, rejects a later region that collides with the distributor, and
retries with a valid region. Its guest code does not access a
redistributor, so it misses redistributor MMIO bus entries lost by the
failed rollback.

Run a guest that reads GICR_TYPER from the second redistributor in the
original region and verifies its processor number. Put the test layout
outside the default guest memory slot so an absent iodev results in a
KVM_EXIT_MMIO instead of an ordinary RAM access.

Allow the common VGIC setup helper to select the guest entry point so the
retry case can reuse the normal test setup.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 tools/testing/selftests/kvm/arm64/vgic_init.c | 115 +++++++++++++-----
 1 file changed, 86 insertions(+), 29 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_init.c b/tools/testing/selftests/kvm/arm64/vgic_init.c
index 47e34b43afb29..8b321a1409b34 100644
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
@@ -13,12 +14,23 @@
 
 #include "test_util.h"
 #include "kvm_util.h"
+#include "gic.h"
 #include "processor.h"
+#include "ucall_common.h"
 #include "vgic.h"
 #include "gic_v3.h"
 
 #define NR_VCPUS		4
 
+/* Keep the redistributor range outside the default guest memory slot. */
+#define REDIST_TEST_REGION0_BASE	GICR_BASE_GPA
+#define REDIST_TEST_REGION1_BASE	\
+	(REDIST_TEST_REGION0_BASE + 2 * KVM_VGIC_V3_REDIST_SIZE)
+#define REDIST_TEST_DIST_BASE	\
+	(REDIST_TEST_REGION1_BASE + KVM_VGIC_V3_REDIST_SIZE)
+#define REDIST_TEST_REGION2_BASE	\
+	(REDIST_TEST_DIST_BASE + KVM_VGIC_V3_DIST_SIZE)
+
 #define REG_OFFSET(vcpu, offset) (((u64)vcpu << 32) | offset)
 
 #define VGIC_DEV_IS_V2(_d) ((_d) == KVM_DEV_TYPE_ARM_VGIC_V2)
@@ -65,6 +77,16 @@ static void guest_code(void)
 	GUEST_DONE();
 }
 
+static void guest_read_second_redist(void)
+{
+	u64 typer = readq((void *)(unsigned long)(REDIST_TEST_REGION0_BASE +
+						   KVM_VGIC_V3_REDIST_SIZE +
+						   GICR_TYPER));
+
+	GUEST_ASSERT_EQ(GICR_TYPER_CPU_NUMBER(typer), 1);
+	GUEST_DONE();
+}
+
 /* we don't want to assert on run execution, hence that helper */
 static int run_vcpu(struct kvm_vcpu *vcpu)
 {
@@ -73,12 +95,13 @@ static int run_vcpu(struct kvm_vcpu *vcpu)
 
 static struct vm_gic vm_gic_create_with_vcpus(u32 gic_dev_type,
 					      u32 nr_vcpus,
+					      void (*guest_fn)(void),
 					      struct kvm_vcpu *vcpus[])
 {
 	struct vm_gic v;
 
 	v.gic_dev_type = gic_dev_type;
-	v.vm = vm_create_with_vcpus(nr_vcpus, guest_code, vcpus);
+	v.vm = vm_create_with_vcpus(nr_vcpus, guest_fn, vcpus);
 	v.gic_fd = kvm_create_device(v.vm, gic_dev_type);
 
 	return v;
@@ -240,38 +263,40 @@ static void subtest_v3_redist_regions(struct vm_gic *v)
 				    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr);
 	TEST_ASSERT(ret && errno == EINVAL, "redist region attr value with count== 0");
 
-	addr = REDIST_REGION_ATTR_ADDR(2, 0x200000, 0, 1);
+	addr = REDIST_REGION_ATTR_ADDR(2, REDIST_TEST_REGION0_BASE, 0, 1);
 	ret = __kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 				    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr);
 	TEST_ASSERT(ret && errno == EINVAL,
 		    "attempt to register the first rdist region with index != 0");
 
-	addr = REDIST_REGION_ATTR_ADDR(2, 0x201000, 0, 1);
+	addr = REDIST_REGION_ATTR_ADDR(2, REDIST_TEST_REGION0_BASE + 0x1000,
+				       0, 1);
 	ret = __kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 				    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr);
 	TEST_ASSERT(ret && errno == EINVAL, "rdist region with misaligned address");
 
-	addr = REDIST_REGION_ATTR_ADDR(2, 0x200000, 0, 0);
+	addr = REDIST_REGION_ATTR_ADDR(2, REDIST_TEST_REGION0_BASE, 0, 0);
 	kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 			    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr);
 
-	addr = REDIST_REGION_ATTR_ADDR(2, 0x200000, 0, 1);
+	addr = REDIST_REGION_ATTR_ADDR(2, REDIST_TEST_REGION0_BASE, 0, 1);
 	ret = __kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 				    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr);
 	TEST_ASSERT(ret && errno == EINVAL, "register an rdist region with already used index");
 
-	addr = REDIST_REGION_ATTR_ADDR(1, 0x210000, 0, 2);
+	addr = REDIST_REGION_ATTR_ADDR(1, REDIST_TEST_REGION0_BASE + 0x10000,
+				       0, 2);
 	ret = __kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 				    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr);
 	TEST_ASSERT(ret && errno == EINVAL,
 		    "register an rdist region overlapping with another one");
 
-	addr = REDIST_REGION_ATTR_ADDR(1, 0x240000, 0, 2);
+	addr = REDIST_REGION_ATTR_ADDR(1, REDIST_TEST_REGION1_BASE, 0, 2);
 	ret = __kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 				    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr);
 	TEST_ASSERT(ret && errno == EINVAL, "register redist region with index not +1");
 
-	addr = REDIST_REGION_ATTR_ADDR(1, 0x240000, 0, 1);
+	addr = REDIST_REGION_ATTR_ADDR(1, REDIST_TEST_REGION1_BASE, 0, 1);
 	kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 			    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr);
 
@@ -288,7 +313,7 @@ static void subtest_v3_redist_regions(struct vm_gic *v)
 	TEST_ASSERT(ret && errno == E2BIG,
 		    "register redist region with top address beyond IPA range");
 
-	addr = 0x260000;
+	addr = REDIST_TEST_DIST_BASE;
 	ret = __kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 				    KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr);
 	TEST_ASSERT(ret && errno == EINVAL,
@@ -296,19 +321,19 @@ static void subtest_v3_redist_regions(struct vm_gic *v)
 
 	/*
 	 * Now there are 2 redist regions:
-	 * region 0 @ 0x200000 2 redists
-	 * region 1 @ 0x240000 1 redist
+	 * region 0 has 2 redistributors
+	 * region 1 has 1 redistributor
 	 * Attempt to read their characteristics
 	 */
 
 	addr = REDIST_REGION_ATTR_ADDR(0, 0, 0, 0);
-	expected_addr = REDIST_REGION_ATTR_ADDR(2, 0x200000, 0, 0);
+	expected_addr = REDIST_REGION_ATTR_ADDR(2, REDIST_TEST_REGION0_BASE, 0, 0);
 	ret = __kvm_device_attr_get(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 				    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr);
 	TEST_ASSERT(!ret && addr == expected_addr, "read characteristics of region #0");
 
 	addr = REDIST_REGION_ATTR_ADDR(0, 0, 0, 1);
-	expected_addr = REDIST_REGION_ATTR_ADDR(1, 0x240000, 0, 1);
+	expected_addr = REDIST_REGION_ATTR_ADDR(1, REDIST_TEST_REGION1_BASE, 0, 1);
 	ret = __kvm_device_attr_get(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 				    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr);
 	TEST_ASSERT(!ret && addr == expected_addr, "read characteristics of region #1");
@@ -318,11 +343,11 @@ static void subtest_v3_redist_regions(struct vm_gic *v)
 				    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr);
 	TEST_ASSERT(ret && errno == ENOENT, "read characteristics of non existing region");
 
-	addr = 0x260000;
+	addr = REDIST_TEST_DIST_BASE;
 	kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 			    KVM_VGIC_V3_ADDR_TYPE_DIST, &addr);
 
-	addr = REDIST_REGION_ATTR_ADDR(1, 0x260000, 0, 2);
+	addr = REDIST_REGION_ATTR_ADDR(1, REDIST_TEST_DIST_BASE, 0, 2);
 	ret = __kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 				    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr);
 	TEST_ASSERT(ret && errno == EINVAL, "register redist region colliding with dist");
@@ -338,7 +363,7 @@ static void test_vgic_then_vcpus(u32 gic_dev_type)
 	struct vm_gic v;
 	int ret, i;
 
-	v = vm_gic_create_with_vcpus(gic_dev_type, 1, vcpus);
+	v = vm_gic_create_with_vcpus(gic_dev_type, 1, guest_code, vcpus);
 
 	subtest_dist_rdist(&v);
 
@@ -359,7 +384,8 @@ static void test_vcpus_then_vgic(u32 gic_dev_type)
 	struct vm_gic v;
 	int ret;
 
-	v = vm_gic_create_with_vcpus(gic_dev_type, NR_VCPUS, vcpus);
+	v = vm_gic_create_with_vcpus(gic_dev_type, NR_VCPUS, guest_code,
+				     vcpus);
 
 	subtest_dist_rdist(&v);
 
@@ -403,6 +429,29 @@ static void test_v2_uaccess_cpuif_no_vcpus(void)
 	vm_gic_destroy(&v);
 }
 
+static void run_vcpu_expect_done(struct kvm_vcpu *vcpu)
+{
+	struct ucall uc;
+
+	vcpu_run(vcpu);
+
+	switch (get_ucall(vcpu, &uc)) {
+	case UCALL_DONE:
+		return;
+	case UCALL_ABORT:
+		REPORT_GUEST_ASSERT(uc);
+		break;
+	case UCALL_NONE:
+		if (vcpu->run->exit_reason == KVM_EXIT_MMIO)
+			TEST_FAIL("Unexpected MMIO exit at 0x%llx",
+				  vcpu->run->mmio.phys_addr);
+		fallthrough;
+	default:
+		TEST_FAIL("Unexpected ucall %lu, exit_reason %u",
+			  uc.cmd, vcpu->run->exit_reason);
+	}
+}
+
 static void test_v3_new_redist_regions(void)
 {
 	struct kvm_vcpu *vcpus[NR_VCPUS];
@@ -411,7 +460,8 @@ static void test_v3_new_redist_regions(void)
 	u64 addr;
 	int ret;
 
-	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS, vcpus);
+	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS,
+				     guest_code, vcpus);
 	subtest_v3_redist_regions(&v);
 	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
 			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
@@ -420,12 +470,13 @@ static void test_v3_new_redist_regions(void)
 	TEST_ASSERT(ret == -ENXIO, "running without sufficient number of rdists");
 	vm_gic_destroy(&v);
 
-	/* step2 */
+	/* Step 2: adding enough redistributors after KVM_RUN is rejected. */
 
-	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS, vcpus);
+	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS,
+				     guest_code, vcpus);
 	subtest_v3_redist_regions(&v);
 
-	addr = REDIST_REGION_ATTR_ADDR(1, 0x280000, 0, 2);
+	addr = REDIST_REGION_ATTR_ADDR(1, REDIST_TEST_REGION2_BASE, 0, 2);
 	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 			    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr);
 
@@ -434,9 +485,10 @@ static void test_v3_new_redist_regions(void)
 
 	vm_gic_destroy(&v);
 
-	/* step 3 */
+	/* Step 3: retry the failed region setup and exercise an existing rdist. */
 
-	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS, vcpus);
+	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS,
+				     guest_read_second_redist, vcpus);
 	subtest_v3_redist_regions(&v);
 
 	ret = __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
@@ -444,15 +496,17 @@ static void test_v3_new_redist_regions(void)
 	TEST_ASSERT(ret && errno == EFAULT,
 		    "register a third region allowing to cover the 4 vcpus");
 
-	addr = REDIST_REGION_ATTR_ADDR(1, 0x280000, 0, 2);
+	addr = REDIST_REGION_ATTR_ADDR(1, REDIST_TEST_REGION2_BASE, 0, 2);
 	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 			    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr);
 
+	virt_map(v.vm, REDIST_TEST_REGION0_BASE, REDIST_TEST_REGION0_BASE,
+		 vm_calc_num_guest_pages(v.vm->mode,
+					 2 * KVM_VGIC_V3_REDIST_SIZE));
 	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
 			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
 
-	ret = run_vcpu(vcpus[3]);
-	TEST_ASSERT(!ret, "vcpu run");
+	run_vcpu_expect_done(vcpus[0]);
 
 	vm_gic_destroy(&v);
 }
@@ -608,7 +662,8 @@ static void test_v3_redist_ipa_range_check_at_vcpu_run(void)
 	int ret, i;
 	u64 addr;
 
-	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, 1, vcpus);
+	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, 1,
+				     guest_code, vcpus);
 
 	/* Set space for 3 redists, we have 1 vcpu, so this succeeds. */
 	addr = max_phys_size - (3 * 2 * 0x10000);
@@ -641,7 +696,8 @@ static void test_v3_its_region(void)
 	u64 addr;
 	int its_fd, ret;
 
-	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS, vcpus);
+	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS,
+				     guest_code, vcpus);
 	its_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_ITS);
 
 	addr = 0x401000;
@@ -684,7 +740,8 @@ static void test_v3_nassgicap(void)
 	u32 typer2;
 	int ret;
 
-	vm = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS, vcpus);
+	vm = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS,
+				      guest_code, vcpus);
 	kvm_device_attr_get(vm.gic_fd, KVM_DEV_ARM_VGIC_GRP_DIST_REGS,
 			    GICD_TYPER2, &typer2);
 	has_nassgicap = typer2 & GICD_TYPER2_nASSGIcap;
-- 
2.53.0

