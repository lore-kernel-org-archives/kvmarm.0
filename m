Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3749A7C
	for <kvmarm@lists.linux.dev>; Sat, 29 Jul 2023 00:37:21 +0000 (UTC)
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1bbf8cb6143so2058695ad.1
        for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 17:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591040; x=1691195840;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=62IIfbK+fVHnQpHB0LZHeva+9zsTyACR3DAXgqGUpUY=;
        b=SjpYkHcU8DfvLPEP6EE3BSTR/2/6/dg3QI3BV6WrrOhgfT/Axj5gvHKmQEj21aynvu
         IfZBARD2/rsjLEVGbvM2z0q99N1PWdAcl7DYCxNnNaLdHcIlkyRkdk/nbDMn7F9+/a8e
         CuhyiC1DAy4v3U+R4k7YfRnm9iEAN42L+6VgqENHy+0Z6wsFjfHa7L8g5WSPsmjJnyFt
         JMTcqvgBf/Y0L040z/FF0Q6nEsDXIJggJlKlAjnI6jY0WsZnbHhBByPRE33YgvMkNqkb
         Z4gitISbvjzVi4D6FyklqEUoPL0KOcodWo1FLrcSiCq7BZ7n03kIFlkuicSVwDz5Bgxw
         MEig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591040; x=1691195840;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=62IIfbK+fVHnQpHB0LZHeva+9zsTyACR3DAXgqGUpUY=;
        b=H9VusmXIXaDbbHmiE6y8G0qYxbskZKQpx+pXn+nsQ8xBG6SbhEfWb2f61UqQOHvKmO
         vxL96z9cZe9vKfHXa9IAM+9LGLUq5RgrUmeuSgawJFji57D2nobafPatxaoAeyzn6Aw6
         f3jLdAfEG+JNAZfh6a5yAnHqQdx3HgKDldFbZsRvjIW8t+baO1j7aktXzWIlDVdynm2z
         mt9OPRJ4jfS3h22ayQu2xrGhANPxL3InAfozAFCL69Wj0qsoJ3lJgRksdKL7qikYE0q3
         tpaxBejVBvXdAs4/GrhS7BLDipD+F2+iQqXBfWjMjxwDVJB/2jQhz9vByfLvIVNdzg2h
         gmDw==
X-Gm-Message-State: ABy/qLaHKyFC3TVNRp83Lj5P4ZitVkHmpj4BNrTzVlmaylRi2lJ7Ri2q
	L4TQtnM1N5NDpEuwk0oOIrbot9hElrs=
X-Google-Smtp-Source: APBJJlH6iRT9Dvs1GTfRtC3q4lJnWblWrURV+JKeAmNtjrPWw6VO8hwBqRMxcLpxte+WdCjaXOyJVdz5jAY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:1d1:b0:1b5:2496:8c0d with SMTP id
 e17-20020a17090301d100b001b524968c0dmr12013plh.3.1690591040630; Fri, 28 Jul
 2023 17:37:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 28 Jul 2023 17:36:27 -0700
In-Reply-To: <20230729003643.1053367-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729003643.1053367-19-seanjc@google.com>
Subject: [PATCH v4 18/34] KVM: selftests: Convert set_memory_region_test to
 printf-based GUEST_ASSERT
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Thomas Huth <thuth@redhat.com>, 
	"=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Convert set_memory_region_test to print-based GUEST_ASSERT, using a combo
of newfangled macros to report (hopefully) useful information.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/set_memory_region_test.c    | 23 +++++++++++--------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index a849ce23ca97..dd8f4bac9df8 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -1,4 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
+#define USE_GUEST_ASSERT_PRINTF 1
+
 #define _GNU_SOURCE /* for program_invocation_short_name */
 #include <fcntl.h>
 #include <pthread.h>
@@ -88,7 +90,7 @@ static void *vcpu_worker(void *data)
 	}
 
 	if (run->exit_reason == KVM_EXIT_IO && cmd == UCALL_ABORT)
-		REPORT_GUEST_ASSERT_1(uc, "val = %lu");
+		REPORT_GUEST_ASSERT(uc);
 
 	return NULL;
 }
@@ -156,19 +158,22 @@ static void guest_code_move_memory_region(void)
 	 * window where the memslot is invalid is usually quite small.
 	 */
 	val = guest_spin_on_val(0);
-	GUEST_ASSERT_1(val == 1 || val == MMIO_VAL, val);
+	__GUEST_ASSERT(val == 1 || val == MMIO_VAL,
+		       "Expected '1' or MMIO ('%llx'), got '%llx'", MMIO_VAL, val);
 
 	/* Spin until the misaligning memory region move completes. */
 	val = guest_spin_on_val(MMIO_VAL);
-	GUEST_ASSERT_1(val == 1 || val == 0, val);
+	__GUEST_ASSERT(val == 1 || val == 0,
+		       "Expected '0' or '1' (no MMIO), got '%llx'", val);
 
 	/* Spin until the memory region starts to get re-aligned. */
 	val = guest_spin_on_val(0);
-	GUEST_ASSERT_1(val == 1 || val == MMIO_VAL, val);
+	__GUEST_ASSERT(val == 1 || val == MMIO_VAL,
+		       "Expected '1' or MMIO ('%llx'), got '%llx'", MMIO_VAL, val);
 
 	/* Spin until the re-aligning memory region move completes. */
 	val = guest_spin_on_val(MMIO_VAL);
-	GUEST_ASSERT_1(val == 1, val);
+	GUEST_ASSERT_EQ(val, 1);
 
 	GUEST_DONE();
 }
@@ -224,15 +229,15 @@ static void guest_code_delete_memory_region(void)
 
 	/* Spin until the memory region is deleted. */
 	val = guest_spin_on_val(0);
-	GUEST_ASSERT_1(val == MMIO_VAL, val);
+	GUEST_ASSERT_EQ(val, MMIO_VAL);
 
 	/* Spin until the memory region is recreated. */
 	val = guest_spin_on_val(MMIO_VAL);
-	GUEST_ASSERT_1(val == 0, val);
+	GUEST_ASSERT_EQ(val, 0);
 
 	/* Spin until the memory region is deleted. */
 	val = guest_spin_on_val(0);
-	GUEST_ASSERT_1(val == MMIO_VAL, val);
+	GUEST_ASSERT_EQ(val, MMIO_VAL);
 
 	asm("1:\n\t"
 	    ".pushsection .rodata\n\t"
@@ -249,7 +254,7 @@ static void guest_code_delete_memory_region(void)
 	    "final_rip_end: .quad 1b\n\t"
 	    ".popsection");
 
-	GUEST_ASSERT_1(0, 0);
+	GUEST_ASSERT(0);
 }
 
 static void test_delete_memory_region(void)
-- 
2.41.0.487.g6d72f3e995-goog

