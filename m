Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D22762C3
	for <kvmarm@lists.linux.dev>; Tue, 20 Feb 2024 15:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708441902; cv=none; b=NJswm/FJpjgcCImZ5eefbE7/RGas3GVqzed7g5lI0RHKq6MIMxHgD8NlkGs/R6JigegcZKXUHWJV0/BWQ+hYeaajCRB7LaoUWdO/ZXvO3KZXtrJD3IOeAY5fQQprbLWCMlDflSI+8cGzVcI302gyRa3+xIMXopTSZBZY3N7nXZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708441902; c=relaxed/simple;
	bh=IXOljfRlcheaKYN7knK3H0eeyYTrPTnwQOEMdeKsDl0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mK7ajNDFsoLQjzGzkJUr+PV3p8qeqWl5WJqHrLEayliGs3GhJ/ghtt4D2ZniUdGq8uQfvoefb/QVi5mmiNkY8wZlOC8rCYitwtLDxsw1zgUXHc6sNjjiPmmUSaEeTFquWT3ff1e5jEi0D9mhukKjDBfB81owX3zCsjb2tKiMnd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=w/8eLdEA; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="w/8eLdEA"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-607d13e81d8so91006927b3.2
        for <kvmarm@lists.linux.dev>; Tue, 20 Feb 2024 07:11:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708441899; x=1709046699; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RNvbES0Rox8H1wht4HUzRcs5UM73wH2hWBF3+Zr3EJM=;
        b=w/8eLdEAgjcNqwMsaWxuBOdU57F/aOSzu08kz0Dcdy3bQUwtbnNWSsvJGR7TUlwf4o
         d6ipHrBb0DYzqgziGh5SmPB+vF/CeAiA2y7q2KWoJA7o7KCbap6qlszEdzYrQm09789w
         rduu10MGmGyBJoNYhQcZ+ow5p4I6xI3vBcnjzsrq69RIQLwx6tSoqhXXL+eFfkVVEl7j
         2j2q9uAr/PrnXFnenmhCNBQ8NTJR/ihQ7EBx4TnpmTI7QnuVvyYwxMC11bEllwCpYMWH
         MBR26JfAmv660xLr29DC5EE6JhuRVRB7y335pbaCrj6WFsKxrWs8HYf0Nh3aNiRKDWGa
         B7/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708441899; x=1709046699;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RNvbES0Rox8H1wht4HUzRcs5UM73wH2hWBF3+Zr3EJM=;
        b=G1lNrwzuhIihJhki8GKuoSr+ahjFeKOiBwzbW5ZkS2XPYGc+O+HLEY0xMwTONxcf4a
         bMJs8NKhXZMboEJL/OuiTy4NyjTIBqFe7/IpGh+2h8mht6qwwjm8Lm9ZliopPKeSCuK7
         9gzseOh1e9KdvEZ/0j2IUkHjegg1dxjbE4LK5rYHuupC6PqLPH0hZy1WyObL8p3bvvpT
         DGCrQld+klUW99jnw9amAEW79vAhby06eYeXf6XvbhlEHgBZES6RmGT55n72h6WACsQb
         n9i0p4bQFvHLaqfpgzTPpm64nzsHIUlri2fv/RACvSzRTuv5hhSsGictyW5cGLGndPg7
         Y32w==
X-Gm-Message-State: AOJu0YwP4+egf6kg/ncPnuTvoirFDWL4jExbu4ghxS4UA/2a5RBqKfMW
	OeYXtWZQYva3a7craAzl4gBjoK7rJA94XzGX8H4k8GAmN/9kmxGvfHXrFe6fSsq5DH+KBEcDSAu
	cf+vxFcUMSyzswqRhvOuqSG18sA==
X-Google-Smtp-Source: AGHT+IHCqDd6jqD2mbOLFkiBYUplNEQYmBoUC62S64EpeNg2nL7Cr4ldMVQ2DcP6j+oQX8xSeK3buozpPcCMj1N+Kv4=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:cd5])
 (user=sebastianene job=sendgmr) by 2002:a25:d695:0:b0:dc7:7ce9:fb4d with SMTP
 id n143-20020a25d695000000b00dc77ce9fb4dmr4178814ybg.12.1708441899532; Tue,
 20 Feb 2024 07:11:39 -0800 (PST)
Date: Tue, 20 Feb 2024 15:10:32 +0000
In-Reply-To: <20240220151035.327199-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240220151035.327199-1-sebastianene@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240220151035.327199-4-sebastianene@google.com>
Subject: [PATCH v6 3/6] arm64: ptdump: Use the mask from the state structure
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
2.44.0.rc0.258.g7320e95886-goog

