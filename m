Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794214157;
	b=f6eFQUkkz9kRcJMWERBX9AopGBhadHTVHBMUNze1JRBe9Qf9W4wIaaQAclyIv04mq5tX
	 C9WthD5vqFl6QIiKljTGzX5itaLXoZHXcSHBZzTraKwOIU6YrnIyQoCxUJdtvYHn6iP04
	 kHpdSzdfiN3CPun/jpxx/cOVL0qsl7OpTlRjomnOnUs8+8MdtAaKwapKN6tGLtZJZcOcL
	 sYyROTh3JcVMTf9yKoqRYNgW0KO8IgtSioH1B6vkjp8eD4GIwr136y+iNU/+2QrtHGUlM
	 yYBUxcaC60BM6FaKGuowGHU1u4NmHhXYU1lYH27q/K1ABHasoR88U5AEnCOA36Q5Osg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794214157;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=zV83cBOy84RU8O9pg+oy+O4d35Nqre8Izu9ZB0pqdss=;
	b=rMxlPXMkYkvdVYcpNSbvhN+zPbWGsIDBKylwP1Und0q3i6dA6kNJZvcB2LuYPg3Lq04U
	 1vrdq2g5xRCBK5AEnTHpVwf2wdlepihEmEHfbYbgH12kauKahJuYF5L833nKpOHHIZzVa
	 bGY1XluAJWMHvqjwLjaVKAnqjFCDPueg6RCPaC2MhNgIOXR0T6nUTWRYwdfJRV3E4t8dO
	 23nIjE39F1W9EkXjWVbQKyS4fZat1kFeriuLHhv3urVUdKqLrQfzg8paZFq6CJL1RrBT+
	 sqSSVBWJY/tR5WmKGIEOAI0nFM9xbwdf0rh02g6oIUBrLTn/4dSYOI6v2xMHKe3P2+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="t/vDo6jt";
	arc=none smtp.remote-ip=91.218.175.15
Received: from mta0.migadu.com (out-15.mta0.migadu.com [91.218.175.15])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7441C606D818
	for <kvmarm@lists.linux.dev>; Mon,  9 Nov 2026 08:49:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7441C606D818
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=t/vDo6jt
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=uIZ6vQOatewDcLF1CVEzKXKmFmuT3AB0I9r88VqX4Hc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794214154; v=1; x=1794818954;
 b=t/vDo6jtjV9dL6z49wsYmqXOmYaE2AauwWqetG6T+DyFEzqi243y9hrY20ywHjXO+9rykJhM
 wohLpBRZp/jF+dDXE/CJgnibF3oWKksu9VRBwOjRxbAjepXt/NulZEOZ8LgHPgj1RjzWS8Mo8Wm
 CKly++lZRASmyLG4bpfVOJAM=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 1eec5c458fbcf882;
	Mon, 09 Nov 2026 08:49:14 +0000
X-Mizu-Trace-ID: 1eec5c458fbcf882
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 06/19] KVM: arm64: selftests: Add protected-VM boot trampoline
Date: Mon,  9 Nov 2026 08:48:41 +0000
Message-ID: <20261109084854.840576-7-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261109084854.840576-1-fuad.tabba@linux.dev>
References: <20261109084854.840576-1-fuad.tabba@linux.dev>
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

From: Will Deacon <will@kernel.org>

EL2 takes only PC and X0 from the host when it boots a protected vCPU,
and resets everything else. So the registers the selftest library sets
before the first run never reach the guest.

Boot a protected guest through a trampoline that restores X0-X7, seven
EL1 system registers and the stack pointer from a block X0 points to,
then enables the MMU and branches to the guest's entry point.

Signed-off-by: Will Deacon <will@kernel.org>
Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 tools/testing/selftests/kvm/Makefile.kvm      |  1 +
 .../selftests/kvm/include/arm64/pkvm.h        | 49 ++++++++++++++++
 .../selftests/kvm/lib/arm64/pvm-entry.S       | 57 +++++++++++++++++++
 3 files changed, 107 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/include/arm64/pkvm.h
 create mode 100644 tools/testing/selftests/kvm/lib/arm64/pvm-entry.S

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 17a4256e90819..c254e82f9a786 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -35,6 +35,7 @@ LIBKVM_arm64 += lib/arm64/gic_v3.c
 LIBKVM_arm64 += lib/arm64/gic_v3_its.c
 LIBKVM_arm64 += lib/arm64/handlers.S
 LIBKVM_arm64 += lib/arm64/processor.c
+LIBKVM_arm64 += lib/arm64/pvm-entry.S
 LIBKVM_arm64 += lib/arm64/spinlock.c
 LIBKVM_arm64 += lib/arm64/ucall.c
 LIBKVM_arm64 += lib/arm64/vgic.c
diff --git a/tools/testing/selftests/kvm/include/arm64/pkvm.h b/tools/testing/selftests/kvm/include/arm64/pkvm.h
new file mode 100644
index 0000000000000..29600342eca13
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/arm64/pkvm.h
@@ -0,0 +1,49 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2025 Google LLC
+ * Author: Will Deacon <will@kernel.org>
+ */
+
+#ifndef SELFTEST_KVM_ARM64_PKVM_H
+#define SELFTEST_KVM_ARM64_PKVM_H
+
+#ifndef __ASSEMBLER__
+/*
+ * Register state the boot trampoline (pvm-entry.S) restores. Only PC and X0
+ * survive to a protected guest's first run, so X0 points at this block.
+ */
+struct pvm_boot_args {
+	u64	jump_tgt;
+
+	u64	regs[8];
+	u64	cpacr_el1;
+	u64	sctlr_el1;
+	u64	tcr_el1;
+	u64	mair_el1;
+	u64	ttbr0_el1;
+	u64	vbar_el1;
+
+	u64	tpidr_el1;
+	u64	sp_el1;
+};
+#endif
+
+#define PVM_BOOT_ARGS_OFF_JUMP_TGT	0
+#define PVM_BOOT_ARGS_OFF_X0		(PVM_BOOT_ARGS_OFF_JUMP_TGT + 8)
+#define PVM_BOOT_ARGS_OFF_X1		(PVM_BOOT_ARGS_OFF_X0 + 8)
+#define PVM_BOOT_ARGS_OFF_X2		(PVM_BOOT_ARGS_OFF_X1 + 8)
+#define PVM_BOOT_ARGS_OFF_X3		(PVM_BOOT_ARGS_OFF_X2 + 8)
+#define PVM_BOOT_ARGS_OFF_X4		(PVM_BOOT_ARGS_OFF_X3 + 8)
+#define PVM_BOOT_ARGS_OFF_X5		(PVM_BOOT_ARGS_OFF_X4 + 8)
+#define PVM_BOOT_ARGS_OFF_X6		(PVM_BOOT_ARGS_OFF_X5 + 8)
+#define PVM_BOOT_ARGS_OFF_X7		(PVM_BOOT_ARGS_OFF_X6 + 8)
+#define PVM_BOOT_ARGS_OFF_CPACR_EL1	(PVM_BOOT_ARGS_OFF_X7 + 8)
+#define PVM_BOOT_ARGS_OFF_SCTLR_EL1	(PVM_BOOT_ARGS_OFF_CPACR_EL1 + 8)
+#define PVM_BOOT_ARGS_OFF_TCR_EL1	(PVM_BOOT_ARGS_OFF_SCTLR_EL1 + 8)
+#define PVM_BOOT_ARGS_OFF_MAIR_EL1	(PVM_BOOT_ARGS_OFF_TCR_EL1 + 8)
+#define PVM_BOOT_ARGS_OFF_TTBR0_EL1	(PVM_BOOT_ARGS_OFF_MAIR_EL1 + 8)
+#define PVM_BOOT_ARGS_OFF_VBAR_EL1	(PVM_BOOT_ARGS_OFF_TTBR0_EL1 + 8)
+#define PVM_BOOT_ARGS_OFF_TPIDR_EL1	(PVM_BOOT_ARGS_OFF_VBAR_EL1 + 8)
+#define PVM_BOOT_ARGS_OFF_SP_EL1	(PVM_BOOT_ARGS_OFF_TPIDR_EL1 + 8)
+
+#endif /* SELFTEST_KVM_ARM64_PKVM_H */
diff --git a/tools/testing/selftests/kvm/lib/arm64/pvm-entry.S b/tools/testing/selftests/kvm/lib/arm64/pvm-entry.S
new file mode 100644
index 0000000000000..d00abe03f8f84
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/arm64/pvm-entry.S
@@ -0,0 +1,57 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2025 Google LLC
+ * Author: Will Deacon <will@kernel.org>
+ */
+
+#include "pkvm.h"
+
+	.text
+	.balign 16
+	.globl	pvm_entry_start
+pvm_entry_start:
+	mov	x30, x0
+
+	ldr	x0, [x30, #PVM_BOOT_ARGS_OFF_X0]
+	ldr	x1, [x30, #PVM_BOOT_ARGS_OFF_X1]
+	ldr	x2, [x30, #PVM_BOOT_ARGS_OFF_X2]
+	ldr	x3, [x30, #PVM_BOOT_ARGS_OFF_X3]
+	ldr	x4, [x30, #PVM_BOOT_ARGS_OFF_X4]
+	ldr	x5, [x30, #PVM_BOOT_ARGS_OFF_X5]
+	ldr	x6, [x30, #PVM_BOOT_ARGS_OFF_X6]
+	ldr	x7, [x30, #PVM_BOOT_ARGS_OFF_X7]
+
+	ldr	x8, [x30, #PVM_BOOT_ARGS_OFF_JUMP_TGT]
+
+	ldr	x9, [x30, #PVM_BOOT_ARGS_OFF_CPACR_EL1]
+	msr	cpacr_el1, x9
+
+	ldr	x9, [x30, #PVM_BOOT_ARGS_OFF_TCR_EL1]
+	msr	tcr_el1, x9
+
+	ldr	x9, [x30, #PVM_BOOT_ARGS_OFF_MAIR_EL1]
+	msr	mair_el1, x9
+
+	ldr	x9, [x30, #PVM_BOOT_ARGS_OFF_TTBR0_EL1]
+	msr	ttbr0_el1, x9
+
+	ldr	x9, [x30, #PVM_BOOT_ARGS_OFF_VBAR_EL1]
+	msr	vbar_el1, x9
+
+	ldr	x9, [x30, #PVM_BOOT_ARGS_OFF_TPIDR_EL1]
+	msr	tpidr_el1, x9
+
+	ldr	x9, [x30, #PVM_BOOT_ARGS_OFF_SP_EL1]
+	mov	sp, x9
+
+	/* No stale TLB entries, and the writes above in effect, before the MMU is on. */
+	tlbi	vmalle1
+	dsb	nsh
+	isb
+	ldr	x9, [x30, #PVM_BOOT_ARGS_OFF_SCTLR_EL1]
+	msr	sctlr_el1, x9
+	isb
+
+	br	x8
+	.globl	pvm_entry_end
+pvm_entry_end:
-- 
2.47.3

