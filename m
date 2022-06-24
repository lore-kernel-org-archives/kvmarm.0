Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 609E7C43334
	for <kvmarm@archiver.kernel.org>; Fri, 24 Jun 2022 21:33:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1384949F19;
	Fri, 24 Jun 2022 17:33:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jdXfLpWqi+ra; Fri, 24 Jun 2022 17:33:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F63E41019;
	Fri, 24 Jun 2022 17:33:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C6B449EF4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jun 2022 17:33:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id H3f5vg2p5KzE for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Jun 2022 17:33:13 -0400 (EDT)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BFF7049ED7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jun 2022 17:33:11 -0400 (EDT)
Received: by mail-pf1-f202.google.com with SMTP id
 c77-20020a624e50000000b00525277a389bso1629451pfb.14
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jun 2022 14:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=ohg8qNeWO0k+2X2oA0Q1pw26PDOaQZastCoJL8M0MaI=;
 b=N9p1wwZh/XCHVIqx4skNWnvlfkCwThNdYWefJOHdhv0LJwlreDXmVvD187AkCAEbRB
 8tpHtkF+pjSVdue9tVQxFtG1k2LsUzoZs7TRDuXmQbLYLvSATZgEjEKWCdpB0+rSyqvU
 COdx62nRUmvroifzPtgEfMBWX//fvMeD2rdgny6jH+mno5kBROrrCtPGZtaVOm1bobBl
 A337SC+795bvuDy9LZxwAl+zsks6SOBz9dpBJER2uburfzxV+4Fd/7OjA0eFYAWBZW98
 aVCscOxEldujKBxA76XjtHASRd6+ZLI7y7qH98DX960+xWmWOnAo1nc5WYtFk5PuLEaR
 WezA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=ohg8qNeWO0k+2X2oA0Q1pw26PDOaQZastCoJL8M0MaI=;
 b=0TSjQZTFMTqCPvwryUd6j4y8IHiNjh5PijefSMMveGtWByi81Pcr1z4wgC4vOGlPTo
 xDgkzSyoRsynesh8a01RRYKTVpf0tEA3EJzpCjgwWpcBo35x0XFgu4SILpEoQJQtSNkX
 VK6Q+aS+lRwMSwmxCxS+CQeXRjwMEdlpBZkPSVnrmwjIgJkVh8xlVgPJ/D1sZkvzPwgc
 pkQGtY+oyssq3JfzaaZPpHwc5EAY0WB28S058aKwMx0H/5jm29dKy0eLt5phIrd43HAo
 0M63WnEuIYXCb1voSSWrvLSXktIdwYi+tVIel+pa/h29u0vWWd/PPp47a5jxN95YH+PY
 Yzrw==
X-Gm-Message-State: AJIora/I2LdIwWWgrWv3L4JS5KZQy8GUb0brfFKc0eGq9IVTZ58WJO25
 H3VyeIqb+H6c6PsDv4a7GMeVqVW2UtIqFQ==
X-Google-Smtp-Source: AGRyM1sCWcsELpAQ1wrMtxcug7LwA0BHy7Mo52gKoM/XLGzmSE9sJ46xMPnzPGuTvXrq5lqC6TpMSo9OTYeaXA==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:aa8a:b0:16a:1ea5:d417 with SMTP
 id d10-20020a170902aa8a00b0016a1ea5d417mr1128363plr.4.1656106391025; Fri, 24
 Jun 2022 14:33:11 -0700 (PDT)
Date: Fri, 24 Jun 2022 14:32:50 -0700
In-Reply-To: <20220624213257.1504783-1-ricarkol@google.com>
Message-Id: <20220624213257.1504783-7-ricarkol@google.com>
Mime-Version: 1.0
References: <20220624213257.1504783-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH v4 06/13] KVM: selftests: Add vm_mem_region_get_src_fd library
 function
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

Add a library function to get the backing source FD of a memslot.

Reviewed-by: Oliver Upton <oupton@google.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    | 23 +++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 54ede9fc923c..72c8881fe8fb 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -322,6 +322,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags);
 void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa);
 void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot);
+int vm_mem_region_get_src_fd(struct kvm_vm *vm, uint32_t memslot);
 struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id);
 vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
 vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 3e45e3776bdf..7c81028f23d8 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -466,6 +466,29 @@ kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
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
  * VM VCPU Remove
  *
-- 
2.37.0.rc0.161.g10f37bed90-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
