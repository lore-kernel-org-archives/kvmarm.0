Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB443C3C06
	for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 21:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782509759; cv=none; b=HYcGV0E4vrTFgRzusaze3s0fwvsUDihZO22vNhCEm3aWjyAHBdlZcvOQ9OnaF9SY6WXDxH8TpWWu2rg0NTujU5ekH6FHZhZB8/rCpF+htGGXTzbhrX8hSMYy0/GUDX3Ethbr1MYaUtxgtLvHaXvQdq941sMj3Ptibcw6+0hAAHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782509759; c=relaxed/simple;
	bh=C8Pm8bDjAvONP3npZngQGRIsMoOy/jsuoXoApS2hZsE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Wc/aQfg4tSS6c8kpiaXvdduPwcW3xKa/RCDArmFbNAxaql3g9F7CSvHR7CPPW3+NSo0DN4dDzO+X5YPtte5X7Xk0hRPZUKwU8I3uA3ZjXDH9IsgNkVZJu8LsI4GDsgz6Ml27/0EI0Ggevew5ZaU32bUVjs4UjUoNSS//si55A34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kFXSqO6+; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kFXSqO6+"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-37df91eab27so1388898a91.2
        for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 14:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782509755; x=1783114555; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=MGnCIDvL4VuiQREjmSstYz3dctCxQA8TSy/TAbZS7yY=;
        b=kFXSqO6+YLllCaRJpZ02JMtn+p4WDpt/KC8xRzVTbblDITXpknelXR4SZRz+WaHLxa
         gltGoQuLMfrmpvJP8i1uJ40B5Sv9d9X3LjelSLZEPwBmCjXa27jR/eQ9ffB2tQfU8R7X
         Jv52YJCBaH+roKTXDLBiFrmyL5RC5YGIRwEGEYr2pYEVOxWkpJmQQVJQhGlsKYEePpyz
         R7gBZZVIIdCilU/G6KpihG14+FGftB5AXe2ygj8mdJsZhlE5xob7trjbjd97sytaXnV5
         +2BA8h0TW1sD8YWtVYfvztZdiUoSUr/V7A7WPSmYlKCox3Wm6Yf4ijK9nme+pzXGgmKF
         RySg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782509755; x=1783114555;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MGnCIDvL4VuiQREjmSstYz3dctCxQA8TSy/TAbZS7yY=;
        b=AFl4hP2hXF1VN87o25Y/zxXrA9xHbrkvYVCkdmeFB1wWTJz/D1SknzaBF9fXKuHxLq
         Hz9Q9EYvfv2NFpdRHlNBQVZy+mshPC12dAYrKzVLB4J46FbhISsrUadlFmT1UP12cZYV
         RMebcXjEkxJBvU1rddoT6rzaOmDNhlKDAj7r+xg07dwybZ1pSAUNl4s5PtZq2TB40mzu
         vcumI+Ys1RFniTJcfMZ3IOPisu6j/My8h/uA6nvbZIxRadb1gfsGOJjIltVwI3vfR09C
         A2D9jYv1w8EqBKVt3BYYz299I1MB3BWhH678YzpHCrMeM4wtFTpXmxpwxWdTLb2AP/iA
         0xCQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq9NQpbo05cOnPrrBL8zXZmWyGZ4ayZqgkxepxTAhpXjSjlMuTnv2AOgRy3/6jMapkYDYuP8PI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz6PTNYd4kWiMZZceMwVdbwk3MjMPNOe4RBY3chkBYaU9kBdm44
	EVAIu4WA8CyWe4U3kW45cVmxSsx9MR6fO69I9J7r3x91+sfIzg++ueKjvY6x5AO2owXt7pksAtx
	VkzBzlQ==
X-Received: from plau11.prod.google.com ([2002:a17:903:304b:b0:2c6:e595:44e1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2f4c:b0:2c9:9a19:10c
 with SMTP id d9443c01a7336-2c99a19037fmr10641045ad.40.1782509754664; Fri, 26
 Jun 2026 14:35:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jun 2026 14:35:28 -0700
In-Reply-To: <20260626213534.3866178-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260626213534.3866178-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260626213534.3866178-16-seanjc@google.com>
Subject: [PATCH v8 15/20] KVM: selftests: Add kvm_gettid() wrapper and convert users
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Sean Christopherson <seanjc@google.com>
Cc: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>, 
	Josh Hilke <jrhilke@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Josh Hilke <jrhilke@google.com>

Add a KVM wrapper for the gettid() syscall so that tests don't have to
open code the syscall() themselves.  Unfortunately, not all flavors of
libc that KVM selftests support provide gettid().  Convert all existing
users of the syscall to the new wrapper.

Note, per the gettid() manpage[1], "This call is always successful", i.e.
prefixing kvm_ to the syscall name is aligned with the goal of providing
syscall wrappers that guarantee success.

No functional changes intended.

Link: https://man7.org/linux/man-pages/man2/gettid.2.html [1]
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Josh Hilke <jrhilke@google.com>
[sean: massage changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/demand_paging_test.c   | 2 +-
 tools/testing/selftests/kvm/include/kvm_syscalls.h | 5 +++++
 tools/testing/selftests/kvm/lib/assert.c           | 8 ++------
 tools/testing/selftests/kvm/lib/test_util.c        | 3 ++-
 tools/testing/selftests/kvm/rseq_test.c            | 2 +-
 5 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index 302c4923d093..f8b3d0b68830 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -57,7 +57,7 @@ static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
 static int handle_uffd_page_request(int uffd_mode, int uffd,
 		struct uffd_msg *msg)
 {
-	pid_t tid = syscall(__NR_gettid);
+	pid_t tid = kvm_gettid();
 	u64 addr = msg->arg.pagefault.address;
 	struct timespec start;
 	struct timespec ts_diff;
diff --git a/tools/testing/selftests/kvm/include/kvm_syscalls.h b/tools/testing/selftests/kvm/include/kvm_syscalls.h
index 6cb3bed29b81..dc4fb97aef8d 100644
--- a/tools/testing/selftests/kvm/include/kvm_syscalls.h
+++ b/tools/testing/selftests/kvm/include/kvm_syscalls.h
@@ -83,6 +83,11 @@ static inline int kvm_dup(int fd)
 	return new_fd;
 }
 
+static inline pid_t kvm_gettid(void)
+{
+	return syscall(__NR_gettid);
+}
+
 __KVM_SYSCALL_DEFINE(munmap, 2, void *, mem, size_t, size);
 __KVM_SYSCALL_DEFINE(close, 1, int, fd);
 __KVM_SYSCALL_DEFINE(fallocate, 4, int, fd, int, mode, loff_t, offset, loff_t, len);
diff --git a/tools/testing/selftests/kvm/lib/assert.c b/tools/testing/selftests/kvm/lib/assert.c
index 8be0d09ecf0f..1d72dcdfce3b 100644
--- a/tools/testing/selftests/kvm/lib/assert.c
+++ b/tools/testing/selftests/kvm/lib/assert.c
@@ -10,6 +10,7 @@
 #include <sys/syscall.h>
 
 #include "kselftest.h"
+#include "kvm_syscalls.h"
 
 #ifdef __GLIBC__
 #include <execinfo.h>
@@ -64,11 +65,6 @@ static void test_dump_stack(void)
 static void test_dump_stack(void) {}
 #endif
 
-static pid_t _gettid(void)
-{
-	return syscall(SYS_gettid);
-}
-
 void __attribute__((noinline))
 test_assert(bool exp, const char *exp_str,
 	const char *file, unsigned int line, const char *fmt, ...)
@@ -81,7 +77,7 @@ test_assert(bool exp, const char *exp_str,
 		fprintf(stderr, "==== Test Assertion Failure ====\n"
 			"  %s:%u: %s\n"
 			"  pid=%d tid=%d errno=%d - %s\n",
-			file, line, exp_str, getpid(), _gettid(),
+			file, line, exp_str, getpid(), kvm_gettid(),
 			errno, strerror(errno));
 		test_dump_stack();
 		if (fmt) {
diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
index e208a57f190c..6b00ab11f3c0 100644
--- a/tools/testing/selftests/kvm/lib/test_util.c
+++ b/tools/testing/selftests/kvm/lib/test_util.c
@@ -17,6 +17,7 @@
 #include "linux/kernel.h"
 
 #include "test_util.h"
+#include "kvm_syscalls.h"
 
 sigjmp_buf expect_sigbus_jmpbuf;
 
@@ -395,7 +396,7 @@ long get_run_delay(void)
 	long val[2];
 	FILE *fp;
 
-	sprintf(path, "/proc/%ld/schedstat", syscall(SYS_gettid));
+	sprintf(path, "/proc/%ld/schedstat", (long)kvm_gettid());
 	fp = fopen(path, "r");
 	/* Return MIN_RUN_DELAY_NS upon failure just to be safe */
 	if (fscanf(fp, "%ld %ld ", &val[0], &val[1]) < 2)
diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
index f80ad6b47d16..6510fbfd64f1 100644
--- a/tools/testing/selftests/kvm/rseq_test.c
+++ b/tools/testing/selftests/kvm/rseq_test.c
@@ -244,7 +244,7 @@ int main(int argc, char *argv[])
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 
 	pthread_create(&migration_thread, NULL, migration_worker,
-		       (void *)(unsigned long)syscall(SYS_gettid));
+		       (void *)(unsigned long)kvm_gettid());
 
 	if (latency >= 0) {
 		/*
-- 
2.55.0.rc0.799.gd6f94ed593-goog

