Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986E5393
	for <kvmarm@lists.linux.dev>; Sun, 26 Mar 2023 01:19:59 +0000 (UTC)
Received: by mail-pl1-f201.google.com with SMTP id z16-20020a170902d55000b001a06f9b5e31so3574924plf.21
        for <kvmarm@lists.linux.dev>; Sat, 25 Mar 2023 18:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679793599;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QI/EqVJSbrviuXTqoZjivbQTyKLSha3AimdnquYMXWc=;
        b=XRKc51T8cnu7JDEWX9tAI7inG2D1iaT67CaXMzQVUYoEs0bP1hCXvbePNvag0nUWJ3
         lUWSQDZTMvn71SCpNmYwWg6NSqpDi6KmDCloaMDl3sCsrKxH7Kb/Yr7KCiO2OTTGgHCL
         hJM9NipRmFgbn7WqBKNlrYDUpJV+t/fZLnZK7OfjelP2XyHlVo9O151TgkT03iSxczm0
         iBAUnxoNbNJ70ax08svmq0VN5wjd8CvISdK6AQX64L5SGCx+fnI3891TxaPy1vFjD8E8
         RK5FkBLxP33q2OEPScBa5fadHqDlCyMjdyRQ8S+BTWLhhSYG/QChcSrYCoUVhvLQAoc8
         XgwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679793599;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QI/EqVJSbrviuXTqoZjivbQTyKLSha3AimdnquYMXWc=;
        b=Hue5gOgIBAs8168k+WRi8tf4ZbKnBzzYHdNFm8LeFZCaA0P3I0bdNejhnLP1qx/Op1
         /VsOzuYa18twRWZnkw0Y/zFj/Ub87jiMmWQXMgTMC+ct+dmtOxTylEMXBc2C5CsuQWKC
         VJUEv7fCKc5Icibdbcl/2Tty5eBWqZEXY4yR3jVMk7l5IBQtmPGgStsXDoRicIj4w/3J
         GWtlBk3EsKSgzSCV7UGQnUbAIKfyQh6pTT1DTclJ4umB6rwz+2i/xa2mI4HDDDeBp1X0
         Rv6g6YFTMVvNMq95aXWhcEtOuQ3DKV/G0pMt2Kcmy564Xi+XhBVKaRGcNwhSUgG5yZO9
         PhQA==
X-Gm-Message-State: AAQBX9fu4B+qWuk4vvnQMOkiP/o5yitSJdd0+NCQQ9zANjna0dniJ+en
	ac/UkBqDVJxh30GN/uetyfTDHQScVIxQcgX9cA==
X-Google-Smtp-Source: AKy350YzdI6W2peL0PoLdiDUrbLBCuUczb8fA3S0s0TXKpTODOv4vqupPU3pSdRyK18yqYxPFmFAFTVFcG9zIn0KWA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:902:b94b:b0:19f:6f30:a3f6 with
 SMTP id h11-20020a170902b94b00b0019f6f30a3f6mr2661620pls.1.1679793599120;
 Sat, 25 Mar 2023 18:19:59 -0700 (PDT)
Date: Sun, 26 Mar 2023 01:19:50 +0000
In-Reply-To: <20230326011950.405749-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230326011950.405749-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230326011950.405749-4-jingzhangos@google.com>
Subject: [PATCH v1 3/3] KVM: arm64: Enable writable for all fields in ID_DFR0_EL1
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

All valid fields in ID_DFR0_EL1 are writable from usrespace with this
change.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/id_regs.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
index e64152aa448b..7dc2fb8121f3 100644
--- a/arch/arm64/kvm/id_regs.c
+++ b/arch/arm64/kvm/id_regs.c
@@ -565,8 +565,22 @@ static struct id_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] = {
 		.set_user = set_id_dfr0_el1,
 		.visibility = aa32_id_visibility, },
 	  .ftr_bits = {
+		ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
+			ID_DFR0_EL1_CopDbg_SHIFT, ID_DFR0_EL1_CopDbg_WIDTH, 0),
+		ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
+			ID_DFR0_EL1_CopSDbg_SHIFT, ID_DFR0_EL1_CopSDbg_WIDTH, 0),
+		ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
+			ID_DFR0_EL1_MMapDbg_SHIFT, ID_DFR0_EL1_MMapDbg_WIDTH, 0),
+		ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
+			ID_DFR0_EL1_CopTrc_SHIFT, ID_DFR0_EL1_CopTrc_WIDTH, 0),
+		ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
+			ID_DFR0_EL1_MMapTrc_SHIFT, ID_DFR0_EL1_MMapTrc_WIDTH, 0),
+		ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
+			ID_DFR0_EL1_MProfDbg_SHIFT, ID_DFR0_EL1_MProfDbg_WIDTH, 0),
 		ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
 			ID_DFR0_EL1_PerfMon_SHIFT, ID_DFR0_EL1_PerfMon_WIDTH, 0),
+		ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
+			ID_DFR0_EL1_TraceFilt_SHIFT, ID_DFR0_EL1_TraceFilt_WIDTH, 0),
 		ARM64_FTR_END, },
 	  .init = init_id_dfr0_el1,
 	},
-- 
2.40.0.348.gf938b09366-goog

