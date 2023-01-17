Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685AA15A0
	for <kvmarm@lists.linux.dev>; Tue, 17 Jan 2023 01:38:26 +0000 (UTC)
Received: by mail-pl1-f201.google.com with SMTP id n14-20020a170902d2ce00b00194a2301b10so978505plc.8
        for <kvmarm@lists.linux.dev>; Mon, 16 Jan 2023 17:38:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SDhGZMGcl/+rCpQW7EzsP5A7EK7uMx6I717AP5BdSVE=;
        b=g3A+F2lovTBusknN04Pspphh2sOZEygyJHo6g0SrJ2qVG/CZS9TOHepUiFMEbeu2P7
         +pbgUZcUYF9GlDu2Noju5TPTZatLo7dvV3wDHPHHLXd7YJ9d+17CzdZGeEHU0NL4BMYF
         rcTYh00PPwtNgsZ5yVDHHXSEHB5qB5IITaq2PmI67NCedEepfxXkNWDlmZrX+EBPgqAI
         pIGKaWKriMwjqFxECsiRor9wGaYSvU1+JKqrYzRyYHNVdGAb8aiO6l5y2aoYhYKiNmyz
         GLk9+y/dlVZ3Ae67oQRNlOcxe92GGHLfiG6kT5OlPZtVfxpx1K9Mty5YY4ISn/Piwj1A
         DtIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SDhGZMGcl/+rCpQW7EzsP5A7EK7uMx6I717AP5BdSVE=;
        b=YZsF8iEUmPKdrpkY5Vj1V0qiiUg0bJ3zHxWD+PglVFxoQD1D6wQdXeG6o/aMuGTI24
         AMebVgszgJpha9/q3PnpsMxpXnmx3KljuobeDm1HrpXfMB0ccO4hGKQ6vTi1X3nP3mJf
         eY5If2TItunIAHiUO8Ed7To65WF34sMwNnV6f6gbq0fdfzSA0vsHTcW8rOlD0Y6g8pr5
         pxG4+AhFWTUKz8BJBku4Y9tyU57xv/Iwolachq33o4z7CEFlbQAnrMDf3l6glVWC2iWl
         dJ5H46WGOcbtj+62JpdjDGh+CuqR0cnB9rugTvXMGkQs90uY6Ds8Wn8VwjVxAKfyLj1K
         XqKg==
X-Gm-Message-State: AFqh2koednsTXNM56c9on4FeN8zHkPUE4riaffQ8JaLWZu+1wBC2TshL
	n/iy5HqPYW7gafLniDs80Mz+EX1h/KA=
X-Google-Smtp-Source: AMrXdXuVU/+Elb5Rp0AHcmNgcHCXEJox4jaCx2mUWqCwLJEwmIXLFTyN3/3HemE7+V5HT6N4PiGUjHLD8m8=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:aa7:9f95:0:b0:578:1e16:f788 with SMTP id
 z21-20020aa79f95000000b005781e16f788mr134098pfr.12.1673919505841; Mon, 16 Jan
 2023 17:38:25 -0800 (PST)
Date: Mon, 16 Jan 2023 17:35:38 -0800
In-Reply-To: <20230117013542.371944-1-reijiw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230117013542.371944-1-reijiw@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230117013542.371944-5-reijiw@google.com>
Subject: [PATCH v2 4/8] KVM: arm64: PMU: Disallow userspace to set PMCR.N
 greater than the host value
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Jing Zhang <jingzhangos@google.com>, 
	Raghavendra Rao Anata <rananta@google.com>, Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"

Currently, KVM allows userspace to set PMCR_EL0 to any values
with KVM_SET_ONE_REG for a vCPU with PMUv3 configured.

Disallow userspace to set PMCR_EL0.N to a value that is greater
than the host value (KVM_SET_ONE_REG will fail), as KVM doesn't
support more event counters than the host HW implements.
Although this is an ABI change, this change only affects
userspace setting PMCR_EL0.N to a larger value than the host.
As accesses to unadvertised event counters indices is CONSTRAINED
UNPREDICTABLE behavior, and PMCR_EL0.N was reset to the host value
on every vCPU reset before this series, I can't think of any
use case where a user space would do that.

Also, ignore writes to read-only bits that are cleared on vCPU reset,
and RES{0,1} bits (including writable bits that KVM doesn't support
yet), as those bits shouldn't be modified (at least with
the current KVM).

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 67c1bd39b478..e4bff9621473 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -958,6 +958,43 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return true;
 }
 
+static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
+		    u64 val)
+{
+	u64 host_pmcr, host_n, new_n, mutable_mask;
+
+	new_n = (val >> ARMV8_PMU_PMCR_N_SHIFT) & ARMV8_PMU_PMCR_N_MASK;
+
+	host_pmcr = read_sysreg(pmcr_el0);
+	host_n = (host_pmcr >> ARMV8_PMU_PMCR_N_SHIFT) & ARMV8_PMU_PMCR_N_MASK;
+
+	/* The vCPU can't have more counters than the host have. */
+	if (new_n > host_n)
+		return -EINVAL;
+
+	/*
+	 * Ignore writes to RES0 bits, read only bits that are cleared on
+	 * vCPU reset, and writable bits that KVM doesn't support yet.
+	 * (i.e. only PMCR.N and bits [7:0] are mutable from userspace)
+	 * The LP bit is RES0 when FEAT_PMUv3p5 is not supported on the vCPU.
+	 * But, we leave the bit as it is here, as the vCPU's PMUver might
+	 * be changed later (NOTE: the bit will be cleared on first vCPU run
+	 * if necessary).
+	 */
+	mutable_mask = (ARMV8_PMU_PMCR_MASK |
+			(ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT));
+	val &= mutable_mask;
+	val |= (__vcpu_sys_reg(vcpu, r->reg) & ~mutable_mask);
+
+	/* The LC bit is RES1 when AArch32 is not supported */
+	if (!kvm_supports_32bit_el0())
+		val |= ARMV8_PMU_PMCR_LC;
+
+	__vcpu_sys_reg(vcpu, r->reg) = val;
+
+	return 0;
+}
+
 /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
 #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
 	{ SYS_DESC(SYS_DBGBVRn_EL1(n)),					\
@@ -1718,7 +1755,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_SVCR), undef_access },
 
 	{ PMU_SYS_REG(SYS_PMCR_EL0), .access = access_pmcr,
-	  .reset = reset_pmcr, .reg = PMCR_EL0 },
+	  .reset = reset_pmcr, .reg = PMCR_EL0, .set_user = set_pmcr },
 	{ PMU_SYS_REG(SYS_PMCNTENSET_EL0),
 	  .access = access_pmcnten, .reg = PMCNTENSET_EL0 },
 	{ PMU_SYS_REG(SYS_PMCNTENCLR_EL0),
-- 
2.39.0.314.g84b9a713c41-goog

