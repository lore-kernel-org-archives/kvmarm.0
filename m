Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7F0E79C9
	for <kvmarm@lists.linux.dev>; Mon, 14 Nov 2022 17:12:52 +0000 (UTC)
Received: by mail-pj1-f54.google.com with SMTP id f5-20020a17090a4a8500b002131bb59d61so12762490pjh.1
        for <kvmarm@lists.linux.dev>; Mon, 14 Nov 2022 09:12:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2Gq4n5C/t1zsqZOKXkWVuXqIWklkF8rMGlYoqGLC400=;
        b=hO7Q0TY2AdjW2SD6aH3T1YtUt0UZafhbqB0bSJCNd1xF7xWabCGu1E1fsaROX7rMfy
         lD/V1XZSYCQTOyl4lO43R3jo9F6M7vce40/CeherGcldJjB5RPgLIfFmbrFJSzwzxfMd
         BXd0zzNBMn6jOLrN/30xO3Bv+pdhDJfCsRTjBOieHA4HrRntn+wqabxFbaeh1JkFqtdj
         PWcnLeRo5ToYlgDUzFSQhe4s8MjIlZhNeOUSgHtcwllrfmnWyU6cL+kEo9QD0G5XFhDa
         8BX2PObkGRyQB3gUdAzMgkNUp4Fe9d8wBcsCgtIHFSRpLwVW6ettTS4D0Ui+DIZ5dA6I
         tPSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2Gq4n5C/t1zsqZOKXkWVuXqIWklkF8rMGlYoqGLC400=;
        b=MkLrxX+XEkW3o4KjT8C7tH2HbRopHJgyw5VlTGWKatDGL3BrJ8LKkOYtlXfNmmOrqu
         1bUfBa5b59ZT9uKYQ32l6bmv9kIPIo1xxr4ylY2KcKegbORQToJurUe744RkVy3igohx
         hmNNYfF8gSFx38F5hFeha32kI8bgp5NX9CQHmXLY1c9hbDLKJ7Yfrg/Yezaz0SZfjcUc
         kilNbFgLmfvZ00Br4zCJAet74+3ivJLMdQH9hFzmmSzU5qzy+pFXt0zmtsIMrjLbMwbd
         mLkdxEfPtMAtfjYGhL0tD73NdRzqw39Pj+jjIZMEOQLAXjUQsqDooeW4oYNIq7rTwOOJ
         eYsg==
X-Gm-Message-State: ANoB5pm3lur9W1eFgvhAVvGK7NBuYG36S4jR0Wut+5Dlz8lf9C08U0Pp
	RcQG+hIWZjA97s3VpShxJm3f2A==
X-Google-Smtp-Source: AA0mqf7XnNmTQkkH7vcYfSPzE2TNLhf316K5J+UMYFkTvtQuWgviRBWa4oPj+NOxyf42Em0406m3YQ==
X-Received: by 2002:a17:902:f08a:b0:17f:8011:dd03 with SMTP id p10-20020a170902f08a00b0017f8011dd03mr250380pla.59.1668445972073;
        Mon, 14 Nov 2022 09:12:52 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id q6-20020a17090a2dc600b0020af2411721sm6689583pjm.34.2022.11.14.09.12.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 09:12:51 -0800 (PST)
Date: Mon, 14 Nov 2022 17:12:48 +0000
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org,
	David Matlack <dmatlack@google.com>, kvmarm@lists.cs.columbia.edu,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] KVM: selftests: Allow >1 guest mode in
 access_tracking_perf_test
Message-ID: <Y3J3EH74B6yafeqm@google.com>
References: <20221111231946.944807-1-oliver.upton@linux.dev>
 <20221111231946.944807-2-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221111231946.944807-2-oliver.upton@linux.dev>
Message-ID: <20221114171248.bR4bpNhmCwxCze3QwjxU1r857XFfQzM0YOmwrfDwAgw@z>

On Fri, Nov 11, 2022, Oliver Upton wrote:
> As the name implies, for_each_guest_mode() will run the test case for
> all supported guest addressing modes. On x86 that doesn't amount to
> anything, but arm64 can handle 4K, 16K, and 64K page sizes on supporting
> hardware.
> 
> Blindly attempting to run access_tracking_perf_test on arm64 stalls on
> the second test case, as the 'done' global remains set between test
> iterations. Clear it after VM teardown in anticipation of a subsequent
> test case.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  tools/testing/selftests/kvm/access_tracking_perf_test.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
> index 76c583a07ea2..4da066479e0a 100644
> --- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
> +++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
> @@ -326,6 +326,9 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  
>  	perf_test_join_vcpu_threads(nr_vcpus);
>  	perf_test_destroy_vm(vm);
> +
> +	/* Clear done in anticipation of testing another guest mode */
> +	done = false;

Can we fix this in the so called "perf_test" infrastructure?
memslot_modification_stress_test.c has the same bug just inverted (see run_vcpus).

E.g. (compile tested only)

---
 .../selftests/kvm/access_tracking_perf_test.c | 28 +++++--------------
 .../selftests/kvm/include/perf_test_util.h    |  3 ++
 .../selftests/kvm/lib/perf_test_util.c        |  3 ++
 .../kvm/memslot_modification_stress_test.c    |  6 +---
 4 files changed, 14 insertions(+), 26 deletions(-)

diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
index 76c583a07ea2..786bc62a2c79 100644
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
 
@@ -206,28 +203,20 @@ static void assert_ucall(struct kvm_vcpu *vcpu, uint64_t expected_ucall)
 		    expected_ucall, actual_ucall);
 }
 
-static bool spin_wait_for_next_iteration(int *current_iteration)
-{
-	int last_iteration = *current_iteration;
-
-	do {
-		if (READ_ONCE(done))
-			return false;
-
-		*current_iteration = READ_ONCE(iteration);
-	} while (last_iteration == *current_iteration);
-
-	return true;
-}
-
 static void vcpu_thread_main(struct perf_test_vcpu_args *vcpu_args)
 {
 	struct kvm_vcpu *vcpu = vcpu_args->vcpu;
 	struct kvm_vm *vm = perf_test_args.vm;
 	int vcpu_idx = vcpu_args->vcpu_idx;
 	int current_iteration = 0;
+	int last_iteration;
+
+	while (!READ_ONCE(perf_test_args.stop_vcpus)) {
+		last_iteration = current_iteration;
+		do {
+			current_iteration = READ_ONCE(iteration);
+		} while (current_iteration == last_iteration);
 
-	while (spin_wait_for_next_iteration(&current_iteration)) {
 		switch (READ_ONCE(iteration_work)) {
 		case ITERATION_ACCESS_MEMORY:
 			vcpu_run(vcpu);
@@ -321,9 +310,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
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
 

base-commit: 10dbc57b5777e6938a648eb4a870bad448fcb6f5
-- 

