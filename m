Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE973976A7
	for <kvmarm@lists.linux.dev>; Tue, 21 Jul 2026 08:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784624213; cv=none; b=J1I+m3qj/pJooOhDVjU5FgrMY2zyubc1nHoSFJ+8JQVaz/ig0LOrtGHJPXr01nxkH52GTC4rVLGfyH7H2/41AnqzDDo/fZgWd/yp/S9YA8a5MQR//m3NSi1PeMrBwcbSxa7MdUbS3ssvoMNkY6DNBquwjuf7CTJxoR8lVvsC5sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784624213; c=relaxed/simple;
	bh=H5Jo2NE294YKi2+iOps1WJzux6a9VrlLZFbf4tPEIXM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=bCskzM6vog+wuMLHmCYwvTmy5YCtVyTKiwwGlUvpcO2LsVHtQRBzJBO54khBNcUV/FxX3ksRBmrFoMltn4G148RfqksMi98cETJHgHF9Kq+J6wArtTfSMkB6SiOvm07XdQPuUmonX1pQaujP9nTFc0/GUWcM7Cu3nxvmacX5wUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a3fNUNqp; arc=none smtp.client-ip=209.85.221.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a3fNUNqp"
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-4740be00302so6715801f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 21 Jul 2026 01:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784624210; x=1785229010; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Z76iw/uyYgGfytOiOZ22580VeGLYiQlgTYWmVZJjXYY=;
        b=a3fNUNqpholUjLibj3WhADPocBk/JX6tNoqQJ72ebgS7CuJzlZF4eYNEDBf0o01Vic
         mq3Ha65hExpnvuMy1anr+cL1W1NnQomDQgsJoaY4d11eK6wpMj2YP+hoJflYBCq3xr6i
         0TIZh3fQhbnf81lL9V1fpaogCwdLOdxw622MhgFX8gbdNE6wPiSZRVbSoQxD3myRwBcH
         UkrAWu2fCQooIZCsdo0gfp8hJ4Yx7I0B5xPZc1hXT0nieogkkNoF/3wgpdKOCgrexCdH
         6UIqMi313FMFBYF2DdFI/8pSHRzmBUGsTXg2Elz14Q2oxHyjbkxcZMoicD2sWaAguz2T
         8/ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784624210; x=1785229010;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Z76iw/uyYgGfytOiOZ22580VeGLYiQlgTYWmVZJjXYY=;
        b=OWKraW2y/Ql0ycinggGsE18VkCIu9+8KKHh2Oks7eNefQVykGf3nPTjXizhlDCRYCG
         Ru5usXlqhMLEP00vHHdGW+O75vJB1Qwai+Fxf+j4RdYuZs3ZEnjCdm2yQdDJZdxDCISo
         H1+OkF4vB9V/qIl2yVB/Vu9CqG6GIdVlxr9+v+aBWSzfKWf7GVwkbIQ1gH0V0Gs+0WGY
         ufbwGwXAAjxEu9VG0Dff/tXNQXBFwOJA3yY4+axwtgcvN5c6N39HSMB8SQtRqorDS0SB
         QeKEFOxzK+fUSYygWIsiqx+d7ckFIfP9SADFMBlsBtL5X0BD9usA9zEfHSrveIniD8R4
         SbGQ==
X-Forwarded-Encrypted: i=1; AHgh+RpDC50JzW/NTWP2MnVYMV+fTnOyUSu+H/EeMLV4bVllcLGoB+sxtC8S2E3NgVXjWheVXkwx1NM=@lists.linux.dev
X-Gm-Message-State: AOJu0YwxGK2KyevdTJvcoqjJwV/RL5aXdVyUs8f8+ihLONVIRYLgmZ5i
	GyjLHN9TDyUkSAAuCTASI4v+J/CkfIdyo8ulM3egyNBccK1IqIT/TlTgoDSXvBxWcvEeAiJYX/E
	+plqRTzLrl9HMoQ==
X-Received: from wrtr5.prod.google.com ([2002:a5d:4e45:0:b0:47f:40f3:b18a])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:5f51:0:b0:47b:5f25:7c59 with SMTP id ffacd0b85a97d-47f6231c5dcmr20981425f8f.38.1784624209952;
 Tue, 21 Jul 2026 01:56:49 -0700 (PDT)
Date: Tue, 21 Jul 2026 08:56:45 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260721085646.1660673-1-smostafa@google.com>
Subject: [PATCH v2] KVM: arm64: Optimize protected mode and FWB
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oupton@kernel.org, seiden@linux.ibm.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, vdonnefort@google.com, 
	tabba@google.com, sebastianene@google.com, keirf@google.com, 
	Mostafa Saleh <smostafa@google.com>, Fuad Tabba <fuad.tabba@linux.dev>
Content-Type: text/plain; charset="UTF-8"

KVM opportunistically enables FWB if supported by the system for guest
VMs, which allows it to elude cache maintenance for data as they are
forced to be cacheable from stage-2.
In that case, __clean_dcache_guest_page() will immediately return.
However in protected mode, before calling __clean_dcache_guest_page()
it loops over the range and fix_map/unmap it, issuing TLB
invalidations, dsb() and isb() unnecessarily.

This can be optimized by returning early if FWB is supported,
kvm_pgtable_stage2_map() already issues dsb() and tlb invalidation
functions issue dsb() for the unmap path.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 4e329e39a695..049a09be2bbf 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -261,6 +261,13 @@ static void __apply_guest_page(void *va, size_t size,
 
 static void clean_dcache_guest_page(void *va, size_t size)
 {
+	/*
+	 * Guest stage-2 uses FWB if available, making it safe to elide CMOs.
+	 * In contrast, the host stage-2 never has FWB enabled.
+	 */
+	if (cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
+		return;
+
 	__apply_guest_page(va, size, __clean_dcache_guest_page);
 }
 
-- 
2.55.0.229.g6434b31f56-goog

