Return-Path: <SRS0=zOpf=C7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C51FC2D0E2
	for <kvmarm@archiver.kernel.org>; Tue, 22 Sep 2020 20:49:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 190A82376F
	for <kvmarm@archiver.kernel.org>; Tue, 22 Sep 2020 20:49:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="H9Qf7DVj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 190A82376F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B0EF44B199;
	Tue, 22 Sep 2020 16:49:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FvimrO+zjCal; Tue, 22 Sep 2020 16:49:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D5E2A4B30E;
	Tue, 22 Sep 2020 16:49:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 908694B2EA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Sep 2020 16:49:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5oMNObzK+-c5 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Sep 2020 16:49:30 -0400 (EDT)
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com
 [209.85.128.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 369334B0CA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Sep 2020 16:49:30 -0400 (EDT)
Received: by mail-wm1-f65.google.com with SMTP id b79so4731433wmb.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Sep 2020 13:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=EQoerP3tBfn00ZbzFIq6padP28pN7slotXicRp3957E=;
 b=H9Qf7DVjzS2uazzSXcsF8UxvWOQKx0YXcEpjys0QzFlKULYxwAudttOshKaEI0RuGb
 4prt+n606mkeJnvIfKgeFNTlwVwlhtSJD0+RZnlVnWFk3fZ4nUnaRPb6MXAgbeyuXVun
 pq7vfFGhwkMqfw+3auW+vxQqRRlSQ8SCE7Nn1MNv7PRGWmatEP4MLbSn5TNCgvqY3eOw
 a9qDfY42N1RtFtFwqdvHF5aAPfgP7wyquROGWLpWezzG1V78CKbgDQ/B29XsdbO7C4fR
 4b7gie1b35wjCzbbUJYBQAXq4G0Mp6m2BWA+R+OLZUs2WHa7DWZv8DDrFo4xqRr9qLMn
 ukSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=EQoerP3tBfn00ZbzFIq6padP28pN7slotXicRp3957E=;
 b=O5BqyiUKFEZyfZF1lWcaiaJMzeJY8IUfeWnEHgryGLLpuBVFe8f7Q08h4hvHYK76XP
 cGauz7ywGlup4aaMBScBjkejtRHa6xq60hhJ6PMDrnOSilv0/XqtLGqj5SsGvWTTUDSa
 jBNjstHugi8yRlUiJj+XL0ag3nSHYbsilieg0LTQOFzTw6quJ4Co82oUiUUhhM+Kcj8t
 Ulw2311OdWSl+iOvkn+n9IGNOI+2zkWDVPfW3YUGDVrBHM+9cTiQm9PP+oICtOSV0TKh
 7/h0KxVh4x1H4yBqDEK9cz5f1T24xtx1OPnbvdqbjB63g0KihTqXXKbRXGJy/n/mI45o
 YDuA==
X-Gm-Message-State: AOAM530gMMr9IPCE65sn1OZmN1imvdKeCEFFqWi0XFCFHT3J5zI9YlQU
 AxtIkZdkENz9ud9i+mknEcz5XVvgbwXKcSNY
X-Google-Smtp-Source: ABdhPJyCu2UBtJO54u19JC9bNyMnYGleK4AbttUj2Zv5iMIbquV3VAo22onzrk/JeZubQXQ7ykQibg==
X-Received: by 2002:a7b:cd06:: with SMTP id f6mr3030151wmj.66.1600807769052;
 Tue, 22 Sep 2020 13:49:29 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:1105:630f:e990:272f])
 by smtp.gmail.com with ESMTPSA id a15sm29708484wrn.3.2020.09.22.13.49.28
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 22 Sep 2020 13:49:28 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 10/10] kvm: arm64: Remove unnecessary hyp mappings
Date: Tue, 22 Sep 2020 21:49:10 +0100
Message-Id: <20200922204910.7265-11-dbrazdil@google.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200922204910.7265-1-dbrazdil@google.com>
References: <20200922204910.7265-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
 Will Deacon <will@kernel.org>
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

With all nVHE per-CPU variables being part of the hyp per-CPU region,
mapping them individual is not necessary any longer. They are mapped to hyp
as part of the overall per-CPU region.

Acked-by: Andrew Scull<ascull@google.com>
Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/kvm_mmu.h | 20 --------------------
 arch/arm64/kvm/arm.c             | 16 ----------------
 2 files changed, 36 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index e134c2ba2c5d..8e7919801196 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -531,21 +531,6 @@ static inline int kvm_map_vectors(void)
 DECLARE_PER_CPU_READ_MOSTLY(u64, arm64_ssbd_callback_required);
 DECLARE_KVM_NVHE_PER_CPU(u64, arm64_ssbd_callback_required);
 
-static inline int hyp_map_aux_data(void)
-{
-	int cpu, err;
-
-	for_each_possible_cpu(cpu) {
-		u64 *ptr;
-
-		ptr = per_cpu_ptr_nvhe_sym(arm64_ssbd_callback_required, cpu);
-		err = create_hyp_mappings(ptr, ptr + 1, PAGE_HYP);
-		if (err)
-			return err;
-	}
-	return 0;
-}
-
 static inline void hyp_init_aux_data(void)
 {
 	u64 *ptr;
@@ -555,11 +540,6 @@ static inline void hyp_init_aux_data(void)
 	*ptr = __this_cpu_read(arm64_ssbd_callback_required);
 }
 #else
-static inline int hyp_map_aux_data(void)
-{
-	return 0;
-}
-
 static inline void hyp_init_aux_data(void) {}
 #endif
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index cd5293e55fec..22ec7176f95b 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1591,22 +1591,6 @@ static int init_hyp_mode(void)
 		}
 	}
 
-	for_each_possible_cpu(cpu) {
-		kvm_host_data_t *cpu_data;
-
-		cpu_data = per_cpu_ptr_hyp_sym(kvm_host_data, cpu);
-		err = create_hyp_mappings(cpu_data, cpu_data + 1, PAGE_HYP);
-
-		if (err) {
-			kvm_err("Cannot map host CPU state: %d\n", err);
-			goto out_err;
-		}
-	}
-
-	err = hyp_map_aux_data();
-	if (err)
-		kvm_err("Cannot map host auxiliary data: %d\n", err);
-
 	return 0;
 
 out_err:
-- 
2.28.0.681.g6f77f65b4e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
