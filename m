Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5DDCC433EF
	for <kvmarm@archiver.kernel.org>; Fri,  8 Apr 2022 00:41:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6159F4B0BF;
	Thu,  7 Apr 2022 20:41:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nhiZQW9eibly; Thu,  7 Apr 2022 20:41:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 262474B0D0;
	Thu,  7 Apr 2022 20:41:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 70CC14B086
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2022 20:41:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Gj8X0N0xAQZv for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Apr 2022 20:41:31 -0400 (EDT)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 754B04B0BA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2022 20:41:30 -0400 (EDT)
Received: by mail-pj1-f74.google.com with SMTP id
 m8-20020a17090aab0800b001cb1320ef6eso2046930pjq.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Apr 2022 17:41:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=KAfe53pKWAZL68142x6k33xnrCZ2swQcXff2G57c/kw=;
 b=R7x2A1GHqSEUwbp3RyEZpy1haZz0x79bvMaIOyfgCDQjCzYtjJBgyUTzal/pX7on/z
 pyi+d3XfXQiXrrUH9EtOHmzz4Lj9WemphCJpjRgJIuCcB6Qk543dE+WBFSuwerNwh0HL
 1x90qVj9xfHsU3R6sQ8eFwqUCog0QN8DcHfE9ICiWjtHOeFHivmS/zONvZLw+LFcgVCU
 obkRjvA7ovoH4Bb480a+XRvrCjmdPrBL2edRp3yHcykJ/8W8lebdYqbfD8X2cLsWGX3l
 mk1rR0AQiWtVLT+8rAT+xWNYoQqGUAD63H7j6zyn4wGEuI49gkgwVgArIgEFnRpYXqJP
 1jxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=KAfe53pKWAZL68142x6k33xnrCZ2swQcXff2G57c/kw=;
 b=2fn56oPC353fTcV+lgkryFuDHAw+zvCactL10WHXHIIT2FAUC3AW/CUqSLfnzMRd0K
 EEYxRzLhQSvv5bHQabFNzzNXhflGRlxh7aUeyw+IGxLrttR19zrV5ve2JiNB65BzWmDk
 CbFrDwPQvGTGl8UIY5Wt80tKXlXJmMkyvBzadcv/e4js0H1smrHzbtFWfjPt6jUR4RZG
 LP4Yc/91+fEK2szGvsollcZxETMu3M67eHOMXecIDTC75C3eRarz1i3wNoVpdhIFufuQ
 pCmE60URPXl4Rce0jCn5kInjXxyHRyzTS9b7vS5Fj/BOyyZSMfQwp4l0p1KiMb1I03Ap
 bo/A==
X-Gm-Message-State: AOAM5335T6CnOdf3zYJDWwOCiaERmDvMaK1FYtZ8s61M6e3Os/8wAfkg
 9NTQoVArd0Zsnotnpu1Lg+TLa2xsuimeXQ==
X-Google-Smtp-Source: ABdhPJy+JrHZpB861uw6fPE5ZifQvEmj2r2MrxGNq54LBdPo29NP4IZe9IfCDi7uv13BtKsv1tHqwXGSCGD1Iw==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:558a:b0:1ca:a819:d2d1 with SMTP
 id c10-20020a17090a558a00b001caa819d2d1mr19006855pji.126.1649378489720; Thu,
 07 Apr 2022 17:41:29 -0700 (PDT)
Date: Thu,  7 Apr 2022 17:41:11 -0700
In-Reply-To: <20220408004120.1969099-1-ricarkol@google.com>
Message-Id: <20220408004120.1969099-5-ricarkol@google.com>
Mime-Version: 1.0
References: <20220408004120.1969099-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v3 04/13] KVM: selftests: aarch64: Export _virt_pg_map with a
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
2.35.1.1178.g4f1659d476-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
