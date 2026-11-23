Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.96
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795433687;
	b=f0lI9jzI/0LH0qSsR0aG0QmRj1G5YuKKKRYVVEli3wf5RaTC+9ck08gEwx1Y7ltWhIaY
	 /MlX1LWAyFf/0H4xsKD3E3cJTmrE3IH4euRBptfOmnaUgnkNIsROUWv1y/KQKtCn86ttA
	 hj8DewBzKp1zUGGdez6iQLF/nJ4OtaNANKrt7Gs16gWaF7AC21NNiBq6EfeRzMCe/wJF/
	 BTqn+xqEfs+/uao9wjD4pq6KUoFQCUQghdE3kTm57su6fuJs6/hEVSp721PJ+lfqnnToA
	 0bVkEgQZCahUm/TvzvUr9kdEZJGviwsZ3WKrDfUUZqG14s0fZ3wRN8R8kZmXG550JdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795433687;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=bMz7/jSXhqQhfLT4KH3Ealv1YuY1uybQCMthgj13rQ4=;
	b=T4+fcYS2eBXz9CXTYo1jqc4Ett2/4mORTwSdVGH8ZSgwj82umMxy05K7DznUBmZbQtth
	 y61twq4Qimu6nYl0UJVehB3peSUMbZL/OKLLQ8DOWL43vJjFQ9aFG1ob2SL1xdSUhn7Yn
	 n57pgQpuumQ7jeVjSlAUrO1CvecS3qViNYoOGQ5yv+5SIQwav/AIYYVEYbAZppFUynaX2
	 Y5j6YOMJlHb1lM6eua6F6QHD4XVwyFJelF0WktUGU6yhr2pf8flE2lHVg8J1b4jrQcjrH
	 oSzNZNQ0JBXdCHrgbBIPKyV16082yNsVtcfQKltvBwVmqSot57iBMzTy3SZCThgjcPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=HmM7dPtl;
	arc=none smtp.remote-ip=91.218.175.96
Received: from mta0.migadu.com (out-96.mta0.migadu.com [91.218.175.96])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D812606A6A6
	for <kvmarm@lists.linux.dev>; Mon, 23 Nov 2026 11:34:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7D812606A6A6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=HmM7dPtl
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=EPW/4inQmR/B22tfOmCqn6geEFgZqhCdt8pVKIKyvII=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795433684; v=1; x=1796038484;
 b=HmM7dPtl//4p4qksXpogGW9SZcW41Negddb0PFi8WLMmtcFq4HC1T2Vyg0aMNAI5JH7zSmSp
 aK1sDLdFz40iuSiEbM8rncDmtJsdmljL3Z01XfYdm8j4a6nKd7DxhIKJOhF4g29j8WTW+9+dNxL
 +HGN0/sGQdT8ccKqO0D0oPHo=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 7d064e68e568c241;
	Mon, 23 Nov 2026 11:34:44 +0000
X-Mizu-Trace-ID: 7d064e68e568c241
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atish.patra@linux.dev>,
	kvm-riscv@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v3 3/3] KVM: selftests: Test KVM_PRE_FAULT_MEMORY against a full dirty ring
Date: Mon, 23 Nov 2026 11:34:35 +0000
Message-ID: <20261123113435.1170711-4-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261123113435.1170711-1-fuad.tabba@linux.dev>
References: <20261123113435.1170711-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Pre-fault more populated, dirty-logged pages than the vCPU's dirty ring
holds, and check that each call stops before the ring overflows, that a
retry returns ENOSPC without progress, and that each page is reported
exactly once. A read pre-fault can map a page read-only, or
access-tracked on x86 without EPT A/D bits, so skip the case if
pre-faulting doesn't dirty any page.

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 .../selftests/kvm/pre_fault_memory_test.c     | 102 ++++++++++++++++++
 1 file changed, 102 insertions(+)

diff --git a/tools/testing/selftests/kvm/pre_fault_memory_test.c b/tools/testing/selftests/kvm/pre_fault_memory_test.c
index 3082fe09b95fa..9588781fc5401 100644
--- a/tools/testing/selftests/kvm/pre_fault_memory_test.c
+++ b/tools/testing/selftests/kvm/pre_fault_memory_test.c
@@ -5,6 +5,9 @@
  * Author:
  * Isaku Yamahata <isaku.yamahata at gmail.com>
  */
+#include <asm/barrier.h>
+#include <linux/bitmap.h>
+#include <linux/bitops.h>
 #include <linux/sizes.h>
 
 #include <test_util.h>
@@ -17,6 +20,8 @@
 /* Arbitrarily chosen values */
 #define TEST_BASE_SIZE		SZ_2M
 #define TEST_SLOT		10
+/* Large enough for the entries every architecture reserves. */
+#define TEST_RING_SIZE		SZ_64K
 
 /* Storage of test info to share with guest code */
 struct test_config {
@@ -281,6 +286,102 @@ static void test_pre_fault_memory(unsigned long vm_type, enum vm_mem_backing_src
 	for_each_guest_mode(__test_pre_fault_memory, &p);
 }
 
+/*
+ * Pre-fault more dirty-logged pages than the ring holds: each call has to stop
+ * before the ring overflows, and no entry may be lost.
+ */
+static void test_pre_fault_dirty_ring(void)
+{
+	const u64 entries = TEST_RING_SIZE / sizeof(struct kvm_dirty_gfn);
+	const u64 npages = entries + entries / 4;
+	struct kvm_pre_fault_memory range, left;
+	struct kvm_dirty_gfn *gfns, *cur;
+	u64 harvested = 0, size;
+	struct kvm_vcpu *vcpu;
+	unsigned long *seen;
+	int ret, stops = 0;
+	struct kvm_vm *vm;
+	u32 fetch = 0;
+	gpa_t gpa;
+
+	if (!kvm_has_cap(KVM_CAP_DIRTY_LOG_RING) && !kvm_has_cap(KVM_CAP_DIRTY_LOG_RING_ACQ_REL)) {
+		pr_info("Skipping the dirty ring test: no dirty ring\n");
+		return;
+	}
+
+	vm = vm_create(1);
+	vm_enable_dirty_ring(vm, TEST_RING_SIZE);
+	vcpu = vm_vcpu_add(vm, 0, NULL);
+	gfns = vcpu_map_dirty_ring(vcpu);
+
+	/* A ring entry is a host page. */
+	size = npages * getpagesize();
+	gpa = align_down(vm->max_gfn * vm->page_size - size, SZ_2M);
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, gpa, TEST_SLOT,
+				    vm_calc_num_guest_pages(vm->mode, size),
+				    KVM_MEM_LOG_DIRTY_PAGES);
+
+	/* Populate the pages, so that pre-faulting can map them writable. */
+	memset(addr_gpa2hva(vm, gpa), 1, size);
+
+	seen = bitmap_zalloc(npages);
+	TEST_ASSERT(seen, "Failed to allocate the bitmap of reported pages");
+
+	range = (struct kvm_pre_fault_memory) { .gpa = gpa, .size = size };
+	while (range.size) {
+		u64 n;
+
+		vcpu_ioctl(vcpu, KVM_PRE_FAULT_MEMORY, &range);
+
+		if (range.size) {
+			left = range;
+			ret = __vcpu_ioctl(vcpu, KVM_PRE_FAULT_MEMORY, &range);
+			TEST_ASSERT_VM_VCPU_IOCTL(ret == -1 && errno == ENOSPC,
+						  KVM_PRE_FAULT_MEMORY, ret, vm);
+			TEST_ASSERT(range.gpa == left.gpa && range.size == left.size,
+				    "KVM_PRE_FAULT_MEMORY made progress on a full ring");
+			stops++;
+		}
+
+		for (n = 0; ; n++) {
+			cur = &gfns[fetch % entries];
+			/* Pairs with the smp_wmb() in kvm_dirty_ring_push(). */
+			if (smp_load_acquire(&cur->flags) != KVM_DIRTY_GFN_F_DIRTY)
+				break;
+
+			TEST_ASSERT(cur->slot == TEST_SLOT && cur->offset < npages,
+				    "Ring entry %u: slot %u offset 0x%llx, expected slot %u offset < 0x%lx",
+				    fetch, cur->slot, cur->offset, TEST_SLOT, npages);
+			TEST_ASSERT(!__test_and_set_bit(cur->offset, seen),
+				    "Ring entry %u: offset 0x%llx reported twice",
+				    fetch, cur->offset);
+			/* Pairs with kvm_dirty_gfn_harvested()'s smp_load_acquire(). */
+			smp_store_release(&cur->flags, KVM_DIRTY_GFN_F_RESET);
+			fetch++;
+		}
+
+		/* A read pre-fault can map a page read-only, or access-tracked on x86. */
+		if (!n && !harvested && !range.size) {
+			pr_info("Skipping the dirty ring test: pre-faulting dirtied no pages\n");
+			bitmap_free(seen);
+			kvm_vm_free(vm);
+			return;
+		}
+		TEST_ASSERT(n, "KVM_PRE_FAULT_MEMORY pushed nothing to the ring");
+		TEST_ASSERT(kvm_vm_reset_dirty_ring(vm) == n,
+			    "KVM_RESET_DIRTY_RINGS didn't reset %lu entries", n);
+		harvested += n;
+	}
+
+	TEST_ASSERT(harvested == npages, "%lu ring entries for %lu pages", harvested, npages);
+	TEST_ASSERT(stops, "KVM_PRE_FAULT_MEMORY never stopped for a %lu-entry ring", entries);
+	pr_info("Pre-faulted %lu pages through a %lu-entry ring, stopping %d times\n",
+		npages, entries, stops);
+
+	bitmap_free(seen);
+	kvm_vm_free(vm);
+}
+
 static void help(char *name)
 {
 	puts("");
@@ -320,5 +421,6 @@ int main(int argc, char *argv[])
 	test_pre_fault_memory(KVM_X86_SW_PROTECTED_VM, backing, false);
 	test_pre_fault_memory(KVM_X86_SW_PROTECTED_VM, backing, true);
 #endif
+	test_pre_fault_dirty_ring();
 	return 0;
 }
-- 
2.47.3

