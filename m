Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A8D7C433F5
	for <kvmarm@archiver.kernel.org>; Fri,  8 Apr 2022 00:41:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 060EE4A3A5;
	Thu,  7 Apr 2022 20:41:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZA15mxa7EtKO; Thu,  7 Apr 2022 20:41:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 092EE4B11A;
	Thu,  7 Apr 2022 20:41:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A3944A500
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2022 20:41:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jdaSHbv0gQ2U for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Apr 2022 20:41:30 -0400 (EDT)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D6D3049F49
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2022 20:41:28 -0400 (EDT)
Received: by mail-pj1-f74.google.com with SMTP id
 d10-20020a17090a3b0a00b001ca93b34e3cso4415146pjc.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Apr 2022 17:41:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=4i8vkVYTpMI8sgCODcyEo+cLvfdtqAncn9Gw8372e+k=;
 b=SEvnDyhP5Eaj73KDVpVzZJA7xQaM+5EXBgQvOedS4v7Sp4iwcAtMpm93TDhBlUx8HC
 p39VVoh0d54k+2oHuWizmDPlEUIFVJGOf2bLgWJvv96kgnpWowBMqrggmwcfdF8MTKer
 NUZ7VnB7Yt0BmOkmTtcHh8WAbsM/yjLXYLBWE7z0BdCWtYSRQGGXnlkuv0G3L+o9V5WU
 FCy+CpQWbmjc21VjuGBCu/rEKBOK27LcV8IeX+CXJ23rGfPbQbAAbNNfXNlNaC3zfaOX
 ekanpHOBpTRaYjdr+V4KkNkIKwtsq+cjeDEKdZZczw39vp7vIg1DhPn27SokxJs9rKMQ
 g6nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=4i8vkVYTpMI8sgCODcyEo+cLvfdtqAncn9Gw8372e+k=;
 b=TiqdOEIm53XPB5VX/05N4VNMfc34Cu10JBkcXaQdMEbyQvmnj5UxPpSXnyax0J/NFC
 P6lP6lfzDt+Gpi3ylgqv/M4zBCPp1UQ8sfszmwT52B13zjwO9wV1AH/ieQVktQHwUOC8
 cl5EjYdbIftcjTcGMSigN+XUH/9v1psL2rEKTKX+jDFDk+AoUgRlYgshvtOT5p6wwxFg
 34HaKxvLYXh0UuoN75vG4xmQjH5cmGYP8rpEnN+o0XAZhs9ZGvXI4nRMFu688b72tmcX
 fmZQ/Gn+N8z6P/iudWE+KKi9igJ5PsXlOIhOd/KTLqpCaNTlj27mMcV4P2jQkeQnEUFF
 W6jQ==
X-Gm-Message-State: AOAM530KsLXByabhw3OzJfoVo5Cu1ZL6VcmB0eL8tKvtJ1dEdiaHT1ST
 p36DLSJZDWY2UAfpEr1FujpWrviJ3D0C8Q==
X-Google-Smtp-Source: ABdhPJzen0F2bMdEJMcNp95xTNKQXKaQ6OIyor32CpS2Lnwc27cP2WP3RwfdBMdsdRt73fT1Uhd/kZ6oQLYhlA==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:8b88:b0:156:2b14:cb6e with SMTP
 id ay8-20020a1709028b8800b001562b14cb6emr16819381plb.14.1649378488058; Thu,
 07 Apr 2022 17:41:28 -0700 (PDT)
Date: Thu,  7 Apr 2022 17:41:10 -0700
In-Reply-To: <20220408004120.1969099-1-ricarkol@google.com>
Message-Id: <20220408004120.1969099-4-ricarkol@google.com>
Mime-Version: 1.0
References: <20220408004120.1969099-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v3 03/13] KVM: selftests: Add vm_alloc_page_table_in_memslot
 library function
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

Add a library function to allocate a page-table physical page in a
particular memslot.  The default behavior is to create new page-table
pages in memslot 0.

Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util_base.h | 1 +
 tools/testing/selftests/kvm/lib/kvm_util.c          | 8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 4ed6aa049a91..3a69b35e37cc 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -306,6 +306,7 @@ vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
 vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 			      vm_paddr_t paddr_min, uint32_t memslot);
 vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
+vm_paddr_t vm_alloc_page_table_in_memslot(struct kvm_vm *vm, uint32_t pt_memslot);
 
 /*
  * Create a VM with reasonable defaults
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index d8cf851ab119..e18f1c93e4b4 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2386,9 +2386,15 @@ vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
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
2.35.1.1178.g4f1659d476-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
