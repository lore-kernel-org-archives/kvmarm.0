Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07CA3321B9
	for <kvmarm@lists.linux.dev>; Thu, 16 Oct 2025 17:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760635830; cv=none; b=kfwuVSkiaH65hO/HFyErZI/VMC3HWQ1SJm++FS6J5g2n9CXK9zsGLnyiS8i7vdfc5vYfp1t7qr7VG5JDEOV+HsOsdHM/W2IY7bZm5hQbkjDCQTe8ivu0Kq8htspnODNaN4mrDgWkfvfNCo6pnkamIqNoZ9U4UC13VIG39xXnUUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760635830; c=relaxed/simple;
	bh=C2oacOVaYmakYuuj01sv0kUdLX8KmQYOY8HvA7F3pWg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pcMRjbdo12WF5jj0Ec/u8g2YhFlkDPP1TEJO3m9Z+DgO/WsfUT0bnkST7r68/k5SHtoX2qYm8SHgVhpp5hp2Ek+IPh6Dp2HyRb5WztF2jGtar1k/KraIUCAHzCnzSdTFxm7xvGP8XVWMaIXz0H0Vythou8AE9DQEa0M4A+zMKEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Gi8JvsnI; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Gi8JvsnI"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-290bd7c835dso6032235ad.3
        for <kvmarm@lists.linux.dev>; Thu, 16 Oct 2025 10:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760635828; x=1761240628; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=RviFSJTeDXrAnxp03nizg0uEL1EB4BJAqQICQBGlk4U=;
        b=Gi8JvsnIUlthnNlV+qHn24UToYtBVPom/d/vuuGh83S7556C5cq1NRr/RqC9Bh2Y7Y
         kLkvPJB+CD8ATBLrLgnQssm1MflkDDl+8VqzAXSNBURIr7YPD9iDkKjUStyTp3Pepce3
         Qymanh2i1PkXJbisxRBJcbKPVC8Lvc48uFB3U7U3EyPNoKLfsLr03iBQsKxzLhDqcZs2
         /HWWiDUADnU+JojknS1RgZe1OwKNMqNOPs++Jq3HdqxCKOlbppIpZxWcsVTfNEJGpZ+2
         /geFFWjGTM0x9HwHKqZDbG2gouhB/+LrqDgwx5F1PLYnKBJPvd9UIw5iVSZQeMKMFAMd
         BeRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760635828; x=1761240628;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RviFSJTeDXrAnxp03nizg0uEL1EB4BJAqQICQBGlk4U=;
        b=D9uw9CFkXh7NZyyypAYy6i4F97Q5ATFroXKZ+3lf9DmeKpcBKkuy+Nq+fTWQ3l3y8/
         ku79xUcu3yplXtHBAlVFpeysXM5XOnHXttR6MArgj63H+ZuPRnYy7u2e9+zjodUZwEas
         YIBoSd+DhdQ/qh0ZScHkeZNNUkmkGd/izuFj3tS/huX+/W2cThBGNgGXRWmRQ2MoGOAi
         tCheBh9xzJDel1eYef1odaKCiTGmgfjIOCy3inOCoR/bZYXZ+ss4ngVmu2wmUyHCZFiT
         BptbfvbJrdYCLizdk3PfptwxyFBk07tllq1H07/BSVrgzVsVoBiWPgDFr71nsGCYTIK4
         KnTg==
X-Forwarded-Encrypted: i=1; AJvYcCXYSznjJkPfgVzEWSWWm6uu0Zkq8Oh0aybRafgru/jaXtq5n+NbpBL+QGdaZtulZd/FWPcKXkw=@lists.linux.dev
X-Gm-Message-State: AOJu0YwC7CR6An9kIEaAbgyfUFlWubU2+CW708LBR4b+d+BM1qRIQbUr
	QUW+7LqjtPibBrwCTzeALZivtQvX7RQqgHcPPeyXTeooak+ucyiJEoYCBNUG0HBVVUwPu/ESrxn
	Y1xvWiQ==
X-Google-Smtp-Source: AGHT+IF/2wryDBFn3Vm/ZItHrOO8Cutyh10iJkyo92xaEeL3XVP9OxJeQvoekCLXXPfR84HIRIYnmu6+FJY=
X-Received: from plsq3.prod.google.com ([2002:a17:902:bd83:b0:27e:ec80:30c6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:b8b:b0:24c:ed95:2725
 with SMTP id d9443c01a7336-290c9c89badmr7138805ad.4.1760635828021; Thu, 16
 Oct 2025 10:30:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Oct 2025 10:28:52 -0700
In-Reply-To: <20251016172853.52451-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251016172853.52451-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251016172853.52451-12-seanjc@google.com>
Subject: [PATCH v13 11/12] KVM: selftests: Add guest_memfd tests for mmap and
 NUMA policy support
From: Sean Christopherson <seanjc@google.com>
To: Miguel Ojeda <ojeda@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ackerley Tng <ackerleytng@google.com>, Shivank Garg <shivankg@amd.com>, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"

From: Shivank Garg <shivankg@amd.com>

Add tests for NUMA memory policy binding and NUMA aware allocation in
guest_memfd. This extends the existing selftests by adding proper
validation for:
  - KVM GMEM set_policy and get_policy() vm_ops functionality using
    mbind() and get_mempolicy()
  - NUMA policy application before and after memory allocation

Run the NUMA mbind() test with and without INIT_SHARED, as KVM should allow
doing mbind(), madvise(), etc. on guest-private memory, e.g. so that
userspace can set NUMA policy for CoCo VMs.

Run the NUMA allocation test only for INIT_SHARED, i.e. if the host can't
fault-in memory (via direct access, madvise(), etc.) as move_pages()
returns -ENOENT if the page hasn't been faulted in (walks the host page
tables to find the associated folio)

[sean: don't skip entire test when running on non-NUMA system, test mbind()
       with private memory, provide more info in assert messages]

Signed-off-by: Shivank Garg <shivankg@amd.com>
Tested-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/guest_memfd_test.c  | 98 +++++++++++++++++++
 1 file changed, 98 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index e7d9aeb418d3..618c937f3c90 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -19,6 +19,7 @@
 #include <sys/stat.h>
 
 #include "kvm_util.h"
+#include "numaif.h"
 #include "test_util.h"
 #include "ucall_common.h"
 
@@ -75,6 +76,101 @@ static void test_mmap_supported(int fd, size_t total_size)
 	kvm_munmap(mem, total_size);
 }
 
+static void test_mbind(int fd, size_t total_size)
+{
+	const unsigned long nodemask_0 = 1; /* nid: 0 */
+	unsigned long nodemask = 0;
+	unsigned long maxnode = 8;
+	int policy;
+	char *mem;
+	int ret;
+
+	if (!is_multi_numa_node_system())
+		return;
+
+	mem = kvm_mmap(total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd);
+
+	/* Test MPOL_INTERLEAVE policy */
+	kvm_mbind(mem, page_size * 2, MPOL_INTERLEAVE, &nodemask_0, maxnode, 0);
+	kvm_get_mempolicy(&policy, &nodemask, maxnode, mem, MPOL_F_ADDR);
+	TEST_ASSERT(policy == MPOL_INTERLEAVE && nodemask == nodemask_0,
+		    "Wanted MPOL_INTERLEAVE (%u) and nodemask 0x%lx, got %u and 0x%lx",
+		    MPOL_INTERLEAVE, nodemask_0, policy, nodemask);
+
+	/* Test basic MPOL_BIND policy */
+	kvm_mbind(mem + page_size * 2, page_size * 2, MPOL_BIND, &nodemask_0, maxnode, 0);
+	kvm_get_mempolicy(&policy, &nodemask, maxnode, mem + page_size * 2, MPOL_F_ADDR);
+	TEST_ASSERT(policy == MPOL_BIND && nodemask == nodemask_0,
+		    "Wanted MPOL_BIND (%u) and nodemask 0x%lx, got %u and 0x%lx",
+		    MPOL_BIND, nodemask_0, policy, nodemask);
+
+	/* Test MPOL_DEFAULT policy */
+	kvm_mbind(mem, total_size, MPOL_DEFAULT, NULL, 0, 0);
+	kvm_get_mempolicy(&policy, &nodemask, maxnode, mem, MPOL_F_ADDR);
+	TEST_ASSERT(policy == MPOL_DEFAULT && !nodemask,
+		    "Wanted MPOL_DEFAULT (%u) and nodemask 0x0, got %u and 0x%lx",
+		    MPOL_DEFAULT, policy, nodemask);
+
+	/* Test with invalid policy */
+	ret = mbind(mem, page_size, 999, &nodemask_0, maxnode, 0);
+	TEST_ASSERT(ret == -1 && errno == EINVAL,
+		    "mbind with invalid policy should fail with EINVAL");
+
+	kvm_munmap(mem, total_size);
+}
+
+static void test_numa_allocation(int fd, size_t total_size)
+{
+	unsigned long node0_mask = 1;  /* Node 0 */
+	unsigned long node1_mask = 2;  /* Node 1 */
+	unsigned long maxnode = 8;
+	void *pages[4];
+	int status[4];
+	char *mem;
+	int i;
+
+	if (!is_multi_numa_node_system())
+		return;
+
+	mem = kvm_mmap(total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd);
+
+	for (i = 0; i < 4; i++)
+		pages[i] = (char *)mem + page_size * i;
+
+	/* Set NUMA policy after allocation */
+	memset(mem, 0xaa, page_size);
+	kvm_mbind(pages[0], page_size, MPOL_BIND, &node0_mask, maxnode, 0);
+	kvm_fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE, 0, page_size);
+
+	/* Set NUMA policy before allocation */
+	kvm_mbind(pages[0], page_size * 2, MPOL_BIND, &node1_mask, maxnode, 0);
+	kvm_mbind(pages[2], page_size * 2, MPOL_BIND, &node0_mask, maxnode, 0);
+	memset(mem, 0xaa, total_size);
+
+	/* Validate if pages are allocated on specified NUMA nodes */
+	kvm_move_pages(0, 4, pages, NULL, status, 0);
+	TEST_ASSERT(status[0] == 1, "Expected page 0 on node 1, got it on node %d", status[0]);
+	TEST_ASSERT(status[1] == 1, "Expected page 1 on node 1, got it on node %d", status[1]);
+	TEST_ASSERT(status[2] == 0, "Expected page 2 on node 0, got it on node %d", status[2]);
+	TEST_ASSERT(status[3] == 0, "Expected page 3 on node 0, got it on node %d", status[3]);
+
+	/* Punch hole for all pages */
+	kvm_fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE, 0, total_size);
+
+	/* Change NUMA policy nodes and reallocate */
+	kvm_mbind(pages[0], page_size * 2, MPOL_BIND, &node0_mask, maxnode, 0);
+	kvm_mbind(pages[2], page_size * 2, MPOL_BIND, &node1_mask, maxnode, 0);
+	memset(mem, 0xaa, total_size);
+
+	kvm_move_pages(0, 4, pages, NULL, status, 0);
+	TEST_ASSERT(status[0] == 0, "Expected page 0 on node 0, got it on node %d", status[0]);
+	TEST_ASSERT(status[1] == 0, "Expected page 1 on node 0, got it on node %d", status[1]);
+	TEST_ASSERT(status[2] == 1, "Expected page 2 on node 1, got it on node %d", status[2]);
+	TEST_ASSERT(status[3] == 1, "Expected page 3 on node 1, got it on node %d", status[3]);
+
+	kvm_munmap(mem, total_size);
+}
+
 static void test_fault_sigbus(int fd, size_t accessible_size, size_t map_size)
 {
 	const char val = 0xaa;
@@ -273,11 +369,13 @@ static void __test_guest_memfd(struct kvm_vm *vm, uint64_t flags)
 		if (flags & GUEST_MEMFD_FLAG_INIT_SHARED) {
 			gmem_test(mmap_supported, vm, flags);
 			gmem_test(fault_overflow, vm, flags);
+			gmem_test(numa_allocation, vm, flags);
 		} else {
 			gmem_test(fault_private, vm, flags);
 		}
 
 		gmem_test(mmap_cow, vm, flags);
+		gmem_test(mbind, vm, flags);
 	} else {
 		gmem_test(mmap_not_supported, vm, flags);
 	}
-- 
2.51.0.858.gf9c4a03a3a-goog

