Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5705EC6FA8E
	for <kvmarm@archiver.kernel.org>; Thu, 22 Sep 2022 03:19:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 02CDD4B239;
	Wed, 21 Sep 2022 23:19:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fJjs192HTRXu; Wed, 21 Sep 2022 23:19:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BE4C4B24C;
	Wed, 21 Sep 2022 23:19:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 024F549F3B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Sep 2022 23:19:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JHKy9AuNzBXL for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Sep 2022 23:19:04 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C74364B0B9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Sep 2022 23:19:04 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 f3-20020a056902038300b00696588a0e87so6995462ybs.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Sep 2022 20:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date;
 bh=qjLjZKvyeIeRGOesNjjS3cTK/aOXc6uRAWIPLUpvrd8=;
 b=kF4yRiS/Rd5ThscLooK8PSbxVEKD+XJPZZemQ1CB4rSRDSOlf/5CLq0rgxG0Iqoq4N
 IuwFx01fTIxVzcYe7oZRxhOF3e51bSQc0lgkOlvjRrMC287hpEqGHWz/Dlc+XN7DjEzm
 xdKJBwX3MX0Vxcb35Ke2lH1GbqMSO+YQyrNzLltFHmOzYvg0HqMxOker8n61wkBfN5IZ
 BjQ8u1giqEVt783IdBSzR6KlLQhe9eMNBoryTt2Zg9ZsKDcHBYAQYTXa91eTuPuetFFb
 nOc6tREpi27L6D/JIEVc3KWe0eYIl/kUxkLdomlx8SkK27KtRkEMSMqtNlnV6JOoszEQ
 VsIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date;
 bh=qjLjZKvyeIeRGOesNjjS3cTK/aOXc6uRAWIPLUpvrd8=;
 b=Ape7mRnsXdED9O3kH4CtDVQlZhgn4pDDt/2rRVofo6N4uhUth0PWJK2zlUcOD7aMzp
 Lm3GysOnk81APfyhBI051k6bjhQYR9NucBNzGo9E0OZeNeueXSnzjBUezQppfCblV5yi
 CrLjRNUjYhVChb2lP2qG6AkaPNEWANgala316poQffWXYqcOrD5J/CkQ5lKmzZJx/yEa
 2bjU8+CnJkR1eGzdZd1TYzh9agXgGcGDPiQWg02nzOIV9FW4e9G+bXfVr3e6WdVP0FWV
 d9XPtRMKAxwQS38qn14c4loSLohIz3sGaQwuo6aU8MTxoZAChRieQPCy2l2p4dxn6ZcA
 FcCg==
X-Gm-Message-State: ACrzQf39k7E4aES2S0Pjdc1B3f2FsXcXQN+Iu/c/p/eZaiONqZ4ZX3SZ
 w0opMjJBZVUyeI58uLv/Byz6klmqsPwBYw==
X-Google-Smtp-Source: AMsMyM7PMMbrQ4oKyuP+30wOQa0mWaPz18dLT/Ogo59kam5aTXyJF6FbF/krZJb3XY3A2cxtntFt+PqH2J0x0w==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:2d4b:0:b0:6b0:cc1:8cc with SMTP id
 s11-20020a252d4b000000b006b00cc108ccmr1495774ybe.570.1663816744338; Wed, 21
 Sep 2022 20:19:04 -0700 (PDT)
Date: Thu, 22 Sep 2022 03:18:46 +0000
In-Reply-To: <20220922031857.2588688-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20220922031857.2588688-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220922031857.2588688-4-ricarkol@google.com>
Subject: [PATCH v8 03/14] KVM: selftests: Add missing close and munmap in
 __vm_mem_region_delete()
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev
Cc: maz@kernel.org, bgardon@google.com, pbonzini@redhat.com,
 axelrasmussen@google.com, dmatlack@google.com
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

Deleting a memslot (when freeing a VM) is not closing the backing fd,
nor it's unmapping the alias mapping. Fix by adding the missing close
and munmap.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Reviewed-by: Oliver Upton <oupton@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 9889fe0d8919..9dd03eda2eb9 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -544,6 +544,12 @@ static void __vm_mem_region_delete(struct kvm_vm *vm,
 	sparsebit_free(&region->unused_phy_pages);
 	ret = munmap(region->mmap_start, region->mmap_size);
 	TEST_ASSERT(!ret, __KVM_SYSCALL_ERROR("munmap()", ret));
+	if (region->fd >= 0) {
+		/* There's an extra map when using shared memory. */
+		ret = munmap(region->mmap_alias, region->mmap_size);
+		TEST_ASSERT(!ret, __KVM_SYSCALL_ERROR("munmap()", ret));
+		close(region->fd);
+	}
 
 	free(region);
 }
-- 
2.37.3.968.ga6b4b080e4-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
