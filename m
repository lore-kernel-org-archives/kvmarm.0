Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.149
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794308854;
	b=vQyZW36V+93vd54VsI21nW0GdGzskDiRXza2lFDnf2UwrXQnXh3/90zuYtRyDGCkm/6s
	 hvApoR1tupyIIJGLEbWNr776mqL9fHjFcGEaj05h1/jcPVt7d2U4HP1LsVw1HP+luGX3N
	 OBokGRDH5BGQBbXCtg0jYd+YQXIiueq9l/gOmg0m73d9D/a623XcivRfjaeRVzO1QqNcI
	 G/4kArJBaDCiMCONzrsHkXEoS6knOZ5GVkEDkeY3fA4GEMEn4LWy7rzpnfGbWdQMc3vcC
	 YxHPr3UhEwRFqzUYjqh/9Jh11hzurcBBB3fVW0N6XnSHc/C4FTnIm8tGIPWhFx60ttg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794308854;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=sDPsGKf/VHOUS0puZRKQwRQtzDRWIoWykff0y+QcUd4=;
	b=dRvfaz0Q969wDYqlORridjcbBG/oCTA64iyIx3ounqRLFSOyYW2yY7bRea4X4yOSFJPA
	 2FmOievyMhs/scGrBhzBHAxHU59BU3jfrEIuWl9vf50amuolRu16CTDiey2+2GJ7M9UAA
	 9qQMGhM957DC30cdYUzHdThU9CjNj0KioQ4T0il+VYp1VO70+Z4n7Ty8mreUAyTTsufpR
	 a8SIAwyUVoCybWwBZJgJzj9edG36Xkq+hhqmh+YFtH4m2aLHN0LnGzD59gNkUNgouAFcK
	 CNgjuC/MKJdhOYzlJveBayXW8y1OD33s+DgCROeVnMoLI7z1CcfiaRSG8COXAFwrDaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=mmnGMscn;
	arc=none smtp.remote-ip=91.218.175.149
Received: from mta0.migadu.com (out-149.mta0.migadu.com [91.218.175.149])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B627606A335
	for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 11:07:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8B627606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=mmnGMscn
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=wriFOBuWpa9rzFZvu7jWs3HxgvPj7gVRqFrspNzYI9Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794308851; v=1; x=1794913651;
 b=mmnGMscnQKYXdSc+pcqmcMmSIPqWkCGejIFXNdogntlH3pO7Z595rnGNcCftoy2+aVnpyM97
 4UGHpbPYUOUUry2ZPqnmwJnGBEsG1MQgAhfvAWjWAPw+J7VPaB5YDWK3znxZ26Q0bMYb5mUAaP1
 J+hskfdxFzlwvU7WqAZKE1Yw=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 084a61cce26cb8b6;
	Tue, 10 Nov 2026 11:07:31 +0000
X-Mizu-Trace-ID: 084a61cce26cb8b6
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
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	kvmarm@lists.linux.dev,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH 2/2] KVM: selftests: Test KVM_PRE_FAULT_MEMORY against a full dirty ring
Date: Tue, 10 Nov 2026 11:07:24 +0000
Message-ID: <20261110110724.3614412-3-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261110110724.3614412-1-fuad.tabba@linux.dev>
References: <20261110110724.3614412-1-fuad.tabba@linux.dev>
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
retry returns ENOSPC without progress, and that the harvested entries
are the pages in order. A read pre-fault can map a page read-only, or
access-tracked on x86 without EPT A/D bits, so skip the case if
pre-faulting dirties nothing.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 .../selftests/kvm/pre_fault_memory_test.c     | 85 +++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/tools/testing/selftests/kvm/pre_fault_memory_test.c b/tools/testing/selftests/kvm/pre_fault_memory_test.c
index 3082fe09b95fa..18fc1d69acbf0 100644
--- a/tools/testing/selftests/kvm/pre_fault_memory_test.c
+++ b/tools/testing/selftests/kvm/pre_fault_memory_test.c
@@ -5,6 +5,7 @@
  * Author:
  * Isaku Yamahata <isaku.yamahata at gmail.com>
  */
+#include <asm/barrier.h>
 #include <linux/sizes.h>
 
 #include <test_util.h>
@@ -17,6 +18,8 @@
 /* Arbitrarily chosen values */
 #define TEST_BASE_SIZE		SZ_2M
 #define TEST_SLOT		10
+/* Large enough for the entries every architecture reserves. */
+#define TEST_RING_SIZE		SZ_64K
 
 /* Storage of test info to share with guest code */
 struct test_config {
@@ -281,6 +284,87 @@ static void test_pre_fault_memory(unsigned long vm_type, enum vm_mem_backing_src
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
+	u64 harvested = 0, n, size;
+	struct kvm_vcpu *vcpu;
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
+	size = npages * vm->page_size;
+	gpa = align_down(vm->max_gfn * vm->page_size - size, SZ_2M);
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, gpa, TEST_SLOT, npages,
+				    KVM_MEM_LOG_DIRTY_PAGES);
+
+	/* Populate the pages, so that pre-faulting can map them writable. */
+	memset(addr_gpa2hva(vm, gpa), 1, size);
+
+	range = (struct kvm_pre_fault_memory) { .gpa = gpa, .size = size };
+	while (range.size) {
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
+			if (smp_load_acquire(&cur->flags) != KVM_DIRTY_GFN_F_DIRTY)
+				break;
+
+			TEST_ASSERT(cur->slot == TEST_SLOT && cur->offset == harvested + n,
+				    "Ring entry %u: slot %u offset 0x%llx, expected slot %u offset 0x%lx",
+				    fetch, cur->slot, cur->offset, TEST_SLOT, harvested + n);
+			smp_store_release(&cur->flags, KVM_DIRTY_GFN_F_RESET);
+			fetch++;
+		}
+
+		/* A read pre-fault can map a page read-only, or access-tracked on x86. */
+		if (!n && !harvested && !range.size) {
+			pr_info("Skipping the dirty ring test: pre-faulting dirtied no pages\n");
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
+	kvm_vm_free(vm);
+}
+
 static void help(char *name)
 {
 	puts("");
@@ -320,5 +404,6 @@ int main(int argc, char *argv[])
 	test_pre_fault_memory(KVM_X86_SW_PROTECTED_VM, backing, false);
 	test_pre_fault_memory(KVM_X86_SW_PROTECTED_VM, backing, true);
 #endif
+	test_pre_fault_dirty_ring();
 	return 0;
 }
-- 
2.47.3

