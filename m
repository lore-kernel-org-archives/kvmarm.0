Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3D31CCA482
	for <kvmarm@archiver.kernel.org>; Fri, 24 Jun 2022 21:33:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AA54E49EE9;
	Fri, 24 Jun 2022 17:33:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id B5-v9V5zCwLZ; Fri, 24 Jun 2022 17:33:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 415F449F19;
	Fri, 24 Jun 2022 17:33:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DA77849E2B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jun 2022 17:33:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3CG2I14k6IBi for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Jun 2022 17:33:06 -0400 (EDT)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B46DC49ED7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jun 2022 17:33:06 -0400 (EDT)
Received: by mail-pl1-f202.google.com with SMTP id
 h18-20020a170902f55200b0016a4a78bd71so1850505plf.9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jun 2022 14:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=PIIOwiRCVKru5M6Nrp84g9xloQXh7ZUyJ0Q6guk3mk8=;
 b=eTuzNcbtyO338kczzwE8DDOMuuaRH1f5Y9dAxTisl5Y7e+/HJAVItIcWXup3kKWD3W
 YRuZUONBmraW2flz1mMIEL8SePvG7HyLIbIDjj2/WpE1BXZjmiNG9JF3SXs1vOChRM75
 eiExX5JwR73k88IDQMW4ctBvGRyRG4Yp03JEbh5Qeye85P+wZINAzf4cv8Q/+pq8MDwT
 fcR/c5q/i4TYfIZwe03W6i+LNsBWcCmCiIF1rVAS8VM3+UCME6mb8Cj0a4vE4Ix2VWqv
 +MbVrnbDVRz/Xylyh8qj8R1FatfKkjQlWzLWEKnV3a7swy5h+JruRveFUWZRAVanriBO
 8UOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=PIIOwiRCVKru5M6Nrp84g9xloQXh7ZUyJ0Q6guk3mk8=;
 b=qSFVT8I5JGlS9JL+fwF4yb6h6mo+A++9BTtAVz5DLGG4KXiAV2DWOQpWmYYD4SVLUl
 c3oa9d+Sg3KhDmjfekAs2Unuh2BJZDOh3vyxlNk/DW9Xwhcx1sT+b7m5Ce2ZNB5hpScj
 pA7PMMJLhntiK5lqegNMne3xikzoFfyILROu5TpujCMdVX4ZhdLK8QYrqKfQcTIk6vwY
 JrfB2lX9Fr/Cupqzgi19aKS7NxUC7DDcAN6B1KzxDcldggls6+fkYegf1pJzUwZ7YejV
 q5ITlBN8gRJtxSS6aIO+alaHuB8V7IL1gZo3h/E3UhA0bO7sm90UrUrACPOdtPvSLKdW
 9dBg==
X-Gm-Message-State: AJIora/Nm72sVFCLGPsXSNYuCKOWQuELgCMIpP0b9lwzAFejHJ/Ade50
 lcj80rNQJiR5Biz2QVxJlBo5SMHZ8eiosg==
X-Google-Smtp-Source: AGRyM1vyYc6zEfg/uVBMFxS2YQhhzBVbpIiwAhrjvZY1Pv3CVOwjZYTcuI+wbDJ/F+0YKM/Em71XQ1AH/IrKuQ==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:7085:b0:168:97dc:ddde with SMTP
 id z5-20020a170902708500b0016897dcdddemr1071782plk.25.1656106385892; Fri, 24
 Jun 2022 14:33:05 -0700 (PDT)
Date: Fri, 24 Jun 2022 14:32:47 -0700
In-Reply-To: <20220624213257.1504783-1-ricarkol@google.com>
Message-Id: <20220624213257.1504783-4-ricarkol@google.com>
Mime-Version: 1.0
References: <20220624213257.1504783-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH v4 03/13] KVM: selftests: Add vm_alloc_page_table_in_memslot
 library function
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com
Cc: maz@kernel.org, bgardon@google.com, dmatlack@google.com,
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

Add a library function to allocate a page-table physical page in a
particular memslot.  The default behavior is to create new page-table
pages in memslot 0.

Reviewed-by: Oliver Upton <oupton@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util_base.h | 1 +
 tools/testing/selftests/kvm/lib/kvm_util.c          | 8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 7ebfc8c7de17..54ede9fc923c 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -579,6 +579,7 @@ vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
 vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 			      vm_paddr_t paddr_min, uint32_t memslot);
 vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
+vm_paddr_t vm_alloc_page_table_in_memslot(struct kvm_vm *vm, uint32_t pt_memslot);
 
 /*
  * ____vm_create() does KVM_CREATE_VM and little else.  __vm_create() also
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index f8c104dba258..5ee20d4da222 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1784,9 +1784,15 @@ vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
 /* Arbitrary minimum physical address used for virtual translation tables. */
 #define KVM_GUEST_PAGE_TABLE_MIN_PADDR 0x180000
 
+vm_paddr_t vm_alloc_page_table_in_memslot(struct kvm_vm *vm, uint32_t pt_memslot)
+{
+	return vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR,
+			pt_memslot);
+}
+
 vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm)
 {
-	return vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
+	return vm_alloc_page_table_in_memslot(vm, 0);
 }
 
 /*
-- 
2.37.0.rc0.161.g10f37bed90-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
