Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59E98C43219
	for <kvmarm@archiver.kernel.org>; Mon, 17 Oct 2022 19:58:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E4B444B7EF;
	Mon, 17 Oct 2022 15:58:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rQWxYSNkpV5S; Mon, 17 Oct 2022 15:58:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB1744B743;
	Mon, 17 Oct 2022 15:58:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AF2F4B6DF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Oct 2022 15:58:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QJPwPUyK0rFw for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Oct 2022 15:58:41 -0400 (EDT)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1A6A84B775
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Oct 2022 15:58:41 -0400 (EDT)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-3549b9f0a03so119833877b3.11
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Oct 2022 12:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=QXN3DrxcNJ/Y/78wkRcairOywvsIdqiZwcK1G1DVGE4=;
 b=oeemi9W1/NxTBGN+bi9ENS2eCzjdUF2iUZSF50JhLehojM563m9xTeji358OLyx/Ko
 In2tJJsWxYNooHpB8nCKPIJh7QXAKL8V5cD2diGLIFs1QCtp1KQ35D7UyilwSMEiZvwq
 aNSWvgtXiTIjl8q3nI2kS0UksX3kAnBSUlHLW3GuCoKZnQc5ZI/4+44dlqLd3P9qaoic
 tvGT/l59bDNFqMnaa1KgE2JGsn97IbrxMWIQBPv+VAIuX1foYOuk9F3+uLgFQun37d2c
 vg6d3ZzTlzG+W6vBrw3/y7UQQA6fKOCM0Q3nnUOitNafMD8JWj0v4i4uEJyBt3u2wnGI
 BhxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=QXN3DrxcNJ/Y/78wkRcairOywvsIdqiZwcK1G1DVGE4=;
 b=Vx5iONJAwvtEwnfxjUHWly2zaY7hUyLC369J5a8Ze6JJWFbpwCo4e70QdDK2H1zYhr
 L17wqjX0hLs4I8bj8pjhyxdEYp1P7Hcc6mK7b5y+m59edE8cET/qx/nnrSXBas2e67HW
 vCdf6xtfW0cdNKNSp1n4wnUhHRs7DaB8DwAwyu5KH1Pn4z3D0QBvqeOo2w0B0ud5YzB4
 C/fv9BKXcceMDJHvMVUcsPJUDi+9AtZJ/kAc8+2YAiSnAU8u/IUPTuPux6hktd6kPzSc
 Iah9TT+UfiHUJr2bDBOWI+Lw5RgT5Z1Czs75dlWrTbftVo1m5J5llLKncKZZIKWIhoob
 sDzg==
X-Gm-Message-State: ACrzQf0E//a0NUo2J8am+oTcNHXxn2L3PPIU/CKYiMi0kDRxzE/WllJq
 YLbibsLFaZiO34rxF0dT2pJT6gJFRj+oIQ==
X-Google-Smtp-Source: AMsMyM6uVRlnbaLwPvA5cv3CBaCfTtzZp4rvmAYbniP0zzjm8hjFbla7cidTFWAF8yo4gU9zCY481meE5wgeTg==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a81:ad5d:0:b0:357:1aeb:843d with SMTP id
 l29-20020a81ad5d000000b003571aeb843dmr10576032ywk.44.1666036720654; Mon, 17
 Oct 2022 12:58:40 -0700 (PDT)
Date: Mon, 17 Oct 2022 19:58:22 +0000
In-Reply-To: <20221017195834.2295901-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20221017195834.2295901-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221017195834.2295901-3-ricarkol@google.com>
Subject: [PATCH v10 02/14] KVM: selftests: aarch64: Add virt_get_pte_hva()
 library function
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
2.38.0.413.g74048e4d9e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
