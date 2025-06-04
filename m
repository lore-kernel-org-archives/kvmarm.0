Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C41E26462C
	for <kvmarm@lists.linux.dev>; Wed,  4 Jun 2025 05:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749013756; cv=none; b=Ph3LHTEsmzggWPvzmk1IRRnQAGvy3Wm6a1/70u3ei3YfXKoukZEHVFAQYkFVfTbHjqQQ/b2gKhE/lD5GyDoeDa8q53f1rNUgIkTyANpaAVtUOXs8Qguu1xy9ggcpyitBlxKEmGoIO1MOthivJKWz7AXwlsjp/L2evmq4HYqQQDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749013756; c=relaxed/simple;
	bh=eU3yapsGWA2+7vXxKVhKcdiYurD0MP5WlF1wcLUeT3c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bIH8IQNt82W2oUfHKYp/mXJHEFcpTDq0205VHPKEq0KXhLweoAAG0x9QJMpFhHN5cuDkDeMXsYQDxvMN26rGSYZRXxla/x3ki0xcXCMY/u3sRPH99gfBEifvnYOUtedyMPZroxenZgcp/o48hJHT3kI/ct6t6ltxAuhZTaZKMEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ielJCR5d; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ielJCR5d"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-747fa83d81dso1711729b3a.3
        for <kvmarm@lists.linux.dev>; Tue, 03 Jun 2025 22:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749013752; x=1749618552; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ca5XEEBBkHI7wnxKesidI9Ic1vb2lLJagV9Bw44j+oc=;
        b=ielJCR5dn67MpUsnaz2q5RXkLfo2WW1iNefXM2rArmZV0+wcPoCOD2kTNGSABlM7Py
         OpATeikdMK1Btkbj2OepEfxfehq0p0zNz7451jOv9Q/055svBt+N1xnJgc5ijMjyZM6s
         L2wP7ykHOLUrnjtFHIhBxB8mNgzLHebyAuK2lnzYl4lnE1Xun5ms9B/uLfvac8VxspYE
         hSiCu1RUqsHwtZ3Vf4iw9nUAV2/0+Q7Jrkf9JkGZBA6LwiVnoC8/mq5LURRrpAJrfcPr
         GOsPz5htvCcSDpiglsElLNicBU5ggx8TwdYNverCMuBmHTKpl3r9hyQKIedOjHVzomCR
         O94g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749013752; x=1749618552;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ca5XEEBBkHI7wnxKesidI9Ic1vb2lLJagV9Bw44j+oc=;
        b=d/PyE+hY2UK1qQFKHki0q/Bbn0LwW/O7Dbk8mhl02/Ru5ja73UF8rynfvcouMNXDs7
         HE4A5GJS+99GKM8vMUgd5p4sN+kNi/Hc0MwgFnN8rzFk/pw5zlybxwKGYA87/q4oAeLG
         L+h05nrhxy3RXaHIHOmfYHnhswtQTMLDaTtLlApGfwOg2kWkxnKgGxnAxhWb3Tx0xjQ0
         v+Gho9djHxDPlYIr4Ba6voCUo2vSHKwBDA8uGuMNNcEPtzVcPTd6nc4gOlwkyPkMoVz8
         MRw6rdweVLprjkPERK12lFM5n3iqcCYdbEFFwBtYGepIgYA7vZA2iAL4P21ZY2erB1qD
         Uerg==
X-Forwarded-Encrypted: i=1; AJvYcCXuSs92uCiznkMuElR4/UOp3u63qmwXxsfI8LOMJv7V0IJuk433DwTaQ5F1asAhDeC6kAFCnow=@lists.linux.dev
X-Gm-Message-State: AOJu0YxcQNXSMfm38ovswxp39IewpxTC6EnwgyLgsNy/5JgcZWRC3oqd
	RYy+w28JzqKxT7goXEvfulpK4B6kUgzBbYqAZL1L/zLrgCyrs4GcFflCyLrRae7l0Q/uWKNj2Tg
	QnX9j8fH6AABrIA==
X-Google-Smtp-Source: AGHT+IGY9FewZRutQWX3kPabe7vpLnmhGCzy5qRwLJrwts22IIPU9KOO/oVkiPw3lXzpgoETazm1TXUFA3gKDg==
X-Received: from pfblr56.prod.google.com ([2002:a05:6a00:73b8:b0:747:a8ac:ca05])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:2e18:b0:730:9946:5973 with SMTP id d2e1a72fcca58-7480b200bf5mr2177985b3a.5.1749013751697;
 Tue, 03 Jun 2025 22:09:11 -0700 (PDT)
Date: Wed,  4 Jun 2025 05:09:00 +0000
In-Reply-To: <20250604050902.3944054-1-jiaqiyan@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250604050902.3944054-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.50.0.rc0.604.gd4ff7b7c86-goog
Message-ID: <20250604050902.3944054-6-jiaqiyan@google.com>
Subject: [PATCH v2 5/6] KVM: selftests: Test for KVM_CAP_INJECT_EXT_IABT
From: Jiaqi Yan <jiaqiyan@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	shuah@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	duenwen@google.com, rananta@google.com, jthoughton@google.com, 
	Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"

Test userspace can use KVM_SET_VCPU_EVENTS to inject an external
instruction abort into guest. The test injects instruction abort at an
arbitrary time without real SEA happening in the guest VCPU, so only
certain ESR_EL1 bits are expected and asserted.

Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 tools/arch/arm64/include/uapi/asm/kvm.h       |  3 +-
 tools/testing/selftests/kvm/Makefile.kvm      |  1 +
 .../testing/selftests/kvm/arm64/inject_iabt.c | 98 +++++++++++++++++++
 3 files changed, 101 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/arm64/inject_iabt.c

diff --git a/tools/arch/arm64/include/uapi/asm/kvm.h b/tools/arch/arm64/include/uapi/asm/kvm.h
index af9d9acaf9975..d3a4530846311 100644
--- a/tools/arch/arm64/include/uapi/asm/kvm.h
+++ b/tools/arch/arm64/include/uapi/asm/kvm.h
@@ -184,8 +184,9 @@ struct kvm_vcpu_events {
 		__u8 serror_pending;
 		__u8 serror_has_esr;
 		__u8 ext_dabt_pending;
+		__u8 ext_iabt_pending;
 		/* Align it to 8 bytes */
-		__u8 pad[5];
+		__u8 pad[4];
 		__u64 serror_esr;
 	} exception;
 	__u32 reserved[12];
diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 9eecce6b8274f..e6b504ded9c1c 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -149,6 +149,7 @@ TEST_GEN_PROGS_arm64 += arm64/arch_timer_edge_cases
 TEST_GEN_PROGS_arm64 += arm64/debug-exceptions
 TEST_GEN_PROGS_arm64 += arm64/host_sve
 TEST_GEN_PROGS_arm64 += arm64/hypercalls
+TEST_GEN_PROGS_arm64 += arm64/inject_iabt
 TEST_GEN_PROGS_arm64 += arm64/mmio_abort
 TEST_GEN_PROGS_arm64 += arm64/page_fault_test
 TEST_GEN_PROGS_arm64 += arm64/psci_test
diff --git a/tools/testing/selftests/kvm/arm64/inject_iabt.c b/tools/testing/selftests/kvm/arm64/inject_iabt.c
new file mode 100644
index 0000000000000..0c7999e5ba5b3
--- /dev/null
+++ b/tools/testing/selftests/kvm/arm64/inject_iabt.c
@@ -0,0 +1,98 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * inject_iabt.c - Tests for injecting instruction aborts into guest.
+ */
+
+#include "processor.h"
+#include "test_util.h"
+
+static void expect_iabt_handler(struct ex_regs *regs)
+{
+	u64 esr = read_sysreg(esr_el1);
+
+	GUEST_PRINTF("Handling Guest SEA\n");
+	GUEST_PRINTF("  ESR_EL1=%#lx\n", esr);
+
+	GUEST_ASSERT_EQ(ESR_ELx_EC(esr), ESR_ELx_EC_IABT_CUR);
+	GUEST_ASSERT_EQ(esr & ESR_ELx_FSC_TYPE, ESR_ELx_FSC_EXTABT);
+
+	GUEST_DONE();
+}
+
+static void guest_code(void)
+{
+	GUEST_FAIL("Guest should only run SEA handler");
+}
+
+static void vcpu_run_expect_done(struct kvm_vcpu *vcpu)
+{
+	struct ucall uc;
+	bool guest_done = false;
+
+	do {
+		vcpu_run(vcpu);
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+			break;
+		case UCALL_PRINTF:
+			ksft_print_msg("From guest: %s", uc.buffer);
+			break;
+		case UCALL_DONE:
+			ksft_print_msg("Guest done gracefully!\n");
+			guest_done = true;
+			break;
+		default:
+			TEST_FAIL("Unexpected ucall: %lu", uc.cmd);
+		}
+	} while (!guest_done);
+}
+
+static void vcpu_inject_ext_iabt(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_events events = {};
+
+	events.exception.ext_iabt_pending = true;
+	vcpu_events_set(vcpu, &events);
+}
+
+static void vcpu_inject_invalid_abt(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_events events = {};
+	int r;
+
+	events.exception.ext_iabt_pending = true;
+	events.exception.ext_dabt_pending = true;
+
+	ksft_print_msg("Injecting invalid external abort events\n");
+	r = __vcpu_ioctl(vcpu, KVM_SET_VCPU_EVENTS, &events);
+	TEST_ASSERT(r && errno == EINVAL,
+		    KVM_IOCTL_ERROR(KVM_SET_VCPU_EVENTS, r));
+}
+
+static void test_inject_iabt(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vcpu);
+
+	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
+				ESR_ELx_EC_IABT_CUR, expect_iabt_handler);
+
+	vcpu_inject_invalid_abt(vcpu);
+
+	vcpu_inject_ext_iabt(vcpu);
+	vcpu_run_expect_done(vcpu);
+
+	kvm_vm_free(vm);
+}
+
+int main(void)
+{
+	test_inject_iabt();
+	return 0;
+}
-- 
2.49.0.1266.g31b7d2e469-goog

