Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96BE27C
	for <kvmarm@lists.linux.dev>; Sat, 29 Jul 2023 00:37:33 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-583b256faf5so45066947b3.1
        for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 17:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591052; x=1691195852;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=x4HKEzKPUNSBzX9E0pO5Q/S6phjiWeOhLiSfPQ8QooI=;
        b=3J4eqVLdR3ykoPJRa1CUqiAo7FXGwSPiLo4xvH7nk6TpWaa/JGpNhmBWPw3KGYxRL0
         9qMYcdR0/u6TUawhaqgYIaxBi5b32u3oPLpRlG7qWlPPXPZunewy09jWcWhC5Cl19DL7
         zBgBnw4cSdRNiEkbsjo5Gcp2bAEBX0lBRSqsq7y6cBmpf20gsU/X+fWwZZk0O0I+ym7u
         pJ0NqE4APMBHTdZkdJxn5Xpo8lTIwyoI4uNBVqd4epT2ornrp+APUS9uMhgYVKkxnoLv
         zYejQkImQ3xyT5zUPKO72TgnNFsAd3LxTmVwJsnOtP65P8WX4nYqjQ+E8aENux/RDqvj
         E9gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591052; x=1691195852;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x4HKEzKPUNSBzX9E0pO5Q/S6phjiWeOhLiSfPQ8QooI=;
        b=hpjs5QO77UP7ISUl3Ymfpt58cNtgxMLKF2aY656xlnD76YUCOqI9e7N9xL8WEmH0f8
         vPyPC5gdsBrtxNOnHYAgNA13EvxvpOe3j4+2ZYVsH89jtNjE41Es4gBBoN7g6e/ZVrCU
         gvcEct3Iej8BRKJNPIRmFkdvb903uGHfb9VW2mUjLLs5Z3StLNYlwntt8ueoa4/NxoWp
         ShD5AqqTxrBOr4dHN4qhg6EgcqkngumHZSZ611w1g61px4yqckGwkX3pWad979uAo4KN
         jYfmBPnGtJptaA2V8bmdh1SY+SFkvrh5tw9Yc1P/gLkudGpZTlLr+mcwobK7f9cveXic
         5xbg==
X-Gm-Message-State: ABy/qLaIXcxSmeZoP+K1xbFMxnLeuLBPjM2Q8nqDdTb5fkbcBgH9RRr4
	XItR2cBXJ3IeNFzMebHS7m1QyEuJNdw=
X-Google-Smtp-Source: APBJJlEzrltnG1bwndm5pPHC3kHPtaj+RzjLvULD33K65TOP6Fq4kMafYhL6vJSstsfRiau2YYzr8Mp1Vdw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b665:0:b0:56c:f903:8678 with SMTP id
 h37-20020a81b665000000b0056cf9038678mr39663ywk.2.1690591052589; Fri, 28 Jul
 2023 17:37:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 28 Jul 2023 17:36:33 -0700
In-Reply-To: <20230729003643.1053367-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729003643.1053367-25-seanjc@google.com>
Subject: [PATCH v4 24/34] KVM: selftests: Convert the MONITOR/MWAIT test to
 use printf guest asserts
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Thomas Huth <thuth@redhat.com>, 
	"=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Convert x86's MONITOR/MWAIT test to use printf-based guest asserts.  Add a
macro to handle reporting failures to reduce the amount of copy+paste
needed for MONITOR vs. MWAIT.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/monitor_mwait_test.c | 37 +++++++++++--------
 1 file changed, 22 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c b/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c
index 72812644d7f5..960fecab3742 100644
--- a/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c
+++ b/tools/testing/selftests/kvm/x86_64/monitor_mwait_test.c
@@ -1,4 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
+#define USE_GUEST_ASSERT_PRINTF 1
+
 #include <fcntl.h>
 #include <stdio.h>
 #include <stdlib.h>
@@ -16,14 +18,25 @@ enum monitor_mwait_testcases {
 	MWAIT_DISABLED = BIT(2),
 };
 
+/*
+ * If both MWAIT and its quirk are disabled, MONITOR/MWAIT should #UD, in all
+ * other scenarios KVM should emulate them as nops.
+ */
+#define GUEST_ASSERT_MONITOR_MWAIT(insn, testcase, vector)		\
+do {									\
+	bool fault_wanted = ((testcase) & MWAIT_QUIRK_DISABLED) &&	\
+			    ((testcase) & MWAIT_DISABLED);		\
+									\
+	if (fault_wanted)						\
+		__GUEST_ASSERT((vector) == UD_VECTOR,			\
+			       "Expected #UD on " insn " for testcase '0x%x', got '0x%x'", vector); \
+	else								\
+		__GUEST_ASSERT(!(vector),				\
+			       "Expected success on " insn " for testcase '0x%x', got '0x%x'", vector); \
+} while (0)
+
 static void guest_monitor_wait(int testcase)
 {
-	/*
-	 * If both MWAIT and its quirk are disabled, MONITOR/MWAIT should #UD,
-	 * in all other scenarios KVM should emulate them as nops.
-	 */
-	bool fault_wanted = (testcase & MWAIT_QUIRK_DISABLED) &&
-			    (testcase & MWAIT_DISABLED);
 	u8 vector;
 
 	GUEST_SYNC(testcase);
@@ -33,16 +46,10 @@ static void guest_monitor_wait(int testcase)
 	 * intercept checks, so the inputs for MONITOR and MWAIT must be valid.
 	 */
 	vector = kvm_asm_safe("monitor", "a"(guest_monitor_wait), "c"(0), "d"(0));
-	if (fault_wanted)
-		GUEST_ASSERT_2(vector == UD_VECTOR, testcase, vector);
-	else
-		GUEST_ASSERT_2(!vector, testcase, vector);
+	GUEST_ASSERT_MONITOR_MWAIT("MONITOR", testcase, vector);
 
 	vector = kvm_asm_safe("mwait", "a"(guest_monitor_wait), "c"(0), "d"(0));
-	if (fault_wanted)
-		GUEST_ASSERT_2(vector == UD_VECTOR, testcase, vector);
-	else
-		GUEST_ASSERT_2(!vector, testcase, vector);
+	GUEST_ASSERT_MONITOR_MWAIT("MWAIT", testcase, vector);
 }
 
 static void guest_code(void)
@@ -85,7 +92,7 @@ int main(int argc, char *argv[])
 			testcase = uc.args[1];
 			break;
 		case UCALL_ABORT:
-			REPORT_GUEST_ASSERT_2(uc, "testcase = %lx, vector = %ld");
+			REPORT_GUEST_ASSERT(uc);
 			goto done;
 		case UCALL_DONE:
 			goto done;
-- 
2.41.0.487.g6d72f3e995-goog

