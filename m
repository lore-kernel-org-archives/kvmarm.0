Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7813FC433FE
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 06:02:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3173449EBE;
	Fri, 11 Mar 2022 01:02:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id M3ndoh0OKFXU; Fri, 11 Mar 2022 01:02:21 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D8D3E49E1E;
	Fri, 11 Mar 2022 01:02:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 25F6140C58
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 01:02:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YYaA9hEpCmsL for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Mar 2022 01:02:18 -0500 (EST)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0D62049E57
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 01:02:18 -0500 (EST)
Received: by mail-pl1-f202.google.com with SMTP id
 z10-20020a170902708a00b0014fc3888923so4006941plk.22
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 22:02:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=8ix8hjq3ugfBG2VjWflpErmFpudSQCGZkT4xxCEQk+0=;
 b=kccGSI/hDvCHSQRVFA8c/lxGAUB465N9ZlpJ8LNzZljadoy6eaRouGO0ksm+3PwcW+
 Vhlw6MIBLNr7pwZaCJLg9mCQ6G0xiNhxkQ+NkNKPzxeF0mj2MpMlYGQIZxa+UYj3GQmg
 tof+9FzK+Tco2G/FpPmm/Aq/BarjXPx/wESPFMnryqUzzL0JXlK2j+ocXj/Hd21xGLNR
 TD9gNBskYZIppl3kma9baKZY6db4lEFD/Txe5QS1KABzNA2Y8oH7L3JmvIHVCINfsmSc
 IBuVhbsNro54yM0zh52mmuZHJeTmJ7kx/D3as1ta9Db8JGUNJBmjqAEOR1ze4Fc73LE5
 eXdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=8ix8hjq3ugfBG2VjWflpErmFpudSQCGZkT4xxCEQk+0=;
 b=J0uPG2H/Gc93uXqDt+sOtgTLB9h9mHPFPoANtHlyHDjpSpM6GC66D3hdidNKJUvBp+
 lWmkZ8+TCdD661/DcJWHTjodVHQKnEnJPFnm4W4B+FeSY8eu7ovJn6M0zPM3EchTHbhb
 gs1EMBsc0xEM7iiy9LIfVaIQzU3hqSFMIhZ2RgTW8lMT2p5U9nGDbHewMty/AajTpDrG
 +auZ8Q9tbQoYMioFgGp9mDU4y/ajku3Si9hXty/a7rKojgVB5BA+6aWIKp7ayVGLL9EI
 eee8M8P1ydWF3/2DJ4FBEQASPsDvDsqHU4TIfaVwUZWpNA6JPTgyeEntHlWF+5UOBbXb
 BsMQ==
X-Gm-Message-State: AOAM530Hsij0OU3uDEMZ6g75rb2qCF8xBdf3Mtt1fup1z7G1LXDsHpDh
 g8foe4ZP3RG51yoDZ7N/ZhXJQ76kg/sidQ==
X-Google-Smtp-Source: ABdhPJxpGigncSmxYhf4XlgXUbziRCRypFVzTD0H9Yb5hfRYSmi/fZj91kJeTwObWuRykQL3BsReC0ZGkDnYsw==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a05:6a00:a0c:b0:4f6:661e:8dda with SMTP
 id p12-20020a056a000a0c00b004f6661e8ddamr8400235pfh.66.1646978537229; Thu, 10
 Mar 2022 22:02:17 -0800 (PST)
Date: Thu, 10 Mar 2022 22:02:00 -0800
In-Reply-To: <20220311060207.2438667-1-ricarkol@google.com>
Message-Id: <20220311060207.2438667-5-ricarkol@google.com>
Mime-Version: 1.0
References: <20220311060207.2438667-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH 04/11] KVM: selftests: Add vm_alloc_page_table_in_memslot
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

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util_base.h | 1 +
 tools/testing/selftests/kvm/lib/kvm_util.c          | 8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index d6acec0858c0..c8dce12a9a52 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -307,6 +307,7 @@ vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
 vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 			      vm_paddr_t paddr_min, uint32_t memslot);
 vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
+vm_paddr_t vm_alloc_page_table_in_memslot(struct kvm_vm *vm, uint32_t pt_memslot);
 
 /*
  * Create a VM with reasonable defaults
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 64ef245b73de..ae21564241c8 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2409,9 +2409,15 @@ vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
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
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
