Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5691C32793
	for <kvmarm@archiver.kernel.org>; Tue, 23 Aug 2022 23:47:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 84A8C4C5F6;
	Tue, 23 Aug 2022 19:47:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yobZjNceQdaO; Tue, 23 Aug 2022 19:47:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F7584C5EB;
	Tue, 23 Aug 2022 19:47:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 798604C5CC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Aug 2022 19:47:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7b1g8muMgzxg for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Aug 2022 19:47:35 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6B1DB4C5D6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Aug 2022 19:47:35 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-3339532b6a8so262850787b3.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Aug 2022 16:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:from:to:cc;
 bh=J2mkVugn1myDbOEjkjhuVtflf2qvQ8P4WyEoICHnLzA=;
 b=JELmj/sO93tSXizhLkFU0QubCoWU13pb29anAIsUo6DQatVi36NQjSZGF5SjGIRpqF
 0m/Rah1nfiPxJJ0TRcD0zI68yPSF1V8G2r75iAhbHO04aTIsxLNy26PqnRf6H2SM3yIJ
 XlQCfBCLxgW0EtntRomOTyfeWPXnDzs2YnnU7A9oz9wHvvr2kLixVm/kQB3amPcCnskz
 mzn16oxpe46c+lRZKfCHIbB88SZ+gq1+yZQ0GRYYyMndrrxhh6e265RtgqmZw8ROmy43
 xb4IzoHFNxOUFPcDqZ17qBfrxtfP8dKrSyMDkpvk/XNgBcKJ5PknVV0dBdZrg0II8cMx
 cBAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:x-gm-message-state:from:to:cc;
 bh=J2mkVugn1myDbOEjkjhuVtflf2qvQ8P4WyEoICHnLzA=;
 b=exz3/tbkBDkI9P/7bPiCDWtSDDoiZvCIMpcUQsjEOoJH+cfqrkTF3ulxyNPDaG5gWG
 hb4SUhNqiWP4Ym+TJLPlT4eaVjcT/riawLv1LNuoVWSykPpIPAy07OkV0f2fLJu7mleR
 N9RdbBAR1KBhG4/Cb7R1XlhHCHl1kAXxCWg+jmY9vG/oZ+p/OYJynENNtAh+dILGkNt3
 a336UZ/Mr8qm4mUeqqMkPJAU/SqpTcMHBQLp5T4k97XQDPWxOQQKRevtLp6/55wq1qmt
 CIey4zXjnahgaeiHUPw4mojXUFNWFHi0D7yM/tw48AWUYDwySbadjuXiv/hUch7SsM2R
 cKxg==
X-Gm-Message-State: ACgBeo39ppYD+wCLIZ9Z/MtQnasT5bM3wyGwA2m13hTOJrCsJ0Q9QJGu
 dYBwvVHJsliKSPKRuVWHiWAH8ca8Kx9HNQ==
X-Google-Smtp-Source: AA6agR5Qhgrm6tImFEyhevEcXK5yqAkkFa6tItim8V2GuytrVo2Y3sEhv0AsIo9oOk55kQ1fSkauI9WZam8/og==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a0d:f402:0:b0:33c:eda4:8557 with SMTP id
 d2-20020a0df402000000b0033ceda48557mr9862942ywf.183.1661298455045; Tue, 23
 Aug 2022 16:47:35 -0700 (PDT)
Date: Tue, 23 Aug 2022 23:47:16 +0000
In-Reply-To: <20220823234727.621535-1-ricarkol@google.com>
Message-Id: <20220823234727.621535-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20220823234727.621535-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH v5 02/13] KVM: selftests: aarch64: Add virt_get_pte_hva()
 library function
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev
Cc: dmatclack@google.com, maz@kernel.org, bgardon@google.com,
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
2.37.1.595.g718a3a8f04-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
