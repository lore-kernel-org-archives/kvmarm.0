Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12CBFECAAD8
	for <kvmarm@archiver.kernel.org>; Thu, 22 Sep 2022 03:19:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B10D14B0AC;
	Wed, 21 Sep 2022 23:19:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ykSwG3WTUFHV; Wed, 21 Sep 2022 23:19:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 78ED54B0B9;
	Wed, 21 Sep 2022 23:19:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DD09B4B17C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Sep 2022 23:19:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5xSymc1rwkDK for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Sep 2022 23:19:04 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5908C49F3B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Sep 2022 23:19:03 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-340ae84fb7dso67131457b3.17
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Sep 2022 20:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date;
 bh=1dmLlVfV3XQMim7N9LUhMLTI6KxQVUDvbYGTx2lRbg8=;
 b=d5L/Pex/df2nsW03MAou/4OYH9F7wbd4tSrasnOYgq2tk1+iLsC2xAMhzxPZcfBHMJ
 AFRfuoNKJHOUgJeSYrj2RQraX7oo9qFH9QAHoBll9w/ez/ptMh/8HVdSvedF/Rr2Typk
 GmKNLM7BHtYBHC4+zm6s9gw8KIoui0aKbrtC9N48bc1V6Qg8IiFiz0M5tNanJO3CCoqJ
 nwjgkCq6mC4fAy6bbL/KnY96n7HeVSYeebg5jRFNQKMF0woCt/PtXOIeBfWi9W0lpoUk
 5UvB+ogLTMXfg0yw6UbXNYyJjVNe67Khk9EuQjywWTkwGJsOGvEpb7dRR2JfU0juIOqg
 40aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date;
 bh=1dmLlVfV3XQMim7N9LUhMLTI6KxQVUDvbYGTx2lRbg8=;
 b=472ndYil4s0+7EELiwtaN5YAbKlx43JvEBKgSBl/v3hmzyYXgxy1jRSx58BmQCIHbD
 q77AFtWl/zoGOMvA4f+acVEu76LCdFWA4wRdRNKsg+WsxAfaJcDWzcTwN9xMKet/nEnl
 QnR0RTRoPBkwy10fLNJc5r6cfOOoVWfqEN/k10GUbqWwMjp8yrgHZjmSF6wBN+CXriPb
 XsGZ5kJvO0pozO0drGHUG19KlCIYhYQLGhFQoejmqGDpmpedFxkCXY1deO1LONn1fqAs
 WJMWHnBeKvBQI7yXqHBzYxkfjVehr49eVWx9lCuXxoP9kEdCf6hpKgqgHKC1sNCCW+zu
 lbvQ==
X-Gm-Message-State: ACrzQf3IqGe34Tbq0U4CXjk9SSHf+K9Zmct444f7isiUbM89TE6gRiwx
 0g4xDzQ6X3Np7CP2+caWqCtS0g63F3Q5YQ==
X-Google-Smtp-Source: AMsMyM4ZkS/VAsRgzEH2KFBQiF50yhXw75krrcdOmJf/P8jj8u5Z/zMedtfCl9DtWKtF7VbO/1YYyyWLDTSfeA==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:e810:0:b0:6b4:5abb:af39 with SMTP id
 k16-20020a25e810000000b006b45abbaf39mr1592729ybd.158.1663816742842; Wed, 21
 Sep 2022 20:19:02 -0700 (PDT)
Date: Thu, 22 Sep 2022 03:18:45 +0000
In-Reply-To: <20220922031857.2588688-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20220922031857.2588688-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220922031857.2588688-3-ricarkol@google.com>
Subject: [PATCH v8 02/14] KVM: selftests: aarch64: Add virt_get_pte_hva()
 library function
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

Add a library function to get the PTE (a host virtual address) of a
given GVA.  This will be used in a future commit by a test to clear and
check the access flag of a particular page.

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/include/aarch64/processor.h       |  2 ++
 tools/testing/selftests/kvm/lib/aarch64/processor.c | 13 ++++++++++---
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index a8124f9dd68a..df4bfac69551 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -109,6 +109,8 @@ void vm_install_exception_handler(struct kvm_vm *vm,
 void vm_install_sync_handler(struct kvm_vm *vm,
 		int vector, int ec, handler_fn handler);
 
+uint64_t *virt_get_pte_hva(struct kvm_vm *vm, vm_vaddr_t gva);
+
 static inline void cpu_relax(void)
 {
 	asm volatile("yield" ::: "memory");
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 6f5551368944..63ef3c78e55e 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -138,7 +138,7 @@ void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 	_virt_pg_map(vm, vaddr, paddr, attr_idx);
 }
 
-vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
+uint64_t *virt_get_pte_hva(struct kvm_vm *vm, vm_vaddr_t gva)
 {
 	uint64_t *ptep;
 
@@ -169,11 +169,18 @@ vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 		TEST_FAIL("Page table levels must be 2, 3, or 4");
 	}
 
-	return pte_addr(vm, *ptep) + (gva & (vm->page_size - 1));
+	return ptep;
 
 unmapped_gva:
 	TEST_FAIL("No mapping for vm virtual address, gva: 0x%lx", gva);
-	exit(1);
+	exit(EXIT_FAILURE);
+}
+
+vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
+{
+	uint64_t *ptep = virt_get_pte_hva(vm, gva);
+
+	return pte_addr(vm, *ptep) + (gva & (vm->page_size - 1));
 }
 
 static void pte_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent, uint64_t page, int level)
-- 
2.37.3.968.ga6b4b080e4-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
