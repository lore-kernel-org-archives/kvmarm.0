Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDBFB7C
	for <kvmarm@lists.linux.dev>; Sat, 29 Jul 2023 00:37:46 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-583312344e7so26632447b3.1
        for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 17:37:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591066; x=1691195866;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=xqj9FFp3GbJzdxodUT2xF7JQwG5o4CpUta+kXT/J/Zc=;
        b=6mRTmQ0sMBjNlnuCoCc0BasP9WSyh4U3UNy+I62mmSF7PQnu5S9L9TmW4nCeJc1yEc
         NqvtlAqSC0Q516Jk1Y9Rkwxmg3AkjhBvkZaMC4+blSIxvv8aNAf4tDwiCWdS/mz3OFyS
         484OUBkMcHObYZQp7hJuJGDR6C5dr7avJVyoJNKl8w3G72UdYYEPxOT+z9Svg5rGM0wS
         ouYYaujR5212sPk4ldidMcjlqiJEBwgSW5vHQDioiBNoBbun5DWGQmKTJ76i9vFQfE+c
         hei//58Ou40y1sKp/lzuKZ07tJ4APhkr7vVnixNLY3U8h3ZP2nDbOyvBDVAvcnxyn5kY
         c1SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591066; x=1691195866;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xqj9FFp3GbJzdxodUT2xF7JQwG5o4CpUta+kXT/J/Zc=;
        b=bJjFbOMn2TVk5txs0yWbwpKHHdE7SUeNbNKw/3nEvwFdRnuaWswLSQMzfjPCA4ogZV
         8LoDIw1DiFSg8o2/qISrWYkBKqRm2O3+JNiG7/jNqUx9LBF/K4fbbOkEXJwuRGVv3KUY
         mTboxgTCPNzHixoPtO4O9WASZ7D5ikJKBM+pxq4EesV30KC8WyugG9lDezDMkjG10QkS
         W/2Hwlu8DzSQgW8oDVINLt2/aTPQm4IioI933jsvwYGBS1uziGZkRd00ySSYBjyeP9VV
         LHCJ+It5Sp1nzNpaplN7I7Hq2AwwsFGCPdTghlNMQM0tr6XXkMi7zRbsdZuhI3EH4pT6
         m/zw==
X-Gm-Message-State: ABy/qLbhgShI5Ag0Oxl0mBqqA8Q66ovlpQj8X6X2FGpGlG9ZSynkMeiw
	WhsPXDMLCZhkHulMoudngzSCw6z/YgU=
X-Google-Smtp-Source: APBJJlGUaaiUxSD6v+uHtzJn5Bok5HEB27UnUCHcnqVc3N6UWv+PT7JG5G0++htnoOGnrQBKyXgZZKI8MMA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:eb14:0:b0:56c:e585:8b19 with SMTP id
 n20-20020a81eb14000000b0056ce5858b19mr22779ywm.2.1690591065884; Fri, 28 Jul
 2023 17:37:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 28 Jul 2023 17:36:40 -0700
In-Reply-To: <20230729003643.1053367-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729003643.1053367-32-seanjc@google.com>
Subject: [PATCH v4 31/34] KVM: selftests: Convert x86's XCR0 test to use
 printf-based guest asserts
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Thomas Huth <thuth@redhat.com>, 
	"=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Convert x86's XCR0 vs. CPUID test to use printf-based guest asserts.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/xcr0_cpuid_test.c    | 29 ++++++++++++-------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c b/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c
index 905bd5ae4431..5e8290797720 100644
--- a/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c
@@ -4,6 +4,7 @@
  *
  * Copyright (C) 2022, Google LLC.
  */
+#define USE_GUEST_ASSERT_PRINTF 1
 
 #include <fcntl.h>
 #include <stdio.h>
@@ -20,13 +21,14 @@
  * Assert that architectural dependency rules are satisfied, e.g. that AVX is
  * supported if and only if SSE is supported.
  */
-#define ASSERT_XFEATURE_DEPENDENCIES(supported_xcr0, xfeatures, dependencies)	  \
-do {										  \
-	uint64_t __supported = (supported_xcr0) & ((xfeatures) | (dependencies)); \
-										  \
-	GUEST_ASSERT_3((__supported & (xfeatures)) != (xfeatures) ||		  \
-		       __supported == ((xfeatures) | (dependencies)),		  \
-		       __supported, (xfeatures), (dependencies));		  \
+#define ASSERT_XFEATURE_DEPENDENCIES(supported_xcr0, xfeatures, dependencies)		\
+do {											\
+	uint64_t __supported = (supported_xcr0) & ((xfeatures) | (dependencies));	\
+											\
+	__GUEST_ASSERT((__supported & (xfeatures)) != (xfeatures) ||			\
+		       __supported == ((xfeatures) | (dependencies)),			\
+		       "supported = 0x%llx, xfeatures = 0x%llx, dependencies = 0x%llx",	\
+		       __supported, (xfeatures), (dependencies));			\
 } while (0)
 
 /*
@@ -41,7 +43,8 @@ do {										  \
 do {									\
 	uint64_t __supported = (supported_xcr0) & (xfeatures);		\
 									\
-	GUEST_ASSERT_2(!__supported || __supported == (xfeatures),	\
+	__GUEST_ASSERT(!__supported || __supported == (xfeatures),	\
+		       "supported = 0x%llx, xfeatures = 0x%llx",	\
 		       __supported, (xfeatures));			\
 } while (0)
 
@@ -79,14 +82,18 @@ static void guest_code(void)
 				    XFEATURE_MASK_XTILE);
 
 	vector = xsetbv_safe(0, supported_xcr0);
-	GUEST_ASSERT_2(!vector, supported_xcr0, vector);
+	__GUEST_ASSERT(!vector,
+		       "Expected success on XSETBV(0x%llx), got vector '0x%x'",
+		       supported_xcr0, vector);
 
 	for (i = 0; i < 64; i++) {
 		if (supported_xcr0 & BIT_ULL(i))
 			continue;
 
 		vector = xsetbv_safe(0, supported_xcr0 | BIT_ULL(i));
-		GUEST_ASSERT_3(vector == GP_VECTOR, supported_xcr0, vector, BIT_ULL(i));
+		__GUEST_ASSERT(vector == GP_VECTOR,
+			       "Expected #GP on XSETBV(0x%llx), supported XCR0 = %llx, got vector '0x%x'",
+			       BIT_ULL(i), supported_xcr0, vector);
 	}
 
 	GUEST_DONE();
@@ -117,7 +124,7 @@ int main(int argc, char *argv[])
 
 		switch (get_ucall(vcpu, &uc)) {
 		case UCALL_ABORT:
-			REPORT_GUEST_ASSERT_3(uc, "0x%lx 0x%lx 0x%lx");
+			REPORT_GUEST_ASSERT(uc);
 			break;
 		case UCALL_DONE:
 			goto done;
-- 
2.41.0.487.g6d72f3e995-goog

