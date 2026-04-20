Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A8130BBBC
	for <kvmarm@lists.linux.dev>; Mon, 20 Apr 2026 21:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776720013; cv=none; b=XK58DG9Sukp193802W08rQ/9Bye+fpZt30HxWbUlxrePg+X3CpUuX/JJjF5ddf9/AN6Dbtc3WrfCIKllGKXDoz0c3tGiOzb8cg6awhxkH8yFVqSFn1LCB4+gqVDe9Mr+ynFPuhHVA0qUBOOCqeP24UgLUTstr6n7rUlrolsjCik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776720013; c=relaxed/simple;
	bh=k73lGFKDO4/vHAM8lpXWmQFmnt70BJjDwUShuglEHas=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=M52ooo8u9ZSdYrmJRXaf36M371TrMIH+1XjhVjyViDOiGuKcdOF2WjyA/QdD3sZw+VGG45Rf36OAQpgvXj/pGzaZ6HAfWSwHY0kb2KGE04NV3p/2EvQqS3gSzObumMBDjVEr6sr8+mVXg5/CClx3X/+LA7q15EC75t1R0o5WMQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jTwo8tVu; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jTwo8tVu"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c70dd30025fso4230093a12.2
        for <kvmarm@lists.linux.dev>; Mon, 20 Apr 2026 14:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776720008; x=1777324808; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=IFrglCoyloT3GmEewLfHk/yw0r4k2oBtwi+jeEWWdhk=;
        b=jTwo8tVuuTWYU+8AHxIJX2b4fA0dbNuqbECU2a2MwrgL+Mv3RcvLFKGzpx5Tx5HYYO
         e9qpP3+KwwTc1plprwsgYNweyp3/w9PPNbJ9ifCdnHy5DDysn3wnpCzjDNsPL+g+6aA9
         rNrG20t8NQdwSZsii7HRDY2Z6B+uyZ772Nu28uEQ5IenUAHo5X9vJZLJUPkYBvuZDX6B
         K1dqaClF1TIdd2SNXLCxYiTGiDIjYfoB9Lmzbvfh61C+mYTcuPYbDfK9HR/iP/fs1dbL
         0eV5lLxjwHsveQfizFR5BCJMwzT7Y8gWFqcy0Eygh0BFa9pzltNm3ygX4x9S5WyNi3mN
         ETRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776720008; x=1777324808;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IFrglCoyloT3GmEewLfHk/yw0r4k2oBtwi+jeEWWdhk=;
        b=KumkXN8150TY4bd/o83/f2FGbMDfMOQpNa9ya09vVmMyNE5fQZ8MWZ4JRbsF7QjNW7
         kAeb7y3Xm+HcE8A55+lkUxCKQtE3Bj242kKaRl+O05I5nK+7ubHwrXFTgIm6CzKf/3Hw
         9oz1MlG+iLOjZ/YWtoiSZeJ6FpODl3E9Hua7yyMRn+5eRL3DBh1vPM//4cXE1VF1Dq0R
         mB2BwzWv/n14V1a6U3pmoo0hTlroISG1llwnxqEs2kOB4qA1mtDgQKWXnfrvqbkPnunk
         YUtYTgM+qc8dv+rxoqGNCwo3nGgmyoVgLge5HWiA5k4xX7CBy5HOPxxWGJYxzpczIKUg
         Hn0Q==
X-Forwarded-Encrypted: i=1; AFNElJ9hQB9xhd2Aeh6ccpuW6fO6eCwp2Wk1cKYNHjT4/17f5pfruN0Sk56iJi0mgCQ/HhvNuZtCp/c=@lists.linux.dev
X-Gm-Message-State: AOJu0YxSpJpd88u7NZvPMb33Y2CTjf88rT5mNSD6cnB14QKieVhx70vg
	MXV3JQ+EE2AHBGHDOqvA82HlAWcpyLtix2o/hvRCgQ3LG7Sf1Gs+nbymjJ1Df2yeQtxQVzZv8Jw
	kqtjESA==
X-Received: from pgiz3.prod.google.com ([2002:a63:c043:0:b0:c79:65cb:1f76])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:2583:b0:398:9820:f6ed
 with SMTP id adf61e73a8af0-3a08d940335mr17898577637.56.1776720008228; Mon, 20
 Apr 2026 14:20:08 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 20 Apr 2026 14:19:46 -0700
In-Reply-To: <20260420212004.3938325-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260420212004.3938325-1-seanjc@google.com>
X-Mailer: git-send-email 2.54.0.rc1.555.g9c883467ad-goog
Message-ID: <20260420212004.3938325-2-seanjc@google.com>
Subject: [PATCH v3 01/19] KVM: selftests: Use gva_t instead of vm_vaddr_t
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

Replace all occurrences of vm_vaddr_t with gva_t to align with KVM code
and with the conversion helpers (e.g. addr_gva2hva()).

This commit was generated with the following command:

  git ls-files tools/testing/selftests/kvm | xargs sed -i 's/vm_vaddr_/gva_/g'

Then by manually adjusting whitespace to make checkpatch.pl happy, and
dropping renames of functions that allocate memory within a given VM.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
[sean: drop renames of allocator APIs]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/arm64/vgic_irq.c  |  6 ++--
 .../selftests/kvm/include/arm64/processor.h   |  4 +--
 .../selftests/kvm/include/arm64/ucall.h       |  4 +--
 .../testing/selftests/kvm/include/kvm_util.h  | 32 +++++++++----------
 .../selftests/kvm/include/kvm_util_types.h    |  2 +-
 .../selftests/kvm/include/loongarch/ucall.h   |  4 +--
 .../selftests/kvm/include/riscv/ucall.h       |  2 +-
 .../selftests/kvm/include/s390/ucall.h        |  2 +-
 .../selftests/kvm/include/ucall_common.h      |  4 +--
 .../selftests/kvm/include/x86/hyperv.h        | 10 +++---
 .../selftests/kvm/include/x86/kvm_util_arch.h |  6 ++--
 .../selftests/kvm/include/x86/svm_util.h      |  2 +-
 tools/testing/selftests/kvm/include/x86/vmx.h |  2 +-
 .../selftests/kvm/kvm_page_table_test.c       |  2 +-
 .../selftests/kvm/lib/arm64/processor.c       | 18 +++++------
 tools/testing/selftests/kvm/lib/arm64/ucall.c |  6 ++--
 tools/testing/selftests/kvm/lib/elf.c         |  6 ++--
 tools/testing/selftests/kvm/lib/kvm_util.c    | 32 ++++++++-----------
 .../selftests/kvm/lib/loongarch/processor.c   |  8 ++---
 .../selftests/kvm/lib/loongarch/ucall.c       |  6 ++--
 .../selftests/kvm/lib/riscv/processor.c       |  8 ++---
 .../selftests/kvm/lib/s390/processor.c        |  2 +-
 .../testing/selftests/kvm/lib/ucall_common.c  |  8 ++---
 tools/testing/selftests/kvm/lib/x86/hyperv.c  |  4 +--
 .../testing/selftests/kvm/lib/x86/memstress.c |  2 +-
 .../testing/selftests/kvm/lib/x86/processor.c | 14 ++++----
 tools/testing/selftests/kvm/lib/x86/svm.c     |  4 +--
 tools/testing/selftests/kvm/lib/x86/ucall.c   |  2 +-
 tools/testing/selftests/kvm/lib/x86/vmx.c     |  4 +--
 .../selftests/kvm/riscv/sbi_pmu_test.c        |  2 +-
 tools/testing/selftests/kvm/s390/memop.c      |  6 ++--
 tools/testing/selftests/kvm/s390/tprot.c      |  6 ++--
 tools/testing/selftests/kvm/steal_time.c      |  2 +-
 tools/testing/selftests/kvm/x86/amx_test.c    |  2 +-
 .../selftests/kvm/x86/aperfmperf_test.c       |  2 +-
 tools/testing/selftests/kvm/x86/cpuid_test.c  |  6 ++--
 .../kvm/x86/evmcs_smm_controls_test.c         |  2 +-
 .../testing/selftests/kvm/x86/hyperv_clock.c  |  2 +-
 .../testing/selftests/kvm/x86/hyperv_evmcs.c  |  6 ++--
 .../kvm/x86/hyperv_extended_hypercalls.c      |  6 ++--
 .../selftests/kvm/x86/hyperv_features.c       |  6 ++--
 tools/testing/selftests/kvm/x86/hyperv_ipi.c  |  8 ++---
 .../selftests/kvm/x86/hyperv_svm_test.c       |  6 ++--
 .../selftests/kvm/x86/hyperv_tlb_flush.c      | 12 +++----
 .../selftests/kvm/x86/kvm_buslock_test.c      |  2 +-
 .../selftests/kvm/x86/kvm_clock_test.c        |  2 +-
 .../selftests/kvm/x86/nested_close_kvm_test.c |  2 +-
 .../selftests/kvm/x86/nested_dirty_log_test.c | 10 +++---
 .../selftests/kvm/x86/nested_emulation_test.c |  2 +-
 .../kvm/x86/nested_exceptions_test.c          |  2 +-
 .../kvm/x86/nested_invalid_cr3_test.c         |  2 +-
 .../kvm/x86/nested_tsc_adjust_test.c          |  2 +-
 .../kvm/x86/nested_tsc_scaling_test.c         |  2 +-
 .../kvm/x86/nested_vmsave_vmload_test.c       |  2 +-
 .../selftests/kvm/x86/sev_smoke_test.c        |  2 +-
 tools/testing/selftests/kvm/x86/smm_test.c    |  2 +-
 tools/testing/selftests/kvm/x86/state_test.c  |  2 +-
 .../selftests/kvm/x86/svm_int_ctl_test.c      |  2 +-
 .../selftests/kvm/x86/svm_lbr_nested_state.c  |  2 +-
 .../kvm/x86/svm_nested_clear_efer_svme.c      |  2 +-
 .../kvm/x86/svm_nested_shutdown_test.c        |  2 +-
 .../kvm/x86/svm_nested_soft_inject_test.c     |  4 +--
 .../selftests/kvm/x86/svm_nested_vmcb12_gpa.c |  6 ++--
 .../selftests/kvm/x86/svm_vmcall_test.c       |  2 +-
 .../kvm/x86/triple_fault_event_test.c         |  4 +--
 .../selftests/kvm/x86/vmx_apic_access_test.c  |  2 +-
 .../kvm/x86/vmx_apicv_updates_test.c          |  2 +-
 .../kvm/x86/vmx_invalid_nested_guest_state.c  |  2 +-
 .../kvm/x86/vmx_nested_la57_state_test.c      |  2 +-
 .../kvm/x86/vmx_preemption_timer_test.c       |  2 +-
 .../selftests/kvm/x86/xapic_ipi_test.c        |  2 +-
 71 files changed, 172 insertions(+), 178 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_irq.c b/tools/testing/selftests/kvm/arm64/vgic_irq.c
index 2fb2c7939fe9..da87d049d246 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_irq.c
@@ -731,7 +731,7 @@ static void kvm_inject_get_call(struct kvm_vm *vm, struct ucall *uc,
 		struct kvm_inject_args *args)
 {
 	struct kvm_inject_args *kvm_args_hva;
-	vm_vaddr_t kvm_args_gva;
+	gva_t kvm_args_gva;
 
 	kvm_args_gva = uc->args[1];
 	kvm_args_hva = (struct kvm_inject_args *)addr_gva2hva(vm, kvm_args_gva);
@@ -752,7 +752,7 @@ static void test_vgic(uint32_t nr_irqs, bool level_sensitive, bool eoi_split)
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	struct kvm_inject_args inject_args;
-	vm_vaddr_t args_gva;
+	gva_t args_gva;
 
 	struct test_args args = {
 		.nr_irqs = nr_irqs,
@@ -986,7 +986,7 @@ static void test_vgic_two_cpus(void *gcode)
 	struct kvm_vcpu *vcpus[2];
 	struct test_args args = {};
 	struct kvm_vm *vm;
-	vm_vaddr_t args_gva;
+	gva_t args_gva;
 	int gic_fd, ret;
 
 	vm = vm_create_with_vcpus(2, gcode, vcpus);
diff --git a/tools/testing/selftests/kvm/include/arm64/processor.h b/tools/testing/selftests/kvm/include/arm64/processor.h
index ac97a1c436fc..5b18ffe68789 100644
--- a/tools/testing/selftests/kvm/include/arm64/processor.h
+++ b/tools/testing/selftests/kvm/include/arm64/processor.h
@@ -179,8 +179,8 @@ void vm_install_exception_handler(struct kvm_vm *vm,
 void vm_install_sync_handler(struct kvm_vm *vm,
 		int vector, int ec, handler_fn handler);
 
-uint64_t *virt_get_pte_hva_at_level(struct kvm_vm *vm, vm_vaddr_t gva, int level);
-uint64_t *virt_get_pte_hva(struct kvm_vm *vm, vm_vaddr_t gva);
+uint64_t *virt_get_pte_hva_at_level(struct kvm_vm *vm, gva_t gva, int level);
+uint64_t *virt_get_pte_hva(struct kvm_vm *vm, gva_t gva);
 
 static inline void cpu_relax(void)
 {
diff --git a/tools/testing/selftests/kvm/include/arm64/ucall.h b/tools/testing/selftests/kvm/include/arm64/ucall.h
index 4ec801f37f00..2210d3d94c40 100644
--- a/tools/testing/selftests/kvm/include/arm64/ucall.h
+++ b/tools/testing/selftests/kvm/include/arm64/ucall.h
@@ -10,9 +10,9 @@
  * ucall_exit_mmio_addr holds per-VM values (global data is duplicated by each
  * VM), it must not be accessed from host code.
  */
-extern vm_vaddr_t *ucall_exit_mmio_addr;
+extern gva_t *ucall_exit_mmio_addr;
 
-static inline void ucall_arch_do_ucall(vm_vaddr_t uc)
+static inline void ucall_arch_do_ucall(gva_t uc)
 {
 	WRITE_ONCE(*ucall_exit_mmio_addr, uc);
 }
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index f861242b4ae8..2378dd42c988 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -112,7 +112,7 @@ struct kvm_vm {
 	struct sparsebit *vpages_mapped;
 	bool has_irqchip;
 	vm_paddr_t ucall_mmio_addr;
-	vm_vaddr_t handlers;
+	gva_t handlers;
 	uint32_t dirty_ring_size;
 	uint64_t gpa_tag_mask;
 
@@ -716,22 +716,20 @@ void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa);
 void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot);
 struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id);
 void vm_populate_vaddr_bitmap(struct kvm_vm *vm);
-vm_vaddr_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
-vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
-vm_vaddr_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
+gva_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz, gva_t vaddr_min);
+gva_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, gva_t vaddr_min);
+gva_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, gva_t vaddr_min,
+		       enum kvm_mem_region_type type);
+gva_t vm_vaddr_alloc_shared(struct kvm_vm *vm, size_t sz, gva_t vaddr_min,
 			    enum kvm_mem_region_type type);
-vm_vaddr_t vm_vaddr_alloc_shared(struct kvm_vm *vm, size_t sz,
-				 vm_vaddr_t vaddr_min,
-				 enum kvm_mem_region_type type);
-vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages);
-vm_vaddr_t __vm_vaddr_alloc_page(struct kvm_vm *vm,
-				 enum kvm_mem_region_type type);
-vm_vaddr_t vm_vaddr_alloc_page(struct kvm_vm *vm);
+gva_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages);
+gva_t __vm_vaddr_alloc_page(struct kvm_vm *vm, enum kvm_mem_region_type type);
+gva_t vm_vaddr_alloc_page(struct kvm_vm *vm);
 
 void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 	      unsigned int npages);
 void *addr_gpa2hva(struct kvm_vm *vm, vm_paddr_t gpa);
-void *addr_gva2hva(struct kvm_vm *vm, vm_vaddr_t gva);
+void *addr_gva2hva(struct kvm_vm *vm, gva_t gva);
 vm_paddr_t addr_hva2gpa(struct kvm_vm *vm, void *hva);
 void *addr_gpa2alias(struct kvm_vm *vm, vm_paddr_t gpa);
 
@@ -1131,12 +1129,12 @@ vm_adjust_num_guest_pages(enum vm_guest_mode mode, unsigned int num_guest_pages)
 }
 
 #define sync_global_to_guest(vm, g) ({				\
-	typeof(g) *_p = addr_gva2hva(vm, (vm_vaddr_t)&(g));	\
+	typeof(g) *_p = addr_gva2hva(vm, (gva_t)&(g));		\
 	memcpy(_p, &(g), sizeof(g));				\
 })
 
 #define sync_global_from_guest(vm, g) ({			\
-	typeof(g) *_p = addr_gva2hva(vm, (vm_vaddr_t)&(g));	\
+	typeof(g) *_p = addr_gva2hva(vm, (gva_t)&(g));		\
 	memcpy(&(g), _p, sizeof(g));				\
 })
 
@@ -1147,7 +1145,7 @@ vm_adjust_num_guest_pages(enum vm_guest_mode mode, unsigned int num_guest_pages)
  * undesirable to change the host's copy of the global.
  */
 #define write_guest_global(vm, g, val) ({			\
-	typeof(g) *_p = addr_gva2hva(vm, (vm_vaddr_t)&(g));	\
+	typeof(g) *_p = addr_gva2hva(vm, (gva_t)&(g));		\
 	typeof(g) _val = val;					\
 								\
 	memcpy(_p, &(_val), sizeof(g));				\
@@ -1242,9 +1240,9 @@ static inline void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr
  * Returns the VM physical address of the translated VM virtual
  * address given by @gva.
  */
-vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva);
+vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva);
 
-static inline vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
+static inline vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, gva_t gva)
 {
 	return addr_arch_gva2gpa(vm, gva);
 }
diff --git a/tools/testing/selftests/kvm/include/kvm_util_types.h b/tools/testing/selftests/kvm/include/kvm_util_types.h
index 0366e9bce7f9..f27bd035ea10 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_types.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_types.h
@@ -15,7 +15,7 @@
 #define kvm_static_assert(expr, ...) __kvm_static_assert(expr, ##__VA_ARGS__, #expr)
 
 typedef uint64_t vm_paddr_t; /* Virtual Machine (Guest) physical address */
-typedef uint64_t vm_vaddr_t; /* Virtual Machine (Guest) virtual address */
+typedef uint64_t gva_t; /* Virtual Machine (Guest) virtual address */
 
 #define INVALID_GPA (~(uint64_t)0)
 
diff --git a/tools/testing/selftests/kvm/include/loongarch/ucall.h b/tools/testing/selftests/kvm/include/loongarch/ucall.h
index 4ec801f37f00..2210d3d94c40 100644
--- a/tools/testing/selftests/kvm/include/loongarch/ucall.h
+++ b/tools/testing/selftests/kvm/include/loongarch/ucall.h
@@ -10,9 +10,9 @@
  * ucall_exit_mmio_addr holds per-VM values (global data is duplicated by each
  * VM), it must not be accessed from host code.
  */
-extern vm_vaddr_t *ucall_exit_mmio_addr;
+extern gva_t *ucall_exit_mmio_addr;
 
-static inline void ucall_arch_do_ucall(vm_vaddr_t uc)
+static inline void ucall_arch_do_ucall(gva_t uc)
 {
 	WRITE_ONCE(*ucall_exit_mmio_addr, uc);
 }
diff --git a/tools/testing/selftests/kvm/include/riscv/ucall.h b/tools/testing/selftests/kvm/include/riscv/ucall.h
index a695ae36f3e0..41d56254968e 100644
--- a/tools/testing/selftests/kvm/include/riscv/ucall.h
+++ b/tools/testing/selftests/kvm/include/riscv/ucall.h
@@ -11,7 +11,7 @@ static inline void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
 {
 }
 
-static inline void ucall_arch_do_ucall(vm_vaddr_t uc)
+static inline void ucall_arch_do_ucall(gva_t uc)
 {
 	sbi_ecall(KVM_RISCV_SELFTESTS_SBI_EXT,
 		  KVM_RISCV_SELFTESTS_SBI_UCALL,
diff --git a/tools/testing/selftests/kvm/include/s390/ucall.h b/tools/testing/selftests/kvm/include/s390/ucall.h
index 8035a872a351..befee84c4609 100644
--- a/tools/testing/selftests/kvm/include/s390/ucall.h
+++ b/tools/testing/selftests/kvm/include/s390/ucall.h
@@ -10,7 +10,7 @@ static inline void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
 {
 }
 
-static inline void ucall_arch_do_ucall(vm_vaddr_t uc)
+static inline void ucall_arch_do_ucall(gva_t uc)
 {
 	/* Exit via DIAGNOSE 0x501 (normally used for breakpoints) */
 	asm volatile ("diag 0,%0,0x501" : : "a"(uc) : "memory");
diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
index d9d6581b8d4f..e5499f170834 100644
--- a/tools/testing/selftests/kvm/include/ucall_common.h
+++ b/tools/testing/selftests/kvm/include/ucall_common.h
@@ -30,7 +30,7 @@ struct ucall {
 };
 
 void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa);
-void ucall_arch_do_ucall(vm_vaddr_t uc);
+void ucall_arch_do_ucall(gva_t uc);
 void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu);
 
 void ucall(uint64_t cmd, int nargs, ...);
@@ -48,7 +48,7 @@ int ucall_nr_pages_required(uint64_t page_size);
  * the full ucall() are problematic and/or unwanted.  Note, this will come out
  * as UCALL_NONE on the backend.
  */
-#define GUEST_UCALL_NONE()	ucall_arch_do_ucall((vm_vaddr_t)NULL)
+#define GUEST_UCALL_NONE()	ucall_arch_do_ucall((gva_t)NULL)
 
 #define GUEST_SYNC_ARGS(stage, arg1, arg2, arg3, arg4)	\
 				ucall(UCALL_SYNC, 6, "hello", stage, arg1, arg2, arg3, arg4)
diff --git a/tools/testing/selftests/kvm/include/x86/hyperv.h b/tools/testing/selftests/kvm/include/x86/hyperv.h
index f13e532be240..eedfff3cf102 100644
--- a/tools/testing/selftests/kvm/include/x86/hyperv.h
+++ b/tools/testing/selftests/kvm/include/x86/hyperv.h
@@ -254,8 +254,8 @@
  * Issue a Hyper-V hypercall. Returns exception vector raised or 0, 'hv_status'
  * is set to the hypercall status (if no exception occurred).
  */
-static inline uint8_t __hyperv_hypercall(u64 control, vm_vaddr_t input_address,
-					 vm_vaddr_t output_address,
+static inline uint8_t __hyperv_hypercall(u64 control, gva_t input_address,
+					 gva_t output_address,
 					 uint64_t *hv_status)
 {
 	uint64_t error_code;
@@ -274,8 +274,8 @@ static inline uint8_t __hyperv_hypercall(u64 control, vm_vaddr_t input_address,
 }
 
 /* Issue a Hyper-V hypercall and assert that it succeeded. */
-static inline void hyperv_hypercall(u64 control, vm_vaddr_t input_address,
-				    vm_vaddr_t output_address)
+static inline void hyperv_hypercall(u64 control, gva_t input_address,
+				    gva_t output_address)
 {
 	uint64_t hv_status;
 	uint8_t vector;
@@ -347,7 +347,7 @@ struct hyperv_test_pages {
 };
 
 struct hyperv_test_pages *vcpu_alloc_hyperv_test_pages(struct kvm_vm *vm,
-						       vm_vaddr_t *p_hv_pages_gva);
+						       gva_t *p_hv_pages_gva);
 
 /* HV_X64_MSR_TSC_INVARIANT_CONTROL bits */
 #define HV_INVARIANT_TSC_EXPOSED               BIT_ULL(0)
diff --git a/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h b/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
index be35d26bb320..4c605f624956 100644
--- a/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
+++ b/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
@@ -33,9 +33,9 @@ struct kvm_mmu_arch {
 struct kvm_mmu;
 
 struct kvm_vm_arch {
-	vm_vaddr_t gdt;
-	vm_vaddr_t tss;
-	vm_vaddr_t idt;
+	gva_t gdt;
+	gva_t tss;
+	gva_t idt;
 
 	uint64_t c_bit;
 	uint64_t s_bit;
diff --git a/tools/testing/selftests/kvm/include/x86/svm_util.h b/tools/testing/selftests/kvm/include/x86/svm_util.h
index 5d7c42534bc4..a25b83e2c233 100644
--- a/tools/testing/selftests/kvm/include/x86/svm_util.h
+++ b/tools/testing/selftests/kvm/include/x86/svm_util.h
@@ -56,7 +56,7 @@ static inline void vmmcall(void)
 		"clgi\n"	\
 		)
 
-struct svm_test_data *vcpu_alloc_svm(struct kvm_vm *vm, vm_vaddr_t *p_svm_gva);
+struct svm_test_data *vcpu_alloc_svm(struct kvm_vm *vm, gva_t *p_svm_gva);
 void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void *guest_rsp);
 void run_guest(struct vmcb *vmcb, uint64_t vmcb_gpa);
 
diff --git a/tools/testing/selftests/kvm/include/x86/vmx.h b/tools/testing/selftests/kvm/include/x86/vmx.h
index 92b918700d24..f194723da3d0 100644
--- a/tools/testing/selftests/kvm/include/x86/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86/vmx.h
@@ -550,7 +550,7 @@ union vmx_ctrl_msr {
 	};
 };
 
-struct vmx_pages *vcpu_alloc_vmx(struct kvm_vm *vm, vm_vaddr_t *p_vmx_gva);
+struct vmx_pages *vcpu_alloc_vmx(struct kvm_vm *vm, gva_t *p_vmx_gva);
 bool prepare_for_vmx_operation(struct vmx_pages *vmx);
 void prepare_vmcs(struct vmx_pages *vmx, void *guest_rip, void *guest_rsp);
 bool load_vmcs(struct vmx_pages *vmx);
diff --git a/tools/testing/selftests/kvm/kvm_page_table_test.c b/tools/testing/selftests/kvm/kvm_page_table_test.c
index c60a24a92829..61915fc89c17 100644
--- a/tools/testing/selftests/kvm/kvm_page_table_test.c
+++ b/tools/testing/selftests/kvm/kvm_page_table_test.c
@@ -292,7 +292,7 @@ static struct kvm_vm *pre_init_before_test(enum vm_guest_mode mode, void *arg)
 	ret = sem_init(&test_stage_completed, 0, 0);
 	TEST_ASSERT(ret == 0, "Error in sem_init");
 
-	current_stage = addr_gva2hva(vm, (vm_vaddr_t)(&guest_test_stage));
+	current_stage = addr_gva2hva(vm, (gva_t)(&guest_test_stage));
 	*current_stage = NUM_TEST_STAGES;
 
 	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
index 43ea40edc533..3645acae09ce 100644
--- a/tools/testing/selftests/kvm/lib/arm64/processor.c
+++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
@@ -19,9 +19,9 @@
 
 #define DEFAULT_ARM64_GUEST_STACK_VADDR_MIN	0xac0000
 
-static vm_vaddr_t exception_handlers;
+static gva_t exception_handlers;
 
-static uint64_t pgd_index(struct kvm_vm *vm, vm_vaddr_t gva)
+static uint64_t pgd_index(struct kvm_vm *vm, gva_t gva)
 {
 	unsigned int shift = (vm->mmu.pgtable_levels - 1) * (vm->page_shift - 3) + vm->page_shift;
 	uint64_t mask = (1UL << (vm->va_bits - shift)) - 1;
@@ -29,7 +29,7 @@ static uint64_t pgd_index(struct kvm_vm *vm, vm_vaddr_t gva)
 	return (gva >> shift) & mask;
 }
 
-static uint64_t pud_index(struct kvm_vm *vm, vm_vaddr_t gva)
+static uint64_t pud_index(struct kvm_vm *vm, gva_t gva)
 {
 	unsigned int shift = 2 * (vm->page_shift - 3) + vm->page_shift;
 	uint64_t mask = (1UL << (vm->page_shift - 3)) - 1;
@@ -40,7 +40,7 @@ static uint64_t pud_index(struct kvm_vm *vm, vm_vaddr_t gva)
 	return (gva >> shift) & mask;
 }
 
-static uint64_t pmd_index(struct kvm_vm *vm, vm_vaddr_t gva)
+static uint64_t pmd_index(struct kvm_vm *vm, gva_t gva)
 {
 	unsigned int shift = (vm->page_shift - 3) + vm->page_shift;
 	uint64_t mask = (1UL << (vm->page_shift - 3)) - 1;
@@ -51,7 +51,7 @@ static uint64_t pmd_index(struct kvm_vm *vm, vm_vaddr_t gva)
 	return (gva >> shift) & mask;
 }
 
-static uint64_t pte_index(struct kvm_vm *vm, vm_vaddr_t gva)
+static uint64_t pte_index(struct kvm_vm *vm, gva_t gva)
 {
 	uint64_t mask = (1UL << (vm->page_shift - 3)) - 1;
 	return (gva >> vm->page_shift) & mask;
@@ -181,7 +181,7 @@ void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 	_virt_pg_map(vm, vaddr, paddr, attr_idx);
 }
 
-uint64_t *virt_get_pte_hva_at_level(struct kvm_vm *vm, vm_vaddr_t gva, int level)
+uint64_t *virt_get_pte_hva_at_level(struct kvm_vm *vm, gva_t gva, int level)
 {
 	uint64_t *ptep;
 
@@ -225,12 +225,12 @@ uint64_t *virt_get_pte_hva_at_level(struct kvm_vm *vm, vm_vaddr_t gva, int level
 	exit(EXIT_FAILURE);
 }
 
-uint64_t *virt_get_pte_hva(struct kvm_vm *vm, vm_vaddr_t gva)
+uint64_t *virt_get_pte_hva(struct kvm_vm *vm, gva_t gva)
 {
 	return virt_get_pte_hva_at_level(vm, gva, 3);
 }
 
-vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
+vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva)
 {
 	uint64_t *ptep = virt_get_pte_hva(vm, gva);
 
@@ -539,7 +539,7 @@ void vm_init_descriptor_tables(struct kvm_vm *vm)
 	vm->handlers = __vm_vaddr_alloc(vm, sizeof(struct handlers),
 					vm->page_size, MEM_REGION_DATA);
 
-	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
+	*(gva_t *)addr_gva2hva(vm, (gva_t)(&exception_handlers)) = vm->handlers;
 }
 
 void vm_install_sync_handler(struct kvm_vm *vm, int vector, int ec,
diff --git a/tools/testing/selftests/kvm/lib/arm64/ucall.c b/tools/testing/selftests/kvm/lib/arm64/ucall.c
index ddab0ce89d4d..9ea747982d00 100644
--- a/tools/testing/selftests/kvm/lib/arm64/ucall.c
+++ b/tools/testing/selftests/kvm/lib/arm64/ucall.c
@@ -6,17 +6,17 @@
  */
 #include "kvm_util.h"
 
-vm_vaddr_t *ucall_exit_mmio_addr;
+gva_t *ucall_exit_mmio_addr;
 
 void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
 {
-	vm_vaddr_t mmio_gva = vm_vaddr_unused_gap(vm, vm->page_size, KVM_UTIL_MIN_VADDR);
+	gva_t mmio_gva = vm_vaddr_unused_gap(vm, vm->page_size, KVM_UTIL_MIN_VADDR);
 
 	virt_map(vm, mmio_gva, mmio_gpa, 1);
 
 	vm->ucall_mmio_addr = mmio_gpa;
 
-	write_guest_global(vm, ucall_exit_mmio_addr, (vm_vaddr_t *)mmio_gva);
+	write_guest_global(vm, ucall_exit_mmio_addr, (gva_t *)mmio_gva);
 }
 
 void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
diff --git a/tools/testing/selftests/kvm/lib/elf.c b/tools/testing/selftests/kvm/lib/elf.c
index f34d926d9735..ff90fba3a5c6 100644
--- a/tools/testing/selftests/kvm/lib/elf.c
+++ b/tools/testing/selftests/kvm/lib/elf.c
@@ -157,12 +157,12 @@ void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename)
 			"memsize of 0,\n"
 			"  phdr index: %u p_memsz: 0x%" PRIx64,
 			n1, (uint64_t) phdr.p_memsz);
-		vm_vaddr_t seg_vstart = align_down(phdr.p_vaddr, vm->page_size);
-		vm_vaddr_t seg_vend = phdr.p_vaddr + phdr.p_memsz - 1;
+		gva_t seg_vstart = align_down(phdr.p_vaddr, vm->page_size);
+		gva_t seg_vend = phdr.p_vaddr + phdr.p_memsz - 1;
 		seg_vend |= vm->page_size - 1;
 		size_t seg_size = seg_vend - seg_vstart + 1;
 
-		vm_vaddr_t vaddr = __vm_vaddr_alloc(vm, seg_size, seg_vstart,
+		gva_t vaddr = __vm_vaddr_alloc(vm, seg_size, seg_vstart,
 						    MEM_REGION_CODE);
 		TEST_ASSERT(vaddr == seg_vstart, "Unable to allocate "
 			"virtual memory for segment at requested min addr,\n"
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index f5e076591c64..04a59603e93e 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1386,8 +1386,7 @@ struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
  * TEST_ASSERT failure occurs for invalid input or no area of at least
  * sz unallocated bytes >= vaddr_min is available.
  */
-vm_vaddr_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz,
-			       vm_vaddr_t vaddr_min)
+gva_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz, gva_t vaddr_min)
 {
 	uint64_t pages = (sz + vm->page_size - 1) >> vm->page_shift;
 
@@ -1452,10 +1451,8 @@ vm_vaddr_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz,
 	return pgidx_start * vm->page_size;
 }
 
-static vm_vaddr_t ____vm_vaddr_alloc(struct kvm_vm *vm, size_t sz,
-				     vm_vaddr_t vaddr_min,
-				     enum kvm_mem_region_type type,
-				     bool protected)
+static gva_t ____vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, gva_t vaddr_min,
+				enum kvm_mem_region_type type, bool protected)
 {
 	uint64_t pages = (sz >> vm->page_shift) + ((sz % vm->page_size) != 0);
 
@@ -1468,10 +1465,10 @@ static vm_vaddr_t ____vm_vaddr_alloc(struct kvm_vm *vm, size_t sz,
 	 * Find an unused range of virtual page addresses of at least
 	 * pages in length.
 	 */
-	vm_vaddr_t vaddr_start = vm_vaddr_unused_gap(vm, sz, vaddr_min);
+	gva_t vaddr_start = vm_vaddr_unused_gap(vm, sz, vaddr_min);
 
 	/* Map the virtual pages. */
-	for (vm_vaddr_t vaddr = vaddr_start; pages > 0;
+	for (gva_t vaddr = vaddr_start; pages > 0;
 		pages--, vaddr += vm->page_size, paddr += vm->page_size) {
 
 		virt_pg_map(vm, vaddr, paddr);
@@ -1480,16 +1477,15 @@ static vm_vaddr_t ____vm_vaddr_alloc(struct kvm_vm *vm, size_t sz,
 	return vaddr_start;
 }
 
-vm_vaddr_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
-			    enum kvm_mem_region_type type)
+gva_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, gva_t vaddr_min,
+		       enum kvm_mem_region_type type)
 {
 	return ____vm_vaddr_alloc(vm, sz, vaddr_min, type,
 				  vm_arch_has_protected_memory(vm));
 }
 
-vm_vaddr_t vm_vaddr_alloc_shared(struct kvm_vm *vm, size_t sz,
-				 vm_vaddr_t vaddr_min,
-				 enum kvm_mem_region_type type)
+gva_t vm_vaddr_alloc_shared(struct kvm_vm *vm, size_t sz, gva_t vaddr_min,
+			    enum kvm_mem_region_type type)
 {
 	return ____vm_vaddr_alloc(vm, sz, vaddr_min, type, false);
 }
@@ -1513,7 +1509,7 @@ vm_vaddr_t vm_vaddr_alloc_shared(struct kvm_vm *vm, size_t sz,
  * a unique set of pages, with the minimum real allocation being at least
  * a page. The allocated physical space comes from the TEST_DATA memory region.
  */
-vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min)
+gva_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, gva_t vaddr_min)
 {
 	return __vm_vaddr_alloc(vm, sz, vaddr_min, MEM_REGION_TEST_DATA);
 }
@@ -1532,12 +1528,12 @@ vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min)
  * Allocates at least N system pages worth of bytes within the virtual address
  * space of the vm.
  */
-vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages)
+gva_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages)
 {
 	return vm_vaddr_alloc(vm, nr_pages * getpagesize(), KVM_UTIL_MIN_VADDR);
 }
 
-vm_vaddr_t __vm_vaddr_alloc_page(struct kvm_vm *vm, enum kvm_mem_region_type type)
+gva_t __vm_vaddr_alloc_page(struct kvm_vm *vm, enum kvm_mem_region_type type)
 {
 	return __vm_vaddr_alloc(vm, getpagesize(), KVM_UTIL_MIN_VADDR, type);
 }
@@ -1556,7 +1552,7 @@ vm_vaddr_t __vm_vaddr_alloc_page(struct kvm_vm *vm, enum kvm_mem_region_type typ
  * Allocates at least one system page worth of bytes within the virtual address
  * space of the vm.
  */
-vm_vaddr_t vm_vaddr_alloc_page(struct kvm_vm *vm)
+gva_t vm_vaddr_alloc_page(struct kvm_vm *vm)
 {
 	return vm_vaddr_alloc_pages(vm, 1);
 }
@@ -2161,7 +2157,7 @@ vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm)
  * Return:
  *   Equivalent host virtual address
  */
-void *addr_gva2hva(struct kvm_vm *vm, vm_vaddr_t gva)
+void *addr_gva2hva(struct kvm_vm *vm, gva_t gva)
 {
 	return addr_gpa2hva(vm, addr_gva2gpa(vm, gva));
 }
diff --git a/tools/testing/selftests/kvm/lib/loongarch/processor.c b/tools/testing/selftests/kvm/lib/loongarch/processor.c
index ee4ad3b1d2a4..3b67720fbbe1 100644
--- a/tools/testing/selftests/kvm/lib/loongarch/processor.c
+++ b/tools/testing/selftests/kvm/lib/loongarch/processor.c
@@ -13,9 +13,9 @@
 #define LOONGARCH_GUEST_STACK_VADDR_MIN		0x200000
 
 static vm_paddr_t invalid_pgtable[4];
-static vm_vaddr_t exception_handlers;
+static gva_t exception_handlers;
 
-static uint64_t virt_pte_index(struct kvm_vm *vm, vm_vaddr_t gva, int level)
+static uint64_t virt_pte_index(struct kvm_vm *vm, gva_t gva, int level)
 {
 	unsigned int shift;
 	uint64_t mask;
@@ -72,7 +72,7 @@ static int virt_pte_none(uint64_t *ptep, int level)
 	return *ptep == invalid_pgtable[level];
 }
 
-static uint64_t *virt_populate_pte(struct kvm_vm *vm, vm_vaddr_t gva, int alloc)
+static uint64_t *virt_populate_pte(struct kvm_vm *vm, gva_t gva, int alloc)
 {
 	int level;
 	uint64_t *ptep;
@@ -106,7 +106,7 @@ static uint64_t *virt_populate_pte(struct kvm_vm *vm, vm_vaddr_t gva, int alloc)
 	exit(EXIT_FAILURE);
 }
 
-vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
+vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva)
 {
 	uint64_t *ptep;
 
diff --git a/tools/testing/selftests/kvm/lib/loongarch/ucall.c b/tools/testing/selftests/kvm/lib/loongarch/ucall.c
index fc6cbb50573f..a5aa568f437b 100644
--- a/tools/testing/selftests/kvm/lib/loongarch/ucall.c
+++ b/tools/testing/selftests/kvm/lib/loongarch/ucall.c
@@ -9,17 +9,17 @@
  * ucall_exit_mmio_addr holds per-VM values (global data is duplicated by each
  * VM), it must not be accessed from host code.
  */
-vm_vaddr_t *ucall_exit_mmio_addr;
+gva_t *ucall_exit_mmio_addr;
 
 void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
 {
-	vm_vaddr_t mmio_gva = vm_vaddr_unused_gap(vm, vm->page_size, KVM_UTIL_MIN_VADDR);
+	gva_t mmio_gva = vm_vaddr_unused_gap(vm, vm->page_size, KVM_UTIL_MIN_VADDR);
 
 	virt_map(vm, mmio_gva, mmio_gpa, 1);
 
 	vm->ucall_mmio_addr = mmio_gpa;
 
-	write_guest_global(vm, ucall_exit_mmio_addr, (vm_vaddr_t *)mmio_gva);
+	write_guest_global(vm, ucall_exit_mmio_addr, (gva_t *)mmio_gva);
 }
 
 void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
index 067c6b2c15b0..552628dda4a0 100644
--- a/tools/testing/selftests/kvm/lib/riscv/processor.c
+++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
@@ -15,7 +15,7 @@
 
 #define DEFAULT_RISCV_GUEST_STACK_VADDR_MIN	0xac0000
 
-static vm_vaddr_t exception_handlers;
+static gva_t exception_handlers;
 
 bool __vcpu_has_ext(struct kvm_vcpu *vcpu, uint64_t ext)
 {
@@ -52,7 +52,7 @@ static uint32_t pte_index_shift[] = {
 	PGTBL_L3_INDEX_SHIFT,
 };
 
-static uint64_t pte_index(struct kvm_vm *vm, vm_vaddr_t gva, int level)
+static uint64_t pte_index(struct kvm_vm *vm, gva_t gva, int level)
 {
 	TEST_ASSERT(level > -1,
 		"Negative page table level (%d) not possible", level);
@@ -119,7 +119,7 @@ void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 		PGTBL_PTE_PERM_MASK | PGTBL_PTE_VALID_MASK;
 }
 
-vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
+vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva)
 {
 	uint64_t *ptep;
 	int level = vm->mmu.pgtable_levels - 1;
@@ -452,7 +452,7 @@ void vm_init_vector_tables(struct kvm_vm *vm)
 	vm->handlers = __vm_vaddr_alloc(vm, sizeof(struct handlers),
 				   vm->page_size, MEM_REGION_DATA);
 
-	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
+	*(gva_t *)addr_gva2hva(vm, (gva_t)(&exception_handlers)) = vm->handlers;
 }
 
 void vm_install_exception_handler(struct kvm_vm *vm, int vector, exception_handler_fn handler)
diff --git a/tools/testing/selftests/kvm/lib/s390/processor.c b/tools/testing/selftests/kvm/lib/s390/processor.c
index 6a9a660413a7..e8d3c1d333d5 100644
--- a/tools/testing/selftests/kvm/lib/s390/processor.c
+++ b/tools/testing/selftests/kvm/lib/s390/processor.c
@@ -86,7 +86,7 @@ void virt_arch_pg_map(struct kvm_vm *vm, uint64_t gva, uint64_t gpa)
 	entry[idx] = gpa;
 }
 
-vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
+vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva)
 {
 	int ri, idx;
 	uint64_t *entry;
diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
index 42151e571953..997444178c78 100644
--- a/tools/testing/selftests/kvm/lib/ucall_common.c
+++ b/tools/testing/selftests/kvm/lib/ucall_common.c
@@ -29,7 +29,7 @@ void ucall_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
 {
 	struct ucall_header *hdr;
 	struct ucall *uc;
-	vm_vaddr_t vaddr;
+	gva_t vaddr;
 	int i;
 
 	vaddr = vm_vaddr_alloc_shared(vm, sizeof(*hdr), KVM_UTIL_MIN_VADDR,
@@ -96,7 +96,7 @@ void ucall_assert(uint64_t cmd, const char *exp, const char *file,
 	guest_vsnprintf(uc->buffer, UCALL_BUFFER_LEN, fmt, va);
 	va_end(va);
 
-	ucall_arch_do_ucall((vm_vaddr_t)uc->hva);
+	ucall_arch_do_ucall((gva_t)uc->hva);
 
 	ucall_free(uc);
 }
@@ -113,7 +113,7 @@ void ucall_fmt(uint64_t cmd, const char *fmt, ...)
 	guest_vsnprintf(uc->buffer, UCALL_BUFFER_LEN, fmt, va);
 	va_end(va);
 
-	ucall_arch_do_ucall((vm_vaddr_t)uc->hva);
+	ucall_arch_do_ucall((gva_t)uc->hva);
 
 	ucall_free(uc);
 }
@@ -135,7 +135,7 @@ void ucall(uint64_t cmd, int nargs, ...)
 		WRITE_ONCE(uc->args[i], va_arg(va, uint64_t));
 	va_end(va);
 
-	ucall_arch_do_ucall((vm_vaddr_t)uc->hva);
+	ucall_arch_do_ucall((gva_t)uc->hva);
 
 	ucall_free(uc);
 }
diff --git a/tools/testing/selftests/kvm/lib/x86/hyperv.c b/tools/testing/selftests/kvm/lib/x86/hyperv.c
index 15bc8cd583aa..be8b31572588 100644
--- a/tools/testing/selftests/kvm/lib/x86/hyperv.c
+++ b/tools/testing/selftests/kvm/lib/x86/hyperv.c
@@ -76,9 +76,9 @@ bool kvm_hv_cpu_has(struct kvm_x86_cpu_feature feature)
 }
 
 struct hyperv_test_pages *vcpu_alloc_hyperv_test_pages(struct kvm_vm *vm,
-						       vm_vaddr_t *p_hv_pages_gva)
+						       gva_t *p_hv_pages_gva)
 {
-	vm_vaddr_t hv_pages_gva = vm_vaddr_alloc_page(vm);
+	gva_t hv_pages_gva = vm_vaddr_alloc_page(vm);
 	struct hyperv_test_pages *hv = addr_gva2hva(vm, hv_pages_gva);
 
 	/* Setup of a region of guest memory for the VP Assist page. */
diff --git a/tools/testing/selftests/kvm/lib/x86/memstress.c b/tools/testing/selftests/kvm/lib/x86/memstress.c
index f53414ba7103..73a82730927d 100644
--- a/tools/testing/selftests/kvm/lib/x86/memstress.c
+++ b/tools/testing/selftests/kvm/lib/x86/memstress.c
@@ -104,7 +104,7 @@ static void memstress_setup_ept_mappings(struct kvm_vm *vm)
 void memstress_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_vcpu *vcpus[])
 {
 	struct kvm_regs regs;
-	vm_vaddr_t nested_gva;
+	gva_t nested_gva;
 	int vcpu_id;
 
 	TEST_REQUIRE(kvm_cpu_has_tdp());
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index 01f0f97d4430..7a01f83cab0b 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -21,7 +21,7 @@
 #define KERNEL_DS	0x10
 #define KERNEL_TSS	0x18
 
-vm_vaddr_t exception_handlers;
+gva_t exception_handlers;
 bool host_cpu_is_amd;
 bool host_cpu_is_intel;
 bool host_cpu_is_hygon;
@@ -618,7 +618,7 @@ static void kvm_seg_set_kernel_data_64bit(struct kvm_segment *segp)
 	segp->present = true;
 }
 
-vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
+vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, gva_t gva)
 {
 	int level = PG_LEVEL_NONE;
 	uint64_t *pte = __vm_get_page_table_entry(vm, &vm->mmu, gva, &level);
@@ -633,7 +633,7 @@ vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 	return vm_untag_gpa(vm, PTE_GET_PA(*pte)) | (gva & ~HUGEPAGE_MASK(level));
 }
 
-static void kvm_seg_set_tss_64bit(vm_vaddr_t base, struct kvm_segment *segp)
+static void kvm_seg_set_tss_64bit(gva_t base, struct kvm_segment *segp)
 {
 	memset(segp, 0, sizeof(*segp));
 	segp->base = base;
@@ -755,7 +755,7 @@ static void vm_init_descriptor_tables(struct kvm_vm *vm)
 	for (i = 0; i < NUM_INTERRUPTS; i++)
 		set_idt_entry(vm, i, (unsigned long)(&idt_handlers)[i], 0, KERNEL_CS);
 
-	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
+	*(gva_t *)addr_gva2hva(vm, (gva_t)(&exception_handlers)) = vm->handlers;
 
 	kvm_seg_set_kernel_code_64bit(&seg);
 	kvm_seg_fill_gdt_64bit(vm, &seg);
@@ -770,9 +770,9 @@ static void vm_init_descriptor_tables(struct kvm_vm *vm)
 void vm_install_exception_handler(struct kvm_vm *vm, int vector,
 			       void (*handler)(struct ex_regs *))
 {
-	vm_vaddr_t *handlers = (vm_vaddr_t *)addr_gva2hva(vm, vm->handlers);
+	gva_t *handlers = (gva_t *)addr_gva2hva(vm, vm->handlers);
 
-	handlers[vector] = (vm_vaddr_t)handler;
+	handlers[vector] = (gva_t)handler;
 }
 
 void assert_on_unhandled_exception(struct kvm_vcpu *vcpu)
@@ -825,7 +825,7 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
 {
 	struct kvm_mp_state mp_state;
 	struct kvm_regs regs;
-	vm_vaddr_t stack_vaddr;
+	gva_t stack_vaddr;
 	struct kvm_vcpu *vcpu;
 
 	stack_vaddr = __vm_vaddr_alloc(vm, DEFAULT_STACK_PGS * getpagesize(),
diff --git a/tools/testing/selftests/kvm/lib/x86/svm.c b/tools/testing/selftests/kvm/lib/x86/svm.c
index eb20b00112c7..4a3b1a2738a2 100644
--- a/tools/testing/selftests/kvm/lib/x86/svm.c
+++ b/tools/testing/selftests/kvm/lib/x86/svm.c
@@ -28,9 +28,9 @@ u64 rflags;
  *   Pointer to structure with the addresses of the SVM areas.
  */
 struct svm_test_data *
-vcpu_alloc_svm(struct kvm_vm *vm, vm_vaddr_t *p_svm_gva)
+vcpu_alloc_svm(struct kvm_vm *vm, gva_t *p_svm_gva)
 {
-	vm_vaddr_t svm_gva = vm_vaddr_alloc_page(vm);
+	gva_t svm_gva = vm_vaddr_alloc_page(vm);
 	struct svm_test_data *svm = addr_gva2hva(vm, svm_gva);
 
 	svm->vmcb = (void *)vm_vaddr_alloc_page(vm);
diff --git a/tools/testing/selftests/kvm/lib/x86/ucall.c b/tools/testing/selftests/kvm/lib/x86/ucall.c
index 1265cecc7dd1..1af2a6880cdf 100644
--- a/tools/testing/selftests/kvm/lib/x86/ucall.c
+++ b/tools/testing/selftests/kvm/lib/x86/ucall.c
@@ -8,7 +8,7 @@
 
 #define UCALL_PIO_PORT ((uint16_t)0x1000)
 
-void ucall_arch_do_ucall(vm_vaddr_t uc)
+void ucall_arch_do_ucall(gva_t uc)
 {
 	/*
 	 * FIXME: Revert this hack (the entire commit that added it) once nVMX
diff --git a/tools/testing/selftests/kvm/lib/x86/vmx.c b/tools/testing/selftests/kvm/lib/x86/vmx.c
index c87b340362a9..a6bb649e62c3 100644
--- a/tools/testing/selftests/kvm/lib/x86/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86/vmx.c
@@ -79,9 +79,9 @@ void vm_enable_ept(struct kvm_vm *vm)
  *   Pointer to structure with the addresses of the VMX areas.
  */
 struct vmx_pages *
-vcpu_alloc_vmx(struct kvm_vm *vm, vm_vaddr_t *p_vmx_gva)
+vcpu_alloc_vmx(struct kvm_vm *vm, gva_t *p_vmx_gva)
 {
-	vm_vaddr_t vmx_gva = vm_vaddr_alloc_page(vm);
+	gva_t vmx_gva = vm_vaddr_alloc_page(vm);
 	struct vmx_pages *vmx = addr_gva2hva(vm, vmx_gva);
 
 	/* Setup of a region of guest memory for the vmxon region. */
diff --git a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
index cec1621ace23..8366c11131ff 100644
--- a/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
+++ b/tools/testing/selftests/kvm/riscv/sbi_pmu_test.c
@@ -610,7 +610,7 @@ static void test_vm_setup_snapshot_mem(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 	virt_map(vm, PMU_SNAPSHOT_GPA_BASE, PMU_SNAPSHOT_GPA_BASE, 1);
 
 	snapshot_gva = (void *)(PMU_SNAPSHOT_GPA_BASE);
-	snapshot_gpa = addr_gva2gpa(vcpu->vm, (vm_vaddr_t)snapshot_gva);
+	snapshot_gpa = addr_gva2gpa(vcpu->vm, (gva_t)snapshot_gva);
 	sync_global_to_guest(vcpu->vm, snapshot_gva);
 	sync_global_to_guest(vcpu->vm, snapshot_gpa);
 }
diff --git a/tools/testing/selftests/kvm/s390/memop.c b/tools/testing/selftests/kvm/s390/memop.c
index 4374b4cd2a80..0e8dc8e5d8bd 100644
--- a/tools/testing/selftests/kvm/s390/memop.c
+++ b/tools/testing/selftests/kvm/s390/memop.c
@@ -878,7 +878,7 @@ static void guest_copy_key_fetch_prot_override(void)
 static void test_copy_key_fetch_prot_override(void)
 {
 	struct test_default t = test_default_init(guest_copy_key_fetch_prot_override);
-	vm_vaddr_t guest_0_page, guest_last_page;
+	gva_t guest_0_page, guest_last_page;
 
 	guest_0_page = vm_vaddr_alloc(t.kvm_vm, PAGE_SIZE, 0);
 	guest_last_page = vm_vaddr_alloc(t.kvm_vm, PAGE_SIZE, last_page_addr);
@@ -917,7 +917,7 @@ static void test_copy_key_fetch_prot_override(void)
 static void test_errors_key_fetch_prot_override_not_enabled(void)
 {
 	struct test_default t = test_default_init(guest_copy_key_fetch_prot_override);
-	vm_vaddr_t guest_0_page, guest_last_page;
+	gva_t guest_0_page, guest_last_page;
 
 	guest_0_page = vm_vaddr_alloc(t.kvm_vm, PAGE_SIZE, 0);
 	guest_last_page = vm_vaddr_alloc(t.kvm_vm, PAGE_SIZE, last_page_addr);
@@ -938,7 +938,7 @@ static void test_errors_key_fetch_prot_override_not_enabled(void)
 static void test_errors_key_fetch_prot_override_enabled(void)
 {
 	struct test_default t = test_default_init(guest_copy_key_fetch_prot_override);
-	vm_vaddr_t guest_0_page, guest_last_page;
+	gva_t guest_0_page, guest_last_page;
 
 	guest_0_page = vm_vaddr_alloc(t.kvm_vm, PAGE_SIZE, 0);
 	guest_last_page = vm_vaddr_alloc(t.kvm_vm, PAGE_SIZE, last_page_addr);
diff --git a/tools/testing/selftests/kvm/s390/tprot.c b/tools/testing/selftests/kvm/s390/tprot.c
index 12d5e1cb62e3..fd8e997de693 100644
--- a/tools/testing/selftests/kvm/s390/tprot.c
+++ b/tools/testing/selftests/kvm/s390/tprot.c
@@ -207,7 +207,7 @@ int main(int argc, char *argv[])
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	struct kvm_run *run;
-	vm_vaddr_t guest_0_page;
+	gva_t guest_0_page;
 
 	ksft_print_header();
 	ksft_set_plan(STAGE_END);
@@ -216,7 +216,7 @@ int main(int argc, char *argv[])
 	run = vcpu->run;
 
 	HOST_SYNC(vcpu, STAGE_INIT_SIMPLE);
-	mprotect(addr_gva2hva(vm, (vm_vaddr_t)pages), PAGE_SIZE * 2, PROT_READ);
+	mprotect(addr_gva2hva(vm, (gva_t)pages), PAGE_SIZE * 2, PROT_READ);
 	HOST_SYNC(vcpu, TEST_SIMPLE);
 
 	guest_0_page = vm_vaddr_alloc(vm, PAGE_SIZE, 0);
@@ -229,7 +229,7 @@ int main(int argc, char *argv[])
 		HOST_SYNC(vcpu, STAGE_INIT_FETCH_PROT_OVERRIDE);
 	}
 	if (guest_0_page == 0)
-		mprotect(addr_gva2hva(vm, (vm_vaddr_t)0), PAGE_SIZE, PROT_READ);
+		mprotect(addr_gva2hva(vm, (gva_t)0), PAGE_SIZE, PROT_READ);
 	run->s.regs.crs[0] |= CR0_FETCH_PROTECTION_OVERRIDE;
 	run->kvm_dirty_regs = KVM_SYNC_CRS;
 	HOST_SYNC(vcpu, TEST_FETCH_PROT_OVERRIDE);
diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index efe56a10d13e..d2a513ec7dd5 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -309,7 +309,7 @@ static void steal_time_init(struct kvm_vcpu *vcpu, uint32_t i)
 {
 	/* ST_GPA_BASE is identity mapped */
 	st_gva[i] = (void *)(ST_GPA_BASE + i * STEAL_TIME_SIZE);
-	st_gpa[i] = addr_gva2gpa(vcpu->vm, (vm_vaddr_t)st_gva[i]);
+	st_gpa[i] = addr_gva2gpa(vcpu->vm, (gva_t)st_gva[i]);
 	sync_global_to_guest(vcpu->vm, st_gva[i]);
 	sync_global_to_guest(vcpu->vm, st_gpa[i]);
 }
diff --git a/tools/testing/selftests/kvm/x86/amx_test.c b/tools/testing/selftests/kvm/x86/amx_test.c
index 37b166260ee3..6f934732c014 100644
--- a/tools/testing/selftests/kvm/x86/amx_test.c
+++ b/tools/testing/selftests/kvm/x86/amx_test.c
@@ -236,7 +236,7 @@ int main(int argc, char *argv[])
 	struct kvm_x86_state *state;
 	struct kvm_x86_state *tile_state = NULL;
 	int xsave_restore_size;
-	vm_vaddr_t amx_cfg, tiledata, xstate;
+	gva_t amx_cfg, tiledata, xstate;
 	struct ucall uc;
 	int ret;
 
diff --git a/tools/testing/selftests/kvm/x86/aperfmperf_test.c b/tools/testing/selftests/kvm/x86/aperfmperf_test.c
index 8b15a13df939..2b547fc93ba8 100644
--- a/tools/testing/selftests/kvm/x86/aperfmperf_test.c
+++ b/tools/testing/selftests/kvm/x86/aperfmperf_test.c
@@ -123,7 +123,7 @@ int main(int argc, char *argv[])
 {
 	const bool has_nested = kvm_cpu_has(X86_FEATURE_SVM) || kvm_cpu_has(X86_FEATURE_VMX);
 	uint64_t host_aperf_before, host_mperf_before;
-	vm_vaddr_t nested_test_data_gva;
+	gva_t nested_test_data_gva;
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	int msr_fd, cpu, i;
diff --git a/tools/testing/selftests/kvm/x86/cpuid_test.c b/tools/testing/selftests/kvm/x86/cpuid_test.c
index f9ed14996977..3c45249a42c4 100644
--- a/tools/testing/selftests/kvm/x86/cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86/cpuid_test.c
@@ -140,10 +140,10 @@ static void run_vcpu(struct kvm_vcpu *vcpu, int stage)
 	}
 }
 
-struct kvm_cpuid2 *vcpu_alloc_cpuid(struct kvm_vm *vm, vm_vaddr_t *p_gva, struct kvm_cpuid2 *cpuid)
+struct kvm_cpuid2 *vcpu_alloc_cpuid(struct kvm_vm *vm, gva_t *p_gva, struct kvm_cpuid2 *cpuid)
 {
 	int size = sizeof(*cpuid) + cpuid->nent * sizeof(cpuid->entries[0]);
-	vm_vaddr_t gva = vm_vaddr_alloc(vm, size, KVM_UTIL_MIN_VADDR);
+	gva_t gva = vm_vaddr_alloc(vm, size, KVM_UTIL_MIN_VADDR);
 	struct kvm_cpuid2 *guest_cpuids = addr_gva2hva(vm, gva);
 
 	memcpy(guest_cpuids, cpuid, size);
@@ -217,7 +217,7 @@ static void test_get_cpuid2(struct kvm_vcpu *vcpu)
 int main(void)
 {
 	struct kvm_vcpu *vcpu;
-	vm_vaddr_t cpuid_gva;
+	gva_t cpuid_gva;
 	struct kvm_vm *vm;
 	int stage;
 
diff --git a/tools/testing/selftests/kvm/x86/evmcs_smm_controls_test.c b/tools/testing/selftests/kvm/x86/evmcs_smm_controls_test.c
index af7c90103396..62cfde273f71 100644
--- a/tools/testing/selftests/kvm/x86/evmcs_smm_controls_test.c
+++ b/tools/testing/selftests/kvm/x86/evmcs_smm_controls_test.c
@@ -73,7 +73,7 @@ static void guest_code(struct vmx_pages *vmx_pages,
 
 int main(int argc, char *argv[])
 {
-	vm_vaddr_t vmx_pages_gva = 0, hv_pages_gva = 0;
+	gva_t vmx_pages_gva = 0, hv_pages_gva = 0;
 	struct hyperv_test_pages *hv;
 	struct hv_enlightened_vmcs *evmcs;
 	struct kvm_vcpu *vcpu;
diff --git a/tools/testing/selftests/kvm/x86/hyperv_clock.c b/tools/testing/selftests/kvm/x86/hyperv_clock.c
index e058bc676cd6..b68844924dc5 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_clock.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_clock.c
@@ -208,7 +208,7 @@ int main(void)
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	struct ucall uc;
-	vm_vaddr_t tsc_page_gva;
+	gva_t tsc_page_gva;
 	int stage;
 
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_HYPERV_TIME));
diff --git a/tools/testing/selftests/kvm/x86/hyperv_evmcs.c b/tools/testing/selftests/kvm/x86/hyperv_evmcs.c
index 74cf19661309..c2de5ac799ee 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_evmcs.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_evmcs.c
@@ -76,7 +76,7 @@ void l2_guest_code(void)
 }
 
 void guest_code(struct vmx_pages *vmx_pages, struct hyperv_test_pages *hv_pages,
-		vm_vaddr_t hv_hcall_page_gpa)
+		gva_t hv_hcall_page_gpa)
 {
 #define L2_GUEST_STACK_SIZE 64
 	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
@@ -231,8 +231,8 @@ static struct kvm_vcpu *save_restore_vm(struct kvm_vm *vm,
 
 int main(int argc, char *argv[])
 {
-	vm_vaddr_t vmx_pages_gva = 0, hv_pages_gva = 0;
-	vm_vaddr_t hcall_page;
+	gva_t vmx_pages_gva = 0, hv_pages_gva = 0;
+	gva_t hcall_page;
 
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
diff --git a/tools/testing/selftests/kvm/x86/hyperv_extended_hypercalls.c b/tools/testing/selftests/kvm/x86/hyperv_extended_hypercalls.c
index 949e08e98f31..7762c168bbf3 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_extended_hypercalls.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_extended_hypercalls.c
@@ -16,7 +16,7 @@
 #define EXT_CAPABILITIES 0xbull
 
 static void guest_code(vm_paddr_t in_pg_gpa, vm_paddr_t out_pg_gpa,
-		       vm_vaddr_t out_pg_gva)
+		       gva_t out_pg_gva)
 {
 	uint64_t *output_gva;
 
@@ -35,8 +35,8 @@ static void guest_code(vm_paddr_t in_pg_gpa, vm_paddr_t out_pg_gpa,
 
 int main(void)
 {
-	vm_vaddr_t hcall_out_page;
-	vm_vaddr_t hcall_in_page;
+	gva_t hcall_out_page;
+	gva_t hcall_in_page;
 	struct kvm_vcpu *vcpu;
 	struct kvm_run *run;
 	struct kvm_vm *vm;
diff --git a/tools/testing/selftests/kvm/x86/hyperv_features.c b/tools/testing/selftests/kvm/x86/hyperv_features.c
index 130b9ce7e5dd..1059fcc460e3 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_features.c
@@ -82,7 +82,7 @@ static void guest_msr(struct msr_data *msr)
 	GUEST_DONE();
 }
 
-static void guest_hcall(vm_vaddr_t pgs_gpa, struct hcall_data *hcall)
+static void guest_hcall(gva_t pgs_gpa, struct hcall_data *hcall)
 {
 	u64 res, input, output;
 	uint8_t vector;
@@ -134,7 +134,7 @@ static void guest_test_msrs_access(void)
 	struct kvm_vm *vm;
 	struct ucall uc;
 	int stage = 0;
-	vm_vaddr_t msr_gva;
+	gva_t msr_gva;
 	struct msr_data *msr;
 	bool has_invtsc = kvm_cpu_has(X86_FEATURE_INVTSC);
 
@@ -523,7 +523,7 @@ static void guest_test_hcalls_access(void)
 	struct kvm_vm *vm;
 	struct ucall uc;
 	int stage = 0;
-	vm_vaddr_t hcall_page, hcall_params;
+	gva_t hcall_page, hcall_params;
 	struct hcall_data *hcall;
 
 	while (true) {
diff --git a/tools/testing/selftests/kvm/x86/hyperv_ipi.c b/tools/testing/selftests/kvm/x86/hyperv_ipi.c
index ca61836c4e32..7d648219833c 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_ipi.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_ipi.c
@@ -45,13 +45,13 @@ struct hv_send_ipi_ex {
 	struct hv_vpset vp_set;
 };
 
-static inline void hv_init(vm_vaddr_t pgs_gpa)
+static inline void hv_init(gva_t pgs_gpa)
 {
 	wrmsr(HV_X64_MSR_GUEST_OS_ID, HYPERV_LINUX_OS_ID);
 	wrmsr(HV_X64_MSR_HYPERCALL, pgs_gpa);
 }
 
-static void receiver_code(void *hcall_page, vm_vaddr_t pgs_gpa)
+static void receiver_code(void *hcall_page, gva_t pgs_gpa)
 {
 	u32 vcpu_id;
 
@@ -85,7 +85,7 @@ static inline void nop_loop(void)
 		asm volatile("nop");
 }
 
-static void sender_guest_code(void *hcall_page, vm_vaddr_t pgs_gpa)
+static void sender_guest_code(void *hcall_page, gva_t pgs_gpa)
 {
 	struct hv_send_ipi *ipi = (struct hv_send_ipi *)hcall_page;
 	struct hv_send_ipi_ex *ipi_ex = (struct hv_send_ipi_ex *)hcall_page;
@@ -243,7 +243,7 @@ int main(int argc, char *argv[])
 {
 	struct kvm_vm *vm;
 	struct kvm_vcpu *vcpu[3];
-	vm_vaddr_t hcall_page;
+	gva_t hcall_page;
 	pthread_t threads[2];
 	int stage = 1, r;
 	struct ucall uc;
diff --git a/tools/testing/selftests/kvm/x86/hyperv_svm_test.c b/tools/testing/selftests/kvm/x86/hyperv_svm_test.c
index 0ddb63229bcb..e0caf5ea14bd 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_svm_test.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_svm_test.c
@@ -67,7 +67,7 @@ void l2_guest_code(void)
 
 static void __attribute__((__flatten__)) guest_code(struct svm_test_data *svm,
 						    struct hyperv_test_pages *hv_pages,
-						    vm_vaddr_t pgs_gpa)
+						    gva_t pgs_gpa)
 {
 	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
 	struct vmcb *vmcb = svm->vmcb;
@@ -149,8 +149,8 @@ static void __attribute__((__flatten__)) guest_code(struct svm_test_data *svm,
 
 int main(int argc, char *argv[])
 {
-	vm_vaddr_t nested_gva = 0, hv_pages_gva = 0;
-	vm_vaddr_t hcall_page;
+	gva_t nested_gva = 0, hv_pages_gva = 0;
+	gva_t hcall_page;
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	struct ucall uc;
diff --git a/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c b/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c
index c542cc4762b1..7f58a5efe6d5 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c
@@ -61,14 +61,14 @@ struct hv_tlb_flush_ex {
  * - GVAs of the test pages' PTEs
  */
 struct test_data {
-	vm_vaddr_t hcall_gva;
+	gva_t hcall_gva;
 	vm_paddr_t hcall_gpa;
-	vm_vaddr_t test_pages;
-	vm_vaddr_t test_pages_pte[NTEST_PAGES];
+	gva_t test_pages;
+	gva_t test_pages_pte[NTEST_PAGES];
 };
 
 /* 'Worker' vCPU code checking the contents of the test page */
-static void worker_guest_code(vm_vaddr_t test_data)
+static void worker_guest_code(gva_t test_data)
 {
 	struct test_data *data = (struct test_data *)test_data;
 	u32 vcpu_id = rdmsr(HV_X64_MSR_VP_INDEX);
@@ -196,7 +196,7 @@ static inline void post_test(struct test_data *data, u64 exp1, u64 exp2)
 #define TESTVAL2 0x0202020202020202
 
 /* Main vCPU doing the test */
-static void sender_guest_code(vm_vaddr_t test_data)
+static void sender_guest_code(gva_t test_data)
 {
 	struct test_data *data = (struct test_data *)test_data;
 	struct hv_tlb_flush *flush = (struct hv_tlb_flush *)data->hcall_gva;
@@ -581,7 +581,7 @@ int main(int argc, char *argv[])
 	struct kvm_vm *vm;
 	struct kvm_vcpu *vcpu[3];
 	pthread_t threads[2];
-	vm_vaddr_t test_data_page, gva;
+	gva_t test_data_page, gva;
 	vm_paddr_t gpa;
 	uint64_t *pte;
 	struct test_data *data;
diff --git a/tools/testing/selftests/kvm/x86/kvm_buslock_test.c b/tools/testing/selftests/kvm/x86/kvm_buslock_test.c
index d88500c118eb..52014a3210c8 100644
--- a/tools/testing/selftests/kvm/x86/kvm_buslock_test.c
+++ b/tools/testing/selftests/kvm/x86/kvm_buslock_test.c
@@ -73,7 +73,7 @@ static void guest_code(void *test_data)
 int main(int argc, char *argv[])
 {
 	const bool has_nested = kvm_cpu_has(X86_FEATURE_SVM) || kvm_cpu_has(X86_FEATURE_VMX);
-	vm_vaddr_t nested_test_data_gva;
+	gva_t nested_test_data_gva;
 	struct kvm_vcpu *vcpu;
 	struct kvm_run *run;
 	struct kvm_vm *vm;
diff --git a/tools/testing/selftests/kvm/x86/kvm_clock_test.c b/tools/testing/selftests/kvm/x86/kvm_clock_test.c
index 5bc12222d87a..e14f7330302e 100644
--- a/tools/testing/selftests/kvm/x86/kvm_clock_test.c
+++ b/tools/testing/selftests/kvm/x86/kvm_clock_test.c
@@ -135,7 +135,7 @@ static void enter_guest(struct kvm_vcpu *vcpu)
 int main(void)
 {
 	struct kvm_vcpu *vcpu;
-	vm_vaddr_t pvti_gva;
+	gva_t pvti_gva;
 	vm_paddr_t pvti_gpa;
 	struct kvm_vm *vm;
 	int flags;
diff --git a/tools/testing/selftests/kvm/x86/nested_close_kvm_test.c b/tools/testing/selftests/kvm/x86/nested_close_kvm_test.c
index f001cb836bfa..761fec293408 100644
--- a/tools/testing/selftests/kvm/x86/nested_close_kvm_test.c
+++ b/tools/testing/selftests/kvm/x86/nested_close_kvm_test.c
@@ -67,7 +67,7 @@ static void l1_guest_code(void *data)
 
 int main(int argc, char *argv[])
 {
-	vm_vaddr_t guest_gva;
+	gva_t guest_gva;
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 
diff --git a/tools/testing/selftests/kvm/x86/nested_dirty_log_test.c b/tools/testing/selftests/kvm/x86/nested_dirty_log_test.c
index 619229bbd693..0e67cce83570 100644
--- a/tools/testing/selftests/kvm/x86/nested_dirty_log_test.c
+++ b/tools/testing/selftests/kvm/x86/nested_dirty_log_test.c
@@ -47,10 +47,10 @@
 #define TEST_SYNC_WRITE_FAULT		BIT(1)
 #define TEST_SYNC_NO_FAULT		BIT(2)
 
-static void l2_guest_code(vm_vaddr_t base)
+static void l2_guest_code(gva_t base)
 {
-	vm_vaddr_t page0 = TEST_GUEST_ADDR(base, 0);
-	vm_vaddr_t page1 = TEST_GUEST_ADDR(base, 1);
+	gva_t page0 = TEST_GUEST_ADDR(base, 0);
+	gva_t page1 = TEST_GUEST_ADDR(base, 1);
 
 	READ_ONCE(*(u64 *)page0);
 	GUEST_SYNC(page0 | TEST_SYNC_READ_FAULT);
@@ -143,7 +143,7 @@ static void l1_guest_code(void *data)
 static void test_handle_ucall_sync(struct kvm_vm *vm, u64 arg,
 				   unsigned long *bmap)
 {
-	vm_vaddr_t gva = arg & ~(PAGE_SIZE - 1);
+	gva_t gva = arg & ~(PAGE_SIZE - 1);
 	int page_nr, i;
 
 	/*
@@ -198,7 +198,7 @@ static void test_handle_ucall_sync(struct kvm_vm *vm, u64 arg,
 
 static void test_dirty_log(bool nested_tdp)
 {
-	vm_vaddr_t nested_gva = 0;
+	gva_t nested_gva = 0;
 	unsigned long *bmap;
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
diff --git a/tools/testing/selftests/kvm/x86/nested_emulation_test.c b/tools/testing/selftests/kvm/x86/nested_emulation_test.c
index abc824dba04f..d398add21e4c 100644
--- a/tools/testing/selftests/kvm/x86/nested_emulation_test.c
+++ b/tools/testing/selftests/kvm/x86/nested_emulation_test.c
@@ -122,7 +122,7 @@ static void guest_code(void *test_data)
 
 int main(int argc, char *argv[])
 {
-	vm_vaddr_t nested_test_data_gva;
+	gva_t nested_test_data_gva;
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 
diff --git a/tools/testing/selftests/kvm/x86/nested_exceptions_test.c b/tools/testing/selftests/kvm/x86/nested_exceptions_test.c
index 3641a42934ac..646cfb0022b3 100644
--- a/tools/testing/selftests/kvm/x86/nested_exceptions_test.c
+++ b/tools/testing/selftests/kvm/x86/nested_exceptions_test.c
@@ -216,7 +216,7 @@ static void queue_ss_exception(struct kvm_vcpu *vcpu, bool inject)
  */
 int main(int argc, char *argv[])
 {
-	vm_vaddr_t nested_test_data_gva;
+	gva_t nested_test_data_gva;
 	struct kvm_vcpu_events events;
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
diff --git a/tools/testing/selftests/kvm/x86/nested_invalid_cr3_test.c b/tools/testing/selftests/kvm/x86/nested_invalid_cr3_test.c
index a6b6da9cf7fe..11fd2467d823 100644
--- a/tools/testing/selftests/kvm/x86/nested_invalid_cr3_test.c
+++ b/tools/testing/selftests/kvm/x86/nested_invalid_cr3_test.c
@@ -78,7 +78,7 @@ int main(int argc, char *argv[])
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
-	vm_vaddr_t guest_gva = 0;
+	gva_t guest_gva = 0;
 
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX) ||
 		     kvm_cpu_has(X86_FEATURE_SVM));
diff --git a/tools/testing/selftests/kvm/x86/nested_tsc_adjust_test.c b/tools/testing/selftests/kvm/x86/nested_tsc_adjust_test.c
index 2839f650e5c9..d9238116d30d 100644
--- a/tools/testing/selftests/kvm/x86/nested_tsc_adjust_test.c
+++ b/tools/testing/selftests/kvm/x86/nested_tsc_adjust_test.c
@@ -125,7 +125,7 @@ static void report(int64_t val)
 
 int main(int argc, char *argv[])
 {
-	vm_vaddr_t nested_gva;
+	gva_t nested_gva;
 	struct kvm_vcpu *vcpu;
 
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX) ||
diff --git a/tools/testing/selftests/kvm/x86/nested_tsc_scaling_test.c b/tools/testing/selftests/kvm/x86/nested_tsc_scaling_test.c
index 4260c9e4f489..b76f29e1e775 100644
--- a/tools/testing/selftests/kvm/x86/nested_tsc_scaling_test.c
+++ b/tools/testing/selftests/kvm/x86/nested_tsc_scaling_test.c
@@ -152,7 +152,7 @@ int main(int argc, char *argv[])
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
-	vm_vaddr_t guest_gva = 0;
+	gva_t guest_gva = 0;
 
 	uint64_t tsc_start, tsc_end;
 	uint64_t tsc_khz;
diff --git a/tools/testing/selftests/kvm/x86/nested_vmsave_vmload_test.c b/tools/testing/selftests/kvm/x86/nested_vmsave_vmload_test.c
index 71717118d692..85d3f4cc76f3 100644
--- a/tools/testing/selftests/kvm/x86/nested_vmsave_vmload_test.c
+++ b/tools/testing/selftests/kvm/x86/nested_vmsave_vmload_test.c
@@ -128,7 +128,7 @@ static void l1_guest_code(struct svm_test_data *svm)
 
 int main(int argc, char *argv[])
 {
-	vm_vaddr_t nested_gva = 0;
+	gva_t nested_gva = 0;
 	struct vmcb *test_vmcb[2];
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
diff --git a/tools/testing/selftests/kvm/x86/sev_smoke_test.c b/tools/testing/selftests/kvm/x86/sev_smoke_test.c
index 8bd37a476f15..dcb3aee699b9 100644
--- a/tools/testing/selftests/kvm/x86/sev_smoke_test.c
+++ b/tools/testing/selftests/kvm/x86/sev_smoke_test.c
@@ -108,7 +108,7 @@ static void test_sync_vmsa(uint32_t type, uint64_t policy)
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
-	vm_vaddr_t gva;
+	gva_t gva;
 	void *hva;
 
 	double x87val = M_PI;
diff --git a/tools/testing/selftests/kvm/x86/smm_test.c b/tools/testing/selftests/kvm/x86/smm_test.c
index ade8412bf94a..3ede3ed8ae5c 100644
--- a/tools/testing/selftests/kvm/x86/smm_test.c
+++ b/tools/testing/selftests/kvm/x86/smm_test.c
@@ -113,7 +113,7 @@ static void guest_code(void *arg)
 
 int main(int argc, char *argv[])
 {
-	vm_vaddr_t nested_gva = 0;
+	gva_t nested_gva = 0;
 
 	struct kvm_vcpu *vcpu;
 	struct kvm_regs regs;
diff --git a/tools/testing/selftests/kvm/x86/state_test.c b/tools/testing/selftests/kvm/x86/state_test.c
index 992a52504a4a..6797da4bd9d9 100644
--- a/tools/testing/selftests/kvm/x86/state_test.c
+++ b/tools/testing/selftests/kvm/x86/state_test.c
@@ -258,7 +258,7 @@ void check_nested_state(int stage, struct kvm_x86_state *state)
 int main(int argc, char *argv[])
 {
 	uint64_t *xstate_bv, saved_xstate_bv;
-	vm_vaddr_t nested_gva = 0;
+	gva_t nested_gva = 0;
 	struct kvm_cpuid2 empty_cpuid = {};
 	struct kvm_regs regs1, regs2;
 	struct kvm_vcpu *vcpu, *vcpuN;
diff --git a/tools/testing/selftests/kvm/x86/svm_int_ctl_test.c b/tools/testing/selftests/kvm/x86/svm_int_ctl_test.c
index 917b6066cfc1..d3cc5e4f7883 100644
--- a/tools/testing/selftests/kvm/x86/svm_int_ctl_test.c
+++ b/tools/testing/selftests/kvm/x86/svm_int_ctl_test.c
@@ -82,7 +82,7 @@ static void l1_guest_code(struct svm_test_data *svm)
 int main(int argc, char *argv[])
 {
 	struct kvm_vcpu *vcpu;
-	vm_vaddr_t svm_gva;
+	gva_t svm_gva;
 	struct kvm_vm *vm;
 	struct ucall uc;
 
diff --git a/tools/testing/selftests/kvm/x86/svm_lbr_nested_state.c b/tools/testing/selftests/kvm/x86/svm_lbr_nested_state.c
index ff99438824d3..7fbfaa054c95 100644
--- a/tools/testing/selftests/kvm/x86/svm_lbr_nested_state.c
+++ b/tools/testing/selftests/kvm/x86/svm_lbr_nested_state.c
@@ -97,9 +97,9 @@ void test_lbrv_nested_state(bool nested_lbrv)
 {
 	struct kvm_x86_state *state = NULL;
 	struct kvm_vcpu *vcpu;
-	vm_vaddr_t svm_gva;
 	struct kvm_vm *vm;
 	struct ucall uc;
+	gva_t svm_gva;
 
 	pr_info("Testing with nested LBRV %s\n", nested_lbrv ? "enabled" : "disabled");
 
diff --git a/tools/testing/selftests/kvm/x86/svm_nested_clear_efer_svme.c b/tools/testing/selftests/kvm/x86/svm_nested_clear_efer_svme.c
index a521a9eed061..6a89eaffc657 100644
--- a/tools/testing/selftests/kvm/x86/svm_nested_clear_efer_svme.c
+++ b/tools/testing/selftests/kvm/x86/svm_nested_clear_efer_svme.c
@@ -38,7 +38,7 @@ int main(int argc, char *argv[])
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
-	vm_vaddr_t nested_gva = 0;
+	gva_t nested_gva = 0;
 
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SVM));
 
diff --git a/tools/testing/selftests/kvm/x86/svm_nested_shutdown_test.c b/tools/testing/selftests/kvm/x86/svm_nested_shutdown_test.c
index 00135cbba35e..c6ea3d609a62 100644
--- a/tools/testing/selftests/kvm/x86/svm_nested_shutdown_test.c
+++ b/tools/testing/selftests/kvm/x86/svm_nested_shutdown_test.c
@@ -42,7 +42,7 @@ static void l1_guest_code(struct svm_test_data *svm, struct idt_entry *idt)
 int main(int argc, char *argv[])
 {
 	struct kvm_vcpu *vcpu;
-	vm_vaddr_t svm_gva;
+	gva_t svm_gva;
 	struct kvm_vm *vm;
 
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SVM));
diff --git a/tools/testing/selftests/kvm/x86/svm_nested_soft_inject_test.c b/tools/testing/selftests/kvm/x86/svm_nested_soft_inject_test.c
index 4bd1655f9e6d..c739d071d3b3 100644
--- a/tools/testing/selftests/kvm/x86/svm_nested_soft_inject_test.c
+++ b/tools/testing/selftests/kvm/x86/svm_nested_soft_inject_test.c
@@ -144,8 +144,8 @@ static void run_test(bool is_nmi)
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
-	vm_vaddr_t svm_gva;
-	vm_vaddr_t idt_alt_vm;
+	gva_t svm_gva;
+	gva_t idt_alt_vm;
 	struct kvm_guest_debug debug;
 
 	pr_info("Running %s test\n", is_nmi ? "NMI" : "soft int");
diff --git a/tools/testing/selftests/kvm/x86/svm_nested_vmcb12_gpa.c b/tools/testing/selftests/kvm/x86/svm_nested_vmcb12_gpa.c
index 569869bed20b..ae8a10913af7 100644
--- a/tools/testing/selftests/kvm/x86/svm_nested_vmcb12_gpa.c
+++ b/tools/testing/selftests/kvm/x86/svm_nested_vmcb12_gpa.c
@@ -74,7 +74,7 @@ static u64 unmappable_gpa(struct kvm_vcpu *vcpu)
 
 static void test_invalid_vmcb12(struct kvm_vcpu *vcpu)
 {
-	vm_vaddr_t nested_gva = 0;
+	gva_t nested_gva = 0;
 	struct ucall uc;
 
 
@@ -90,7 +90,7 @@ static void test_invalid_vmcb12(struct kvm_vcpu *vcpu)
 
 static void test_unmappable_vmcb12(struct kvm_vcpu *vcpu)
 {
-	vm_vaddr_t nested_gva = 0;
+	gva_t nested_gva = 0;
 
 	vcpu_alloc_svm(vcpu->vm, &nested_gva);
 	vcpu_args_set(vcpu, 2, nested_gva, unmappable_gpa(vcpu));
@@ -103,7 +103,7 @@ static void test_unmappable_vmcb12(struct kvm_vcpu *vcpu)
 static void test_unmappable_vmcb12_vmexit(struct kvm_vcpu *vcpu)
 {
 	struct kvm_x86_state *state;
-	vm_vaddr_t nested_gva = 0;
+	gva_t nested_gva = 0;
 	struct ucall uc;
 
 	/*
diff --git a/tools/testing/selftests/kvm/x86/svm_vmcall_test.c b/tools/testing/selftests/kvm/x86/svm_vmcall_test.c
index 8a62cca28cfb..b1887242f3b8 100644
--- a/tools/testing/selftests/kvm/x86/svm_vmcall_test.c
+++ b/tools/testing/selftests/kvm/x86/svm_vmcall_test.c
@@ -36,7 +36,7 @@ static void l1_guest_code(struct svm_test_data *svm)
 int main(int argc, char *argv[])
 {
 	struct kvm_vcpu *vcpu;
-	vm_vaddr_t svm_gva;
+	gva_t svm_gva;
 	struct kvm_vm *vm;
 
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SVM));
diff --git a/tools/testing/selftests/kvm/x86/triple_fault_event_test.c b/tools/testing/selftests/kvm/x86/triple_fault_event_test.c
index 56306a19144a..f1c488e0d497 100644
--- a/tools/testing/selftests/kvm/x86/triple_fault_event_test.c
+++ b/tools/testing/selftests/kvm/x86/triple_fault_event_test.c
@@ -72,13 +72,13 @@ int main(void)
 
 
 	if (has_vmx) {
-		vm_vaddr_t vmx_pages_gva;
+		gva_t vmx_pages_gva;
 
 		vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code_vmx);
 		vcpu_alloc_vmx(vm, &vmx_pages_gva);
 		vcpu_args_set(vcpu, 1, vmx_pages_gva);
 	} else {
-		vm_vaddr_t svm_gva;
+		gva_t svm_gva;
 
 		vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code_svm);
 		vcpu_alloc_svm(vm, &svm_gva);
diff --git a/tools/testing/selftests/kvm/x86/vmx_apic_access_test.c b/tools/testing/selftests/kvm/x86/vmx_apic_access_test.c
index a81a24761aac..dc5c3d1db346 100644
--- a/tools/testing/selftests/kvm/x86/vmx_apic_access_test.c
+++ b/tools/testing/selftests/kvm/x86/vmx_apic_access_test.c
@@ -72,7 +72,7 @@ static void l1_guest_code(struct vmx_pages *vmx_pages, unsigned long high_gpa)
 int main(int argc, char *argv[])
 {
 	unsigned long apic_access_addr = ~0ul;
-	vm_vaddr_t vmx_pages_gva;
+	gva_t vmx_pages_gva;
 	unsigned long high_gpa;
 	struct vmx_pages *vmx;
 	bool done = false;
diff --git a/tools/testing/selftests/kvm/x86/vmx_apicv_updates_test.c b/tools/testing/selftests/kvm/x86/vmx_apicv_updates_test.c
index 337c53fddeff..7f84cc92feaf 100644
--- a/tools/testing/selftests/kvm/x86/vmx_apicv_updates_test.c
+++ b/tools/testing/selftests/kvm/x86/vmx_apicv_updates_test.c
@@ -110,7 +110,7 @@ static void l1_guest_code(struct vmx_pages *vmx_pages)
 
 int main(int argc, char *argv[])
 {
-	vm_vaddr_t vmx_pages_gva;
+	gva_t vmx_pages_gva;
 	struct vmx_pages *vmx;
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
diff --git a/tools/testing/selftests/kvm/x86/vmx_invalid_nested_guest_state.c b/tools/testing/selftests/kvm/x86/vmx_invalid_nested_guest_state.c
index a100ee5f0009..a2eaceed9ad5 100644
--- a/tools/testing/selftests/kvm/x86/vmx_invalid_nested_guest_state.c
+++ b/tools/testing/selftests/kvm/x86/vmx_invalid_nested_guest_state.c
@@ -52,7 +52,7 @@ static void l1_guest_code(struct vmx_pages *vmx_pages)
 
 int main(int argc, char *argv[])
 {
-	vm_vaddr_t vmx_pages_gva;
+	gva_t vmx_pages_gva;
 	struct kvm_sregs sregs;
 	struct kvm_vcpu *vcpu;
 	struct kvm_run *run;
diff --git a/tools/testing/selftests/kvm/x86/vmx_nested_la57_state_test.c b/tools/testing/selftests/kvm/x86/vmx_nested_la57_state_test.c
index 915c42001dba..4ffa11a6bcd8 100644
--- a/tools/testing/selftests/kvm/x86/vmx_nested_la57_state_test.c
+++ b/tools/testing/selftests/kvm/x86/vmx_nested_la57_state_test.c
@@ -73,7 +73,7 @@ void guest_code(struct vmx_pages *vmx_pages)
 
 int main(int argc, char *argv[])
 {
-	vm_vaddr_t vmx_pages_gva = 0;
+	gva_t vmx_pages_gva = 0;
 	struct kvm_vm *vm;
 	struct kvm_vcpu *vcpu;
 	struct kvm_x86_state *state;
diff --git a/tools/testing/selftests/kvm/x86/vmx_preemption_timer_test.c b/tools/testing/selftests/kvm/x86/vmx_preemption_timer_test.c
index 00dd2ac07a61..1b7b6ba23de7 100644
--- a/tools/testing/selftests/kvm/x86/vmx_preemption_timer_test.c
+++ b/tools/testing/selftests/kvm/x86/vmx_preemption_timer_test.c
@@ -152,7 +152,7 @@ void guest_code(struct vmx_pages *vmx_pages)
 
 int main(int argc, char *argv[])
 {
-	vm_vaddr_t vmx_pages_gva = 0;
+	gva_t vmx_pages_gva = 0;
 
 	struct kvm_regs regs1, regs2;
 	struct kvm_vm *vm;
diff --git a/tools/testing/selftests/kvm/x86/xapic_ipi_test.c b/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
index ae4a4b6c05ca..0b10dfbfa3ea 100644
--- a/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
+++ b/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
@@ -393,7 +393,7 @@ int main(int argc, char *argv[])
 	int run_secs = 0;
 	int delay_usecs = 0;
 	struct test_data_page *data;
-	vm_vaddr_t test_data_page_vaddr;
+	gva_t test_data_page_vaddr;
 	bool migrate = false;
 	pthread_t threads[2];
 	struct thread_params params[2];
-- 
2.54.0.rc1.555.g9c883467ad-goog

