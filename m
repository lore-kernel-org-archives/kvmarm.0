Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBC9CC433F5
	for <kvmarm@archiver.kernel.org>; Wed, 23 Mar 2022 22:54:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A972540A84;
	Wed, 23 Mar 2022 18:54:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GdDc9dRZIllE; Wed, 23 Mar 2022 18:54:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 92D8449F40;
	Wed, 23 Mar 2022 18:54:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D16649F0A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 18:54:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 649rag6+6PlE for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Mar 2022 18:54:20 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E4A5C49F40
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 18:54:19 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 t12-20020a17090a448c00b001b9cbac9c43so1802389pjg.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 15:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=vKLQzM6klqpkjmFS7GU8Jq/66Sy+Fcb5x77LNB4tmdY=;
 b=T2r1Caf2OJOtk5scJPySOp/9x5bj+Apl8WHaB3jSMoOIz1MKaQBurKnGDjtE5j7HIZ
 9OzExFu8pSpHjGFZCP3Cuj1ybKmX1oCev7O7tSC+rgrYeVIw8Tr3sNK35PzvXat/KSR9
 dolxuhItD4Ol+BlA6VIzVmvkJT0NxWvmxp88V7/W1lTGTKFLRyWtGRd2iEMSN5A9yy2H
 Seddhj/2HySTBw0pKeLTmrJNHMvXNP+/FAmkaEkHGZlS45r7/IWEwWw6nH+c7krdYanH
 JOCd4/NjP0nSTfd43jcxEdgU+kxdHjcnaruKZsOp4e5k8y/vNSOOSipI3Y41Bg2nBs6n
 bCpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=vKLQzM6klqpkjmFS7GU8Jq/66Sy+Fcb5x77LNB4tmdY=;
 b=KfeFZkM70YJRstzk66d4/MHfCeR0DKK6d2LaPCq9ISDQDdwwJz6En40o9xISeGxzJa
 Y7X3/Det+eORrT85dD+C5xgi5SA1nIioi/LJAS9EE1U5ZRajVHOCAey/Yq4HliYahSvM
 Bz2EARHitHhJHRL66t5I3YmU79JHVDd59QfFpI0XO6g2PEQjFti5Nj8IqWkjYBS6FBtd
 32cmEvzb41yhyfnMai+ecqRiSaIFlYwMHBOTohXEQri1nJX+LeDzsa++tje4paUvibYn
 rRIHCOE6CsZDjjGiwQI93pU2VoHA2IFnoHvsloJOrR+aayVb159TEQQEOJLIT3kaJfgs
 wssA==
X-Gm-Message-State: AOAM533Z0cyLLlVk67KcECCtKJ+ESIF1I0+eyFAa43Z1qnq/RMJiE0H9
 /VhrzXGCyKShpjeufbbCP3ZjHBI7fkNG/g==
X-Google-Smtp-Source: ABdhPJyAZxVTIQwmd51afsdptnZnXVDyKJtPsBQk9LT1jHkerS5r8cmHIz4Q/xt8p3x6a0B6SZillADFV5BM/Q==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:8bcc:b0:14f:2294:232e with SMTP
 id r12-20020a1709028bcc00b0014f2294232emr2362408plo.105.1648076059147; Wed,
 23 Mar 2022 15:54:19 -0700 (PDT)
Date: Wed, 23 Mar 2022 15:54:00 -0700
In-Reply-To: <20220323225405.267155-1-ricarkol@google.com>
Message-Id: <20220323225405.267155-7-ricarkol@google.com>
Mime-Version: 1.0
References: <20220323225405.267155-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH v2 06/11] KVM: selftests: Add vm_mem_region_get_src_fd library
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
2.35.1.894.gb6a874cedc-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
