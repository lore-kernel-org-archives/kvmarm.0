Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA5CBCCA473
	for <kvmarm@archiver.kernel.org>; Fri, 24 Jun 2022 21:33:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7251649EDF;
	Fri, 24 Jun 2022 17:33:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GTgx9LYVA5fH; Fri, 24 Jun 2022 17:33:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E07149F3B;
	Fri, 24 Jun 2022 17:33:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C599C49EDF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jun 2022 17:33:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9seEg+tN0TJD for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Jun 2022 17:33:11 -0400 (EDT)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3EB9849ED1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jun 2022 17:33:10 -0400 (EDT)
Received: by mail-pj1-f74.google.com with SMTP id
 v8-20020a17090a458800b001ec721f6bd1so1729111pjg.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jun 2022 14:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=otVCDsDipEgqqy0EKJSpTC6sTwev8b+0+mqwOVd2AWM=;
 b=YBMHgPJkXnFFS9afwwbH9zZeXr5t3AxpkWUPoME1Cx4KZrzy4yetX4RbI5zIjZF7lc
 y/eg4HH1FfYqF7SNJPBky2VUURlQnF/lvFdMmPBD6OijRt7oe5h0UqIyeSoca8f1tFh+
 Ef9TCMOJc265YUKqbcfwCuvX7lnhOpHhSfiHgkthbDeteIZsh5LD212Z2IqWcv4vOe/Y
 QuYwQmSNlqB6J7Lt9DeABIww7RBEoSjX9qck81pas208WM/fGc7/IBpzHEG7m15D4wAi
 EKuXmCluUtIxqxxEAUzDlYNLTDvIGlKKQAcz10VtrbJfy7Z1X66fsjShJhE34sUI8o9M
 I4PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=otVCDsDipEgqqy0EKJSpTC6sTwev8b+0+mqwOVd2AWM=;
 b=bebWbbLQVoIaoUnf259CEroXrU6A3EE7EfND1FWvJj5AIGOXCpSrNTOJe29eYz3JfQ
 7LolWDQw2vY71S/Mf/kQkDdyiHDxqOyIrQhlEhdtzy+XZg023FNskR3Ckh5Nbgb7/cCf
 CoygRHhGDKJ7Oe0+btKPJra5VZMuQbbpTa0ZK/pCAsQZOibk3jocrww9CyOajBbk3L7f
 zzx/CKfWIy31smdspauDg8HJH1SltBTL4WrEWE9kaYhgM/caT9IheJn1Xjx+zAWH3BBp
 6ZxsYG0M02HzWVmwFPquvLzuK2sjRbYMZ9Ph1lnDUJKm/hctlxMayiK7a6QfUkB8H7xd
 aGyg==
X-Gm-Message-State: AJIora+XKh0tTfiIfoZfJSuXpOXiHIOWXzE4WMmTKbDKQkh1L+KGpwem
 N8Yj7PEe1bKzOox2Fcsw/PUcEwOyWs4gLg==
X-Google-Smtp-Source: AGRyM1vqxKSZJ4P11BC2HxRlI4B+bvpREdVNXBFoOE27FV8Tj3VmayMZgHvvdiIYWdsa2eGYkGNfmyJoOzBzgQ==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:903:10c:b0:16a:1166:4ee9 with SMTP id
 y12-20020a170903010c00b0016a11664ee9mr1058965plc.138.1656106389460; Fri, 24
 Jun 2022 14:33:09 -0700 (PDT)
Date: Fri, 24 Jun 2022 14:32:49 -0700
In-Reply-To: <20220624213257.1504783-1-ricarkol@google.com>
Message-Id: <20220624213257.1504783-6-ricarkol@google.com>
Mime-Version: 1.0
References: <20220624213257.1504783-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH v4 05/13] KVM: selftests: Add missing close and munmap in
 __vm_mem_region_delete
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

Deleting a memslot (when freeing a VM) is not closing the backing fd,
nor it's unmapping the alias mapping. Fix by adding the missing close
and munmap.

Reviewed-by: Oliver Upton <oupton@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 5ee20d4da222..3e45e3776bdf 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -531,6 +531,12 @@ static void __vm_mem_region_delete(struct kvm_vm *vm,
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
2.37.0.rc0.161.g10f37bed90-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
