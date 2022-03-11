Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE510C43217
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 08:49:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E31849F0A;
	Fri, 11 Mar 2022 03:49:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TBVZuEMlgulF; Fri, 11 Mar 2022 03:49:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 948CE49EC5;
	Fri, 11 Mar 2022 03:48:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 661D4408C1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 19:26:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hEtpe6j0ycJV for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Mar 2022 19:26:16 -0500 (EST)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3852D408A7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 19:26:16 -0500 (EST)
Received: by mail-pj1-f73.google.com with SMTP id
 q9-20020a17090a7a8900b001bf0a7d9dfdso4240057pjf.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 16:26:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=C/6kqtgpfTZHxI5VWOjwoNRlEkRWSpZD6XXLim3vJOQ=;
 b=Bs0Nt6VPOSGpoyrAZTXHtLQrqfTnnHH0UC9KK9A0vLWpFqtNCmQ76QkKCaoiU7vlME
 Q0bTazFlFcbJfqcpCjLO9tF13nAtANqrfJ4/weyLzjhfeuO+6qrSrtOmMS7TIYUEvmoj
 3jWCRL/2/6pXWfByCKv+9rhnbh7rbU0XaID/OlkGYUR1Z4dQD7f/Cw2G6GMi4iWL1Uec
 P+O9K7voxCptiW2ggUfO7UL3R6VkHHKXqZbW0O4DhLGBotN31nqItGDXOibW5YjGwp66
 nMmg3cEoPd8Q4NTBLdQxpNMCsJJ+tFv4B4qQ12ZQNrnMrYMMdODRkSRN3LkqTjAlbCWy
 wjpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=C/6kqtgpfTZHxI5VWOjwoNRlEkRWSpZD6XXLim3vJOQ=;
 b=PanOwrzVfdGVpmg0CnUsoAiRVw8LwKLbuKURtcEMWuKOWNE1NER9FDRWao0b8SExrZ
 8TD3XZF1F6iF73tKygmTs2xjeVMBwn5wO2cqg7Focy140F5kViXHJZFfYvbkI84lGV+i
 VVbDCAVFJeOIZPr8tcBx/fcz9F8ifhwTHZt7BRQ9ZDPY2gPm/bCa0Uzgf4sgv0PItySz
 9+6fmzOw+DqJ2oqxXVVQfKHWkIewye+e623xuF1nxt0AEvRvvkHTOdEBURDJMKDwYJtU
 4c+LQRIpTKfrHPDSN2xxvnewvz4PFN+eqJhibd1XxxD/fDFppvIOoIG2KkNIUiE6DMKn
 0M3g==
X-Gm-Message-State: AOAM533WmpVQDq8Vc9NTPqIsQRkN67P28TL1Ofm6nPmjQNa4PPS+Zdne
 le3BoPwecSbB3Oi5I6uix46gpreOrZ/HOw==
X-Google-Smtp-Source: ABdhPJxWLEVXby9lk2SDFDSYjtNrAmaCeZHIJ0XIStrXC375fHHUc9G7571Y4uEmDYxZrmSHCBqVZt0xqwpthw==
X-Received: from dmatlack-heavy.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:12c8:b0:1bf:6484:3e27 with SMTP
 id b8-20020a17090a12c800b001bf64843e27mr7807022pjg.209.1646958375426; Thu, 10
 Mar 2022 16:26:15 -0800 (PST)
Date: Fri, 11 Mar 2022 00:25:28 +0000
In-Reply-To: <20220311002528.2230172-1-dmatlack@google.com>
Message-Id: <20220311002528.2230172-27-dmatlack@google.com>
Mime-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v2 26/26] KVM: selftests: Map x86_64 guest virtual memory with
 huge pages
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailman-Approved-At: Fri, 11 Mar 2022 03:48:42 -0500
Cc: Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>, David Matlack <dmatlack@google.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Ben Gardon <bgardon@google.com>, maciej.szmigiero@oracle.com,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Peter Feiner <pfeiner@google.com>
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

Override virt_map() in x86_64 selftests to use the largest page size
possible when mapping guest virtual memory. This enables testing eager
page splitting with shadow paging (e.g. kvm_intel.ept=N), as it allows
KVM to shadow guest memory with huge pages.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  |  6 ++++
 tools/testing/selftests/kvm/lib/kvm_util.c    |  4 +--
 .../selftests/kvm/lib/x86_64/processor.c      | 31 +++++++++++++++++++
 3 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 37db341d4cc5..efb228d2fbf7 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -470,6 +470,12 @@ enum x86_page_size {
 	X86_PAGE_SIZE_2M,
 	X86_PAGE_SIZE_1G,
 };
+
+static inline size_t page_size_bytes(enum x86_page_size page_size)
+{
+	return 1UL << (page_size * 9 + 12);
+}
+
 void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 		   enum x86_page_size page_size);
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 1665a220abcb..60198587236d 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1432,8 +1432,8 @@ vm_vaddr_t vm_vaddr_alloc_page(struct kvm_vm *vm)
  * Within the VM given by @vm, creates a virtual translation for
  * @npages starting at @vaddr to the page range starting at @paddr.
  */
-void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
-	      unsigned int npages)
+void __weak virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
+		     unsigned int npages)
 {
 	size_t page_size = vm->page_size;
 	size_t size = npages * page_size;
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 9f000dfb5594..7df84292d5de 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -282,6 +282,37 @@ void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 	__virt_pg_map(vm, vaddr, paddr, X86_PAGE_SIZE_4K);
 }
 
+void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, unsigned int npages)
+{
+	size_t size = (size_t) npages * vm->page_size;
+	size_t vend = vaddr + size;
+	enum x86_page_size page_size;
+	size_t stride;
+
+	TEST_ASSERT(vaddr + size > vaddr, "Vaddr overflow");
+	TEST_ASSERT(paddr + size > paddr, "Paddr overflow");
+
+	/*
+	 * Map the region with all 1G pages if possible, falling back to all
+	 * 2M pages, and finally all 4K pages. This could be improved to use
+	 * a mix of page sizes so that more of the region is mapped with large
+	 * pages.
+	 */
+	for (page_size = X86_PAGE_SIZE_1G; page_size >= X86_PAGE_SIZE_4K; page_size--) {
+		stride = page_size_bytes(page_size);
+
+		if (!(vaddr % stride) && !(paddr % stride) && !(size % stride))
+			break;
+	}
+
+	TEST_ASSERT(page_size >= X86_PAGE_SIZE_4K,
+		    "Cannot map unaligned region: vaddr 0x%lx paddr 0x%lx npages 0x%x\n",
+		    vaddr, paddr, npages);
+
+	for (; vaddr < vend; vaddr += stride, paddr += stride)
+		__virt_pg_map(vm, vaddr, paddr, page_size);
+}
+
 static struct pageTableEntry *_vm_get_page_table_entry(struct kvm_vm *vm, int vcpuid,
 						       uint64_t vaddr)
 {
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
