Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F49A38E
	for <kvmarm@lists.linux.dev>; Sat, 29 Jul 2023 00:37:31 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d05883d850fso2488426276.3
        for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 17:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591050; x=1691195850;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=u2EIFWrBLGEnIiN/EFJ5XRmezLxqqm+61iiHmkdd9ak=;
        b=TIIFj9PRB7w7knxR4gGCXPFWprbCc6PSg9bZdqeQNgOIr8n4lBUcFDZnrj3QtXE6nu
         LT7OVvjwtMrAeu0gPoA5V4phKY1ayY/jFxjHHj4KHYmdKbTaWR+HVw5JhWp5QpmEHtPQ
         r3nOgYRipUN2H2CkKumNFOEEdfgGc8tndwAlLM5yNrUDmZRqDycA+OFsTczRw3p1Ixzt
         nCWPRmwKCpJHn4Y74RBkJqDY9ab5UY4rZLZaMcC4Ec12Wnh0ni/LvbvBdt0YaXmyhF15
         KHpSU49BiLispdDH9IcnQsp8yk8N5ZPxjboEL8tLmbT5z0ASXh3ruBWkK444oxHt16uX
         DsZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591050; x=1691195850;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u2EIFWrBLGEnIiN/EFJ5XRmezLxqqm+61iiHmkdd9ak=;
        b=F7A68fUQTSlD71Y1XYGHz4YXN++T62dS60upzR44GbuaPxqZDbRQuDFmlggnHfuFP+
         qllBP1LW93p1hOCLJNuQOfPwMpiZjObLXMUwJEZ96yk3OSkY+9RRUrTcZpZudD6/Zo+V
         FRTD0CT8xNNq5lv8CActohGzFnEUs6j+wOjp+Ybt/muNPdJR6bZMfYGToa6J5DSf6f3V
         5elfTcNt2dmNtDqqHxsDax/IEJUUk1nQvXu5YzkSUqFJRFQqvq6OBB04Y0XbqWLZYy3S
         ihW/g8O2WX950EmD3nPLCQ7bHVsJU5OZ1jZFbCcD4A2VpmWbtMMrNMM/7KSvTLpFti0m
         weaQ==
X-Gm-Message-State: ABy/qLbldvwDD5zh8lpeGuMUG6rwnFr0aIh+CKLy2wsuCKMjvs5XC5wz
	ndUQxFwDOmn/zhb9QOPRz8TLk4Wm9J0=
X-Google-Smtp-Source: APBJJlHE48bzeCyOTilENfSay/pSrMUoqERzzk5XcsIhTPUOx1NnLk0AtqS5bz6Uj5fvFPTyTHsRaarOSPo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ac48:0:b0:d15:d6da:7e97 with SMTP id
 r8-20020a25ac48000000b00d15d6da7e97mr16764ybd.3.1690591050399; Fri, 28 Jul
 2023 17:37:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 28 Jul 2023 17:36:32 -0700
In-Reply-To: <20230729003643.1053367-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729003643.1053367-24-seanjc@google.com>
Subject: [PATCH v4 23/34] KVM: selftests: Convert x86's KVM paravirt test to
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

Convert x86's KVM paravirtualization test to use the printf-based
GUEST_ASSERT_EQ().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/kvm_pv_test.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
index f774a9e62858..1c28b77ff3cd 100644
--- a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
@@ -4,6 +4,8 @@
  *
  * Tests for KVM paravirtual feature disablement
  */
+#define USE_GUEST_ASSERT_PRINTF 1
+
 #include <asm/kvm_para.h>
 #include <linux/kvm_para.h>
 #include <stdint.h>
@@ -46,10 +48,10 @@ static void test_msr(struct msr_data *msr)
 	PR_MSR(msr);
 
 	vector = rdmsr_safe(msr->idx, &ignored);
-	GUEST_ASSERT_1(vector == GP_VECTOR, vector);
+	GUEST_ASSERT_EQ(vector, GP_VECTOR);
 
 	vector = wrmsr_safe(msr->idx, 0);
-	GUEST_ASSERT_1(vector == GP_VECTOR, vector);
+	GUEST_ASSERT_EQ(vector, GP_VECTOR);
 }
 
 struct hcall_data {
@@ -77,7 +79,7 @@ static void test_hcall(struct hcall_data *hc)
 
 	PR_HCALL(hc);
 	r = kvm_hypercall(hc->nr, 0, 0, 0, 0);
-	GUEST_ASSERT(r == -KVM_ENOSYS);
+	GUEST_ASSERT_EQ(r, -KVM_ENOSYS);
 }
 
 static void guest_main(void)
@@ -125,7 +127,7 @@ static void enter_guest(struct kvm_vcpu *vcpu)
 			pr_hcall(&uc);
 			break;
 		case UCALL_ABORT:
-			REPORT_GUEST_ASSERT_1(uc, "vector = %lu");
+			REPORT_GUEST_ASSERT(uc);
 			return;
 		case UCALL_DONE:
 			return;
-- 
2.41.0.487.g6d72f3e995-goog

