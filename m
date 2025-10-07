Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE8D274FD3
	for <kvmarm@lists.linux.dev>; Tue,  7 Oct 2025 22:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759875300; cv=none; b=ld2xz/O6kY0EVxld1Q6zjF9OIWj4PEKxrhVd0/YhjQmCxr8ooCiEsiZFRiCf79Gf+Pheh7albmHFmaCPb8epaOHMSJbFqI+BnmTi9dS9mZxvycOSYyZ+GRTm9wxzb2d+GvMrU9mdaFKK7+pBgU1eWO2pKoHjLaiSls+3CRviQ3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759875300; c=relaxed/simple;
	bh=CDrOrMNO9l5cLoWd98CveZ7KTkfm+YOe4TpGJ/Wt4fA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=k8rEczzdMB24qQPYkljiH+frD6fV3O6pc0vIkSnscV9jspSeyBWMCHMiGd8SNMyhDBFRskmgqN6WL9/tEwGpKoOWtrMzRq5PXpRyyX745zZ5Yp7wtnwbaXDK84Asz76s9kugligp2at7pn3TBGJqn9S7iUrWnZCeCkHnYtgBvMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pi7QSRoF; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pi7QSRoF"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32ec69d22b2so6323501a91.1
        for <kvmarm@lists.linux.dev>; Tue, 07 Oct 2025 15:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759875296; x=1760480096; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=pq3jKNyKi/1WXgeEr4Kt/LxPicRmmT3+M3Z6Wud5iC8=;
        b=pi7QSRoFfP1LhRLkeHjIVEYiFR6pvctBRL/yzkL2SyyPSMoFajejUPcoem1qZ+y9K3
         O/Mk7o3dXcbZW+ZR2deGaEG0ouqCESwwv2UMVeAWM04CarDg9VxvqVnTrg2bR8vcqwti
         XIwOyB07ZQTg4fHJBrq/F2WDVTDrQ1XGLjWD5PCcKIMgm2PLuynVQUTSz9q5QkbFad8m
         wOQj3hK80j2/d73YQ85jyU0pPuDLW+NgJX//nuR2gIOQSa2awlmlJocMpSgy6zKAV2ZW
         rpe/K5i1oKpGbX01YbMr+VgQeBDGFcbTUmLLeDlv9IFKoAwXK5O+b+XzAYAy60YkXLwU
         18/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759875296; x=1760480096;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pq3jKNyKi/1WXgeEr4Kt/LxPicRmmT3+M3Z6Wud5iC8=;
        b=u6FNDfjo95Tk+bhmpSsRGCDjToAMsuTVHKaby8Wc9sV7gL3lM2Nz+uPWTxc/o/plv5
         DpAUpYTEAxNXntxadgu59/jL62zQYBh4Q2hRRjOOG2PyacEkeii5D5jXdpgN02du5DhJ
         mxygz5t5E5pHDCKlMn6CfS4BmWOyIUT6a0ZJ1jeAzgeMSQMwHwl8q/NgmStFUwe6/y4u
         UB8R7K2F6+3BMAFFET/8nkRqmSZSN94QIJqs9sl5qwRutfIa7YvjrFSAAapRT5QUjUFs
         h0C2wM8Na2D8RIP+YGPDhVNjHt8Y9r2XlPeKTDHkmGcu68iN1IBDTtJbKx/yr1Te40GL
         LOiQ==
X-Forwarded-Encrypted: i=1; AJvYcCVeG/Yb9avVr/bu3d2i3kAoqrgwA9v0QhEDtsRad5cZ03MnVCazhJuHH6xO7xZs5SEqYf7FUrA=@lists.linux.dev
X-Gm-Message-State: AOJu0YyVcws37HR0Z0PidzPDCzgBVN0Lw+sxH31tVunwim6I5lzEaBdS
	6+BONR6KVVqJrdQWGHwnAlqBtGNJS/NLR4gU5bOXRtgtN7n7jyyFCHkTzUEIDP2PWiayg7eQ761
	8gXg0NQ==
X-Google-Smtp-Source: AGHT+IFr1z+OHs2pqkHxNhtbO8xQGrGNQletDRxpDZROHoK8rGfdZgYkQaGuDGapxPz1ninSCtdpRZhLQBs=
X-Received: from pjbmw12.prod.google.com ([2002:a17:90b:4d0c:b0:329:b272:45a7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1b4c:b0:327:9e88:7714
 with SMTP id 98e67ed59e1d1-33b513ebf89mr1315059a91.37.1759875296568; Tue, 07
 Oct 2025 15:14:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  7 Oct 2025 15:14:19 -0700
In-Reply-To: <20251007221420.344669-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251007221420.344669-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251007221420.344669-12-seanjc@google.com>
Subject: [PATCH v12 11/12] KVM: selftests: Add guest_memfd tests for mmap and
 NUMA policy support
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Vlastimil Babka <vbabka@suse.cz>
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

Signed-off-by: Shivank Garg <shivankg@amd.com>
Tested-by: Ashish Kalra <ashish.kalra@amd.com>
[sean: don't skip entire test when running on non-NUMA system, test mbind()
       with private memory, provide more info in assert messages]
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
2.51.0.710.ga91ca5db03-goog

