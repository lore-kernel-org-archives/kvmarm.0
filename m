Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89DC64699
	for <kvmarm@lists.linux.dev>; Mon, 17 Oct 2022 19:58:51 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-364433d6546so18715927b3.18
        for <kvmarm@lists.linux.dev>; Mon, 17 Oct 2022 12:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ats/NAlCS1luK6vF3+RezajfxIpEXVSdMMBn80xOsuk=;
        b=iWt404jTHZJ0mR4SvFltcNN4TOS1tv/w1kVVHlBigojJsUeTDvXkg9US/mW9TxLI2F
         zGf7IwcFbpcFUDB4fJUjL1obA7vxfdbRwsro8wLmz0dqDvky/Smq08v/QsQjaTj4baCb
         wEBxToD/dtwRv+SoHSBHDtDycUShbbW5F/6eX/PIh84Q2wnKM68O9OetBwgwHrZ2gtmx
         V29QR1H4yHXcXJYA35uly8z5WJ8/SA6dKZ9+dDMjygwvx9XmtBA+lUHnGZhClR9euoh5
         CbeD2hf51PcyROIaki06OeVTS/9hKY9V5Gojk6iNZVzwH64iv+c/vRtZ++4hBdQKFkyD
         Tmbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ats/NAlCS1luK6vF3+RezajfxIpEXVSdMMBn80xOsuk=;
        b=BSRNNcQxOS84wRkM/Q1ilmp3dfy2CkRuzih1zTFvGoyXvOp7l23Uxq6JN9NNw97Qek
         M+x4cGBwN8clRmP73CtKxo94dFVj6+LVHl0NF0DKJTdNzmF026XSm+sKKd/6RurZ1YuD
         c3ZRKMvGWiEO5TGi8yrzcRpmqPPkN3eK8JJAD7x6UfXTzyBtPHFvS2q3dvy1pvLtecfH
         ku8pOxr+X8V9sIOPj4vhaxoAI41m1lG7nHGSnf2FZcYeigv3YvpmtuD9pb2XLwhZgFe+
         ctsHDqFyK5e4POdcGsSCMpsFAtcS27rzksw/6w2Bx1aQkO1Ouj/jaLKQHYhtFF6JL0Ac
         1zqQ==
X-Gm-Message-State: ACrzQf1akx8w3PGvTiZ1GvmtFnXlcnKXSCYleE7SmtDBUIwga2+TtxE/
	npboadORAWp2BvfBwRwYKw4w82/ENR8nyg==
X-Google-Smtp-Source: AMsMyM4kGQO3pGz4mHAQtarsKfsT93psIvufIVDDHDh+ck1NaRi2b4Po7h90FryVSnMOJF89NUkDEHDlQyRCBA==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a0d:cb0b:0:b0:364:3815:db17 with SMTP id
 n11-20020a0dcb0b000000b003643815db17mr6232283ywd.479.1666036730678; Mon, 17
 Oct 2022 12:58:50 -0700 (PDT)
Date: Mon, 17 Oct 2022 19:58:28 +0000
In-Reply-To: <20221017195834.2295901-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221017195834.2295901-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221017195834.2295901-9-ricarkol@google.com>
Subject: [PATCH v10 08/14] KVM: selftests: Fix alignment in
 virt_arch_pgd_alloc() and vm_vaddr_alloc()
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
	andrew.jones@linux.dev
Cc: pbonzini@redhat.com, maz@kernel.org, seanjc@google.com, 
	alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com, 
	reijiw@google.com, rananta@google.com, bgardon@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, 
	Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221017195828.C6zz_IucoZnpAL1K7dZqq8CnBposp90BEuugK8j4nX0@z>

Refactor virt_arch_pgd_alloc() and vm_vaddr_alloc() in both RISC-V and
aarch64 to fix the alignment of parameters in a couple of calls. This will
make it easier to fix the alignment in a future commit that adds an extra
parameter (that happens to be very long).

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
---
 .../selftests/kvm/lib/aarch64/processor.c     | 27 ++++++++++---------
 .../selftests/kvm/lib/riscv/processor.c       | 27 ++++++++++---------
 2 files changed, 30 insertions(+), 24 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 26f0eccff6fe..6ff2b9d6cea6 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -76,13 +76,14 @@ static uint64_t __maybe_unused ptrs_per_pte(struct kvm_vm *vm)
 
 void virt_arch_pgd_alloc(struct kvm_vm *vm)
 {
-	if (!vm->pgd_created) {
-		vm_paddr_t paddr = vm_phy_pages_alloc(vm,
-			page_align(vm, ptrs_per_pgd(vm) * 8) / vm->page_size,
-			KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
-		vm->pgd = paddr;
-		vm->pgd_created = true;
-	}
+	size_t nr_pages = page_align(vm, ptrs_per_pgd(vm) * 8) / vm->page_size;
+
+	if (vm->pgd_created)
+		return;
+
+	vm->pgd = vm_phy_pages_alloc(vm, nr_pages,
+				     KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
+	vm->pgd_created = true;
 }
 
 static void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
@@ -325,13 +326,15 @@ void vcpu_arch_dump(FILE *stream, struct kvm_vcpu *vcpu, uint8_t indent)
 struct kvm_vcpu *aarch64_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
 				  struct kvm_vcpu_init *init, void *guest_code)
 {
-	size_t stack_size = vm->page_size == 4096 ?
-					DEFAULT_STACK_PGS * vm->page_size :
-					vm->page_size;
-	uint64_t stack_vaddr = vm_vaddr_alloc(vm, stack_size,
-					      DEFAULT_ARM64_GUEST_STACK_VADDR_MIN);
+	size_t stack_size;
+	uint64_t stack_vaddr;
 	struct kvm_vcpu *vcpu = __vm_vcpu_add(vm, vcpu_id);
 
+	stack_size = vm->page_size == 4096 ? DEFAULT_STACK_PGS * vm->page_size :
+					     vm->page_size;
+	stack_vaddr = vm_vaddr_alloc(vm, stack_size,
+				     DEFAULT_ARM64_GUEST_STACK_VADDR_MIN);
+
 	aarch64_vcpu_setup(vcpu, init);
 
 	vcpu_set_reg(vcpu, ARM64_CORE_REG(sp_el1), stack_vaddr + stack_size);
diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
index 604478151212..ac7fc9d317db 100644
--- a/tools/testing/selftests/kvm/lib/riscv/processor.c
+++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
@@ -55,13 +55,14 @@ static uint64_t pte_index(struct kvm_vm *vm, vm_vaddr_t gva, int level)
 
 void virt_arch_pgd_alloc(struct kvm_vm *vm)
 {
-	if (!vm->pgd_created) {
-		vm_paddr_t paddr = vm_phy_pages_alloc(vm,
-			page_align(vm, ptrs_per_pte(vm) * 8) / vm->page_size,
-			KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
-		vm->pgd = paddr;
-		vm->pgd_created = true;
-	}
+	size_t nr_pages = page_align(vm, ptrs_per_pte(vm) * 8) / vm->page_size;
+
+	if (vm->pgd_created)
+		return;
+
+	vm->pgd = vm_phy_pages_alloc(vm, nr_pages,
+				     KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
+	vm->pgd_created = true;
 }
 
 void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
@@ -279,15 +280,17 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
 				  void *guest_code)
 {
 	int r;
-	size_t stack_size = vm->page_size == 4096 ?
-					DEFAULT_STACK_PGS * vm->page_size :
-					vm->page_size;
-	unsigned long stack_vaddr = vm_vaddr_alloc(vm, stack_size,
-					DEFAULT_RISCV_GUEST_STACK_VADDR_MIN);
+	size_t stack_size;
+	unsigned long stack_vaddr;
 	unsigned long current_gp = 0;
 	struct kvm_mp_state mps;
 	struct kvm_vcpu *vcpu;
 
+	stack_size = vm->page_size == 4096 ? DEFAULT_STACK_PGS * vm->page_size :
+					     vm->page_size;
+	stack_vaddr = vm_vaddr_alloc(vm, stack_size,
+				     DEFAULT_RISCV_GUEST_STACK_VADDR_MIN);
+
 	vcpu = __vm_vcpu_add(vm, vcpu_id);
 	riscv_vcpu_mmu_setup(vcpu);
 
-- 
2.38.0.413.g74048e4d9e-goog

