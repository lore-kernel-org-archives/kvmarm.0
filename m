Return-Path: <SRS0=9/XU=MV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 046F6C4320E
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 13:29:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A856760EFD
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 13:29:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A856760EFD
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F38340870;
	Thu, 29 Jul 2021 09:29:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gTuEySb5kOko; Thu, 29 Jul 2021 09:29:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C4164B0D0;
	Thu, 29 Jul 2021 09:29:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D83FE4B0F8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 09:28:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id g3n+-xYG91vT for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Jul 2021 09:28:58 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DAEC74B09A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 09:28:57 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id
 l7-20020a5d48070000b0290153b1557952so2251139wrq.16
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 06:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=OjC24vlLeAeaPgTOLWCqiGMhh2YFKJ1LYBLN6vgVBCE=;
 b=FUVDUhP/Rgin9C5BP59XMAHUmYRtf8wsXok+/g39vfdccCUCbbIVDOgFIm6+T7feET
 OomVLcyL10A24g9qFkGVaYhLGSLUP+7LPM2rYyJvJcTC/EXcS3QMcQy9Zjn2OfviE4Vv
 pqDLpQ9h2b8lvFh1vVNIwNeokffqlvkzEHZ/4KbVuW5P3FYo7Kz/ngnmtxczHYdDl2aY
 dn8R3JChCBT+YQ6mC/tGYOavge71IRXVQjA3y7zhUwAZ9lCCEAZhdKwSqg682Veyp4Op
 H6zjmSwxexlMkOT79IpXhHTF8vO1H6IiZx2lHKa9zI3DieJ1lud/goMYV8Lz8Fg4Utho
 4szg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=OjC24vlLeAeaPgTOLWCqiGMhh2YFKJ1LYBLN6vgVBCE=;
 b=JFyEeq7Zo+y5Ghi2V/sVQrh2UN+QyrDUrk51mkzViri3nXoJLneZ6qGBvMUVrHAuNF
 Q8ovDKKc1inMtPGvs8AgwooZe05gkJm3Wmw2z14Mx1Vez5erwDGSpoGMQlUuJtPA7huO
 tVC9MJELYTQWBLI9D+FcW3mZufovW7oKk16Xs3Nu/pZmj2vDuBqlTqgweIc4Qa/ag9Ro
 wzqrzEIeB3FLnqWrHdcF+aSiY75Qs3vN8el8ZNbk/L2jjr1cuo6UonueBCMFVLUW7TE5
 zdvBZERrhMgB4/Kp6rswS+ORX/70ckSA9oaboxaJBFGyf/xdItSH7SM++Ml/qGlmVV/Q
 AGpg==
X-Gm-Message-State: AOAM531dxFgbZ/sHicOGP7yMbC9KNsiGdOQMYziuid9bRRwA8AVlS1rd
 54wmv4xTIGWI+ZAMOwueCU5isSkSBo2P
X-Google-Smtp-Source: ABdhPJypNTDOJ5B4zDhDCdj5CCbjzdEdEoifMoEeuxe0LOvoyI2vi5S+2I0+5g7DpCtXnyU4MWjdIokkLn73
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:293a:bc89:7514:5218])
 (user=qperret job=sendgmr) by 2002:a1c:1b14:: with SMTP id
 b20mr3965963wmb.170.1627565337101; Thu, 29 Jul 2021 06:28:57 -0700 (PDT)
Date: Thu, 29 Jul 2021 14:28:12 +0100
In-Reply-To: <20210729132818.4091769-1-qperret@google.com>
Message-Id: <20210729132818.4091769-16-qperret@google.com>
Mime-Version: 1.0
References: <20210729132818.4091769-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v3 15/21] KVM: arm64: Introduce addr_is_memory()
From: Quentin Perret <qperret@google.com>
To: maz@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com, 
 suzuki.poulose@arm.com, catalin.marinas@arm.com, will@kernel.org
Cc: qwandor@google.com, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com
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

Introduce a helper usable in nVHE protected mode to check whether a
physical address is in a RAM region or not.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h | 1 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index cc86598654b9..5968fbbb3514 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -51,6 +51,7 @@ extern const u8 pkvm_hyp_id;
 int __pkvm_prot_finalize(void);
 int __pkvm_mark_hyp(phys_addr_t start, phys_addr_t end);
 
+bool addr_is_memory(phys_addr_t phys);
 int host_stage2_idmap_locked(u64 start, u64 end, enum kvm_pgtable_prot prot);
 int host_stage2_set_owner_locked(u64 start, u64 end, u8 owner_id);
 int kvm_host_prepare_stage2(void *pgt_pool_base);
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index bb18940c3d12..4532f3d55a1a 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -196,6 +196,13 @@ static bool find_mem_range(phys_addr_t addr, struct kvm_mem_range *range)
 	return false;
 }
 
+bool addr_is_memory(phys_addr_t phys)
+{
+	struct kvm_mem_range range;
+
+	return find_mem_range(phys, &range);
+}
+
 static bool range_is_memory(u64 start, u64 end)
 {
 	struct kvm_mem_range r1, r2;
-- 
2.32.0.432.gabb21c7263-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
