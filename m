Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66BC926C3A1
	for <kvmarm@lists.linux.dev>; Mon,  5 May 2025 16:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746461665; cv=none; b=jltM3tPUwt0EPh9YmX1qVXJT2LnSZIgqsUA51jpXy2AzY7mGwkM3PwDG6Rv0zcIUGq3FuOcfpl9NE9zp6iKWvT6ppJm36kg6wgjchUfiE3lJpJDpOua4R/4tcsDVeMlsktEyLITQ0r4nM/Ciwktn6fR7FfHxMyEFLLsbsVMtWv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746461665; c=relaxed/simple;
	bh=0xPFNmQ2aYdSjFcVuUL7sWXmakZUXXwCI8TdRZJDz9g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OtWFJSk1IpqaR/VRNazirIk95jJRYFUt2z+lCYuKMKJIwobUbheOxVyI0pwxGSLtHrTeVxRHjm90JWjWFMnzZy8WsDXAqQnEMJnR0CrbFL6zkeFRj+F5JzheQ28xHQkQfYPUXfMcwZ1beLI+e/yE5QOjBEBguEe2SWtpOjBTLjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RptELBOP; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RptELBOP"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-22650077995so69063785ad.3
        for <kvmarm@lists.linux.dev>; Mon, 05 May 2025 09:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746461663; x=1747066463; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qoM9DcHdqZBj+rk9l05sHHopuoPZxH677juEX9RJpMg=;
        b=RptELBOPuVulH+HZ5SV5PyOOvqmoDuZ0OEOG4Fe6RDonjkZzKKH8s1UXhlQsPTZ6KD
         hrom7wDY/xBnWKEKjUG/GWwNQTylT9QMF2wpzrtYEcGczLX22raRppFtvfPCw1/X/9ka
         0QMja+Hl9l+iSccPe5QXVvv+YSzlcRNUbpR9TISML3wEBn8AhykedH4A5SDkBDSbRQbY
         laJNRvJM1e0uPmQk6Q3qwwhbYq3ySBMf8wnLveMuCY9/mvYm0SlCgNheNRyRUwt0dqjC
         z6TjO7QKp84Tvc/iW8LUQTjUQeWP7Ueau713dnw+uJsAUkD6CeknIt7YvJB50t7Kkn1U
         V8aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746461663; x=1747066463;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qoM9DcHdqZBj+rk9l05sHHopuoPZxH677juEX9RJpMg=;
        b=IKWzd3iKrwLJE6xxOIgmSxr+Rf6gA99bLBUlZTF9+znZuFb1z4mYj+LuIFYKarhQ9I
         3TV5tKZKPms69qOwRY03WmjiDiD3togieFqFkHvPUosLv65z/d62jdU0zhc/Toblwo+N
         /qcPNPiSjXWd9unkcDkX+g3Uakpa4CUIbEulkzEojIE6J1OzupNSxqTszyviPTWNYeOm
         z2e5hq40/U4839jgRjwbNPUJv3ZAdAbBdFqMIxzhq9X3yWw6nazbnPB5fbbNWPij1627
         Q2149O9f570SQnIqGOPOT7FicxOp8ghJVIoVv3qY7ncp9W5OMEkQh9D1IITnLUjhqgTh
         BOvg==
X-Forwarded-Encrypted: i=1; AJvYcCWt0QQtHj0KQFaWYrrile58EM3Yal0m0bIxuG5zKCizhpxCB2MY7NUgwmQjAtWl+LO/cO4i5dc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw4oBLJAUTHbWDduoyaUmKYvkULhrBrFYcW9FpH5kz4WhNkR1tk
	uEFcI8KPAx4V2L4XboyzeT8KCVUirk4btXXFoq2KkYS6m2Z9yW/SrNCtmoXeDVRH7voJ4YNWw/K
	dqe0e7jUunw==
X-Google-Smtp-Source: AGHT+IFZMxB5zKbz0DCB224XcS28TLNRLHuTk3G5CmkpWtkGxQ7uQKT12C81gz2CRUWIcDMNDv5x3jsR5vZQHg==
X-Received: from pfbdh13.prod.google.com ([2002:a05:6a00:478d:b0:739:485f:c33e])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:2383:b0:21f:52e:939e with SMTP id d9443c01a7336-22e18bc4033mr159804055ad.28.1746461662677;
 Mon, 05 May 2025 09:14:22 -0700 (PDT)
Date: Mon,  5 May 2025 16:14:11 +0000
In-Reply-To: <20250505161412.1926643-1-jiaqiyan@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250505161412.1926643-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.49.0.967.g6a0df3ecc3-goog
Message-ID: <20250505161412.1926643-6-jiaqiyan@google.com>
Subject: [PATCH v1 5/6] KVM: selftests: Test for KVM_CAP_INJECT_EXT_IABT
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
certain ESR_EL1 value can be expected, but not the case for FAR_EL1.

Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 tools/arch/arm64/include/uapi/asm/kvm.h       |   3 +-
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../testing/selftests/kvm/arm64/inject_iabt.c | 100 ++++++++++++++++++
 3 files changed, 103 insertions(+), 1 deletion(-)
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
index 16d2e9f32619f..708fd126a36dd 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -148,6 +148,7 @@ TEST_GEN_PROGS_arm64 += arm64/aarch32_id_regs
 TEST_GEN_PROGS_arm64 += arm64/arch_timer_edge_cases
 TEST_GEN_PROGS_arm64 += arm64/debug-exceptions
 TEST_GEN_PROGS_arm64 += arm64/hypercalls
+TEST_GEN_PROGS_arm64 += arm64/inject_iabt
 TEST_GEN_PROGS_arm64 += arm64/mmio_abort
 TEST_GEN_PROGS_arm64 += arm64/page_fault_test
 TEST_GEN_PROGS_arm64 += arm64/psci_test
diff --git a/tools/testing/selftests/kvm/arm64/inject_iabt.c b/tools/testing/selftests/kvm/arm64/inject_iabt.c
new file mode 100644
index 0000000000000..43b701e9143c2
--- /dev/null
+++ b/tools/testing/selftests/kvm/arm64/inject_iabt.c
@@ -0,0 +1,100 @@
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
+	GUEST_PRINTF("Guest SEA esr_el1=%#lx\n", esr);
+	GUEST_ASSERT_EQ(ESR_ELx_EC(esr), ESR_ELx_EC_IABT_CUR);
+	GUEST_ASSERT_EQ(esr & ESR_ELx_FSC_TYPE, ESR_ELx_FSC_EXTABT);
+	/*
+	 * We inject IABT but there is no SEA in guest at all,
+	 * so guest should see FnV == 1, which is set by KVM.
+	 */
+	GUEST_ASSERT(esr & ESR_ELx_FnV);
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
+		case UCALL_DONE:
+			ksft_print_msg("Guest done gracefully!\n");
+			guest_done = true;
+			break;
+		default:
+			TEST_FAIL("Unexpected ucall: %lu", uc.cmd);
+	}
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
2.49.0.967.g6a0df3ecc3-goog

