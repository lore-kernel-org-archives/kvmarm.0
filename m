Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E48CA3F
	for <kvmarm@lists.linux.dev>; Sat, 11 Feb 2023 03:16:43 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id a1-20020a258701000000b008e1de4c1e7dso5356735ybl.17
        for <kvmarm@lists.linux.dev>; Fri, 10 Feb 2023 19:16:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Qt9DyyP+jmxt2SRd9Qfh6SlGcBq+sGg3jGSKwiZnJL0=;
        b=C1bEkr31Oghws9EXM2+M78anmo1fN6vdiqVKbpzl4X7MsRntpD5o+I8PqT5MvEFooZ
         kQr7e8aA/+8WIn8xqsm3jq9Tm8xgZrHyMSJB1LdNMgX7JcRvxW0ec+JBL3MoVg8/d1sJ
         Z8tBsoDqXa556tZjMiWiSsqXliJDZVVvzQq4gmoLuLo7bi0OxJkM/A2ZqBuFyzf5VL1W
         EYQFEqS3Lrl26h+oAUO0PyL4iLKeMNQyYXTc1Rs6Xy7cJJvBNmpVypwHtvbpYDxpuNzt
         re45vhtC/opL+3MfEYkx1em6R9CUm90bIIztwg/woBPSmUrcDmmOlH0E09fXY9zPS63p
         yRIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qt9DyyP+jmxt2SRd9Qfh6SlGcBq+sGg3jGSKwiZnJL0=;
        b=VOC9WR1JKtZIUr6r8j6VtwjHgwiWOtyV0X/0KBfImKLDfIa9pKC2qgeQRO6/w7OWR1
         dqQiVVe5Jk3wE59gq5yxbLKVqmmMapN5nSBocSggM1jzLhKcXnz8NCDZwRPhSUT5mHvR
         g8ntsBmcg0d5x5snIM2duf0/D24LLIB60Ki242L6oHgq4q9fFWv0Ck1FEkFIijGwORJI
         ve1hoX2jIF3w6oU7aLiM5N3qkdKJmMhOKOBTwStg6w4krfi7hNdnEqCfuJ/Ue0ZxJl5X
         KmPXicNV+RWnpYlZi+oGDqc1EGhJu9be09ip+ST/BMPCpCgdZz9U8inyKITXwbc4fB3E
         QygA==
X-Gm-Message-State: AO0yUKWNfKaOwdZBoDi1rLgslFTx6eyDd7SUhnudmhq/L5Wk3u/W2ehj
	oFPM4NfeA6atPmw1wIuwY5UfMxw4Bvw=
X-Google-Smtp-Source: AK7set+ncL9YC5JFHYhtNyMYhJcbgzv4xqHEyW0dk7wxu2vqklwEMnCfyPDaS30N5G1PI7QfeeBSP5J2yF0=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a81:9304:0:b0:52e:e6ed:30a7 with SMTP id
 k4-20020a819304000000b0052ee6ed30a7mr158690ywg.551.1676085402308; Fri, 10 Feb
 2023 19:16:42 -0800 (PST)
Date: Fri, 10 Feb 2023 19:14:57 -0800
In-Reply-To: <20230211031506.4159098-1-reijiw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230211031506.4159098-1-reijiw@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230211031506.4159098-6-reijiw@google.com>
Subject: [PATCH v4 05/14] KVM: arm64: PMU: Clear PM{C,I}NTEN{SET,CLR} and
 PMOVS{SET,CLR} on vCPU reset
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Jing Zhang <jingzhangos@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"

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
---
 arch/arm64/kvm/sys_regs.c | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c1ec4a68b914..e6e419157856 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -602,23 +602,6 @@ static unsigned int pmu_visibility(const struct kvm_vcpu *vcpu,
 	return REG_HIDDEN;
 }
 
-static void reset_pmu_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
-{
-	u64 n, mask = BIT(ARMV8_PMU_CYCLE_IDX);
-
-	/* No PMU available, any PMU reg may UNDEF... */
-	if (!kvm_arm_support_pmu_v3())
-		return;
-
-	n = read_sysreg(pmcr_el0) >> ARMV8_PMU_PMCR_N_SHIFT;
-	n &= ARMV8_PMU_PMCR_N_MASK;
-	if (n)
-		mask |= GENMASK(n - 1, 0);
-
-	reset_unknown(vcpu, r);
-	__vcpu_sys_reg(vcpu, r->reg) &= mask;
-}
-
 static void reset_pmevcntr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	reset_unknown(vcpu, r);
@@ -976,7 +959,7 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	  trap_wcr, reset_wcr, 0, 0,  get_wcr, set_wcr }
 
 #define PMU_SYS_REG(r)						\
-	SYS_DESC(r), .reset = reset_pmu_reg, .visibility = pmu_visibility
+	SYS_DESC(r), .reset = reset_val, .visibility = pmu_visibility
 
 /* Macro to expand the PMEVCNTRn_EL0 register */
 #define PMU_PMEVCNTR_EL0(n)						\
-- 
2.39.1.581.gbfd45094c4-goog

