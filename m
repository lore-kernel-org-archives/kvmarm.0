Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC552E62A4
	for <kvmarm@lists.linux.dev>; Sat, 13 Jun 2026 00:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781310065; cv=none; b=ZeUVfELH+JUX6fOvWmjmormLIfz0hN8gIlUKi05lbSZ7ziGB2UiaYwb2M2QZ2xvge10QoTznAmCYSy8Py8yEkcRkKiBY1qRcGFG8hTrUAqIMG+q+ZtJtoXGWGaBU+y5dS4rusxFMNL2aMZG/lKgrmXf27wfFvJMwkz9h1eQ91w0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781310065; c=relaxed/simple;
	bh=DXm65+wwCfmwcAhLsPNv0VdtsrYVwst7/L7xVk8vR0E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UxwA3LCN+ed/+XsMekKmlJi6rVbvW547vTra9Li28e/RzZDFY5mVIgtMByAwY6RrQRVTMRPYW44usgnJ0gn8zD0usMAqmPvATzg0tFaGseagIdh4iQ1p3s7HWRdzZEozygZnoSc68mOv85QbdgGIzRUEJX0bnQRaBS/nfv/em70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dBAuyU2O; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dBAuyU2O"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2bf004bf8beso18624245ad.3
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 17:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781310054; x=1781914854; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=sWIXchGp3EK3iYBKn9Q0PTpgyTSAfcuEHB9Bn8r8u9A=;
        b=dBAuyU2OaVix4lboJ3Ug1q27hQL5cVaOQGB3RlhI8/f4Ew4uk+lCXLLzbBgYX1dI6c
         7DYYnUx2HBFbZpfWgkQXj9fOGWtWA0YeOfpmlhJ/GgbTu60Csc6LtzOvPeFZc91FNJKn
         NzP0yrgBK4Sj+MhOJNtHl7Im7L3FCwAlEXmzUwH0uNCzdJB/oACmM+d0Ao/WC3wpKf8c
         HgqUyd3sPpX2eLb5propyMPSE1mOCGOEYDwmyUQPrU4uKRlX92ysrXe82bGQ8wqnHcSZ
         avVfceR9cRHSGHfYsGEDZkNFjd58Ew3M6jMc71EiS/joehOTD2+AzBxJXesRhRLKUh8X
         0Uwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781310054; x=1781914854;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sWIXchGp3EK3iYBKn9Q0PTpgyTSAfcuEHB9Bn8r8u9A=;
        b=oThMaHWLNZlwihPD6ZdEh7s7G4G7pyjnSPXWHwHu07+8sBZTayVdiYmkiYs6v5fFzD
         hZHB9/pNOLjFF/lMeS61ty5YInhsLt+DmC+hHim0a8owQB7C0/Q02OimElAj9VQsKvn0
         uc7qfMXNN0SrXRpSFX2DTcT0cfeeYL0kWcSs9zwSwUrRx3YMw/P+9HeA1dYjfftu8kza
         rjeTuVdaJ5XZ1i6fBDk9KS4yjdVP7JyLnFxt+cIyW0T6EL42FYPo3Dl4KuNfjtL4Pg+N
         BrHtgC1LszJdc81M15fS0RCNmE8dyghHWztyzc1gmc4U3EVk3TcwpqPHKDWL2W8dM1jM
         ymeA==
X-Forwarded-Encrypted: i=1; AFNElJ9M0exw/Q7cuQ5AyoemeY7UFMBXVUyfzjGUKxXyw544yTK11GpAis6AfDzdh2ubgHNPONhyfFo=@lists.linux.dev
X-Gm-Message-State: AOJu0YxAxYDQskb3zFKbGahOW3jUXk5HsMb7XeQ6EW+jDX2Km+VaVO+u
	7YlUhUK60qK6Qw839KkkXwVuRWZs8+vZX/qFvDerK8/C2pyIlyWkM8kE3p5XBOF89/uUVlAoTCC
	C3QTKig==
X-Received: from plrf19.prod.google.com ([2002:a17:902:ab93:b0:2bd:5ced:c1c0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:f8e:b0:2c0:d8ee:7d66
 with SMTP id d9443c01a7336-2c6642a221amr19502385ad.36.1781310054137; Fri, 12
 Jun 2026 17:20:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Jun 2026 17:20:26 -0700
In-Reply-To: <20260613002031.745413-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260613002031.745413-1-seanjc@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260613002031.745413-16-seanjc@google.com>
Subject: [PATCH v7 15/20] KVM: selftests: Add kvm_gettid() wrapper and convert users
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
2.54.0.1136.gdb2ca164c4-goog

