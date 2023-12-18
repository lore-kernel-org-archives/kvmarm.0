Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 710133A1BC
	for <kvmarm@lists.linux.dev>; Mon, 18 Dec 2023 13:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yROqgg19"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3335231c733so1378330f8f.0
        for <kvmarm@lists.linux.dev>; Mon, 18 Dec 2023 05:59:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702907995; x=1703512795; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/snQWpLs/9aDAfFwDwLoi7Q0iJhDc3rGT80KePC/RNs=;
        b=yROqgg19ie0wq3K+/sdJ+ClfaYZc57xTKy8hzegpywVH4bbVcI+p18b12G4rCcvL/G
         NdHyUoMyiT14S6ju56j84FOcngRZcVVphWK+fzTbuS+HZRtrD/6AL3hEGjGe6EKAhpPP
         Qvhc8H0cRK78FibKLS9cQjLoegBaGxmkODQzE6kvGbEk+D39+Vo2505+1kGejTJcqMuB
         oqx/01XfEhg4GdlzHRqOR4vJKw/sYaWvKf3kJ6KJ+ZgmrjeGMeSXr8sH1rDsZ4hNGhVp
         yMEVTYjVz1XigmTZRoH18HvCrvuOShxBRYfUUCOdQRR4FbLDhyOkq/Qp1HgUr6zRFveH
         XULg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702907995; x=1703512795;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/snQWpLs/9aDAfFwDwLoi7Q0iJhDc3rGT80KePC/RNs=;
        b=MZDgf3vFWfYaUNrtDwzeOQQ1OiQ0ad15qVMmUZHmj3oSL2BCGpkrRLq9Qm7kPXVDQC
         VxG4MrXapQmiK6xh15kqkBoCkFeMWBE9yggpA67i1hgic5eNc6CoBj0n/MyjL3EkG9kI
         sVxh40I1EUMHITpY54tQGqH4/gBQtq0+ogRRXIxNA42PC7Pg1jZ++q743P2hkChQb6kr
         dkOx8Q9QceCIh6SBu1kL8LZJS/nclSaywOyAZh0H8vbsJsKPyrr1peNaZxnHQZgEdTPw
         SHs05T+FcK0Bd6jSpL8vlpEwzZR8zzAWdLTwlOVABs4s8QEWLcb6HaxE+jj/o/6WT3yw
         /6Bg==
X-Gm-Message-State: AOJu0Yx5o047Ntn1GTdfPygQ2VRYicao6s3ZwXLP4NdgX9Ngu/u+8aa9
	8MtJ7C1eTMFBawzyktb561gi7BVCvGVXkNUvJrU=
X-Google-Smtp-Source: AGHT+IGcU8IkdlfTmgAO7aC/oFs5X2llBNjhnb3I0wUbMfWOUAWu8CT+O1oF7roOu+Kzu88bosaE4t8ma3t0wuku/bU=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:cd5])
 (user=sebastianene job=sendgmr) by 2002:adf:f548:0:b0:336:68ff:e929 with SMTP
 id j8-20020adff548000000b0033668ffe929mr7158wrp.5.1702907995808; Mon, 18 Dec
 2023 05:59:55 -0800 (PST)
Date: Mon, 18 Dec 2023 13:58:54 +0000
In-Reply-To: <20231218135859.2513568-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231218135859.2513568-2-sebastianene@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231218135859.2513568-6-sebastianene@google.com>
Subject: [PATCH v4 04/10] arm64: ptdump: Expose the attribute parsing functionality
From: Sebastian Ene <sebastianene@google.com>
To: will@kernel.org, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, catalin.marinas@arm.com, mark.rutland@arm.com, 
	akpm@linux-foundation.org, maz@kernel.org
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kernel-team@android.com, vdonnefort@google.com, 
	qperret@google.com, smostafa@google.com, 
	Sebastian Ene <sebastianene@google.com>
Content-Type: text/plain; charset="UTF-8"

To keep the same output format as the arch specific ptdump and for the
sake of reusability, move the parser's state tracking code out
of the arch specific.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/include/asm/ptdump.h | 41 ++++++++++++++++++++++++++++++++-
 arch/arm64/mm/ptdump.c          | 36 ++---------------------------
 2 files changed, 42 insertions(+), 35 deletions(-)

diff --git a/arch/arm64/include/asm/ptdump.h b/arch/arm64/include/asm/ptdump.h
index 581caac52..23510be35 100644
--- a/arch/arm64/include/asm/ptdump.h
+++ b/arch/arm64/include/asm/ptdump.h
@@ -9,6 +9,8 @@
 
 #include <linux/mm_types.h>
 #include <linux/seq_file.h>
+#include <linux/ptdump.h>
+
 
 struct addr_marker {
 	unsigned long start_address;
@@ -21,15 +23,52 @@ struct ptdump_info {
 	unsigned long			base_addr;
 };
 
+struct prot_bits {
+	u64		mask;
+	u64		val;
+	const char	*set;
+	const char	*clear;
+};
+
+struct pg_level {
+	const struct prot_bits	*bits;
+	const char		*name;
+	size_t			num;
+	u64			mask;
+};
+
+/*
+ * The page dumper groups page table entries of the same type into a single
+ * description. It uses pg_state to track the range information while
+ * iterating over the pte entries. When the continuity is broken it then
+ * dumps out a description of the range.
+ */
+struct pg_state {
+	struct ptdump_state		ptdump;
+	struct seq_file			*seq;
+	const struct addr_marker	*marker;
+	unsigned long			start_address;
+	int				level;
+	u64				current_prot;
+	bool				check_wx;
+	unsigned long			wx_pages;
+	unsigned long			uxn_pages;
+};
+
 void ptdump_walk(struct seq_file *s, struct ptdump_info *info);
+void note_page(struct ptdump_state *pt_st, unsigned long addr, int level,
+	       u64 val);
 #ifdef CONFIG_PTDUMP_DEBUGFS
 #define EFI_RUNTIME_MAP_END	DEFAULT_MAP_WINDOW_64
 void __init ptdump_debugfs_register(struct ptdump_info *info, const char *name);
 #else
 static inline void ptdump_debugfs_register(struct ptdump_info *info,
 					   const char *name) { }
-#endif
+#endif /* CONFIG_PTDUMP_DEBUGFS */
 void ptdump_check_wx(void);
+#else
+static inline void note_page(void *pt_st, unsigned long addr,
+			     int level, u64 val) { }
 #endif /* CONFIG_PTDUMP_CORE */
 
 #ifdef CONFIG_DEBUG_WX
diff --git a/arch/arm64/mm/ptdump.c b/arch/arm64/mm/ptdump.c
index e305b6593..64127c70b 100644
--- a/arch/arm64/mm/ptdump.c
+++ b/arch/arm64/mm/ptdump.c
@@ -66,31 +66,6 @@ static struct addr_marker address_markers[] = {
 		seq_printf(m, fmt);	\
 })
 
-/*
- * The page dumper groups page table entries of the same type into a single
- * description. It uses pg_state to track the range information while
- * iterating over the pte entries. When the continuity is broken it then
- * dumps out a description of the range.
- */
-struct pg_state {
-	struct ptdump_state ptdump;
-	struct seq_file *seq;
-	const struct addr_marker *marker;
-	unsigned long start_address;
-	int level;
-	u64 current_prot;
-	bool check_wx;
-	unsigned long wx_pages;
-	unsigned long uxn_pages;
-};
-
-struct prot_bits {
-	u64		mask;
-	u64		val;
-	const char	*set;
-	const char	*clear;
-};
-
 static const struct prot_bits pte_bits[] = {
 	{
 		.mask	= PTE_VALID,
@@ -170,13 +145,6 @@ static const struct prot_bits pte_bits[] = {
 	}
 };
 
-struct pg_level {
-	const struct prot_bits *bits;
-	const char *name;
-	size_t num;
-	u64 mask;
-};
-
 static struct pg_level pg_level[] = {
 	{ /* pgd */
 		.name	= "PGD",
@@ -248,8 +216,8 @@ static void note_prot_wx(struct pg_state *st, unsigned long addr)
 	st->wx_pages += (addr - st->start_address) / PAGE_SIZE;
 }
 
-static void note_page(struct ptdump_state *pt_st, unsigned long addr, int level,
-		      u64 val)
+void note_page(struct ptdump_state *pt_st, unsigned long addr, int level,
+	       u64 val)
 {
 	struct pg_state *st = container_of(pt_st, struct pg_state, ptdump);
 	static const char units[] = "KMGTPE";
-- 
2.43.0.472.g3155946c3a-goog

