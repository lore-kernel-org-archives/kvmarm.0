Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691AD13FE5
	for <kvmarm@lists.linux.dev>; Sat,  3 Feb 2024 00:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706918982; cv=none; b=Ba557F51LQUxDlCYZQS/AwfjKBXAlhDtfniMG0r2lHqIKp578EMCvwZUuhsMw4NMN5dTFtH+4p5YJeeOj/hcW8OQP/mjiFzCP5DKDJhUeD8SMGoSU8A5ybRDP2vF8xqjFeQImG+ZZ06Uq+6amGIGRSO1NOsWoaHsXrnvxA1biBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706918982; c=relaxed/simple;
	bh=dxFDbsAQMhSueKOp2cttxeSOtYuXNHRkrePZ7bjyZ1U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ljbyzPxIvqxqp8S/huRSo0x6dhP1ClJYlxrPqstxfljmX0eq+6V5ql6/clVjN5d6c9ydyVEdIAxJdAzErTaPETYpISnAJ2CJD526LW8Vl8ZNx0tnubLCGOoj0GhvgoLWoQg1cRXY7AySFpkA2ZRNc4CEzZ1FB3dSSswRGpeb0EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GQeZjnPY; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GQeZjnPY"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1d968aebbd1so17556105ad.1
        for <kvmarm@lists.linux.dev>; Fri, 02 Feb 2024 16:09:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706918981; x=1707523781; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=VzhuhwHBOVTPe3ek7qdXtFf4wVMa0yBW9i03fvIkD6g=;
        b=GQeZjnPYOx5Uxzk1+2zjQIDMrhsulemv8xzfBJpSr777UXHj0dbTsr0pXPZF00NvnJ
         e67ifb6dzHYFSjziEY64TdHIr+Yp9Ppy98NCFvErSSjyy5u5SuSClq/rA4XlSB4h+ubr
         zReZQ/caelUay1LxLUrwwa8Xim3mzwx0SKW29kVaTDWhr++HSaYW0chCPgmmx6YiouUq
         6Xhh8JohASmxEw+Re7SxMVa6g3/oX0gx3WyyAjEj6qlvMfTduce6ZvCeky/wXbYR6Doo
         JbAFtGo5EgJzvkcQbbVqH7aJhTpLK3ohCOuBHAGcvOaPkt3xpV+te6b/Mco0V+YlsfnW
         vACQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706918981; x=1707523781;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VzhuhwHBOVTPe3ek7qdXtFf4wVMa0yBW9i03fvIkD6g=;
        b=krECXUi04Mq/fEQ03I604QjDXflqIbRwYs2KfiCQa7uh/5TappElP7dr/qHPDJcg04
         +GJTSf4t5eM4yDR6R2Z7J7QD7+dtdqAOU0hjdVFRJ5jFWKnmdQVdaje3unP8HqsNOtb6
         ebminhsQ1qexd+LGhFoA5+vbppScjpsLB9ftwJCwJlg9SLOiutCKAcK54pHPMKu3VM4w
         qa4a0AW20DWFkAhzojfmcRpmDBHgq9fKhaOn27aEJs/dg6x5nTcTczZEfpHC+STUCSYr
         Jh9P9UWkeQSkbVfZG12ZZBZtYI7qdVJEZ6yBdmpQp0K4OtDt3MCCJMj/DVj620kWpXbu
         TYmQ==
X-Gm-Message-State: AOJu0YwWX8a+113DHFjpnLCaQam3m1h8V34bDS8ito/pjkHFafM/da2b
	ngC0Wap/WFPNMgWUmDgExo5WcyJGOiz5Bu3o5j81Z7Jw6bvjYcmuHPsHLQ9DJ6nNAQkEjLTrZL0
	zPA==
X-Google-Smtp-Source: AGHT+IFdVzXVjWcXSdnVu4txbSAxtL7z3o5BSMoU53EUfpfZ3637JRMu4aCEDmVPmG/jpu55q3noR5dZ8rg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e741:b0:1d9:1ca3:1883 with SMTP id
 p1-20020a170902e74100b001d91ca31883mr51751plf.5.1706918980700; Fri, 02 Feb
 2024 16:09:40 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Feb 2024 16:09:16 -0800
In-Reply-To: <20240203000917.376631-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240203000917.376631-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.594.gd9cf4e227d-goog
Message-ID: <20240203000917.376631-11-seanjc@google.com>
Subject: [PATCH v8 10/10] KVM: selftests: Add a basic SEV smoke test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Andrew Jones <andrew.jones@linux.dev>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Michael Roth <michael.roth@amd.com>, Peter Gonda <pgonda@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Peter Gonda <pgonda@google.com>

Add a basic smoke test for SEV guests to verify that KVM can launch an
SEV guest and run a few instructions without exploding.  To verify that
SEV is indeed enabled, assert that SEV is reported as enabled in
MSR_AMD64_SEV, a.k.a. SEV_STATUS, which cannot be intercepted by KVM
(architecturally enforced).

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Cc: Ackerly Tng <ackerleytng@google.com>
cc: Andrew Jones <andrew.jones@linux.dev>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Michael Roth <michael.roth@amd.com>
Suggested-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
[sean: rename to "sev_smoke_test"]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../selftests/kvm/x86_64/sev_smoke_test.c     | 58 +++++++++++++++++++
 2 files changed, 59 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/sev_smoke_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 169b6ee8f733..da20e6bb43ed 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -120,6 +120,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/vmx_pmu_caps_test
 TEST_GEN_PROGS_x86_64 += x86_64/xen_shinfo_test
 TEST_GEN_PROGS_x86_64 += x86_64/xen_vmcall_test
 TEST_GEN_PROGS_x86_64 += x86_64/sev_migrate_tests
+TEST_GEN_PROGS_x86_64 += x86_64/sev_smoke_test
 TEST_GEN_PROGS_x86_64 += x86_64/amx_test
 TEST_GEN_PROGS_x86_64 += x86_64/max_vcpuid_cap_test
 TEST_GEN_PROGS_x86_64 += x86_64/triple_fault_event_test
diff --git a/tools/testing/selftests/kvm/x86_64/sev_smoke_test.c b/tools/testing/selftests/kvm/x86_64/sev_smoke_test.c
new file mode 100644
index 000000000000..c1534efab2be
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/sev_smoke_test.c
@@ -0,0 +1,58 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+#include "svm_util.h"
+#include "linux/psp-sev.h"
+#include "sev.h"
+
+static void guest_sev_code(void)
+{
+	GUEST_ASSERT(this_cpu_has(X86_FEATURE_SEV));
+	GUEST_ASSERT(rdmsr(MSR_AMD64_SEV) & MSR_AMD64_SEV_ENABLED);
+
+	GUEST_DONE();
+}
+
+static void test_sev(void *guest_code, uint64_t policy)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	struct ucall uc;
+
+	vm = vm_sev_create_with_one_vcpu(policy, guest_code, &vcpu);
+
+	for (;;) {
+		vcpu_run(vcpu);
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_SYNC:
+			continue;
+		case UCALL_DONE:
+			return;
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+		default:
+			TEST_FAIL("Unexpected exit: %s",
+				  exit_reason_str(vcpu->run->exit_reason));
+		}
+	}
+
+	kvm_vm_free(vm);
+}
+
+int main(int argc, char *argv[])
+{
+	TEST_REQUIRE(is_kvm_sev_supported());
+
+	test_sev(guest_sev_code, SEV_POLICY_NO_DBG);
+	test_sev(guest_sev_code, 0);
+
+	return 0;
+}
-- 
2.43.0.594.gd9cf4e227d-goog

