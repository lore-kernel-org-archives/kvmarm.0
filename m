Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 347FFC4332F
	for <kvmarm@archiver.kernel.org>; Tue, 11 Oct 2022 01:06:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DFE6C403FD;
	Mon, 10 Oct 2022 21:06:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FLAM7bsDukWh; Mon, 10 Oct 2022 21:06:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 71EAE4B64D;
	Mon, 10 Oct 2022 21:06:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 211464B63D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Oct 2022 21:06:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1B3Se-Idhl-6 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Oct 2022 21:06:48 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7AC304B62D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Oct 2022 21:06:46 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-356a9048111so118168097b3.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Oct 2022 18:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=NChdwDXJfPmnfWf5atW/Yp9il5xPVGNMebBCfEdWL2k=;
 b=UkcJ/bp46qwS500IUMujefCobrQShOfuHj8ioURU3a0xRbWbiAY1dJoK1tX+sNtP7T
 CxqJV0TdJjgLOcXmL2VYIE88pJHrCcVSAno3rTBfypXy9epKFlZfxIB6U3TkUx+Ct/6/
 Lb348Bq/LWI2EvD9u2tDQF93FpdduOF1jjL+wMv5+jU2mIXLqg0PjXfVJdA5r0nI2gCR
 MpVB7KFa0SrftyMS7OlytdguZ8mjXhb8fCxo5BAIiDEWdHcJ820STx57+6hU5d3myWRp
 uWQinnUUJs4HUVh/fvW/4AjczmuWdPPkEHt6MxzKBMGeYirap0BsWWRr+qPTe+/tkdOM
 c3gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=NChdwDXJfPmnfWf5atW/Yp9il5xPVGNMebBCfEdWL2k=;
 b=bNWgrcke+ENOfKba4tR/1VCudvzsQvxUdbQXiWDzgunRvOcfWN8FsDzBDB+0Waohfa
 blCSbeUJVP/b6j/kQ8MIYQLOOMnu7GRhNflEVshVKGOYRpmAl4fg72JCTi1cbYp47eJd
 vaZ4KRZRUQwaQFBiUo68IVXK79G7Zr+ICpIRq7YZYfaWMBEAhL0d1glqxFuzvTt6wpb8
 jGNE7vetHQzRrxL6Q7N8t9uei/mWblkRhm5KkYlhXJGvoSTM2K37EBb3BX4vE6XAS+NX
 Haud8o7BMhzuZSMnXk7xOLi8ylzw/wQZW1W7ssezofZ03yFn20dwJahENkDfAuGAq5eK
 /mjw==
X-Gm-Message-State: ACrzQf2Q7M/jLttH/DoH8on4qQ0DGRwfcYMMwa9cuG977+rGZSMQxYpA
 p56iRQQ2LMaMWy+uraAf0QdWVfEqUGCGNg==
X-Google-Smtp-Source: AMsMyM6DvDW7RQp/vT3H4oz3eGzG6d941XFf+LY4Plq3XF9A4zKfPJxqaSk6SkRxtj0iUkgns4BqjOw8cl41tA==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:d7c3:0:b0:6be:28a9:b8ec with SMTP id
 o186-20020a25d7c3000000b006be28a9b8ecmr20504274ybg.443.1665450406087; Mon, 10
 Oct 2022 18:06:46 -0700 (PDT)
Date: Tue, 11 Oct 2022 01:06:20 +0000
In-Reply-To: <20221011010628.1734342-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20221011010628.1734342-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221011010628.1734342-7-ricarkol@google.com>
Subject: [PATCH v9 06/14] KVM: selftests: Stash backing_src_type in struct
 userspace_mem_region
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
 andrew.jones@linux.dev
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

Add the backing_src_type into struct userspace_mem_region. This struct
already stores a lot of info about memory regions, except the backing
source type.  This info will be used by a future commit in order to
determine the method for punching a hole.

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util_base.h | 1 +
 tools/testing/selftests/kvm/lib/kvm_util.c          | 1 +
 2 files changed, 2 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index e42a09cd24a0..a9264ed22cca 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -34,6 +34,7 @@ struct userspace_mem_region {
 	struct sparsebit *unused_phy_pages;
 	int fd;
 	off_t offset;
+	enum vm_mem_backing_src_type backing_src_type;
 	void *host_mem;
 	void *host_alias;
 	void *mmap_start;
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 19e37fb7de7c..6affce47e899 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -929,6 +929,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 			    vm_mem_backing_src_alias(src_type)->name);
 	}
 
+	region->backing_src_type = src_type;
 	region->unused_phy_pages = sparsebit_alloc();
 	sparsebit_set_num(region->unused_phy_pages,
 		guest_paddr >> vm->page_shift, npages);
-- 
2.38.0.rc1.362.ged0d419d3c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
