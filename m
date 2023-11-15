Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C0017743
	for <kvmarm@lists.linux.dev>; Wed, 15 Nov 2023 17:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CycGH66N"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-da0ccfc4fc8so8898835276.2
        for <kvmarm@lists.linux.dev>; Wed, 15 Nov 2023 09:16:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1700068618; x=1700673418; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=y0A/JzsGt28jdcT80BavCxCwKvAhE81Bu7nGud0PArE=;
        b=CycGH66Njc9PC/qtTDvPzedGYZjMbv1V70/4iZN/5Zf2INQ5K1UPVR2Ap84aH7m+7S
         rpFBA74z+65hWoctjvshOHq3JopWYD658hc9JMrm6rirFhl+Rf9F+mxdksvR1eXqTgZz
         QNo+3MhaNCsCA0kTXhb677wymGpNlx7AJ8wimPmI4NTi+bjvSyi73uoGTN+swUFRn/RK
         naElrmfmGoAdJWk6s9w2PTLox9+m6GwrC97Z/XdUOUZ92H2zBv/UZSNi+EKlCN4qk476
         SGJ8FH5VADv9o0RfX9LfyAZTquF1fwttmAo19zl7Ju1ORS70jfje0r/HBQjNa1UI6jce
         tnkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700068618; x=1700673418;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y0A/JzsGt28jdcT80BavCxCwKvAhE81Bu7nGud0PArE=;
        b=nN2QIdmo+iMYlR3NrEz72uJFz3Q/vw7XYABJ+K62EPVrFg7HHb03qwtuEd2JZzy3KS
         tD9mupXRQ1zOgbtb04v9+UZYgqoMwJDQ3TTbjEjByk2GwJWAGoAB+azJyw8ZG0r50unt
         HXnt/ye0DTY+znhdDko0rePduw/INnzTRPLQTsmp7lvEDWc2qq1f2fZeNEqc7dR7Ne68
         Z5sEz511mLFKjQFT+I8gy31prCEYutOYEYSarTnNE9hcDp1SAzd+nJML8hedOoIw6vDZ
         0aUGqquN1mk9aKz9CYu3j+1M5Y4jpyeswlpDqQ97jajMebdHj2oBN0MleEr4b+oEFji5
         2lPw==
X-Gm-Message-State: AOJu0YzfTfFMxcXIDGeOHFvSqjRQi/AAz6vsg7dB8Rfs8/HkfOPXU9J+
	VnhiMiNqtd+cAXQGEKW/s9rSCmRq407noHWxvi0=
X-Google-Smtp-Source: AGHT+IHvlCAUAQ7rynEQW7WXWvObMDPO+YBhC2cqr0pMjotcdPVLuo899EzI/e2mZHuLUOn3sEwympOD+yO+Oto2Btk=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:cd5])
 (user=sebastianene job=sendgmr) by 2002:a25:3206:0:b0:da0:3da9:ce08 with SMTP
 id y6-20020a253206000000b00da03da9ce08mr324716yby.10.1700068618426; Wed, 15
 Nov 2023 09:16:58 -0800 (PST)
Date: Wed, 15 Nov 2023 17:16:32 +0000
In-Reply-To: <20231115171639.2852644-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231115171639.2852644-2-sebastianene@google.com>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
Message-ID: <20231115171639.2852644-4-sebastianene@google.com>
Subject: [PATCH v3 02/10] arm64: ptdump: Use the mask from the state structure
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
 arch/arm64/mm/ptdump.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/mm/ptdump.c b/arch/arm64/mm/ptdump.c
index e305b6593c4e..8761a70f916f 100644
--- a/arch/arm64/mm/ptdump.c
+++ b/arch/arm64/mm/ptdump.c
@@ -75,6 +75,7 @@ static struct addr_marker address_markers[] = {
 struct pg_state {
 	struct ptdump_state ptdump;
 	struct seq_file *seq;
+	struct pg_level *pg_level;
 	const struct addr_marker *marker;
 	unsigned long start_address;
 	int level;
@@ -252,11 +253,12 @@ static void note_page(struct ptdump_state *pt_st, unsigned long addr, int level,
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
@@ -282,10 +284,10 @@ static void note_page(struct ptdump_state *pt_st, unsigned long addr, int level,
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
@@ -316,6 +318,7 @@ void ptdump_walk(struct seq_file *s, struct ptdump_info *info)
 	st = (struct pg_state){
 		.seq = s,
 		.marker = info->markers,
+		.pg_level = &pg_level[0],
 		.level = -1,
 		.ptdump = {
 			.note_page = note_page,
@@ -353,6 +356,7 @@ void ptdump_check_wx(void)
 			{ 0, NULL},
 			{ -1, NULL},
 		},
+		.pg_level = &pg_level[0],
 		.level = -1,
 		.check_wx = true,
 		.ptdump = {
-- 
2.43.0.rc0.421.g78406f8d94-goog

