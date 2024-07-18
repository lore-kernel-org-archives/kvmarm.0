Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572F5146A61
	for <kvmarm@lists.linux.dev>; Thu, 18 Jul 2024 22:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721342126; cv=none; b=cbZZV5yi9WXlulvdKv5NiyEVE/F48rhbFT4u91j2NXRkEy1WzKJCgidMqJM8PUreCXSYY8vgOuOlQTzTGo/MY/WZz7MM8P9EV4keNZLNv65ZKILidQvkKxUy/9hbJky+gju2htHvNn+iX5fnKCfqu04zhtrB9nbwLSw7DuDtZxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721342126; c=relaxed/simple;
	bh=YDpDr4yxWaBJNXkK2yYee40+CDxF3GQ0b52/63eIRv0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=NzbehwKV46NfZIks8u00XzVPWt7e2SG8Msmziy9B8xP5AxSXUqUBr3PiUu06bjt51ZiK+5ztME8Hl8izuxvnQz6+0AoIN4yZuu2i+UC3DPDp8DCirQs746LkSNYQXOlWedN6pkymq9fwDwPEc7UG2sFnZOJw2Ic29FKPsb8oDaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fdRr/SUE; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fdRr/SUE"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-65ef46e8451so36833067b3.0
        for <kvmarm@lists.linux.dev>; Thu, 18 Jul 2024 15:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721342124; x=1721946924; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=t17NNug3pGXskbylK7023fOephyseDv5XvuuntGRCyI=;
        b=fdRr/SUE0cCcW/Nz/eK/NKeXQS3+FDUMpnDFNJxfVn6NGEsBTJLMSgU7IHyzocT8Fo
         aThGad2Jt9TOXRZWD89w7R0tFt3B2wrrSnSz2oIAqCvWe7ziUxJrpYX+inFVIexeHI2k
         zKwirgfn2huweSGEwwUgjojDdcI+rP0u/Kg828kiQefTR2oJE6L5BN6CgTKt/adMPhuB
         XoxXcobsrGTw8eTX7WGX8ZhtxUVFKWz1H7gyGKNqXDUlzk7J05WOy8iz8aTYcNqITr9N
         YTZmF8duHuwBkTxw2gBHL/GzHwssjnqlVUqyH+8XfuenZxUs+X9PIaeINnrzNKmHNI/q
         ZEIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721342124; x=1721946924;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=t17NNug3pGXskbylK7023fOephyseDv5XvuuntGRCyI=;
        b=k8VVTTf9kD693NlhjscLYopuToN4D2e7G/Tj30PwYUGcPoWe9b0bE+IGHigLHNFeGx
         0VLOLya3GY/tIvTzovuGZt5ZzA5HHwQQOW6StO1fkRRFRP833PRPRDBIBAWNM+WikhrV
         8z6phy5M+jN/aegNJsyCkmbp/2hFsF/IiriaTkBhUHhgL1tCUgYXQ9unTBOUhZYgAe6A
         w3Y97+lOBdxh+8177GH55ZlqnAEL7GltWsTQSSb0dpb30S4uTMSBcUluaRb70K/t/X/Z
         5cimn5xfHEAFLsXk7n9RdTvObsTASmC365Yc22FvXpvZuytMyYascdKI1wst8oDfa47E
         ZyGQ==
X-Forwarded-Encrypted: i=1; AJvYcCUqWik05GUQdyiFZAMKNwqkmGp2is3bhYPL3Mlc/SIG+J1jYDJjvmd0xDv17iRci9B/w16Dk+xQI3b88WUIIJSotvc62aMj
X-Gm-Message-State: AOJu0YzUPNv3FMFD2AOelVjIBMf+9xt3Yslrzp0p3q1Jb+nweSQq6i7g
	AT8MZw2O+rgUKExs8rOGXRiThTfIivYHHglZKYg3kD2KsLsb5u/lulDfmSvi1hByHLjhhhh6NOh
	iCC1BPLIoqT2yDduzl8nzEQ==
X-Google-Smtp-Source: AGHT+IFAzxmz+xd5k+TsYOLSlTiwpUEcd3PMTkPrko0oISXqajR79Y7rD10ay46njNzlCvfw2OfNGwggk1RAW9y4Sw==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:690c:f94:b0:627:a961:caee with
 SMTP id 00721157ae682-66603127fa6mr1628197b3.4.1721342124251; Thu, 18 Jul
 2024 15:35:24 -0700 (PDT)
Date: Thu, 18 Jul 2024 22:35:19 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2.1089.g2a221341d9-goog
Message-ID: <20240718223519.1673835-1-coltonlewis@google.com>
Subject: [PATCH] KVM: arm64: Move data barrier to end of split walk
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Moving the data barrier from stage2_split_walker to after the walk is
finished in kvm_pgtable_stage2_split results in a roughly 70%
reduction in Clear Dirty Log Time in dirty_log_perf_test (modified to
use eager page splitting) when using huge pages. This gain holds
steady through a range of vcpus used (tested 1-64) and memory
used (tested 1-64GB).

This is safe to do because nothing else is using the page tables while
they are still being mapped and this is how other page table walkers
already function. None of them have a data barrier in the walker
itself.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 9e2bbee77491..9788af2ca8c0 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1547,7 +1547,6 @@ static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	 */
 	new = kvm_init_table_pte(childp, mm_ops);
 	stage2_make_pte(ctx, new);
-	dsb(ishst);
 	return 0;
 }
 
@@ -1559,8 +1558,11 @@ int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
 		.flags	= KVM_PGTABLE_WALK_LEAF,
 		.arg	= mc,
 	};
+	int ret;
 
-	return kvm_pgtable_walk(pgt, addr, size, &walker);
+	ret = kvm_pgtable_walk(pgt, addr, size, &walker);
+	dsb(ishst);
+	return ret;
 }
 
 int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
-- 
2.45.2.1089.g2a221341d9-goog

