Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B920FCCA485
	for <kvmarm@archiver.kernel.org>; Fri, 22 Jul 2022 01:51:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 738C54C6EF;
	Thu, 21 Jul 2022 21:51:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pYj-QdVx8gul; Thu, 21 Jul 2022 21:51:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AB244C875;
	Thu, 21 Jul 2022 21:51:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED9464C859
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 21:51:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j0NNFA1rHrjw for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jul 2022 21:51:03 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D59074C830
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 21:51:02 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-31e63e48e49so28423707b3.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 18:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=TwIGZxOgt6rBe9wTaWtA8OadqnubKpslEOefQ0KlBYc=;
 b=NkaUVQiJc5jp+Kd2jx7nqyeLgTuFuMR+XL7JQsjYclkpdvHDVQSs++oKJUciE3moo+
 ++QPlhiRnCM5hnKWWKwiBeCGYNzfZRM70Zb8d/mMX9XxKQqkFWrFDMZRSYO/twzB9DN0
 tUhyOaKS+2VpTg2zP8AIXPINcgEvdnjIZfzofEXHRALLETPHGbIv2z7g7sbF89BagsaZ
 b/KrKcET0FOT7cYFKscqtzCKR+RGicAklN0CDyJtWmUdIv3BlWspqKD84OugLk/Qv9tT
 Dz4fo2RX85w/ryKRTsUDeumOGudpVjHMJzJIinDSj8vhiCxEZz5hgyjnyNLfK01rFbYu
 Z+iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=TwIGZxOgt6rBe9wTaWtA8OadqnubKpslEOefQ0KlBYc=;
 b=J6yVQGqy0E/G51/NhCVaVqBg48eMGikSaQQVuUm4XOad0efnrBUgl0x+nQ5kBbF1Cz
 /V/PM9KsnKc3KW286dVS1Y2tdef0hm3Dhsr6ow8PZE8ZyYxDuLPO64uNz8CUDt/GIqeY
 HCJeBvkCYbyLiAyR8iGQekt+p12ntTCSCv+X9bxFobFT88grbwq0m2iTx3mcNxV6UFg9
 NffYjP220WGEgCeh0cl2WOCMvv2zxJhRqE5yTAc5rnqagwjN7WvVSJvKIAYP+EMFCFPv
 WjWZwvkp4OsvlGKYBQGz1LZC7bjqWH9gBuHO+ntMOuqLdO3PJYE44oz1z1YW4jdwh5ts
 PBlg==
X-Gm-Message-State: AJIora+rTsMwJk9f6vjHZZ2gHz4dI81aeIsY6yFsMPnCWJRHR6DmOkGD
 hz9HKb4Fv2IhS0dRnbyT3OtjZXE=
X-Google-Smtp-Source: AGRyM1v5HWTX6JYtiwrUXhpyDwH9QneRyI4FxOnAArRXJ2u1OihyxjWyM/5NJuRzTZObSJn7lnprhPc=
X-Received: from pcc-desktop.svl.corp.google.com
 ([2620:15c:2ce:200:7ed4:5864:d5e1:ffe1])
 (user=pcc job=sendgmr) by 2002:a25:d512:0:b0:670:9301:a997 with SMTP id
 r18-20020a25d512000000b006709301a997mr1176046ybe.351.1658454662450; Thu, 21
 Jul 2022 18:51:02 -0700 (PDT)
Date: Thu, 21 Jul 2022 18:50:29 -0700
In-Reply-To: <20220722015034.809663-1-pcc@google.com>
Message-Id: <20220722015034.809663-4-pcc@google.com>
Mime-Version: 1.0
References: <20220722015034.809663-1-pcc@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v2 3/7] mm: Add PG_arch_3 page flag
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
 fs/proc/page.c                 | 1 +
 include/linux/page-flags.h     | 1 +
 include/trace/events/mmflags.h | 7 ++++---
 mm/huge_memory.c               | 1 +
 4 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/proc/page.c b/fs/proc/page.c
index a2873a617ae8..438b8aa7249d 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -220,6 +220,7 @@ u64 stable_page_flags(struct page *page)
 	u |= kpf_copy_bit(k, KPF_ARCH,		PG_arch_1);
 #ifdef CONFIG_64BIT
 	u |= kpf_copy_bit(k, KPF_ARCH_2,	PG_arch_2);
+	u |= kpf_copy_bit(k, KPF_ARCH_2,	PG_arch_3);
 #endif
 
 	return u;
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 465ff35a8c00..ad01a3abf6c8 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -134,6 +134,7 @@ enum pageflags {
 #endif
 #ifdef CONFIG_64BIT
 	PG_arch_2,
+	PG_arch_3,
 #endif
 #ifdef CONFIG_KASAN_HW_TAGS
 	PG_skip_kasan_poison,
diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
index 11524cda4a95..704380179986 100644
--- a/include/trace/events/mmflags.h
+++ b/include/trace/events/mmflags.h
@@ -91,9 +91,9 @@
 #endif
 
 #ifdef CONFIG_64BIT
-#define IF_HAVE_PG_ARCH_2(flag,string) ,{1UL << flag, string}
+#define IF_HAVE_PG_ARCH_2_3(flag,string) ,{1UL << flag, string}
 #else
-#define IF_HAVE_PG_ARCH_2(flag,string)
+#define IF_HAVE_PG_ARCH_2_3(flag,string)
 #endif
 
 #ifdef CONFIG_KASAN_HW_TAGS
@@ -129,7 +129,8 @@ IF_HAVE_PG_UNCACHED(PG_uncached,	"uncached"	)		\
 IF_HAVE_PG_HWPOISON(PG_hwpoison,	"hwpoison"	)		\
 IF_HAVE_PG_IDLE(PG_young,		"young"		)		\
 IF_HAVE_PG_IDLE(PG_idle,		"idle"		)		\
-IF_HAVE_PG_ARCH_2(PG_arch_2,		"arch_2"	)		\
+IF_HAVE_PG_ARCH_2_3(PG_arch_2,		"arch_2"	)		\
+IF_HAVE_PG_ARCH_2_3(PG_arch_3,		"arch_3"	)		\
 IF_HAVE_PG_SKIP_KASAN_POISON(PG_skip_kasan_poison, "skip_kasan_poison")
 
 #define show_page_flags(flags)						\
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8320874901f1..d6e8789e9ebb 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2399,6 +2399,7 @@ static void __split_huge_page_tail(struct page *head, int tail,
 			 (1L << PG_unevictable) |
 #ifdef CONFIG_64BIT
 			 (1L << PG_arch_2) |
+			 (1L << PG_arch_3) |
 #endif
 			 (1L << PG_dirty)));
 
-- 
2.37.1.359.gd136c6c3e2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
