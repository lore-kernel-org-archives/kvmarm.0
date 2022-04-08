Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8C29C433EF
	for <kvmarm@archiver.kernel.org>; Fri,  8 Apr 2022 00:41:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 52F334A534;
	Thu,  7 Apr 2022 20:41:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oKSKGWBvoeDt; Thu,  7 Apr 2022 20:41:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DE96F4B159;
	Thu,  7 Apr 2022 20:41:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 391B74A100
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2022 20:41:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G8JOdI2TBr+f for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Apr 2022 20:41:28 -0400 (EDT)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5610F4A7FD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2022 20:41:27 -0400 (EDT)
Received: by mail-pl1-f201.google.com with SMTP id
 q3-20020a170902dac300b001570362c37bso2019950plx.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Apr 2022 17:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=HeX9SVaeN+dOlq3215hdXIGo/ycBIAgWX4h+cW+bQa4=;
 b=A2NZj+FpVZNDGJQWNXDrB2BNEOaaJfiikxNwLSYWGz6Zg9PxPsi/PfA69cXgtQpKBW
 cS4Xc3Zw68rXwZDzMOUQePv5n9Q1jW6twdRYmGzcWfLz505eZNzAaNqoVjfDNoJNzs5t
 kkhDrFclG6AMRs/8DvYiF49WBSiWkeb//ayHr/Dywek4pLEUSiko1nFj0N0ZPWqmAeLo
 iaQpWW/D5UoCcVTmeT1tuu3HwxFwI3ucBk51EU8HRTPTV1ShDoiT/LFnU/x4UE3uGEeO
 YSNa9Hbp2I8ZNdqwlqVFXkCeNvu4ZBd9JR89XsorHdFFbn6LYPNSqmNiHiTacj1NxRN6
 Alow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=HeX9SVaeN+dOlq3215hdXIGo/ycBIAgWX4h+cW+bQa4=;
 b=5x1kE788De6FoNlnBOA3HjwHMQacpF5J9Wdx3B+SrxSHX77Vc4EH6WUcGX/v0fwRk3
 4/zC9LXHLs6MvOtstltTvICgsmPs3lJgapoQm4FkSoFXTYd2D7nYV9EC2XFlyGdDLkgN
 foRvIvyDtvc9sqif4+tMKoiZOcGVL4F5mU/esN0XQE+z7AIEavuE5aah9Tp2R2b16gDV
 ry/SWIN/ppmv7gwigenJceyHqRjzesmcagQ1aUsHtx6VNaLThWW+FktcSDfl6lRRw/8n
 Al8uXoU/K6Ecpi6UxpO6ef5sOV6+rQUOOZGUBPHobEkL/Okz02VvsokOENhu2YsEcSsi
 0yig==
X-Gm-Message-State: AOAM533bNM0vEt0mCcXf3oR81Cmkw6nulETlh8IZ1Crf5zjO4LixKDiq
 K34HLuhIZ7AD2mJC/REZQaT2M24PagCVsg==
X-Google-Smtp-Source: ABdhPJyKVr37Yo71iEW4bLnBVyE3YskZbsr0cqGngvrD9/wXPN9pxPB1vdwn2+eYR04wMeSf5UMtQue/ILXUyA==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a63:6c8a:0:b0:398:5208:220a with SMTP id
 h132-20020a636c8a000000b003985208220amr13391414pgc.176.1649378486405; Thu, 07
 Apr 2022 17:41:26 -0700 (PDT)
Date: Thu,  7 Apr 2022 17:41:09 -0700
In-Reply-To: <20220408004120.1969099-1-ricarkol@google.com>
Message-Id: <20220408004120.1969099-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20220408004120.1969099-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v3 02/13] KVM: selftests: aarch64: Add vm_get_pte_gpa library
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
2.35.1.1178.g4f1659d476-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
