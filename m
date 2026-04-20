Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0EB3A7F7A
	for <kvmarm@lists.linux.dev>; Mon, 20 Apr 2026 21:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776720014; cv=none; b=ljRg4H3K8WU5wT1vJaXhAMHTAXd5pC17XxkjYB146/ZmyFkgMJZZUq/G2+K5J8dpKWvsbI8eq/x02GOyOdwd7H7Rs9F2RNLjzACNlfwmtEaoXpz2XG55f6M8Zb+Gq3Blij0BI1ucH7Cwmyg+tMOg4WDgfpNf37ffsPd/VbYAymM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776720014; c=relaxed/simple;
	bh=3PIZY/gbMaV7GMO/h79Wqixj9S0uWojIg0gWYnv2eMs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XbO+NzXb5Zo/df1UOljWY/vIcndJfPOPRK79/NYfEq3kI1BJymA4Kepx1q3FgwFVfTKfsPaX+43kwOIQW19Ns9UFYwY0UXEECZGmmCwQdlx3aQBcH1UqaKTFPrr+zY18xVTy2hivc3DNMeBHZUZYRjVo0h+lE2024DPn49GalG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FQNCgWjB; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FQNCgWjB"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-82fa2165c3eso1590864b3a.0
        for <kvmarm@lists.linux.dev>; Mon, 20 Apr 2026 14:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776720010; x=1777324810; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=GUvaJ+xA/ByOjYAym9DrOAM97xYrvpdK6zXd2S4iDZk=;
        b=FQNCgWjBQtXXotOlM3Y3A1BnFguT9wSx0NvjyPwoSVpTSP/mZ0qYU7yy8DFthZ2wCd
         K75PmM8Wqpfwl4B6JBO7/xp0seZba/hAlhMKXnT3OEkwVzpWv0NepZPyOLHMGewRfHjk
         0OnlpY6/P1gR2FJWMD7ph4U7q5dScsNaTam/fTOehqtt45g/98iYeGnXzQSQLibnZTyH
         PJAvRBW8WnR1+xL5LcUGsDMVLzK0sxKYaNvz0S4nrsssSwIdvkIXePt0VLefwTlfkN5m
         taiMexa6uNgQnvL85WwizGPnciJCfo3yITHmiZwNXNnkfX3c+aRir0ClLlaittG6M13F
         auOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776720010; x=1777324810;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GUvaJ+xA/ByOjYAym9DrOAM97xYrvpdK6zXd2S4iDZk=;
        b=SvO8NaVtpXCCwVpHc8C8tmJmf9ZrECQNbH6l8Z2rZXwMXFMVeCj5+TLDiVFiFm5FPI
         l9RrUA3NsH1vGe+azxh0DBzQv6+ah2TtM2N3pMLUjpPK2YV9DVIo8P0zXXBb7abr2UIl
         r4teiqk+1HxI4Ac8o3xcQfTiaat3MDCylZAYXWfB2riyovIqyypZEYMdK93uBRYUVhHQ
         8VYFoYGdxnjgEDLGRc4Ue9B5AQdv6ryYiy7sI11sEMDwfEzbjcm47mjTF+wpaJl2dMRR
         VYtMiNgulIKqkLMy58Z8SThVtSJycG4q5wkUZpPZMsvJmXdr8Fe1Y6wX/o3ZiXA5dFeJ
         Ea6g==
X-Forwarded-Encrypted: i=1; AFNElJ918UmIILM392LA7RHkQJ/lvzDHtDSPDOTCCoywpf2LWhfuiQcWXIoFmIyTN3kFcn9FhM48Zu8=@lists.linux.dev
X-Gm-Message-State: AOJu0YyM4+5XOaWXB9324lM10lEeaXVbbsSvHHRGm0ziKAVNHljm4zx0
	1UB7tnHM+gTP5zeycYiMO1mg1EoA7jIf19N5G24QbmrC6LvgRXnDFupFJZEzmzi5qNXRiPAJrc7
	5aB+avw==
X-Received: from pfbho13.prod.google.com ([2002:a05:6a00:880d:b0:7ba:8e68:3140])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:847:b0:82f:6a64:deac
 with SMTP id d2e1a72fcca58-82f8c96211bmr16386230b3a.28.1776720009912; Mon, 20
 Apr 2026 14:20:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 20 Apr 2026 14:19:47 -0700
In-Reply-To: <20260420212004.3938325-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260420212004.3938325-1-seanjc@google.com>
X-Mailer: git-send-email 2.54.0.rc1.555.g9c883467ad-goog
Message-ID: <20260420212004.3938325-3-seanjc@google.com>
Subject: [PATCH v3 02/19] KVM: selftests: Use gpa_t instead of vm_paddr_t
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

From: David Matlack <dmatlack@google.com>

Replace all occurrences of vm_paddr_t with gpa_t to align with KVM code
and with the conversion helpers (e.g. addr_hva2gpa()).

This commit was generated with the following command:

  git ls-files tools/testing/selftests/kvm | xargs sed -i 's/vm_paddr_/gpa_/g'

Then by manually adjusting whitespace to make checkpatch.pl happy.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
[sean: drop bogus changelog blurb about renaming functions]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/arm64/sea_to_user.c |  4 +--
 .../selftests/kvm/arm64/vgic_lpi_stress.c     | 20 ++++++------
 tools/testing/selftests/kvm/dirty_log_test.c  |  2 +-
 .../testing/selftests/kvm/include/arm64/gic.h |  4 +--
 .../selftests/kvm/include/arm64/gic_v3_its.h  |  7 ++---
 .../testing/selftests/kvm/include/kvm_util.h  | 31 +++++++++----------
 .../selftests/kvm/include/kvm_util_types.h    |  2 +-
 .../selftests/kvm/include/riscv/ucall.h       |  2 +-
 .../selftests/kvm/include/s390/ucall.h        |  2 +-
 .../selftests/kvm/include/ucall_common.h      |  4 +--
 tools/testing/selftests/kvm/include/x86/sev.h |  4 +--
 .../testing/selftests/kvm/include/x86/ucall.h |  2 +-
 .../selftests/kvm/kvm_page_table_test.c       |  2 +-
 .../testing/selftests/kvm/lib/arm64/gic_v3.c  |  4 +--
 .../selftests/kvm/lib/arm64/gic_v3_its.c      | 11 +++----
 .../selftests/kvm/lib/arm64/processor.c       |  2 +-
 tools/testing/selftests/kvm/lib/arm64/ucall.c |  2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 27 ++++++++--------
 .../selftests/kvm/lib/loongarch/processor.c   | 10 +++---
 .../selftests/kvm/lib/loongarch/ucall.c       |  2 +-
 tools/testing/selftests/kvm/lib/memstress.c   |  2 +-
 .../selftests/kvm/lib/riscv/processor.c       |  2 +-
 .../selftests/kvm/lib/s390/processor.c        |  4 +--
 .../testing/selftests/kvm/lib/ucall_common.c  |  2 +-
 .../testing/selftests/kvm/lib/x86/processor.c |  2 +-
 tools/testing/selftests/kvm/lib/x86/sev.c     |  2 +-
 .../selftests/kvm/riscv/sbi_pmu_test.c        |  4 +--
 .../testing/selftests/kvm/s390/irq_routing.c  |  2 +-
 .../selftests/kvm/s390/ucontrol_test.c        |  2 +-
 tools/testing/selftests/kvm/steal_time.c      |  4 +--
 .../testing/selftests/kvm/x86/hyperv_clock.c  |  2 +-
 .../kvm/x86/hyperv_extended_hypercalls.c      |  2 +-
 .../selftests/kvm/x86/hyperv_tlb_flush.c      |  8 ++---
 .../selftests/kvm/x86/kvm_clock_test.c        |  4 +--
 .../kvm/x86/vmx_nested_la57_state_test.c      |  2 +-
 35 files changed, 92 insertions(+), 96 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/sea_to_user.c b/tools/testing/selftests/kvm/arm64/sea_to_user.c
index 573dd790aeb8..f41987dc726a 100644
--- a/tools/testing/selftests/kvm/arm64/sea_to_user.c
+++ b/tools/testing/selftests/kvm/arm64/sea_to_user.c
@@ -51,7 +51,7 @@
 #define EINJ_OFFSET		0x01234badUL
 #define EINJ_GVA		((START_GVA) + (EINJ_OFFSET))
 
-static vm_paddr_t einj_gpa;
+static gpa_t einj_gpa;
 static void *einj_hva;
 static uint64_t einj_hpa;
 static bool far_invalid;
@@ -254,7 +254,7 @@ static struct kvm_vm *vm_create_with_sea_handler(struct kvm_vcpu **vcpu)
 	size_t guest_page_size;
 	size_t alignment;
 	uint64_t num_guest_pages;
-	vm_paddr_t start_gpa;
+	gpa_t start_gpa;
 	enum vm_mem_backing_src_type src_type = VM_MEM_SRC_ANONYMOUS_HUGETLB_1GB;
 	struct kvm_vm *vm;
 
diff --git a/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c b/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
index e857a605f577..d64d434d3f06 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
@@ -23,7 +23,7 @@
 #define GIC_LPI_OFFSET	8192
 
 static size_t nr_iterations = 1000;
-static vm_paddr_t gpa_base;
+static gpa_t gpa_base;
 
 static struct kvm_vm *vm;
 static struct kvm_vcpu **vcpus;
@@ -35,14 +35,14 @@ static struct test_data {
 	u32		nr_devices;
 	u32		nr_event_ids;
 
-	vm_paddr_t	device_table;
-	vm_paddr_t	collection_table;
-	vm_paddr_t	cmdq_base;
+	gpa_t		device_table;
+	gpa_t		collection_table;
+	gpa_t		cmdq_base;
 	void		*cmdq_base_va;
-	vm_paddr_t	itt_tables;
+	gpa_t		itt_tables;
 
-	vm_paddr_t	lpi_prop_table;
-	vm_paddr_t	lpi_pend_tables;
+	gpa_t		lpi_prop_table;
+	gpa_t		lpi_pend_tables;
 } test_data =  {
 	.nr_cpus	= 1,
 	.nr_devices	= 1,
@@ -73,7 +73,7 @@ static void guest_setup_its_mappings(void)
 	/* Round-robin the LPIs to all of the vCPUs in the VM */
 	coll_id = 0;
 	for (device_id = 0; device_id < nr_devices; device_id++) {
-		vm_paddr_t itt_base = test_data.itt_tables + (device_id * SZ_64K);
+		gpa_t itt_base = test_data.itt_tables + (device_id * SZ_64K);
 
 		its_send_mapd_cmd(test_data.cmdq_base_va, device_id,
 				  itt_base, SZ_64K, true);
@@ -188,7 +188,7 @@ static void setup_test_data(void)
 	size_t pages_per_64k = vm_calc_num_guest_pages(vm->mode, SZ_64K);
 	u32 nr_devices = test_data.nr_devices;
 	u32 nr_cpus = test_data.nr_cpus;
-	vm_paddr_t cmdq_base;
+	gpa_t cmdq_base;
 
 	test_data.device_table = vm_phy_pages_alloc(vm, pages_per_64k,
 						    gpa_base,
@@ -224,7 +224,7 @@ static void setup_gic(void)
 
 static void signal_lpi(u32 device_id, u32 event_id)
 {
-	vm_paddr_t db_addr = GITS_BASE_GPA + GITS_TRANSLATER;
+	gpa_t db_addr = GITS_BASE_GPA + GITS_TRANSLATER;
 
 	struct kvm_msi msi = {
 		.address_lo	= db_addr,
diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 7627b328f18a..9b6b9a597175 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -667,7 +667,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	virt_map(vm, guest_test_virt_mem, guest_test_phys_mem, guest_num_pages);
 
 	/* Cache the HVA pointer of the region */
-	host_test_mem = addr_gpa2hva(vm, (vm_paddr_t)guest_test_phys_mem);
+	host_test_mem = addr_gpa2hva(vm, (gpa_t)guest_test_phys_mem);
 
 	/* Export the shared variables to the guest */
 	sync_global_to_guest(vm, host_page_size);
diff --git a/tools/testing/selftests/kvm/include/arm64/gic.h b/tools/testing/selftests/kvm/include/arm64/gic.h
index cc7a7f34ed37..6408f952cb64 100644
--- a/tools/testing/selftests/kvm/include/arm64/gic.h
+++ b/tools/testing/selftests/kvm/include/arm64/gic.h
@@ -59,7 +59,7 @@ bool gic_irq_get_pending(unsigned int intid);
 void gic_irq_set_config(unsigned int intid, bool is_edge);
 void gic_irq_set_group(unsigned int intid, bool group);
 
-void gic_rdist_enable_lpis(vm_paddr_t cfg_table, size_t cfg_table_size,
-			   vm_paddr_t pend_table);
+void gic_rdist_enable_lpis(gpa_t cfg_table, size_t cfg_table_size,
+			   gpa_t pend_table);
 
 #endif /* SELFTEST_KVM_GIC_H */
diff --git a/tools/testing/selftests/kvm/include/arm64/gic_v3_its.h b/tools/testing/selftests/kvm/include/arm64/gic_v3_its.h
index 58feef3eb386..a43a407e2d5c 100644
--- a/tools/testing/selftests/kvm/include/arm64/gic_v3_its.h
+++ b/tools/testing/selftests/kvm/include/arm64/gic_v3_its.h
@@ -5,11 +5,10 @@
 
 #include <linux/sizes.h>
 
-void its_init(vm_paddr_t coll_tbl, size_t coll_tbl_sz,
-	      vm_paddr_t device_tbl, size_t device_tbl_sz,
-	      vm_paddr_t cmdq, size_t cmdq_size);
+void its_init(gpa_t coll_tbl, size_t coll_tbl_sz, gpa_t device_tbl,
+	      size_t device_tbl_sz, gpa_t cmdq, size_t cmdq_size);
 
-void its_send_mapd_cmd(void *cmdq_base, u32 device_id, vm_paddr_t itt_base,
+void its_send_mapd_cmd(void *cmdq_base, u32 device_id, gpa_t itt_base,
 		       size_t itt_size, bool valid);
 void its_send_mapc_cmd(void *cmdq_base, u32 vcpu_id, u32 collection_id, bool valid);
 void its_send_mapti_cmd(void *cmdq_base, u32 device_id, u32 event_id,
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 2378dd42c988..9f602c73fbb4 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -111,7 +111,7 @@ struct kvm_vm {
 	struct sparsebit *vpages_valid;
 	struct sparsebit *vpages_mapped;
 	bool has_irqchip;
-	vm_paddr_t ucall_mmio_addr;
+	gpa_t ucall_mmio_addr;
 	gva_t handlers;
 	uint32_t dirty_ring_size;
 	uint64_t gpa_tag_mask;
@@ -728,16 +728,16 @@ gva_t vm_vaddr_alloc_page(struct kvm_vm *vm);
 
 void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 	      unsigned int npages);
-void *addr_gpa2hva(struct kvm_vm *vm, vm_paddr_t gpa);
+void *addr_gpa2hva(struct kvm_vm *vm, gpa_t gpa);
 void *addr_gva2hva(struct kvm_vm *vm, gva_t gva);
-vm_paddr_t addr_hva2gpa(struct kvm_vm *vm, void *hva);
-void *addr_gpa2alias(struct kvm_vm *vm, vm_paddr_t gpa);
+gpa_t addr_hva2gpa(struct kvm_vm *vm, void *hva);
+void *addr_gpa2alias(struct kvm_vm *vm, gpa_t gpa);
 
 #ifndef vcpu_arch_put_guest
 #define vcpu_arch_put_guest(mem, val) do { (mem) = (val); } while (0)
 #endif
 
-static inline vm_paddr_t vm_untag_gpa(struct kvm_vm *vm, vm_paddr_t gpa)
+static inline gpa_t vm_untag_gpa(struct kvm_vm *vm, gpa_t gpa)
 {
 	return gpa & ~vm->gpa_tag_mask;
 }
@@ -988,15 +988,14 @@ void kvm_gsi_routing_write(struct kvm_vm *vm, struct kvm_irq_routing *routing);
 
 const char *exit_reason_str(unsigned int exit_reason);
 
-vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
-			     uint32_t memslot);
-vm_paddr_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
-				vm_paddr_t paddr_min, uint32_t memslot,
-				bool protected);
-vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
+gpa_t vm_phy_page_alloc(struct kvm_vm *vm, gpa_t paddr_min, uint32_t memslot);
+gpa_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
+			   gpa_t paddr_min, uint32_t memslot,
+			   bool protected);
+gpa_t vm_alloc_page_table(struct kvm_vm *vm);
 
-static inline vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
-					    vm_paddr_t paddr_min, uint32_t memslot)
+static inline gpa_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
+				       gpa_t paddr_min, uint32_t memslot)
 {
 	/*
 	 * By default, allocate memory as protected for VMs that support
@@ -1240,9 +1239,9 @@ static inline void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr
  * Returns the VM physical address of the translated VM virtual
  * address given by @gva.
  */
-vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva);
+gpa_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva);
 
-static inline vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, gva_t gva)
+static inline gpa_t addr_gva2gpa(struct kvm_vm *vm, gva_t gva)
 {
 	return addr_arch_gva2gpa(vm, gva);
 }
@@ -1291,7 +1290,7 @@ void kvm_arch_vm_post_create(struct kvm_vm *vm, unsigned int nr_vcpus);
 void kvm_arch_vm_finalize_vcpus(struct kvm_vm *vm);
 void kvm_arch_vm_release(struct kvm_vm *vm);
 
-bool vm_is_gpa_protected(struct kvm_vm *vm, vm_paddr_t paddr);
+bool vm_is_gpa_protected(struct kvm_vm *vm, gpa_t paddr);
 
 uint32_t guest_get_vcpuid(void);
 
diff --git a/tools/testing/selftests/kvm/include/kvm_util_types.h b/tools/testing/selftests/kvm/include/kvm_util_types.h
index f27bd035ea10..1d9eedb4885e 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_types.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_types.h
@@ -14,7 +14,7 @@
 #define __kvm_static_assert(expr, msg, ...) _Static_assert(expr, msg)
 #define kvm_static_assert(expr, ...) __kvm_static_assert(expr, ##__VA_ARGS__, #expr)
 
-typedef uint64_t vm_paddr_t; /* Virtual Machine (Guest) physical address */
+typedef uint64_t gpa_t; /* Virtual Machine (Guest) physical address */
 typedef uint64_t gva_t; /* Virtual Machine (Guest) virtual address */
 
 #define INVALID_GPA (~(uint64_t)0)
diff --git a/tools/testing/selftests/kvm/include/riscv/ucall.h b/tools/testing/selftests/kvm/include/riscv/ucall.h
index 41d56254968e..2de7c6a36096 100644
--- a/tools/testing/selftests/kvm/include/riscv/ucall.h
+++ b/tools/testing/selftests/kvm/include/riscv/ucall.h
@@ -7,7 +7,7 @@
 
 #define UCALL_EXIT_REASON       KVM_EXIT_RISCV_SBI
 
-static inline void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
+static inline void ucall_arch_init(struct kvm_vm *vm, gpa_t mmio_gpa)
 {
 }
 
diff --git a/tools/testing/selftests/kvm/include/s390/ucall.h b/tools/testing/selftests/kvm/include/s390/ucall.h
index befee84c4609..3907d629304f 100644
--- a/tools/testing/selftests/kvm/include/s390/ucall.h
+++ b/tools/testing/selftests/kvm/include/s390/ucall.h
@@ -6,7 +6,7 @@
 
 #define UCALL_EXIT_REASON       KVM_EXIT_S390_SIEIC
 
-static inline void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
+static inline void ucall_arch_init(struct kvm_vm *vm, gpa_t mmio_gpa)
 {
 }
 
diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
index e5499f170834..1db399c00d02 100644
--- a/tools/testing/selftests/kvm/include/ucall_common.h
+++ b/tools/testing/selftests/kvm/include/ucall_common.h
@@ -29,7 +29,7 @@ struct ucall {
 	struct ucall *hva;
 };
 
-void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa);
+void ucall_arch_init(struct kvm_vm *vm, gpa_t mmio_gpa);
 void ucall_arch_do_ucall(gva_t uc);
 void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu);
 
@@ -39,7 +39,7 @@ __printf(5, 6) void ucall_assert(uint64_t cmd, const char *exp,
 				 const char *file, unsigned int line,
 				 const char *fmt, ...);
 uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
-void ucall_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa);
+void ucall_init(struct kvm_vm *vm, gpa_t mmio_gpa);
 int ucall_nr_pages_required(uint64_t page_size);
 
 /*
diff --git a/tools/testing/selftests/kvm/include/x86/sev.h b/tools/testing/selftests/kvm/include/x86/sev.h
index 008b4169f5e2..289ff5b3f10c 100644
--- a/tools/testing/selftests/kvm/include/x86/sev.h
+++ b/tools/testing/selftests/kvm/include/x86/sev.h
@@ -120,7 +120,7 @@ static inline void sev_register_encrypted_memory(struct kvm_vm *vm,
 	vm_ioctl(vm, KVM_MEMORY_ENCRYPT_REG_REGION, &range);
 }
 
-static inline void sev_launch_update_data(struct kvm_vm *vm, vm_paddr_t gpa,
+static inline void sev_launch_update_data(struct kvm_vm *vm, gpa_t gpa,
 					  uint64_t size)
 {
 	struct kvm_sev_launch_update_data update_data = {
@@ -131,7 +131,7 @@ static inline void sev_launch_update_data(struct kvm_vm *vm, vm_paddr_t gpa,
 	vm_sev_ioctl(vm, KVM_SEV_LAUNCH_UPDATE_DATA, &update_data);
 }
 
-static inline void snp_launch_update_data(struct kvm_vm *vm, vm_paddr_t gpa,
+static inline void snp_launch_update_data(struct kvm_vm *vm, gpa_t gpa,
 					  uint64_t hva, uint64_t size, uint8_t type)
 {
 	struct kvm_sev_snp_launch_update update_data = {
diff --git a/tools/testing/selftests/kvm/include/x86/ucall.h b/tools/testing/selftests/kvm/include/x86/ucall.h
index d3825dcc3cd9..0e4950041e3e 100644
--- a/tools/testing/selftests/kvm/include/x86/ucall.h
+++ b/tools/testing/selftests/kvm/include/x86/ucall.h
@@ -6,7 +6,7 @@
 
 #define UCALL_EXIT_REASON       KVM_EXIT_IO
 
-static inline void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
+static inline void ucall_arch_init(struct kvm_vm *vm, gpa_t mmio_gpa)
 {
 }
 
diff --git a/tools/testing/selftests/kvm/kvm_page_table_test.c b/tools/testing/selftests/kvm/kvm_page_table_test.c
index 61915fc89c17..e8a60d5ccbe6 100644
--- a/tools/testing/selftests/kvm/kvm_page_table_test.c
+++ b/tools/testing/selftests/kvm/kvm_page_table_test.c
@@ -281,7 +281,7 @@ static struct kvm_vm *pre_init_before_test(enum vm_guest_mode mode, void *arg)
 	virt_map(vm, guest_test_virt_mem, guest_test_phys_mem, guest_num_pages);
 
 	/* Cache the HVA pointer of the region */
-	host_test_mem = addr_gpa2hva(vm, (vm_paddr_t)guest_test_phys_mem);
+	host_test_mem = addr_gpa2hva(vm, (gpa_t)guest_test_phys_mem);
 
 	/* Export shared structure test_args to guest */
 	sync_global_to_guest(vm, test_args);
diff --git a/tools/testing/selftests/kvm/lib/arm64/gic_v3.c b/tools/testing/selftests/kvm/lib/arm64/gic_v3.c
index 50754a27f493..ae3959f3bb11 100644
--- a/tools/testing/selftests/kvm/lib/arm64/gic_v3.c
+++ b/tools/testing/selftests/kvm/lib/arm64/gic_v3.c
@@ -424,8 +424,8 @@ const struct gic_common_ops gicv3_ops = {
 	.gic_irq_set_group = gicv3_set_group,
 };
 
-void gic_rdist_enable_lpis(vm_paddr_t cfg_table, size_t cfg_table_size,
-			   vm_paddr_t pend_table)
+void gic_rdist_enable_lpis(gpa_t cfg_table, size_t cfg_table_size,
+			   gpa_t pend_table)
 {
 	volatile void *rdist_base = gicr_base_cpu(guest_get_vcpuid());
 
diff --git a/tools/testing/selftests/kvm/lib/arm64/gic_v3_its.c b/tools/testing/selftests/kvm/lib/arm64/gic_v3_its.c
index 7f9fdcf42ae6..1188b578121d 100644
--- a/tools/testing/selftests/kvm/lib/arm64/gic_v3_its.c
+++ b/tools/testing/selftests/kvm/lib/arm64/gic_v3_its.c
@@ -54,7 +54,7 @@ static unsigned long its_find_baser(unsigned int type)
 	return -1;
 }
 
-static void its_install_table(unsigned int type, vm_paddr_t base, size_t size)
+static void its_install_table(unsigned int type, gpa_t base, size_t size)
 {
 	unsigned long offset = its_find_baser(type);
 	u64 baser;
@@ -69,7 +69,7 @@ static void its_install_table(unsigned int type, vm_paddr_t base, size_t size)
 	its_write_u64(offset, baser);
 }
 
-static void its_install_cmdq(vm_paddr_t base, size_t size)
+static void its_install_cmdq(gpa_t base, size_t size)
 {
 	u64 cbaser;
 
@@ -82,9 +82,8 @@ static void its_install_cmdq(vm_paddr_t base, size_t size)
 	its_write_u64(GITS_CBASER, cbaser);
 }
 
-void its_init(vm_paddr_t coll_tbl, size_t coll_tbl_sz,
-	      vm_paddr_t device_tbl, size_t device_tbl_sz,
-	      vm_paddr_t cmdq, size_t cmdq_size)
+void its_init(gpa_t coll_tbl, size_t coll_tbl_sz, gpa_t device_tbl,
+	      size_t device_tbl_sz, gpa_t cmdq, size_t cmdq_size)
 {
 	u32 ctlr;
 
@@ -204,7 +203,7 @@ static void its_send_cmd(void *cmdq_base, struct its_cmd_block *cmd)
 	}
 }
 
-void its_send_mapd_cmd(void *cmdq_base, u32 device_id, vm_paddr_t itt_base,
+void its_send_mapd_cmd(void *cmdq_base, u32 device_id, gpa_t itt_base,
 		       size_t itt_size, bool valid)
 {
 	struct its_cmd_block cmd = {};
diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
index 3645acae09ce..0e8603788134 100644
--- a/tools/testing/selftests/kvm/lib/arm64/processor.c
+++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
@@ -230,7 +230,7 @@ uint64_t *virt_get_pte_hva(struct kvm_vm *vm, gva_t gva)
 	return virt_get_pte_hva_at_level(vm, gva, 3);
 }
 
-vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva)
+gpa_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva)
 {
 	uint64_t *ptep = virt_get_pte_hva(vm, gva);
 
diff --git a/tools/testing/selftests/kvm/lib/arm64/ucall.c b/tools/testing/selftests/kvm/lib/arm64/ucall.c
index 9ea747982d00..5f85fa7a9449 100644
--- a/tools/testing/selftests/kvm/lib/arm64/ucall.c
+++ b/tools/testing/selftests/kvm/lib/arm64/ucall.c
@@ -8,7 +8,7 @@
 
 gva_t *ucall_exit_mmio_addr;
 
-void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
+void ucall_arch_init(struct kvm_vm *vm, gpa_t mmio_gpa)
 {
 	gva_t mmio_gva = vm_vaddr_unused_gap(vm, vm->page_size, KVM_UTIL_MIN_VADDR);
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 04a59603e93e..89c4e6f01739 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1457,9 +1457,9 @@ static gva_t ____vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, gva_t vaddr_min,
 	uint64_t pages = (sz >> vm->page_shift) + ((sz % vm->page_size) != 0);
 
 	virt_pgd_alloc(vm);
-	vm_paddr_t paddr = __vm_phy_pages_alloc(vm, pages,
-						KVM_UTIL_MIN_PFN * vm->page_size,
-						vm->memslots[type], protected);
+	gpa_t paddr = __vm_phy_pages_alloc(vm, pages,
+					   KVM_UTIL_MIN_PFN * vm->page_size,
+					   vm->memslots[type], protected);
 
 	/*
 	 * Find an unused range of virtual page addresses of at least
@@ -1607,7 +1607,7 @@ void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
  * address providing the memory to the vm physical address is returned.
  * A TEST_ASSERT failure occurs if no region containing gpa exists.
  */
-void *addr_gpa2hva(struct kvm_vm *vm, vm_paddr_t gpa)
+void *addr_gpa2hva(struct kvm_vm *vm, gpa_t gpa)
 {
 	struct userspace_mem_region *region;
 
@@ -1640,7 +1640,7 @@ void *addr_gpa2hva(struct kvm_vm *vm, vm_paddr_t gpa)
  * VM physical address is returned. A TEST_ASSERT failure occurs if no
  * region containing hva exists.
  */
-vm_paddr_t addr_hva2gpa(struct kvm_vm *vm, void *hva)
+gpa_t addr_hva2gpa(struct kvm_vm *vm, void *hva)
 {
 	struct rb_node *node;
 
@@ -1651,7 +1651,7 @@ vm_paddr_t addr_hva2gpa(struct kvm_vm *vm, void *hva)
 		if (hva >= region->host_mem) {
 			if (hva <= (region->host_mem
 				+ region->region.memory_size - 1))
-				return (vm_paddr_t)((uintptr_t)
+				return (gpa_t)((uintptr_t)
 					region->region.guest_phys_addr
 					+ (hva - (uintptr_t)region->host_mem));
 
@@ -1683,7 +1683,7 @@ vm_paddr_t addr_hva2gpa(struct kvm_vm *vm, void *hva)
  * memory without mapping said memory in the guest's address space. And, for
  * userfaultfd-based demand paging, to do so without triggering userfaults.
  */
-void *addr_gpa2alias(struct kvm_vm *vm, vm_paddr_t gpa)
+void *addr_gpa2alias(struct kvm_vm *vm, gpa_t gpa)
 {
 	struct userspace_mem_region *region;
 	uintptr_t offset;
@@ -2087,9 +2087,9 @@ const char *exit_reason_str(unsigned int exit_reason)
  * and their base address is returned. A TEST_ASSERT failure occurs if
  * not enough pages are available at or above paddr_min.
  */
-vm_paddr_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
-				vm_paddr_t paddr_min, uint32_t memslot,
-				bool protected)
+gpa_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
+			   gpa_t paddr_min, uint32_t memslot,
+			   bool protected)
 {
 	struct userspace_mem_region *region;
 	sparsebit_idx_t pg, base;
@@ -2133,13 +2133,12 @@ vm_paddr_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 	return base * vm->page_size;
 }
 
-vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
-			     uint32_t memslot)
+gpa_t vm_phy_page_alloc(struct kvm_vm *vm, gpa_t paddr_min, uint32_t memslot)
 {
 	return vm_phy_pages_alloc(vm, 1, paddr_min, memslot);
 }
 
-vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm)
+gpa_t vm_alloc_page_table(struct kvm_vm *vm)
 {
 	return vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR,
 				 vm->memslots[MEM_REGION_PT]);
@@ -2353,7 +2352,7 @@ void __attribute((constructor)) kvm_selftest_init(void)
 	kvm_selftest_arch_init();
 }
 
-bool vm_is_gpa_protected(struct kvm_vm *vm, vm_paddr_t paddr)
+bool vm_is_gpa_protected(struct kvm_vm *vm, gpa_t paddr)
 {
 	sparsebit_idx_t pg = 0;
 	struct userspace_mem_region *region;
diff --git a/tools/testing/selftests/kvm/lib/loongarch/processor.c b/tools/testing/selftests/kvm/lib/loongarch/processor.c
index 3b67720fbbe1..28a384e9704f 100644
--- a/tools/testing/selftests/kvm/lib/loongarch/processor.c
+++ b/tools/testing/selftests/kvm/lib/loongarch/processor.c
@@ -12,7 +12,7 @@
 #define LOONGARCH_PAGE_TABLE_PHYS_MIN		0x200000
 #define LOONGARCH_GUEST_STACK_VADDR_MIN		0x200000
 
-static vm_paddr_t invalid_pgtable[4];
+static gpa_t invalid_pgtable[4];
 static gva_t exception_handlers;
 
 static uint64_t virt_pte_index(struct kvm_vm *vm, gva_t gva, int level)
@@ -35,7 +35,7 @@ static uint64_t ptrs_per_pte(struct kvm_vm *vm)
 	return 1 << (vm->page_shift - 3);
 }
 
-static void virt_set_pgtable(struct kvm_vm *vm, vm_paddr_t table, vm_paddr_t child)
+static void virt_set_pgtable(struct kvm_vm *vm, gpa_t table, gpa_t child)
 {
 	uint64_t *ptep;
 	int i, ptrs_per_pte;
@@ -49,7 +49,7 @@ static void virt_set_pgtable(struct kvm_vm *vm, vm_paddr_t table, vm_paddr_t chi
 void virt_arch_pgd_alloc(struct kvm_vm *vm)
 {
 	int i;
-	vm_paddr_t child, table;
+	gpa_t child, table;
 
 	if (vm->mmu.pgd_created)
 		return;
@@ -76,7 +76,7 @@ static uint64_t *virt_populate_pte(struct kvm_vm *vm, gva_t gva, int alloc)
 {
 	int level;
 	uint64_t *ptep;
-	vm_paddr_t child;
+	gpa_t child;
 
 	if (!vm->mmu.pgd_created)
 		goto unmapped_gva;
@@ -106,7 +106,7 @@ static uint64_t *virt_populate_pte(struct kvm_vm *vm, gva_t gva, int alloc)
 	exit(EXIT_FAILURE);
 }
 
-vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva)
+gpa_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva)
 {
 	uint64_t *ptep;
 
diff --git a/tools/testing/selftests/kvm/lib/loongarch/ucall.c b/tools/testing/selftests/kvm/lib/loongarch/ucall.c
index a5aa568f437b..2c8abe9f5382 100644
--- a/tools/testing/selftests/kvm/lib/loongarch/ucall.c
+++ b/tools/testing/selftests/kvm/lib/loongarch/ucall.c
@@ -11,7 +11,7 @@
  */
 gva_t *ucall_exit_mmio_addr;
 
-void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
+void ucall_arch_init(struct kvm_vm *vm, gpa_t mmio_gpa)
 {
 	gva_t mmio_gva = vm_vaddr_unused_gap(vm, vm->page_size, KVM_UTIL_MIN_VADDR);
 
diff --git a/tools/testing/selftests/kvm/lib/memstress.c b/tools/testing/selftests/kvm/lib/memstress.c
index 1ea735d66e15..b7bfeade85f7 100644
--- a/tools/testing/selftests/kvm/lib/memstress.c
+++ b/tools/testing/selftests/kvm/lib/memstress.c
@@ -203,7 +203,7 @@ struct kvm_vm *memstress_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 	/* Add extra memory slots for testing */
 	for (i = 0; i < slots; i++) {
 		uint64_t region_pages = guest_num_pages / slots;
-		vm_paddr_t region_start = args->gpa + region_pages * args->guest_page_size * i;
+		gpa_t region_start = args->gpa + region_pages * args->guest_page_size * i;
 
 		vm_userspace_mem_region_add(vm, backing_src, region_start,
 					    MEMSTRESS_MEM_SLOT_INDEX + i,
diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
index 552628dda4a0..25749439fdbf 100644
--- a/tools/testing/selftests/kvm/lib/riscv/processor.c
+++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
@@ -119,7 +119,7 @@ void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 		PGTBL_PTE_PERM_MASK | PGTBL_PTE_VALID_MASK;
 }
 
-vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva)
+gpa_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva)
 {
 	uint64_t *ptep;
 	int level = vm->mmu.pgtable_levels - 1;
diff --git a/tools/testing/selftests/kvm/lib/s390/processor.c b/tools/testing/selftests/kvm/lib/s390/processor.c
index e8d3c1d333d5..153cef5c2328 100644
--- a/tools/testing/selftests/kvm/lib/s390/processor.c
+++ b/tools/testing/selftests/kvm/lib/s390/processor.c
@@ -12,7 +12,7 @@
 
 void virt_arch_pgd_alloc(struct kvm_vm *vm)
 {
-	vm_paddr_t paddr;
+	gpa_t paddr;
 
 	TEST_ASSERT(vm->page_size == PAGE_SIZE, "Unsupported page size: 0x%x",
 		    vm->page_size);
@@ -86,7 +86,7 @@ void virt_arch_pg_map(struct kvm_vm *vm, uint64_t gva, uint64_t gpa)
 	entry[idx] = gpa;
 }
 
-vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva)
+gpa_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva)
 {
 	int ri, idx;
 	uint64_t *entry;
diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
index 997444178c78..9afcae844d72 100644
--- a/tools/testing/selftests/kvm/lib/ucall_common.c
+++ b/tools/testing/selftests/kvm/lib/ucall_common.c
@@ -25,7 +25,7 @@ int ucall_nr_pages_required(uint64_t page_size)
  */
 static struct ucall_header *ucall_pool;
 
-void ucall_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
+void ucall_init(struct kvm_vm *vm, gpa_t mmio_gpa)
 {
 	struct ucall_header *hdr;
 	struct ucall *uc;
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index 7a01f83cab0b..d1de157fedff 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -618,7 +618,7 @@ static void kvm_seg_set_kernel_data_64bit(struct kvm_segment *segp)
 	segp->present = true;
 }
 
-vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva)
+gpa_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva)
 {
 	int level = PG_LEVEL_NONE;
 	uint64_t *pte = __vm_get_page_table_entry(vm, &vm->mmu, gva, &level);
diff --git a/tools/testing/selftests/kvm/lib/x86/sev.c b/tools/testing/selftests/kvm/lib/x86/sev.c
index c3a9838f4806..aecef6048ff1 100644
--- a/tools/testing/selftests/kvm/lib/x86/sev.c
+++ b/tools/testing/selftests/kvm/lib/x86/sev.c
@@ -18,7 +18,7 @@ static void encrypt_region(struct kvm_vm *vm, struct userspace_mem_region *regio
 			   uint8_t page_type, bool private)
 {
 	const struct sparsebit *protected_phy_pages = region->protected_phy_pages;
-	const vm_paddr_t gpa_base = region->region.guest_phys_addr;
+	const gpa_t gpa_base = region->region.guest_phys_addr;
 	const sparsebit_idx_t lowest_page_in_region = gpa_base >> vm->page_shift;
 	sparsebit_idx_t i, j;
 
diff --git a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
index 8366c11131ff..207dc5cd36f0 100644
--- a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
+++ b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
@@ -24,7 +24,7 @@ union sbi_pmu_ctr_info ctrinfo_arr[RISCV_MAX_PMU_COUNTERS];
 /* Snapshot shared memory data */
 #define PMU_SNAPSHOT_GPA_BASE		BIT(30)
 static void *snapshot_gva;
-static vm_paddr_t snapshot_gpa;
+static gpa_t snapshot_gpa;
 
 static int vcpu_shared_irq_count;
 static int counter_in_use;
@@ -259,7 +259,7 @@ static inline void verify_sbi_requirement_assert(void)
 		__GUEST_ASSERT(0, "SBI implementation version doesn't support PMU Snapshot");
 }
 
-static void snapshot_set_shmem(vm_paddr_t gpa, unsigned long flags)
+static void snapshot_set_shmem(gpa_t gpa, unsigned long flags)
 {
 	unsigned long lo = (unsigned long)gpa;
 #if __riscv_xlen == 32
diff --git a/tools/testing/selftests/kvm/s390/irq_routing.c b/tools/testing/selftests/kvm/s390/irq_routing.c
index 7819a0af19a8..f3839284ac08 100644
--- a/tools/testing/selftests/kvm/s390/irq_routing.c
+++ b/tools/testing/selftests/kvm/s390/irq_routing.c
@@ -27,7 +27,7 @@ static void test(void)
 	struct kvm_irq_routing *routing;
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
-	vm_paddr_t mem;
+	gpa_t mem;
 	int ret;
 
 	struct kvm_irq_routing_entry ue = {
diff --git a/tools/testing/selftests/kvm/s390/ucontrol_test.c b/tools/testing/selftests/kvm/s390/ucontrol_test.c
index 50bc1c38225a..f773ba0f4641 100644
--- a/tools/testing/selftests/kvm/s390/ucontrol_test.c
+++ b/tools/testing/selftests/kvm/s390/ucontrol_test.c
@@ -111,7 +111,7 @@ FIXTURE(uc_kvm)
 	uintptr_t base_hva;
 	uintptr_t code_hva;
 	int kvm_run_size;
-	vm_paddr_t pgd;
+	gpa_t pgd;
 	void *vm_mem;
 	int vcpu_fd;
 	int kvm_fd;
diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index d2a513ec7dd5..f461eb7a0f6e 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -239,7 +239,7 @@ static void check_steal_time_uapi(void)
 /* SBI STA shmem must have 64-byte alignment */
 #define STEAL_TIME_SIZE		((sizeof(struct sta_struct) + 63) & ~63)
 
-static vm_paddr_t st_gpa[NR_VCPUS];
+static gpa_t st_gpa[NR_VCPUS];
 
 struct sta_struct {
 	uint32_t sequence;
@@ -249,7 +249,7 @@ struct sta_struct {
 	uint8_t pad[47];
 } __packed;
 
-static void sta_set_shmem(vm_paddr_t gpa, unsigned long flags)
+static void sta_set_shmem(gpa_t gpa, unsigned long flags)
 {
 	unsigned long lo = (unsigned long)gpa;
 #if __riscv_xlen == 32
diff --git a/tools/testing/selftests/kvm/x86/hyperv_clock.c b/tools/testing/selftests/kvm/x86/hyperv_clock.c
index b68844924dc5..6bb1ca11256f 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_clock.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_clock.c
@@ -98,7 +98,7 @@ static inline void check_tsc_msr_tsc_page(struct ms_hyperv_tsc_page *tsc_page)
 	GUEST_ASSERT(r2 >= t1 && r2 - t2 < 100000);
 }
 
-static void guest_main(struct ms_hyperv_tsc_page *tsc_page, vm_paddr_t tsc_page_gpa)
+static void guest_main(struct ms_hyperv_tsc_page *tsc_page, gpa_t tsc_page_gpa)
 {
 	u64 tsc_scale, tsc_offset;
 
diff --git a/tools/testing/selftests/kvm/x86/hyperv_extended_hypercalls.c b/tools/testing/selftests/kvm/x86/hyperv_extended_hypercalls.c
index 7762c168bbf3..5f561fcda55a 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_extended_hypercalls.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_extended_hypercalls.c
@@ -15,7 +15,7 @@
 /* Any value is fine */
 #define EXT_CAPABILITIES 0xbull
 
-static void guest_code(vm_paddr_t in_pg_gpa, vm_paddr_t out_pg_gpa,
+static void guest_code(gpa_t in_pg_gpa, gpa_t out_pg_gpa,
 		       gva_t out_pg_gva)
 {
 	uint64_t *output_gva;
diff --git a/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c b/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c
index 7f58a5efe6d5..2de01da9d11d 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c
@@ -62,7 +62,7 @@ struct hv_tlb_flush_ex {
  */
 struct test_data {
 	gva_t hcall_gva;
-	vm_paddr_t hcall_gpa;
+	gpa_t hcall_gpa;
 	gva_t test_pages;
 	gva_t test_pages_pte[NTEST_PAGES];
 };
@@ -133,7 +133,7 @@ static void set_expected_val(void *addr, u64 val, int vcpu_id)
  * Update PTEs swapping two test pages.
  * TODO: use swap()/xchg() when these are provided.
  */
-static void swap_two_test_pages(vm_paddr_t pte_gva1, vm_paddr_t pte_gva2)
+static void swap_two_test_pages(gpa_t pte_gva1, gpa_t pte_gva2)
 {
 	uint64_t tmp = *(uint64_t *)pte_gva1;
 
@@ -201,7 +201,7 @@ static void sender_guest_code(gva_t test_data)
 	struct test_data *data = (struct test_data *)test_data;
 	struct hv_tlb_flush *flush = (struct hv_tlb_flush *)data->hcall_gva;
 	struct hv_tlb_flush_ex *flush_ex = (struct hv_tlb_flush_ex *)data->hcall_gva;
-	vm_paddr_t hcall_gpa = data->hcall_gpa;
+	gpa_t hcall_gpa = data->hcall_gpa;
 	int i, stage = 1;
 
 	wrmsr(HV_X64_MSR_GUEST_OS_ID, HYPERV_LINUX_OS_ID);
@@ -582,7 +582,7 @@ int main(int argc, char *argv[])
 	struct kvm_vcpu *vcpu[3];
 	pthread_t threads[2];
 	gva_t test_data_page, gva;
-	vm_paddr_t gpa;
+	gpa_t gpa;
 	uint64_t *pte;
 	struct test_data *data;
 	struct ucall uc;
diff --git a/tools/testing/selftests/kvm/x86/kvm_clock_test.c b/tools/testing/selftests/kvm/x86/kvm_clock_test.c
index e14f7330302e..5721e035e38c 100644
--- a/tools/testing/selftests/kvm/x86/kvm_clock_test.c
+++ b/tools/testing/selftests/kvm/x86/kvm_clock_test.c
@@ -31,7 +31,7 @@ static struct test_case test_cases[] = {
 #define GUEST_SYNC_CLOCK(__stage, __val)			\
 		GUEST_SYNC_ARGS(__stage, __val, 0, 0, 0)
 
-static void guest_main(vm_paddr_t pvti_pa, struct pvclock_vcpu_time_info *pvti)
+static void guest_main(gpa_t pvti_pa, struct pvclock_vcpu_time_info *pvti)
 {
 	int i;
 
@@ -136,7 +136,7 @@ int main(void)
 {
 	struct kvm_vcpu *vcpu;
 	gva_t pvti_gva;
-	vm_paddr_t pvti_gpa;
+	gpa_t pvti_gpa;
 	struct kvm_vm *vm;
 	int flags;
 
diff --git a/tools/testing/selftests/kvm/x86/vmx_nested_la57_state_test.c b/tools/testing/selftests/kvm/x86/vmx_nested_la57_state_test.c
index 4ffa11a6bcd8..f13dee317383 100644
--- a/tools/testing/selftests/kvm/x86/vmx_nested_la57_state_test.c
+++ b/tools/testing/selftests/kvm/x86/vmx_nested_la57_state_test.c
@@ -30,7 +30,7 @@ static void l1_guest_code(struct vmx_pages *vmx_pages)
 #define L2_GUEST_STACK_SIZE 64
 	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
 	u64 guest_cr4;
-	vm_paddr_t pml5_pa, pml4_pa;
+	gpa_t pml5_pa, pml4_pa;
 	u64 *pml5;
 	u64 exit_reason;
 
-- 
2.54.0.rc1.555.g9c883467ad-goog

