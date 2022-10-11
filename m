Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64FA5C43217
	for <kvmarm@archiver.kernel.org>; Tue, 11 Oct 2022 01:06:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E2AA44B63D;
	Mon, 10 Oct 2022 21:06:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IdomMySNMI0B; Mon, 10 Oct 2022 21:06:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A4C8F4B0CB;
	Mon, 10 Oct 2022 21:06:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D75F04B3C0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Oct 2022 21:06:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BUl3yPD8tczf for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Oct 2022 21:06:37 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A56374B62D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Oct 2022 21:06:37 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 e15-20020a25370f000000b006be3091eee2so12240782yba.10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Oct 2022 18:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=Hq9NL6B9Os53bTPgTLTOMBGsM6lY0z/4JHp7mLyST1U=;
 b=lkrHQV/0lVpq1npY9LHpffGonYfpeNlunRWanRqfunEzNi/NcefaHQcNSm8i6b+GU7
 j8K6AP95M36DnJphvvI9B7hRpUeiECfr6j3gW7J0sj73Ekcsv1hTGG+t2N+wfUUDU6oR
 lu0GrlM0vFAtxWCpmGs2HZjoHYhxe5Sw+G/DhMRfgYTIDSUbXwdYBIXC04yqLLUJrgxu
 jDI6NwHNSxy7ENngck0izE6Qy5f6kkj+epUcBJZRz34B16rGbqwAyFhK4bNZbgEjc6o6
 mXW78Xf9dEoKzUbpRzEYUsW74h7NPRhf8F9lT7uisjcwgoMD4OXNV0WmcBLfau25SdcZ
 07WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=Hq9NL6B9Os53bTPgTLTOMBGsM6lY0z/4JHp7mLyST1U=;
 b=8EU5oag20SaCzbdFqaoP5VLbjVe+lcf0xunK5ZmLQqVwkP707TKkmtmQk01ieZe0TL
 Mbq2eEH/Nabi+Z1ugb3aDsOnU10dT6ALYzI8DkQHI88XCeFzaHyXxpfVuuOvWiIh3/dT
 AO7ZkQZdMWSBqVK41giE2iplky3z6uh5EHRXqupMSYl1FBxyLCtuozteFQG4kBrDzU3p
 le+8FLJDFw/+sSm+HbwBTq9VIKnppWQuhTMKnixqfQhqkN/T0YMaPkXsbsUXVhZuDhYf
 flbwqMO6YQOJrsBvmLRNLUxT6e2eA0xZNLwccf7L0R4iB1KqQTWdgg+DPocw5AQlkQo9
 RkEA==
X-Gm-Message-State: ACrzQf3YGffWkK/yWVJ743RUUMSv++Jt2UOavQxowLn2wI4gp2sPEVYT
 ZDou59in8pshlUWV/eb7mnVkxMCKzh9dKg==
X-Google-Smtp-Source: AMsMyM5werx4OlUxUq9yYtmxBAkTX+TLMdV2IK95277jRL8MA7+s0rjb4DSqTbsl0obBxVv8WfNgTl1RA9rJdw==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a5b:bca:0:b0:6bf:b0d4:407d with SMTP id
 c10-20020a5b0bca000000b006bfb0d4407dmr16896540ybr.189.1665450397236; Mon, 10
 Oct 2022 18:06:37 -0700 (PDT)
Date: Tue, 11 Oct 2022 01:06:16 +0000
In-Reply-To: <20221011010628.1734342-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20221011010628.1734342-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221011010628.1734342-3-ricarkol@google.com>
Subject: [PATCH v9 02/14] KVM: selftests: aarch64: Add virt_get_pte_hva()
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
2.38.0.rc1.362.ged0d419d3c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
