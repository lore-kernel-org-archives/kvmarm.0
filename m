Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5F9CC6FA90
	for <kvmarm@archiver.kernel.org>; Tue, 20 Sep 2022 04:15:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 811F54B6DD;
	Tue, 20 Sep 2022 00:15:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id B+SqsSqDI2bE; Tue, 20 Sep 2022 00:15:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 54BEC4B733;
	Tue, 20 Sep 2022 00:15:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 26A954B64A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 00:15:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 36xrIhkA5AjN for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 00:15:24 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 239D04B629
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 00:15:22 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 184-20020a2507c1000000b00696056767cfso1067295ybh.22
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2022 21:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date;
 bh=MpiWeS5yT9XQtTMvfOWTUplS/QmLd1Rz7gB7rSz3ANA=;
 b=WGfWOvd651OPU36vfdkVf6aKW6kkKSmQdI9uaJ8UegJkA8h64GkxoGQN0mOlZ450ZR
 cF+4kqmvwDIGt5rgJEswPRo5RR38yVMyFPVm52++arxNBTL/Wp1A6yxZlwNrmbWcyhQF
 AaeUAhp2EL8qQCophfoyouvtjJDFNSeuGz4TRvJqW5CtWIZsExlIL0XL0A76w+IDGeuv
 roAGE04ShN5CxI3hDyMsQweQ3B2aqFubf3TKizCvQsCo/is29MOxAR1emEy8+emc5zaL
 wSPF92flRwEow21BPz/DCFufyaIgejTRvRcj0JFgSkYXSEyh9zkd2B6QD3FESrsEdayy
 dOfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date;
 bh=MpiWeS5yT9XQtTMvfOWTUplS/QmLd1Rz7gB7rSz3ANA=;
 b=QP0SZGBywNODW8QaRdfIdlrbeT7qU2Oen85WP10q7sJBJRnxH6RLunJRJa4gz+fWIP
 0pZwWYNTNkGsJ/rAT+xZViNqKeiIr8kK7Gyjv9tfDArcct7QLx8hKg0GguyK5ZzwIHkp
 K9fvpeLIq5weoTj8UDIjCdbG108ompdfeWCyDWzKFIVUvLoBnMWcZseLpKpEx2XGUcgj
 OF0O6ap3OgWZddg3CFQ1P6PWKOJhtFKDf7P0jwyiWEhX1dRLWi09ucHjhfTqUjoitMHp
 E54EuJUobTQvVB6r2Ntf0P9C9vWXIiaBhWa6sYAv8taz2ubC4bkGROZoAvKp+S/0nTiX
 bh+g==
X-Gm-Message-State: ACrzQf37VU3ZQDAJXzzKA76FV6vY3AwCHSleTcmFvAEFSz0lbdB3Vj7a
 udBSwm0P8vaZvMlylyk3BsrIG2pBe36w8A==
X-Google-Smtp-Source: AMsMyM743v9RHjCbocTeIC8k7S8usQkHw9SN6JnI4RIjXLvXo1eeVqBlWeIPovzZ3O5kAOfJedfifjR+iHq8Xw==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:f88:0:b0:6a2:805:7e70 with SMTP id
 130-20020a250f88000000b006a208057e70mr18193563ybp.461.1663647321752; Mon, 19
 Sep 2022 21:15:21 -0700 (PDT)
Date: Tue, 20 Sep 2022 04:15:02 +0000
In-Reply-To: <20220920041509.3131141-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20220920041509.3131141-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920041509.3131141-7-ricarkol@google.com>
Subject: [PATCH v6 06/13] KVM: selftests: Stash backing_src_type in struct
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

Add the backing_src_type into struct userspace_mem_region. This struct already
stores a lot of info about memory regions, except the backing source type.
This info will be used by a future commit in order to determine the method for
punching a hole.

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
