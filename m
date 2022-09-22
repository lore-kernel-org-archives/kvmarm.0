Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A778C32771
	for <kvmarm@archiver.kernel.org>; Thu, 22 Sep 2022 03:19:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4519343C96;
	Wed, 21 Sep 2022 23:19:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tzrCen3f4UNi; Wed, 21 Sep 2022 23:19:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CE3014B0B9;
	Wed, 21 Sep 2022 23:19:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 590F94B1AD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Sep 2022 23:19:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xtWkDWYWjPej for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Sep 2022 23:19:11 -0400 (EDT)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 527C24B1C6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Sep 2022 23:19:10 -0400 (EDT)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-349e90aa547so67278487b3.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Sep 2022 20:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date;
 bh=+QOeE+p9XPKEQJzF+WIS+zt2pkS7/YZHn+1BD5zz4Z0=;
 b=luVHMEWPH+Yd5BdgHDoxwgya5Q0SpmEdJATYkEiyfovMC3E8G+6MTJ4QQIf5wjPjAj
 TZoRl+s8E4wk4e4nNwbSa5QsQoKk1DQ7JvQsff1j5NEx6AeLhm6V3Pv6Gyfj3uKRknoN
 FdrC/FQ65AQQpzI+fRfaL0Pi9b8MQxCRSZAyIC1eCKtt2A1ZmLCJwIje1W2y81vzLwNJ
 t+InhbMXzSCw+Hw2noV/0BIyYfsturwqrvLUYJOpWxWP2rI+EjbDhx70Rkn0ss89UBrF
 8ldQQBnVdrXpy9GqZNNt8Pc1HvXWY5i2GKnuNrYknTyXb/BpWoySjsioScqVfK7YuMuz
 gqng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date;
 bh=+QOeE+p9XPKEQJzF+WIS+zt2pkS7/YZHn+1BD5zz4Z0=;
 b=zmaVUNkjSY2ly9dwzgjtc3vurbG+CUurhxXRQdjucnLWbkKzjvlRy3YsxbzoRbhIWc
 ygs4cxb50nIQEdPNcAa+br8mhDYHLePmfRhmXZ/KI4ChLDgEmZvE3AoPDlamo99GIrtU
 QAjNkC3gPMpHmyxQhJQotZW1Dh1qOg+T+DWVoyJ1AQ3D1WMtQD5AqnRpWRDizyfWLSqE
 e5bwY+9qMTuOyi4N9VyfKMaNkABBuhYSFUFgyRRht2ZRZkmzrpK6zamr4Qrfeyl7/vcb
 IdOJ2q03RzXqa9XwEOqayEIbsmZj9Te8P1CDQLjANngFYqrrM6+Cu5vOn5aUZ3LwDFaL
 J66A==
X-Gm-Message-State: ACrzQf2nuiL4Om/3FEJ1CSZa+I1ZpjQ6F9lPW9BPL+XxTsxMc0IkMsg4
 FWHfBAGmdedpnNtb3xoyGEZsjQmGQgcvFQ==
X-Google-Smtp-Source: AMsMyM68RC+1q2crajg2CdNq5asHX1kj7q5tPPmCcQ+GHi7uygjwZsAtKwEv3OK9VXrDqZAMZJiRnna/2X7dew==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a05:6902:70f:b0:6af:281e:39ad with SMTP
 id k15-20020a056902070f00b006af281e39admr1667812ybt.136.1663816749901; Wed,
 21 Sep 2022 20:19:09 -0700 (PDT)
Date: Thu, 22 Sep 2022 03:18:49 +0000
In-Reply-To: <20220922031857.2588688-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20220922031857.2588688-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220922031857.2588688-7-ricarkol@google.com>
Subject: [PATCH v8 06/14] KVM: selftests: Stash backing_src_type in struct
 userspace_mem_region
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
index 24fde97f6121..b2dbe253d4d0 100644
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
index 9dd03eda2eb9..5a9f080ff888 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -887,6 +887,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 			    vm_mem_backing_src_alias(src_type)->name);
 	}
 
+	region->backing_src_type = src_type;
 	region->unused_phy_pages = sparsebit_alloc();
 	sparsebit_set_num(region->unused_phy_pages,
 		guest_paddr >> vm->page_shift, npages);
-- 
2.37.3.968.ga6b4b080e4-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
