Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7EC41B81A3
	for <kvmarm@lists.linux.dev>; Mon,  9 Sep 2024 12:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725886055; cv=none; b=u9RZSiNqnBUYSPlqZMjL665j1t+DYWpV93yYkoQyELWjLfUYqz8IIUQDOG0BYOUNvpKR4EkfEVgeLZnMh5SoVz1v4Tnw+HfaohmTnpex/3c9qre4sylF4uCOnIPiopQ4CwVB3IPpenFM9T/845qg50TfcZEMUOkTGv4bJNoYXg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725886055; c=relaxed/simple;
	bh=VtR8TuQkNfUkd5xyRn11f5JLt2Zxl4vNilvMS7v/n5o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mnGyfmTrSy15pV0Hcxc8GBWlvF++2vWPJWVincEnOyD0qeXCLezVUVE9AV/5EDr/Ba0nAFKeWimRE13DSY2I1ByfX20B4HNGxuIVVSDr1mCkRrxv2bz+jy8D3591aNp42m5eK5HSmQej0Rf+ny6HWBBQkJpI7KOnfXWA4PonbWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QVhT6OJw; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QVhT6OJw"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-42ac185e26cso34022125e9.3
        for <kvmarm@lists.linux.dev>; Mon, 09 Sep 2024 05:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725886052; x=1726490852; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=z5YaerhLrnlA1kDn0gvbQTCDMMWwt29NrOwuLXna95M=;
        b=QVhT6OJwB0v4/Sd6wN8V9qRrID0zVjvYoDMM7hbW6APfZ7E98y+bySJaRPozx5oxMx
         bgLQbFyy7L1xK0EINPhsF8L8fKJHOwbwMqNYWfBuyahSQFmAs9+puPyxoFNxJ87OTP56
         kU9O56douXvV0ZAkmf8gqZ85wHEGfTAVh8sTR+aCMS4On1eQ/1tGEHJxHiLILe6WC2Gr
         5IEm9XbzTsXPPda1GkZlfR1xjj1MOHVn4GeJaEcUAjs60t7WyRll9wEQbvbLm+WPmw/J
         rzkecFGrAzQGND11MAUu3LGHiM+o4df4QZ2usNmJyJKyetDcTMYU1VJpbGNlVrnzOFbE
         NAsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725886052; x=1726490852;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z5YaerhLrnlA1kDn0gvbQTCDMMWwt29NrOwuLXna95M=;
        b=BgDdMvnnriYpizFBD5KpzU0LWggMF8x6X1lmflM3274wnK85wF8YFFFiNa6DYoDXq8
         SpZgg7/uBr/l8aFlxugP6p654LBwvdhWzi92MGPxry5hMAvYfPuuhZFYaLU+tINxgd18
         ylEvXufdWxp1JCEFgoXESFjNmRo84H5WksEusq1prwqgMwVnoU+YyL49BnUOR9dlteZb
         lr/G/h/vVDbMHYaBvCpc8HTBNeCh7mrG3Xe5WE/62OL8+wCpnVBKMab6khe1C7wVkuVI
         xD59mcsGpag/f1lfknqLky6G/17Mzzh3M6Fyj1AToizg7a90uYeuzrkyjftToqzz/38p
         NUXA==
X-Gm-Message-State: AOJu0YwFs7Bb5YDE7cLaqCGMwKGJi13N5v6LiFNW9jTpmxK3tdMvinyy
	HMgMzBn38cJkuzOg7QM8nY6vkNbSdHB+qqu7u/uveG0evCMMeWNrpAJeoNNGGD0Aetv7vdhhYET
	zd1SqCHVe+tRzBxuWAdYS6rD7YQ==
X-Google-Smtp-Source: AGHT+IHvFQbj0rKg0Z2E+lg4FZtxEigwOSWg+BND77qixGLBIzbCZ5lpRaiz0wEgqDC0ZzG+egBczPT3YnPFvCYHpdQ=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:68:fe9:ac10:f1b7])
 (user=sebastianene job=sendgmr) by 2002:a05:600c:6b6d:b0:42c:8875:95da with
 SMTP id 5b1f17b1804b1-42c9f9e090emr259485e9.7.1725886051855; Mon, 09 Sep 2024
 05:47:31 -0700 (PDT)
Date: Mon,  9 Sep 2024 12:47:19 +0000
In-Reply-To: <20240909124721.1672199-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240909124721.1672199-1-sebastianene@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240909124721.1672199-4-sebastianene@google.com>
Subject: [PATCH v10 3/5] arm64: ptdump: Use the ptdump description from a
 local context
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
2.46.0.469.g59c65b2a67-goog

