Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188B93A1D0
	for <kvmarm@lists.linux.dev>; Mon, 18 Dec 2023 13:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SMo8aSJg"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5e50add1a12so30257487b3.3
        for <kvmarm@lists.linux.dev>; Mon, 18 Dec 2023 05:59:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702907998; x=1703512798; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mFw1xMXqNfgjkaBSBUL3X2hMTwwdH9z1Qrb9oU+YYCg=;
        b=SMo8aSJgjVNbZCxxzUpqOFL3ghUr9wJw0Pp4hqSvU7kYMlQfHNfPi2TbY1RnI6hEBw
         qJpmmRcIX4bYP0BDHTzfZ0bJMYuxhMXUSRkDQZcC6F1FXpowHAm/XkGs4CR9Dv51nU5m
         CZ0WClbtzCEI7qEJlTshUAIbEIP75XgPxj0Mvqbz+Zbg/1KVuPlirbRHfdsDXUW+AeYK
         J5DweYh/Y8kBCV2D1Jn1AOIXJx2t+t/FEiQmMPu/9TcAx2MQOm6pZqJCHyUvcT6r+JHV
         lJWT4GS4Mr2l8SaarYeu/0khoHq/I4d2klLL4pxsbxDobd66glVHCG2/PQXGHkDJdcKT
         xTkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702907998; x=1703512798;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mFw1xMXqNfgjkaBSBUL3X2hMTwwdH9z1Qrb9oU+YYCg=;
        b=b/09Qnvhbgq+H9HNiAfznxcJzxRqs2Ft+PdpB7ASBLRAKPraX4vbXLwSGpfLZp7zEn
         +gs01cPyaJih9zKZEvAk/ORrGAulvygx7DjkFSACJcz2GTp9uLJfWAjhkI8eczsJH2QK
         0vNxqh9OSiVsxmc4E5xcUyCvzuvdzxLbWrnHf4DIPKKECRnB45nEIkCIwacoD3jh5jlZ
         SEinoTduLLTMDH/5y3uv+eajhWrbEwF8jUCDk4934lNVdJyqqiOWv6P5TYgGxlmQ65ib
         neX6Ou0iKu88aGszc+L/E1pOdXOMgpL94nV1rtbLkJhUKtpGZqLD7hAqrFcpzcS+YKxe
         9mTg==
X-Gm-Message-State: AOJu0YwuUksHwpFI32hbUMIHIL0N8+cntQzGnLmHy2hpGwgSMxrZr9pu
	Ui/0ORkGkWZUKzn8PWU7vNSkYrVGX+Q8ZzFuMa8=
X-Google-Smtp-Source: AGHT+IEFAVylPAkwhhH2AZEDt0+C92z4jGsfWuRL60FJ8EEzto9BtF/sl4dbwHDk1YbX1tmslSZZ2vCCzauBKs4CL5A=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:cd5])
 (user=sebastianene job=sendgmr) by 2002:a25:8a09:0:b0:db5:4d59:3b30 with SMTP
 id g9-20020a258a09000000b00db54d593b30mr1613891ybl.8.1702907998064; Mon, 18
 Dec 2023 05:59:58 -0800 (PST)
Date: Mon, 18 Dec 2023 13:58:55 +0000
In-Reply-To: <20231218135859.2513568-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231218135859.2513568-2-sebastianene@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231218135859.2513568-7-sebastianene@google.com>
Subject: [PATCH v4 05/10] arm64: ptdump: Use the mask from the state structure
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
index 23510be35..4e728d2a1 100644
--- a/arch/arm64/include/asm/ptdump.h
+++ b/arch/arm64/include/asm/ptdump.h
@@ -45,6 +45,7 @@ struct pg_level {
  */
 struct pg_state {
 	struct ptdump_state		ptdump;
+	struct pg_level			*pg_level;
 	struct seq_file			*seq;
 	const struct addr_marker	*marker;
 	unsigned long			start_address;
diff --git a/arch/arm64/mm/ptdump.c b/arch/arm64/mm/ptdump.c
index 64127c70b..015ed65d3 100644
--- a/arch/arm64/mm/ptdump.c
+++ b/arch/arm64/mm/ptdump.c
@@ -220,11 +220,12 @@ void note_page(struct ptdump_state *pt_st, unsigned long addr, int level,
 	       u64 val)
 {
 	struct pg_state *st = container_of(pt_st, struct pg_state, ptdump);
+	struct pg_level *pg_info = st->pg_level;
 	static const char units[] = "KMGTPE";
 	u64 prot = 0;
 
 	if (level >= 0)
-		prot = val & pg_level[level].mask;
+		prot = val & pg_info[level].mask;
 
 	if (st->level == -1) {
 		st->level = level;
@@ -250,10 +251,10 @@ void note_page(struct ptdump_state *pt_st, unsigned long addr, int level,
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
@@ -284,6 +285,7 @@ void ptdump_walk(struct seq_file *s, struct ptdump_info *info)
 	st = (struct pg_state){
 		.seq = s,
 		.marker = info->markers,
+		.pg_level = &pg_level[0],
 		.level = -1,
 		.ptdump = {
 			.note_page = note_page,
@@ -321,6 +323,7 @@ void ptdump_check_wx(void)
 			{ 0, NULL},
 			{ -1, NULL},
 		},
+		.pg_level = &pg_level[0],
 		.level = -1,
 		.check_wx = true,
 		.ptdump = {
-- 
2.43.0.472.g3155946c3a-goog

