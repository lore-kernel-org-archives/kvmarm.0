Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28991CFBC
	for <kvmarm@lists.linux.dev>; Wed, 15 Nov 2023 17:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lIyGPmvW"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-daf35a935fcso6044808276.2
        for <kvmarm@lists.linux.dev>; Wed, 15 Nov 2023 09:17:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1700068621; x=1700673421; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ancG5BntywgLYEtvolLfMGCRB6TUL9+Qsz3r5K1PW+Y=;
        b=lIyGPmvWLJe0SvJKGBcRIQsKW/q8f2/vib3vrYoZmdFtjX9SYn1zgo0c6meOq8NRSr
         I32wYmhTnJkWhp8D2Zbn2B5P8yOlGnKFeeXBu82QhxI9oBihBFlkxPDDvUi9qJnj4Vpx
         N5AhXESQV+gfGp9N90j6ex+nDHRrgEnlBSp9kvfuzKtP77kF5wshQVKhMiH9kT7MYLct
         8jNVjCf3I5kel8YsT8QZLUUy6rUFnb0p9fPfYjzuhXCNSYQm6vjuezmi00h4qj0VKB5G
         FxoRJcfMq1Apw3ZAr16PoEuru+g1Ffn4IdCoyJYU6uLHBHcviDJy4cqRwAst9WFJIJGD
         nLNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700068621; x=1700673421;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ancG5BntywgLYEtvolLfMGCRB6TUL9+Qsz3r5K1PW+Y=;
        b=bcXeD04Az7hrjdYl96QnDZ7Pqo/w52RIJ3XjUKJwH/a6LlaWWcIXFRpKb2puLK6Mk3
         nncM5kdiG0GdFApFVJtW1B9ykTvA8JJ070VZH7IZ7IfMV6JaCli72XhfI6DE58b+Uw3N
         k4cUnRsT1NbRUg7lHNAzXlgnGLDFCKzpWjMN+Eokez0K2QHT3AH5UdtZzZ5QF/BHQeGJ
         Sn4k7VXA7Ak2EcmgReXHvr2CqTAoOSTYH/u9QsJPcypkFgUKMOThQ1i4YOOKZgqAJJNZ
         pJb66Y1YTmDE76LZlUvGyPXY18HWbvBxxBSo9d3zVkpUprtzMxvokXIgi57+3wUFkf4y
         XG8w==
X-Gm-Message-State: AOJu0YxW9tgA08UmbKtW6kaGUL9InlDpXso93AD7sPAV9IkQIkOEkL3C
	BRmZNoJNyhnnPIxHNKIe5ftwBsiAz1NcBsDAUpk=
X-Google-Smtp-Source: AGHT+IGj2sqWbMdL/6D9g7CRzAYqqT3mXvwK0Hse86EHkE+8SGctzk4vkst4vCcjMP9s+i6Vnuewpw1qh5ywF521RY0=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:cd5])
 (user=sebastianene job=sendgmr) by 2002:a25:dcc3:0:b0:d9a:4fb2:16a2 with SMTP
 id y186-20020a25dcc3000000b00d9a4fb216a2mr310123ybe.12.1700068620695; Wed, 15
 Nov 2023 09:17:00 -0800 (PST)
Date: Wed, 15 Nov 2023 17:16:33 +0000
In-Reply-To: <20231115171639.2852644-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231115171639.2852644-2-sebastianene@google.com>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
Message-ID: <20231115171639.2852644-5-sebastianene@google.com>
Subject: [PATCH v3 03/10] arm64: ptdump: Add the walker function to the ptdump
 info structure
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

Stage-2 needs a dedicated walk function to be able to parse concatenated
pagetables. The ptdump info structure is used to hold different
configuration options for the walker. This structure is registered with
the debugfs entry and is stored in the argument for the debugfs file.
Hence, in preparation for parsing the stage-2 pagetables add the walk
function as an argument for the debugfs file.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/include/asm/ptdump.h | 1 +
 arch/arm64/mm/ptdump.c          | 1 +
 arch/arm64/mm/ptdump_debugfs.c  | 3 ++-
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/ptdump.h b/arch/arm64/include/asm/ptdump.h
index 581caac525b0..1f6e0aabf16a 100644
--- a/arch/arm64/include/asm/ptdump.h
+++ b/arch/arm64/include/asm/ptdump.h
@@ -19,6 +19,7 @@ struct ptdump_info {
 	struct mm_struct		*mm;
 	const struct addr_marker	*markers;
 	unsigned long			base_addr;
+	void (*ptdump_walk)(struct seq_file *s, struct ptdump_info *info);
 };
 
 void ptdump_walk(struct seq_file *s, struct ptdump_info *info);
diff --git a/arch/arm64/mm/ptdump.c b/arch/arm64/mm/ptdump.c
index 8761a70f916f..d531e24ea0b2 100644
--- a/arch/arm64/mm/ptdump.c
+++ b/arch/arm64/mm/ptdump.c
@@ -346,6 +346,7 @@ static struct ptdump_info kernel_ptdump_info = {
 	.mm		= &init_mm,
 	.markers	= address_markers,
 	.base_addr	= PAGE_OFFSET,
+	.ptdump_walk	= &ptdump_walk,
 };
 
 void ptdump_check_wx(void)
diff --git a/arch/arm64/mm/ptdump_debugfs.c b/arch/arm64/mm/ptdump_debugfs.c
index 68bf1a125502..7564519db1e6 100644
--- a/arch/arm64/mm/ptdump_debugfs.c
+++ b/arch/arm64/mm/ptdump_debugfs.c
@@ -10,7 +10,8 @@ static int ptdump_show(struct seq_file *m, void *v)
 	struct ptdump_info *info = m->private;
 
 	get_online_mems();
-	ptdump_walk(m, info);
+	if (info->ptdump_walk)
+		info->ptdump_walk(m, info);
 	put_online_mems();
 	return 0;
 }
-- 
2.43.0.rc0.421.g78406f8d94-goog

