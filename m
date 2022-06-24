Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BA81C43334
	for <kvmarm@archiver.kernel.org>; Fri, 24 Jun 2022 21:33:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F082749EF6;
	Fri, 24 Jun 2022 17:33:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Rh6iy2KkLl1k; Fri, 24 Jun 2022 17:33:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 60D9B49F0A;
	Fri, 24 Jun 2022 17:33:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EE2D49ED1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jun 2022 17:33:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ralo7GFpcyCN for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Jun 2022 17:33:08 -0400 (EDT)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6C67A49EE3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jun 2022 17:33:08 -0400 (EDT)
Received: by mail-pl1-f201.google.com with SMTP id
 l16-20020a170903121000b0016a64bbe81cso1853106plh.11
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jun 2022 14:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=YUm56oivDgN+RP5oA0g2s9n3unpAggk6uf6vDLH3FH4=;
 b=WgPTRm1ERpmL4jqcLWSpoDy77/dfU2P7YjENougX8oSvFRtvVdvYrez9nldzWv4sgH
 JAqU2ErQjdlJ6h0lJurfDi86kJerb+4tmhb6GRJbvzhoNGxRQ6RFqr+c1WkmEiPNgCgY
 vnpssxrwl84jquENHn7m9Mb1unW2XU7uX9E7vcMkG8bFCivqaHJ2O9k3OExy5qjTC5l7
 zfswWmo7mzifSSQ94gdirTjO2NbhmNWrlmT0/bH50yalZAQKDqZaD3jKWmXHxFIwEva1
 r6Tda5OIMFppvuHmzbLQAxxo0wPohxD8XEI4b2ogCy5qrYBTbYW5ZzlTsS+L7NlQlwNe
 bqnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=YUm56oivDgN+RP5oA0g2s9n3unpAggk6uf6vDLH3FH4=;
 b=ZktX7M/yqodvBCYMYrGjwhOM94dALXadzEBe1SxoBpY4qs0L/WE5QLZoD1S76QEdn2
 fo2zUnAVpPFexeEg8anM0PEgSVBMfqTUNktVnE0R2g1guXSYQQhR6zW2BN+qDJVNRbWQ
 e1tbIwTu4L2nf5yAQ50RkOhBwCcvXbvzAPps7A5Op0W2g1ZviDuSxRWxPvNzzafqrhh2
 zENISSnByqBO7nUiqo/nnCu9EuxS2m8sN2lCiYcEiywN/mSJdQ/1ao8wCbhhoOft76Y+
 uoeSRWxxw+uJVwI0Q5tUEplxDdoPSrnwTDYxDWrpgmPLZRqV9nE4Tbm3SgQtFv02voMr
 GkLQ==
X-Gm-Message-State: AJIora+yHQoDaAvp8hzKE8yLwJXUiQsDY7jYVgtopiyd+c1Pi2INsOk7
 YGN/1kuB55uxqMB7k60JOVgdiIvXOlODtw==
X-Google-Smtp-Source: AGRyM1twav2RjNxEnLmJHpien9GiTvNG3d2qoHQES9jZd2VNIqEUDyLCOIYWGE3epI54P1wH8YNze67SsZF2dQ==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:c2ca:b0:168:db72:16a with SMTP id
 c10-20020a170902c2ca00b00168db72016amr1018402pla.171.1656106387722; Fri, 24
 Jun 2022 14:33:07 -0700 (PDT)
Date: Fri, 24 Jun 2022 14:32:48 -0700
In-Reply-To: <20220624213257.1504783-1-ricarkol@google.com>
Message-Id: <20220624213257.1504783-5-ricarkol@google.com>
Mime-Version: 1.0
References: <20220624213257.1504783-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH v4 04/13] KVM: selftests: aarch64: Export _virt_pg_map with a
 pt_memslot arg
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com
Cc: maz@kernel.org, bgardon@google.com, dmatlack@google.com,
 pbonzini@redhat.com, axelrasmussen@google.com
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

Add an argument, pt_memslot, into _virt_pg_map in order to use a
specific memslot for the page-table allocations performed when creating
a new map. This will be used in a future commit to test having PTEs
stored on memslots with different setups (e.g., hugetlb with a hole).

Reviewed-by: Oliver Upton <oupton@google.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/include/aarch64/processor.h        |  3 +++
 tools/testing/selftests/kvm/lib/aarch64/processor.c  | 12 ++++++------
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index df4bfac69551..6649671fa7c1 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -109,6 +109,9 @@ void vm_install_exception_handler(struct kvm_vm *vm,
 void vm_install_sync_handler(struct kvm_vm *vm,
 		int vector, int ec, handler_fn handler);
 
+void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
+			 uint64_t flags, uint32_t pt_memslot);
+
 uint64_t *virt_get_pte_hva(struct kvm_vm *vm, vm_vaddr_t gva);
 
 static inline void cpu_relax(void)
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 63ef3c78e55e..8dd511aa79c2 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -85,8 +85,8 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
 	}
 }
 
-static void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
-			 uint64_t flags)
+void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
+			 uint64_t flags, uint32_t pt_memslot)
 {
 	uint8_t attr_idx = flags & 7;
 	uint64_t *ptep;
@@ -107,18 +107,18 @@ static void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 
 	ptep = addr_gpa2hva(vm, vm->pgd) + pgd_index(vm, vaddr) * 8;
 	if (!*ptep)
-		*ptep = vm_alloc_page_table(vm) | 3;
+		*ptep = vm_alloc_page_table_in_memslot(vm, pt_memslot) | 3;
 
 	switch (vm->pgtable_levels) {
 	case 4:
 		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pud_index(vm, vaddr) * 8;
 		if (!*ptep)
-			*ptep = vm_alloc_page_table(vm) | 3;
+			*ptep = vm_alloc_page_table_in_memslot(vm, pt_memslot) | 3;
 		/* fall through */
 	case 3:
 		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pmd_index(vm, vaddr) * 8;
 		if (!*ptep)
-			*ptep = vm_alloc_page_table(vm) | 3;
+			*ptep = vm_alloc_page_table_in_memslot(vm, pt_memslot) | 3;
 		/* fall through */
 	case 2:
 		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pte_index(vm, vaddr) * 8;
@@ -135,7 +135,7 @@ void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 {
 	uint64_t attr_idx = 4; /* NORMAL (See DEFAULT_MAIR_EL1) */
 
-	_virt_pg_map(vm, vaddr, paddr, attr_idx);
+	_virt_pg_map(vm, vaddr, paddr, attr_idx, 0);
 }
 
 uint64_t *virt_get_pte_hva(struct kvm_vm *vm, vm_vaddr_t gva)
-- 
2.37.0.rc0.161.g10f37bed90-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
