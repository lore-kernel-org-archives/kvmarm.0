Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6267C1C758
	for <kvmarm@lists.linux.dev>; Fri,  2 Jun 2023 16:09:28 +0000 (UTC)
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-53425d37fefso973752a12.3
        for <kvmarm@lists.linux.dev>; Fri, 02 Jun 2023 09:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685722167; x=1688314167;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vX8ZCjC9l+xt5cqUnwzlqCkk/7EvJIEZcs67EwYM95Y=;
        b=ZpYUhbbZC6uUYrReM+ixNdEUwp22WUU7l8j2aahWsJUYqP381L7DaYeopKye6+Q9sn
         w6jGO0nX6WnAtH7Q3sGlOdc68vECR5PacYtF8uFrv3gPYqUB1KYLtsQIi3wA+701ktoo
         VcYLyZENUnFYI88cWmJbgLosheXItBqWsjUj1JOOFK7yQMQ1EVYBrKEM74EAZ9G1JJes
         +Fy3XP3gLD3JszJ1CTZiXeoILpXFoZBpgnn/vdDYBMvk+Dqwv0kvHMMpaOH7tt3QFj+s
         ke1ao1kRwftxIusnCaBSonu2zz1KVzCGGfUgW7HZsGqYe4xCh5lCKxmVw7qkF3LGd5ny
         Gpkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685722167; x=1688314167;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vX8ZCjC9l+xt5cqUnwzlqCkk/7EvJIEZcs67EwYM95Y=;
        b=POVuccScl2tRY9QW7rfeQ12NTRVwcyXCi8zagxG4VuxnkShN6pJFlZ7RRbAR3wWNj4
         JoX3T4n6gZEy40d2SwjwJzVH9gHE6aSbKbRsFzi046SMqHPQrG56Yp1xyLCHiGTMjfm2
         fKKsWsYjduKg+rsPRoch975d/yBZuFQIhkkpLsZOyq4NWx5xDDG9lgij0TL1VtNZVaTW
         8Rn7qUFyYydVSpil+IHm+ZbRmZxU2m1W/xYxJnqR+HaiQYfdy4Jz8oF7cPrZyB5YpIiu
         /7ifKLTMEkxt/efeISUHDb7Z1NQq4o6xFne8ApmGs6iDYyilNw4NMwycHd8V6C4z5dSw
         Y6ZQ==
X-Gm-Message-State: AC+VfDyBksyEBkYS3AW3MxNAccve+zKZJ6cU7hQhRlyY9v/r8n750bgw
	vGOeyrHh4hgGuDkeUQdIk5TsEfEoloE1
X-Google-Smtp-Source: ACHHUZ7w+3zMwOJ66cN0pwH2useIGj7AgTlfLjnw5VFZgi7VE2BNKptqAZGtU12TE7bl7/aJEHHayi6hzCyj
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a63:685:0:b0:530:866e:c3c1 with SMTP id
 127-20020a630685000000b00530866ec3c1mr2520235pgg.11.1685722167618; Fri, 02
 Jun 2023 09:09:27 -0700 (PDT)
Date: Fri,  2 Jun 2023 09:09:02 -0700
In-Reply-To: <20230602160914.4011728-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230602160914.4011728-1-vipinsh@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602160914.4011728-5-vipinsh@google.com>
Subject: [PATCH v2 04/16] KVM: selftests: Print read-write progress by vCPUs
 in dirty_log_perf_test
From: Vipin Sharma <vipinsh@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, chenhuacai@kernel.org, aleksandar.qemu.devel@gmail.com, 
	tsbogend@alpha.franken.de, anup@brainfault.org, atishp@atishpatra.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com, 
	ricarkol@google.com
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Fetch count of read and write accesses from guest code and print sum of
these values across all vCPUs in dirty_log_perf_test.

This data provides progress made by vCPUs during dirty logging
operations. Since, vCPUs execute in lockstep with userspace dirty log
iterations, this metric is not very interesting. However, in future
commits when dirty_log_perf_test can execute vCPUs independently from
dirty log iterations then this metric can give good measure of vCPUs
performance during dirty logging.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 .../selftests/kvm/dirty_log_perf_test.c        | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 2e31f13aaba6..14b012a0dcb1 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -12,6 +12,7 @@
 #include <stdlib.h>
 #include <time.h>
 #include <pthread.h>
+#include <stdatomic.h>
 #include <linux/bitmap.h>
 
 #include "kvm_util.h"
@@ -66,17 +67,22 @@ static u64 dirty_log_manual_caps;
 static bool host_quit;
 static int iteration;
 static int vcpu_last_completed_iteration[KVM_MAX_VCPUS];
+static atomic_ullong total_reads;
+static atomic_ullong total_writes;
 
 static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
 {
 	struct kvm_vcpu *vcpu = vcpu_args->vcpu;
 	int vcpu_idx = vcpu_args->vcpu_idx;
 	uint64_t pages_count = 0;
+	uint64_t reads = 0;
+	uint64_t writes = 0;
 	struct kvm_run *run;
 	struct timespec start;
 	struct timespec ts_diff;
 	struct timespec total = (struct timespec){0};
 	struct timespec avg;
+	struct ucall uc = {};
 	int ret;
 
 	run = vcpu->run;
@@ -89,7 +95,7 @@ static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
 		ts_diff = timespec_elapsed(start);
 
 		TEST_ASSERT(ret == 0, "vcpu_run failed: %d\n", ret);
-		TEST_ASSERT(get_ucall(vcpu, NULL) == UCALL_SYNC,
+		TEST_ASSERT(get_ucall(vcpu, &uc) == UCALL_SYNC,
 			    "Invalid guest sync status: exit_reason=%s\n",
 			    exit_reason_str(run->exit_reason));
 
@@ -101,6 +107,8 @@ static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
 		if (current_iteration) {
 			pages_count += vcpu_args->pages;
 			total = timespec_add(total, ts_diff);
+			reads += uc.args[2];
+			writes += uc.args[3];
 			pr_debug("vCPU %d iteration %d dirty memory time: %ld.%.9lds\n",
 				vcpu_idx, current_iteration, ts_diff.tv_sec,
 				ts_diff.tv_nsec);
@@ -123,6 +131,8 @@ static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
 	pr_debug("\nvCPU %d dirtied 0x%lx pages over %d iterations in %ld.%.9lds. (Avg %ld.%.9lds/iteration)\n",
 		vcpu_idx, pages_count, vcpu_last_completed_iteration[vcpu_idx],
 		total.tv_sec, total.tv_nsec, avg.tv_sec, avg.tv_nsec);
+	atomic_fetch_add(&total_reads, reads);
+	atomic_fetch_add(&total_writes, writes);
 }
 
 struct test_params {
@@ -270,6 +280,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 			      dirty_log_manual_caps);
 
 	arch_setup_vm(vm, nr_vcpus);
+	atomic_store(&total_reads, 0);
+	atomic_store(&total_writes, 0);
 
 	/* Start the iterations */
 	iteration = 0;
@@ -388,6 +400,10 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 			clear_dirty_log_total.tv_nsec, avg.tv_sec, avg.tv_nsec);
 	}
 
+	pr_info("Total pages touched: %llu (Reads: %llu, Writes: %llu)\n",
+		atomic_load(&total_reads) + atomic_load(&total_writes),
+		atomic_load(&total_reads), atomic_load(&total_writes));
+
 	free_bitmaps(bitmaps, p->slots);
 	arch_cleanup_vm(vm);
 	memstress_destroy_vm(vm);
-- 
2.41.0.rc0.172.g3f132b7071-goog

