Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A78DC43217
	for <kvmarm@archiver.kernel.org>; Fri,  8 Apr 2022 00:41:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0279E4B093;
	Thu,  7 Apr 2022 20:41:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WD+gjCSXqYSl; Thu,  7 Apr 2022 20:41:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 676FF49F44;
	Thu,  7 Apr 2022 20:41:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B1B4049F44
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2022 20:41:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hoqKUUOX+rDt for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Apr 2022 20:41:33 -0400 (EDT)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 97BD34B086
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2022 20:41:33 -0400 (EDT)
Received: by mail-pj1-f74.google.com with SMTP id
 z18-20020a17090ab11200b001ca9f560e91so3787628pjq.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Apr 2022 17:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=ma205ge9BDOVMj7gZDxqTm6bY+KHnPOCZruDDJTsiDQ=;
 b=XdNNOy+Xf42B56zBTOagqhnkIL2gXF35sWD5D7P7s7jff+QGphla7l3EukkPSCLOin
 y57ixsuzrAl5CZiH4/eM6+jb6VFmpuz7ijMdbG82+JFA98iXGDE+0nabN/AdBig7OyzM
 FwttxRmdVs+dk2sBGidoWMyRKJX/6B+84LQpzH1Sdj0KDpzB2IdXX1LWXnnHlCc2rp5Q
 qTN1IWY7L3kXbPiMNb4wYaaUR3tXU7OWTrVtGTumt60ZVQcqcaQobGp+hYjPriXhciZ6
 HIkKnfTwtETqk1UYPo0Zk82c+mLcr6IMof2gV+2x/9G+1Yt/20zk2YI6LsEeKO+7+YjZ
 V5XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=ma205ge9BDOVMj7gZDxqTm6bY+KHnPOCZruDDJTsiDQ=;
 b=WUkkgylZvpp/HIWRbKoxf/jIDJonagULDKr4YBOvAfNqqtTCd8/AXe5DeZQZrCOT7J
 u3+gb0fZRR6+doLcbfuI6CRJCOSqAwqh5LcvQMR/EE1pzNTMunP1nXqU9kNS3cIh62WC
 W3c79iieMi8fgLTySVQe/jD+I8zAGqEFwsW1CvnMf7DTLoev/PQwWFaVFAn/yAn5CEGF
 z9oLKj/j0GB6Zj8GAZtj5WlDgMm7q5ihYBKzUteBBqo8D3roBmhta/aIkQ5kXvR+4bxj
 R5Bun6H9ZDTKgBL9p5iemy0nLaIwTS5Jguw4i5FCJtlxo/NL0NCn8pyc05xYsMvlkifY
 ustw==
X-Gm-Message-State: AOAM533BMRiSaSmMQsLblLcr8hZyS4GdMsk1Z8A86VSiD7+P+YVh9LNt
 yPUtjtlWluauN3nAZAmeFJg1H/XtHH7zHA==
X-Google-Smtp-Source: ABdhPJx/x/5ymStBVtSGKj7Xfm/crzv8lUGNkVJDDDCjk2nW2zm+u3BK3CB1mCfuw7JBEbiV1LYqYuZQsLSIEw==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:903:20c:b0:154:b58:d424 with SMTP id
 r12-20020a170903020c00b001540b58d424mr16087633plh.45.1649378492864; Thu, 07
 Apr 2022 17:41:32 -0700 (PDT)
Date: Thu,  7 Apr 2022 17:41:13 -0700
In-Reply-To: <20220408004120.1969099-1-ricarkol@google.com>
Message-Id: <20220408004120.1969099-7-ricarkol@google.com>
Mime-Version: 1.0
References: <20220408004120.1969099-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v3 06/13] KVM: selftests: Add vm_mem_region_get_src_fd library
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

Add a library function to get the backing source FD of a memslot.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    | 23 +++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 3a69b35e37cc..c8dce12a9a52 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -163,6 +163,7 @@ int _kvm_ioctl(struct kvm_vm *vm, unsigned long ioctl, void *arg);
 void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags);
 void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa);
 void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot);
+int vm_mem_region_get_src_fd(struct kvm_vm *vm, uint32_t memslot);
 void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid);
 vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
 vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 268ad3d75fe2..a0a9cd575fac 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -580,6 +580,29 @@ kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
 	return &region->region;
 }
 
+/*
+ * KVM Userspace Memory Get Backing Source FD
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *   memslot - KVM memory slot ID
+ *
+ * Output Args: None
+ *
+ * Return:
+ *   Backing source file descriptor, -1 if the memslot is an anonymous region.
+ *
+ * Returns the backing source fd of a memslot, so tests can use it to punch
+ * holes, or to setup permissions.
+ */
+int vm_mem_region_get_src_fd(struct kvm_vm *vm, uint32_t memslot)
+{
+	struct userspace_mem_region *region;
+
+	region = memslot2region(vm, memslot);
+	return region->fd;
+}
+
 /*
  * VCPU Find
  *
-- 
2.35.1.1178.g4f1659d476-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
