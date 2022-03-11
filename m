Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DB6AC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 06:02:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CEC1349EE7;
	Fri, 11 Mar 2022 01:02:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pn73MgYM0aqB; Fri, 11 Mar 2022 01:02:19 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B9B7D49ED7;
	Fri, 11 Mar 2022 01:02:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D5A040BE7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 01:02:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9zIYpQ51syGU for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Mar 2022 01:02:16 -0500 (EST)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 75C3A49E57
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 01:02:16 -0500 (EST)
Received: by mail-pg1-f202.google.com with SMTP id
 v8-20020a654608000000b0037d5ef9cfa0so4238541pgq.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 22:02:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=KUc4dNO91pxe/NV0PVPkfNxi+9BwbPEO+xnILPLfPtM=;
 b=OWem3wBwWHa+HaaS8WpKJBbzmMF72Cj+Df1b68H+hj8/jon+uQJrz08+ML/M0WqJJ1
 2SaXqEBuLt3uZBIMPZ0oE5QkFVVbwwoE5wJWFRLpvdSXEpKESmZfpezDhuxF621uKGuQ
 rXtV601E/AhPf4YgMyBH4LjaEO6M8oNTBbIxHiur5TT20l9pZwAqQYx9aGauBknmdeQq
 YEfCapjRrzso8wYmMZ1I6oyEAA9CcZnJkteqFu8mQovKsiXdj5L2RSUteZDo2izqb66Q
 V5k1eNjv9Qx7bUK3FxF2bkCWT5gRa8berXIo+1vqOzeVrc5glsskWiD5bAeSzJc3qTLE
 540A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=KUc4dNO91pxe/NV0PVPkfNxi+9BwbPEO+xnILPLfPtM=;
 b=i6+EA2MLyVSeXUy7Sv5g3QUk3+nKl94JsQSJkm40Swy3+9FTaORKrjw3UkI1nMEvgX
 LYypTQqZW1CF2/je7dez7La+AUZptmqAYojLmoBy5wrI5a5r71sWu4E2BFls19n55ZED
 DxcyKYD7FULHW/c423IfUIZ+HuNqUHDbBza6JfHqlH1AgxEWDduAZHZVD4PQ1V7NpVir
 89n9kmG2RqFC6+LZGGnf3lOQ/rotYFIIr74JmHUJcX6hge6lyMbj8kxq4QKAo6t7FS9Z
 fr/DCjeOHL1pYwPxw/+M9k7R49Tzw7RawQbcOa8UDyo5T6p3NLsST1K0fFBR4+tn55JT
 Z2QQ==
X-Gm-Message-State: AOAM532DA8ZkUuWOscV58ytoGdKrNZd7N8f1GAE/MyIMvXUx1Z2TDvIA
 kOvdzBqA/eMaWVWOlbxi/sDzzhBcjbgLvg==
X-Google-Smtp-Source: ABdhPJzk4mG7szV7nhCSQP4wEbEtKHndkNBInkYogcawx/lZmIEZBQ8uLDfqKN6TKj4ltYzJ4pYt4Cq2WbHPmQ==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a05:6a00:1248:b0:4f7:db0:4204 with SMTP
 id u8-20020a056a00124800b004f70db04204mr8469014pfi.27.1646978535585; Thu, 10
 Mar 2022 22:02:15 -0800 (PST)
Date: Thu, 10 Mar 2022 22:01:59 -0800
In-Reply-To: <20220311060207.2438667-1-ricarkol@google.com>
Message-Id: <20220311060207.2438667-4-ricarkol@google.com>
Mime-Version: 1.0
References: <20220311060207.2438667-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH 03/11] KVM: selftests: aarch64: Add vm_get_pte_gpa library
 function
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

Add a library function (in-guest) to get the GPA of the PTE of a
particular GVA.  This will be used in a future commit by a test to clear
and check the AF (access flag) of a particular page.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/include/aarch64/processor.h |  2 ++
 .../selftests/kvm/lib/aarch64/processor.c     | 24 +++++++++++++++++--
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 8f9f46979a00..caa572d83062 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -125,6 +125,8 @@ void vm_install_exception_handler(struct kvm_vm *vm,
 void vm_install_sync_handler(struct kvm_vm *vm,
 		int vector, int ec, handler_fn handler);
 
+vm_paddr_t vm_get_pte_gpa(struct kvm_vm *vm, vm_vaddr_t gva);
+
 static inline void cpu_relax(void)
 {
 	asm volatile("yield" ::: "memory");
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 9343d82519b4..ee006d354b79 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -139,7 +139,7 @@ void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 	_virt_pg_map(vm, vaddr, paddr, attr_idx);
 }
 
-vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
+vm_paddr_t vm_get_pte_gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 {
 	uint64_t *ptep;
 
@@ -162,7 +162,7 @@ vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 			goto unmapped_gva;
 		/* fall through */
 	case 2:
-		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pte_index(vm, gva) * 8;
+		ptep = (uint64_t *)(pte_addr(vm, *ptep) + pte_index(vm, gva) * 8);
 		if (!ptep)
 			goto unmapped_gva;
 		break;
@@ -170,6 +170,26 @@ vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 		TEST_FAIL("Page table levels must be 2, 3, or 4");
 	}
 
+	return (vm_paddr_t)ptep;
+
+unmapped_gva:
+	TEST_FAIL("No mapping for vm virtual address, gva: 0x%lx", gva);
+	exit(1);
+}
+
+vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
+{
+	uint64_t *ptep;
+	vm_paddr_t ptep_gpa;
+
+	ptep_gpa = vm_get_pte_gpa(vm, gva);
+	if (!ptep_gpa)
+		goto unmapped_gva;
+
+	ptep = addr_gpa2hva(vm, ptep_gpa);
+	if (!ptep)
+		goto unmapped_gva;
+
 	return pte_addr(vm, *ptep) + (gva & (vm->page_size - 1));
 
 unmapped_gva:
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
