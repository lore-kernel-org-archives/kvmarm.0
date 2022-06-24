Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0672CCA47E
	for <kvmarm@archiver.kernel.org>; Fri, 24 Jun 2022 21:33:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3979549E35;
	Fri, 24 Jun 2022 17:33:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id W+jESSdqS9mk; Fri, 24 Jun 2022 17:33:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 206DB49F0A;
	Fri, 24 Jun 2022 17:33:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1EEE849EDE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jun 2022 17:33:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KYb+vrNqq5Ff for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Jun 2022 17:33:06 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D522441019
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jun 2022 17:33:04 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 92-20020a17090a09e500b001d917022847so1730440pjo.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jun 2022 14:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=/E7cBtwhQeWlJ2/e8yQhI7SinJMEgtQXjp0sOP+6HPI=;
 b=WA6fD4LXAC+4hdOVvDFxL02msgmrqFB06eNhzzNHtZir41tAARyP6q+lG5QjPfUUlU
 x++Hp503zt5xO31KyV2ah4U0u9BFUKAAINqX93oLYKmxBchO0pOEO05rAJ39kZELWKDy
 vOevQteJdFvPTXRQgx0p3hPuR4fDFXVEFQr9B9c4nwo2lV/i5oCJwkgr7TJdce5Zk9UE
 mpKAzNdXG+18DNY7xy3oEJqE5Q2VQ5mGjq6nMrYAC6fy5oZyGSiup9FlhfnCAIxH/h/V
 55iZAEVPoRjDTToRGJaGqNB9W9etrUlZrUJd/pHhbze7sRzUXYoum+rIFha+dCPxc8yS
 jl7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=/E7cBtwhQeWlJ2/e8yQhI7SinJMEgtQXjp0sOP+6HPI=;
 b=H7n//pfKu8gnVHLS1S84HtW7e4R087/fCgjwczClv054wuiZrGV4YfeTqaiNe9hzF+
 4w72826frjcQjlFy3AeEzhelJiHfIJ29APvkRRuAeTGhh335S0kQXpRy16Z1zyQHXYIJ
 sO80JcnIyT2LTJYXU9jkA7qI/7F82RxHd0PmLqb6mvN/MCnDP2sdcnHiO1Wu4ghELaDN
 h7yRQmfPT/reMEXsAkSRlXAJz6n96TMC+7/NTXGsRypQhVO41fL85u30DNLiXWp3p0io
 l2zmeHi2etL94aJXYZhNr/phLvD/zgfnQB+en+YoKtlCMrqrZ/eZ/bSvD5vb+1QIfDCd
 VIfg==
X-Gm-Message-State: AJIora/4/9rpMrDBTrw8c2SSinq87Wc+l+V60TPRGbF3BlyOo3OFsn7p
 9Q/QTFxE9tIqVgcxIdOd30aJA1kF6UukDw==
X-Google-Smtp-Source: AGRyM1tMkZOAPWy+tG5mvLJoE0l1skI8OqXHBmejxdQHH07AlUTOJKDvKPcnQeV0Vojk9fCozl29/tFuNZ8nUA==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:e0c3:b0:16a:1fc3:b6e4 with SMTP
 id e3-20020a170902e0c300b0016a1fc3b6e4mr1154179pla.85.1656106384089; Fri, 24
 Jun 2022 14:33:04 -0700 (PDT)
Date: Fri, 24 Jun 2022 14:32:46 -0700
In-Reply-To: <20220624213257.1504783-1-ricarkol@google.com>
Message-Id: <20220624213257.1504783-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20220624213257.1504783-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH v4 02/13] KVM: selftests: aarch64: Add virt_get_pte_hva
 library function
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

Add a library function to get the PTE (a host virtual address) of a
given GVA.  This will be used in a future commit by a test to clear and
check the access flag of a particular page.

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
2.37.0.rc0.161.g10f37bed90-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
