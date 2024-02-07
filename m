Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870837E784
	for <kvmarm@lists.linux.dev>; Wed,  7 Feb 2024 14:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707317362; cv=none; b=chArXj2CjuB02H3X4f7tmksd/7xTOHe7MnxKGMgfVVnh92Oh1moTIXlDHQ8Xm/RLd/J/rp/7oQm7bKHSoffvAANeJXuBzvypN/DrxEjUQphcW8FqNc5TEZ2cwBcOduu0yogGnj/rx3hd3QhcspSF/UVIvw/8p9cMZdrzTbDMfdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707317362; c=relaxed/simple;
	bh=6vzgHsVxuihU3g4TMAduWqr1ZW75RviyAlTg5U5fA5M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sOfVXlgGCM9GhDtJKkwmpaKUMwkKMlt8sctJZOguQ1bCCrXvyEhiHWmxM2qDxI9DqzkxSw+Ex5mBKBGCpaJFdeAEpILKtTKih1+Ira8po7cf8CvKvFdfjh7K74KBjVfeVZFjtk4sRnElZSVPM4w+PbsMxC+Ki59eaboNRiYJae4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2smyAEu+; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2smyAEu+"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc64b659a9cso1170660276.3
        for <kvmarm@lists.linux.dev>; Wed, 07 Feb 2024 06:49:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707317359; x=1707922159; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KuSad3U75XWRyrG0hVFC7e1TsgCe+6P5oSqEz6h0Hdo=;
        b=2smyAEu+50vh4MyjtUxDWnd3bzxlH+PjSE1URVEXs0NuLkluPCkJlIsZpbJ2ljrrxD
         VuStcqmwDdSRp4hPN/wgTXRvpNx/9FeSu7FUNkIJGjjLUp6btAYqo7y3al8XbGBcWVzI
         a8orZeCcmbp4TgaxP1+cJ+9lLD+lz1XPEsMa3wZMVOmAfJhjuXNGLXAP8jdSdLvTHdi6
         wCOu4gbOd4Vi9PxCvn5R3iuQ9c/eF84uj0eZ29xe8Vr/uuLOeIASEVq/Jm3Zr4gt4pX6
         eF6dAnn2//oBXWvCuFIruz5mKHLn6kxLwxuB3y9+WLwd/mWW2vQsMpp6caEau0gC4HEH
         pvGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707317359; x=1707922159;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KuSad3U75XWRyrG0hVFC7e1TsgCe+6P5oSqEz6h0Hdo=;
        b=YbTJw0yi/4Eaz4K9uzlMmDiJyFaAvV0fDpMGCjetdWoE1QT0GI+37KN+V+ZfX/trOn
         BjVe0OahylnqpOhnsCGIENhIyiss6DhU2+KF5sHEm3dBnR1LcPNubPniHLxCGJta7Fnj
         76Ucm6BK5ZgG7fkkWPNjAdqYkpeWrzpSmygoNpv42vx0LMUErNrGk0e1Tmo2eRCUuz0m
         C9o3imQT1du9/Z1wvGOladnH1JSsJ/Sj/QEyepNKCmuh2lPESgSCtPUwIU5a/AJnW7T0
         DDEYUE+MzAGZW69nYaTpxuYgwVONxhUjTr6Jl/0d6D8BsstILATOxe1oX9UBfKbSaBJJ
         R+cw==
X-Gm-Message-State: AOJu0Ywf2AJVgUkcvBpeQfN0IEjOmYY8m3btf1X6E3+KUj8kfXJQq8Z3
	kHeH2q+V/qaB+XpbfIMSRFtYG4ZBXFfrhgeXQQMWeg9OYH/HB0E/4lZqJOMU942g3DzAsJn66N3
	pNteRIHUyh304F6kQ9KhQGJoBWA==
X-Google-Smtp-Source: AGHT+IFtCuGfAeqFdgjl+E/TRR4RFQ5mbVlens49Mh0ShuT1nuemqiHaz2jdZNbdKjru2453mCpm44BAccO7UGz0AYU=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:cd5])
 (user=sebastianene job=sendgmr) by 2002:a05:6902:200c:b0:dc6:53c3:bcbd with
 SMTP id dh12-20020a056902200c00b00dc653c3bcbdmr1272474ybb.7.1707317359551;
 Wed, 07 Feb 2024 06:49:19 -0800 (PST)
Date: Wed,  7 Feb 2024 14:48:30 +0000
In-Reply-To: <20240207144832.1017815-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240207144832.1017815-2-sebastianene@google.com>
X-Mailer: git-send-email 2.43.0.594.gd9cf4e227d-goog
Message-ID: <20240207144832.1017815-3-sebastianene@google.com>
Subject: [PATCH v5 1/4] arm64: ptdump: Expose the attribute parsing functionality
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, gshan@redhat.com, james.morse@arm.com, 
	mark.rutland@arm.com, maz@kernel.org, oliver.upton@linux.dev, 
	rananta@google.com, ricarkol@google.com, ryan.roberts@arm.com, 
	shahuang@redhat.com, suzuki.poulose@arm.com, will@kernel.org, 
	yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kernel-team@android.com, vdonnefort@google.com, 
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
index 581caac525b0..23510be35084 100644
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
index e305b6593c4e..64127c70b109 100644
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
2.43.0.594.gd9cf4e227d-goog

