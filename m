Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF020C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 23 Mar 2022 22:54:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 761F640C02;
	Wed, 23 Mar 2022 18:54:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cpePlL45bLzs; Wed, 23 Mar 2022 18:54:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BF0649F5F;
	Wed, 23 Mar 2022 18:54:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 25CDF49F54
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 18:54:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kAtkxZT-SRfY for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Mar 2022 18:54:15 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 194F449F44
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 18:54:15 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 j15-20020a17090a2a8f00b001c6d6b729f1so1799854pjd.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 15:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=iVxsz/nxe69FaKPg7w+D5EN2GRyAtqQAGpLEEQZhEHs=;
 b=VU0CIiC8HQxd7t8K1M3jmQDYqgvIorEmirh+ftwpKsWGJiy95+m1qEDus1m4U1t5WN
 7UXWM/0apqb95IDvBoTfGgiEY71kaeuxiYEsyU32epxdJNRj2uUTmegG80Q51H9el7iw
 CzCdxLJWbmWVpaxM9XP4kHTR0X1vX3oHqxz0FiQlC1w3dPVl1KgUOJ+0Vb3GnEi2WiXy
 3BLwyuXJjxr0ZDwH+JUK1Zbnky1LNQMWWM8Pw1A+slStCy9SQJSNkQAoLARNjOU4OoCp
 CfambUCXnhYDW/wE5aaKMgKRKbhj6NoXnQ2vFGSLAcCcDWiXq6OuSKyDLkdy6rdes+Rm
 0yBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=iVxsz/nxe69FaKPg7w+D5EN2GRyAtqQAGpLEEQZhEHs=;
 b=sy94VwSD/YvtkdAMLJbMigpWBiKZT3CL4SHGylhp278q7S/R2OgECFGr0/TFAXdTzu
 8bNl3UI5WTbO5ycD/JIGMdRkFCikzjNYwTRwUp06nCTBK9AeiH0syrqjGSgLHpk3Q9Ue
 K5Ju80walDwqVlFdmagOa/WMIsAqnXSOSsHyKQYzFmLGV++lv6iFxdPIn4aLiHQ8OJ0G
 eQVR4sPld6k7jlPk2Bv+iE0COrtsSiovi+8LWHWfN1it9KclAVu2htW6VDN5dB8CiLVa
 8F4SdmD2ccLW0zR3pVvUW2BJwfPH3ql28qrc0vcKqQXa85LGehcUhxK3cyRw2mIEz0lW
 6XVA==
X-Gm-Message-State: AOAM530OS9h96MxWccPDmws5mgUH+w3wJSjwZc6SbvvdnaH1AfkedYbN
 DvPRgHDs49+96JY9/WrXsR7p1uC76EC8mA==
X-Google-Smtp-Source: ABdhPJwo+TcYa43YtvZ8dZVWCEVPpmS+xcdh51rkUG++rK+wYWB1GkUggZNN5tsVJR2O9qdpFXekINZzbsRF/Q==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:bf04:b0:149:c5a5:5323 with SMTP
 id bi4-20020a170902bf0400b00149c5a55323mr2553612plb.97.1648076054305; Wed, 23
 Mar 2022 15:54:14 -0700 (PDT)
Date: Wed, 23 Mar 2022 15:53:57 -0700
In-Reply-To: <20220323225405.267155-1-ricarkol@google.com>
Message-Id: <20220323225405.267155-4-ricarkol@google.com>
Mime-Version: 1.0
References: <20220323225405.267155-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH v2 03/11] KVM: selftests: Add vm_alloc_page_table_in_memslot
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
2.35.1.894.gb6a874cedc-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
