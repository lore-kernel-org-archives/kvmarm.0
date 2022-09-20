Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30E73C54EE9
	for <kvmarm@archiver.kernel.org>; Tue, 20 Sep 2022 04:26:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC79A4B658;
	Tue, 20 Sep 2022 00:26:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NsSZP0o-tCkT; Tue, 20 Sep 2022 00:26:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD83E4B649;
	Tue, 20 Sep 2022 00:25:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D64804B70F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 00:25:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ktMmie3BPjJV for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 00:25:57 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C95734B69D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 00:25:57 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 f15-20020a17090a664f00b002038154eb4bso683716pjm.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2022 21:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date;
 bh=1dmLlVfV3XQMim7N9LUhMLTI6KxQVUDvbYGTx2lRbg8=;
 b=aosHoqT9RThNoe6VamtssuE/g/+U6tbcYt4qPFtB37IY5Pgq7TvkXhvZv/Tezmsibt
 nSdcxRl4TC+EiTYicXiUdRHl1wryv+m7B3oiFNzlXQB1dr1YydmpWzPT22bgb1FSkLw+
 vZ6GRmU7kkq/HnJMkoksoRE/hpVZAsbYyo4tjvmMxg6EQGSmbD2mTrR/ZZoMUyD6UNks
 HWaC+pW/10LVg+IUOFJiY1YX7airz6RJcruSMQvWWidXq9iP7J3sfZ4FVXG46EvoNe0J
 Av+4QD0GXwrUmEEo4sDDMFa/zLgy4nd0hEVD5XTgYMU/i1kBrih/O2V5MRI0/mjtFV7u
 RlUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date;
 bh=1dmLlVfV3XQMim7N9LUhMLTI6KxQVUDvbYGTx2lRbg8=;
 b=istjSOPIzMgYg7dnpgubyqlCdxEZGIc9UyRVlsLmKo1PJu5Syn1dYL4Zz708Mw6leK
 xwfrLib2DWvRyZbQP7W1zRVGn14dFSyTPZh4lQAfLoMiXg1ZJSwA0ORHVtAKL1AgUPof
 gUNJcfdY7+2yytl5sa0j6R+kFKjg7jt8fS1cRaA6snLEYoVBT8uSZ7FI54tRZ1KMIy+g
 BT2YtqR+m6a2IcYitMAWikbj68cgkSYYYB/2jDUnhvwRBIOaw1oKq8i0BkX4juhBLZC3
 1AzSaIAkc7/EP2zGMurR6WGO1cLjWWusDDfZxGzRnVGXW8WvrZMDI1nsqc06AGz3UD+O
 vV/g==
X-Gm-Message-State: ACrzQf1JruT/s47y7oAwLtEs16t/cHPYkiwSC0iCWSOY0HQRCSS1Mm3W
 F/Fg2hew2g8RSmFEITz8E4mQsMKr40QFJg==
X-Google-Smtp-Source: AMsMyM7tML0kfhsb91m2QQGv5wnNsCscQ9UrJdt1ChXynxWjvefJ75VFez66KA01gGb+cl8htzwVZcmyoW/2yQ==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a63:e709:0:b0:438:98e8:d1c with SMTP id
 b9-20020a63e709000000b0043898e80d1cmr18586866pgi.403.1663647956879; Mon, 19
 Sep 2022 21:25:56 -0700 (PDT)
Date: Tue, 20 Sep 2022 04:25:40 +0000
In-Reply-To: <20220920042551.3154283-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20220920042551.3154283-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920042551.3154283-3-ricarkol@google.com>
Subject: [PATCH v7 02/13] KVM: selftests: aarch64: Add virt_get_pte_hva()
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
