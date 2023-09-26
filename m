Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB934BDAD
	for <kvmarm@lists.linux.dev>; Tue, 26 Sep 2023 23:40:16 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d81646fcf3eso15441357276.0
        for <kvmarm@lists.linux.dev>; Tue, 26 Sep 2023 16:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695771615; x=1696376415; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jKu1b4ypf/1yghTsriWdPSnBvGzU0xcIPJuBHtiUctI=;
        b=UFyWuaGjeWwM/TIs4fHhicuYIusyJM17ZeL1ChqtNrRqtkddpYdv9ImusKjgnaxqKc
         ibQdEe0bHBHV1s9oH4zgZ9ssz+5Ar/IsHCH3aLTA1NHqN9TSiwmnP3G96i2p594tvWqe
         l2+8Fi6nTFfuF+k3e3RiNoasBkB7kCo+vsx1qm4n669euaTrQzAsQ3AtQ+Mm4UlepzpC
         /I+qPm+iSdSKe4vabNnttsYXY3fM4YYbgwPsNzrylEfWItBu48lWBhYHceacchsWsTTD
         4fWE1qq4od9Vglb/nRYQ7GMQ4g9O6pkhPH0apooJ4g6BJommCWn9q7Hux9DK+EMIOyV4
         gRoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695771615; x=1696376415;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jKu1b4ypf/1yghTsriWdPSnBvGzU0xcIPJuBHtiUctI=;
        b=oVkArjKXRPRrnlMG/lDuClTFZTtljcAi81yRailbv8yT7QLq6a9A+H9Y5l2annIPsU
         H/Kq1d5aw2HCq7vidruS3a1KyhoNOCu/ohxPwoCgnn0tjG465PveqYRLoIPYY9ixs6GH
         REBYFBRoRXAcgFryT0vawF1aeCqSvOCGK2SqzSUuLPFaXYK9BPXzEP/acehVe9IwSr/3
         XTo3m2XyZRyhzLfMaDfo84NewVMFZLAxHx/Mkfk1kPEGAwBON1c6mmRORh6NBTAD0ii2
         fdLTMSXM2iXLyvDQckIjlVfLfn9hHBPagIc5xTDiZihygHabGSoNb8kYuXsD164cap/Y
         DJeA==
X-Gm-Message-State: AOJu0YyTi9CJ7rbApra/tvHbf3aaLIn4L+uOJtN6vzNqCwkq/1uSU8XB
	5s0xnwiMPgAY9xy9StbjeOXij8CtEuJc
X-Google-Smtp-Source: AGHT+IGV5SFhSIRyByL8fTSP12VqgZmgARh5Ry8ZzINOdYh4tv/44IYbvZ41cAWOSTLUQkOt8P/xRpn4mw7O
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:20a1])
 (user=rananta job=sendgmr) by 2002:a25:ad13:0:b0:d77:984e:c770 with SMTP id
 y19-20020a25ad13000000b00d77984ec770mr4746ybi.5.1695771615699; Tue, 26 Sep
 2023 16:40:15 -0700 (PDT)
Date: Tue, 26 Sep 2023 23:40:01 +0000
In-Reply-To: <20230926234008.2348607-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230926234008.2348607-1-rananta@google.com>
X-Mailer: git-send-email 2.42.0.582.g8ccd20d70d-goog
Message-ID: <20230926234008.2348607-5-rananta@google.com>
Subject: [PATCH v6 04/11] KVM: arm64: PMU: Don't define the sysreg reset() for PM{USERENR,CCFILTR}_EL0
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Reiji Watanabe <reijiw@google.com>

The default reset function for PMU registers (defined by PMU_SYS_REG)
now simply clears a specified register. Use the default one for
PMUSERENR_EL0 and PMCCFILTR_EL0, as KVM currently clears those
registers on vCPU reset (NOTE: All non-RES0 fields of those
registers have UNKNOWN reset values, and the same fields of
their AArch32 registers have 0 reset values).

No functional change intended.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/kvm/sys_regs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ffd123fae30d6..66b9e1de54230 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2180,7 +2180,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	 * in 32bit mode. Here we choose to reset it as zero for consistency.
 	 */
 	{ PMU_SYS_REG(PMUSERENR_EL0), .access = access_pmuserenr,
-	  .reset = reset_val, .reg = PMUSERENR_EL0, .val = 0 },
+	  .reg = PMUSERENR_EL0, },
 	{ PMU_SYS_REG(PMOVSSET_EL0),
 	  .access = access_pmovs, .reg = PMOVSSET_EL0 },
 
@@ -2338,7 +2338,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	 * in 32bit mode. Here we choose to reset it as zero for consistency.
 	 */
 	{ PMU_SYS_REG(PMCCFILTR_EL0), .access = access_pmu_evtyper,
-	  .reset = reset_val, .reg = PMCCFILTR_EL0, .val = 0 },
+	  .reg = PMCCFILTR_EL0, },
 
 	EL2_REG(VPIDR_EL2, access_rw, reset_unknown, 0),
 	EL2_REG(VMPIDR_EL2, access_rw, reset_unknown, 0),
-- 
2.42.0.582.g8ccd20d70d-goog

