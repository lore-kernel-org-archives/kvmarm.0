Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA3A1553A2
	for <kvmarm@lists.linux.dev>; Fri, 21 Jun 2024 12:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718973168; cv=none; b=Qrw5iYAEFPjKdMCdWgAStnq7AfCnRj24aMBe7njzKuCmqQtN0KzTKb4/YRDgNkqOOdCI5l3LiBZ5G9r8qLeGqKJAP++DP9dJnwbB8tEAEnS+B+0pHfD+docYi7JZjLHtqefP/ISJzAy+mUfANu0AZ5/MSyWkJkcJgAHERLJUxRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718973168; c=relaxed/simple;
	bh=XvKH8yB7+J6NL1xJMHOJ0ToppJXlMKTu2n7fXKk/DyQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=epPbQUk5gjz4m5U3yn4ATnUOmjsB5iysCftJqR0GTNmSHmJUoWD4qcmDZhSzgPnEthEkeYCzJVQoVVgtlA3Zfmlp/E9gO9Ok49MJ//KTupXkY7IXTcSIND0I37W6/dvU9rrV+cPz7Ual+y5je85ZlcQHKdJSMrzw6LRFbJZC0Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BfjgTyKU; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BfjgTyKU"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-42181c64596so13572275e9.1
        for <kvmarm@lists.linux.dev>; Fri, 21 Jun 2024 05:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718973164; x=1719577964; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CfipnPazTooSWljHtj0QKg/sbCS/LwM8w5FGtvn8eIw=;
        b=BfjgTyKUgN8R8TA5DnOB8lUfkocIPchOKIwOaRVEL7ChTF+NqPDcSjG3qaYm6B6zj/
         4WpiwGC1Gptu3tjq8FE/GM0qj3cByy3NiXScBCVql6JX34ZKBW3Z9ajnC6xXNQJq9xQS
         6YvuuG5p5Yk67Cy+zLbw+X1qZo2TIpinCwFih+bNydmNEC5EclwRnb6xKScnm5dA9/pF
         SaG7tNpyWJsaOfqVUuZtGsQIqJVVd+p6A9RtIqECOp72bn++vtJLyskEthDfgtyebp5Y
         yiBVaGgENK1jctcYHFIuZ9LVOt9cVhmTTkZ1m3ku0LvyGB5ZpzPgEHwEsTSK1vvH8L1N
         vAlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718973164; x=1719577964;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CfipnPazTooSWljHtj0QKg/sbCS/LwM8w5FGtvn8eIw=;
        b=PmZa8BmmTWl2i+cW7SaHTteWntiyfN+EQVO/a/iSxPGkTPFWQO1wXeDpAebOq9iP4j
         FGv+9GlAUx9HpBJhlSKv6IurNINJ/EFjzOa/RDAjP/evm3Fh06bzypnQwwd0IPO+wYIA
         yC1LG8bJU/ODW4hQSPvBVZ3qEy/LAgC4LKPWoid7vF3KJjfVqCjNv3bchFNuf4zgmy6d
         4CQyGmdxPn8I4AGQEJcf7mGR1JB3SZav5P/5Rc1Jgz6/etnidDQzU9yXrnYvfrlgabJ6
         cYYSa2YfuTzAvbbfh+FrO/98ooN5qK+z7v9os+k84EhbqjMEqGklGWOJkOlV6OZcJ7m6
         Pbcw==
X-Gm-Message-State: AOJu0YxrDf4tAag0hAOx4QW/kyq9XJaRJXJyqeiHgFY2ow/NX1va6wM6
	KSgFlK/RTygYWEUwLkUIUCn9qfzuJC8dSrP0+NP9WXuSFocpEJRmDG7IZsdjALZZ1WBwxJZp/aY
	6PJosHkEGr+7l+WcSKEAOd5sW0A==
X-Google-Smtp-Source: AGHT+IGRdi8iCVedSAjQTPJq6auLk/a0anHCRS31CgRh12LvFMpWeGYnx6ArZlAwPEeWqjlBpzoOnFCppGjHDAYrqfw=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:cd5])
 (user=sebastianene job=sendgmr) by 2002:a05:600c:3b9f:b0:421:7dc3:9a0c with
 SMTP id 5b1f17b1804b1-4247529a86bmr593065e9.3.1718973164436; Fri, 21 Jun 2024
 05:32:44 -0700 (PDT)
Date: Fri, 21 Jun 2024 12:32:27 +0000
In-Reply-To: <20240621123230.1085265-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240621123230.1085265-1-sebastianene@google.com>
X-Mailer: git-send-email 2.45.2.741.gdbec12cfda-goog
Message-ID: <20240621123230.1085265-4-sebastianene@google.com>
Subject: [PATCH v7 3/6] arm64: ptdump: Use the mask from the state structure
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

Printing the descriptor attributes requires accessing a mask which has a
different set of attributes for stage-2. In preparation for adding support
for the stage-2 pagetables dumping, use the mask from the local context
and not from the globally defined pg_level array. Store a pointer to
the pg_level array in the ptdump state structure. This will allow us to
extract the mask which is wrapped in the pg_level array and use it for
descriptor parsing in the note_page.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/include/asm/ptdump.h |  1 +
 arch/arm64/mm/ptdump.c          | 13 ++++++++-----
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/ptdump.h b/arch/arm64/include/asm/ptdump.h
index c550b2afcab7..a4125d8d5a32 100644
--- a/arch/arm64/include/asm/ptdump.h
+++ b/arch/arm64/include/asm/ptdump.h
@@ -44,6 +44,7 @@ struct pg_level {
  */
 struct pg_state {
 	struct ptdump_state ptdump;
+	struct pg_level *pg_level;
 	struct seq_file *seq;
 	const struct addr_marker *marker;
 	const struct mm_struct *mm;
diff --git a/arch/arm64/mm/ptdump.c b/arch/arm64/mm/ptdump.c
index e370b7a945de..9637a6415ea7 100644
--- a/arch/arm64/mm/ptdump.c
+++ b/arch/arm64/mm/ptdump.c
@@ -192,6 +192,7 @@ void note_page(struct ptdump_state *pt_st, unsigned long addr, int level,
 	       u64 val)
 {
 	struct pg_state *st = container_of(pt_st, struct pg_state, ptdump);
+	struct pg_level *pg_info = st->pg_level;
 	static const char units[] = "KMGTPE";
 	u64 prot = 0;
 
@@ -201,7 +202,7 @@ void note_page(struct ptdump_state *pt_st, unsigned long addr, int level,
 		level = 0;
 
 	if (level >= 0)
-		prot = val & pg_level[level].mask;
+		prot = val & pg_info[level].mask;
 
 	if (st->level == -1) {
 		st->level = level;
@@ -227,10 +228,10 @@ void note_page(struct ptdump_state *pt_st, unsigned long addr, int level,
 			unit++;
 		}
 		pt_dump_seq_printf(st->seq, "%9lu%c %s", delta, *unit,
-				   pg_level[st->level].name);
-		if (st->current_prot && pg_level[st->level].bits)
-			dump_prot(st, pg_level[st->level].bits,
-				  pg_level[st->level].num);
+				   pg_info[st->level].name);
+		if (st->current_prot && pg_info[st->level].bits)
+			dump_prot(st, pg_info[st->level].bits,
+				  pg_info[st->level].num);
 		pt_dump_seq_puts(st->seq, "\n");
 
 		if (addr >= st->marker[1].start_address) {
@@ -262,6 +263,7 @@ void ptdump_walk(struct seq_file *s, struct ptdump_info *info)
 		.seq = s,
 		.marker = info->markers,
 		.mm = info->mm,
+		.pg_level = &pg_level[0],
 		.level = -1,
 		.ptdump = {
 			.note_page = note_page,
@@ -297,6 +299,7 @@ bool ptdump_check_wx(void)
 			{ 0, NULL},
 			{ -1, NULL},
 		},
+		.pg_level = &pg_level[0],
 		.level = -1,
 		.check_wx = true,
 		.ptdump = {
-- 
2.45.2.741.gdbec12cfda-goog

