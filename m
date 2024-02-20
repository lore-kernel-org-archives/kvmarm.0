Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A2276040
	for <kvmarm@lists.linux.dev>; Tue, 20 Feb 2024 15:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708441899; cv=none; b=n2dGh/pJMFf8Hq7BXZdBcKQDAV4xiC9s9xUdbCQ/tGhR4y2CnX37X8934oVGqqlsBT5vB4humJMURhVhRveUvQMMCRCF/aZcbtOvyYh1+S5kwImr9L/2kk4bgORNUWytit+kSnlQOtyFc8DANI5mY5sg7w93lTEXfN3Kc9C4RJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708441899; c=relaxed/simple;
	bh=NJa1BLuTC1M9IXyS8cUBmrPvfsMqCbFinRO8836TETA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mhtOPd5ka9VS+5uqKrlnx4lpt/3J1wWZyEIzScM05DXHlnBgTWtskQxe2QF7MwLyAB6GjkrZ6S6miBi78BZSeroq9nHZhhGqBJnM92M5REWZbZyxUQGCZjNsE6GXcpbAdcDuIvM1stSVCGni5P26H41SF2IrTTlrfexnUznck7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uOkA0VXI; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uOkA0VXI"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc657e9bdc4so6582722276.0
        for <kvmarm@lists.linux.dev>; Tue, 20 Feb 2024 07:11:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708441897; x=1709046697; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=I0gsyti8lKhCK+AHvAHuyBhR7vYZPhP9z/P4jDBYvrE=;
        b=uOkA0VXIw6k6Ce5JhS3e6W1q9GHe/kOoV9gknWR9gC1qTQpfouIGSRPSA2Co3CfX54
         Jax780Enhr3HlUQEYzbKUtU5lQoDbdP88mnD08ufsw+ejd3ZPX3OGLzWnUujeMOUMihi
         NzXXeOEmY/qof2DqzjcClaImduYIuOastHoIGL3hLQy5J37G2sBAtGVFoi9x5yhbh6v3
         uU/eNqchlzB2/PjG0bHSrpnYUMoWB0u7a2LBPVQLJw/EkMQtH0kcpgRz2Zk3oZzbPcnD
         wqH0ZqmEt2ynTGdI69j8fK+3ft0E5PpT4TDJkPiaz3f/pb/EHA1TUv1kvh9XIGr1m8CC
         GgGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708441897; x=1709046697;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I0gsyti8lKhCK+AHvAHuyBhR7vYZPhP9z/P4jDBYvrE=;
        b=dsQLoFAUHHAXHf723kP6jQ/l2pOjb5SV7JF9Ohq2egdJO1FiTAGnAcvvr/dU/MUs9w
         FRqVwHMKOHm1zWcef/9sEPH/ooh1JMdFH++Q5amYxzvRU0A4BWZcqqNBVUpsWfykJzde
         xP+QIFosAAT+OCy19XHo5WwnT4uOmHtMA8bBiqeHPTl8eoTwtmpYExbJEH+HwyUQPjG5
         40u/VOZH2glytA1RKs1qxHGwOXJ6zg5wIJnisGn3xxbZeIf6QMN9Dgv1grkH0nxeiEXG
         ze0Ds6UOKOBJDfXSQ5pVuUGyfnMqO1Ha/Wv8FHYqSYa006cAaah/tXW/Xju8SHoEhSVO
         d/8Q==
X-Gm-Message-State: AOJu0YwPnyAOKka5Ip+Ho1A/A/eDKHNnu2ZAuTFf5Nd0i2WXAXqAK2lJ
	RVLeHmGla+8eEI/mc/MD776pskxzE73N/o0AKfnQyeNDJNFULGV6FFYdzADlB+iy+FVuEDwaxeF
	3kC1CTiaZIO0FGnRknBiLzk9Ngg==
X-Google-Smtp-Source: AGHT+IG+jlQa4S4iBavS25d/TUrwEAyS5uvZXS9pyLoDz2YsufCK6yJuxUh5mwLf78C/X5obDHvN6CN7NkZOThXn3Fk=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:cd5])
 (user=sebastianene job=sendgmr) by 2002:a05:6902:1008:b0:dbe:a0c2:df25 with
 SMTP id w8-20020a056902100800b00dbea0c2df25mr871279ybt.8.1708441897282; Tue,
 20 Feb 2024 07:11:37 -0800 (PST)
Date: Tue, 20 Feb 2024 15:10:31 +0000
In-Reply-To: <20240220151035.327199-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240220151035.327199-1-sebastianene@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240220151035.327199-3-sebastianene@google.com>
Subject: [PATCH v6 2/6] arm64: ptdump: Expose the attribute parsing functionality
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
2.44.0.rc0.258.g7320e95886-goog

