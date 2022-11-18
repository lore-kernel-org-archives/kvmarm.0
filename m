Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C118CC4332F
	for <kvmarm@archiver.kernel.org>; Fri, 18 Nov 2022 21:15:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 346844BAE3;
	Fri, 18 Nov 2022 16:15:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hgoubpQHLdMG; Fri, 18 Nov 2022 16:15:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D52574B9B2;
	Fri, 18 Nov 2022 16:15:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CFE224BAD3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2022 16:15:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5Xl4o5YtgmGb for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Nov 2022 16:15:25 -0500 (EST)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C91894BADF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2022 16:15:24 -0500 (EST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1668806123;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=xCYUGaupX5cvs453r6y2KLObby9QVEfhtajAIprPxEc=;
 b=Fx49S7ywYMGdFD/E2m89wuPcBkOOaNariIsk6xwrf0cC8m9A1le4R7byvtN8e9Zws+iYs4
 PFX0XSDRyjA9eUO3YO0WryXgbm9Y/7dQX3OuDzGoihEHDD+vQVGQFlxiokm4Edj+bLtO/k
 TRm4SvgtwTlNem4WVM9PGCB4mGf+ZC4=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>
Subject: [PATCH v2 1/2] KVM: selftests: Have perf_test_util signal when to
 stop vCPUs
Date: Fri, 18 Nov 2022 21:15:02 +0000
Message-Id: <20221118211503.4049023-2-oliver.upton@linux.dev>
In-Reply-To: <20221118211503.4049023-1-oliver.upton@linux.dev>
References: <20221118211503.4049023-1-oliver.upton@linux.dev>
MIME-Version: 1.0
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Signal that a test run is complete through perf_test_args instead of
having tests open code a similar solution. Ensure that the field resets
to false at the beginning of a test run as the structure is reused
between test runs, eliminating a couple of bugs:

access_tracking_perf_test hangs indefinitely on a subsequent test run,
as 'done' remains true. The bug doesn't amount to much right now, as x86
supports a single guest mode. However, this is a precondition of
enabling the test for other architectures with >1 guest mode, like
arm64.

memslot_modification_stress_test has the exact opposite problem, where
subsequent test runs complete immediately as 'run_vcpus' remains false.

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
[oliver: added commit message, preserve spin_wait_for_next_iteration()]
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 tools/testing/selftests/kvm/access_tracking_perf_test.c   | 8 +-------
 tools/testing/selftests/kvm/include/perf_test_util.h      | 3 +++
 tools/testing/selftests/kvm/lib/perf_test_util.c          | 3 +++
 .../selftests/kvm/memslot_modification_stress_test.c      | 6 +-----
 4 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
index 76c583a07ea2..942370d57392 100644
--- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
+++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
@@ -58,9 +58,6 @@ static enum {
 	ITERATION_MARK_IDLE,
 } iteration_work;
 
-/* Set to true when vCPU threads should exit. */
-static bool done;
-
 /* The iteration that was last completed by each vCPU. */
 static int vcpu_last_completed_iteration[KVM_MAX_VCPUS];
 
@@ -211,7 +208,7 @@ static bool spin_wait_for_next_iteration(int *current_iteration)
 	int last_iteration = *current_iteration;
 
 	do {
-		if (READ_ONCE(done))
+		if (READ_ONCE(perf_test_args.stop_vcpus))
 			return false;
 
 		*current_iteration = READ_ONCE(iteration);
@@ -321,9 +318,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	mark_memory_idle(vm, nr_vcpus);
 	access_memory(vm, nr_vcpus, ACCESS_READ, "Reading from idle memory");
 
-	/* Set done to signal the vCPU threads to exit */
-	done = true;
-
 	perf_test_join_vcpu_threads(nr_vcpus);
 	perf_test_destroy_vm(vm);
 }
diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
index eaa88df0555a..536d7c3c3f14 100644
--- a/tools/testing/selftests/kvm/include/perf_test_util.h
+++ b/tools/testing/selftests/kvm/include/perf_test_util.h
@@ -40,6 +40,9 @@ struct perf_test_args {
 	/* Run vCPUs in L2 instead of L1, if the architecture supports it. */
 	bool nested;
 
+	/* Test is done, stop running vCPUs. */
+	bool stop_vcpus;
+
 	struct perf_test_vcpu_args vcpu_args[KVM_MAX_VCPUS];
 };
 
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 9618b37c66f7..ee3f499ccbd2 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -267,6 +267,7 @@ void perf_test_start_vcpu_threads(int nr_vcpus,
 
 	vcpu_thread_fn = vcpu_fn;
 	WRITE_ONCE(all_vcpu_threads_running, false);
+	WRITE_ONCE(perf_test_args.stop_vcpus, false);
 
 	for (i = 0; i < nr_vcpus; i++) {
 		struct vcpu_thread *vcpu = &vcpu_threads[i];
@@ -289,6 +290,8 @@ void perf_test_join_vcpu_threads(int nr_vcpus)
 {
 	int i;
 
+	WRITE_ONCE(perf_test_args.stop_vcpus, true);
+
 	for (i = 0; i < nr_vcpus; i++)
 		pthread_join(vcpu_threads[i].thread, NULL);
 }
diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
index bb1d17a1171b..3a5e4518307c 100644
--- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
+++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
@@ -34,8 +34,6 @@
 static int nr_vcpus = 1;
 static uint64_t guest_percpu_mem_size = DEFAULT_PER_VCPU_MEM_SIZE;
 
-static bool run_vcpus = true;
-
 static void vcpu_worker(struct perf_test_vcpu_args *vcpu_args)
 {
 	struct kvm_vcpu *vcpu = vcpu_args->vcpu;
@@ -45,7 +43,7 @@ static void vcpu_worker(struct perf_test_vcpu_args *vcpu_args)
 	run = vcpu->run;
 
 	/* Let the guest access its memory until a stop signal is received */
-	while (READ_ONCE(run_vcpus)) {
+	while (!READ_ONCE(perf_test_args.stop_vcpus)) {
 		ret = _vcpu_run(vcpu);
 		TEST_ASSERT(ret == 0, "vcpu_run failed: %d\n", ret);
 
@@ -110,8 +108,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	add_remove_memslot(vm, p->memslot_modification_delay,
 			   p->nr_memslot_modifications);
 
-	run_vcpus = false;
-
 	perf_test_join_vcpu_threads(nr_vcpus);
 	pr_info("All vCPU threads joined\n");
 
-- 
2.38.1.584.g0f3c55d4c2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
