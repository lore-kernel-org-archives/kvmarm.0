Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07E37C6FA90
	for <kvmarm@archiver.kernel.org>; Wed, 21 Sep 2022 03:53:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B53214B7E9;
	Tue, 20 Sep 2022 23:53:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OEFkiujxFHvV; Tue, 20 Sep 2022 23:53:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 824DE4B7F6;
	Tue, 20 Sep 2022 23:53:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CDCE4B795
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 23:53:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aud4vDn6T7MM for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 23:53:05 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8424C4B79B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 23:53:02 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-340ae84fb7dso41149867b3.17
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 20:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:from:to:cc:subject:date;
 bh=HHCJMOz1PMG82DQmjUuOPo5k0H/Opjm/8PtzbIkPyNo=;
 b=SN1sMLBxlit2X7oFwY/sWO1LFKwUpplAezDsBIxaraCcU6jYzpP2/vkmHYHXHDlP0Q
 u7nq/HQUyFgmKfdGJdxn5nPk8sRzVVss7iybg2+VCD00b9zwdXZjt90zwyeFHKvMYhFZ
 uOr0kyZAQoW056MNg5y19el28LHLf1faWAsXNs2mss8i6B288E3u8lr+wIUiK7aCviEM
 LfW3uQ2AO1blNKP3/ob1IZ3N+Qd9XFfxEBCatSRpOjnBhAWgkRBuMJAJiNnBlWewL8Kr
 xEB+eIyN/U04VxGAO1tRSUOeb3K9kv71h3UPvx3r/x4o1TO3b9np3/QToA2S4MMqwVny
 eYbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date;
 bh=HHCJMOz1PMG82DQmjUuOPo5k0H/Opjm/8PtzbIkPyNo=;
 b=e1huuM5UxsBwtDLLewgLf4Hk7a4YUHRLvU9DIwRBU/P8HmG5MpR0LQGU+wiPuDUDLm
 gEI0PsBz1WMXheE4xd8tyLfNBZ4cw/tQK9ru12pir037nAASkIcWeOaRRFul3I8XGrii
 MXSRvmJ3YI1Jfit4YorN4wjsQNUxC0+IiuFSxq8xyzaxPZScaYI3XxZm7B9SY+4c4cqk
 u9LIf3Cx8fc9RaYH7Lq8Xnw6nx+xWg38w/c4HQFTtePOjPNZ7a8fmeGsKnikutNnXmx3
 nk5xgLEa6GVphuPWXwad5NCoggI0CQT3Cn2pRUz0jyEreN84xo3MJZeyHt8j6RiSHZYy
 Tyew==
X-Gm-Message-State: ACrzQf1+zXNcUOA7FEmRfQdwYPjQl3qxCQi7lISG+Qku/0nKlJQ+hxpw
 5Zx/IrXBcjS9CAtM1/HlnsucRSU=
X-Google-Smtp-Source: AMsMyM5cHIxx3BGamuUDyHW0NPVNke58O5XSz5v6UmrGOsmBcjAu7uIaew2O8hgxFF92rZiXUGymBjI=
X-Received: from pcc-desktop.svl.corp.google.com
 ([2620:15c:2ce:200:1b89:96f1:d30:e3c])
 (user=pcc job=sendgmr) by 2002:a25:8b10:0:b0:6b0:58a:f8f5 with SMTP id
 i16-20020a258b10000000b006b0058af8f5mr20788531ybl.524.1663732382089; Tue, 20
 Sep 2022 20:53:02 -0700 (PDT)
Date: Tue, 20 Sep 2022 20:51:36 -0700
In-Reply-To: <20220921035140.57513-1-pcc@google.com>
Message-Id: <20220921035140.57513-5-pcc@google.com>
Mime-Version: 1.0
References: <20220921035140.57513-1-pcc@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Subject: [PATCH v4 4/8] mm: Add PG_arch_3 page flag
From: Peter Collingbourne <pcc@google.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Cornelia Huck <cohuck@redhat.com>,
 Steven Price <steven.price@arm.com>, Marc Zyngier <maz@kernel.org>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Peter Collingbourne <pcc@google.com>, Evgenii Stepanov <eugenis@google.com>
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

As with PG_arch_2, this flag is only allowed on 64-bit architectures due
to the shortage of bits available. It will be used by the arm64 MTE code
in subsequent patches.

Signed-off-by: Peter Collingbourne <pcc@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Steven Price <steven.price@arm.com>
[catalin.marinas@arm.com: added flag preserving in __split_huge_page_tail()]
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 fs/proc/page.c                    | 1 +
 include/linux/kernel-page-flags.h | 1 +
 include/linux/page-flags.h        | 1 +
 include/trace/events/mmflags.h    | 1 +
 mm/huge_memory.c                  | 1 +
 5 files changed, 5 insertions(+)

diff --git a/fs/proc/page.c b/fs/proc/page.c
index 6f4b4bcb9b0d..43d371e6b366 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -220,6 +220,7 @@ u64 stable_page_flags(struct page *page)
 	u |= kpf_copy_bit(k, KPF_ARCH,		PG_arch_1);
 #ifdef CONFIG_ARCH_USES_PG_ARCH_X
 	u |= kpf_copy_bit(k, KPF_ARCH_2,	PG_arch_2);
+	u |= kpf_copy_bit(k, KPF_ARCH_3,	PG_arch_3);
 #endif
 
 	return u;
diff --git a/include/linux/kernel-page-flags.h b/include/linux/kernel-page-flags.h
index eee1877a354e..859f4b0c1b2b 100644
--- a/include/linux/kernel-page-flags.h
+++ b/include/linux/kernel-page-flags.h
@@ -18,5 +18,6 @@
 #define KPF_UNCACHED		39
 #define KPF_SOFTDIRTY		40
 #define KPF_ARCH_2		41
+#define KPF_ARCH_3		42
 
 #endif /* LINUX_KERNEL_PAGE_FLAGS_H */
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 5dc7977edf9d..c50ce2812f17 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -134,6 +134,7 @@ enum pageflags {
 #endif
 #ifdef CONFIG_ARCH_USES_PG_ARCH_X
 	PG_arch_2,
+	PG_arch_3,
 #endif
 #ifdef CONFIG_KASAN_HW_TAGS
 	PG_skip_kasan_poison,
diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
index 4673e58a7626..9db52bc4ce19 100644
--- a/include/trace/events/mmflags.h
+++ b/include/trace/events/mmflags.h
@@ -130,6 +130,7 @@ IF_HAVE_PG_HWPOISON(PG_hwpoison,	"hwpoison"	)		\
 IF_HAVE_PG_IDLE(PG_young,		"young"		)		\
 IF_HAVE_PG_IDLE(PG_idle,		"idle"		)		\
 IF_HAVE_PG_ARCH_X(PG_arch_2,		"arch_2"	)		\
+IF_HAVE_PG_ARCH_X(PG_arch_3,		"arch_3"	)		\
 IF_HAVE_PG_SKIP_KASAN_POISON(PG_skip_kasan_poison, "skip_kasan_poison")
 
 #define show_page_flags(flags)						\
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 24974a4ce28f..c7c5f9fb226d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2446,6 +2446,7 @@ static void __split_huge_page_tail(struct page *head, int tail,
 			 (1L << PG_unevictable) |
 #ifdef CONFIG_ARCH_USES_PG_ARCH_X
 			 (1L << PG_arch_2) |
+			 (1L << PG_arch_3) |
 #endif
 			 (1L << PG_dirty) |
 			 LRU_GEN_MASK | LRU_REFS_MASK));
-- 
2.37.3.968.ga6b4b080e4-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
