Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A68D07C
	for <kvmarm@lists.linux.dev>; Sat, 29 Jul 2023 00:37:44 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-c647150c254so4647862276.1
        for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 17:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591063; x=1691195863;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=sEeXYbzgZRVXR5YLFfEtQVAczR2xalSf9MVNMlCNrPc=;
        b=510yqVUE3dJrmTFvMRZmUgU2asXSH3DoFW0Fghi574CxyywdgdIv8Y/diDFElXqlyf
         jU6KsQmAZf71nxPH+MSup9/mIF1uemfLZbDWceTG4BdkFGD9rcuSR2n/9/0/bk8De/N9
         25VV8tPUNlntY3Fv3oSuGTysrAQ/6Y6iPssCSdafPx304Mq6vNfG78lBD+9VDgXAqZkq
         em5cPcrt8KHlMBFm8vm0+E08hW/a6en+YbJ7ZZAKPcaON8hlum758WmUnT3f2Lw6PHXK
         Z/cAhUBz5bE1+QxdbyvOLhdn7yGVpm4px3BGKkYiY2arDrtsqFhkBbGF+doEA8uqBr8T
         5T5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591063; x=1691195863;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sEeXYbzgZRVXR5YLFfEtQVAczR2xalSf9MVNMlCNrPc=;
        b=IXuuiL++KQZbVD4hj14dXtFNtTWBMmx16JAXUWL97+q8pvDFGq+RdxrxJT114D65QB
         8JTrFWVQziC/v0XBxWD/cEKGKFqO2+YSYAjccwq2HGlQzuRDtIO/G8LQalOQJ7FeKmke
         OQQK81xRSnbT5YGKbcexh2Bq88KLOLxPBJ7jApU0HHddkW+khItIlJZC120YE/Q3X50w
         apDAL4mRRh1M7Usgc3hN66nZsDqc+iGJQGAZ3Nd1/KpEduYR6l4KkhTK+L9yS8KXSdGq
         K0/4fLP3tz7T9q2kUd1DuEwm5CO2D2X9HiyPxduigB9tV0HwrJdUDhZe4tCPnz5gJ5ud
         d+DQ==
X-Gm-Message-State: ABy/qLZ/EoR7DAzAMMA2JpQLC3VAegpuXXFCrpL+t/qM33KkC1eQ182Z
	3MdjxfECOe9RAf+TYswHYSPZ2Dvdh5g=
X-Google-Smtp-Source: APBJJlEwkcPph7CHbR1bEzAaGPD5/cOkJGSBy5rl0bnU2QuHcdpuQJe7rfYazvWjgBg8IHQMVGr/YJUq7Ok=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:11cb:b0:d16:7ccc:b406 with SMTP id
 n11-20020a05690211cb00b00d167cccb406mr31838ybu.5.1690591063821; Fri, 28 Jul
 2023 17:37:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 28 Jul 2023 17:36:39 -0700
In-Reply-To: <20230729003643.1053367-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729003643.1053367-31-seanjc@google.com>
Subject: [PATCH v4 30/34] KVM: selftests: Convert VMX's PMU capabilities test
 to printf guest asserts
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Thomas Huth <thuth@redhat.com>, 
	"=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Convert x86's VMX PMU capabilities test to use printf-based guest asserts.
Opportunstically add a helper to do the WRMSR+assert so as to reduce the
amount of copy+paste needed to spit out debug information.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/vmx_pmu_caps_test.c  | 28 ++++++++++---------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
index 34efd57c2b32..ba09d5a01c39 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
@@ -10,6 +10,7 @@
  * and check it can be retrieved with KVM_GET_MSR, also test
  * the invalid LBR formats are rejected.
  */
+#define USE_GUEST_ASSERT_PRINTF 1
 
 #define _GNU_SOURCE /* for program_invocation_short_name */
 #include <sys/ioctl.h>
@@ -52,23 +53,24 @@ static const union perf_capabilities format_caps = {
 	.pebs_format = -1,
 };
 
+static void guest_test_perf_capabilities_gp(uint64_t val)
+{
+	uint8_t vector = wrmsr_safe(MSR_IA32_PERF_CAPABILITIES, val);
+
+	__GUEST_ASSERT(vector == GP_VECTOR,
+		       "Expected #GP for value '0x%llx', got vector '0x%x'",
+		       val, vector);
+}
+
 static void guest_code(uint64_t current_val)
 {
-	uint8_t vector;
 	int i;
 
-	vector = wrmsr_safe(MSR_IA32_PERF_CAPABILITIES, current_val);
-	GUEST_ASSERT_2(vector == GP_VECTOR, current_val, vector);
+	guest_test_perf_capabilities_gp(current_val);
+	guest_test_perf_capabilities_gp(0);
 
-	vector = wrmsr_safe(MSR_IA32_PERF_CAPABILITIES, 0);
-	GUEST_ASSERT_2(vector == GP_VECTOR, 0, vector);
-
-	for (i = 0; i < 64; i++) {
-		vector = wrmsr_safe(MSR_IA32_PERF_CAPABILITIES,
-				    current_val ^ BIT_ULL(i));
-		GUEST_ASSERT_2(vector == GP_VECTOR,
-			       current_val ^ BIT_ULL(i), vector);
-	}
+	for (i = 0; i < 64; i++)
+		guest_test_perf_capabilities_gp(current_val ^ BIT_ULL(i));
 
 	GUEST_DONE();
 }
@@ -95,7 +97,7 @@ static void test_guest_wrmsr_perf_capabilities(union perf_capabilities host_cap)
 
 	switch (get_ucall(vcpu, &uc)) {
 	case UCALL_ABORT:
-		REPORT_GUEST_ASSERT_2(uc, "val = 0x%lx, vector = %lu");
+		REPORT_GUEST_ASSERT(uc);
 		break;
 	case UCALL_DONE:
 		break;
-- 
2.41.0.487.g6d72f3e995-goog

