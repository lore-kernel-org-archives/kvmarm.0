Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276FB13FEF
	for <kvmarm@lists.linux.dev>; Fri, 23 Feb 2024 00:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708649003; cv=none; b=rF2rNrDk3dEvX1h+lHaRSB973GefZjjWmR1U81rsPBmQX0mXh0J+tCqJ5t1c6VktThKzH2Zl0zocQWgEcp5iTjz61HQj5UBucp7nCkLdwstitFZ/vNi27CIeW0Hs/AtXsQDdVRLTTppPS7RL4SDE6Nsk3KVBs+V99uc71arM+HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708649003; c=relaxed/simple;
	bh=wYG3aBkI4214Z2xd6xHe4uZY8sEWm9j7oKweqpMTgCo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CXkJ6dS/AfplNsmwe+6jaapC4EWDj/N9FkBEPkLL74jp8jCRwPPsLqu42vu1r78HRj6bQbc0s6Gg9XDv4dHplCDNnk2Rg6HxOEyotYc3O7FrF9m89ud4ywZba7e05eKfUM2N9LtJDgkPRwxwOT8PbRaqfPpUmpw3TkFEulSvEMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Uo6fNjU0; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Uo6fNjU0"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1d5b60c929bso2587275ad.3
        for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 16:43:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708649001; x=1709253801; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ufdAB/OIgPR6sk1BH6tXU4Lb92iEyKpRUAsMWFh65lo=;
        b=Uo6fNjU0J7UMA35dfEj/p8rOyA+IxZ3AvzqKYI5+TaDsd0z2TUWMfr9lkb2SZc4Tao
         wn68XKaZdFShDoBiLKl80KyfPndjfnkidgMbPaA/J8h08xtqbr9gatzPKBi9kHUnRGoV
         lcxprITtLtM+Ae1hXSkIXIG8cULnQpHAbMwd7XJ1O5hcZt6IXSFk4gVB8TFhZsvBWfAq
         TXHztrkHYH7dzxUdPFf0yaK7Nng6v2xTcOj4z+Ux6y5inPLdiH+rBypktx0tk00vxWgB
         6ZEwnGAzkPcJZxSrqivxyVuJp3drf2CDcdNqy+KAyOo4n9DXoTG+tWWg5I9VEoLY5qej
         RwbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708649001; x=1709253801;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ufdAB/OIgPR6sk1BH6tXU4Lb92iEyKpRUAsMWFh65lo=;
        b=q7tBDm+4H1f3h1uco+lc8wDYgzJChDbulVE+loa9ETqmaQ6mTIaR1RfEKCPJ+SgV3Z
         dTQjhrDkxJ5j04PE66HoQ4ZsFmC4YQd46zgt4Oany8nqlMh6su5UpS8DolYC/sSLs0Is
         gk0WFfcHi7FZqiciyox+Kxc/mMqHkxOEP0bMd9heSar6hiBL9m8D0HjPkbYM6ol9jmKs
         A0SjSCvoWG63jbQtSlmelz/VFMGLxWWb5FjNwmHQHGwztUIXBxMAVRnd4Zfi9ImPHClN
         OUIIxgIeWpInjsMmxKMS/lfe9sb0bO1Rw85cGa4tQs2WEtGz9HgAZ53CsJkBqTCA0RsA
         lVEw==
X-Forwarded-Encrypted: i=1; AJvYcCWybWYPxs8VpHHHd8YN/PnZD/dwS/eRgr57sDNExTCN7cKwO9Vk6b+bgAa2kxuYk+f7rXDXZsrTUTXjRZz0vuLMGAOxCP8W
X-Gm-Message-State: AOJu0YyRWXi+GcnrGOo6Wbi0kLLn7sf6zQiafg1ma4+6rZ83+Xw9Q5Sd
	NXqpfUDJRH3QTJRFQmc8EudQFh8LjmU6P5aK7tadb+ZGegvB+L/YU+4mcgyKg7AWbQAluuYe3Cu
	6UQ==
X-Google-Smtp-Source: AGHT+IG8+r/xpCHDcIabTu60pIgBwVS8FUp4lQYZJVuuCn7QXyTR4BHnC5QtDdnTL8fekJtdMeUpyEN6qt8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:234c:b0:1dc:1c81:1b2a with SMTP id
 c12-20020a170903234c00b001dc1c811b2amr1699plh.1.1708649001454; Thu, 22 Feb
 2024 16:43:21 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 Feb 2024 16:42:57 -0800
In-Reply-To: <20240223004258.3104051-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240223004258.3104051-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240223004258.3104051-11-seanjc@google.com>
Subject: [PATCH v9 10/11] KVM: selftests: Add a basic SEV smoke test
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
	Michael Roth <michael.roth@amd.com>, Carlos Bilbao <carlos.bilbao@amd.com>, 
	Peter Gonda <pgonda@google.com>, Itaru Kitayama <itaru.kitayama@fujitsu.com>
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
Tested-by: Carlos Bilbao <carlos.bilbao@amd.com>
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
index 000000000000..54d72efd9b4d
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
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SEV));
+
+	test_sev(guest_sev_code, SEV_POLICY_NO_DBG);
+	test_sev(guest_sev_code, 0);
+
+	return 0;
+}
-- 
2.44.0.rc0.258.g7320e95886-goog

