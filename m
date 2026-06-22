Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9F5349AE6
	for <kvmarm@lists.linux.dev>; Mon, 22 Jun 2026 19:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782155233; cv=none; b=fRdDEpbCB46nVKjXoBTBnqOm6W8TNDNaYWxbh8B58P8B17RTLnAv+pKfhEQx4N5dePuY+uQWIz/hmQNkAlr3+tJThSA5yB24gJHvVBUvFRtrO4VrIF7DzFad76FseO25fyRw99z8lt0UQ65IlDgQsCGvwOkMQAY9U9OeWIvnypc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782155233; c=relaxed/simple;
	bh=Uydph5RRzoGZrnJ+RHbGdYqpI5UdO5G/DexLf26YrE4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Obey1Bg4cpwMAO2b0YS7F2Lal4sEJoGrElJ6BfFk6U4cBNRgZ1yEaCb9Ot4LWll69pGM/UnP8Pi8iBlaDxWBL1wXtfYehHIPWrC+B5ummk4GdR42InWTNw13rYRqNAZfz/h9r6GAjY0W/F4GsN5cOxBNm1E9+c87B/5aeeJqrGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ukkLvB7X; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ukkLvB7X"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782155229;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H/ptLYDoNYECHV8Av4vKOACJyHkEJSNp/4xAFTlNvYU=;
	b=ukkLvB7XmLFD+E8YKhTqcZli2nlA0iadBQfzNjh2oOCZmaHjboqos1B9yGGBJMNZtuMCvp
	B6NZV1Fl6iWvGbIhTO0lS8t+OuuQ0svpobXhcjIZzEEcUL24/aXJkpL4c4rcv37f6UD0WM
	f1oF+UmZgxkBjjCCQq0hsSsK3VHCP5A=
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Christoffer Dall <christoffer.dall@linaro.org>,
	Victor Kamensky <victor.kamensky@linaro.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] KVM: arm64: selftests: Add MMIO sign-extending load test
Date: Mon, 22 Jun 2026 20:07:01 +0100
Message-Id: <20260622190701.2039766-3-fuad.tabba@linux.dev>
In-Reply-To: <20260622190701.2039766-1-fuad.tabba@linux.dev>
References: <20260622190701.2039766-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add a test for sign-extending MMIO loads (LDRSB, LDRSH, LDRSW) into Xt
and Wt destinations, with and without the sign bit set. The host supplies
the MMIO data and checks the guest register holds the sign-extended value.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/arm64/mmio_sign_ext.c       | 133 ++++++++++++++++++
 2 files changed, 134 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/arm64/mmio_sign_ext.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 9118a5a51b89f..0f5803a1092e1 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -171,6 +171,7 @@ TEST_GEN_PROGS_arm64 += arm64/hello_el2
 TEST_GEN_PROGS_arm64 += arm64/host_sve
 TEST_GEN_PROGS_arm64 += arm64/hypercalls
 TEST_GEN_PROGS_arm64 += arm64/external_aborts
+TEST_GEN_PROGS_arm64 += arm64/mmio_sign_ext
 TEST_GEN_PROGS_arm64 += arm64/page_fault_test
 TEST_GEN_PROGS_arm64 += arm64/psci_test
 TEST_GEN_PROGS_arm64 += arm64/sea_to_user
diff --git a/tools/testing/selftests/kvm/arm64/mmio_sign_ext.c b/tools/testing/selftests/kvm/arm64/mmio_sign_ext.c
new file mode 100644
index 0000000000000..d1efbccd1603a
--- /dev/null
+++ b/tools/testing/selftests/kvm/arm64/mmio_sign_ext.c
@@ -0,0 +1,133 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * mmio_sign_ext - Test sign-extending MMIO load emulation (LDRSB/LDRSH/LDRSW)
+ *
+ * Copyright (c) 2026 Google LLC
+ */
+
+#include "processor.h"
+#include "test_util.h"
+
+#define MMIO_ADDR	0x8000000ULL
+
+struct mmio_test {
+	const char *name;
+	uint64_t data;
+	uint8_t len;
+	uint64_t expected;
+};
+
+/* Paired 1:1, in order, with the loads in guest_code() below. */
+static const struct mmio_test tests[] = {
+	/* LDRSB Xt: byte sign-extended to 64 bits */
+	{ "LDRSB Xt 0xFF",	0xFF,		1, 0xFFFFFFFFFFFFFFFFULL },
+	{ "LDRSB Xt 0x7F",	0x7F,		1, 0x7FULL },
+
+	/* LDRSB Wt: byte sign-extended to 32 bits, upper 32 bits zeroed */
+	{ "LDRSB Wt 0xFF",	0xFF,		1, 0xFFFFFFFFULL },
+	{ "LDRSB Wt 0x7F",	0x7F,		1, 0x7FULL },
+
+	/* LDRSH Xt: halfword sign-extended to 64 bits */
+	{ "LDRSH Xt 0x8001",	0x8001,		2, 0xFFFFFFFFFFFF8001ULL },
+	{ "LDRSH Xt 0x7FFF",	0x7FFF,		2, 0x7FFFULL },
+
+	/* LDRSH Wt: halfword sign-extended to 32 bits, upper 32 bits zeroed */
+	{ "LDRSH Wt 0x8001",	0x8001,		2, 0xFFFF8001ULL },
+	{ "LDRSH Wt 0x7FFF",	0x7FFF,		2, 0x7FFFULL },
+
+	/* LDRSW Xt: word sign-extended to 64 bits (no Wt form) */
+	{ "LDRSW Xt 0x80000001", 0x80000001,	4, 0xFFFFFFFF80000001ULL },
+	{ "LDRSW Xt 0x7FFFFFFF", 0x7FFFFFFF,	4, 0x7FFFFFFFULL },
+};
+
+static void guest_code(void)
+{
+	uint64_t val;
+
+	asm volatile("ldrsb %0, [%1]" : "=r"(val) : "r"(MMIO_ADDR) : "memory");
+	GUEST_SYNC(val);
+
+	asm volatile("ldrsb %0, [%1]" : "=r"(val) : "r"(MMIO_ADDR) : "memory");
+	GUEST_SYNC(val);
+
+	asm volatile("ldrsb %w0, [%1]" : "=r"(val) : "r"(MMIO_ADDR) : "memory");
+	GUEST_SYNC(val);
+
+	asm volatile("ldrsb %w0, [%1]" : "=r"(val) : "r"(MMIO_ADDR) : "memory");
+	GUEST_SYNC(val);
+
+	asm volatile("ldrsh %0, [%1]" : "=r"(val) : "r"(MMIO_ADDR) : "memory");
+	GUEST_SYNC(val);
+
+	asm volatile("ldrsh %0, [%1]" : "=r"(val) : "r"(MMIO_ADDR) : "memory");
+	GUEST_SYNC(val);
+
+	asm volatile("ldrsh %w0, [%1]" : "=r"(val) : "r"(MMIO_ADDR) : "memory");
+	GUEST_SYNC(val);
+
+	asm volatile("ldrsh %w0, [%1]" : "=r"(val) : "r"(MMIO_ADDR) : "memory");
+	GUEST_SYNC(val);
+
+	asm volatile("ldrsw %0, [%1]" : "=r"(val) : "r"(MMIO_ADDR) : "memory");
+	GUEST_SYNC(val);
+
+	asm volatile("ldrsw %0, [%1]" : "=r"(val) : "r"(MMIO_ADDR) : "memory");
+	GUEST_SYNC(val);
+
+	GUEST_DONE();
+}
+
+static void handle_mmio(struct kvm_run *run, const struct mmio_test *t)
+{
+	TEST_ASSERT_EQ(run->mmio.phys_addr, MMIO_ADDR);
+	TEST_ASSERT(!run->mmio.is_write, "Expected MMIO read for %s", t->name);
+	TEST_ASSERT_EQ(run->mmio.len, t->len);
+
+	memset(run->mmio.data, 0, sizeof(run->mmio.data));
+	/* Works because arm64 KVM hosts are always little-endian. */
+	memcpy(run->mmio.data, &t->data, t->len);
+}
+
+int main(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	struct ucall uc;
+	unsigned int i;
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	virt_map(vm, MMIO_ADDR, MMIO_ADDR, 1);
+
+	ksft_print_header();
+	ksft_set_plan(ARRAY_SIZE(tests));
+
+	for (i = 0; i < ARRAY_SIZE(tests); i++) {
+		const struct mmio_test *t = &tests[i];
+
+		vcpu_run(vcpu);
+		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_MMIO);
+
+		handle_mmio(vcpu->run, t);
+		vcpu_run(vcpu);
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_SYNC:
+			TEST_ASSERT_EQ(uc.args[1], t->expected);
+			break;
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+			break;
+		default:
+			TEST_FAIL("Unexpected ucall for %s", t->name);
+		}
+
+		ksft_test_result_pass("%s\n", t->name);
+	}
+
+	vcpu_run(vcpu);
+	TEST_ASSERT(get_ucall(vcpu, &uc) == UCALL_DONE, "Expected UCALL_DONE");
+
+	kvm_vm_free(vm);
+
+	ksft_finished();
+}
-- 
2.39.5

