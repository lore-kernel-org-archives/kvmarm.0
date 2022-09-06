Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27F89ECAAA1
	for <kvmarm@archiver.kernel.org>; Tue,  6 Sep 2022 18:09:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC98D4BC48;
	Tue,  6 Sep 2022 14:09:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id v-6u+1Fw0mlp; Tue,  6 Sep 2022 14:09:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A88694BC6B;
	Tue,  6 Sep 2022 14:09:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D7114BBB4
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2022 14:09:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gEDrDZwsam3v for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Sep 2022 14:09:39 -0400 (EDT)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 65F324BB43
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2022 14:09:39 -0400 (EDT)
Received: by mail-pg1-f201.google.com with SMTP id
 a33-20020a630b61000000b00429d91cc649so6106457pgl.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 06 Sep 2022 11:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date;
 bh=WdKXXyOiNL7tHw4czPZqabS6V/2k1QhfqlT03oehezc=;
 b=AHTPSnI9WzHXRJKYVXhU1NPy3w9I3wq7nZoibVPLBek+eNJ2p7U12Zj2Q7LX4y4zXQ
 dlwj705TeJSYZq0A6FD1T075aVX/4VRVP112xYJQcrcwiNFW1KHwrK3HmsCjbYP3+pyW
 yq8eH+7mdQzLLOiKhCYJtAewr9eLSpaOfftNvAiqIT549eQGyXVNDYllNuTIyM2bysun
 aGoLLMTYsQToKc5OLP34nmYYkdnq6Ea+PZKDy+CPhsZxdsdOklNX2c7FIIrsN9fOSu1H
 qp6QIN8XynxEVU1aFo8N82oYeMtMRpVw8q2NC5bFk3NCep/NXnr+Z751VKOPHCyq/idW
 lJQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date;
 bh=WdKXXyOiNL7tHw4czPZqabS6V/2k1QhfqlT03oehezc=;
 b=vrO8bs/7gapkFagstAgt4i9/xNV33wWlhJ/5CdDnejEUmKclO8WVm0wSlJegfXiAd7
 Ki45dDLIQD02d2D/DdQZU2yJLT6zxVUvREib68W4XpSMI7///ztvKptebmdFNsm9wCVb
 VUFWlaEJZtH9WV/53nDxGQx4jCV7yAB6zq9bbZ6WADWRNTgQWe5Z+ovq2Swf0ylNBaJl
 8SwnP/efylJiLL8WZtGkBWOl5oRRgQ4tVtooQ6UIRK2zAKjtqyiMgAwF+vEwGctvd/M4
 It2P7wDoLJ0CwW1NyCZs2Cx11PNiPlZPFrIxxswTIWrOtaaKyUjua0ZG9Tk9OjoxSEWq
 044A==
X-Gm-Message-State: ACgBeo3AxcRa8czNHnh0FYbyWZEWl7iC9NOttKmMvSsIlhqS8BD8AQE0
 NXsmaMKMmVkAq6JgDgEQbjS/ONUFBDWgUg==
X-Google-Smtp-Source: AA6agR4ac83JgAtiop9Kq9QbBzgDoQaETkNX/tKBEn77W26FNsF/bmL0SV5ArqF2s5Vm9OK1ey6e9aaH57h2yw==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a63:2341:0:b0:434:d9b8:cfdf with SMTP id
 u1-20020a632341000000b00434d9b8cfdfmr753937pgm.446.1662487778403; Tue, 06 Sep
 2022 11:09:38 -0700 (PDT)
Date: Tue,  6 Sep 2022 18:09:19 +0000
In-Reply-To: <20220906180930.230218-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20220906180930.230218-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220906180930.230218-3-ricarkol@google.com>
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
2.37.2.789.g6183377224-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
