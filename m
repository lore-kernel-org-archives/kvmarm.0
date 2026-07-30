Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B990443F0BE
	for <kvmarm@lists.linux.dev>; Thu, 30 Jul 2026 19:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785439159; cv=none; b=ctjW9wk6lJtRlrwkySmcdEFTwVdXCQ3Fpwc8HPXeawXu6O4kB9DmhHvIKmoqh+9htgD7rE24eOLQPYGcPl6kxqSJj8/cMWkB7rkr+5oW1tlvSY9PAa2n4nzA49C3YPWj6Lc3oxFrmGu2ju2hQuAQ0Als8GpGQ5MRiURWCMVZMfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785439159; c=relaxed/simple;
	bh=lwh4ys9HIR2gOOVKZEfdEzqJQI0Ip7JtSbwGpkz2B/I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sKzqzWwNODu/Sgk0OZCYxMYHY6LQ86ZCOJwNqjQeCfUdr1h5jvt9HTw5sH55G30zT7MUeY5PgUEsB0bSJM2KsJn/wZyeJ1rDk9F2E6++e5YrFlhqlZAgDS3k30UlGJYnwNC7VkWvIXIi+id1JV7DNsA/1JYdzvDxenfuz209mwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vhdAgb1d; arc=none smtp.client-ip=209.85.210.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vhdAgb1d"
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-84c4cd31b51so1348578b3a.0
        for <kvmarm@lists.linux.dev>; Thu, 30 Jul 2026 12:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785439156; x=1786043956; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=o2DcwzlrubCNuT24RD/nTN5cT+um7dgpX6VefWZNk0A=;
        b=vhdAgb1dS5f43hmK4pQ6zg3UoZrAKTukd+PLxtzr+PLmsZh4/D0+x9h1rgh65csCtU
         ROwML9jnPIqhFLKEXIIGjCZeiE4er31nnx9uh2ga1+mdWWPx2Lf4rbadsKe3N67a46rN
         SI76kxjFdHc0bz/0fn8Sn0PrAePqpICFp6WGCtqPvEheFtD6PAvZvWPIIpu9y0rn4u+q
         uB7q486jrT76if/Am1tTd/NH1J0f807O7j24cBpTUH6H+0OphCvhlcoQKz5Y7/zh0olf
         iWpNO7Uwf7bbFgayouV4QCb+wGKwXTEQWlJsl5VzWbF7IZ5Q8IiDjU+1St5umEuC5CWS
         QBBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785439156; x=1786043956;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=o2DcwzlrubCNuT24RD/nTN5cT+um7dgpX6VefWZNk0A=;
        b=J7MuIXpJxz68krSBDmDaLtYLv1LLPLVh8FXJlK0/HUDQa3SrKp3fnqAsJBBWTPc9lQ
         WEaoJNORaYgWe/ZwfqlEF07OMojWdOE8ldcpBEX3EL8RsR5JN6Igry35A8Hg+wvSvjUv
         KFkkfa3U1GFjnUEiDrJQ38/MCaPk/dNTdnq1j93P5pLH93eLUzqtxt6HDcYoKYprspM1
         vI5M8J175yQPD2se3vijGxfH0qXRDku6284rCxkrnBQtKugSFw6/ozQeQv4AugHs3cWK
         r4sd/A+Ht6oE9PovpVO3gpVS9z42ddFkPCaLs1erlTjHscTRzLTRCSqFWqpMtHZyjAdK
         Cm2Q==
X-Forwarded-Encrypted: i=1; AHgh+RqwUGVBqseNr9mTpdZHlEvHknCSXF9m79E1hU2O9Iks6tRqXlZkuI8bPy7KkY8+lOgL7Pmy/tc=@lists.linux.dev
X-Gm-Message-State: AOJu0YwWYshsglUGH+RmLcdj8zFer06a4vKjfO+kkeYHqsjOSALtICks
	bnz66Lwt0bIDboKRYia13ibotDww/FR3c5HtN+19yQAkRhFvJTU75bBdf/MSAjxmFqSNVAZLn+s
	vWKLJ3Q==
X-Received: from pfx52.prod.google.com ([2002:a05:6a00:a474:b0:84a:6b32:7768])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3c8b:b0:848:3576:3204
 with SMTP id d2e1a72fcca58-84eca87f787mr1125578b3a.34.1785439155333; Thu, 30
 Jul 2026 12:19:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 30 Jul 2026 12:19:03 -0700
In-Reply-To: <20260730191908.2084803-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260730191908.2084803-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260730191908.2084803-5-seanjc@google.com>
Subject: [PATCH 4/9] KVM: selftests: Drop unreachable, dead code from hardware
 disable test
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
 .../selftests/kvm/hardware_disable_test.c     | 42 +++++++------------
 1 file changed, 14 insertions(+), 28 deletions(-)

diff --git a/tools/testing/selftests/kvm/hardware_disable_test.c b/tools/testing/selftests/kvm/hardware_disable_test.c
index 1bcbd13e9994..e08aef94382f 100644
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
@@ -38,22 +39,19 @@ static void *run_vcpu(void *arg)
 
 	vcpu_run(vcpu);
 
-	TEST_ASSERT(false, "%s: exited with reason %d: %s",
-		    __func__, run->exit_reason,
-		    exit_reason_str(run->exit_reason));
-	pthread_exit(NULL);
+	TEST_FAIL("vCPU%d exited with reason %d: %s",
+		  vcpu->id, run->exit_reason, exit_reason_str(run->exit_reason));
 }
 
 static void *sleeping_thread(void *arg)
 {
 	int fd;
 
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
@@ -73,21 +71,11 @@ static inline void check_set_affinity(pthread_t thread, cpu_set_t *cpu_set)
 	TEST_ASSERT(r == 0, "%s: failed set affinity", __func__);
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
 	struct kvm_vm *vm;
-	pthread_t threads[VCPU_NUM];
-	pthread_t throw_away;
-	void *b;
+	pthread_t thread;
 	u32 i, j;
 
 	vm = vm_create(VCPU_NUM);
@@ -96,21 +84,19 @@ static void run_test(u32 run)
 	for (i = 0; i < VCPU_NUM; ++i) {
 		vcpu = vm_vcpu_add(vm, i, guest_code);
 
-		check_create_thread(&threads[i], NULL, run_vcpu, vcpu);
-		check_set_affinity(threads[i], &child_cpu_set);
+		check_create_thread(&thread, NULL, run_vcpu, vcpu);
+		check_set_affinity(thread, &child_cpu_set);
 
 		for (j = 0; j < SLEEPING_THREAD_NUM; ++j) {
-			check_create_thread(&throw_away, NULL, sleeping_thread,
-					    (void *)NULL);
-			check_set_affinity(throw_away, &child_cpu_set);
+			check_create_thread(&thread, NULL, sleeping_thread, (void *)NULL);
+			check_set_affinity(thread, &child_cpu_set);
 		}
 	}
 	pr_debug("%s: [%d] all threads launched\n", __func__, run);
 	sem_post(sem);
-	for (i = 0; i < VCPU_NUM; ++i)
-		check_join(threads[i], &b);
-	/* Should not be reached */
-	TEST_ASSERT(false, "%s: [%d] child escaped the ninja", __func__, run);
+
+	/* Wait for the parent to SIGKILL this child. */
+	while (1);
 }
 
 void wait_for_child_setup(pid_t pid)
-- 
2.55.0.508.g3f0d502094-goog

