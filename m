Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BEC24519AC
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 17:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785517593; cv=none; b=L24VorGgYZ4Dk5axCQpsKwDhv8mJjZAQ9h5HRpR+0XGjX7IdSubvcXeh3P3HQrLTt7/Br5bIhTgtbbncqmdfygDaVo1J+iF4Lf+ndOm+klwGjWpVNzIFvK8k5lS9MBMYv6GfAY+ZUOS8a2D4lJ4WHJfkpL9oAhm9L/nk+eEqKBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785517593; c=relaxed/simple;
	bh=JuNyQeBG82czs+HN+A+wHJX43qaOj8+9Nl8By6b2l/k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gGLJdvTPscsUPIBXcm0ofBDDcesEe6By8IGph8znRz3xBIjwmQdHVcyYDuFBL5CS8w4kFEbjGsq3oEVJzmJ+ArMsO/VSopiyH3KE6jUSdW2ZsmpsphSKGf5g4g/W9h9awv18Z5aOYRsMX0vmhcb96BEB+MRb1ts5C7ZYu3+BnSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kfTr++L6; arc=none smtp.client-ip=209.85.210.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kfTr++L6"
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-84a3514f912so2134733b3a.3
        for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 10:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785517592; x=1786122392; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=F2wB8IP388Lc2MBAteJRNDo31xEFc0D1s8JJGVqmoX8=;
        b=kfTr++L65mo3WMGdzuI4Q/D3swca4E0DN+QM/MfE389RWJk/vb09T4hD5IEBfsiHXg
         0QowHS42uyPuQuqE8BT9d63BSlr4UwWLUVgrx7vwCSmNAB9OOKAx1v8e0MBF3IOZHV1s
         qZrA6EwWYqJpXooGSERsoa3YuYwWgCNusGHkq3wY4bkgfECxWhYEo0m5NSZiBe2Tt3Ya
         JjlRr2LYMFRDbWrRJHjy3HY7I6BLnaGLPsmioztGF7w12wV9s+90yBelmcJIbMq/xTx5
         PIAfO+5e5bhf1P0EXnJZR+bKNvP1M/sKbK/OkFUaHhQLaKDvz3QIUTaIpdx9VhHY2I34
         KCSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785517592; x=1786122392;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=F2wB8IP388Lc2MBAteJRNDo31xEFc0D1s8JJGVqmoX8=;
        b=iCilQBMLO1srVGbbcVi8POdsCeEqsqNW1Sb23udAOrQAEXzKl76rWk2TWFH+lPQ6Uy
         zS/JrqLlqvVr2z3hCyGyj2H15nqTYvAOXSj9gonsP+eCS1i0oxvMps+oaUilubE+cVfo
         vsxv++4eyxyHgxqWAQ2vais2Ps/u5Hz5ZEzgTg/5S+olsV7axxoGX4ZHiJnqAnsoaehZ
         rZOnq8kOFNwLsl730cgDdG69mtI59Y8Mq2atArfph42NyGGn12JFD7veJBMB7v5G/GJw
         QzIpO6LBz7QjmA4q8iZiXcSB3yReyhLu2JUAn6aXGyH8dfY14ffcYk9INLjV/PmU7EMc
         38Jw==
X-Forwarded-Encrypted: i=1; AHgh+RoyuMDxtBXNi52FE819fXaQiSkjodEdnQjYvgx421dWuLAsTF7V0m6dEdq0qvM3JC0Vc9fo/b8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy/3UcQfp6ODcZqkuFtfFpUSMnwgsyAMJS+HL8xHR5PTd2Vbizd
	pLmQWGj9nwuVsy+S5AMwvBj5jBN/Oymf1KlA+ShdBT5IYpERfIm1CKvejgJfhAyd6k7f2hAPUEt
	X2gQM3g==
X-Received: from pfbdc10.prod.google.com ([2002:a05:6a00:35ca:b0:84c:2b7d:213b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:885:b0:847:8c4e:1d5e
 with SMTP id d2e1a72fcca58-84ee48f8431mr387593b3a.56.1785517591199; Fri, 31
 Jul 2026 10:06:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jul 2026 10:06:14 -0700
In-Reply-To: <20260731170619.2620845-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260731170619.2620845-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260731170619.2620845-8-seanjc@google.com>
Subject: [PATCH v2 07/12] KVM: selftests: Drop unreachable, dead code from
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
index bd23c1300370..b8115b2dcae3 100644
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
 
 	pthread_attr_init(&attr);
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

