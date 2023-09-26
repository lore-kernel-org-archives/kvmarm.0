Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C1D4998F
	for <kvmarm@lists.linux.dev>; Tue, 26 Sep 2023 23:40:15 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-c647150c254so20684242276.1
        for <kvmarm@lists.linux.dev>; Tue, 26 Sep 2023 16:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695771614; x=1696376414; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Qevun5/yY9+JK3ZHPWuRVz7IcDpyIACFdYtKkR+rLD4=;
        b=oOq5QhKkAraPDRos+NFaG0ZRn/84GwwNecQx/R9zSBvemN/vPOlRuGopKYGlYVSXKr
         x+uJtwtqMurXg5FyKFaILrbXIwjJpY/lVOEcXCyNQxAUtgs1Korv/me0l15R3ptc3nA7
         /ejQeNQBMf+4bXE0+jugz9sN9UX8A4e1eZaMLsLtEFr5l3yEpSzu51DNVhMjBbsatkEi
         Um888jSJzhQppml/W6jIPkkZ2xWzsyiSk35jx7b+CzawVAC8h9dMF6uZbFh9nHvz9G6B
         BOsIUjWeFvQkqiHtEsagEsOQYDsTJbVmWtYMuJyO77cV/RZyORxmjKQb/UOCTlojvBai
         RLBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695771614; x=1696376414;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qevun5/yY9+JK3ZHPWuRVz7IcDpyIACFdYtKkR+rLD4=;
        b=T4sSzN5p4USb9h8bVl4szwRQ/gd0JwBoNu5qyysaOYkykbUVjuIWIjt35vSq/T4apZ
         d23W14MTwzPPFBkBJxBzDZzrpQM6UNQjYvH03dDCc2un026uCwdNazPoYA+xqfe9rJvJ
         /qESOWy+DNsbM3dzlm+nrAcJpTZaw6XOU9RW64xegEGSDjb56J0VItNxOvq2apw14m2s
         vOLYlGCC6whtGbPCxG+9LXct9G5xOzPHA9niFe3AqNyTCVdzr+Saa/qAJhkADwSECLtP
         BxA9hgP2pp9NGdwA+zNcVbx8i4ICd8DKVt+5xcoihE3nybe9xQGIIJFdxvqHLym5NK4F
         GXqw==
X-Gm-Message-State: AOJu0YwdUtYloiODPVYTHgjthsYpiDRXQFjIH4YkrNmklbrrnnK1i/tj
	Frra5qwl4vwgPzDnf9ylBpruWg4O+JKl
X-Google-Smtp-Source: AGHT+IEetmKobj2HvrfP5UmgYOr+yV8c5JH7C8utm5y5aVOqCwA2WWM3hZUA8gTkdds5ZVhPcUCGyps/w76l
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:20a1])
 (user=rananta job=sendgmr) by 2002:a05:6902:4f2:b0:ca3:3341:6315 with SMTP id
 w18-20020a05690204f200b00ca333416315mr8256ybs.0.1695771614584; Tue, 26 Sep
 2023 16:40:14 -0700 (PDT)
Date: Tue, 26 Sep 2023 23:40:00 +0000
In-Reply-To: <20230926234008.2348607-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230926234008.2348607-1-rananta@google.com>
X-Mailer: git-send-email 2.42.0.582.g8ccd20d70d-goog
Message-ID: <20230926234008.2348607-4-rananta@google.com>
Subject: [PATCH v6 03/11] KVM: arm64: PMU: Clear PM{C,I}NTEN{SET,CLR} and
 PMOVS{SET,CLR} on vCPU reset
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

On vCPU reset, PMCNTEN{SET,CLR}_EL0, PMINTEN{SET,CLR}_EL1, and
PMOVS{SET,CLR}_EL1 for a vCPU are reset by reset_pmu_reg().
This function clears RAZ bits of those registers corresponding
to unimplemented event counters on the vCPU, and sets bits
corresponding to implemented event counters to a predefined
pseudo UNKNOWN value (some bits are set to 1).

The function identifies (un)implemented event counters on the
vCPU based on the PMCR_EL0.N value on the host. Using the host
value for this would be problematic when KVM supports letting
userspace set PMCR_EL0.N to a value different from the host value
(some of the RAZ bits of those registers could end up being set to 1).

Fix this by clearing the registers so that it can ensure
that all the RAZ bits are cleared even when the PMCR_EL0.N value
for the vCPU is different from the host value. Use reset_val() to
do this instead of fixing reset_pmu_reg(), and remove
reset_pmu_reg(), as it is no longer used.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/kvm/sys_regs.c | 21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index e92ec810d4494..ffd123fae30d6 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -717,25 +717,6 @@ static unsigned int pmu_visibility(const struct kvm_vcpu *vcpu,
 	return REG_HIDDEN;
 }
 
-static u64 reset_pmu_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
-{
-	u64 n, mask = BIT(ARMV8_PMU_CYCLE_IDX);
-
-	/* No PMU available, any PMU reg may UNDEF... */
-	if (!kvm_arm_support_pmu_v3())
-		return 0;
-
-	n = read_sysreg(pmcr_el0) >> ARMV8_PMU_PMCR_N_SHIFT;
-	n &= ARMV8_PMU_PMCR_N_MASK;
-	if (n)
-		mask |= GENMASK(n - 1, 0);
-
-	reset_unknown(vcpu, r);
-	__vcpu_sys_reg(vcpu, r->reg) &= mask;
-
-	return __vcpu_sys_reg(vcpu, r->reg);
-}
-
 static u64 reset_pmevcntr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	reset_unknown(vcpu, r);
@@ -1115,7 +1096,7 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	  trap_wcr, reset_wcr, 0, 0,  get_wcr, set_wcr }
 
 #define PMU_SYS_REG(name)						\
-	SYS_DESC(SYS_##name), .reset = reset_pmu_reg,			\
+	SYS_DESC(SYS_##name), .reset = reset_val,			\
 	.visibility = pmu_visibility
 
 /* Macro to expand the PMEVCNTRn_EL0 register */
-- 
2.42.0.582.g8ccd20d70d-goog

