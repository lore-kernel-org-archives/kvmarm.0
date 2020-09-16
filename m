Return-Path: <SRS0=cLXx=CZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCBCAC35256
	for <kvmarm@archiver.kernel.org>; Wed, 16 Sep 2020 17:35:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4EADF22460
	for <kvmarm@archiver.kernel.org>; Wed, 16 Sep 2020 17:35:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="XBpFPnVn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4EADF22460
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E769F4B3D6;
	Wed, 16 Sep 2020 13:35:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3laU1b-DjcNV; Wed, 16 Sep 2020 13:35:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EC8E4B51E;
	Wed, 16 Sep 2020 13:35:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 742CC4B44B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 13:35:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Yj4oC0sySsqy for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Sep 2020 13:35:08 -0400 (EDT)
Received: from mail-wr1-f68.google.com (mail-wr1-f68.google.com
 [209.85.221.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 676C24B3D6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 13:35:08 -0400 (EDT)
Received: by mail-wr1-f68.google.com with SMTP id z4so7804513wrr.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 10:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=EdexJTeSJ1yzSq2NB9sPeJusVOkXFFsSU8w5tX+wAoY=;
 b=XBpFPnVnEXotZ9h7Vi96uiegtXa9f6RsxKZhjfRsj/bVOPdAq6fxcKcQEAWKY2yP/+
 j3PWyy1esATPnLP3uevSBbvUQKYvsCxNVoLaiGC/5iqudT2qc6itwteJuDQZN39vdob3
 QaDJj5Fg7ELcwgZceR5AuZcuIyWWmWGJn9h8tuNgYqFXJvF9GfV92xXB911rmrSm3IJz
 DEVO8XTVwMYWDmqJ1lvnk1kAgNDeDDzO49zUONaiMZF3cfbTO5K+56OTvnR1AU7UXbMn
 LvmycZKfMnvi9K9gtcHdirkVA7EoQe+EhLFDqe8HnRz+8V1xqmA+BY1XfOsJpaZD8LH6
 UDzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=EdexJTeSJ1yzSq2NB9sPeJusVOkXFFsSU8w5tX+wAoY=;
 b=jZaoQWrKeiVktiFyagcn23xW9kO8aSxojkJk8xXY+nXJSdDzLW+3qtzbRzoZO0DUNi
 QKURCk5X8UoEq8pN9+jTJmBfMNQKEapsMA4sKSGQNUUMthw/jf6EOZsbINfYZEgNM6YM
 aXErvmUQtoXpI88ME0i8zG7mg/KS4S4JTmGtVNTxSkkij6mccIQRakDegbBgk0PSVlbd
 xcMAGQcYbcxGu8567kZQjta2Wuf8EukI5KIXJ46YShyzOxaVp6Zkqvyx5os9rBuxsAbF
 dUaIcts5cwqSL3mYJ1ZNWYycCQ4ufnjGKBkRm7vU0jyxqAfwYMOsuAntpTIzZSnaa3j1
 5qbA==
X-Gm-Message-State: AOAM530nQQckC9WY8gYHefqRkwh2SJvtLhFExtK49MS1sAJON5l8IyN1
 dw5Yv1CGEQjpIioDcXHNa+loWHqPfKIPy/z+
X-Google-Smtp-Source: ABdhPJxiNME7o6IoYWEvolPBp1wwKcDxQ2PJwQacH0w0glnZjPPICPGldNZPzVdYDrWU7SS+rM/Ucw==
X-Received: by 2002:adf:92c2:: with SMTP id 60mr29983169wrn.220.1600277707032; 
 Wed, 16 Sep 2020 10:35:07 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:e49d:f6be:d31b:ad3c])
 by smtp.gmail.com with ESMTPSA id j10sm35693576wrn.2.2020.09.16.10.35.05
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 16 Sep 2020 10:35:05 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 11/11] kvm: arm64: Remove unnecessary hyp mappings
Date: Wed, 16 Sep 2020 18:34:39 +0100
Message-Id: <20200916173439.32265-12-dbrazdil@google.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200916173439.32265-1-dbrazdil@google.com>
References: <20200916173439.32265-1-dbrazdil@google.com>
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
 arch/arm64/include/asm/kvm_mmu.h | 19 +++++--------------
 arch/arm64/kvm/arm.c             | 17 +----------------
 2 files changed, 6 insertions(+), 30 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 9db93da35606..7d1581bc8b97 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -531,28 +531,19 @@ static inline int kvm_map_vectors(void)
 DECLARE_PER_CPU_READ_MOSTLY(u64, arm64_ssbd_callback_required);
 DECLARE_KVM_NVHE_PER_CPU(u64, arm64_ssbd_callback_required);
 
-static inline int hyp_init_aux_data(void)
+static inline void hyp_init_aux_data(void)
 {
-	int cpu, err;
+	int cpu;
 
+	/* Copy arm64_ssbd_callback_required values from kernel to hyp. */
 	for_each_possible_cpu(cpu) {
-		u64 *ptr;
+		u64 *ptr = per_cpu_ptr_nvhe(arm64_ssbd_callback_required, cpu);
 
-		ptr = per_cpu_ptr_nvhe(arm64_ssbd_callback_required, cpu);
-		err = create_hyp_mappings(ptr, ptr + 1, PAGE_HYP);
-		if (err)
-			return err;
-
-		/* Copy value from kernel to hyp. */
 		*ptr = per_cpu(arm64_ssbd_callback_required, cpu);
 	}
-	return 0;
 }
 #else
-static inline int hyp_init_aux_data(void)
-{
-	return 0;
-}
+static inline void hyp_init_aux_data(void) {}
 #endif
 
 #define kvm_phys_to_vttbr(addr)		phys_to_ttbr(addr)
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 8293319a32e7..4483b6aca5d7 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1634,22 +1634,7 @@ static int init_hyp_mode(void)
 		}
 	}
 
-	for_each_possible_cpu(cpu) {
-		kvm_host_data_t *cpu_data;
-
-		cpu_data = per_cpu_ptr_hyp(kvm_host_data, cpu);
-		err = create_hyp_mappings(cpu_data, cpu_data + 1, PAGE_HYP);
-
-		if (err) {
-			kvm_err("Cannot map host CPU state: %d\n", err);
-			goto out_err;
-		}
-	}
-
-	err = hyp_init_aux_data();
-	if (err)
-		kvm_err("Cannot map host auxiliary data: %d\n", err);
-
+	hyp_init_aux_data();
 	return 0;
 
 out_err:
-- 
2.28.0.618.gf4bc123cb7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
