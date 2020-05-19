Return-Path: <SRS0=JN4F=7B=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBB7CC433E0
	for <kvmarm@archiver.kernel.org>; Tue, 19 May 2020 10:40:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4C1E020674
	for <kvmarm@archiver.kernel.org>; Tue, 19 May 2020 10:40:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="asPR0hzt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4C1E020674
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C43A34B138;
	Tue, 19 May 2020 06:40:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fdUIufyJJaNV; Tue, 19 May 2020 06:40:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CE1C64B16D;
	Tue, 19 May 2020 06:40:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD6FD4B138
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 May 2020 06:40:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XoYiaR4xBul6 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 May 2020 06:40:44 -0400 (EDT)
Received: from mail-qt1-f202.google.com (mail-qt1-f202.google.com
 [209.85.160.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 138454B132
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 May 2020 06:40:44 -0400 (EDT)
Received: by mail-qt1-f202.google.com with SMTP id c20so16206493qtw.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 May 2020 03:40:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=IukSylGaIR5gaKlG+xDtFZim9P8RAJ6FK69GQOC9RaQ=;
 b=asPR0hztoEoHaGzaHjCw+fe/33Ee3krH9GlxwXyBDh0CDhZMRpxqzBAnJbcf+KzLeh
 Fo5lbRQeY/B3I5ZrEUwMabjb57cFzpJLgNBc9yIg9AVKn0ZUWHVK160PEi0+Cc/OcVUq
 FYo8qUioio8CZBQ+gqvJysQd7yRxigcg/xxbT14BEgYwhLfwnUucnI+2MlpHM28N0Tlx
 RG5hiz9Q4cyP2B+AUkf4qvAMGzckvYD4324/TtIMSVufpq/jrZA4bb7Sef+76z4BxFlD
 9jH1taeLDZOaS7yea9neMUKfZ3DDYSj1by9Aw5TrlQaFtnNyPKAdCuK9rU1RWhBvdUte
 txVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=IukSylGaIR5gaKlG+xDtFZim9P8RAJ6FK69GQOC9RaQ=;
 b=HBJGxHCemM2e3pZRTv/Vlq8s7tF5DwPOHhYGFgn7vjRCt+4dObLpWhJQpRiPtNPYqg
 YukTWtS9WfyZTom2ZhD1QqiEH54mJcUK+teWTCubrFfxKMLvOEjnjUTmitQfw1wz8Lvq
 aaxWbBAcxhhUTVrXL+WbsJFsckiKXqgSU1fEwLCm+zr9NbkimcK7S3F3okcitd85xqbq
 Hi3TRkz3vsTWDHd9KHy2jbodtl8Qzr/RcNRu+GXzGGDBykLhhtXkNmMf9o7odSDbxx1B
 cBaFkDoGpYga9Vdq5hOsriQVlU/gKWGBcNtdNtUDKnDHi/DKjQwILzrK3BZ5ECJGLpYS
 NAxg==
X-Gm-Message-State: AOAM530TX6F9qK2275Q4SoS36JSSAy3SDu0CgABMIZbAaEmHPEBiR8dG
 NiFj0kOusbXqms/M4+GNnCb7VeMsdPYXnFlcMxHcgWnVjvQVc8Et2LqRq/v6DjMD4JemvJuy9LN
 uFHu55cDsqO+1NVGcJJzjoQY/1f+LE6jnA6Qc740lBOP/pY3nKGtN39h6zgd8B5nYrdFwqA==
X-Google-Smtp-Source: ABdhPJzRMWotQQ2GSoODUI15KJr07PIzObzEaNnJPdBcJPC1OCuYK6tQUji4oYmJXVF5R0/R/ze8J9pEbgY=
X-Received: by 2002:a25:77d8:: with SMTP id s207mr2934092ybc.8.1589884843420; 
 Tue, 19 May 2020 03:40:43 -0700 (PDT)
Date: Tue, 19 May 2020 11:40:36 +0100
Message-Id: <20200519104036.259917-1-ascull@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH] arm64: kvm: Remove obsolete kvm_virt_to_phys abstraction
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <maz@kernel.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

This abstraction was introduced to hide the difference between arm and
arm64 but, with the former no longer supported, this abstraction can be
removed and the canonical kernel API used directly instead.

Signed-off-by: Andrew Scull <ascull@google.com>
CC: Marc Zyngier <maz@kernel.org>
CC: James Morse <james.morse@arm.com>
CC: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/include/asm/kvm_mmu.h | 2 --
 virt/kvm/arm/mmu.c               | 6 +++---
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 30b0e8d6b895..e275a85117e8 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -363,8 +363,6 @@ static inline void __kvm_flush_dcache_pud(pud_t pud)
 	}
 }
 
-#define kvm_virt_to_phys(x)		__pa_symbol(x)
-
 void kvm_set_way_flush(struct kvm_vcpu *vcpu);
 void kvm_toggle_cache(struct kvm_vcpu *vcpu, bool was_enabled);
 
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index e3b9ee268823..2aa853e3c789 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -2185,11 +2185,11 @@ int kvm_mmu_init(void)
 {
 	int err;
 
-	hyp_idmap_start = kvm_virt_to_phys(__hyp_idmap_text_start);
+	hyp_idmap_start = __pa_symbol(__hyp_idmap_text_start);
 	hyp_idmap_start = ALIGN_DOWN(hyp_idmap_start, PAGE_SIZE);
-	hyp_idmap_end = kvm_virt_to_phys(__hyp_idmap_text_end);
+	hyp_idmap_end = __pa_symbol(__hyp_idmap_text_end);
 	hyp_idmap_end = ALIGN(hyp_idmap_end, PAGE_SIZE);
-	hyp_idmap_vector = kvm_virt_to_phys(__kvm_hyp_init);
+	hyp_idmap_vector = __pa_symbol(__kvm_hyp_init);
 
 	/*
 	 * We rely on the linker script to ensure at build time that the HYP
-- 
2.26.2.761.g0e0b3e54be-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
