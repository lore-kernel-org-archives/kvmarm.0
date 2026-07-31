Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4B13793BF
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 19:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785527790; cv=none; b=Ae6cREi1dupHT467iEtVwGJcEydyr22EKiGZZSob4pV89FVpLP2b7zUYYzrURRmNZgThmccCK8TOlBaCvh5qn48DGGnKoZ3m7cX/VGoQRmxgSW1ZPMtS6IVsWWcSUluM7G9LCPkITet3dtSvMFQmIn6H2HpPuWAZhgsPoeCXHT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785527790; c=relaxed/simple;
	bh=GSlZ/QfH22uYNIQc6bnCNCACqwR92zhApm/uHM2zGa0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dyup4iIldl+a4dBpQBXGJgEy3RN11aL6hbNksxg/PtG0s0c3aPnTSa1bMy9O5vmvg8FhFVYQ0OC7bbr9dScRw85GnUcgb8reXjfbkvCGWWopsGjVy9Sue2sYAlRYVMSaVL7NNh7JkRzrlWfy2vAxGvKcKv8AGLQmQmOuEvfk0ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=N8qVmrJX; arc=none smtp.client-ip=209.85.210.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="N8qVmrJX"
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-84a251c2e3eso3014035b3a.1
        for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 12:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785527784; x=1786132584; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=NUF7ZMtALHs5ft2o/4IkbgfVOeTdBoOGjjUFtC1Jiy0=;
        b=N8qVmrJXGach8lxb8b8Ys+vKCb3hdIiYAjDHCR96DtlKFjCP7yjkyFkYm0bQHm2Egg
         C4qhdsGCZ5Q3iES4J6+T6V8ZtcNQvPNKPsT4mBAa1piLbKRSCWv+RVdvpIgU/ZZie+f/
         jXY1vrhRWGCohqwei8IsIADKWusKS2YG6cPu+o+xBHqeT/zn8gjSb2ccpJ3fz1JZ2sqV
         DNuhLNlKaeV4yec+ODaElRFV21ilvdVqHyxI8k9XTcn0wrzWzU8dofEitmlcbe35v73c
         0/JEuVKhhq1pqJvXgS9TyZ+xXXWz+SOrmnFVh1Sfi4p7VyepXGHsJKeKxydacPsUmTer
         rnHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785527784; x=1786132584;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NUF7ZMtALHs5ft2o/4IkbgfVOeTdBoOGjjUFtC1Jiy0=;
        b=Tp9nO16i08RrO2TFDh8Mao6VDDgRd6MrsVHhlbeLOb/EdPFaw7/KGVw4NrvZ1yn5Vj
         AbRhu12DKhQLWuzpmnG0hqeQA1m3ERKFN4JV2DHo8p+YlN4tMu8+0r590TqTjJrJBMKF
         EeTKHqxBwWAGvjxUoksq5o/BLXGMartBuQoRJKOeeQ4nZRoGr9hXHS2uB0WgPvnte+oe
         5g0RBZztbJWT6IB34Jxwj2tlrkDtPVQ6WUDSsHBFUZJYWgzCdkDsbiJXvx0D0ioESrdf
         4u719XxBR4ThggADEKaoqwICf6so8PudwZqEah48qHVFsbB+2Xol6XqDvzBAfGY9iINC
         LerA==
X-Forwarded-Encrypted: i=1; AHgh+Rp8MMCN1WrRaEyBqzwV5abPOT1H46h2z2osM85ygwj7swgeZx6dBGgeKVnxAlPP6cszfi63kys=@lists.linux.dev
X-Gm-Message-State: AOJu0YxB7idbLpvHnGwkdOQt10i+pcQ1K692xyjb+Xd7KNaedsnqYSNQ
	byHauUCCFdDzvsKocfRiTHdY6giFjuTi1zfNBc/XyVaaFt+Km3q3991zsaDaTu2sLkJ1UHi8f98
	ewQEqJA==
X-Received: from pfva4.prod.google.com ([2002:a05:6a00:c84:b0:845:4ca2:60a5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1d8c:b0:845:df5c:2567
 with SMTP id d2e1a72fcca58-84ee492fc27mr727552b3a.25.1785527784352; Fri, 31
 Jul 2026 12:56:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jul 2026 12:56:07 -0700
In-Reply-To: <20260731195612.2697986-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260731195612.2697986-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260731195612.2697986-8-seanjc@google.com>
Subject: [PATCH v3 07/12] KVM: selftests: Drop unreachable, dead code from
 hardware disable test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	David Hildenbrand <david@kernel.org>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Drop all of the code that is unreachable in the hardware disable test, as
it adds a lot of noise that makes the test seem far more complicated than
it actually is.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/hardware_disable_test.c     | 41 +++++++------------
 1 file changed, 14 insertions(+), 27 deletions(-)

diff --git a/tools/testing/selftests/kvm/hardware_disable_test.c b/tools/testing/selftests/kvm/hardware_disable_test.c
index fcc06c602fca..de8e63da7b58 100644
--- a/tools/testing/selftests/kvm/hardware_disable_test.c
+++ b/tools/testing/selftests/kvm/hardware_disable_test.c
@@ -15,6 +15,7 @@
 #include <test_util.h>
 
 #include "kvm_util.h"
+#include "ucall_common.h"
 
 #define VCPU_NUM 4
 #define SLEEPING_THREAD_NUM (1 << 4)
@@ -28,7 +29,7 @@ static void guest_code(void)
 {
 	for (;;)
 		;  /* Some busy work */
-	printf("Should not be reached.\n");
+	GUEST_ASSERT(0);
 }
 
 static void *run_vcpu(void *arg)
@@ -42,10 +43,8 @@ static void *run_vcpu(void *arg)
 
 	vcpu_run(vcpu);
 
-	TEST_ASSERT(false, "%s: exited with reason %d: %s",
-		    __func__, run->exit_reason,
-		    exit_reason_str(run->exit_reason));
-	pthread_exit(NULL);
+	TEST_FAIL("vCPU%d exited with reason %d: %s",
+		  vcpu->id, run->exit_reason, exit_reason_str(run->exit_reason));
 }
 
 static void *sleeping_thread(void *arg)
@@ -56,12 +55,11 @@ static void *sleeping_thread(void *arg)
 	kvm_sched_setaffinity(0, sizeof(cpu_set_t), &threads_cpu_set);
 #endif
 
-	while (true) {
+	while (1) {
 		fd = open("/dev/null", O_RDWR);
 		close(fd);
 	}
-	TEST_ASSERT(false, "%s: exited", __func__);
-	pthread_exit(NULL);
+	TEST_FAIL("%s: exited", __func__);
 }
 
 static inline void check_create_thread(pthread_t *thread, pthread_attr_t *attr,
@@ -73,22 +71,12 @@ static inline void check_create_thread(pthread_t *thread, pthread_attr_t *attr,
 	TEST_ASSERT(r == 0, "%s: failed to create thread", __func__);
 }
 
-static inline void check_join(pthread_t thread, void **retval)
-{
-	int r;
-
-	r = pthread_join(thread, retval);
-	TEST_ASSERT(r == 0, "%s: failed to join thread", __func__);
-}
-
 static void run_test(u32 run)
 {
 	struct kvm_vcpu *vcpu;
 	pthread_attr_t attr;
 	struct kvm_vm *vm;
-	pthread_t threads[VCPU_NUM];
-	pthread_t throw_away;
-	void *b;
+	pthread_t thread;
 	u32 i, j;
 
 	TEST_ASSERT_EQ(pthread_attr_init(&attr), 0);
@@ -102,19 +90,18 @@ static void run_test(u32 run)
 	for (i = 0; i < VCPU_NUM; ++i) {
 		vcpu = vm_vcpu_add(vm, i, guest_code);
 
-		check_create_thread(&threads[i], &attr, run_vcpu, vcpu);
+		check_create_thread(&thread, &attr, run_vcpu, vcpu);
 
-		for (j = 0; j < SLEEPING_THREAD_NUM; ++j) {
-			check_create_thread(&throw_away, &attr, sleeping_thread,
+		for (j = 0; j < SLEEPING_THREAD_NUM; ++j)
+			check_create_thread(&thread, &attr, sleeping_thread,
 					    (void *)NULL);
-		}
 	}
 	pr_debug("%s: [%d] all threads launched\n", __func__, run);
 	sem_post(sem);
-	for (i = 0; i < VCPU_NUM; ++i)
-		check_join(threads[i], &b);
-	/* Should not be reached */
-	TEST_ASSERT(false, "%s: [%d] child escaped the ninja", __func__, run);
+
+	/* Wait for the parent to SIGKILL this child. */
+	while (1)
+		pause();
 }
 
 void wait_for_child_setup(pid_t pid)
-- 
2.55.0.508.g3f0d502094-goog

