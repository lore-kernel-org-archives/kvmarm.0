Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6009415A0
	for <kvmarm@lists.linux.dev>; Tue, 17 Jan 2023 01:37:17 +0000 (UTC)
Received: by mail-pj1-f74.google.com with SMTP id h1-20020a17090a470100b0022646263abfso13645575pjg.6
        for <kvmarm@lists.linux.dev>; Mon, 16 Jan 2023 17:37:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=R/yQ6qOJ9nE5sbZwT5+Hdlb+OS4oscumD9F8iuYsEP0=;
        b=BIanP+6o+DalVgd3npztrKDyle5vEuGPPH2y24H9sG6gr8WHAqWrGxjc4qJOF3b7Pe
         pZ0ocJObA8sR1zKG3b4dtjvur3wtGP/F+RP81Lu2vmg/KJG3A5cY61EclFYbzoZmAD9R
         2t4xMqS2xPUWqi2ecaKApshFrbENbCi/23GuUYaeL+AQrZrLlr8C9X+eg1PV68Zzp/rJ
         FrpWTAt69byVLoVLigmqkOdQfbZOb83t1hj2H4gRXV+CPU32Jwi2Sv7wPPlbpjfe7N/r
         ZshXJAWwiJybZsnx4UMyJrAPpFVwfdEa+QeblTavPTbowIcGOkJ0WFEYxuUoeS2bNEq2
         3cOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R/yQ6qOJ9nE5sbZwT5+Hdlb+OS4oscumD9F8iuYsEP0=;
        b=5XfzfHA1cT7PjqOoLWb0G6yPA1+ZJNzeLmOsQy+x43zJzKkOGdyg2zgs0Qnv0yaOuk
         TDL0VCOcm6SHjh0M6nvMM/U1q9A+Fng5r0dc3YzFyzeZ2wSqOnxp0xZN3KPgMnwYndhg
         W+L0uYTazPMUkEoRnzbq6dzhYhPXpUg170E04iilVLWKQYRgThmFzonok8KJyKRcDiT8
         Vl42F/kFw1TQG8JncEsJgnqIDYtwwT/qOn/mbphUrm+eOufrK2QEfLg1wA4uaZXuenLd
         TLfFxRh33tWuy9CdrcSn1l3MAsWokW8hkiRc0ANetZ//AZNAqtOaxNg93KnKf9fHlbWO
         hozw==
X-Gm-Message-State: AFqh2krwoFawkrKPmMLPlFjj8z4nzezT/IvDDbcT9k9JeYSZ3e2IFeDR
	FE9kSoUmIOoQETPclukCYy66h82Ux8Y=
X-Google-Smtp-Source: AMrXdXu1BwvGS43nNucWc8njSPNaqgCGpTv5cPH0A8yykvGIC9UMKkE3HnsLwdKjNbWczW0pdOjTVkd832g=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:1401:b0:58b:bf1f:e213 with SMTP id
 l1-20020a056a00140100b0058bbf1fe213mr110981pfu.50.1673919436912; Mon, 16 Jan
 2023 17:37:16 -0800 (PST)
Date: Mon, 16 Jan 2023 17:35:37 -0800
In-Reply-To: <20230117013542.371944-1-reijiw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230117013542.371944-1-reijiw@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230117013542.371944-4-reijiw@google.com>
Subject: [PATCH v2 3/8] KVM: arm64: PMU: Preserve vCPU's PMCR_EL0.N value on
 vCPU reset
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Jing Zhang <jingzhangos@google.com>, 
	Raghavendra Rao Anata <rananta@google.com>, Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"

The number of PMU event counters is indicated in PMCR_EL0.N.
For a vCPU with PMUv3 configured, its value will be the same as
the host value by default. Userspace can set PMCR_EL0.N for the
vCPU to a lower value than the host value using KVM_SET_ONE_REG.
However, it is practically unsupported, as reset_pmcr() resets
PMCR_EL0.N to the host value on vCPU reset.

Change reset_pmcr() to preserve the vCPU's PMCR_EL0.N value on
vCPU reset so that userspace can limit the number of the PMU
event counter on the vCPU.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/pmu-emul.c | 6 ++++++
 arch/arm64/kvm/sys_regs.c | 4 +++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 24908400e190..937a272b00a5 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -213,6 +213,12 @@ void kvm_pmu_vcpu_init(struct kvm_vcpu *vcpu)
 
 	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++)
 		pmu->pmc[i].idx = i;
+
+	/*
+	 * Initialize PMCR_EL0 for the vCPU with the host value so that
+	 * the value is available at the very first vCPU reset.
+	 */
+	__vcpu_sys_reg(vcpu, PMCR_EL0) = read_sysreg(pmcr_el0);
 }
 
 /**
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 4959658b502c..67c1bd39b478 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -637,8 +637,10 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	if (!kvm_arm_support_pmu_v3())
 		return;
 
+	/* PMCR_EL0 for the vCPU is set to the host value at vCPU creation. */
+
 	/* Only preserve PMCR_EL0.N, and reset the rest to 0 */
-	pmcr = read_sysreg(pmcr_el0) & (ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT);
+	pmcr = __vcpu_sys_reg(vcpu, r->reg) & (ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT);
 	if (!kvm_supports_32bit_el0())
 		pmcr |= ARMV8_PMU_PMCR_LC;
 
-- 
2.39.0.314.g84b9a713c41-goog

