Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 139D5C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 06:02:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B18A440C58;
	Fri, 11 Mar 2022 01:02:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id T8iVLg0xdAf6; Fri, 11 Mar 2022 01:02:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 880AE410F7;
	Fri, 11 Mar 2022 01:02:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB3D840BE7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 01:02:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id m5JNzNQD6egp for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Mar 2022 01:02:15 -0500 (EST)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C6E1940C31
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 01:02:14 -0500 (EST)
Received: by mail-pf1-f202.google.com with SMTP id
 184-20020a6215c1000000b004f6dc47ec08so4596187pfv.21
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 22:02:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=xwfZh69dZOdSDjKPAanZfrcJOqRr+yQYeyh7zLSa5HM=;
 b=FmJrdIQ4nkAf2XhudiEZwKvXHoi1jC/nwpfxS6QVNMD2gPfr86NLRAre5UcUjxyqqf
 tpfui4ksu2sGfp+uQsV5yIpGapg3LBMNCt/amcsL5lmSGJ3/yIjRb0ObSWspsHGJ/ExJ
 E+UXgzwVetIbnj9tRAx5JjTRdumu1rneme2ubpOwDyXKrYlqJmUYCFAekBIiz091gpaT
 KbqliVra7ce0Y5Qk7cd6GQcxH6Z4e5SRYivMRlJAQ2vZi2+LZ8ygTB01Si4Fb5ScWXR8
 sPuDuZ7kmM3T0y2+IPlT+bqYW/pW8DCcyLD2Y81KBDrp7R1EjscglqttDJohlJ/bX+O6
 uq6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=xwfZh69dZOdSDjKPAanZfrcJOqRr+yQYeyh7zLSa5HM=;
 b=3aN1Kqn/4VX1ArpHZz/JKtdkBkIEa90/kCkqiwbCIfpxaTyQb0EKnF1+GjMmgUry21
 JwIO4Uaz7YrdJQq7cIkVzkVxdnI0sqd46toIrfRyaim7H1djuSNneu/2XEZKJ3IktXSL
 6OSaTw7aOqMV64HC11Tb0soGlfjTA6p3HSR7OsoxBsQe4G6GceIPcxkRzfvmEt2b8u+A
 o629NVcYIA3h3txx4ZQ43rWF+LQqi4BskKWJ/n41lbnO2TS/sVPwM9KUQ1YqlPbf2Dyr
 AJotve2Okp8gQeZ2XEQ3jPN5/osHPR5qcfMAyKXkWupCiE4bscKtkkXkNtprOWXwsvf4
 T6ag==
X-Gm-Message-State: AOAM531kBXTvGO8fNEPePWZQy9g5q8mbUH9EYv9jIB3f6P1/Y7eoh0Po
 IX/R9D/xfPzP7Rs5/Nn+bC1N+pRw5znXDw==
X-Google-Smtp-Source: ABdhPJx2Dx7cNt7Ofd9w5hxmXsBiBkr6Dftp2Jiv2s6DH+Uk1zEWu8ia9W4jQ1mK6lRGzs+WWSNA8YA6bHTD5w==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90b:4a52:b0:1be:fb7c:9fef with SMTP
 id lb18-20020a17090b4a5200b001befb7c9fefmr20013275pjb.57.1646978533927; Thu,
 10 Mar 2022 22:02:13 -0800 (PST)
Date: Thu, 10 Mar 2022 22:01:58 -0800
In-Reply-To: <20220311060207.2438667-1-ricarkol@google.com>
Message-Id: <20220311060207.2438667-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20220311060207.2438667-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH 02/11] KVM: selftests: Add vm_mem_region_get_src_fd library
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
index 4ed6aa049a91..d6acec0858c0 100644
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
index d8cf851ab119..64ef245b73de 100644
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
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
