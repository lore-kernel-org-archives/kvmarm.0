Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E723D331D
	for <kvmarm@lists.linux.dev>; Mon, 20 Apr 2026 21:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776720044; cv=none; b=dSpO85cvULXHR2JXgxWn4VLd+XHILPZkRNX9dXdCf9PFVbMZ4MOeRc1LtTnbIwA7L8CipAScvWJdixhnZvYc9Ov39LvW4YOw/zyE0AS47LqdZDjOxZGhXo+YhzCRwtZZ4t5zhupqwVU6lgJ/+JHPFLYR/mHh9Ow6GEZss/zZRcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776720044; c=relaxed/simple;
	bh=Z01xZwsZZkRYQMo6Za/XKWe+YwHyZ1LyWyYZzSbElJQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kxaedTLkAv94Gz3/jhSHD9VBvH6QfYuQ1WL9qUrY2xvAj6+i0EQGFaGhxcRFhIzM/bzWPC+ZYX2LE9FlzrbVItGX+6St0mLU7uA1Bwzl6SFeBGWk4SvTbRKwyT/MIi5eXNR52R/HFh5S0fMt+WW/LDRV+5hdcTuxPzwv2zSJHjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YvXgG3Jk; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YvXgG3Jk"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-82fa2165c3eso1591073b3a.0
        for <kvmarm@lists.linux.dev>; Mon, 20 Apr 2026 14:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776720041; x=1777324841; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Rpd6vMcLqXnLIzoMZjZBJw63vKplluuAVwdNOopWl7o=;
        b=YvXgG3JkMrnN0C6FSLKuqDxxnlTnH2xvQZbwVtQBKQr/rX7u8XEzO7j+tvhhfRoz2j
         xMI2KUk3DsENNUXXCFyGn2qganALcxWOrvPseTcFeIsDApJSngkfl4SoRtppr4eCc6KZ
         kwtXqI7oAdMwHFWfbule62AB0YpoLF0ULYB3VRJBjKf84t5a3wVswhfnHTyNdQM2pbpg
         12Pl1k8ermVu7a9Ph07Y1rlEaZp//7ZFFwPP9g6sMou6QTbF9cS294fG/f3R/PZBDfu+
         lNIrB5TRJCX/y8ZvuoJZ0qlycP3ERXQjkFRI6OVHejvTDpHVukdHq/S5UByC61XgiPKi
         asCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776720041; x=1777324841;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Rpd6vMcLqXnLIzoMZjZBJw63vKplluuAVwdNOopWl7o=;
        b=hKDTaMRpmidskpHzPYk61Jpq/IHFeIFUZ/OMyMVFOSDLHfBLqCbFr7IKKkc8vLhdy4
         BrmRT6RhNzf/QihF85YMW1iUng0zCrv5X0zUPURVNiplAGqH7aBHNx0y3fJs0xJcu6YM
         g6ThCKzR3v+QaeT5WYhG6m1XuTJOfX8Wn1wTLxwrMEf8NYHd1T684A0S2lRphxi/KgUz
         IbLgezpzbUkpxa36F/oIQ9b9qsDDDu8Y3utYttSJcv7mXvsHqeDd9Nj74flUFWUkHL/t
         9njuLjfNONfFho/Vrd+gweTyffUyw1JgRwQDiac849XrpgJfMLJukdlXxSC1eN3TnwTw
         B2dQ==
X-Forwarded-Encrypted: i=1; AFNElJ+g8HH5pAheZTTr2+eyiN5E/Z2rOsVPS4U3bFn33HkyhaSzJOfos4+3ubL3PvKrPzXbYUDdhno=@lists.linux.dev
X-Gm-Message-State: AOJu0YwgVnuSXx5Kpq9aMdc0M1IXju34y8i6pR6mq+0p984kjnhPNAsG
	Uhr2fRGaRomQwxd3R4AKpya7mrv1AgIPFjLZjbEks+ZoCwU/7f6KkHZH9kPA/j9ECAwCCy5V0il
	nxORycw==
X-Received: from pffv19.prod.google.com ([2002:aa7:8093:0:b0:82f:5d4f:734f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4f87:b0:82f:8698:101
 with SMTP id d2e1a72fcca58-82f8c9bbeb9mr15967277b3a.44.1776720040495; Mon, 20
 Apr 2026 14:20:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 20 Apr 2026 14:20:02 -0700
In-Reply-To: <20260420212004.3938325-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260420212004.3938325-1-seanjc@google.com>
X-Mailer: git-send-email 2.54.0.rc1.555.g9c883467ad-goog
Message-ID: <20260420212004.3938325-18-seanjc@google.com>
Subject: [PATCH v3 17/19] KVM: selftests: Replace "u64 gpa" with "gpa_t" throughout
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Use gpa_t instead of u64 for obvious declarations of GPA variables.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/guest_memfd_test.c  |  2 +-
 .../testing/selftests/kvm/include/kvm_util.h  | 26 +++++++++----------
 .../testing/selftests/kvm/include/memstress.h |  4 +--
 .../selftests/kvm/include/x86/processor.h     |  4 +--
 tools/testing/selftests/kvm/lib/kvm_util.c    | 14 +++++-----
 .../selftests/kvm/lib/s390/processor.c        |  2 +-
 .../kvm/memslot_modification_stress_test.c    |  2 +-
 .../testing/selftests/kvm/memslot_perf_test.c | 10 +++----
 tools/testing/selftests/kvm/mmu_stress_test.c |  4 +--
 .../selftests/kvm/pre_fault_memory_test.c     |  4 +--
 .../selftests/kvm/s390/ucontrol_test.c        |  2 +-
 .../selftests/kvm/set_memory_region_test.c    |  2 +-
 .../kvm/x86/private_mem_conversions_test.c    | 24 ++++++++---------
 .../x86/smaller_maxphyaddr_emulation_test.c   |  2 +-
 .../selftests/kvm/x86/svm_nested_vmcb12_gpa.c |  8 +++---
 15 files changed, 55 insertions(+), 55 deletions(-)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 9cbd3ad7f44a..d6528c6f5e03 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -489,7 +489,7 @@ static void test_guest_memfd_guest(void)
 	 * the guest's code, stack, and page tables, and low memory contains
 	 * the PCI hole and other MMIO regions that need to be avoided.
 	 */
-	const u64 gpa = SZ_4G;
+	const gpa_t gpa = SZ_4G;
 	const int slot = 1;
 
 	struct kvm_vcpu *vcpu;
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 0dcfad728edd..0d9f11be9806 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -114,7 +114,7 @@ struct kvm_vm {
 	gpa_t ucall_mmio_addr;
 	gva_t handlers;
 	u32 dirty_ring_size;
-	u64 gpa_tag_mask;
+	gpa_t gpa_tag_mask;
 
 	/*
 	 * "mmu" is the guest's stage-1, with a short name because the vast
@@ -418,7 +418,7 @@ static inline void vm_enable_cap(struct kvm_vm *vm, u32 cap, u64 arg0)
 	vm_ioctl(vm, KVM_ENABLE_CAP, &enable_cap);
 }
 
-static inline void vm_set_memory_attributes(struct kvm_vm *vm, u64 gpa,
+static inline void vm_set_memory_attributes(struct kvm_vm *vm, gpa_t gpa,
 					    u64 size, u64 attributes)
 {
 	struct kvm_memory_attributes attr = {
@@ -439,28 +439,28 @@ static inline void vm_set_memory_attributes(struct kvm_vm *vm, u64 gpa,
 }
 
 
-static inline void vm_mem_set_private(struct kvm_vm *vm, u64 gpa,
+static inline void vm_mem_set_private(struct kvm_vm *vm, gpa_t gpa,
 				      u64 size)
 {
 	vm_set_memory_attributes(vm, gpa, size, KVM_MEMORY_ATTRIBUTE_PRIVATE);
 }
 
-static inline void vm_mem_set_shared(struct kvm_vm *vm, u64 gpa,
+static inline void vm_mem_set_shared(struct kvm_vm *vm, gpa_t gpa,
 				     u64 size)
 {
 	vm_set_memory_attributes(vm, gpa, size, 0);
 }
 
-void vm_guest_mem_fallocate(struct kvm_vm *vm, u64 gpa, u64 size,
+void vm_guest_mem_fallocate(struct kvm_vm *vm, gpa_t gpa, u64 size,
 			    bool punch_hole);
 
-static inline void vm_guest_mem_punch_hole(struct kvm_vm *vm, u64 gpa,
+static inline void vm_guest_mem_punch_hole(struct kvm_vm *vm, gpa_t gpa,
 					   u64 size)
 {
 	vm_guest_mem_fallocate(vm, gpa, size, true);
 }
 
-static inline void vm_guest_mem_allocate(struct kvm_vm *vm, u64 gpa,
+static inline void vm_guest_mem_allocate(struct kvm_vm *vm, gpa_t gpa,
 					 u64 size)
 {
 	vm_guest_mem_fallocate(vm, gpa, size, false);
@@ -685,21 +685,21 @@ static inline int vm_create_guest_memfd(struct kvm_vm *vm, u64 size,
 }
 
 void vm_set_user_memory_region(struct kvm_vm *vm, u32 slot, u32 flags,
-			       u64 gpa, u64 size, void *hva);
+			       gpa_t gpa, u64 size, void *hva);
 int __vm_set_user_memory_region(struct kvm_vm *vm, u32 slot, u32 flags,
-				u64 gpa, u64 size, void *hva);
+				gpa_t gpa, u64 size, void *hva);
 void vm_set_user_memory_region2(struct kvm_vm *vm, u32 slot, u32 flags,
-				u64 gpa, u64 size, void *hva,
+				gpa_t gpa, u64 size, void *hva,
 				u32 guest_memfd, u64 guest_memfd_offset);
 int __vm_set_user_memory_region2(struct kvm_vm *vm, u32 slot, u32 flags,
-				 u64 gpa, u64 size, void *hva,
+				 gpa_t gpa, u64 size, void *hva,
 				 u32 guest_memfd, u64 guest_memfd_offset);
 
 void vm_userspace_mem_region_add(struct kvm_vm *vm,
 				 enum vm_mem_backing_src_type src_type,
-				 u64 gpa, u32 slot, u64 npages, u32 flags);
+				 gpa_t gpa, u32 slot, u64 npages, u32 flags);
 void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
-		u64 gpa, u32 slot, u64 npages, u32 flags,
+		gpa_t gpa, u32 slot, u64 npages, u32 flags,
 		int guest_memfd_fd, u64 guest_memfd_offset);
 
 #ifndef vm_arch_has_protected_memory
diff --git a/tools/testing/selftests/kvm/include/memstress.h b/tools/testing/selftests/kvm/include/memstress.h
index abd0dca10283..0d1d6230cc05 100644
--- a/tools/testing/selftests/kvm/include/memstress.h
+++ b/tools/testing/selftests/kvm/include/memstress.h
@@ -20,7 +20,7 @@
 #define MEMSTRESS_MEM_SLOT_INDEX	1
 
 struct memstress_vcpu_args {
-	u64 gpa;
+	gpa_t gpa;
 	gva_t gva;
 	u64 pages;
 
@@ -32,7 +32,7 @@ struct memstress_vcpu_args {
 struct memstress_args {
 	struct kvm_vm *vm;
 	/* The starting address and size of the guest test region. */
-	u64 gpa;
+	gpa_t gpa;
 	u64 size;
 	u64 guest_page_size;
 	u32 random_seed;
diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index 15252e75aaf1..fc7efd722229 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -1400,12 +1400,12 @@ u64 kvm_hypercall(u64 nr, u64 a0, u64 a1, u64 a2, u64 a3);
 u64 __xen_hypercall(u64 nr, u64 a0, void *a1);
 void xen_hypercall(u64 nr, u64 a0, void *a1);
 
-static inline u64 __kvm_hypercall_map_gpa_range(u64 gpa, u64 size, u64 flags)
+static inline u64 __kvm_hypercall_map_gpa_range(gpa_t gpa, u64 size, u64 flags)
 {
 	return kvm_hypercall(KVM_HC_MAP_GPA_RANGE, gpa, size >> PAGE_SHIFT, flags, 0);
 }
 
-static inline void kvm_hypercall_map_gpa_range(u64 gpa, u64 size, u64 flags)
+static inline void kvm_hypercall_map_gpa_range(gpa_t gpa, u64 size, u64 flags)
 {
 	u64 ret = __kvm_hypercall_map_gpa_range(gpa, size, flags);
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index e282f9abd4c7..905fa214099d 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -919,7 +919,7 @@ static void vm_userspace_mem_region_hva_insert(struct rb_root *hva_tree,
 
 
 int __vm_set_user_memory_region(struct kvm_vm *vm, u32 slot, u32 flags,
-				u64 gpa, u64 size, void *hva)
+				gpa_t gpa, u64 size, void *hva)
 {
 	struct kvm_userspace_memory_region region = {
 		.slot = slot,
@@ -933,7 +933,7 @@ int __vm_set_user_memory_region(struct kvm_vm *vm, u32 slot, u32 flags,
 }
 
 void vm_set_user_memory_region(struct kvm_vm *vm, u32 slot, u32 flags,
-			       u64 gpa, u64 size, void *hva)
+			       gpa_t gpa, u64 size, void *hva)
 {
 	int ret = __vm_set_user_memory_region(vm, slot, flags, gpa, size, hva);
 
@@ -946,7 +946,7 @@ void vm_set_user_memory_region(struct kvm_vm *vm, u32 slot, u32 flags,
 		       "KVM selftests now require KVM_SET_USER_MEMORY_REGION2 (introduced in v6.8)")
 
 int __vm_set_user_memory_region2(struct kvm_vm *vm, u32 slot, u32 flags,
-				 u64 gpa, u64 size, void *hva,
+				 gpa_t gpa, u64 size, void *hva,
 				 u32 guest_memfd, u64 guest_memfd_offset)
 {
 	struct kvm_userspace_memory_region2 region = {
@@ -965,7 +965,7 @@ int __vm_set_user_memory_region2(struct kvm_vm *vm, u32 slot, u32 flags,
 }
 
 void vm_set_user_memory_region2(struct kvm_vm *vm, u32 slot, u32 flags,
-				u64 gpa, u64 size, void *hva,
+				gpa_t gpa, u64 size, void *hva,
 				u32 guest_memfd, u64 guest_memfd_offset)
 {
 	int ret = __vm_set_user_memory_region2(vm, slot, flags, gpa, size, hva,
@@ -978,7 +978,7 @@ void vm_set_user_memory_region2(struct kvm_vm *vm, u32 slot, u32 flags,
 
 /* FIXME: This thing needs to be ripped apart and rewritten. */
 void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
-		u64 gpa, u32 slot, u64 npages, u32 flags,
+		gpa_t gpa, u32 slot, u64 npages, u32 flags,
 		int guest_memfd, u64 guest_memfd_offset)
 {
 	int ret;
@@ -1141,7 +1141,7 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 
 void vm_userspace_mem_region_add(struct kvm_vm *vm,
 				 enum vm_mem_backing_src_type src_type,
-				 u64 gpa, u32 slot, u64 npages, u32 flags)
+				 gpa_t gpa, u32 slot, u64 npages, u32 flags)
 {
 	vm_mem_add(vm, src_type, gpa, slot, npages, flags, -1, 0);
 }
@@ -1278,7 +1278,7 @@ void vm_guest_mem_fallocate(struct kvm_vm *vm, u64 base, u64 size,
 	const int mode = FALLOC_FL_KEEP_SIZE | (punch_hole ? FALLOC_FL_PUNCH_HOLE : 0);
 	struct userspace_mem_region *region;
 	u64 end = base + size;
-	u64 gpa, len;
+	gpa_t gpa, len;
 	off_t fd_offset;
 	int ret;
 
diff --git a/tools/testing/selftests/kvm/lib/s390/processor.c b/tools/testing/selftests/kvm/lib/s390/processor.c
index 643e583c804c..77a7b6965812 100644
--- a/tools/testing/selftests/kvm/lib/s390/processor.c
+++ b/tools/testing/selftests/kvm/lib/s390/processor.c
@@ -47,7 +47,7 @@ static u64 virt_alloc_region(struct kvm_vm *vm, int ri)
 		| ((ri < 4 ? (PAGES_PER_REGION - 1) : 0) & REGION_ENTRY_LENGTH);
 }
 
-void virt_arch_pg_map(struct kvm_vm *vm, gva_t gva, u64 gpa)
+void virt_arch_pg_map(struct kvm_vm *vm, gva_t gva, gpa_t gpa)
 {
 	int ri, idx;
 	u64 *entry;
diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
index 9d7c4afab961..9c7578a098c3 100644
--- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
+++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
@@ -58,7 +58,7 @@ static void add_remove_memslot(struct kvm_vm *vm, useconds_t delay,
 			       u64 nr_modifications)
 {
 	u64 pages = max_t(int, vm->page_size, getpagesize()) / vm->page_size;
-	u64 gpa;
+	gpa_t gpa;
 	int i;
 
 	/*
diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
index 51f8be50c7e4..3d02db371422 100644
--- a/tools/testing/selftests/kvm/memslot_perf_test.c
+++ b/tools/testing/selftests/kvm/memslot_perf_test.c
@@ -186,9 +186,9 @@ static void wait_for_vcpu(void)
 		    "sem_timedwait() failed: %d", errno);
 }
 
-static void *vm_gpa2hva(struct vm_data *data, u64 gpa, u64 *rempages)
+static void *vm_gpa2hva(struct vm_data *data, gpa_t gpa, u64 *rempages)
 {
-	u64 gpage, pgoffs;
+	gpa_t gpage, pgoffs;
 	u32 slot, slotoffs;
 	void *base;
 	u32 guest_page_size = data->vm->page_size;
@@ -332,7 +332,7 @@ static bool prepare_vm(struct vm_data *data, int nslots, u64 *maxslots,
 
 	for (slot = 1, guest_addr = MEM_GPA; slot <= data->nslots; slot++) {
 		u64 npages;
-		u64 gpa;
+		gpa_t gpa;
 
 		npages = data->pages_per_slot;
 		if (slot == data->nslots)
@@ -638,7 +638,7 @@ static void test_memslot_move_loop(struct vm_data *data, struct sync_area *sync)
 static void test_memslot_do_unmap(struct vm_data *data,
 				  u64 offsp, u64 count)
 {
-	u64 gpa, ctr;
+	gpa_t gpa, ctr;
 	u32 guest_page_size = data->vm->page_size;
 
 	for (gpa = MEM_TEST_GPA + offsp * guest_page_size, ctr = 0; ctr < count; ) {
@@ -663,7 +663,7 @@ static void test_memslot_do_unmap(struct vm_data *data,
 static void test_memslot_map_unmap_check(struct vm_data *data,
 					 u64 offsp, u64 valexp)
 {
-	u64 gpa;
+	gpa_t gpa;
 	u64 *val;
 	u32 guest_page_size = data->vm->page_size;
 
diff --git a/tools/testing/selftests/kvm/mmu_stress_test.c b/tools/testing/selftests/kvm/mmu_stress_test.c
index e0975a5dcff1..54d281419d31 100644
--- a/tools/testing/selftests/kvm/mmu_stress_test.c
+++ b/tools/testing/selftests/kvm/mmu_stress_test.c
@@ -22,7 +22,7 @@ static bool all_vcpus_hit_ro_fault;
 
 static void guest_code(u64 start_gpa, u64 end_gpa, u64 stride)
 {
-	u64 gpa;
+	gpa_t gpa;
 	int i;
 
 	for (i = 0; i < 2; i++) {
@@ -206,7 +206,7 @@ static pthread_t *spawn_workers(struct kvm_vm *vm, struct kvm_vcpu **vcpus,
 				u64 start_gpa, u64 end_gpa)
 {
 	struct vcpu_info *info;
-	u64 gpa, nr_bytes;
+	gpa_t gpa, nr_bytes;
 	pthread_t *threads;
 	int i;
 
diff --git a/tools/testing/selftests/kvm/pre_fault_memory_test.c b/tools/testing/selftests/kvm/pre_fault_memory_test.c
index bfdaaeed3a8c..fcb57fd034e6 100644
--- a/tools/testing/selftests/kvm/pre_fault_memory_test.c
+++ b/tools/testing/selftests/kvm/pre_fault_memory_test.c
@@ -33,7 +33,7 @@ static void guest_code(u64 base_gva)
 
 struct slot_worker_data {
 	struct kvm_vm *vm;
-	u64 gpa;
+	gpa_t gpa;
 	u32 flags;
 	bool worker_ready;
 	bool prefault_ready;
@@ -161,7 +161,7 @@ static void pre_fault_memory(struct kvm_vcpu *vcpu, u64 base_gpa, u64 offset,
 
 static void __test_pre_fault_memory(unsigned long vm_type, bool private)
 {
-	u64 gpa, gva, alignment, guest_page_size;
+	gpa_t gpa, gva, alignment, guest_page_size;
 	const struct vm_shape shape = {
 		.mode = VM_MODE_DEFAULT,
 		.type = vm_type,
diff --git a/tools/testing/selftests/kvm/s390/ucontrol_test.c b/tools/testing/selftests/kvm/s390/ucontrol_test.c
index dbdee4c39d47..b8c6f37b53e0 100644
--- a/tools/testing/selftests/kvm/s390/ucontrol_test.c
+++ b/tools/testing/selftests/kvm/s390/ucontrol_test.c
@@ -269,7 +269,7 @@ TEST(uc_cap_hpage)
 }
 
 /* calculate host virtual addr from guest physical addr */
-static void *gpa2hva(FIXTURE_DATA(uc_kvm) *self, u64 gpa)
+static void *gpa2hva(FIXTURE_DATA(uc_kvm) *self, gpa_t gpa)
 {
 	return (void *)(self->base_hva - self->base_gpa + gpa);
 }
diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index 5551dd0f9fad..9b919a231c93 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -112,7 +112,7 @@ static struct kvm_vm *spawn_vm(struct kvm_vcpu **vcpu, pthread_t *vcpu_thread,
 {
 	struct kvm_vm *vm;
 	u64 *hva;
-	u64 gpa;
+	gpa_t gpa;
 
 	vm = vm_create_with_one_vcpu(vcpu, guest_code);
 
diff --git a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
index 27675d7d04c0..1d2f5d4fd45d 100644
--- a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
@@ -38,7 +38,7 @@ do {												\
 			       pattern, i, gpa + i, mem[i]);					\
 } while (0)
 
-static void memcmp_h(u8 *mem, u64 gpa, u8 pattern, size_t size)
+static void memcmp_h(u8 *mem, gpa_t gpa, u8 pattern, size_t size)
 {
 	size_t i;
 
@@ -70,13 +70,13 @@ enum ucall_syncs {
 	SYNC_PRIVATE,
 };
 
-static void guest_sync_shared(u64 gpa, u64 size,
+static void guest_sync_shared(gpa_t gpa, u64 size,
 			      u8 current_pattern, u8 new_pattern)
 {
 	GUEST_SYNC5(SYNC_SHARED, gpa, size, current_pattern, new_pattern);
 }
 
-static void guest_sync_private(u64 gpa, u64 size, u8 pattern)
+static void guest_sync_private(gpa_t gpa, u64 size, u8 pattern)
 {
 	GUEST_SYNC4(SYNC_PRIVATE, gpa, size, pattern);
 }
@@ -86,7 +86,7 @@ static void guest_sync_private(u64 gpa, u64 size, u8 pattern)
 #define MAP_GPA_SHARED		BIT(1)
 #define MAP_GPA_DO_FALLOCATE	BIT(2)
 
-static void guest_map_mem(u64 gpa, u64 size, bool map_shared,
+static void guest_map_mem(gpa_t gpa, u64 size, bool map_shared,
 			  bool do_fallocate)
 {
 	u64 flags = MAP_GPA_SET_ATTRIBUTES;
@@ -98,12 +98,12 @@ static void guest_map_mem(u64 gpa, u64 size, bool map_shared,
 	kvm_hypercall_map_gpa_range(gpa, size, flags);
 }
 
-static void guest_map_shared(u64 gpa, u64 size, bool do_fallocate)
+static void guest_map_shared(gpa_t gpa, u64 size, bool do_fallocate)
 {
 	guest_map_mem(gpa, size, true, do_fallocate);
 }
 
-static void guest_map_private(u64 gpa, u64 size, bool do_fallocate)
+static void guest_map_private(gpa_t gpa, u64 size, bool do_fallocate)
 {
 	guest_map_mem(gpa, size, false, do_fallocate);
 }
@@ -134,7 +134,7 @@ static void guest_test_explicit_conversion(u64 base_gpa, bool do_fallocate)
 	memcmp_g(base_gpa, init_p, PER_CPU_DATA_SIZE);
 
 	for (i = 0; i < ARRAY_SIZE(test_ranges); i++) {
-		u64 gpa = base_gpa + test_ranges[i].offset;
+		gpa_t gpa = base_gpa + test_ranges[i].offset;
 		u64 size = test_ranges[i].size;
 		u8 p1 = 0x11;
 		u8 p2 = 0x22;
@@ -214,7 +214,7 @@ static void guest_test_explicit_conversion(u64 base_gpa, bool do_fallocate)
 	}
 }
 
-static void guest_punch_hole(u64 gpa, u64 size)
+static void guest_punch_hole(gpa_t gpa, u64 size)
 {
 	/* "Mapping" memory shared via fallocate() is done via PUNCH_HOLE. */
 	u64 flags = MAP_GPA_SHARED | MAP_GPA_DO_FALLOCATE;
@@ -239,7 +239,7 @@ static void guest_test_punch_hole(u64 base_gpa, bool precise)
 	guest_map_private(base_gpa, PER_CPU_DATA_SIZE, false);
 
 	for (i = 0; i < ARRAY_SIZE(test_ranges); i++) {
-		u64 gpa = base_gpa + test_ranges[i].offset;
+		gpa_t gpa = base_gpa + test_ranges[i].offset;
 		u64 size = test_ranges[i].size;
 
 		/*
@@ -289,7 +289,7 @@ static void guest_code(u64 base_gpa)
 static void handle_exit_hypercall(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *run = vcpu->run;
-	u64 gpa = run->hypercall.args[0];
+	gpa_t gpa = run->hypercall.args[0];
 	u64 size = run->hypercall.args[1] * PAGE_SIZE;
 	bool set_attributes = run->hypercall.args[2] & MAP_GPA_SET_ATTRIBUTES;
 	bool map_shared = run->hypercall.args[2] & MAP_GPA_SHARED;
@@ -337,7 +337,7 @@ static void *__test_mem_conversions(void *__vcpu)
 		case UCALL_ABORT:
 			REPORT_GUEST_ASSERT(uc);
 		case UCALL_SYNC: {
-			u64 gpa  = uc.args[1];
+			gpa_t gpa  = uc.args[1];
 			size_t size = uc.args[2];
 			size_t i;
 
@@ -402,7 +402,7 @@ static void test_mem_conversions(enum vm_mem_backing_src_type src_type, u32 nr_v
 			   KVM_MEM_GUEST_MEMFD, memfd, slot_size * i);
 
 	for (i = 0; i < nr_vcpus; i++) {
-		u64 gpa =  BASE_DATA_GPA + i * per_cpu_size;
+		gpa_t gpa =  BASE_DATA_GPA + i * per_cpu_size;
 
 		vcpu_args_set(vcpus[i], 1, gpa);
 
diff --git a/tools/testing/selftests/kvm/x86/smaller_maxphyaddr_emulation_test.c b/tools/testing/selftests/kvm/x86/smaller_maxphyaddr_emulation_test.c
index 27cded643699..3dca85e95478 100644
--- a/tools/testing/selftests/kvm/x86/smaller_maxphyaddr_emulation_test.c
+++ b/tools/testing/selftests/kvm/x86/smaller_maxphyaddr_emulation_test.c
@@ -48,7 +48,7 @@ int main(int argc, char *argv[])
 	struct kvm_vm *vm;
 	struct ucall uc;
 	u64 *hva;
-	u64 gpa;
+	gpa_t gpa;
 	int rc;
 
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_SMALLER_MAXPHYADDR));
diff --git a/tools/testing/selftests/kvm/x86/svm_nested_vmcb12_gpa.c b/tools/testing/selftests/kvm/x86/svm_nested_vmcb12_gpa.c
index ae8a10913af7..a4935ce2fb99 100644
--- a/tools/testing/selftests/kvm/x86/svm_nested_vmcb12_gpa.c
+++ b/tools/testing/selftests/kvm/x86/svm_nested_vmcb12_gpa.c
@@ -28,28 +28,28 @@ static void l2_code(void)
 	vmcall();
 }
 
-static void l1_vmrun(struct svm_test_data *svm, u64 gpa)
+static void l1_vmrun(struct svm_test_data *svm, gpa_t gpa)
 {
 	generic_svm_setup(svm, l2_code, &l2_guest_stack[L2_GUEST_STACK_SIZE]);
 
 	asm volatile ("vmrun %[gpa]" : : [gpa] "a" (gpa) : "memory");
 }
 
-static void l1_vmload(struct svm_test_data *svm, u64 gpa)
+static void l1_vmload(struct svm_test_data *svm, gpa_t gpa)
 {
 	generic_svm_setup(svm, l2_code, &l2_guest_stack[L2_GUEST_STACK_SIZE]);
 
 	asm volatile ("vmload %[gpa]" : : [gpa] "a" (gpa) : "memory");
 }
 
-static void l1_vmsave(struct svm_test_data *svm, u64 gpa)
+static void l1_vmsave(struct svm_test_data *svm, gpa_t gpa)
 {
 	generic_svm_setup(svm, l2_code, &l2_guest_stack[L2_GUEST_STACK_SIZE]);
 
 	asm volatile ("vmsave %[gpa]" : : [gpa] "a" (gpa) : "memory");
 }
 
-static void l1_vmexit(struct svm_test_data *svm, u64 gpa)
+static void l1_vmexit(struct svm_test_data *svm, gpa_t gpa)
 {
 	generic_svm_setup(svm, l2_code, &l2_guest_stack[L2_GUEST_STACK_SIZE]);
 
-- 
2.54.0.rc1.555.g9c883467ad-goog

