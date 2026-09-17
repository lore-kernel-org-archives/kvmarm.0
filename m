Received: from mta0.migadu.com (out-116.mta0.migadu.com [91.218.175.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E59C4C33E9
	for <kvmarm@lists.linux.dev>; Thu, 17 Sep 2026 11:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789645572; cv=none; b=LTGEWc0FiYoABKLYweu8CT/D8QY3CPxyGRqlS1j2boeAl3p0o2f2HxwsRJOK/NP0Cr/7dECM5qgTqVaOAlxVd8Bf1yZzES74azAH+2gu0uydNNWJFcBcjy5vxNJugY6nLn8gXVQtxAXzJ2h5oXRa2JIQcra4iUzfECe1ZXwr/S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789645572; c=relaxed/simple;
	bh=/5LbqE2HaIAymwXyigxpXa2Ct6zVBx0/LuQcM40Dhxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qZODJLn0x6tIwihxmQAXCyL/eCy/uGlWP8qauNGmmWkzqulQQ7t8TBb+bWhfeRG1vjX0boatSD5C3HKTjQdkbJvI/LELC72P9C7ZuR/0xsxSg6PwteBSLNja1XPkoENb9fofLZ151JENS9oBxlHoneU8rnzLjGYnt64Hg0VnjvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WHMqLI8M; arc=none smtp.client-ip=91.218.175.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WHMqLI8M"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=/5LbqE2HaIAymwXyigxpXa2Ct6zVBx0/LuQcM40Dhxg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789645559; v=1; x=1790250359;
 b=WHMqLI8M3qe4hnAUG9ubM1OalvIA9Shcvouj895mfhex74LI7W9vTFqKIBy+zIYLcrwwnq2n
 NZThg4dgKkl/I9G/GTIlvjydxVeMbsoEIN4QOe3eZZGGt6yqN+YVII+CAeih/G7ybQaXh3j4Zfr
 uwlmQ9SeYDAl2Slct1dkHF6w=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 63a91e1a8f4e2f13;
	Thu, 17 Sep 2026 11:45:59 +0000
X-Mizu-Trace-ID: 63a91e1a8f4e2f13
X-Migadu-Flow: FLOW_OUT
From: Zenghui Yu <zenghui.yu@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: [PATCH 1/3] KVM: selftests: Fix access_tracking_perf_test for larger host page size
Date: Thu, 17 Sep 2026 19:45:41 +0800
Message-ID: <20260917114543.85044-2-zenghui.yu@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260917114543.85044-1-zenghui.yu@linux.dev>
References: <20260917114543.85044-1-zenghui.yu@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>

access_tracking_perf_test marks guest memory idle through page_idle by
walking its test region one guest page at a time and checking/marking the
host PFN backing each guest page.  The walk assumes that every guest page
maps to a distinct host page, which only holds when the guest page size is
>= the host page size.

On an arm64 host with 64K pages, the test also runs guest modes that use 4K
pages, where 16 consecutive guest pages are backed by one host page.  The
first of them marks the shared host page idle and the other 15 then see the
page as already idle and count it as "still idle", inflating still_idle to
~94% and failing the test:

  $ ./access_tracking_perf_test
  Random seed: 0x1c04f013
  lru_gen: Could not open /sys/kernel/mm/lru_gen/enabled
  Using page_idle for aging
  Testing guest mode: PA-bits:48,  VA-bits:48,  4K pages
  __vm_create: mode='PA-bits:48,  VA-bits:48,  4K pages' type='0', pages='1696'
  guest physical test memory: [0xffffbfff0000, 0xffffffff0000)

  Populating memory             : 0.299047690s
  Writing to populated memory   : 0.008723980s
  Reading from populated memory : 0.010692350s

  ==== Test Assertion Failure ====
    access_tracking_perf_test.c:164: idle_pages_warn_only
    pid=3503998 tid=3504006 errno=4 - Interrupted system call
       1	0x000000000040308f: too_many_idle_pages at access_tracking_perf_test.c:164
       2	 (inlined by) pageidle_mark_vcpu_memory_idle at access_tracking_perf_test.c:229
       3	 (inlined by) vcpu_thread_main at access_tracking_perf_test.c:339
       4	0x000000000040a267: vcpu_thread_main at memstress.c:277
       5	0x00007fff958ef09b: ?? ??:0
       6	0x00007fff959548db: ?? ??:0
    vCPU0: Too many pages still idle (245647 out of 262144)

Idle tracking is fundamentally per host page though.  Walk the region in
units of the larger of the guest and host page size instead.  This changes
nothing when the guest page size is >= the host's - if the guest page is
bigger, the guest only ever faults the first host page of each guest page
anyway.

Assisted-by: GLM-5.3 OpenCode
Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
---
 .../selftests/kvm/access_tracking_perf_test.c    | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
index 4415c94b2866..bcdfeb9c22d8 100644
--- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
+++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
@@ -175,8 +175,8 @@ static void pageidle_mark_vcpu_memory_idle(struct kvm_vm *vm,
 {
 	int vcpu_idx = vcpu_args->vcpu_idx;
 	gva_t base_gva = vcpu_args->gva;
-	u64 pages = vcpu_args->pages;
-	u64 page;
+	u64 idle_page_size;
+	u64 pages, page;
 	u64 still_idle = 0;
 	u64 no_pfn = 0;
 	int page_idle_fd;
@@ -192,8 +192,18 @@ static void pageidle_mark_vcpu_memory_idle(struct kvm_vm *vm,
 	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
 	TEST_ASSERT(pagemap_fd > 0, "Failed to open pagemap.");
 
+	/*
+	 * Idle tracking operates on host pages, so walk the region in units of
+	 * the larger of the guest and host page size.  If the host page is the
+	 * bigger one, several guest pages are backed by one host page and
+	 * checking/marking the same PFN once per guest page would make the
+	 * sanity check below count the shared page as still idle.
+	 */
+	idle_page_size = max_t(u64, memstress_args.guest_page_size, getpagesize());
+	pages = vcpu_args->pages * memstress_args.guest_page_size / idle_page_size;
+
 	for (page = 0; page < pages; page++) {
-		gva_t gva = base_gva + page * memstress_args.guest_page_size;
+		gva_t gva = base_gva + page * idle_page_size;
 		u64 pfn = lookup_pfn(pagemap_fd, vm, gva);
 
 		if (!pfn) {
-- 
2.53.0

