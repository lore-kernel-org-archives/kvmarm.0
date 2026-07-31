Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6955C4582E4
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 17:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785517600; cv=none; b=ESYZCLulRTN05Cgs0PiVSKYboSixIFfIi9GCbzSP+dxVHpHQOwYrvPYpcv1qVjKTV3wzOWCTQSmGiAsPMBAQk2I+HNu/GK1y5h7YqiVzkKG0VRn/PsE+IRpyzXuUmbe0gJ4uWg9ZD8plnoUGJX6/ZDCH0eZ4USEiwKPvZag8s/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785517600; c=relaxed/simple;
	bh=3q//Tabf4H6D6g2+hq87aIi4ctizRMkEW/nlcxYiGYQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=R1bI7lMCdh7eC8W0Hf/f9GQqBPEcIzWvK/Q2iLxDL8ksAobiyBJs4KWdtIyLZXycufaUhX1PuxtXgP8uBWGqebDfLk4C5hveSFJQcHrTgGhcZCygR8ro3nPaDhG5X8UKMH4bmjk9YjxXR6GcNztpaiDaeywafVBNoTXuVbHk9Co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=svBgsonu; arc=none smtp.client-ip=209.85.216.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="svBgsonu"
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38ea32e57e2so2274463a91.1
        for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 10:06:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785517598; x=1786122398; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=G1JBjopkc75BtNRKBSR+DchDeaVK0MN8H8Q6AmKvrIE=;
        b=svBgsonuTWHIL4Z0JdYos9SgN5f2A9r268APLQLfKUHH1s2NOrnqSZGMQP+VSV9N+D
         Fa/fGhmgvPkdQ6XpTt6g1d1g8hdd2UYb7ZKSMc9GgeSK64oQ7ns5Fg9wT2iUUuHpo6Nn
         ubc+XPFBLA7mxVhzIINKPSWyAtiiyVeO7IlxnlLBZjNK76rgA+xEnjP4z2xubD17j+fa
         4HVLGnhyguR46C9+rNreerCdooEJhVC4cwa2mUana7fJ9BpKbL9gUoxLWgx0lO6yXMHL
         F2q8oKx6GannDLZv3LMfK0JfOuDaXu3ai+Qr6sKYbz/o/0axmyJcQmtn3kS+saR0yVGf
         tm6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785517598; x=1786122398;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=G1JBjopkc75BtNRKBSR+DchDeaVK0MN8H8Q6AmKvrIE=;
        b=lUG1bECdNJ51N+/4NPLuDHPNGSduDkamE6akPAt4iar/vbebXs3emT8o+7/DqClg2G
         WbTJFeYXniEqCx5bRaIAOoX55G6gUq+CFhqP0mgMhxie7odnm+C/M0K39Aq1FODDe9l7
         LKSEVsg3G4wGj/MjWXsObFBrOl/tjdNELbxzLy7hMXrE5tUqOFSWAQkS5Q5xR3xY3luV
         xMA1J4dDxc+z8o3rv7S3sr0HgKXHlI07nTOunXpUNCbYR+nncgmMLJvNXwwIG1wHoY3Q
         /+bqB/C5D95v5K4h7dS6isfVc6W1aRh6wbDjDkjfNmrwAPY/DLFJROxgIkX1zJQAROhV
         EIUw==
X-Forwarded-Encrypted: i=1; AHgh+RoDqr7Ji5yt/hWPu8mb5wJkefsySjOZrJGw/QvQMqh4EQL8/inj4p3nZBPxkNRI27DFkUrjUEo=@lists.linux.dev
X-Gm-Message-State: AOJu0YzZ1kiJ0InomlEQ6qXqK8Kp0fvYwGOvmx9wf+syON3+UVxCm6J0
	Q1OpmXe1Azt6ObjZkpneNj+Q4sMjS6eiuIVl6IlJ5FzulAxz0MJUBK6E93gYHWPHA6l9mVMG4Zd
	Vh7iSzg==
X-Received: from pjbii5.prod.google.com ([2002:a17:90b:4885:b0:38d:ed16:8b30])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:53c3:b0:36a:5d1f:7b6
 with SMTP id 98e67ed59e1d1-38fbc40e148mr607598a91.2.1785517597505; Fri, 31
 Jul 2026 10:06:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jul 2026 10:06:19 -0700
In-Reply-To: <20260731170619.2620845-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260731170619.2620845-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260731170619.2620845-13-seanjc@google.com>
Subject: [PATCH v2 12/12] KVM: selftests: Clean up global constants in
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

Rename the global constants in the hardware disable test to better
capture what they control, and open code the literal number of sleeping
tasks and iterations instead of using power-of-2 math to express values
that are 100% arbitrary.

Opportunistically tag the global semaphore with "static".

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/hardware_disable_test.c     | 20 +++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/hardware_disable_test.c b/tools/testing/selftests/kvm/hardware_disable_test.c
index 694d064e63f1..cf9306bbe970 100644
--- a/tools/testing/selftests/kvm/hardware_disable_test.c
+++ b/tools/testing/selftests/kvm/hardware_disable_test.c
@@ -17,13 +17,13 @@
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
 
 static cpu_set_t threads_cpu_set;
-sem_t *sem;
+static sem_t *sem;
 
 static void guest_code(void)
 {
@@ -75,15 +75,15 @@ static void run_test(u32 run)
 	pthread_attr_setaffinity_np(&attr, sizeof(cpu_set_t), &threads_cpu_set);
 #endif
 
-	vm = vm_create(VCPU_NUM);
+	vm = vm_create(NR_VCPUS);
 
 	pr_debug("%s: [%d] start vcpus\n", __func__, run);
-	for (i = 0; i < VCPU_NUM; ++i) {
+	for (i = 0; i < NR_VCPUS; ++i) {
 		vcpu = vm_vcpu_add(vm, i, guest_code);
 
 		kvm_pthread_create(&thread, &attr, run_vcpu, vcpu);
 
-		for (j = 0; j < SLEEPING_THREAD_NUM; ++j)
+		for (j = 0; j < NR_SLEEPERS_PER_VCPU; ++j)
 			kvm_pthread_create(&thread, &attr, sleeping_thread, (void *)NULL);
 	}
 	pr_debug("%s: [%d] all threads launched\n", __func__, run);
@@ -133,13 +133,13 @@ int main(int argc, char **argv)
 
 	kvm_sched_getaffinity(0, sizeof(cpu_set_t), &allowed_cpu_set);
 
-	for (i = 0; i < VCPU_NUM && CPU_COUNT(&allowed_cpu_set); i++)
+	for (i = 0; i < NR_VCPUS && CPU_COUNT(&allowed_cpu_set); i++)
 		CPU_SET(kvm_pick_random_cpu(&allowed_cpu_set), &threads_cpu_set);
 
 	sem = sem_open("vm_sem", O_CREAT | O_EXCL, 0644, 0);
 	sem_unlink("vm_sem");
 
-	for (i = 0; i < FORK_NUM; ++i) {
+	for (i = 0; i < NR_ITERATIONS; ++i) {
 		pid = fork();
 		TEST_ASSERT(pid >= 0, "%s: unable to fork", __func__);
 		if (pid == 0)
-- 
2.55.0.508.g3f0d502094-goog

