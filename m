Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08FA31AE87B
	for <kvmarm@lists.linux.dev>; Fri, 16 Aug 2024 12:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723811964; cv=none; b=Sutcw76BIZkzAcg6vFrNXfW7K3x7EUSzG49RtgSFNSHt/iMoBP+q4athKJ257zzSH0YzmHIJornI2J2pUhm01PRxOHWckVmN3Of68HKLezO971Xapx+KN7RjcjPz4hxMdfrqyzcFa7JVV2uiOR8rduDPcsSkpQ1nV9uj7Xpeo/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723811964; c=relaxed/simple;
	bh=eGtEtPkxRm/Bp/1pUnIw1ZGoSEo/VchDZHTGqv1Cie0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=P2pWftGEqq8342t8ckg8rK5Zo0RPxF0Db5utZ13qSSNTymm75JOJh6gjnHHj/wwPvcIzV2DNeFHJbNFDvhYUi0wtUzq1x3tVIArInPgAvs/JfKxdRx/dSnA2ZRIqZVrb6aw6f8hxSBirMqCt7lmOBG7pGheQ7OHz63NM+7VNdeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1dD8f/eR; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1dD8f/eR"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3719ee7c72eso98165f8f.0
        for <kvmarm@lists.linux.dev>; Fri, 16 Aug 2024 05:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723811961; x=1724416761; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TOVsSjbkFKkupVHDdUClsSrj3QZ/4GeILHKaUawEmW8=;
        b=1dD8f/eR48Bhi1SkOlhclI5CqE+Zvchbq4s5rRw0zuxP+msqciaQXkTUyYyz7SGeLW
         iBLpdi8urfziwbH0LFtx4d9TyXJ267AQ3bGYbJreEo8+rOMlULx/3Vq53mYUDxy/GJl2
         v3aHIsB4cGia4kBjNUF5g9PpWhHRwXZnXzMJFsIohaXzJJPtZssEEymb1gRuQhyOl6qq
         Hh6LS7UAyI9ZPoKdMXxX4P6SNjrnZw1DDup28wpeZMnC8UrJz76Yw2idwmrgmkoifqso
         1VKjlzBFd/c/15CQHni6vH/VxB5jp1FMWtqtModTljh/wdLmwe5tfXG8olEhOFd9UFyY
         8bpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723811961; x=1724416761;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TOVsSjbkFKkupVHDdUClsSrj3QZ/4GeILHKaUawEmW8=;
        b=jkeKYlsaoU3SRTGAXjhKl21M/EXi5daJP6RKYg6B6D/dAxkIwr3xC7r/Oses9EOyYf
         17ettFeKwiRK+foLlq8qf6Rbj7ngK1d3kJxzqLBDU6h6oSwCwT6NxAlNQSvp0lMUd+ED
         3tFVKivbVvMRQLqGYFOLO+fBBJDba6TSqqWd+qV1f1NgdgedSFbcqbg9gEgPuT50r0LL
         G3bNCjw4YHiZBwdBVSmILmAnk4OV8jqy0gvWsj2tNKILbWniwsQQ1mqkx+T2zSG3hQzo
         yJHViKCT2vz/fUO8JRlxERv6QTs4nPlRCRfjiQm6N0AZGlAKmAkX4H3YpVqGrV79mSz/
         JamA==
X-Gm-Message-State: AOJu0YyVprplN3XexeITDqy6DcqexFNdYF2+oRosFJaeuHL1SeuNOKRq
	02maGYg6AxjYkzdjr0eNyQ+ICM97opNHosGmtTGhYr4CYvEqMsteqqR9pB3NCRkO8rFwMPzWrbj
	Ht/GM3fYPvPAJcDPaEHFjVUowXA==
X-Google-Smtp-Source: AGHT+IHcICbWJmK89n8rtw3CIsZCVnNXfh2Wfm6YpkzCdhB56aOnbSeNarXn8GFhkvmcCHzcvJ1/hlKucHN9pFgTZco=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:cd5])
 (user=sebastianene job=sendgmr) by 2002:a5d:6449:0:b0:371:8685:846 with SMTP
 id ffacd0b85a97d-3719465d24fmr4614f8f.8.1723811960947; Fri, 16 Aug 2024
 05:39:20 -0700 (PDT)
Date: Fri, 16 Aug 2024 12:39:03 +0000
In-Reply-To: <20240816123906.3683425-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240816123906.3683425-1-sebastianene@google.com>
X-Mailer: git-send-email 2.46.0.184.g6999bdac58-goog
Message-ID: <20240816123906.3683425-4-sebastianene@google.com>
Subject: [PATCH v8 3/6] arm64: ptdump: Use the mask from the state structure
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
2.46.0.184.g6999bdac58-goog

