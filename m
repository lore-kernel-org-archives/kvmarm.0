Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C427464
	for <kvmarm@lists.linux.dev>; Thu,  8 Jun 2023 22:06:12 +0000 (UTC)
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1b02cd4b829so821465ad.1
        for <kvmarm@lists.linux.dev>; Thu, 08 Jun 2023 15:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686261972; x=1688853972;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=f9CaDc6GGBWuK7eCpoNYT6YueR8Zbl2jpIpeaKQVQvQ=;
        b=g6TUacceAYPEbfsv6EW0WtXBfm6IOz5S5d+OFFFjRuXIN+Gt6qw1Hxz/wxQRodLv6Q
         fZvF+Q31Rn/FCi8bHs7ONm0lzgg2+m7cQKkQ6aAmUBSZVRKELWdRRtCJE1LkgFGEy3zQ
         SxZE6ZO51wmiUifCL70ATkprYaVBcUZO8HlrsZfUqqxFI2uuJg2p5Hgbntzk6iKii5ZF
         qYY0amN96y9UZxoF6WKyTwgEpRR55ljoc844L4vL0UGsBIG0swmXQmOgRXIkO3EUuJIv
         vyKSVUkn1eQVVuBk8NZ6GWTUIYEHnAR4AAFKiV+taoOoCgyj5MdYG6SmNJrXxexjNXoH
         ZfQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686261972; x=1688853972;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=f9CaDc6GGBWuK7eCpoNYT6YueR8Zbl2jpIpeaKQVQvQ=;
        b=b2A9VJVbhE2bSnELpz4T0vGxePTc44Mm5vnFdbE4UVFplOUgFPqy4rU5fF76bBjcHp
         Nj37l50e5mBr0y/P7sliQs51CD9S/X7BHXuEaqjtg07HyTdp2019c8b3cVA3bFZES0E/
         Td//K1isLyOyDm+E9fwiKjWfvPkGtNTWARmD1I+k+WyIs7lNlEfzf4Bx9828UIO9jeeC
         FIuW9EZBMnfR4MU8UahCKJA4ebLCbtv9LoL9xZjQx3Bur62vcPOn/Hu/gspFVSpIs4Sj
         Rf+NaV/uR4hIppaDh6Qu1bKUKLex5w4OfDXztn9VzoM7p40iR6f78O9dcG+aF0m+UGZ6
         GQmg==
X-Gm-Message-State: AC+VfDzvuvLuRjjVl3TwWtc2kezgWDg+aYzPloCvcBaNzvWFliXpG1t/
	t0jkB39MLZstpFM1y/3auzHzBOs/9ss=
X-Google-Smtp-Source: ACHHUZ6MQlIY790bFakXPIY1+zDRu/UOVYFkss4KwDwJ93EXpywhfKozP0OWWxinQPg4v+c45aCEckKGtc8=
X-Received: from colette.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:5cff])
 (user=ctshao job=sendgmr) by 2002:a17:902:8c81:b0:1b0:46af:7edf with SMTP id
 t1-20020a1709028c8100b001b046af7edfmr626301plo.2.1686261971803; Thu, 08 Jun
 2023 15:06:11 -0700 (PDT)
Date: Thu,  8 Jun 2023 15:05:38 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230608220558.39094-1-ctshao@google.com>
Subject: [PATCH v1 1/3] KVM: arm64: Consistently use free_removed_table() for stage-2
From: Chun-Tse Shao <ctshao@google.com>
To: linux-kernel@vger.kernel.org, yuzhao@google.com, oliver.upton@linux.dev
Cc: Chun-Tse Shao <ctshao@google.com>, Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Ben Gardon <bgardon@google.com>, Gavin Shan <gshan@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

From: Oliver Upton <oliver.upton@linux.dev>

free_removed_table() is essential to the RCU-protected parallel walking
scheme, as behind the scenes the cleanup is deferred until an RCU grace
period. Nonetheless, the stage-2 unmap path calls put_page() directly,
which leads to table memory being freed inline with the table walk.

This is safe for the time being, as the stage-2 unmap walker is called
while holding the write lock. A future change to KVM will further relax
the locking mechanics around the stage-2 page tables to allow lock-free
walkers protected only by RCU. As such, switch to the RCU-safe mechanism
for freeing table memory.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Chun-Tse Shao <ctshao@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 5282cb9ca4cf..cc1af0286755 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1042,7 +1042,7 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
 					       kvm_granule_size(ctx->level));
 
 	if (childp)
-		mm_ops->put_page(childp);
+		mm_ops->free_removed_table(childp, ctx->level);
 
 	return 0;
 }
-- 
2.41.0.162.gfafddb0af9-goog

