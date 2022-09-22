Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 958ADC6FA8E
	for <kvmarm@archiver.kernel.org>; Thu, 22 Sep 2022 03:19:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5124C4B282;
	Wed, 21 Sep 2022 23:19:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QXtJMvFFy5b9; Wed, 21 Sep 2022 23:19:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 414A04B285;
	Wed, 21 Sep 2022 23:19:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B0F24B256
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Sep 2022 23:19:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sx-NCFaobO3o for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Sep 2022 23:19:15 -0400 (EDT)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1613D410F3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Sep 2022 23:19:14 -0400 (EDT)
Received: by mail-pl1-f202.google.com with SMTP id
 k2-20020a170902c40200b001782bd6c416so5114927plk.20
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Sep 2022 20:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date;
 bh=liu7uI/e22f8WJg4KuLaGgmLgmCrsiW3uXCrNS+fFnk=;
 b=fXssmAtSBDIn2rfBB4d/5FIiwDq1eTLpavdwubE5eQewmc+0bmawRazFueWyjdXY9L
 tgo6q+2bcERUsk+6eO2GqsdjNhr0J+UT/O0zziO4rIbsWrs0P/lS4CpvktH6YJlTePeX
 tE5Hwl1Fw3FlEoAmFgJSBb6TBTf5rk0qmq+5NNmaK5WdAQMqxKHXi8AxxzbPpWKd449g
 qKFLrNlh2JUSjPxAmeq0W6FuNVl5by2W+2bwpa0Lphnfwo4XHioXyDT9ZG9+hBfdHDTa
 /f3Y+aX2x6lAF/2pKlw8CfxxZBcnimOl6uHxsnRVKfDAsSbjUNDK0ItP3cjM6k846p5p
 QhCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date;
 bh=liu7uI/e22f8WJg4KuLaGgmLgmCrsiW3uXCrNS+fFnk=;
 b=BsksJQJITeJkk3ukvDRYMcSh49ViychJ1RULODM1AuQaFPf03CL4Zd8sLvsc5sNDC0
 XdCNWMhI6V8WIrn5cCVOr/nT1t16OrBhQgh3Kcri8PA4+YXg8lHFuzi1dqNv1/pjEJYn
 mVr0jv1u4wGKLQzt7d1iEZuBDewxWuLNj/lFegJCLkQuGz0066X43DcebloXz77f94Vk
 lpCHYEeFF8UfnypaKvN/4lGcVfZbYeiOP+huEJHnf9UGC4uGtJi6xCWmyNgPXvhcIeU4
 bPer2jX6LYVbfDqg7Eda+9AC9SECl9QmQV/q0bKH/U1hJBbJojYDGnMZdcruBwVR+m30
 5xRA==
X-Gm-Message-State: ACrzQf0ztQBc4Yhbu4wX0jLTH2zdd3KrJgssH+QoDpSzuu3KueGT7Q6H
 gvVjED2hk+nTJSm4b0xv6R/uhdDPWnmWUw==
X-Google-Smtp-Source: AMsMyM78mwru01meZ94QbbtZNQpK6DQ0wTBBe66B9NESWpPDZnszYvOvdyZwVK3YgDjfIB4ig/xQZzBy0wY4iw==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a17:902:c944:b0:178:4568:9f99 with SMTP
 id i4-20020a170902c94400b0017845689f99mr1265948pla.98.1663816753218; Wed, 21
 Sep 2022 20:19:13 -0700 (PDT)
Date: Thu, 22 Sep 2022 03:18:51 +0000
In-Reply-To: <20220922031857.2588688-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20220922031857.2588688-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220922031857.2588688-9-ricarkol@google.com>
Subject: [PATCH v8 08/14] KVM: selftests: Fix alignment in
 virt_arch_pgd_alloc() and vm_vaddr_alloc()
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev
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
2.37.3.968.ga6b4b080e4-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
