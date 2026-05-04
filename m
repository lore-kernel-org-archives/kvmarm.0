Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C9937FF6D
	for <kvmarm@lists.linux.dev>; Mon,  4 May 2026 22:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777934576; cv=none; b=qsCjb4/YA/ozygk/nm2GOCTJtJ9S5CKYzQOwxB1RTU/FYa2RW9/COhiKq18bGGnmTujmPOhOp8J01/zHIy0ap9kbawgVu4lpdsy4cCLBLk5v6JvPUWxSjLsnhygUCGcxohSFUmiAIW/oAK+CB5yw7YZ+OeFPlk8eHjJYmA0jKzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777934576; c=relaxed/simple;
	bh=0BD6mkbohgb2czORLGaMoEldssxteY6SP7hZbvfyuC4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hauI1XkigMAlvKL+WJSJMjN5BIc0xJR9cCn67zpYR6kTwbV7pHYWayS0VjYoC2eHfB1ORKh2BwiFtKFmGvf/AqLzs1/3uFH3pGiM+QOeZ75MIZCn9l3JSVcDAfi+332Zf1Q5HY0MAUu2ZxrFBoZpd4ulUOZQ8DpZ+jgLSf8Nx4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bA89J5Bj; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bA89J5Bj"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-8353df9bc7eso1951561b3a.2
        for <kvmarm@lists.linux.dev>; Mon, 04 May 2026 15:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777934574; x=1778539374; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ps0DFf8iRHwNv96IoiVMKA2BLuSI9Fl2G1MpiXXkiQc=;
        b=bA89J5BjTCQEY0JFvjc9FHtmLTkHvuuxJW76ug/5+p+TC5Orb1Afl1akbrbCPmI9AQ
         soahqXNtyizv/Ti8jvnNJmnH1a9CQObgHRDGsaP0G4eXBjJYWtR3XruPpqxnBNKY5oXm
         QrQdK3QU1c4RtFwjh9N6njEAobJqJgv/kJVOGNo+r5W44ENkmTWhPX/zj4M6eGzph8GW
         T+tbOqyM2koGBt74rPq9F8XvWM6mLFmM9VNU+3vTXrn24Y/rYtzg4egDnLs6ifmSMAfG
         qJMxGeUAIcbTddo5+wfUdBdbhLvpSaX3dGyCwswlR/PwcpD0yCiLP3AKux96yE1/de4K
         KhPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777934574; x=1778539374;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ps0DFf8iRHwNv96IoiVMKA2BLuSI9Fl2G1MpiXXkiQc=;
        b=pMsHq+fM0veqUJxO6gjF53eD5tFb4UZeCLAaP2OqmRDRHO8ma0cUB/OuRDGh7VcR7N
         puguGrh2++TRDY1p9Zkc3uIltJTkUk7TzR4gi3/2hPIgvPB3fseGtdAkKmTI4eNLBqDo
         66FsPJm/pUhRWvC3tJy66sPme5Iv52NV08q9cYGLRcceZzLMLR2MZSpwBlAFZX5sjDQa
         kSgg+Pg4ztuPiu+1tC7wepNbROs0bm7JPahksdoMhOpPrbbzmC/NpBDv9x4OfDAez58L
         B4l+sbK9vGJTMOtByosMdRS9RgWfadCjpDG75LC8/7cjvoNZbw5lI33r9g6pIYOynl08
         m+pw==
X-Forwarded-Encrypted: i=1; AFNElJ9Pi4vczFUM21LxWQSP2ICsVCRvO4Sd5YoBQEOMbnQxPPxGycKTJLDvj1BIrPBUm+A2U3NPbeM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yya79hpDpHkg5FvqQJ4xWx/VyETxsF/R5vjvUGoFDTJht0/a9A1
	K9GddPvzHvMaxhJ0kJFjMQFhdQdwkCpsZk+ssp0H6TG7FzSDc3PXk/zTHJXZ5oGsGtccX7vp+If
	JY8c1gEXpwchvipQ/+DgQoQ==
X-Received: from pfbdo5.prod.google.com ([2002:a05:6a00:4a05:b0:835:4488:892b])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:aa7:8044:0:b0:835:6173:dd2 with SMTP id d2e1a72fcca58-835617316f9mr5445427b3a.44.1777934574253;
 Mon, 04 May 2026 15:42:54 -0700 (PDT)
Date: Mon,  4 May 2026 22:42:12 +0000
In-Reply-To: <20260504224213.1049426-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260504224213.1049426-1-jthoughton@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260504224213.1049426-6-jthoughton@google.com>
Subject: [PATCH 5/5] DO NOT MERGE: KVM: selftests: Reproducer for arm64 double-free
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Sean Christopherson <seanjc@google.com>, Gavin Shan <gshan@redhat.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, James Hogan <jhogan@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a delay and a counter for the split_page_cache double-free to
reliably demonstrate the race. Please see the cover letter and the arm64
fix patch for more information.

The selftest is partially written by Gemini.

Assisted-by: Gemini:gemini-3-flash-preview
Not-signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/arm64/include/asm/kvm_host.h             |   1 +
 arch/arm64/kvm/mmu.c                          |  16 +++
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../testing/selftests/kvm/transfer_fd_test.c  | 129 ++++++++++++++++++
 4 files changed, 147 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/transfer_fd_test.c

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 65eead8362e0..5072fc2e2eb8 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -192,6 +192,7 @@ struct kvm_s2_mmu {
 	 * Protected by kvm->slots_lock.
 	 */
 	struct kvm_mmu_memory_cache split_page_cache;
+	int is_freeing;
 	uint64_t split_page_chunk_size;
 
 	struct kvm_arch *arch;
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 4bab407d43bb..fa05900a5124 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1004,6 +1004,8 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 	mmu->split_page_chunk_size = KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT;
 	mmu->split_page_cache.gfp_zero = __GFP_ZERO;
 
+	mmu->is_freeing = 0;
+
 	mmu->pgd_phys = __pa(pgt->pgd);
 
 	if (kvm_is_nested_s2_mmu(kvm, mmu))
@@ -1021,10 +1023,24 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 
 void kvm_uninit_stage2_mmu(struct kvm *kvm)
 {
+	int is_freeing;
+	ktime_t s;
+
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
 	kvm_free_stage2_pgd_locked(&kvm->arch.mmu);
+
+	is_freeing = ++kvm->arch.mmu.is_freeing;
+	s = ktime_get();
+
+	/* Sleep for 10ms */
+	while (ktime_to_ns(ktime_get()) - ktime_to_ns(s) < 1E7) {}
+
+	WARN(is_freeing > 1, "detected double-free of split page cache");
+
 	kvm_mmu_free_memory_cache(&kvm->arch.mmu.split_page_cache);
+
+	kvm->arch.mmu.is_freeing--;
 }
 
 static void stage2_unmap_memslot(struct kvm *kvm,
diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 9118a5a51b89..53a1b9c7bff8 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -66,6 +66,7 @@ TEST_GEN_PROGS_COMMON += kvm_page_table_test
 TEST_GEN_PROGS_COMMON += set_memory_region_test
 TEST_GEN_PROGS_COMMON += memslot_modification_stress_test
 TEST_GEN_PROGS_COMMON += memslot_perf_test
+TEST_GEN_PROGS_COMMON += transfer_fd_test
 
 # Compiled test targets
 TEST_GEN_PROGS_x86 = $(TEST_GEN_PROGS_COMMON)
diff --git a/tools/testing/selftests/kvm/transfer_fd_test.c b/tools/testing/selftests/kvm/transfer_fd_test.c
new file mode 100644
index 000000000000..ff2adff9954b
--- /dev/null
+++ b/tools/testing/selftests/kvm/transfer_fd_test.c
@@ -0,0 +1,129 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Test VM file descriptor transfer via Unix Domain Sockets.
+ */
+#include <sys/socket.h>
+#include <sys/un.h>
+#include <sys/wait.h>
+#include <unistd.h>
+#include <errno.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+
+static void send_fd(int sock, int fd)
+{
+	struct msghdr msg = {0};
+	struct cmsghdr *cmsg;
+	char buf[CMSG_SPACE(sizeof(int))];
+	struct iovec io = {
+		.iov_base = "a",
+		.iov_len = 1,
+	};
+
+	msg.msg_iov = &io;
+	msg.msg_iovlen = 1;
+	msg.msg_control = buf;
+	msg.msg_controllen = sizeof(buf);
+
+	cmsg = CMSG_FIRSTHDR(&msg);
+	cmsg->cmsg_level = SOL_SOCKET;
+	cmsg->cmsg_type = SCM_RIGHTS;
+	cmsg->cmsg_len = CMSG_LEN(sizeof(int));
+
+	*((int *)CMSG_DATA(cmsg)) = fd;
+
+	TEST_ASSERT(sendmsg(sock, &msg, 0) == 1, "sendmsg failed, errno: %d", errno);
+}
+
+static int recv_fd(int sock)
+{
+	struct msghdr msg = {0};
+	struct cmsghdr *cmsg;
+	char buf[CMSG_SPACE(sizeof(int))];
+	char dummy;
+	struct iovec io = {
+		.iov_base = &dummy,
+		.iov_len = 1,
+	};
+	int fd;
+
+	msg.msg_iov = &io;
+	msg.msg_iovlen = 1;
+	msg.msg_control = buf;
+	msg.msg_controllen = sizeof(buf);
+
+	TEST_ASSERT(recvmsg(sock, &msg, 0) == 1, "recvmsg failed, errno: %d", errno);
+
+	cmsg = CMSG_FIRSTHDR(&msg);
+	TEST_ASSERT(cmsg && cmsg->cmsg_level == SOL_SOCKET &&
+		    cmsg->cmsg_type == SCM_RIGHTS, "No FD received");
+
+	fd = *((int *)CMSG_DATA(cmsg));
+	return fd;
+}
+
+int main(int argc, char **argv)
+{
+	pthread_barrierattr_t attr;
+	pthread_barrier_t *barrier;
+	int socks[2];
+	pid_t pid;
+	int ret;
+
+	barrier = mmap(NULL, sizeof(*barrier), PROT_READ | PROT_WRITE,
+		       MAP_SHARED | MAP_ANONYMOUS, -1, 0);
+	TEST_ASSERT(barrier != MAP_FAILED, "mmap failed, errno: %d", errno);
+
+	ret = pthread_barrierattr_init(&attr);
+	TEST_ASSERT(!ret, "pthread_barrierattr_init failed, ret: %d", ret);
+
+	ret = pthread_barrierattr_setpshared(&attr, PTHREAD_PROCESS_SHARED);
+	TEST_ASSERT(!ret, "pthread_barrierattr_setpshared failed, ret: %d", ret);
+
+	ret = pthread_barrier_init(barrier, &attr, 2);
+	TEST_ASSERT(!ret, "pthread_barrier_init failed, ret: %d", ret);
+
+	ret = socketpair(AF_UNIX, SOCK_STREAM, 0, socks);
+	TEST_ASSERT(ret == 0, "socketpair failed, errno: %d", errno);
+
+	pid = fork();
+	TEST_ASSERT(pid >= 0, "fork failed, errno: %d", errno);
+
+	if (pid > 0) {
+		struct kvm_vm *vm;
+
+		close(socks[1]);
+
+		vm = vm_create_barebones();
+
+		send_fd(socks[0], vm->fd);
+		close(socks[0]);
+
+		/* Drop *ALL* refs to this VM. */
+		close(vm->fd);
+		close(vm->kvm_fd);
+		if (vm->stats.fd >= 0)
+			close(vm->stats.fd);
+
+		pthread_barrier_wait(barrier);
+
+		/* Trigger the exit_mm() side of the race. */
+		_exit(0);
+	} else {
+		int vm_fd;
+
+		close(socks[0]);
+
+		vm_fd = recv_fd(socks[1]);
+		close(socks[1]);
+
+		pthread_barrier_wait(barrier);
+
+		/* Drop the final ref of the VM, triggering the kvm_destroy_vm()
+		 * side of the race. */
+		close(vm_fd);
+	}
+
+	return 0;
+}
-- 
2.54.0.545.g6539524ca2-goog

