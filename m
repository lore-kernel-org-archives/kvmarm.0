Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42A26C43219
	for <kvmarm@archiver.kernel.org>; Tue, 11 Oct 2022 01:06:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED95E4B643;
	Mon, 10 Oct 2022 21:06:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vaMB-jPydgOH; Mon, 10 Oct 2022 21:06:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B50B64B63D;
	Mon, 10 Oct 2022 21:06:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B4034B62F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Oct 2022 21:06:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8dS20J+8tkA2 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Oct 2022 21:06:50 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 52CAF403FD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Oct 2022 21:06:50 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 h4-20020a5b02c4000000b006bc192d672bso12171040ybp.22
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Oct 2022 18:06:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=xfhZy3UUkhriDslFYVDM9M5BDExkncZX0DsGcYX7fbg=;
 b=admd+5/x8wpeJKkVRTO+JUip5gV6XBIFkmir4GdgC2eSEsMzfDSO5ZQshAsiD52f84
 PmeR0g4XO7es/yHVJST8vnjs1QXcJsmlKpWos/1MY1PMaroasIeVW45Sx/CJRbttgPbo
 hvTOcthoK4SZaV0oqCGbMKy3mY+Y5sdt2jS0MOT8zNuWuK+gNl2E1v6pJT+Ml4NCudDQ
 e/LjED9lTE4JR0jr3p4TLJmMYbngAKSymqYpxRijNM7Qv/Fu6wGQL9/iOqWtkysTKEW8
 gkFr3x3uu5hTvb1JuHgQQTPMqCbWPZWNvCqhOj6yEth4cztBAG20dKgGRmnXPOZYfzIH
 N9yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=xfhZy3UUkhriDslFYVDM9M5BDExkncZX0DsGcYX7fbg=;
 b=1Lx1vOE77emeUETUa5RnSUOse51Ig2BsQwGBGH60u8bMB1kkvqn67No+wFQi/GZvaL
 BzDzvl57CNwZZz8rZBp6RYMiyUa/MVXs7OO6dvh9PrL9bBjTZv36aqS/iCe/tL4qzFkY
 0zXve2XT4urQO9Qb7qv6RkEUw3Pc1taiqh/kyUjI8FrrLR6n8XOIpYMuAxaLwrLQ48GI
 HKRBN3Sfme6uDCH5ElzWBVmCjO3dLE2zR1/fCfJWBUO3F5HunfJt+jkkjjqrWsMF8m6S
 kM43OgoAP+bnQfMQrm7flgA9EhUPrdTCTEkTA6OclA+ijWvZ0DtBRal8+8XrvNc+u9UP
 L8Lw==
X-Gm-Message-State: ACrzQf0sTEyy3ftc/0zKdbjUKK5uuipuNebUqdrFPAUCx2L+KRD7KvMN
 apWH7amGN3GMiQg81AAI7jTC5F6ohyr71A==
X-Google-Smtp-Source: AMsMyM6K8mKf7kubU50iXGiAK5FjtnbsyCh1le0Tt8DHH74pM4TSk7C4VDwEmdlpD/akb779t1V37FXog58JtQ==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:6a57:0:b0:6af:c9f1:1f8d with SMTP id
 f84-20020a256a57000000b006afc9f11f8dmr20568767ybc.3.1665450409962; Mon, 10
 Oct 2022 18:06:49 -0700 (PDT)
Date: Tue, 11 Oct 2022 01:06:22 +0000
In-Reply-To: <20221011010628.1734342-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20221011010628.1734342-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221011010628.1734342-9-ricarkol@google.com>
Subject: [PATCH v9 08/14] KVM: selftests: Fix alignment in
 virt_arch_pgd_alloc() and vm_vaddr_alloc()
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
 andrew.jones@linux.dev
Cc: maz@kernel.org, bgardon@google.com, pbonzini@redhat.com,
 axelrasmussen@google.com, dmatlack@google.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Refactor virt_arch_pgd_alloc() and vm_vaddr_alloc() in both RISC-V and
aarch64 to fix the alignment of parameters in a couple of calls. This will
make it easier to fix the alignment in a future commit that adds an extra
parameter (that happens to be very long).

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
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
2.38.0.rc1.362.ged0d419d3c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
