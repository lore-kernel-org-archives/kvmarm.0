Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C142C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 06:02:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 34A3D49EBA;
	Fri, 11 Mar 2022 01:02:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eqOCZpqHOfOh; Fri, 11 Mar 2022 01:02:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F20CB49EC3;
	Fri, 11 Mar 2022 01:02:23 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1850F40C2B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 01:02:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iIJycx0fvM8u for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Mar 2022 01:02:21 -0500 (EST)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C45C240C02
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 01:02:19 -0500 (EST)
Received: by mail-pl1-f201.google.com with SMTP id
 b1-20020a170902bd4100b00151f3f97b0cso4028596plx.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 22:02:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=bQK3tiQaNCPDChbMmIObJpHbjuJxCpHp0ngHczz/K88=;
 b=p0ElfbSfRFbh2onOZMLcgvy7xaQN+L1eRjGbdEdlotyXLZxUvTezAMBNQg23NqVACa
 OIS3GBP+f1CuQU99x8YtcyT2uqeg6UR4tZbWw2+4FcHuMKto0isIwUY8wAeKoV0jrKIl
 AZOc3b34fZbzlEJxzBbYqSaq7Zd9UJEyzLBPj28JHWLikyNK5+NcYqk7fsfDHQf+nrMR
 vCPreel5KxzZrTpDRo/WOViBrz2O1b1aqB5awJd9DVx18IpdzICbmSE0+SjwdAmGq77s
 Qi6WgRnF/DOWrhhn+IlDWNSYmrDkigCUUBCgQdsuKEgJmwOE3LhDin3Ski+hFwiSlSLO
 Cw+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=bQK3tiQaNCPDChbMmIObJpHbjuJxCpHp0ngHczz/K88=;
 b=cGMkg/d/aAyZK+omMextxFll6031+DbDCBZwHmsZg3QEjQ/NM3tfK1t4Cswd3AA9Zw
 b3dHAmodYr4v/7OMIjn2l8T71v1cQWabjWbIFBtuaZD9H6X0E9gdXQa1hG2gX6CINRfu
 lL2jTdWDJZL5xV8fHtqXS7li6YfqajQ4srzpfQDEozKYh/e0wPTh9+/8jxKzXsOMH20J
 5xOWeBtP0wOFpm+ftpSlzMNjgkEbo6EuPTISBVBMZjgSxNN3VkELOY4lMYLF4BWwdSCB
 /4H56fZUCYs8e4m/qDHJ9R9oI9Uoy84nUJDkO2ivx94XkAmKaMukSfuUEUWYLH5JKV6T
 14ag==
X-Gm-Message-State: AOAM531IP1s7LK8wmP/5Y06RqhDLRAqPwBQz1sjAXrl8uwSpNqIaREpr
 X5NiwllEEnsQ3I2GiZkam63otHqMA8LlPA==
X-Google-Smtp-Source: ABdhPJy7CkMfNWO/q7qASHNk+OXFyikAV71Ej2ADGG+MttMyDAp29u5Su8YNs60F3+/3TeijkeLWvjr11PDX7A==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:aa7:8ec2:0:b0:4f7:4a9:7fcd with SMTP id
 b2-20020aa78ec2000000b004f704a97fcdmr8436792pfr.26.1646978538998; Thu, 10 Mar
 2022 22:02:18 -0800 (PST)
Date: Thu, 10 Mar 2022 22:02:01 -0800
In-Reply-To: <20220311060207.2438667-1-ricarkol@google.com>
Message-Id: <20220311060207.2438667-6-ricarkol@google.com>
Mime-Version: 1.0
References: <20220311060207.2438667-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH 05/11] KVM: selftests: aarch64: Export _virt_pg_map with a
 pt_memslot arg
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com
Cc: maz@kernel.org, bgardon@google.com, pbonzini@redhat.com,
 axelrasmussen@google.com
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

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/include/aarch64/processor.h        |  3 +++
 tools/testing/selftests/kvm/lib/aarch64/processor.c  | 12 ++++++------
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index caa572d83062..3965a5ac778e 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -125,6 +125,9 @@ void vm_install_exception_handler(struct kvm_vm *vm,
 void vm_install_sync_handler(struct kvm_vm *vm,
 		int vector, int ec, handler_fn handler);
 
+void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
+			 uint64_t flags, uint32_t pt_memslot);
+
 vm_paddr_t vm_get_pte_gpa(struct kvm_vm *vm, vm_vaddr_t gva);
 
 static inline void cpu_relax(void)
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index ee006d354b79..8f4ec1be4364 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -86,8 +86,8 @@ void virt_pgd_alloc(struct kvm_vm *vm)
 	}
 }
 
-static void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
-			 uint64_t flags)
+void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
+			 uint64_t flags, uint32_t pt_memslot)
 {
 	uint8_t attr_idx = flags & 7;
 	uint64_t *ptep;
@@ -108,18 +108,18 @@ static void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 
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
@@ -136,7 +136,7 @@ void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 {
 	uint64_t attr_idx = 4; /* NORMAL (See DEFAULT_MAIR_EL1) */
 
-	_virt_pg_map(vm, vaddr, paddr, attr_idx);
+	_virt_pg_map(vm, vaddr, paddr, attr_idx, 0);
 }
 
 vm_paddr_t vm_get_pte_gpa(struct kvm_vm *vm, vm_vaddr_t gva)
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
