Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D1C5C6FA90
	for <kvmarm@archiver.kernel.org>; Tue, 20 Sep 2022 04:15:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 120CC4B63F;
	Tue, 20 Sep 2022 00:15:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wQ6v4xOhYwlM; Tue, 20 Sep 2022 00:15:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C09794B629;
	Tue, 20 Sep 2022 00:15:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CDA54B600
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 00:15:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B3YlYU5r4v7x for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 00:15:16 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 401554B62A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 00:15:16 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 bu13-20020a056902090d00b00671743601f1so1142640ybb.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2022 21:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date;
 bh=1dmLlVfV3XQMim7N9LUhMLTI6KxQVUDvbYGTx2lRbg8=;
 b=KcsacheBvoBTtwutYkASgDvMhsJttlNfMGwNm/qnBaEwR+K++vD5/0gcPcjU7oEKH+
 iyDNSgGTvmV/LSf4/9jOx83l3nG8Wqp5KfnSBm8Cgkhk78WUEIkqrlxfp0NpQQPwrdKE
 VPIew7wW1kW1oDbIERxQRTKfCL/3hYisd/Fl8l2ry5OW2LRDS0me2yRz5Zz9JHpsuNs2
 xNHYSb8XJwyKivDtX9jac/R4a929ClWvZOMkS+x+tjCCtvEryiVTIDUZIyUIq21ZJ0zl
 eGJ7colHEey6TQebT3YpFCw6GheidpULhx9+QrGORwtcka3IbYvtTd6pDSn7Sdf34j6+
 hKWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date;
 bh=1dmLlVfV3XQMim7N9LUhMLTI6KxQVUDvbYGTx2lRbg8=;
 b=2CnUCQ7Uo177f/8u6ReK1mok9io6VlP64nzEz1uyqFrHHEzP1vxmx+luBuaukHN7YX
 2b3WAr0AXvPKUibOQOMZu7Jx2fRtUdoBUsSVlO4cJLCq72wBpAsXx3cR7P/mF7o/mVXz
 apLAL9lNJLd9zwQjLXFcq/NzcM+LSvETH19T7AVfyaFjPh+WYN4UtWwirgZ6OeaW8s0g
 CANHL5pjS16KTlnfr3B1Yf/2iqjizqIglGCJv6bMVLqEyL2wGtoTt758uwo7P9lXVrf5
 VVL9EKh4dhxb5c3SwRYmRAphhG8n7By3UQhWT4i91V0C/Coqp3jW/BNBA0oTBIQWpLZI
 ksgw==
X-Gm-Message-State: ACrzQf2RuTKCYHjtlf7nl61uzIg8wKoJfciRPwRzQ5MHGwdcpe/Ul2qx
 GPhSlOeZXCVH72TiI4GFgOtL0TgPap2/dA==
X-Google-Smtp-Source: AMsMyM4w/TW6t7ALYUwLVOL4AbvLhEcMAXxCd3cv3LQWgT3THGBCzU/5rahjOxQK0Uj8B9XUhpdcKgs/m1b7Ew==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:3356:0:b0:6af:13b8:f8a4 with SMTP id
 z83-20020a253356000000b006af13b8f8a4mr17691864ybz.52.1663647315737; Mon, 19
 Sep 2022 21:15:15 -0700 (PDT)
Date: Tue, 20 Sep 2022 04:14:58 +0000
In-Reply-To: <20220920041509.3131141-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20220920041509.3131141-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920041509.3131141-3-ricarkol@google.com>
Subject: [PATCH v6 02/13] KVM: selftests: aarch64: Add virt_get_pte_hva()
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
