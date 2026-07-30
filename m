Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE34646C823
	for <kvmarm@lists.linux.dev>; Thu, 30 Jul 2026 19:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785439164; cv=none; b=GcT9QoERSpOOfF+p5jqL9H7VitDiGh4LZ4di3UhwmljIAwGeFB6Ko/rCHNGvszFgc6KtOwDVhl3o3jxk9h5JCO6gQ5UMPPtxTh/mErpIKa/UWuSyY8AtaCwkmNaOZ+cLjQxnxmf6sf0nBZIO3ZQ8B9THMG371e1hAYzTWqUK+hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785439164; c=relaxed/simple;
	bh=9eB1/vxRZMNrMuybVouYj9D4B4rxtHe2oati0JA5JD4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=e/+HfOt912LEGaDYYq6usfzYT/KuuQMSnGnOm4HuCp5tlwchqQmHll/Q8DD7FnGU/7tYV4r0m7Ko9YXEnfQUY2jsRPkMv9dd3JPETVgH5aisZhH0ith0PuXNiZH0hSQdQPX80h4EsN/wAWP7S6hMnyr9ivChM0bHFzl4/CyBqtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VZ43kjTs; arc=none smtp.client-ip=209.85.210.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VZ43kjTs"
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-84eccf9d899so271761b3a.2
        for <kvmarm@lists.linux.dev>; Thu, 30 Jul 2026 12:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785439161; x=1786043961; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=YgYOnGbE/Qcoxe+WXdzA3Ub6YZQpGia+1p7vtjJDY/M=;
        b=VZ43kjTsDNqMIBampKcD2A4UGKpcFusobVxQNVkhdHLpxV6ocmx7X7f3mNJBEbmtIk
         GeSGXz8SGm4yDb8QnrM2nz06hOXFtG9ZpFyH1F69lQw/l81JPpimc6uPYRvBIoM099BX
         DnhCsj3kzrbI04TBFD68RYQQO/7S1M59xegAvlMg0eyco/ZZfMpwRqC//S9LovtRmm5U
         zJHp7PTKv0GJooOjoIphMl+iXxfbDANWmHGHheVlsj1D74ODqVaAsbyk1iuh93VRig+h
         gAZHO9iuvn5/fALcekGquHOKEdeWCVk9KYB5FJyjWJz/XEhK4kNXQmCwlZr8cuxxHSho
         6JSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785439161; x=1786043961;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YgYOnGbE/Qcoxe+WXdzA3Ub6YZQpGia+1p7vtjJDY/M=;
        b=BHaE7bB5+1Bt/Kyf8/4xCQMcWn5tkuZ325A9oT0aXdED0oGBH9VDEL3n4SRd2nNoR1
         Z98IaHqkiTTTQO9oLlJOViJkAGaqVtloxLnHVm+sZSvE1sZ4uWKUxkK7BiDINvyB8s+N
         tUsnHqmz+/oBHj3jDYdOv1Ivtn1wKvtlcoYGTtcxZox82hbqmecQvUFu0r6Xise90DGp
         I3D8Gn3i8F19oDqAqry3FKcRtK5C4UXtf0TySFNw7v1VftEQZ0DoO0vEFap8/ds/xkyv
         m0mqnhFYOcD81f2Z8C9wACNuiUSf6kSSL1sC/7uRneynTJqPfhrlX0ac3gJmaXppYl95
         0jOw==
X-Forwarded-Encrypted: i=1; AHgh+RpW5UZGUAckKHrj3zUebeutMp5x2pOugdqGuL4ckxSV1F4fEq8XoOA0u0rNeDgrEVIaUWBmdRc=@lists.linux.dev
X-Gm-Message-State: AOJu0YwzedwbMTLD7uYyG6FqavNRxWnJR4icBDZtf4k27uIoS2mWDlNS
	gDvUooHqd20WcFruv5XSl5+fOKKMXL2zK+Db11tuWUWY5CnokSodgYva6Hk8eG9CjNxytRFYF6W
	7Ypz4EA==
X-Received: from pfoi22.prod.google.com ([2002:aa7:87d6:0:b0:847:823c:d265])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:12da:b0:848:2d1d:836f
 with SMTP id d2e1a72fcca58-84ebc22e880mr3456538b3a.28.1785439160801; Thu, 30
 Jul 2026 12:19:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 30 Jul 2026 12:19:07 -0700
In-Reply-To: <20260730191908.2084803-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260730191908.2084803-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260730191908.2084803-9-seanjc@google.com>
Subject: [PATCH 8/9] KVM: selftests: Add KVM syscall wrappers for pthread_{g,s}etaffinity_np()
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

Add and use KVM wrappers for pthread_{g,s}etaffinity_np() so that selftests
don't need to manually assert that the syscalls succeeded, and so that they
don't need to manually pass in sizeof(cpu_set_t) for the size.

Note, the steal time test didn't assert success, but the TEST_ASSERT() one
line later makes it quite clear the test relies on pthread_getaffinity_np()
succeeding.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/hardware_disable_test.c        | 12 ++----------
 .../testing/selftests/kvm/include/kvm_syscalls.h | 16 ++++++++++++++++
 tools/testing/selftests/kvm/steal_time.c         |  2 +-
 3 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/hardware_disable_test.c b/tools/testing/selftests/kvm/hardware_disable_test.c
index 38ebacaa0fce..bcca42182656 100644
--- a/tools/testing/selftests/kvm/hardware_disable_test.c
+++ b/tools/testing/selftests/kvm/hardware_disable_test.c
@@ -54,14 +54,6 @@ static void *sleeping_thread(void *arg)
 	TEST_FAIL("%s: exited", __func__);
 }
 
-static inline void check_set_affinity(pthread_t thread, cpu_set_t *cpu_set)
-{
-	int r;
-
-	r = pthread_setaffinity_np(thread, sizeof(cpu_set_t), cpu_set);
-	TEST_ASSERT(r == 0, "%s: failed set affinity", __func__);
-}
-
 static void run_test(u32 run)
 {
 	struct kvm_vcpu *vcpu;
@@ -76,11 +68,11 @@ static void run_test(u32 run)
 		vcpu = vm_vcpu_add(vm, i, guest_code);
 
 		kvm_pthread_create(&thread, NULL, run_vcpu, vcpu);
-		check_set_affinity(thread, &child_cpu_set);
+		kvm_pthread_setaffinity(thread, &child_cpu_set);
 
 		for (j = 0; j < SLEEPING_THREAD_NUM; ++j) {
 			kvm_pthread_create(&thread, NULL, sleeping_thread, (void *)NULL);
-			check_set_affinity(thread, &child_cpu_set);
+			kvm_pthread_setaffinity(thread, &child_cpu_set);
 		}
 	}
 	pr_debug("%s: [%d] all threads launched\n", __func__, run);
diff --git a/tools/testing/selftests/kvm/include/kvm_syscalls.h b/tools/testing/selftests/kvm/include/kvm_syscalls.h
index 002b5a4e59eb..3d82351bef92 100644
--- a/tools/testing/selftests/kvm/include/kvm_syscalls.h
+++ b/tools/testing/selftests/kvm/include/kvm_syscalls.h
@@ -97,6 +97,22 @@ __KVM_SYSCALL_DEFINE(ftruncate, 2, unsigned int, fd, off_t, length);
 __KVM_SYSCALL_DEFINE(madvise, 3, void *, addr, size_t, length, int, advice);
 __KVM_SYSCALL_DEFINE(sched_getaffinity, 3, pid_t, pid, size_t, cpusetsize, cpu_set_t *, mask);
 
+__KVM_SYSCALL_DEFINE(pthread_getaffinity_np, 3, pthread_t, thread,
+		     size_t, cpusetsize, cpu_set_t *, cpuset);
+__KVM_SYSCALL_DEFINE(pthread_setaffinity_np, 3, pthread_t, thread,
+		     size_t, cpusetsize, const cpu_set_t *, cpuset);
+
+static inline void kvm_pthread_getaffinity(pthread_t thread, cpu_set_t *cpuset)
+{
+	kvm_pthread_getaffinity_np(thread, sizeof(cpu_set_t), cpuset);
+}
+
+static inline void kvm_pthread_setaffinity(pthread_t thread,
+					   const cpu_set_t *cpuset)
+{
+	kvm_pthread_setaffinity_np(thread, sizeof(cpu_set_t), cpuset);
+}
+
 typedef void *(*pthread_fn_t)(void *);
 __KVM_SYSCALL_DEFINE(pthread_create, 4, pthread_t *, thread,
 		     const pthread_attr_t *, attr, pthread_fn_t, fn, void *, arg);
diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index 6cb1eb4c40c9..bc3c62b72c58 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -549,7 +549,7 @@ int main(int ac, char **av)
 		/* Steal time from the VCPU. The steal time thread has the same CPU affinity as the VCPUs. */
 		run_delay = get_run_delay();
 		kvm_pthread_create(&thread, NULL, do_steal_time, NULL);
-		pthread_getaffinity_np(thread, sizeof(cpuset), &cpuset);
+		kvm_pthread_getaffinity(thread, &cpuset);
 		TEST_ASSERT(CPU_COUNT(&cpuset) == 1 && CPU_ISSET(cpu, &cpuset),
 			    "Worker failed to inherit parent's CPU affinity");
 
-- 
2.55.0.508.g3f0d502094-goog

