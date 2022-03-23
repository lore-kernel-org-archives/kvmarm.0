Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D930CC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 23 Mar 2022 22:54:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 83BAE49ED8;
	Wed, 23 Mar 2022 18:54:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WIgn6uqAOfbN; Wed, 23 Mar 2022 18:54:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D76B49F0A;
	Wed, 23 Mar 2022 18:54:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E2FEC49F44
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 18:54:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DptKpMZGhMxQ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Mar 2022 18:54:13 -0400 (EDT)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B774649ED7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 18:54:13 -0400 (EDT)
Received: by mail-pl1-f201.google.com with SMTP id
 w14-20020a1709027b8e00b0015386056d2bso1527341pll.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 15:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=EX5EdkPTcMFobBvg2k2IPzfGAyJv+44CwzcOylMIfUM=;
 b=QXX9iZudZkXIo6wQ/ra4T2fPlG8qjoYt07mt2kngzjE9dhe3Dx9l52TRYkqJR7e4Qj
 9nYLZ/vLz8qnYf4o2ymu82DKVONyT2QxVh2wYgg2K+9+0UCEznlA3L8YwiqVaOjqJaTx
 pppzXBXWskc8koE/QRdI6XNRQAKzdRM83fntH+rkqvMdKJcjM3XzKalXNz8qdXTEJLsI
 ijjHKokSVH8e1aAAyGTH2VtZJdPKBIdzAezuHc8PgD9vNXTjNsbsMzlDKWIaSujE+Sh/
 WTx/gsX4vlG+zwOYii+USookdJYWIAipso6FweptVh1BF3XpHYsZ9iNhx5VFhoXX/TDW
 4zoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=EX5EdkPTcMFobBvg2k2IPzfGAyJv+44CwzcOylMIfUM=;
 b=UGPL14bKDnH+CFYIu8lAusLjriVbWrHS3I3lEFDh/nDtL1XE3e8zizSH6hDmQ0ganS
 89ubWQg00lSnevtjR0tG/QzBsyt75yt0CAK0U27PbIZ94aBJpghsK3hCWJuLlHZ/15rw
 HyB7Gy4v8RDx36I/9mzho1QfzIuf8TEW6/t4hR71kGW/AlG71xmGkBLqcylumlpwMN6N
 aNfoAFVkAwPDok1f3nNhjozyhYM8UWTpi8q1bVHpF5oZYR6oWyGkyWA0LXsMPILW0gDd
 7r+yHKgyszh5DjJrWZNl9XugNPXLt7ULurZykvqbVrJSVrHqJTlIXk0jpgqiCCMwPlGI
 n2ew==
X-Gm-Message-State: AOAM530/vi7EY3Xw1ZyVZS93tSEv6VFLPWptct8GeLlgFGtzMi7HYukS
 lEJhzS/lzya89iBYQ6NHQoDvLFSTA+p8bQ==
X-Google-Smtp-Source: ABdhPJxlDAyrKty4WlvxYaFgWBnQWGbA8dG7nnwcr1i+I3TtdRt9Pt8GemhN9kPAWxAHCUPTszfC7fapjfAFuw==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a65:524b:0:b0:383:1b87:2d21 with SMTP id
 q11-20020a65524b000000b003831b872d21mr1670543pgp.482.1648076052888; Wed, 23
 Mar 2022 15:54:12 -0700 (PDT)
Date: Wed, 23 Mar 2022 15:53:56 -0700
In-Reply-To: <20220323225405.267155-1-ricarkol@google.com>
Message-Id: <20220323225405.267155-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20220323225405.267155-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH v2 02/11] KVM: selftests: aarch64: Add vm_get_pte_gpa library
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
2.35.1.894.gb6a874cedc-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
