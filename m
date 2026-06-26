Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB2A3BED7E
	for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 21:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782509741; cv=none; b=rOKkAxdLOtOuyLwguhOYST6t2VFBTxGP+ZJcVdzVNB1Sp6mIinOs5+yO1xzAANpMQpkusp3yqVZahXPA3+SYKmvCLNH71uC7oMLGmSiSf10IGLvZobaUQa3nWE/2vYzsV9l+oFTUBakp9Ht6PKBmlY9DPBmhSzIgd10CFwLUWVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782509741; c=relaxed/simple;
	bh=+iVK0U72I4V9rzOETZXqLIHJYh3Jg+jyJNG57By+z/c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=T5bENCRQdaArk3jtQd9x7J7FntYFl/PZ8f7oeWTF34/ev/+oOFciuHLFcRZN5cYnmKdixg8R7qZyMkb/ja5aUYc10NqxQ4s9uK/32pIiMC6gIYr6e5dj+plcHhhW4fx2WYI82Qewn4I4vDr7TEMS57RjZ5kDdr2yNDFIzootM48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=C36+Btsy; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C36+Btsy"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2c80be91ea3so20129945ad.1
        for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 14:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782509739; x=1783114539; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4C/F69MMCNbFC/U7daD4jUcYFr10L9zUYtkcPR6sWF8=;
        b=C36+BtsypU8ijiDD+eF5+H9q9CSeMhFGpMjmLJOS0hbgb6ZM9YqD1/Jb/A1zHzQ/JD
         J0XomHKcUzX1iOZh/N5W28broHbdw2Gj7sm9ggB9kTHrGSA4HRb+EB9EFPUtBlcyoHaW
         sAuLlKjn8SwFYc2Co6QX9qbBgsBrYHZj1XHB7HrGfGx2BF5GLMxkutYgBPXjIWFzsJpj
         6mguYnY7K4Kscu8C+CI1cwajfZ5qSi5207UkZMLs2yDQCaVIkFeOxuZhNrWtc1ayRKWJ
         khQM6+PMrOYMDJersQai6V+LqQoigVRa1vB8PN5BNP4Xmm8vpwiMNWcfiOLoEmddUXyl
         3LlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782509739; x=1783114539;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4C/F69MMCNbFC/U7daD4jUcYFr10L9zUYtkcPR6sWF8=;
        b=HyYfN2SCW4Vc9qmMPwkrVHa3OG3PXCOI+qlS17GL0OXgnVIVsJVuJdtVI0DAHNgn5B
         Dz82tn5VzDbKqH5HXmbMb/Jku8gwg60dOGkGNTmo0lOGyooAFwxMhqiMNCTCL//Wr6cj
         u1XNXpyT5RT7uFDuS7WZtpZlXRJdka4mNXQ2fOxdHLV8tH1BKMKKpweDctPR7MXXvlnF
         IjHRQN4HxXLZRKbOti4mYscYae4ER3OsTPxD+FDSuhvSXmCqdvhEDFsHytv3sx0wwjJQ
         sXJhYA7GJzkaXSJbZeD78Gfj8/vNY93iHoxHsX07Fl/Olow02i6Du18MgrJvvUDoQBGx
         /n4g==
X-Forwarded-Encrypted: i=1; AHgh+RrF4rPlc1ngiNnpWYGNwasTeWals20vSjDJ4pKYZ1FhaP02XoSGkw7TzqM0p421nWqWg6GqoLQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YwVXVk+VvwvONnodgY/jIZBgrMx+fGI+cProrgrX68fqC0gVXZB
	Hw2N1ys4uy5vRkXtXJfUzklmz2aNaNlHaKYlXR5nbknQcMLnotEX96po5dEILLRMuPMEHDmUdj7
	t48cu4g==
X-Received: from plrr3.prod.google.com ([2002:a17:902:c603:b0:2c6:a096:4c29])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2f05:b0:2c2:be43:39bc
 with SMTP id d9443c01a7336-2c7fc6f3442mr85977465ad.22.1782509738712; Fri, 26
 Jun 2026 14:35:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jun 2026 14:35:15 -0700
In-Reply-To: <20260626213534.3866178-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260626213534.3866178-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260626213534.3866178-3-seanjc@google.com>
Subject: [PATCH v8 02/20] KVM: selftests: Add macros to read/write+sync
 to/from guest memory
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Sean Christopherson <seanjc@google.com>
Cc: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>, 
	Josh Hilke <jrhilke@google.com>
Content-Type: text/plain; charset="UTF-8"

From: David Matlack <dmatlack@google.com>

Add SYNC_FROM_GUEST_AND_READ(vm, variable), to read a variable value
from the guest. Add WRITE_AND_SYNC_TO_GUEST(vm, variable, value) to
write a value to a guest variable. These macros improve the readability
of code which reads and writes data between host and guest in tests.

Use the new macro in existing tests that do back-to-back write+sync.

No functional changes are intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
Co-developed-by: Josh Hilke <jrhilke@google.com>
Signed-off-by: Josh Hilke <jrhilke@google.com>
[sean: massage changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c  |  9 +++-----
 .../testing/selftests/kvm/include/kvm_util.h  | 10 +++++++++
 tools/testing/selftests/kvm/mmu_stress_test.c |  9 +++-----
 tools/testing/selftests/kvm/steal_time.c      | 22 +++++++------------
 4 files changed, 24 insertions(+), 26 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 74ca096bf976..087e94a8a81a 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -708,8 +708,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 
 		sync_global_to_guest(vm, iteration);
 
-		WRITE_ONCE(nr_writes, 0);
-		sync_global_to_guest(vm, nr_writes);
+		WRITE_AND_SYNC_TO_GUEST(vm, nr_writes, 0);
 
 		dirty_ring_prev_iteration_last_page = dirty_ring_last_page;
 		WRITE_ONCE(dirty_ring_vcpu_ring_full, false);
@@ -775,16 +774,14 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		 * writing memory during verification, pages that this thread
 		 * sees as clean may be written with this iteration's value.
 		 */
-		WRITE_ONCE(vcpu_stop, true);
-		sync_global_to_guest(vm, vcpu_stop);
+		WRITE_AND_SYNC_TO_GUEST(vm, vcpu_stop, true);
 		sem_wait(&sem_vcpu_stop);
 
 		/*
 		 * Clear vcpu_stop after the vCPU thread has acknowledge the
 		 * stop request and is waiting, i.e. is definitely not running!
 		 */
-		WRITE_ONCE(vcpu_stop, false);
-		sync_global_to_guest(vm, vcpu_stop);
+		WRITE_AND_SYNC_TO_GUEST(vm, vcpu_stop, false);
 
 		/*
 		 * Sync the number of writes performed before verification, the
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 04a910164a29..c1f588154398 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -1138,6 +1138,16 @@ vm_adjust_num_guest_pages(enum vm_guest_mode mode, unsigned int num_guest_pages)
 	memcpy(&(g), _p, sizeof(g));				\
 })
 
+#define SYNC_FROM_GUEST_AND_READ(_vm, _variable) ({		\
+	sync_global_from_guest(_vm, _variable);			\
+	READ_ONCE(_variable);					\
+})
+
+#define WRITE_AND_SYNC_TO_GUEST(_vm, _variable, _value) do {	\
+	WRITE_ONCE(_variable, _value);				\
+	sync_global_to_guest(_vm, _variable);			\
+} while (0)
+
 /*
  * Write a global value, but only in the VM's (guest's) domain.  Primarily used
  * for "globals" that hold per-VM values (VMs always duplicate code and global
diff --git a/tools/testing/selftests/kvm/mmu_stress_test.c b/tools/testing/selftests/kvm/mmu_stress_test.c
index 54d281419d31..473ef4c0ea9f 100644
--- a/tools/testing/selftests/kvm/mmu_stress_test.c
+++ b/tools/testing/selftests/kvm/mmu_stress_test.c
@@ -155,10 +155,8 @@ static void *vcpu_worker(void *data)
 		    "Expected EFAULT on write to RO memory, got r = %d, errno = %d", r, errno);
 
 	atomic_inc(&nr_ro_faults);
-	if (atomic_read(&nr_ro_faults) == nr_vcpus) {
-		WRITE_ONCE(all_vcpus_hit_ro_fault, true);
-		sync_global_to_guest(vm, all_vcpus_hit_ro_fault);
-	}
+	if (atomic_read(&nr_ro_faults) == nr_vcpus)
+		WRITE_AND_SYNC_TO_GUEST(vm, all_vcpus_hit_ro_fault, true);
 
 #if defined(__x86_64__) || defined(__aarch64__)
 	/*
@@ -383,8 +381,7 @@ int main(int argc, char *argv[])
 	rendezvous_with_vcpus(&time_run2, "run 2");
 
 	mprotect(mem, slot_size, PROT_READ);
-	mprotect_ro_done = true;
-	sync_global_to_guest(vm, mprotect_ro_done);
+	WRITE_AND_SYNC_TO_GUEST(vm, mprotect_ro_done, true);
 
 	rendezvous_with_vcpus(&time_ro, "mprotect RO");
 	mprotect(mem, slot_size, PROT_READ | PROT_WRITE);
diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index 76fcdd1fd3cb..2de87549fcc0 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -70,8 +70,8 @@ static bool is_steal_time_supported(struct kvm_vcpu *vcpu)
 static void steal_time_init(struct kvm_vcpu *vcpu, u32 i)
 {
 	/* ST_GPA_BASE is identity mapped */
-	st_gva[i] = (void *)(ST_GPA_BASE + i * STEAL_TIME_SIZE);
-	sync_global_to_guest(vcpu->vm, st_gva[i]);
+	WRITE_AND_SYNC_TO_GUEST(vcpu->vm, st_gva[i],
+				(void *)(ST_GPA_BASE + i * STEAL_TIME_SIZE));
 
 	vcpu_set_msr(vcpu, MSR_KVM_STEAL_TIME, (ulong)st_gva[i] | KVM_MSR_ENABLED);
 }
@@ -187,8 +187,7 @@ static void steal_time_init(struct kvm_vcpu *vcpu, u32 i)
 	};
 
 	/* ST_GPA_BASE is identity mapped */
-	st_gva[i] = (void *)(ST_GPA_BASE + i * STEAL_TIME_SIZE);
-	sync_global_to_guest(vm, st_gva[i]);
+	WRITE_AND_SYNC_TO_GUEST(vm, st_gva[i], (void *)(ST_GPA_BASE + i * STEAL_TIME_SIZE));
 
 	st_ipa = (ulong)st_gva[i];
 	vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &dev);
@@ -310,10 +309,8 @@ static bool is_steal_time_supported(struct kvm_vcpu *vcpu)
 static void steal_time_init(struct kvm_vcpu *vcpu, u32 i)
 {
 	/* ST_GPA_BASE is identity mapped */
-	st_gva[i] = (void *)(ST_GPA_BASE + i * STEAL_TIME_SIZE);
-	st_gpa[i] = addr_gva2gpa(vcpu->vm, (gva_t)st_gva[i]);
-	sync_global_to_guest(vcpu->vm, st_gva[i]);
-	sync_global_to_guest(vcpu->vm, st_gpa[i]);
+	WRITE_AND_SYNC_TO_GUEST(vcpu->vm, st_gva[i], (void *)(ST_GPA_BASE + i * STEAL_TIME_SIZE));
+	WRITE_AND_SYNC_TO_GUEST(vcpu->vm, st_gpa[i], addr_gva2gpa(vcpu->vm, (gva_t)st_gva[i]));
 }
 
 static void steal_time_dump(struct kvm_vm *vm, u32 vcpu_idx)
@@ -442,8 +439,7 @@ static void steal_time_init(struct kvm_vcpu *vcpu, u32 i)
 	};
 
 	/* ST_GPA_BASE is identity mapped */
-	st_gva[i] = (void *)(ST_GPA_BASE + i * STEAL_TIME_SIZE);
-	sync_global_to_guest(vm, st_gva[i]);
+	WRITE_AND_SYNC_TO_GUEST(vm, st_gva[i], (void *)(ST_GPA_BASE + i * STEAL_TIME_SIZE));
 
 	err = __vcpu_ioctl(vcpu, KVM_HAS_DEVICE_ATTR, &attr);
 	TEST_ASSERT(err == 0, "No PV stealtime Feature");
@@ -549,8 +545,7 @@ int main(int ac, char **av)
 
 		/* Second VCPU run, expect guest stolen time to be <= run_delay */
 		run_vcpu(vcpus[i]);
-		sync_global_from_guest(vm, guest_stolen_time[i]);
-		stolen_time = guest_stolen_time[i];
+		stolen_time = SYNC_FROM_GUEST_AND_READ(vm, guest_stolen_time[i]);
 		run_delay = get_run_delay();
 		TEST_ASSERT(stolen_time <= run_delay,
 			    "Expected stolen time <= %ld, got %ld",
@@ -570,8 +565,7 @@ int main(int ac, char **av)
 
 		/* Run VCPU again to confirm stolen time is consistent with run_delay */
 		run_vcpu(vcpus[i]);
-		sync_global_from_guest(vm, guest_stolen_time[i]);
-		stolen_time = guest_stolen_time[i] - stolen_time;
+		stolen_time = SYNC_FROM_GUEST_AND_READ(vm, guest_stolen_time[i]) - stolen_time;
 		TEST_ASSERT(stolen_time >= run_delay,
 			    "Expected stolen time >= %ld, got %ld",
 			    run_delay, stolen_time);
-- 
2.55.0.rc0.799.gd6f94ed593-goog

