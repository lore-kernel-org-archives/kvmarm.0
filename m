Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C919C8BE3
	for <kvmarm@lists.linux.dev>; Wed,  2 Aug 2023 15:07:35 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5847479b559so81356287b3.1
        for <kvmarm@lists.linux.dev>; Wed, 02 Aug 2023 08:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690988854; x=1691593654;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QsQzCCvgsUc29iN0t+r4OrRLxcOlAg596pNmSZ7559A=;
        b=4ZYamtVu7c5DBlxohGCGmrb3sFLfmn9HVQ5Wg0u74wgUuS9HmeqzsIbgmvxx4vbynp
         G5rhNqMQc/y5nAAokrb8biNfvQGEp8VjT02HxfGGmCTT5wPDSvxvnVw8kiA6iPjuGFVD
         LA+s86W47CrKMLOaDF3oTsFV1irTVQ90npxdXPTIsyYRRVrnjksYD/YOpvA5gcb/NJON
         1/DNjlxIfTxKKGGO7EWAXeVsoT9Ba6/DtSkaghydahqdF14skDb3T2FlkiHoREdye/Wn
         PP4uXHlG/PZ7eozLUn1Qs2nxG2z0Y5gSqG2d0rJKhv4XdK6rQ2bU5XD8YUaBIrlQg13L
         ZuFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690988854; x=1691593654;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QsQzCCvgsUc29iN0t+r4OrRLxcOlAg596pNmSZ7559A=;
        b=MZWvqmmZQ9vpObNYJQEAlAV8LZ7Jfank5YDg4Kcryp1OzaBItR65ZKDnRh6pFK+zPO
         APVOnbM7Qc/sLDLOvcwnnQY+oFCb8KsUH4EBWF5tru1dmJv9I932gwLFY1l+V06gqX15
         k/4CJ4fdXTz4LxsbCZsAezGmDwU8cBz/Sov47eyuNyVGl3qBKlq3mcxo+VlOjnDlRfnz
         a0pbH2bhBDaQKK3uvXeNqbqY0laa+o2KlgOccHali48nEldKTaJR9qo6h9c1hXzF4poV
         S3cjPp06f0KEgOm53ApLE7J2IvPMgNjGWXFc6UcrDyWHapSCkMzeC/mKBwREWxR/WU4A
         BDKA==
X-Gm-Message-State: ABy/qLaCOlPldPLEUtO3tDnpZ9qCAYci5b5ybJE/Ojpwjwh3dqywJvQU
	U797ERbDF0r+CA7X6qUfnKHuWXxvzQ==
X-Google-Smtp-Source: APBJJlF2dxbHCNlW4tE69srWZHv4LNf1FBrEIP73vEfLojj7ssYK9cpF/2NfJOSE1k3fWGXBcvsb8SmIjQ==
X-Received: from elver.muc.corp.google.com ([2a00:79e0:9c:201:5f73:1fc0:c9fd:f203])
 (user=elver job=sendgmr) by 2002:a81:b50d:0:b0:586:4e84:26d2 with SMTP id
 t13-20020a81b50d000000b005864e8426d2mr79140ywh.3.1690988854773; Wed, 02 Aug
 2023 08:07:34 -0700 (PDT)
Date: Wed,  2 Aug 2023 17:06:39 +0200
In-Reply-To: <20230802150712.3583252-1-elver@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230802150712.3583252-1-elver@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230802150712.3583252-3-elver@google.com>
Subject: [PATCH 3/3] list_debug: Introduce CONFIG_DEBUG_LIST_MINIMAL
From: Marco Elver <elver@google.com>
To: elver@google.com, Andrew Morton <akpm@linux-foundation.org>, 
	Kees Cook <keescook@chromium.org>
Cc: Guenter Roeck <linux@roeck-us.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Miguel Ojeda <ojeda@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Nathan Chancellor <nathan@kernel.org>, Tom Rix <trix@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	Dmitry Vyukov <dvyukov@google.com>, Alexander Potapenko <glider@google.com>, kasan-dev@googlegroups.com, 
	linux-toolchains@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Numerous production kernel configs (see [1, 2]) are choosing to enable
CONFIG_DEBUG_LIST, which is also being recommended by KSPP for hardened
configs [3]. The feature has never been designed with performance in
mind, yet common list manipulation is happening across hot paths all
over the kernel.

Introduce CONFIG_DEBUG_LIST_MINIMAL, which performs list pointer
checking inline, and only upon list corruption delegates to the
reporting slow path.

To generate optimal machine code with CONFIG_DEBUG_LIST_MINIMAL:

  1. Elide checking for pointer values which upon dereference would
     result in an immediate access fault -- therefore "minimal" checks.
     The trade-off is lower-quality error reports.

  2. Use the newly introduced __preserve_most function attribute
     (available with Clang, but not yet with GCC) to minimize the code
     footprint for calling the reporting slow path. As a result,
     function size of callers is reduced by avoiding saving registers
     before calling the rarely called reporting slow path.

  3. Because the inline checks are a subset of the full set of checks in
     ___list_*_valid(), always return false if the inline checks failed.
     This avoids redundant compare and conditional branch right after
     return from the slow path.

As a side-effect of the checks being inline, if the compiler can prove
some condition to always be true, it can completely elide some checks.

Running netperf with CONFIG_DEBUG_LIST_MINIMAL (using a Clang compiler
with "preserve_most") shows throughput improvements, in my case of ~7%
on average (up to 20-30% on some test cases).

Link: https://r.android.com/1266735 [1]
Link: https://gitlab.archlinux.org/archlinux/packaging/packages/linux/-/blob/main/config [2]
Link: https://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project/Recommended_Settings [3]
Signed-off-by: Marco Elver <elver@google.com>
---
 arch/arm64/kvm/hyp/nvhe/list_debug.c |  2 +
 include/linux/list.h                 | 56 +++++++++++++++++++++++++---
 lib/Kconfig.debug                    | 15 ++++++++
 lib/list_debug.c                     |  2 +
 4 files changed, 69 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/list_debug.c b/arch/arm64/kvm/hyp/nvhe/list_debug.c
index 589284496ac5..df718e29f6d4 100644
--- a/arch/arm64/kvm/hyp/nvhe/list_debug.c
+++ b/arch/arm64/kvm/hyp/nvhe/list_debug.c
@@ -26,6 +26,7 @@ static inline __must_check bool nvhe_check_data_corruption(bool v)
 
 /* The predicates checked here are taken from lib/list_debug.c. */
 
+__list_valid_slowpath
 bool ___list_add_valid(struct list_head *new, struct list_head *prev,
 		       struct list_head *next)
 {
@@ -37,6 +38,7 @@ bool ___list_add_valid(struct list_head *new, struct list_head *prev,
 	return true;
 }
 
+__list_valid_slowpath
 bool ___list_del_entry_valid(struct list_head *entry)
 {
 	struct list_head *prev, *next;
diff --git a/include/linux/list.h b/include/linux/list.h
index e0b2cf904409..a28a215a3eb1 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -39,20 +39,64 @@ static inline void INIT_LIST_HEAD(struct list_head *list)
 }
 
 #ifdef CONFIG_DEBUG_LIST
-extern bool ___list_add_valid(struct list_head *new,
-			      struct list_head *prev,
-			      struct list_head *next);
+
+#ifdef CONFIG_DEBUG_LIST_MINIMAL
+# define __list_valid_slowpath __cold __preserve_most
+#else
+# define __list_valid_slowpath
+#endif
+
+extern bool __list_valid_slowpath ___list_add_valid(struct list_head *new,
+						    struct list_head *prev,
+						    struct list_head *next);
 static __always_inline bool __list_add_valid(struct list_head *new,
 					     struct list_head *prev,
 					     struct list_head *next)
 {
-	return ___list_add_valid(new, prev, next);
+	bool ret = true;
+
+	if (IS_ENABLED(CONFIG_DEBUG_LIST_MINIMAL)) {
+		/*
+		 * In the minimal config, elide checking if next and prev are
+		 * NULL, since the immediate dereference of them below would
+		 * result in a fault if NULL.
+		 *
+		 * With the minimal config we can afford to inline the checks,
+		 * which also gives the compiler a chance to elide some of them
+		 * completely if they can be proven at compile-time. If one of
+		 * the pre-conditions does not hold, the slow-path will show a
+		 * report which pre-condition failed.
+		 */
+		if (likely(next->prev == prev && prev->next == next && new != prev && new != next))
+			return true;
+		ret = false;
+	}
+
+	ret &= ___list_add_valid(new, prev, next);
+	return ret;
 }
 
-extern bool ___list_del_entry_valid(struct list_head *entry);
+extern bool __list_valid_slowpath ___list_del_entry_valid(struct list_head *entry);
 static __always_inline bool __list_del_entry_valid(struct list_head *entry)
 {
-	return ___list_del_entry_valid(entry);
+	bool ret = true;
+
+	if (IS_ENABLED(CONFIG_DEBUG_LIST_MINIMAL)) {
+		struct list_head *prev = entry->prev;
+		struct list_head *next = entry->next;
+
+		/*
+		 * In the minimal config, elide checking if next and prev are
+		 * NULL, LIST_POISON1 or LIST_POISON2, since the immediate
+		 * dereference of them below would result in a fault.
+		 */
+		if (likely(prev->next == entry && next->prev == entry))
+			return true;
+		ret = false;
+	}
+
+	ret &= ___list_del_entry_valid(entry);
+	return ret;
 }
 #else
 static inline bool __list_add_valid(struct list_head *new,
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index fbc89baf7de6..e72cf08af0fa 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1680,6 +1680,21 @@ config DEBUG_LIST
 
 	  If unsure, say N.
 
+config DEBUG_LIST_MINIMAL
+	bool "Minimal linked list debug checks"
+	default !DEBUG_KERNEL
+	depends on DEBUG_LIST
+	help
+	  Only perform the minimal set of checks in the linked-list walking
+	  routines to catch corruptions that are not guaranteed to result in an
+	  immediate access fault.
+
+	  This trades lower quality error reports for improved performance: the
+	  generated code should be more optimal and provide trade-offs that may
+	  better serve safety- and performance- critical environments.
+
+	  If unsure, say Y.
+
 config DEBUG_PLIST
 	bool "Debug priority linked list manipulation"
 	depends on DEBUG_KERNEL
diff --git a/lib/list_debug.c b/lib/list_debug.c
index fd69009cc696..daad32855f0d 100644
--- a/lib/list_debug.c
+++ b/lib/list_debug.c
@@ -17,6 +17,7 @@
  * attempt).
  */
 
+__list_valid_slowpath
 bool ___list_add_valid(struct list_head *new, struct list_head *prev,
 		       struct list_head *next)
 {
@@ -39,6 +40,7 @@ bool ___list_add_valid(struct list_head *new, struct list_head *prev,
 }
 EXPORT_SYMBOL(___list_add_valid);
 
+__list_valid_slowpath
 bool ___list_del_entry_valid(struct list_head *entry)
 {
 	struct list_head *prev, *next;
-- 
2.41.0.585.gd2178a4bd4-goog

