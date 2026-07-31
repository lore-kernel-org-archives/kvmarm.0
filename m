Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78365455184
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 17:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785517596; cv=none; b=tVi5ODG/WAceMHUCgB+bznny59pMRtQQv/u09XuUIXL0tgasuGDdx6tV9grHvtU/6vQOknBweB4iJiLmWWs/hvKtlt7yu/JjNXR+yzESTxZrOHFhdlIc0M/Ki77O4L2UZxHiz+NB3SaskFBdHW5rNcO5WUfP+LowzpsEbF+jnhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785517596; c=relaxed/simple;
	bh=005O5sYv+kMGHI/IAxuHJ7W9GOqScFIr6j9jgra9L2w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=f1deuYb+BS9rrrc6TtIw3ZHf3m4vzxe2+whykeJN7TAShkQkm8Cn/e7QKsHfO+sTfafctKwqlNhgUvwQSDL40DVp1nhf5ZwrF+CkPJk6GipfahPXKPWnQJwALT+FYXFv5lEcu9ihllmtvEDOG7ZJjHATg7pWRjWg2AnOdYLLPLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=q5/gWw6m; arc=none smtp.client-ip=209.85.210.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q5/gWw6m"
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-848474825ffso1277822b3a.0
        for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 10:06:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785517593; x=1786122393; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ctlXdT2JZ1q5UveKB40Dd/6tqw4CMEidpPSRexgEDyQ=;
        b=q5/gWw6m8UJghzXHr2omjj2nUXhaBhzsfhzin3PKoOrc44U5HYDSBZkSS6Zcmlw2XN
         l2/KTwl3b0SXf5hQJMPZfHJ0uN3pUUJaTlx8RETxxVgZ4bdCc089HdeJPYraD4Iw4SlB
         lRl/q9laeuOqXl7ibUSzdetOUfi/uykbNSkXM+f4jQmop3V6m03jpqNdSAyaQh5m8Z+U
         2YkuIQVEVhgHKSDHouuww6O6CYPdfphr6EqaFxSZggK7NfkZZZZ+qt+DhTJay79ieQIS
         TsbT3Jh8NhnKQmHyK09gZeVjPjnQG4ukW94Z/dLqOU4HILpisv2QzgPhSS05cm709KRz
         WDXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785517593; x=1786122393;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ctlXdT2JZ1q5UveKB40Dd/6tqw4CMEidpPSRexgEDyQ=;
        b=Ol5NufE+9jKIZaBoW+pYQOtxRFUL/jWOFs+Rc1f8t8Zo0PnsBwWzDOOa2/3Q5ks+l+
         wlmZn9hSfmBjYodFT3AleFyZI28J7Mf1Uqxbk9yJp+ffWpMQWi65jqtzruZA1Tyh5Fr/
         qO+n2/g+uu0BcdJLRQQKCuxN1a6YoqQD4pII45EfHb5tIHzRHlVuIMoI2e2SP7IRNB+8
         ZC5GLMa8xMgPHqtexQBPFOpf6rsm4fXT14nA9315W1nAvEylPG5Af1Wk1DOR6x/q902C
         HU1J/2rVP0pOTLFt1Z8JL5wJcyb29P+KlELPTE2YGJWmH20OZfyFpaXVrN1ZhgGSzpjv
         UGNQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro4naQ2BL7nOpgsWp0h/grP82juEY3k9HLslSyMkGrEEDpRBjqNo2mimpJMy4Twzby2mfI7LYQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzza0B/9dsSd7eEs8uhkj0broOToILaXloEJ+ZYGzLp1NCiDGyf
	TtaP0rjbw7ztJoSk151SqD0OQJSliyENgbReI3FHFni7zKTaF7X6+OR340IlcmGHPHnEv6LPUwj
	2LSx3FA==
X-Received: from pgvh11.prod.google.com ([2002:a65:638b:0:b0:caf:5e6:fda0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1f18:b0:845:3033:6cbb
 with SMTP id d2e1a72fcca58-84ed72609d0mr2155625b3a.11.1785517592354; Fri, 31
 Jul 2026 10:06:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jul 2026 10:06:15 -0700
In-Reply-To: <20260731170619.2620845-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260731170619.2620845-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260731170619.2620845-9-seanjc@google.com>
Subject: [PATCH v2 08/12] KVM: selftests: Add KVM syscall wrapper for pthread_create()
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

Add and use a KVM wrapper for pthread_create() syscall so that selftests
don't need to manually assert that the syscall succeeded.

Note, most tests don't actually assert success, but they all obviously
rely on the syscall to succeed.

Other than explicitly failing if pthread_create() fails, no functional
change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/arch_timer.c         | 14 ++++----------
 tools/testing/selftests/kvm/arm64/vgic_irq.c     | 10 +++-------
 .../selftests/kvm/arm64/vgic_lpi_stress.c        |  4 ++--
 tools/testing/selftests/kvm/dirty_log_test.c     |  2 +-
 .../selftests/kvm/hardware_disable_test.c        | 16 +++-------------
 .../testing/selftests/kvm/include/kvm_syscalls.h |  5 +++++
 tools/testing/selftests/kvm/irq_test.c           |  2 +-
 tools/testing/selftests/kvm/irqfd_test.c         |  2 +-
 .../testing/selftests/kvm/kvm_page_table_test.c  |  4 ++--
 tools/testing/selftests/kvm/lib/memstress.c      |  2 +-
 .../testing/selftests/kvm/lib/userfaultfd_util.c |  4 ++--
 tools/testing/selftests/kvm/memslot_perf_test.c  |  2 +-
 tools/testing/selftests/kvm/mmu_stress_test.c    |  2 +-
 .../selftests/kvm/pre_fault_memory_test.c        |  2 +-
 tools/testing/selftests/kvm/rseq_test.c          |  4 ++--
 tools/testing/selftests/kvm/s390/memop.c         |  2 +-
 .../selftests/kvm/set_memory_region_test.c       |  2 +-
 tools/testing/selftests/kvm/steal_time.c         |  2 +-
 tools/testing/selftests/kvm/x86/hyperv_ipi.c     | 11 ++++-------
 .../testing/selftests/kvm/x86/hyperv_tlb_flush.c |  9 +++------
 .../kvm/x86/private_mem_conversions_test.c       |  2 +-
 .../kvm/x86/private_mem_kvm_exits_test.c         |  5 ++---
 .../selftests/kvm/x86/recalc_apic_map_test.c     |  2 +-
 .../selftests/kvm/x86/sev_migrate_tests.c        |  2 +-
 tools/testing/selftests/kvm/x86/sync_regs_test.c |  2 +-
 .../testing/selftests/kvm/x86/tsc_scaling_sync.c |  2 +-
 tools/testing/selftests/kvm/x86/xapic_ipi_test.c |  8 ++------
 .../testing/selftests/kvm/x86/xen_shinfo_test.c  |  3 +--
 28 files changed, 50 insertions(+), 77 deletions(-)

diff --git a/tools/testing/selftests/kvm/arch_timer.c b/tools/testing/selftests/kvm/arch_timer.c
index f8b02597897b..a6a66b5b7ea9 100644
--- a/tools/testing/selftests/kvm/arch_timer.c
+++ b/tools/testing/selftests/kvm/arch_timer.c
@@ -141,28 +141,22 @@ static void test_run(struct kvm_vm *vm)
 {
 	pthread_t pt_vcpu_migration;
 	unsigned int i;
-	int ret;
 
 	pthread_mutex_init(&vcpu_done_map_lock, NULL);
 	vcpu_done_map = bitmap_zalloc(test_args.nr_vcpus);
 	TEST_ASSERT(vcpu_done_map, "Failed to allocate vcpu done bitmap");
 
-	for (i = 0; i < (unsigned long)test_args.nr_vcpus; i++) {
-		ret = pthread_create(&pt_vcpu_run[i], NULL, test_vcpu_run,
-				     (void *)(unsigned long)i);
-		TEST_ASSERT(!ret, "Failed to create vCPU-%d pthread", i);
-	}
+	for (i = 0; i < (unsigned long)test_args.nr_vcpus; i++)
+		kvm_pthread_create(&pt_vcpu_run[i], NULL, test_vcpu_run,
+				   (void *)(unsigned long)i);
 
 	/* Spawn a thread to control the vCPU migrations */
 	if (test_args.migration_freq_ms) {
 		srand(time(NULL));
 
-		ret = pthread_create(&pt_vcpu_migration, NULL,
-					test_vcpu_migration, NULL);
-		TEST_ASSERT(!ret, "Failed to create the migration pthread");
+		kvm_pthread_create(&pt_vcpu_migration, NULL, test_vcpu_migration, NULL);
 	}
 
-
 	for (i = 0; i < test_args.nr_vcpus; i++)
 		pthread_join(pt_vcpu_run[i], NULL);
 
diff --git a/tools/testing/selftests/kvm/arm64/vgic_irq.c b/tools/testing/selftests/kvm/arm64/vgic_irq.c
index 5e231998617e..2d6f20d5c117 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_irq.c
@@ -988,7 +988,7 @@ static void test_vgic_two_cpus(void *gcode)
 	struct test_args args = {};
 	struct kvm_vm *vm;
 	gva_t args_gva;
-	int gic_fd, ret;
+	int gic_fd;
 
 	vm = vm_create_with_vcpus(2, gcode, vcpus);
 
@@ -1004,12 +1004,8 @@ static void test_vgic_two_cpus(void *gcode)
 
 	gic_fd = vgic_v3_setup(vm, 2, 64);
 
-	ret = pthread_create(&thr[0], NULL, test_vcpu_run, vcpus[0]);
-	if (ret)
-		TEST_FAIL("Can't create thread for vcpu 0 (%d)\n", ret);
-	ret = pthread_create(&thr[1], NULL, test_vcpu_run, vcpus[1]);
-	if (ret)
-		TEST_FAIL("Can't create thread for vcpu 1 (%d)\n", ret);
+	kvm_pthread_create(&thr[0], NULL, test_vcpu_run, vcpus[0]);
+	kvm_pthread_create(&thr[1], NULL, test_vcpu_run, vcpus[1]);
 
 	pthread_join(thr[0], NULL);
 	pthread_join(thr[1], NULL);
diff --git a/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c b/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
index d64d434d3f06..549e0547d905 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
@@ -311,10 +311,10 @@ static void run_test(void)
 	pthread_barrier_init(&test_setup_barrier, NULL, nr_vcpus + nr_devices + 1);
 
 	for (i = 0; i < nr_vcpus; i++)
-		pthread_create(&vcpu_threads[i], NULL, vcpu_worker_thread, vcpus[i]);
+		kvm_pthread_create(&vcpu_threads[i], NULL, vcpu_worker_thread, vcpus[i]);
 
 	for (i = 0; i < nr_devices; i++)
-		pthread_create(&lpi_threads[i], NULL, lpi_worker_thread, (void *)i);
+		kvm_pthread_create(&lpi_threads[i], NULL, lpi_worker_thread, (void *)i);
 
 	pthread_barrier_wait(&test_setup_barrier);
 
diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index e8419d7da1ea..ca22e5f09ac2 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -691,7 +691,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 
 	TEST_ASSERT_EQ(vcpu_stop, false);
 
-	pthread_create(&vcpu_thread, NULL, vcpu_worker, vcpu);
+	kvm_pthread_create(&vcpu_thread, NULL, vcpu_worker, vcpu);
 
 	for (iteration = 1; iteration <= p->iterations; iteration++) {
 		unsigned long i, reap_i;
diff --git a/tools/testing/selftests/kvm/hardware_disable_test.c b/tools/testing/selftests/kvm/hardware_disable_test.c
index b8115b2dcae3..694d064e63f1 100644
--- a/tools/testing/selftests/kvm/hardware_disable_test.c
+++ b/tools/testing/selftests/kvm/hardware_disable_test.c
@@ -5,7 +5,6 @@
  * return notifiers.
  */
 #include <fcntl.h>
-#include <pthread.h>
 #include <semaphore.h>
 #include <stdint.h>
 #include <stdlib.h>
@@ -14,6 +13,7 @@
 
 #include <test_util.h>
 
+#include "kvm_syscalls.h"
 #include "kvm_util.h"
 #include "ucall_common.h"
 
@@ -62,15 +62,6 @@ static void *sleeping_thread(void *arg)
 	TEST_FAIL("%s: exited", __func__);
 }
 
-static inline void check_create_thread(pthread_t *thread, pthread_attr_t *attr,
-				       void *(*f)(void *), void *arg)
-{
-	int r;
-
-	r = pthread_create(thread, attr, f, arg);
-	TEST_ASSERT(r == 0, "%s: failed to create thread", __func__);
-}
-
 static void run_test(u32 run)
 {
 	struct kvm_vcpu *vcpu;
@@ -90,11 +81,10 @@ static void run_test(u32 run)
 	for (i = 0; i < VCPU_NUM; ++i) {
 		vcpu = vm_vcpu_add(vm, i, guest_code);
 
-		check_create_thread(&thread, &attr, run_vcpu, vcpu);
+		kvm_pthread_create(&thread, &attr, run_vcpu, vcpu);
 
 		for (j = 0; j < SLEEPING_THREAD_NUM; ++j)
-			check_create_thread(&thread, &attr, sleeping_thread,
-					    (void *)NULL);
+			kvm_pthread_create(&thread, &attr, sleeping_thread, (void *)NULL);
 	}
 	pr_debug("%s: [%d] all threads launched\n", __func__, run);
 	sem_post(sem);
diff --git a/tools/testing/selftests/kvm/include/kvm_syscalls.h b/tools/testing/selftests/kvm/include/kvm_syscalls.h
index 01dca99009c2..e75be8378779 100644
--- a/tools/testing/selftests/kvm/include/kvm_syscalls.h
+++ b/tools/testing/selftests/kvm/include/kvm_syscalls.h
@@ -12,6 +12,7 @@
 #include <sys/mman.h>
 #include <sys/syscall.h>
 
+#include <pthread.h>
 #include <sched.h>
 #include <test_util.h>
 
@@ -97,6 +98,10 @@ __KVM_SYSCALL_DEFINE(madvise, 3, void *, addr, size_t, length, int, advice);
 __KVM_SYSCALL_DEFINE(sched_getaffinity, 3, pid_t, pid, size_t, cpusetsize, cpu_set_t *, mask);
 __KVM_SYSCALL_DEFINE(sched_setaffinity, 3, pid_t, pid, size_t, cpusetsize, cpu_set_t *, mask);
 
+typedef void *(*pthread_fn_t)(void *);
+__KVM_SYSCALL_DEFINE(pthread_create, 4, pthread_t *, thread,
+		     const pthread_attr_t *, attr, pthread_fn_t, fn, void *, arg);
+
 #define kvm_free_fd(fd)		\
 do {				\
 	kvm_close(fd);		\
diff --git a/tools/testing/selftests/kvm/irq_test.c b/tools/testing/selftests/kvm/irq_test.c
index 240f6f0fdbe4..7da5f8d75e85 100644
--- a/tools/testing/selftests/kvm/irq_test.c
+++ b/tools/testing/selftests/kvm/irq_test.c
@@ -296,7 +296,7 @@ int main(int argc, char **argv)
 		kvm_sched_getaffinity(0, sizeof(available_cpus), &available_cpus);
 
 	for (i = 0; i < nr_vcpus; i++)
-		pthread_create(&vcpu_threads[i], NULL, vcpu_thread_main, vcpus[i]);
+		kvm_pthread_create(&vcpu_threads[i], NULL, vcpu_thread_main, vcpus[i]);
 
 	for (i = 0; i < nr_vcpus; i++) {
 		struct kvm_vcpu *vcpu = vcpus[i];
diff --git a/tools/testing/selftests/kvm/irqfd_test.c b/tools/testing/selftests/kvm/irqfd_test.c
index 5d7590d01868..8b39144a2834 100644
--- a/tools/testing/selftests/kvm/irqfd_test.c
+++ b/tools/testing/selftests/kvm/irqfd_test.c
@@ -128,7 +128,7 @@ int main(int argc, char *argv[])
 
 	close(__eventfd);
 
-	pthread_create(&racing_thread, NULL, secondary_irqfd_juggler, vm2);
+	kvm_pthread_create(&racing_thread, NULL, secondary_irqfd_juggler, vm2);
 
 	for (i = 0; i < 10000; i++) {
 		WRITE_ONCE(__eventfd, kvm_new_eventfd());
diff --git a/tools/testing/selftests/kvm/kvm_page_table_test.c b/tools/testing/selftests/kvm/kvm_page_table_test.c
index a910e3abb8c7..8222bdb63e49 100644
--- a/tools/testing/selftests/kvm/kvm_page_table_test.c
+++ b/tools/testing/selftests/kvm/kvm_page_table_test.c
@@ -364,8 +364,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	*current_stage = KVM_BEFORE_MAPPINGS;
 
 	for (i = 0; i < nr_vcpus; i++)
-		pthread_create(&vcpu_threads[i], NULL, vcpu_worker,
-			       test_args.vcpus[i]);
+		kvm_pthread_create(&vcpu_threads[i], NULL, vcpu_worker,
+				   test_args.vcpus[i]);
 
 	vcpus_complete_new_stage(*current_stage);
 	pr_info("Started all vCPUs successfully\n");
diff --git a/tools/testing/selftests/kvm/lib/memstress.c b/tools/testing/selftests/kvm/lib/memstress.c
index 3599b75d97c9..0bfa623ce9b5 100644
--- a/tools/testing/selftests/kvm/lib/memstress.c
+++ b/tools/testing/selftests/kvm/lib/memstress.c
@@ -294,7 +294,7 @@ void memstress_start_vcpu_threads(int nr_vcpus,
 		vcpu->vcpu_idx = i;
 		WRITE_ONCE(vcpu->running, false);
 
-		pthread_create(&vcpu->thread, NULL, vcpu_thread_main, vcpu);
+		kvm_pthread_create(&vcpu->thread, NULL, vcpu_thread_main, vcpu);
 	}
 
 	for (i = 0; i < nr_vcpus; i++) {
diff --git a/tools/testing/selftests/kvm/lib/userfaultfd_util.c b/tools/testing/selftests/kvm/lib/userfaultfd_util.c
index ef8d76f71f83..4b3e3158ed87 100644
--- a/tools/testing/selftests/kvm/lib/userfaultfd_util.c
+++ b/tools/testing/selftests/kvm/lib/userfaultfd_util.c
@@ -167,8 +167,8 @@ struct uffd_desc *uffd_setup_demand_paging(int uffd_mode, useconds_t delay,
 		uffd_desc->reader_args[i].handler = handler;
 		uffd_desc->reader_args[i].pipe = pipes[0];
 
-		pthread_create(&uffd_desc->readers[i], NULL, uffd_handler_thread_fn,
-			       &uffd_desc->reader_args[i]);
+		kvm_pthread_create(&uffd_desc->readers[i], NULL, uffd_handler_thread_fn,
+				   &uffd_desc->reader_args[i]);
 
 		PER_VCPU_DEBUG("Created uffd thread %i for HVA range [%p, %p)\n",
 			       i, hva, hva + len);
diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
index 4d9ad6104a6e..eb49305db404 100644
--- a/tools/testing/selftests/kvm/memslot_perf_test.c
+++ b/tools/testing/selftests/kvm/memslot_perf_test.c
@@ -366,7 +366,7 @@ static void launch_vm(struct vm_data *data)
 {
 	pr_info_v("Launching the test VM\n");
 
-	pthread_create(&data->vcpu_thread, NULL, vcpu_worker, data);
+	kvm_pthread_create(&data->vcpu_thread, NULL, vcpu_worker, data);
 
 	/* Ensure the guest thread is spun up. */
 	wait_for_vcpu();
diff --git a/tools/testing/selftests/kvm/mmu_stress_test.c b/tools/testing/selftests/kvm/mmu_stress_test.c
index 3d5f33a63b2b..9448498849ff 100644
--- a/tools/testing/selftests/kvm/mmu_stress_test.c
+++ b/tools/testing/selftests/kvm/mmu_stress_test.c
@@ -222,7 +222,7 @@ static pthread_t *spawn_workers(struct kvm_vm *vm, struct kvm_vcpu **vcpus,
 		info[i].vcpu = vcpus[i];
 		info[i].start_gpa = gpa;
 		info[i].end_gpa = gpa + nr_bytes;
-		pthread_create(&threads[i], NULL, vcpu_worker, &info[i]);
+		kvm_pthread_create(&threads[i], NULL, vcpu_worker, &info[i]);
 	}
 	return threads;
 }
diff --git a/tools/testing/selftests/kvm/pre_fault_memory_test.c b/tools/testing/selftests/kvm/pre_fault_memory_test.c
index a0fcae3cb7a8..88287ccb9093 100644
--- a/tools/testing/selftests/kvm/pre_fault_memory_test.c
+++ b/tools/testing/selftests/kvm/pre_fault_memory_test.c
@@ -84,7 +84,7 @@ static void pre_fault_memory(struct kvm_vcpu *vcpu, u64 base_gpa, u64 offset,
 	 * Concurrently delete (and recreate) the slot to test KVM's handling
 	 * of a racing memslot deletion with prefaulting.
 	 */
-	pthread_create(&slot_worker, NULL, delete_slot_worker, &data);
+	kvm_pthread_create(&slot_worker, NULL, delete_slot_worker, &data);
 
 	while (!READ_ONCE(data.worker_ready))
 		cpu_relax();
diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
index edcaf0fbe20c..0921b8d90d4a 100644
--- a/tools/testing/selftests/kvm/rseq_test.c
+++ b/tools/testing/selftests/kvm/rseq_test.c
@@ -239,8 +239,8 @@ int main(int argc, char *argv[])
 	 */
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 
-	pthread_create(&migration_thread, NULL, migration_worker,
-		       (void *)(unsigned long)kvm_gettid());
+	kvm_pthread_create(&migration_thread, NULL, migration_worker,
+			   (void *)(unsigned long)kvm_gettid());
 
 	if (latency >= 0) {
 		/*
diff --git a/tools/testing/selftests/kvm/s390/memop.c b/tools/testing/selftests/kvm/s390/memop.c
index 0244848621b3..96b32bd74009 100644
--- a/tools/testing/selftests/kvm/s390/memop.c
+++ b/tools/testing/selftests/kvm/s390/memop.c
@@ -678,7 +678,7 @@ static void test_cmpxchg_key_concurrent(void)
 	HOST_SYNC(t.vcpu, STAGE_SKEYS_SET);
 	prepare_mem12();
 	MOP(t.vcpu, LOGICAL, WRITE, mem1, max_block, GADDR_V(mem2));
-	pthread_create(&thread, NULL, run_guest, &t.vcpu);
+	kvm_pthread_create(&thread, NULL, run_guest, &t.vcpu);
 
 	for (int i = 0; i < cmpxchg_iter_outer; i++) {
 		do {
diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index a152ab65c657..12f5022bb164 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -133,7 +133,7 @@ static struct kvm_vm *spawn_vm(struct kvm_vcpu **vcpu, pthread_t *vcpu_thread,
 	hva = addr_gpa2hva(vm, MEM_REGION_GPA);
 	memset(hva, 0, 2 * 4096);
 
-	pthread_create(vcpu_thread, NULL, vcpu_worker, *vcpu);
+	kvm_pthread_create(vcpu_thread, NULL, vcpu_worker, *vcpu);
 
 	/* Ensure the guest thread is spun up. */
 	wait_for_vcpu();
diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index 0b88c743ee7d..f5f708be5aa0 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -548,7 +548,7 @@ int main(int ac, char **av)
 
 		/* Steal time from the VCPU. The steal time thread has the same CPU affinity as the VCPUs. */
 		run_delay = get_run_delay();
-		pthread_create(&thread, NULL, do_steal_time, NULL);
+		kvm_pthread_create(&thread, NULL, do_steal_time, NULL);
 		pthread_getaffinity_np(thread, sizeof(cpuset), &cpuset);
 		TEST_ASSERT(CPU_COUNT(&cpuset) == 1 && CPU_ISSET(cpu, &cpuset),
 			    "Worker failed to inherit parent's CPU affinity");
diff --git a/tools/testing/selftests/kvm/x86/hyperv_ipi.c b/tools/testing/selftests/kvm/x86/hyperv_ipi.c
index 771535f9aad3..3cf451f3153e 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_ipi.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_ipi.c
@@ -245,7 +245,7 @@ int main(int argc, char *argv[])
 	struct kvm_vcpu *vcpu[3];
 	gva_t hcall_page;
 	pthread_t threads[2];
-	int stage = 1, r;
+	int stage = 1;
 	struct ucall uc;
 
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_HYPERV_SEND_IPI));
@@ -272,11 +272,8 @@ int main(int argc, char *argv[])
 	vcpu_args_set(vcpu[0], 2, hcall_page, addr_gva2gpa(vm, hcall_page));
 	vcpu_set_hv_cpuid(vcpu[0]);
 
-	r = pthread_create(&threads[0], NULL, vcpu_thread, vcpu[1]);
-	TEST_ASSERT(!r, "pthread_create failed errno=%d", r);
-
-	r = pthread_create(&threads[1], NULL, vcpu_thread, vcpu[2]);
-	TEST_ASSERT(!r, "pthread_create failed errno=%d", errno);
+	kvm_pthread_create(&threads[0], NULL, vcpu_thread, vcpu[1]);
+	kvm_pthread_create(&threads[1], NULL, vcpu_thread, vcpu[2]);
 
 	while (true) {
 		vcpu_run(vcpu[0]);
@@ -306,5 +303,5 @@ int main(int argc, char *argv[])
 	cancel_join_vcpu_thread(threads[1], vcpu[2]);
 	kvm_vm_free(vm);
 
-	return r;
+	return 0;
 }
diff --git a/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c b/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c
index b4be9a175379..87fac1968a47 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c
@@ -575,7 +575,7 @@ int main(int argc, char *argv[])
 	u64 *pte;
 	struct test_data *data;
 	struct ucall uc;
-	int stage = 1, r, i;
+	int stage = 1, i;
 
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_HYPERV_TLBFLUSH));
 
@@ -632,11 +632,8 @@ int main(int argc, char *argv[])
 	vcpu_set_msr(vcpu[2], HV_X64_MSR_VP_INDEX, WORKER_VCPU_ID_2);
 	vcpu_set_hv_cpuid(vcpu[2]);
 
-	r = pthread_create(&threads[0], NULL, vcpu_thread, vcpu[1]);
-	TEST_ASSERT(!r, "pthread_create() failed");
-
-	r = pthread_create(&threads[1], NULL, vcpu_thread, vcpu[2]);
-	TEST_ASSERT(!r, "pthread_create() failed");
+	kvm_pthread_create(&threads[0], NULL, vcpu_thread, vcpu[1]);
+	kvm_pthread_create(&threads[1], NULL, vcpu_thread, vcpu[2]);
 
 	while (true) {
 		vcpu_run(vcpu[0]);
diff --git a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
index 1d2f5d4fd45d..e419b08f1fa6 100644
--- a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
@@ -412,7 +412,7 @@ static void test_mem_conversions(enum vm_mem_backing_src_type src_type, u32 nr_v
 		 */
 		virt_map(vm, gpa, gpa, PER_CPU_DATA_SIZE / vm->page_size);
 
-		pthread_create(&threads[i], NULL, __test_mem_conversions, vcpus[i]);
+		kvm_pthread_create(&threads[i], NULL, __test_mem_conversions, vcpus[i]);
 	}
 
 	WRITE_ONCE(run_vcpus, true);
diff --git a/tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c b/tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c
index 10db9fe6d906..e26524fb4b50 100644
--- a/tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c
+++ b/tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c
@@ -65,9 +65,8 @@ static void test_private_access_memslot_deleted(void)
 	/* Request to access page privately */
 	vm_mem_set_private(vm, EXITS_TEST_GPA, EXITS_TEST_SIZE);
 
-	pthread_create(&vm_thread, NULL,
-		       (void *(*)(void *))run_vcpu_get_exit_reason,
-		       (void *)vcpu);
+	kvm_pthread_create(&vm_thread, NULL,
+			   (pthread_fn_t)run_vcpu_get_exit_reason, (void *)vcpu);
 
 	vm_mem_region_delete(vm, EXITS_TEST_SLOT);
 
diff --git a/tools/testing/selftests/kvm/x86/recalc_apic_map_test.c b/tools/testing/selftests/kvm/x86/recalc_apic_map_test.c
index cbc92a862ea9..13abb65620d5 100644
--- a/tools/testing/selftests/kvm/x86/recalc_apic_map_test.c
+++ b/tools/testing/selftests/kvm/x86/recalc_apic_map_test.c
@@ -57,7 +57,7 @@ int main(void)
 	for (i = 0; i < KVM_MAX_VCPUS; i++)
 		vcpu_set_msr(vcpus[i], MSR_IA32_APICBASE, LAPIC_X2APIC);
 
-	TEST_ASSERT_EQ(pthread_create(&thread, NULL, race, vcpus[0]), 0);
+	kvm_pthread_create(&thread, NULL, race, vcpus[0]);
 
 	vcpuN = vcpus[KVM_MAX_VCPUS - 1];
 	for (t = time(NULL) + TIMEOUT; time(NULL) < t;) {
diff --git a/tools/testing/selftests/kvm/x86/sev_migrate_tests.c b/tools/testing/selftests/kvm/x86/sev_migrate_tests.c
index d59abb198d86..66c7ce49620a 100644
--- a/tools/testing/selftests/kvm/x86/sev_migrate_tests.c
+++ b/tools/testing/selftests/kvm/x86/sev_migrate_tests.c
@@ -128,7 +128,7 @@ static void test_sev_migrate_locking(void)
 		       sizeof(input[i].source_vms));
 
 	for (i = 0; i < NR_LOCK_TESTING_THREADS; ++i)
-		pthread_create(&pt[i], NULL, locking_test_thread, &input[i]);
+		kvm_pthread_create(&pt[i], NULL, locking_test_thread, &input[i]);
 
 	for (i = 0; i < NR_LOCK_TESTING_THREADS; ++i)
 		pthread_join(pt[i], NULL);
diff --git a/tools/testing/selftests/kvm/x86/sync_regs_test.c b/tools/testing/selftests/kvm/x86/sync_regs_test.c
index 5b0c2359bbb4..f7228af7d594 100644
--- a/tools/testing/selftests/kvm/x86/sync_regs_test.c
+++ b/tools/testing/selftests/kvm/x86/sync_regs_test.c
@@ -181,7 +181,7 @@ static void race_sync_regs(struct kvm_vcpu *vcpu, void *racer)
 		    !!(run->s.regs.sregs.cr4 & X86_CR4_PAE),
 		    !!(run->s.regs.sregs.efer & EFER_LME));
 
-	TEST_ASSERT_EQ(pthread_create(&thread, NULL, racer, (void *)run), 0);
+	kvm_pthread_create(&thread, NULL, racer, (void *)run);
 
 	for (t = time(NULL) + TIMEOUT; time(NULL) < t;) {
 		/*
diff --git a/tools/testing/selftests/kvm/x86/tsc_scaling_sync.c b/tools/testing/selftests/kvm/x86/tsc_scaling_sync.c
index 59da8d4da607..54b4b8d06d3b 100644
--- a/tools/testing/selftests/kvm/x86/tsc_scaling_sync.c
+++ b/tools/testing/selftests/kvm/x86/tsc_scaling_sync.c
@@ -94,7 +94,7 @@ int main(int argc, char *argv[])
 	pthread_t cpu_threads[NR_TEST_VCPUS];
 	unsigned long cpu;
 	for (cpu = 0; cpu < NR_TEST_VCPUS; cpu++)
-		pthread_create(&cpu_threads[cpu], NULL, run_vcpu, (void *)cpu);
+		kvm_pthread_create(&cpu_threads[cpu], NULL, run_vcpu, (void *)cpu);
 
 	unsigned long failures = 0;
 	for (cpu = 0; cpu < NR_TEST_VCPUS; cpu++) {
diff --git a/tools/testing/selftests/kvm/x86/xapic_ipi_test.c b/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
index 3a326c5e74ca..271ec09c629e 100644
--- a/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
+++ b/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
@@ -387,7 +387,6 @@ void get_cmdline_args(int argc, char *argv[], int *run_secs,
 
 int main(int argc, char *argv[])
 {
-	int r;
 	int wait_secs;
 	const int max_halter_wait = 10;
 	int run_secs = 0;
@@ -428,9 +427,7 @@ int main(int argc, char *argv[])
 	params[1].pipis_rcvd = pipis_rcvd;
 
 	/* Start halter vCPU thread and wait for it to execute first HLT. */
-	r = pthread_create(&threads[0], NULL, vcpu_thread, &params[0]);
-	TEST_ASSERT(r == 0,
-		    "pthread_create halter failed errno=%d", errno);
+	kvm_pthread_create(&threads[0], NULL, vcpu_thread, &params[0]);
 	fprintf(stderr, "Halter vCPU thread started\n");
 
 	wait_secs = 0;
@@ -447,8 +444,7 @@ int main(int argc, char *argv[])
 		"Halter vCPU thread reported its APIC ID: %u after %d seconds.\n",
 		data->halter_apic_id, wait_secs);
 
-	r = pthread_create(&threads[1], NULL, vcpu_thread, &params[1]);
-	TEST_ASSERT(r == 0, "pthread_create sender failed errno=%d", errno);
+	kvm_pthread_create(&threads[1], NULL, vcpu_thread, &params[1]);
 
 	fprintf(stderr,
 		"IPI sender vCPU thread started. Letting vCPUs run for %d seconds.\n",
diff --git a/tools/testing/selftests/kvm/x86/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86/xen_shinfo_test.c
index 5076f6a75455..20f518fe2450 100644
--- a/tools/testing/selftests/kvm/x86/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86/xen_shinfo_test.c
@@ -894,8 +894,7 @@ int main(int argc, char *argv[])
 				if (verbose)
 					printf("Testing shinfo lock corruption (KVM_XEN_HVM_EVTCHN_SEND)\n");
 
-				ret = pthread_create(&thread, NULL, &juggle_shinfo_state, (void *)vm);
-				TEST_ASSERT(ret == 0, "pthread_create() failed: %s", strerror(ret));
+				kvm_pthread_create(&thread, NULL, &juggle_shinfo_state, (void *)vm);
 
 				struct kvm_irq_routing_xen_evtchn uxe = {
 					.port = 1,
-- 
2.55.0.508.g3f0d502094-goog

