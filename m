Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA8F3C433FE
	for <kvmarm@archiver.kernel.org>; Mon, 17 Oct 2022 19:58:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9590A4B7A9;
	Mon, 17 Oct 2022 15:58:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2+AJFiCujLJk; Mon, 17 Oct 2022 15:58:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 747684B85B;
	Mon, 17 Oct 2022 15:58:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2941E4B778
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Oct 2022 15:58:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mdzJ1vCnIuIj for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Oct 2022 15:58:48 -0400 (EDT)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3049F4B865
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Oct 2022 15:58:48 -0400 (EDT)
Received: by mail-pl1-f202.google.com with SMTP id
 y1-20020a17090322c100b001853a004c1bso7732106plg.19
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Oct 2022 12:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=f+96/JvEAuWePUN7O/aZOKRhlXrvVXfk8Y5jpPQ95es=;
 b=fgWWpUPTATZoObqhmudipHE1rbimOoJyI+54OfwH0kvktKoHrRezhrx8scWRrlgMw3
 R9fqTrITvnJxkHRGObhA9IygDkwfDAkNo5fZW58sIZ9j7CkQCf7yKBSSBOzOlygv3cEX
 WqQqU2nOcWbJnZnUqakS42G8OGsJ1yEQ3sl4cEpytYa+dH63gdc08lDiNWKEEtToWTiG
 gDkhd6zCSHx2QEbNkAAlw0pSB+KQ1K/BnEIypAUi+drLyyjBB/UqJI/pjgYlNGleGayr
 wVamIBpZzR1ep0WZE7pYHhZXtx9d0noSwsAqFq0yLs1MOARtOloT/o7sqRgUK+vYl5sr
 ot7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=f+96/JvEAuWePUN7O/aZOKRhlXrvVXfk8Y5jpPQ95es=;
 b=hoINrP6ESNF6IXsLwYURRUMkd5yD6HaMB3Wsoa7GvmHX2l15hZeLtLUmZ8qXzOH0s8
 Bhukt/7XkSdGG7b8AmG+lTOZWjL4klQ2xY4DKoBddlPsQ4x4nJK7EmFqkSWN6DmjC0NY
 g4Kz14PTg7XG7emZwz0B9qSDAE0WepQhmm2N6Cmtu7UC5ZXoscu8THNnAW32+Izi3stX
 izaFaIZF6H/4yliY7MeKqCri2KAqmVQVFE7GBFfeZ93lSTzg/wGC1n2DMllvIZOp0UTg
 9Uchfi7yHzo85FhTD8m241Kr01YfPvFcI+RfCxIZZygIPVupswEU2hjlmQN8SCxn7zW1
 Bwmw==
X-Gm-Message-State: ACrzQf1K7r7gPKsklJ9jKMLp8WXbuJo1VM37Pb26ByjZUtzbMc512NK5
 OCTeZw47krb6JedIFPoi6/lQBV10uVVc7A==
X-Google-Smtp-Source: AMsMyM4H8tFUm5rFlQxBAMa9WbaF7a7ibX/iAyJ0SH1yF0izF7uxbK7MzSL5/AADU6b1oJGCrLQySyhxETmSLA==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a63:e52:0:b0:438:ebec:363e with SMTP id
 18-20020a630e52000000b00438ebec363emr12257328pgo.437.1666036727104; Mon, 17
 Oct 2022 12:58:47 -0700 (PDT)
Date: Mon, 17 Oct 2022 19:58:26 +0000
In-Reply-To: <20221017195834.2295901-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20221017195834.2295901-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221017195834.2295901-7-ricarkol@google.com>
Subject: [PATCH v10 06/14] KVM: selftests: Stash backing_src_type in struct
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
2.38.0.413.g74048e4d9e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
