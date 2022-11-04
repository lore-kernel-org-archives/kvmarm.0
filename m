Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8FA2C43217
	for <kvmarm@archiver.kernel.org>; Fri,  4 Nov 2022 01:11:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C4E640D23;
	Thu,  3 Nov 2022 21:11:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JYnFYUfrn12w; Thu,  3 Nov 2022 21:11:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DBF1A49ECB;
	Thu,  3 Nov 2022 21:11:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B30CD41070
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 21:11:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id USmBQa4ypsj0 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Nov 2022 21:11:09 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 61A2C410F3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 21:11:09 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 205-20020a2503d6000000b006d2132f6f85so1984039ybd.16
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Nov 2022 18:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=rPYxlKSPJfSZtg3Q9jRN1rfy7iNW7lamdhzlzuPASYU=;
 b=EK2CfW/zJnZP96rUOilP2BktF4iuKcovvHFosZ0YeJeb3KtLyxVdRs+D+ycgLZnrDs
 /U1zBGKJpog9nLofxSIuFaqr2jVa7nL1vUHMZeBDya1ZBBx/l0v/fomj9VLAOL9zzhwn
 /Vpcsgo66C+hsDcSK7koi10JNVEgt5RMOa9zq41iBuvOQ9uSU0tZOW2vSe0r/Iq4/ojB
 sK2FOPfqs+DBQU+SdmnHptlRBihaxWXN/QOq4hb+Lj8xIpzIrJhxT+t9qkI/1UnsPe8M
 aaLWMX2hJsQBFMgxL5zDMHc5kkYNBCaDT1sNb4CTMZrELH7Yhw/M7cLA8ZI7KXAf6w3M
 7SlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=rPYxlKSPJfSZtg3Q9jRN1rfy7iNW7lamdhzlzuPASYU=;
 b=oIDfEBcWELPN9LRWCpg54drrhoinnaPD5wxqZaxbDbV7YwPrH24tyHSTbu1oug9a+j
 Yi5NA7Yw/EpuS+LVx/8Dhy3Zm0BJEJKSeoa+3AFvvPRnmYc6yvLDx97TZpg+qseV8Vah
 kUC/WcBs8s+1vW734mCXsMEFFr5GxK2H34hwDM9esFPLh6Toku7cQ2MRVPB+/ccensYy
 wc+22rPQhWfrsF3yV/pKNF+U1ud4ifWSqwNu1UzYRauqBIk9nR/1kxm6fqXDX4JJp4G5
 3lHLGzZEw+/rWApVcHw26jkILS4kL/rPSra85sGLNcUGwEdZZYYpHQfu5iI1sh4DT9y6
 emOQ==
X-Gm-Message-State: ACrzQf0HN3S9S41gE8B2pCxQNenjzd6OPW5aZ44OMEzugrvZ7Qg9bYaF
 T/5TgjbNT/W6JX0blNX0vCqtdNQ=
X-Google-Smtp-Source: AMsMyM4lZ0RBt0V0qrjSEpyMHEmom8fBptSXrmNmTvgvtT7vTA4SH5SZJVwz3XGowF95qq3jHThGkOU=
X-Received: from pcc-desktop.svl.corp.google.com
 ([2620:15c:2ce:200:2844:b0ec:e556:30d8])
 (user=pcc job=sendgmr) by 2002:a81:5385:0:b0:370:b29:abb3 with SMTP id
 h127-20020a815385000000b003700b29abb3mr30405462ywb.2.1667524269214; Thu, 03
 Nov 2022 18:11:09 -0700 (PDT)
Date: Thu,  3 Nov 2022 18:10:37 -0700
In-Reply-To: <20221104011041.290951-1-pcc@google.com>
Message-Id: <20221104011041.290951-5-pcc@google.com>
Mime-Version: 1.0
References: <20221104011041.290951-1-pcc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Subject: [PATCH v5 4/8] mm: Add PG_arch_3 page flag
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
Reviewed-by: Steven Price <steven.price@arm.com>
---
 fs/proc/page.c                    | 1 +
 include/linux/kernel-page-flags.h | 1 +
 include/linux/page-flags.h        | 1 +
 include/trace/events/mmflags.h    | 1 +
 mm/huge_memory.c                  | 1 +
 5 files changed, 5 insertions(+)

diff --git a/fs/proc/page.c b/fs/proc/page.c
index 882525c8e94c..6249c347809a 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -221,6 +221,7 @@ u64 stable_page_flags(struct page *page)
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
index 5d87dc4611b9..c509011bd4a2 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2403,6 +2403,7 @@ static void __split_huge_page_tail(struct page *head, int tail,
 			 (1L << PG_unevictable) |
 #ifdef CONFIG_ARCH_USES_PG_ARCH_X
 			 (1L << PG_arch_2) |
+			 (1L << PG_arch_3) |
 #endif
 			 (1L << PG_dirty) |
 			 LRU_GEN_MASK | LRU_REFS_MASK));
-- 
2.38.1.431.g37b22c650d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
