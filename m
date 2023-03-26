Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0974E393
	for <kvmarm@lists.linux.dev>; Sun, 26 Mar 2023 01:19:57 +0000 (UTC)
Received: by mail-pg1-f202.google.com with SMTP id q15-20020a63d60f000000b00502e1c551aaso1411522pgg.21
        for <kvmarm@lists.linux.dev>; Sat, 25 Mar 2023 18:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679793597;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AiMZEZjS/R3ipxVNHJJuMkHexwVTEkmCRRTtOI5qhNw=;
        b=KqTTT40bJR0BN34ySkmBfSuRZ9EgxGkBStd0Pv2hwquBjC03w54UHh/lcw2yxGA9C1
         8eU3hwKB+diiVW8mgMrcTntSOR+XpOEvUqV9tMV4BDtXtsB9uJ/KMMwYh55Ww52lrPos
         eSdDHtEd+AozRtUGd43QRI7LLxHj9yggf+Ukuk3JbiXzJE5tnp0H4EZkb96/WB6oarAM
         dw4iQUNfDV1HDm+AlbUSKsBIuNuk6QAJkzm0+NfPV0dluSru/hEO3KMKR55YA9eXkZDH
         KOoaGXQ8LESI7agnkg72WRtqLxljwC6WzOrFkv33VrSt1KdPZ/QKyPemO/wpG4K3AjBJ
         YDUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679793597;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AiMZEZjS/R3ipxVNHJJuMkHexwVTEkmCRRTtOI5qhNw=;
        b=sR0SZleiE8yyKYEDyD16xiT/l7m4POoS5obYhnqOlYD9MKjLm6MyA1FlWMH13dSumd
         yYO8j+TR+KX1vdp755lJLnXvc+8cqXeshPo/qMUH0C6zUd4gd9kP3kjSqz43exo11tuA
         gzLB72CbUc/Xo9+DbTbPo89f/qZgQh3jqUqp5ddo5o9rlBthND2w3NkLCU6O72kYMBz0
         C26qujpqHijvxcLPvFWiMzgw4BnPOCdLgzT+oeX6G46+LAlQWd3b/VmWKwYfSH6q/tf0
         DoK2yq0t0DIPyh1Y/k42m46RsGSWnf07vd8YyBDuyGed7g44t1CqH305rBT2+4MunUf6
         VO3w==
X-Gm-Message-State: AAQBX9fvb1ZsZjJS7k01MeUl6fvGb8fgHMqC/QQ8r/rl8r5lykBrTinZ
	Wli7LgUYVGqZYAg3SMes3gYUvJg38S6xATe4kg==
X-Google-Smtp-Source: AKy350avbKAxOk+db38c6sX31fwyjmAlmiFXrdx0L1mTNt1HhUge0LRva3Myy/yf6APbwdmWYSewCKG/DZD9iJa/gA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:90a:4d8a:b0:23f:6e7:f462 with SMTP
 id m10-20020a17090a4d8a00b0023f06e7f462mr2142071pjh.2.1679793597500; Sat, 25
 Mar 2023 18:19:57 -0700 (PDT)
Date: Sun, 26 Mar 2023 01:19:49 +0000
In-Reply-To: <20230326011950.405749-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230326011950.405749-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230326011950.405749-3-jingzhangos@google.com>
Subject: [PATCH v1 2/3] KVM: arm64: Enable writable for remaining fields for ID_AA64DFR0_EL1
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@google.com>
Cc: Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Ricardo Koller <ricarkol@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

Enable writable from userspace for all remaining fields in
ID_AA64DFR0_EL1, which don't need special handlings for dependency.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/id_regs.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
index 64691273980b..e64152aa448b 100644
--- a/arch/arm64/kvm/id_regs.c
+++ b/arch/arm64/kvm/id_regs.c
@@ -626,12 +626,32 @@ static struct id_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] = {
 		.get_user = get_id_reg,
 		.set_user = set_id_aa64dfr0_el1, },
 	  .ftr_bits = {
+		ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
+			ID_AA64DFR0_EL1_DebugVer_SHIFT, ID_AA64DFR0_EL1_DebugVer_WIDTH, 0),
+		ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
+			ID_AA64DFR0_EL1_TraceVer_SHIFT, ID_AA64DFR0_EL1_TraceVer_WIDTH, 0),
 		ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
 			ID_AA64DFR0_EL1_PMUVer_SHIFT, ID_AA64DFR0_EL1_PMUVer_WIDTH, 0),
 		ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
 			ID_AA64DFR0_EL1_BRPs_SHIFT, ID_AA64DFR0_EL1_BRPs_WIDTH, 0),
+		ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
+			ID_AA64DFR0_EL1_WRPs_SHIFT, ID_AA64DFR0_EL1_WRPs_WIDTH, 0),
 		ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
 			ID_AA64DFR0_EL1_CTX_CMPs_SHIFT, ID_AA64DFR0_EL1_CTX_CMPs_WIDTH, 0),
+		ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
+			ID_AA64DFR0_EL1_PMSVer_SHIFT, ID_AA64DFR0_EL1_PMSVer_WIDTH, 0),
+		ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
+			ID_AA64DFR0_EL1_DoubleLock_SHIFT, ID_AA64DFR0_EL1_DoubleLock_WIDTH, 0),
+		ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
+			ID_AA64DFR0_EL1_TraceFilt_SHIFT, ID_AA64DFR0_EL1_TraceFilt_WIDTH, 0),
+		ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
+			ID_AA64DFR0_EL1_TraceBuffer_SHIFT, ID_AA64DFR0_EL1_TraceBuffer_WIDTH, 0),
+		ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
+			ID_AA64DFR0_EL1_MTPMU_SHIFT, ID_AA64DFR0_EL1_MTPMU_WIDTH, 0),
+		ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
+			ID_AA64DFR0_EL1_BRBE_SHIFT, ID_AA64DFR0_EL1_BRBE_WIDTH, 0),
+		ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
+			ID_AA64DFR0_EL1_HPMN0_SHIFT, ID_AA64DFR0_EL1_HPMN0_WIDTH, 0),
 		ARM64_FTR_END, },
 	  .init = init_id_aa64dfr0_el1,
 	},
-- 
2.40.0.348.gf938b09366-goog

