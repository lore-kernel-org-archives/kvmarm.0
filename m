Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E3919AD86
	for <kvmarm@lists.linux.dev>; Tue, 27 Aug 2024 08:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724748368; cv=none; b=Kx/dFASjDJ6+OHggcdhlIeKcPwxSITV6uLOe2m0CcuUrBW/f1wgag+XOugT6vf1B58+cLemwWo2TUheTUdtuBcb9J1COAl2zyuDNxesNJdtvZc9RvCEwcLdCJJcnkvi4wC9CRY+I7yOfFzdZF1Jsmx2/xCm72K3+0Ptq+K/cA6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724748368; c=relaxed/simple;
	bh=Lw37HyF37GzltMhnte000Ty23NUQC83Fy2jc5oyK3FA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TdUFrv/r6FjAa5hC6ht+LA2QaGc9BCAlutlXNPai3abo3yKUb+Xoj0/PAjggkLTPbvFmFYDD4VFQUmqGquwnY73OJGVrxWNn6hrDJFEBNfYCaI2SFxRHsesy8qRxYuNbC4yC8sbYI3sy5nDd3LOjP4i6Lu445rp9UWQ45ZxtXG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oXzjZjQJ; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oXzjZjQJ"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6b2249bf2d0so109104827b3.2
        for <kvmarm@lists.linux.dev>; Tue, 27 Aug 2024 01:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724748365; x=1725353165; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=S/4eIk6jI1tjaj4UGqml6oE2hCNIy1npmCkHCveHD80=;
        b=oXzjZjQJAn+U9S+0/ZVGtdPGSigCqlPLWdRoKxRbNq0Uuz712hxAJ+mejzdj69KQtM
         xM1Dzf18/FOt4FLmruGzylnw8HxQQA1JBQIlR5yyKZw7Q0gVK5O1deMaL6QWD2GPkw0A
         SaDMfInFK1FaSCtL8zcSjghCNNq+5aCZABfCpHWDevkLMG78Lll01Qudqhz6ckSom31x
         LadC7faVnchHUvsOX0AC9Hr6jjaph//7ocPGKySoOujQDtlf73MuPfV3LSyPyM60vwkO
         +6uFlimyYGkbnw8Xv22U14wvmQoVnbtE/iApP4xMi3IkFNgqoMgN96QCjNAn+bC+05Co
         VrBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724748365; x=1725353165;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S/4eIk6jI1tjaj4UGqml6oE2hCNIy1npmCkHCveHD80=;
        b=AqHgwnZvfzRpvaMpiBIzlZao0BqQmkDVDCAErFJsj5qoAup9NM5CTZrB8SQvg8UpMP
         rELrc+QAW1i8P2Xl1d7K3IM/dLTPrztDzitRI/YUJGpgx+wPDaFuNhWMKGE50xvBuU3A
         QOwwEtfrqB5LyXPDEkFXjmzEuR5DMbdtKI1EvcoSlwG+V1V68Xi+kyFjD5qYtefkQYlK
         LpFdcirDuJ55JR7sYUu5/CHIIUGOwWwoS829J4jdS83rfVKSM8XA2SI6KQ43vwNR2tXR
         +HXfPTQPUIOO0gwibBxcL52ruoc3Cmv7uIpP+TZBXq0XOnW4l39KSD36FPY3xGABC/dQ
         0uFg==
X-Gm-Message-State: AOJu0YxfAINSEwttOZ0ViVtALQ0NlO5PI6sbTqzNzncBYbaVN25Hrpws
	G16V/4oS9E7gmSSyvajDe/LEezAD3eCK3ieNo6lJrj8L/E5sVriqRBBK3soaw6I6/TwrMZnhk3N
	dy8b2r0jSxbDExI6i+TbXjuJP9w==
X-Google-Smtp-Source: AGHT+IH5RM7JuVVSPKnjdxxxYeoYnQeY0l7qLc/ywBgRIM547MLlZ6+2U/YgCfXhEykPoaO06zqlMD4Kq2MFsPnHn0E=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:cd5])
 (user=sebastianene job=sendgmr) by 2002:a05:690c:4a06:b0:62d:1142:83a5 with
 SMTP id 00721157ae682-6cfbbadf920mr1801177b3.8.1724748365682; Tue, 27 Aug
 2024 01:46:05 -0700 (PDT)
Date: Tue, 27 Aug 2024 08:45:46 +0000
In-Reply-To: <20240827084549.45731-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240827084549.45731-1-sebastianene@google.com>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <20240827084549.45731-4-sebastianene@google.com>
Subject: [PATCH v9 3/5] arm64: ptdump: Use the ptdump description from a local context
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

Rename the attributes description array to allow the parsing method
to use the description from a local context. To be able to do this,
store a pointer to the description array in the state structure. This
will allow for the later introduced callers (stage_2 ptdump) to specify
their own page table description format to the ptdump parser.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/include/asm/ptdump.h |  1 +
 arch/arm64/mm/ptdump.c          | 13 ++++++++-----
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/ptdump.h b/arch/arm64/include/asm/ptdump.h
index bd5d3ee3e8dc..71a7ed01153a 100644
--- a/arch/arm64/include/asm/ptdump.h
+++ b/arch/arm64/include/asm/ptdump.h
@@ -44,6 +44,7 @@ struct ptdump_pg_level {
  */
 struct ptdump_pg_state {
 	struct ptdump_state ptdump;
+	struct ptdump_pg_level *pg_level;
 	struct seq_file *seq;
 	const struct addr_marker *marker;
 	const struct mm_struct *mm;
diff --git a/arch/arm64/mm/ptdump.c b/arch/arm64/mm/ptdump.c
index 404751fd30fe..ca53ef274a8b 100644
--- a/arch/arm64/mm/ptdump.c
+++ b/arch/arm64/mm/ptdump.c
@@ -117,7 +117,7 @@ static const struct ptdump_prot_bits pte_bits[] = {
 	}
 };
 
-static struct ptdump_pg_level pg_level[] __ro_after_init = {
+static struct ptdump_pg_level kernel_pg_levels[] __ro_after_init = {
 	{ /* pgd */
 		.name	= "PGD",
 		.bits	= pte_bits,
@@ -192,6 +192,7 @@ void note_page(struct ptdump_state *pt_st, unsigned long addr, int level,
 	       u64 val)
 {
 	struct ptdump_pg_state *st = container_of(pt_st, struct ptdump_pg_state, ptdump);
+	struct ptdump_pg_level *pg_level = st->pg_level;
 	static const char units[] = "KMGTPE";
 	u64 prot = 0;
 
@@ -262,6 +263,7 @@ void ptdump_walk(struct seq_file *s, struct ptdump_info *info)
 		.seq = s,
 		.marker = info->markers,
 		.mm = info->mm,
+		.pg_level = &kernel_pg_levels[0],
 		.level = -1,
 		.ptdump = {
 			.note_page = note_page,
@@ -279,10 +281,10 @@ static void __init ptdump_initialize(void)
 {
 	unsigned i, j;
 
-	for (i = 0; i < ARRAY_SIZE(pg_level); i++)
-		if (pg_level[i].bits)
-			for (j = 0; j < pg_level[i].num; j++)
-				pg_level[i].mask |= pg_level[i].bits[j].mask;
+	for (i = 0; i < ARRAY_SIZE(kernel_pg_levels); i++)
+		if (kernel_pg_levels[i].bits)
+			for (j = 0; j < kernel_pg_levels[i].num; j++)
+				kernel_pg_levels[i].mask |= kernel_pg_levels[i].bits[j].mask;
 }
 
 static struct ptdump_info kernel_ptdump_info __ro_after_init = {
@@ -297,6 +299,7 @@ bool ptdump_check_wx(void)
 			{ 0, NULL},
 			{ -1, NULL},
 		},
+		.pg_level = &kernel_pg_levels[0],
 		.level = -1,
 		.check_wx = true,
 		.ptdump = {
-- 
2.46.0.295.g3b9ea8a38a-goog

