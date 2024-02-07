Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988837F7D6
	for <kvmarm@lists.linux.dev>; Wed,  7 Feb 2024 14:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707317365; cv=none; b=LcfvEDIJH/Hb/MPid9BehIRa2JXzXCnlR75UMHo6ytapDAy3QY8i7Z9pvtwviN1NrxjLnrMFOVBK/2XNPRubMUdyO2yduyW1bKXMC5YKotSYYO2O5EiI5cIzHhBhz1iVjfVEcYoekKlaulAgpx3hci3YvuAKjsTgTNaFYWHsJkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707317365; c=relaxed/simple;
	bh=iJoX6VotvrSCPb1HffuAPKumVXhHe9gdUehIpt69Ano=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=h0pEpaxUUmS3iYmgQOlcG9OL3W7QQEUU/exG5G9FJileFH5DwKg5s1TNrH+aoHd5ZqmuK4ak0w6hIwyE93vY80O+le53Sm3Nr43WDF8zQUogSNah7mpdTOaByzCkTC8VNlny3KkfNI0VZhXHq5rVagV8cdOFEMp0zGRIjmu5CjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HpojXyFH; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HpojXyFH"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-40e4478a3afso3368575e9.1
        for <kvmarm@lists.linux.dev>; Wed, 07 Feb 2024 06:49:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707317362; x=1707922162; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8tIUh8e7+u6fe/L9d2IoiyaWpJieVgDcIoakNbd8hrU=;
        b=HpojXyFHtYYcgCOc6Yd8EGDSv5p5/443GJMS3fIng8CIKaI6QBM2wqCtTugliqAvbF
         po1INtOWSVBNt5Dqp6Wy9wJkMEFs1KBag45iU7jQtbaDbRE+vpbR5KNw9MXORJl1OtXb
         vYaMZ+0Sq267PyTqoVYzcbREypAvGoN9FhD7XrtEP4lpgL1PG3YBptqjrCm8QW41UI1c
         QAYwJVVOGQSwADppzME3j8HgKC2O4cIRLwABzIsrik3/PxT1rxxhN5mGx7pi1znnJlR9
         OlgO0zCkwIcnL2A07PaoLEf0cGerQsjdWSfnMReGxSaDDfwhx+cz+Gz170xVbvAJ10dy
         5Nfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707317362; x=1707922162;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8tIUh8e7+u6fe/L9d2IoiyaWpJieVgDcIoakNbd8hrU=;
        b=VDQdfb8TMjTKh1VaY+kpw1SukNWS4OzBPemNki2ER8cFmumxcUibg7nBfoHkPDc2gr
         XJjcAQ6hOngr+pVOKvCQplSLxOwsXMyd5QCN50kK49KAxGm7FypsPwmiuhOxZspwBvp6
         bnyLeli/lvBPWG7yB1QLC2SBsGMyV0Hb9RUDNvKEOYFUcdSzyEwujCHN8R2flmZdYjsS
         p7QVUjvr8hLU4tfJLL2WK6CVP4BZIthcMUzWvs/OOTdCs45QSRErUVF/Xn4ferNbUYHW
         4l+rvLguxwVCJ0BZtx4+4HzRq/MIqmCQhPbphC+2VErK2IwM2QDD+OFMZF64Ne0vbO4/
         fTdQ==
X-Gm-Message-State: AOJu0YzizJ78dcJyM5cb37NsiI4Z0OeA/VvHIH7iMusGrQI2T8cK2h7H
	Lj/lrd/Dh1mlXYPPu61OBdeuON/5+uIHuorGQAVGS6VsOqHHVGkyfUmPYLkW/3zw3vzLocHIzPT
	ivVKsvmJ9WC49/dexFbgj13mmjg==
X-Google-Smtp-Source: AGHT+IHZWozJw6iEdHYJvbi8rYI97x/8VSLY+PehA27Gu1vNkYuY53+7wudnkk76X2VvuGrFo0tvrbQt62XM8gjTJX0=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:cd5])
 (user=sebastianene job=sendgmr) by 2002:a05:600c:518b:b0:40f:e205:9868 with
 SMTP id fa11-20020a05600c518b00b0040fe2059868mr158210wmb.0.1707317361885;
 Wed, 07 Feb 2024 06:49:21 -0800 (PST)
Date: Wed,  7 Feb 2024 14:48:31 +0000
In-Reply-To: <20240207144832.1017815-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240207144832.1017815-2-sebastianene@google.com>
X-Mailer: git-send-email 2.43.0.594.gd9cf4e227d-goog
Message-ID: <20240207144832.1017815-4-sebastianene@google.com>
Subject: [PATCH v5 2/4] arm64: ptdump: Use the mask from the state structure
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
index 23510be35084..4e728d2a1f2c 100644
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
index 64127c70b109..015ed65d3e9b 100644
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
2.43.0.594.gd9cf4e227d-goog

