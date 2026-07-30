Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF69146C82F
	for <kvmarm@lists.linux.dev>; Thu, 30 Jul 2026 19:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785439164; cv=none; b=lsdXZ6wO+e9LfVeaTzCeqeG+W4L9g6mMI2oVRprlL4hk9RNffNkPNOcDu4q/UcT+ENs1KCiMlIZgvLqUtf8pkVaAiNo0eO5cQ2+khUY+NZHYwdbVpZ/gDO/k7n9hsVaamSjMJwyh6tF3xe6XdSCLxRk8/h3kKisqa8vQDhwS2xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785439164; c=relaxed/simple;
	bh=YqbowzZLTbvED6IIZ5eKs/x5hI5KUK0TZBiCRoRnSms=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MMaaSLrc9WRT1coDTtbUZBhyAWmgHSYFG1UcEeuNUDNsY4mWBqPR37J7mu4uHLxMkUd4jhyJuCX5clH0LTz6PM/6EOsi2tlFlkLdO7tS3ChdWCW5pUXZG7rATVNdR9kg1uwAQ41o2Ln4pSzhOuIRwIRNgGq8Mwd/+CWIe6KXVTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hE3WnS8Y; arc=none smtp.client-ip=209.85.216.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hE3WnS8Y"
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38e4758ab46so261251a91.0
        for <kvmarm@lists.linux.dev>; Thu, 30 Jul 2026 12:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785439162; x=1786043962; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ej1XcnuLH5yYzQBAwBT+NjRAfZ8wjNCP8hhOnMl6lPQ=;
        b=hE3WnS8YiArtp7fffDNEfq9XboNz6xneAZ1hLBKoMd9KmIVZdDPZ/p3n2b6JarewwL
         cywYX7nZCyMWwEyC35KKFpiopTHAuXHNu5vf5TPrPtQoOzLLzXiomXvIFd64T79zgRRH
         KxGV/K53j/2Wc8h25RZKCM8P6qjaRXkHdZ8mSid7d7pu6NLg3S+VMV+ueBx0Des/9URi
         3sIayi8Am5pWTfB45oUe1Q/k75dCTBvHuqOuKR74nxx7Rqpl3pVsAaDnjPPQeTd4wJyT
         CYINYje9JbyZNkCb1PXyqMjbZQRAqUgYrFHc+cvz6WABoIWlhbNfrI2+fL1BQFm3ko/+
         rjjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785439162; x=1786043962;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ej1XcnuLH5yYzQBAwBT+NjRAfZ8wjNCP8hhOnMl6lPQ=;
        b=U0lg4vVVTLBAAyDtXuL2b+En6vOKj4e4z0JlnmYdOU5IZx4VxSoIMJeJ8Ei6AD8HBF
         mtsKgE8xFZ51yME/3u0Ntqnxg2P/WhK2IfETjRARG5AQACXDVq9sK1ud/Yxe633gYqio
         89IkB76l5y9j3Nk4R8Hu5dutOuTe1UJ1KKfBubCkv5D9BvUgw6O/UI89rim6ZtuLjOkZ
         kbvWdiRqOvRfF5JrmuWIIa7MJCiyYTmx5fqt3+rrGbvuFwIE+lptg1etph+ojdypykbr
         YeompfPaTTiowD8+m5szVg1wULg6PNUect8GlQZaPHbX20WJwPDrj/LXk6WCMLuBMKEV
         7DSw==
X-Forwarded-Encrypted: i=1; AHgh+RpVaOZJIVP1S4apGvkq2y0P3BUrOMf3SbydpMK8huhXqGQCgynCU3iquhnJSd7Ue3HdGKqL+qI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx5YvgOKdvH/pm6L0Y6xAzlL7wmtpi4PT6BMQLCkcUpyOAemMpX
	RTAI7xQmnikJhW1FAuPKBE48CnYNr8PbDuRd3trsY4woZJ/jPKhods6yRFJkDjN+qECNATkYpsP
	UBxn4/Q==
X-Received: from pjpo7.prod.google.com ([2002:a17:90a:9f87:b0:38e:c35c:d872])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b82:b0:38e:2a4:cffc
 with SMTP id 98e67ed59e1d1-38f9c020226mr3137625a91.25.1785439161887; Thu, 30
 Jul 2026 12:19:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 30 Jul 2026 12:19:08 -0700
In-Reply-To: <20260730191908.2084803-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260730191908.2084803-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260730191908.2084803-10-seanjc@google.com>
Subject: [PATCH 9/9] KVM: selftests: Clean up global constants in hardware
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

Rename the global constants in the hardware disable test to better
capture what they control, and open code the literal number of sleeping
tasks and iterations instead of using power-of-2 math to express values
that are 100% arbitrary.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/hardware_disable_test.c      | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/hardware_disable_test.c b/tools/testing/selftests/kvm/hardware_disable_test.c
index bcca42182656..4abad7158989 100644
--- a/tools/testing/selftests/kvm/hardware_disable_test.c
+++ b/tools/testing/selftests/kvm/hardware_disable_test.c
@@ -17,10 +17,10 @@
 #include "kvm_util.h"
 #include "ucall_common.h"
 
-#define VCPU_NUM 4
-#define SLEEPING_THREAD_NUM (1 << 4)
-#define FORK_NUM (1ULL << 9)
-#define DELAY_US_MAX 2000
+#define NR_VCPUS		4
+#define NR_SLEEPERS_PER_VCPU	16
+#define NR_ITERATIONS		512
+#define DELAY_US_MAX		2000
 
 sem_t *sem;
 static cpu_set_t child_cpu_set;
@@ -61,16 +61,16 @@ static void run_test(u32 run)
 	pthread_t thread;
 	u32 i, j;
 
-	vm = vm_create(VCPU_NUM);
+	vm = vm_create(NR_VCPUS);
 
 	pr_debug("%s: [%d] start vcpus\n", __func__, run);
-	for (i = 0; i < VCPU_NUM; ++i) {
+	for (i = 0; i < NR_VCPUS; ++i) {
 		vcpu = vm_vcpu_add(vm, i, guest_code);
 
 		kvm_pthread_create(&thread, NULL, run_vcpu, vcpu);
 		kvm_pthread_setaffinity(thread, &child_cpu_set);
 
-		for (j = 0; j < SLEEPING_THREAD_NUM; ++j) {
+		for (j = 0; j < NR_SLEEPERS_PER_VCPU; ++j) {
 			kvm_pthread_create(&thread, NULL, sleeping_thread, (void *)NULL);
 			kvm_pthread_setaffinity(thread, &child_cpu_set);
 		}
@@ -124,7 +124,7 @@ static void setup_child_cpu_set(void)
 	cpu = pin_task_to_random_cpu(pthread_self(), &child_cpu_set);
 	CPU_CLR(cpu, &child_cpu_set);
 
-	while (CPU_COUNT(&child_cpu_set) > VCPU_NUM)
+	while (CPU_COUNT(&child_cpu_set) > NR_VCPUS)
 		CPU_CLR(kvm_pick_random_cpu(&child_cpu_set), &child_cpu_set);
 }
 
@@ -139,7 +139,7 @@ int main(int argc, char **argv)
 	sem = sem_open("vm_sem", O_CREAT | O_EXCL, 0644, 0);
 	sem_unlink("vm_sem");
 
-	for (i = 0; i < FORK_NUM; ++i) {
+	for (i = 0; i < NR_ITERATIONS; ++i) {
 		pid = fork();
 		TEST_ASSERT(pid >= 0, "%s: unable to fork", __func__);
 		if (pid == 0)
-- 
2.55.0.508.g3f0d502094-goog

