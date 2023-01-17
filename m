Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C2D15A0
	for <kvmarm@lists.linux.dev>; Tue, 17 Jan 2023 01:36:04 +0000 (UTC)
Received: by mail-pg1-f202.google.com with SMTP id y37-20020a634b25000000b004b1d90ea947so11235766pga.15
        for <kvmarm@lists.linux.dev>; Mon, 16 Jan 2023 17:36:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=300KIYOplSSI+ZMp3X/TUeSfcU5weuXC03K02O9sYcM=;
        b=e3uPjfL92VI+YaZk15R9Pjh1o0bTmFUgCgCOFhlKvx6QcljtI9lz6v/zbfJSXvCd1D
         iePHCuAoPzbThx8eQiufOY3N1km12jfbD/cou2HuyyJ+Lcks6hZjcTxr9AmbX0n0WwgU
         8dLluqitN3rdpOREVQp48ieClgybL+BAS2FXNmseBT+L87FIguRrtRc+f+51aE0ze0V9
         IJBPNu7PtOmIU1HobDWB2MihtfXtnwrcIFxlHwwteauzVb06LlFO+GgsJodWobJEzKEB
         UKghbjf4h72RgnjI8XjD9aZwQWz5JvXhq+FGDviZVrXadf4JROqAO9hMm0OJ5bKwv4d1
         QZNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=300KIYOplSSI+ZMp3X/TUeSfcU5weuXC03K02O9sYcM=;
        b=GD9DyJQlKNGF2reHfB60I8TmD580cVKHgigeuxlBZqYCVvg7Z4SDKlwVS43b1uOMyc
         Yq8pWGuC6NjbrBlt41XTQ6U5HZcO3mVowwNiIjra+RcUQgWlWY/OsL9fnsks45MR4Eiy
         VfQivinT7Kca7l+Yc/YRtShw62ov1cSgKZ2hU33hD83jUTeCRNpUYD+JiUKMg1wjLHJP
         +Hhe266Cbp/HFr9ya0gtqnOVqxEmrrQrU/fzYd2XIKio9owoNxrnFyY8E9CJVAJ8lhbt
         gIYkIJBPpmhzOdvtJ1ivpqns7f6MNYTbDh20qugeGHyuyDsAt7rRHwKon7Wgl5PKBT1J
         uxyg==
X-Gm-Message-State: AFqh2kpJTvAYtUANS+zk+G0JSR/tsksVocb1aSWB91BtGubGkiBEHm8Z
	4M2RFyiMQqYT+axnITC62+/NBUGGBWc=
X-Google-Smtp-Source: AMrXdXs3rKjFgNbseEaHIbohSFHUxCQJdUXPGHsNJTk1fHY3uVZgpmMJpJfCn/DzEXDXOFyJQLcX1QD8O9w=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a62:e801:0:b0:58d:aeb6:2d66 with SMTP id
 c1-20020a62e801000000b0058daeb62d66mr130395pfi.66.1673919363765; Mon, 16 Jan
 2023 17:36:03 -0800 (PST)
Date: Mon, 16 Jan 2023 17:35:35 -0800
In-Reply-To: <20230117013542.371944-1-reijiw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230117013542.371944-1-reijiw@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230117013542.371944-2-reijiw@google.com>
Subject: [PATCH v2 1/8] KVM: arm64: PMU: Have reset_pmu_reg() to clear a register
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Jing Zhang <jingzhangos@google.com>, 
	Raghavendra Rao Anata <rananta@google.com>, Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"

On vCPU reset, PMCNTEN{SET,CLR}_EL0, PMINTEN{SET,CLR}_EL1, and
PMOVS{SET,CLR}_EL1 for a vCPU are reset by reset_pmu_reg().
This function clears RAZ bits of those registers corresponding
to unimplemented event counters on the vCPU, and sets bits
corresponding to implemented event counters to a predefined
pseudo UNKNOWN value (some bits are set to 1).

The function identifies (un)implemented event counters on the
vCPU based on the PMCR_EL1.N value on the host. Using the host
value for this would be problematic when KVM supports letting
userspace set PMCR_EL1.N to a value different from the host value
(some of the RAZ bits of those registers could end up being set to 1).

Fix reset_pmu_reg() to clear the registers so that it can ensure
that all the RAZ bits are cleared even when the PMCR_EL1.N value
for the vCPU is different from the host value.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c6cbfe6b854b..ec4bdaf71a15 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -604,19 +604,11 @@ static unsigned int pmu_visibility(const struct kvm_vcpu *vcpu,
 
 static void reset_pmu_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
-	u64 n, mask = BIT(ARMV8_PMU_CYCLE_IDX);
-
 	/* No PMU available, any PMU reg may UNDEF... */
 	if (!kvm_arm_support_pmu_v3())
 		return;
 
-	n = read_sysreg(pmcr_el0) >> ARMV8_PMU_PMCR_N_SHIFT;
-	n &= ARMV8_PMU_PMCR_N_MASK;
-	if (n)
-		mask |= GENMASK(n - 1, 0);
-
-	reset_unknown(vcpu, r);
-	__vcpu_sys_reg(vcpu, r->reg) &= mask;
+	__vcpu_sys_reg(vcpu, r->reg) = 0;
 }
 
 static void reset_pmevcntr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
-- 
2.39.0.314.g84b9a713c41-goog

