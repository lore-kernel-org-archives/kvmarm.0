Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78BA6E57E
	for <kvmarm@lists.linux.dev>; Tue,  8 Aug 2023 10:21:30 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-583c49018c6so64824687b3.0
        for <kvmarm@lists.linux.dev>; Tue, 08 Aug 2023 03:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691490089; x=1692094889;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LIkYxQB49dC0FQNHu2erIkpIfETNvfhvCz995ch8SuY=;
        b=eGKzGkRmwHjO3/n1QcWNjJOltyC41u0duV0TVTZ3fBMgGDl0nlQ5QiRp7lOQAsE7QO
         OGr2AAIfLtRW2QiBskIUQSU2DGwjDOx7UMVUgMhvxWw/gE++HwEMAvv7dC/CU3+R4HMt
         GzhlZLUY2AGzPICPTPx5NbJmIyVj52XRkSbsKdm9qGLcq7/xfg0KX88jfLPuSqFKZFv2
         ha1KlWQw7jxa9v/R0N3pMeV5TzG0W+8X0/EZX7J+jnqEG00HIpJFpFLo2GvWg7evJYo1
         ewY4Ufv9e369vjGwh85Jn1JoVfJCD1dE9/tT9sf7m+Wi9s2I9JgifsHU2zq8qO0/nbKl
         FnWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691490089; x=1692094889;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LIkYxQB49dC0FQNHu2erIkpIfETNvfhvCz995ch8SuY=;
        b=PNQQ6i7apg0YaIUHay9HhvZ54zbnftGhrtap1O5o3EuzKagC2LhCtrjptpJlCDlvTP
         z/D1DD17ae3I/4MulMRls10JP9JcfM3lLzaZmLPf1KWFV45kBgWuak3SpQHEYmEZoAWu
         ERt3OuIxV0fox68khvV98StCwT8EDcgGXwSfVNrZcCW6I0Xzs54Ja7Rda0Eq97YVVv97
         /pk3LUVatOocRqfY7KVdnIoiCVVEnHcn4rvihg0I2iCq6XgqJAB3RcRtG5vwBjFuu49j
         dfsgwKouGeS4KlO2dqkd5z87l6BW1x+vsGhmyRdjWq3DLH6njJJoPupSDDgNMcDR3Bcp
         w5AQ==
X-Gm-Message-State: AOJu0YztXYP07Ne/2+/Lx8hNO/BwHmWN23TKTPA7/GubqNF83ERSU18L
	n1Z6c9QXpumJeDY6MtKAQctf6JIR9A==
X-Google-Smtp-Source: AGHT+IHxvhUVKdMAT1tPy5MkypgIrF/CSoYfvgc0eKx9Lu6TYjeI7LJ8ieHcAdveSGPemZkzK5rR5O62Ng==
X-Received: from elver.muc.corp.google.com ([2a00:79e0:9c:201:39c0:833d:c267:7f64])
 (user=elver job=sendgmr) by 2002:a81:451f:0:b0:577:617b:f881 with SMTP id
 s31-20020a81451f000000b00577617bf881mr88047ywa.8.1691490089320; Tue, 08 Aug
 2023 03:21:29 -0700 (PDT)
Date: Tue,  8 Aug 2023 12:17:26 +0200
In-Reply-To: <20230808102049.465864-1-elver@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230808102049.465864-1-elver@google.com>
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
Message-ID: <20230808102049.465864-2-elver@google.com>
Subject: [PATCH v3 2/3] list_debug: Introduce inline wrappers for debug checks
From: Marco Elver <elver@google.com>
To: elver@google.com, Andrew Morton <akpm@linux-foundation.org>, 
	Kees Cook <keescook@chromium.org>
Cc: Guenter Roeck <linux@roeck-us.net>, Peter Zijlstra <peterz@infradead.org>, 
	Mark Rutland <mark.rutland@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Tom Rix <trix@redhat.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	Dmitry Vyukov <dvyukov@google.com>, Alexander Potapenko <glider@google.com>, kasan-dev@googlegroups.com, 
	linux-toolchains@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Turn the list debug checking functions __list_*_valid() into inline
functions that wrap the out-of-line functions. Care is taken to ensure
the inline wrappers are always inlined, so that additional compiler
instrumentation (such as sanitizers) does not result in redundant
outlining.

This change is preparation for performing checks in the inline wrappers.

No functional change intended.

Signed-off-by: Marco Elver <elver@google.com>
---
v3:
* Rename ___list_*_valid() to __list_*_valid_or_report().
* Some documentation.
---
 arch/arm64/kvm/hyp/nvhe/list_debug.c |  6 ++---
 include/linux/list.h                 | 37 +++++++++++++++++++++++++---
 lib/list_debug.c                     | 11 ++++-----
 3 files changed, 41 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/list_debug.c b/arch/arm64/kvm/hyp/nvhe/list_debug.c
index d68abd7ea124..16266a939a4c 100644
--- a/arch/arm64/kvm/hyp/nvhe/list_debug.c
+++ b/arch/arm64/kvm/hyp/nvhe/list_debug.c
@@ -26,8 +26,8 @@ static inline __must_check bool nvhe_check_data_corruption(bool v)
 
 /* The predicates checked here are taken from lib/list_debug.c. */
 
-bool __list_add_valid(struct list_head *new, struct list_head *prev,
-		      struct list_head *next)
+bool __list_add_valid_or_report(struct list_head *new, struct list_head *prev,
+				struct list_head *next)
 {
 	if (NVHE_CHECK_DATA_CORRUPTION(next->prev != prev) ||
 	    NVHE_CHECK_DATA_CORRUPTION(prev->next != next) ||
@@ -37,7 +37,7 @@ bool __list_add_valid(struct list_head *new, struct list_head *prev,
 	return true;
 }
 
-bool __list_del_entry_valid(struct list_head *entry)
+bool __list_del_entry_valid_or_report(struct list_head *entry)
 {
 	struct list_head *prev, *next;
 
diff --git a/include/linux/list.h b/include/linux/list.h
index f10344dbad4d..130c6a1bb45c 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -39,10 +39,39 @@ static inline void INIT_LIST_HEAD(struct list_head *list)
 }
 
 #ifdef CONFIG_DEBUG_LIST
-extern bool __list_add_valid(struct list_head *new,
-			      struct list_head *prev,
-			      struct list_head *next);
-extern bool __list_del_entry_valid(struct list_head *entry);
+/*
+ * Performs the full set of list corruption checks before __list_add().
+ * On list corruption reports a warning, and returns false.
+ */
+extern bool __list_add_valid_or_report(struct list_head *new,
+				       struct list_head *prev,
+				       struct list_head *next);
+
+/*
+ * Performs list corruption checks before __list_add(). Returns false if a
+ * corruption is detected, true otherwise.
+ */
+static __always_inline bool __list_add_valid(struct list_head *new,
+					     struct list_head *prev,
+					     struct list_head *next)
+{
+	return __list_add_valid_or_report(new, prev, next);
+}
+
+/*
+ * Performs the full set of list corruption checks before __list_del_entry().
+ * On list corruption reports a warning, and returns false.
+ */
+extern bool __list_del_entry_valid_or_report(struct list_head *entry);
+
+/*
+ * Performs list corruption checks before __list_del_entry(). Returns false if a
+ * corruption is detected, true otherwise.
+ */
+static __always_inline bool __list_del_entry_valid(struct list_head *entry)
+{
+	return __list_del_entry_valid_or_report(entry);
+}
 #else
 static inline bool __list_add_valid(struct list_head *new,
 				struct list_head *prev,
diff --git a/lib/list_debug.c b/lib/list_debug.c
index d98d43f80958..2def33b1491f 100644
--- a/lib/list_debug.c
+++ b/lib/list_debug.c
@@ -17,8 +17,8 @@
  * attempt).
  */
 
-bool __list_add_valid(struct list_head *new, struct list_head *prev,
-		      struct list_head *next)
+bool __list_add_valid_or_report(struct list_head *new, struct list_head *prev,
+				struct list_head *next)
 {
 	if (CHECK_DATA_CORRUPTION(prev == NULL,
 			"list_add corruption. prev is NULL.\n") ||
@@ -37,9 +37,9 @@ bool __list_add_valid(struct list_head *new, struct list_head *prev,
 
 	return true;
 }
-EXPORT_SYMBOL(__list_add_valid);
+EXPORT_SYMBOL(__list_add_valid_or_report);
 
-bool __list_del_entry_valid(struct list_head *entry)
+bool __list_del_entry_valid_or_report(struct list_head *entry)
 {
 	struct list_head *prev, *next;
 
@@ -65,6 +65,5 @@ bool __list_del_entry_valid(struct list_head *entry)
 		return false;
 
 	return true;
-
 }
-EXPORT_SYMBOL(__list_del_entry_valid);
+EXPORT_SYMBOL(__list_del_entry_valid_or_report);
-- 
2.41.0.640.ga95def55d0-goog

