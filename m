Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F8A81B86D0
	for <kvmarm@lists.linux.dev>; Mon,  9 Sep 2024 12:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725886053; cv=none; b=EsoYkc7lLYgd2SXhZ20OsjWF13nRBVACNoxpc2z67Yhzr8QM/dxa4oSakiYKXibQOAit7hMtK1aCaNKY2xrjKERR2nbS1UKOR82AV8AbgXkG+Osq6B79nw1EnTih6PX45RlKXY2wL2jjyuZshUwTKMR6GY7cPIvN9Y8wfp5FJhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725886053; c=relaxed/simple;
	bh=VgYapO8i1qKDRRRsUo0MTuUblS7PQzfXlK6ZkBqLlsI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kfT0urQdqpnH7z8vavQKQ3rtxnZLF5ZmhUaBhNwahkI0UaAlVf5nrtOptkIBQiDV4kpx4aiJRAhME/GlxLl2ZpwJE1oNv9tLcj5egwE+VZXdVh7NUFIkiNnw2FC4sM26cCp1+HCaj/9Xo3AVbxaHyiGAKNBvfWIBGM7ecKkhCdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Q+Ue09fU; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q+Ue09fU"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-374b9a8512dso2069983f8f.2
        for <kvmarm@lists.linux.dev>; Mon, 09 Sep 2024 05:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725886049; x=1726490849; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rOyTNrjRYeC5V1YoJMilLcLgHHeqHqjXzH9wfdwY9sw=;
        b=Q+Ue09fUI7gAfHuGsNtMp0F1Iel32aFz02ycf8ZE7exnHYzf5lqClJE8xNHDEHV+lU
         nzaQqlcxq1p623UGdHlPa+qdKrRyafC0KVEEtkRy8kXsUl/rQsMp3W2B3EzexipB88+X
         uk5iHzVjNDO/1oJTKPWxWId/2UJoavn+TEayUeOeYS3U+1dXtEZ/J/3FOqqAjBi+Uo7T
         m9RgLrvWlnof+Sj5hC5K5TvJP9bWLuDsCkWPYGjeBsMPkTMV5ksb4cMJuzTVaPHaBiKT
         Z4CGPJsBMdfQ182IKxySnB/EoH8nU+EENfsWQG+GKDcCFYVe3RoxaCYpHYE53pvO2J9Q
         yRqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725886049; x=1726490849;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rOyTNrjRYeC5V1YoJMilLcLgHHeqHqjXzH9wfdwY9sw=;
        b=j6Ld21PolkFBw8INQCP/4HH7fJF1HuJ1q1x1mFZjSDHwNfuR+CC21pObMDDI7V+cUH
         zMVfejmqyj+Ex7CI04SrE7XPa+rC2AZJiUecCkHu4N72DFi+7Or2Lv3e+YpmBDIzsOcy
         gs1bEwWP6RpB3wMlJDGtMEAQUk2c8R1tX1tEZSW2nTpqr2bzB/2t2GrWsyxT21jQvcB0
         +Iq1lty+/FdKOrti4i5WH9WPVyRyAcMBoPNpEfeJLOGllpERC4GiS8VRQmKd3xf9sil1
         CGztTsGf8QtcHSaCusTyaNAJ+iDhKAq6/HRQdn3H0keISHGkl8ICpjHCcpuuTROTZyY4
         sSmw==
X-Gm-Message-State: AOJu0YxIVUnmCvceRUb8H3pxjhmaItQMEp5IC//lIJsu+tle6TrEzAyl
	3At/tkTh7vXHCS03PEWOJHNsvcE7dkG3E8zl5nl76iWGU4vplEvW0zYa/iMVdB/DlyKRJT0fz1a
	iDRvmKSs8JXOtnXnjssE/rTFOdw==
X-Google-Smtp-Source: AGHT+IG+ip5lnTk9ayqB7jP8eGKNbUqkVkAL495AT+0kgCNA1tzshuDCmFE76GVP0BcqGg2a70PypynTTnHwd3R29A0=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:68:fe9:ac10:f1b7])
 (user=sebastianene job=sendgmr) by 2002:a05:6000:1281:b0:374:cad2:a75e with
 SMTP id ffacd0b85a97d-378895c2527mr13872f8f.1.1725886049120; Mon, 09 Sep 2024
 05:47:29 -0700 (PDT)
Date: Mon,  9 Sep 2024 12:47:18 +0000
In-Reply-To: <20240909124721.1672199-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240909124721.1672199-1-sebastianene@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240909124721.1672199-3-sebastianene@google.com>
Subject: [PATCH v10 2/5] arm64: ptdump: Expose the attribute parsing functionality
From: Sebastian Ene <sebastianene@google.com>
To: akpm@linux-foundation.org, alexghiti@rivosinc.com, ankita@nvidia.com, 
	ardb@kernel.org, catalin.marinas@arm.com, christophe.leroy@csgroup.eu, 
	james.morse@arm.com, vdonnefort@google.com, mark.rutland@arm.com, 
	maz@kernel.org, oliver.upton@linux.dev, rananta@google.com, 
	ryan.roberts@arm.com, sebastianene@google.com, shahuang@redhat.com, 
	suzuki.poulose@arm.com, will@kernel.org, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"

Reuse the descriptor parsing functionality to keep the same output format
as the original ptdump code. In order for this to happen, move the state
tracking objects into a common header.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/include/asm/ptdump.h | 41 +++++++++++++++++++++++-
 arch/arm64/mm/ptdump.c          | 55 +++++++--------------------------
 2 files changed, 51 insertions(+), 45 deletions(-)

diff --git a/arch/arm64/include/asm/ptdump.h b/arch/arm64/include/asm/ptdump.h
index 5b1701c76d1c..bd5d3ee3e8dc 100644
--- a/arch/arm64/include/asm/ptdump.h
+++ b/arch/arm64/include/asm/ptdump.h
@@ -9,6 +9,7 @@
 
 #include <linux/mm_types.h>
 #include <linux/seq_file.h>
+#include <linux/ptdump.h>
 
 struct addr_marker {
 	unsigned long start_address;
@@ -21,14 +22,52 @@ struct ptdump_info {
 	unsigned long			base_addr;
 };
 
+struct ptdump_prot_bits {
+	u64		mask;
+	u64		val;
+	const char	*set;
+	const char	*clear;
+};
+
+struct ptdump_pg_level {
+	const struct ptdump_prot_bits *bits;
+	char name[4];
+	int num;
+	u64 mask;
+};
+
+/*
+ * The page dumper groups page table entries of the same type into a single
+ * description. It uses pg_state to track the range information while
+ * iterating over the pte entries. When the continuity is broken it then
+ * dumps out a description of the range.
+ */
+struct ptdump_pg_state {
+	struct ptdump_state ptdump;
+	struct seq_file *seq;
+	const struct addr_marker *marker;
+	const struct mm_struct *mm;
+	unsigned long start_address;
+	int level;
+	u64 current_prot;
+	bool check_wx;
+	unsigned long wx_pages;
+	unsigned long uxn_pages;
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
+#else
+static inline void note_page(void *pt_st, unsigned long addr,
+			     int level, u64 val) { }
 #endif /* CONFIG_PTDUMP_CORE */
 
 #endif /* __ASM_PTDUMP_H */
diff --git a/arch/arm64/mm/ptdump.c b/arch/arm64/mm/ptdump.c
index 6986827e0d64..404751fd30fe 100644
--- a/arch/arm64/mm/ptdump.c
+++ b/arch/arm64/mm/ptdump.c
@@ -38,33 +38,7 @@
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
-	const struct mm_struct *mm;
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
-static const struct prot_bits pte_bits[] = {
+static const struct ptdump_prot_bits pte_bits[] = {
 	{
 		.mask	= PTE_VALID,
 		.val	= PTE_VALID,
@@ -143,14 +117,7 @@ static const struct prot_bits pte_bits[] = {
 	}
 };
 
-struct pg_level {
-	const struct prot_bits *bits;
-	char name[4];
-	int num;
-	u64 mask;
-};
-
-static struct pg_level pg_level[] __ro_after_init = {
+static struct ptdump_pg_level pg_level[] __ro_after_init = {
 	{ /* pgd */
 		.name	= "PGD",
 		.bits	= pte_bits,
@@ -174,7 +141,7 @@ static struct pg_level pg_level[] __ro_after_init = {
 	},
 };
 
-static void dump_prot(struct pg_state *st, const struct prot_bits *bits,
+static void dump_prot(struct ptdump_pg_state *st, const struct ptdump_prot_bits *bits,
 			size_t num)
 {
 	unsigned i;
@@ -192,7 +159,7 @@ static void dump_prot(struct pg_state *st, const struct prot_bits *bits,
 	}
 }
 
-static void note_prot_uxn(struct pg_state *st, unsigned long addr)
+static void note_prot_uxn(struct ptdump_pg_state *st, unsigned long addr)
 {
 	if (!st->check_wx)
 		return;
@@ -206,7 +173,7 @@ static void note_prot_uxn(struct pg_state *st, unsigned long addr)
 	st->uxn_pages += (addr - st->start_address) / PAGE_SIZE;
 }
 
-static void note_prot_wx(struct pg_state *st, unsigned long addr)
+static void note_prot_wx(struct ptdump_pg_state *st, unsigned long addr)
 {
 	if (!st->check_wx)
 		return;
@@ -221,10 +188,10 @@ static void note_prot_wx(struct pg_state *st, unsigned long addr)
 	st->wx_pages += (addr - st->start_address) / PAGE_SIZE;
 }
 
-static void note_page(struct ptdump_state *pt_st, unsigned long addr, int level,
-		      u64 val)
+void note_page(struct ptdump_state *pt_st, unsigned long addr, int level,
+	       u64 val)
 {
-	struct pg_state *st = container_of(pt_st, struct pg_state, ptdump);
+	struct ptdump_pg_state *st = container_of(pt_st, struct ptdump_pg_state, ptdump);
 	static const char units[] = "KMGTPE";
 	u64 prot = 0;
 
@@ -286,12 +253,12 @@ static void note_page(struct ptdump_state *pt_st, unsigned long addr, int level,
 void ptdump_walk(struct seq_file *s, struct ptdump_info *info)
 {
 	unsigned long end = ~0UL;
-	struct pg_state st;
+	struct ptdump_pg_state st;
 
 	if (info->base_addr < TASK_SIZE_64)
 		end = TASK_SIZE_64;
 
-	st = (struct pg_state){
+	st = (struct ptdump_pg_state){
 		.seq = s,
 		.marker = info->markers,
 		.mm = info->mm,
@@ -324,7 +291,7 @@ static struct ptdump_info kernel_ptdump_info __ro_after_init = {
 
 bool ptdump_check_wx(void)
 {
-	struct pg_state st = {
+	struct ptdump_pg_state st = {
 		.seq = NULL,
 		.marker = (struct addr_marker[]) {
 			{ 0, NULL},
-- 
2.46.0.469.g59c65b2a67-goog

