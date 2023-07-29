Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E5638E
	for <kvmarm@lists.linux.dev>; Sat, 29 Jul 2023 00:37:29 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d11f35a0d5cso2564730276.1
        for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 17:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591048; x=1691195848;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=w199spolidmz1fyWW2Lr4cL/pHW9KEOboysIoigRNpA=;
        b=DrhecqVPQeLMP91ubgEGu6G/jHyWR4//Lad7FZiEySEklpS4P1wiOZupUHqW/ZjTAY
         Qc2O+aSQCxUoaI2hSjEjV6ICPMoEYiI/GB3LLTYh8g6SG83BAN4KuJG0rOSqKHyJQ6+k
         paUMofkHmyHbueb3IEOlz7jeH0HHA+RoEI9CWRflI8qxBnLZeDeBhpL76Rd0pFtN6BFv
         V8G7CP4W7qnDGSWeKWVac5kpCNXWOdfPOm0KSvSo4TZgIjbmMLsl4KYqh5wpnE4g/fxP
         UZIo3ILZlXQ8MTNA4ijFkX0NpuTKiC4UU3mKTPYa6sQJtt/aDbT7apbEJQfp0Nikwdi0
         8MKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591048; x=1691195848;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w199spolidmz1fyWW2Lr4cL/pHW9KEOboysIoigRNpA=;
        b=V+TBGXFJSWoSJhk23t/6+LeNBAjroqMsgByIN+kMTCxUgqURGRYHrRr6OSBIpJ3g7s
         IKTfw5S0deIGEuFjFRdfudSmcOxNmv9K6jmGczCJBcsi0bIpMUAZthrc5vN8BgvVLeCw
         RZHzbfEeXojNH5c6B0GdJskIyyf/UQ1Q5n0/9CCZrNEi1MqgsbNPPFSNhKWBWladTGFg
         uZTfOEAQ4Bttv7pDhoV6782RCB5QBerKar+UwOZ1095qa697DzvPWd3GeSIrplLl2T7E
         pC82R1DDv7Kh7RDvA4IXF3DVaf+JBGc2VOO9kfWxP5aUFydCYuSQRtO5q02i/jbNlGSW
         KcpQ==
X-Gm-Message-State: ABy/qLZlsLZdOK4sO1q5ja0mYIezDZ6Vm7I9Xw+6R8M1WHk7i70jr257
	6Ijz5gVlJeIt14AYGiSXoYgoelS6f0A=
X-Google-Smtp-Source: APBJJlEkIujTI85kXI9jRFQI7RC5mYrZ6Cg6VIZeTCAXQQnRxYdIDgUz9r2skvpYxnizApg4b/YiqoDb0dM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:4d4:0:b0:d1a:4d0e:c11c with SMTP id
 203-20020a2504d4000000b00d1a4d0ec11cmr16550ybe.11.1690591048693; Fri, 28 Jul
 2023 17:37:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 28 Jul 2023 17:36:31 -0700
In-Reply-To: <20230729003643.1053367-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729003643.1053367-23-seanjc@google.com>
Subject: [PATCH v4 22/34] KVM: selftests: Convert the Hyper-V feature test to
 printf style GUEST_ASSERT
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Thomas Huth <thuth@redhat.com>, 
	"=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Convert x86's Hyper-V feature test to use print-based guest asserts.
Opportunistically use the EQ and NE variants in a few places to capture
additional information.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/hyperv_features.c    | 31 +++++++++++++------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
index 78606de9385d..41a6beff78c4 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
@@ -4,6 +4,8 @@
  *
  * Tests for Hyper-V features enablement
  */
+#define USE_GUEST_ASSERT_PRINTF 1
+
 #include <asm/kvm_para.h>
 #include <linux/kvm_para.h>
 #include <stdint.h>
@@ -53,16 +55,21 @@ static void guest_msr(struct msr_data *msr)
 		vector = rdmsr_safe(msr->idx, &msr_val);
 
 	if (msr->fault_expected)
-		GUEST_ASSERT_3(vector == GP_VECTOR, msr->idx, vector, GP_VECTOR);
+		__GUEST_ASSERT(vector == GP_VECTOR,
+			       "Expected #GP on %sMSR(0x%x), got vector '0x%x'",
+			       msr->idx, msr->write ? "WR" : "RD", vector);
 	else
-		GUEST_ASSERT_3(!vector, msr->idx, vector, 0);
+		__GUEST_ASSERT(!vector,
+			       "Expected success on %sMSR(0x%x), got vector '0x%x'",
+			       msr->idx, msr->write ? "WR" : "RD", vector);
 
 	if (vector || is_write_only_msr(msr->idx))
 		goto done;
 
 	if (msr->write)
-		GUEST_ASSERT_3(msr_val == msr->write_val, msr->idx,
-			       msr_val, msr->write_val);
+		__GUEST_ASSERT(!vector,
+			       "WRMSR(0x%x) to '0x%llx', RDMSR read '0x%llx'",
+			       msr->idx, msr->write_val, msr_val);
 
 	/* Invariant TSC bit appears when TSC invariant control MSR is written to */
 	if (msr->idx == HV_X64_MSR_TSC_INVARIANT_CONTROL) {
@@ -82,7 +89,7 @@ static void guest_hcall(vm_vaddr_t pgs_gpa, struct hcall_data *hcall)
 	u64 res, input, output;
 	uint8_t vector;
 
-	GUEST_ASSERT(hcall->control);
+	GUEST_ASSERT_NE(hcall->control, 0);
 
 	wrmsr(HV_X64_MSR_GUEST_OS_ID, HYPERV_LINUX_OS_ID);
 	wrmsr(HV_X64_MSR_HYPERCALL, pgs_gpa);
@@ -96,10 +103,14 @@ static void guest_hcall(vm_vaddr_t pgs_gpa, struct hcall_data *hcall)
 
 	vector = __hyperv_hypercall(hcall->control, input, output, &res);
 	if (hcall->ud_expected) {
-		GUEST_ASSERT_2(vector == UD_VECTOR, hcall->control, vector);
+		__GUEST_ASSERT(vector == UD_VECTOR,
+			       "Expected #UD for control '%u', got vector '0x%x'",
+			       hcall->control, vector);
 	} else {
-		GUEST_ASSERT_2(!vector, hcall->control, vector);
-		GUEST_ASSERT_2(res == hcall->expect, hcall->expect, res);
+		__GUEST_ASSERT(!vector,
+			       "Expected no exception for control '%u', got vector '0x%x'",
+			       hcall->control, vector);
+		GUEST_ASSERT_EQ(res, hcall->expect);
 	}
 
 	GUEST_DONE();
@@ -495,7 +506,7 @@ static void guest_test_msrs_access(void)
 
 		switch (get_ucall(vcpu, &uc)) {
 		case UCALL_ABORT:
-			REPORT_GUEST_ASSERT_3(uc, "MSR = %lx, arg1 = %lx, arg2 = %lx");
+			REPORT_GUEST_ASSERT(uc);
 			return;
 		case UCALL_DONE:
 			break;
@@ -665,7 +676,7 @@ static void guest_test_hcalls_access(void)
 
 		switch (get_ucall(vcpu, &uc)) {
 		case UCALL_ABORT:
-			REPORT_GUEST_ASSERT_2(uc, "arg1 = %lx, arg2 = %lx");
+			REPORT_GUEST_ASSERT(uc);
 			return;
 		case UCALL_DONE:
 			break;
-- 
2.41.0.487.g6d72f3e995-goog

