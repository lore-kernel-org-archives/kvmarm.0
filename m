Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A59D5689
	for <kvmarm@lists.linux.dev>; Fri, 21 Apr 2023 16:53:19 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-b8f6d2ac543so3270854276.2
        for <kvmarm@lists.linux.dev>; Fri, 21 Apr 2023 09:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682095998; x=1684687998;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aIXwJZ86g2cMsPal848/IoLZKDxpkMIUoWM/xoiNZjQ=;
        b=OIjqFWC1f6JrRiHtRugX+y84MBGm6ZcE+DgB55EOotUGyniIQQqePlnbirQ3o2dDFU
         ZnbasVHpI23zQIfcI6Jn3dVfZwuX6HKTuVl0G4OM/jmCEWcu3RScvyE/peQMI6YRxFAi
         gf0XUXKKZmW/2xI2sZZBymHSazOLXzzNqXiPCfYZYBJgFR1ppXYdTKevwBVLtyFVmsIu
         +l8sz+E+NsmIMDQ/1tM0lFmpgOnwSQOEUwLEGaRH1NEwhUlguM0BNFYJ1HKGHsauRDG0
         npWVDOT9XxNmTt4xr+n6quK+ZKfLBdDgq8rhh/Dtt9wDzk6+CyFCPfqqi4sAI0/YzshM
         AXnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682095998; x=1684687998;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aIXwJZ86g2cMsPal848/IoLZKDxpkMIUoWM/xoiNZjQ=;
        b=Jv0RVTarxIX4RHqY73RP974H2tCQMc/Urwb1Q3k6gooULAN9sTqWU/3ewjSv7M7cb/
         tLN541d98U0i3LKANT/ZgXvVWKj3lo2KsefKXkxPTZrKydL2OQ/c4yoOwjM5X73qfEMG
         /fLc2WxUUroeWR0Q/yqgjvYIX326NAvPijiOACacY9gShUdkGPMX0KescCY/uO73s15s
         Xk3xgT+LeLgCIeHLRp67P/LWhfWZHiFaA5dQQVTOp72y0P+CjUcupCDzU7XFyxwEN1T8
         pf9SxOPjjwn51UuWSAfFy5m7vZArkABmlGOAV5TF66fGYBgDAq44n6HGi9UYb61lGKOC
         NcPg==
X-Gm-Message-State: AAQBX9e5sNlaO/QH0Yyo4Y76rNpAaWsYEOCPZXkXFw8f41aEfSHY6+76
	rPkl3y38PQ8HgbML1CxmJoZ+ApJd4moA
X-Google-Smtp-Source: AKy350bXgyJDTEgckFAM/H87961TV8R1B/izBkH2FZgQ+FxNt6ajRDFj7SNSbgxdm0eZ4bQuJyBfwm/9rS7m
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a25:d147:0:b0:b8c:ad5:6b4e with SMTP id
 i68-20020a25d147000000b00b8c0ad56b4emr1983907ybg.12.1682095998019; Fri, 21
 Apr 2023 09:53:18 -0700 (PDT)
Date: Fri, 21 Apr 2023 09:53:01 -0700
In-Reply-To: <20230421165305.804301-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230421165305.804301-1-vipinsh@google.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230421165305.804301-6-vipinsh@google.com>
Subject: [PATCH 5/9]  KVM: selftests: Allow independent execution of vCPUs in dirty_log_perf_test
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

Allow vCPUs to execute independent of dirty log iterations after
initialization is complete. Hide this feature behind the new option
"-j".

This change makes dirty_log_perf_test execute like real world workflows
where guest vCPUs keep on executing while VMM collects dirty logs. Total
pages touched during execution of test will give good estimate of how
vCPUs are performing while dirty logging is enabled.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 .../selftests/kvm/dirty_log_perf_test.c       | 60 ++++++++++++-------
 1 file changed, 40 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 0a08a3d21123..ffdad535fdaa 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -69,6 +69,7 @@ static int iteration;
 static int vcpu_last_completed_iteration[KVM_MAX_VCPUS];
 static atomic_ullong total_reads;
 static atomic_ullong total_writes;
+static bool lockstep_iterations;
 
 static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
 {
@@ -83,12 +84,16 @@ static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
 	struct timespec total = (struct timespec){0};
 	struct timespec avg;
 	struct ucall uc = {};
+	int current_iteration = -1;
 	int ret;
 
 	run = vcpu->run;
 
 	while (!READ_ONCE(host_quit)) {
-		int current_iteration = READ_ONCE(iteration);
+		if (lockstep_iterations)
+			current_iteration = READ_ONCE(iteration);
+		else
+			current_iteration++;
 
 		clock_gettime(CLOCK_MONOTONIC, &start);
 		ret = _vcpu_run(vcpu);
@@ -118,13 +123,19 @@ static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
 				ts_diff.tv_nsec);
 		}
 
-		/*
-		 * Keep running the guest while dirty logging is being disabled
-		 * (iteration is negative) so that vCPUs are accessing memory
-		 * for the entire duration of zapping collapsible SPTEs.
-		 */
-		while (current_iteration == READ_ONCE(iteration) &&
-		       READ_ONCE(iteration) >= 0 && !READ_ONCE(host_quit)) {}
+		if (lockstep_iterations) {
+			/*
+			 * Keep running the guest while dirty logging is being disabled
+			 * (iteration is negative) so that vCPUs are accessing memory
+			 * for the entire duration of zapping collapsible SPTEs.
+			 */
+			while (current_iteration == READ_ONCE(iteration) &&
+			       READ_ONCE(iteration) >= 0 && !READ_ONCE(host_quit))
+				;
+		} else {
+			while (!READ_ONCE(iteration))
+				;
+		}
 	}
 
 	avg = timespec_div(total, vcpu_last_completed_iteration[vcpu_idx]);
@@ -238,17 +249,19 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		clock_gettime(CLOCK_MONOTONIC, &start);
 		iteration++;
 
-		pr_debug("Starting iteration %d\n", iteration);
-		for (i = 0; i < nr_vcpus; i++) {
-			while (READ_ONCE(vcpu_last_completed_iteration[i])
-			       != iteration)
-				;
-		}
+		if (lockstep_iterations) {
+			pr_debug("Starting iteration %d\n", iteration);
+			for (i = 0; i < nr_vcpus; i++) {
+				while (READ_ONCE(vcpu_last_completed_iteration[i])
+				       != iteration)
+					;
+			}
 
-		ts_diff = timespec_elapsed(start);
-		vcpu_dirty_total = timespec_add(vcpu_dirty_total, ts_diff);
-		pr_info("Iteration %d dirty memory time: %ld.%.9lds\n",
-			iteration, ts_diff.tv_sec, ts_diff.tv_nsec);
+			ts_diff = timespec_elapsed(start);
+			vcpu_dirty_total = timespec_add(vcpu_dirty_total, ts_diff);
+			pr_info("Iteration %d dirty memory time: %ld.%.9lds\n",
+				iteration, ts_diff.tv_sec, ts_diff.tv_nsec);
+		}
 
 		clock_gettime(CLOCK_MONOTONIC, &start);
 		memstress_get_dirty_log(vm, bitmaps, p->slots);
@@ -365,6 +378,10 @@ static void help(char *name)
 	       "     To leave the application task unpinned, drop the final entry:\n\n"
 	       "         ./dirty_log_perf_test -v 3 -c 22,23,24\n\n"
 	       "     (default: no pinning)\n");
+	printf(" -j: Execute vCPUs independent of dirty log iterations\n"
+	       "     Independent vCPUs execution will allow them to continuously\n"
+	       "     dirty memory while main thread is collecting and clearing\n"
+	       "     dirty logs in the main thread's iterations.\n");
 	printf(" -k: Specify the chunk size in which dirty memory gets cleared\n"
 	       "     in memslots in each iteration. If the size is bigger than\n"
 	       "     the memslot size then whole memslot is cleared in one call.\n"
@@ -399,10 +416,10 @@ int main(int argc, char *argv[])
 		kvm_check_cap(KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
 	dirty_log_manual_caps &= (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE |
 				  KVM_DIRTY_LOG_INITIALLY_SET);
-
+	lockstep_iterations = true;
 	guest_modes_append_default();
 
-	while ((opt = getopt(argc, argv, "ab:c:eghi:k:l:m:nop:r:s:v:x:w:")) != -1) {
+	while ((opt = getopt(argc, argv, "ab:c:eghi:jk:l:m:nop:r:s:v:x:w:")) != -1) {
 		switch (opt) {
 		case 'a':
 			p.random_access = true;
@@ -426,6 +443,9 @@ int main(int argc, char *argv[])
 		case 'i':
 			p.iterations = atoi_positive("Number of iterations", optarg);
 			break;
+		case 'j':
+			lockstep_iterations = false;
+			break;
 		case 'k':
 			p.clear_chunk_size = parse_size(optarg);
 			break;
-- 
2.40.0.634.g4ca3ef3211-goog

