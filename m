Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476D57C
	for <kvmarm@lists.linux.dev>; Sat, 29 Jul 2023 00:37:23 +0000 (UTC)
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-267f00f6876so1723096a91.3
        for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 17:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591042; x=1691195842;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4KUkVA9WMnyLxYGz79SDCJn7ve+A3Wf1F6DPB0+B89Y=;
        b=m1lnc4WNUUb4LhX1UCRMwTzJ/kua4mNB+cCI2zAZJDw/YuWyBNC/mjTXyBnbABdSwK
         XlTEeooUTC/+KEnZs8SdsD7KD4D5QT2j61EexSFXezqGR/jmMDfqT8QirXCkaEUchBzC
         yQnQHpQKSbauSGLL1v1IXcHYKGUzNuLGMNkFvyI4TcWFeI2ssuz9YaMH0Oei27k/Nyon
         5p7fEQS3naCoN6/hzKKe7XVSJuuPLuc5vpk+ZhrcR46/7R1M/CvlAIb/SNLlgSZcRNvd
         /rG6QtBHZYxac3GXVkkOzTpCaNB7ZTUbXG+aooqbeSQfPP1kS8AIrJeT4F/CLnedG0IS
         LNzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591042; x=1691195842;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4KUkVA9WMnyLxYGz79SDCJn7ve+A3Wf1F6DPB0+B89Y=;
        b=kX4g2Kzx610JpH6V6XkPs99219KQLOqVF+IL1NRDbhRswABl9kfsWl9LAYBbsDUgMi
         qhIPyn3zzXpC/te/Jm44JEqAQz0CtsnfM6I0bAefYDU1usBemTYWH36TWXVSvfvVrs0t
         QF0GYatTOua4jiRcXrd+QlgWmpllfmk42HDEpaCcc2mDk/eV0BwNpS4i12NgLxFh4z8D
         rjyI28UErb18ZfD30DkO3rs+pp4ZGXjbb/L6gmgn61w61tWfY3yr40wIxNUtOr4k7bzp
         RK/QQ00KeNbS1RVUiauz9OjBN7DLdaphKqh3EBOVrPbfd4MEYc6MRHupBVDQV+QXboKQ
         +Oxw==
X-Gm-Message-State: ABy/qLaLvCsbVO4f1As9ckH3p8kg9hr6Z08Q6sRCG7bWy6A2ru2R6vIH
	5Xt5oD0FL4Pi9kpdgiCW+ManvQBHlXY=
X-Google-Smtp-Source: APBJJlGuA7vi3U6gzhB6JqQWicL1WyEr3IUOwMBH5vFB9eArqoqzqemY3es1drglI/28nECd76urnf6xTrY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d4c9:b0:1bb:8c42:79f4 with SMTP id
 o9-20020a170902d4c900b001bb8c4279f4mr11146plg.2.1690591042672; Fri, 28 Jul
 2023 17:37:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 28 Jul 2023 17:36:28 -0700
In-Reply-To: <20230729003643.1053367-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729003643.1053367-20-seanjc@google.com>
Subject: [PATCH v4 19/34] KVM: selftests: Convert steal_time test to printf
 style GUEST_ASSERT
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Thomas Huth <thuth@redhat.com>, 
	"=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Convert the steal_time test to use printf-based GUEST_ASERT.
Opportunistically use GUEST_ASSERT_EQ() and GUEST_ASSERT_NE() so that the
test spits out debug information on failure.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/steal_time.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index c87f38712073..8649c8545882 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -4,6 +4,8 @@
  *
  * Copyright (C) 2020, Red Hat, Inc.
  */
+#define USE_GUEST_ASSERT_PRINTF 1
+
 #define _GNU_SOURCE
 #include <stdio.h>
 #include <time.h>
@@ -31,8 +33,8 @@ static uint64_t guest_stolen_time[NR_VCPUS];
 static void check_status(struct kvm_steal_time *st)
 {
 	GUEST_ASSERT(!(READ_ONCE(st->version) & 1));
-	GUEST_ASSERT(READ_ONCE(st->flags) == 0);
-	GUEST_ASSERT(READ_ONCE(st->preempted) == 0);
+	GUEST_ASSERT_EQ(READ_ONCE(st->flags), 0);
+	GUEST_ASSERT_EQ(READ_ONCE(st->preempted), 0);
 }
 
 static void guest_code(int cpu)
@@ -40,7 +42,7 @@ static void guest_code(int cpu)
 	struct kvm_steal_time *st = st_gva[cpu];
 	uint32_t version;
 
-	GUEST_ASSERT(rdmsr(MSR_KVM_STEAL_TIME) == ((uint64_t)st_gva[cpu] | KVM_MSR_ENABLED));
+	GUEST_ASSERT_EQ(rdmsr(MSR_KVM_STEAL_TIME), ((uint64_t)st_gva[cpu] | KVM_MSR_ENABLED));
 
 	memset(st, 0, sizeof(*st));
 	GUEST_SYNC(0);
@@ -122,8 +124,8 @@ static int64_t smccc(uint32_t func, uint64_t arg)
 
 static void check_status(struct st_time *st)
 {
-	GUEST_ASSERT(READ_ONCE(st->rev) == 0);
-	GUEST_ASSERT(READ_ONCE(st->attr) == 0);
+	GUEST_ASSERT_EQ(READ_ONCE(st->rev), 0);
+	GUEST_ASSERT_EQ(READ_ONCE(st->attr), 0);
 }
 
 static void guest_code(int cpu)
@@ -132,15 +134,15 @@ static void guest_code(int cpu)
 	int64_t status;
 
 	status = smccc(SMCCC_ARCH_FEATURES, PV_TIME_FEATURES);
-	GUEST_ASSERT(status == 0);
+	GUEST_ASSERT_EQ(status, 0);
 	status = smccc(PV_TIME_FEATURES, PV_TIME_FEATURES);
-	GUEST_ASSERT(status == 0);
+	GUEST_ASSERT_EQ(status, 0);
 	status = smccc(PV_TIME_FEATURES, PV_TIME_ST);
-	GUEST_ASSERT(status == 0);
+	GUEST_ASSERT_EQ(status, 0);
 
 	status = smccc(PV_TIME_ST, 0);
-	GUEST_ASSERT(status != -1);
-	GUEST_ASSERT(status == (ulong)st_gva[cpu]);
+	GUEST_ASSERT_NE(status, -1);
+	GUEST_ASSERT_EQ(status, (ulong)st_gva[cpu]);
 
 	st = (struct st_time *)status;
 	GUEST_SYNC(0);
-- 
2.41.0.487.g6d72f3e995-goog

