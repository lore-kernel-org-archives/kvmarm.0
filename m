Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE72E55D
	for <kvmarm@lists.linux.dev>; Thu, 17 Aug 2023 00:30:36 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-589c2516024so72646437b3.3
        for <kvmarm@lists.linux.dev>; Wed, 16 Aug 2023 17:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692232235; x=1692837035;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3xjUNDJiBCoJcgjT/+49Msar3+0uyb3GjRudfsNPpjA=;
        b=nnwae7ChRhKPujDVQLlOFC/RbuGXKrYufvf1XOGFJo5aF+NN2asXevdOm4rbRZg8Tq
         aERDuo7GrEeVKvsx4Y4ftQzz7Fe54TcomW89SWLsiO2sFU0mLEMQMqCt3tWaiUuAZpF9
         aB+0qT5dhPAgfNfruG8Fkkt1LGwyH1vWQpzPpfbxi1n6HBjodVHOOTQ16KQgjvYU1+3h
         5o4p52ynaOPp3OxqDByhxbsEDOIbdsTuEmsCpOQo7M54IVuyHnmBv6YncwY0QMSo4Qjc
         98YJ22vCwSwb5CqrV3TU8soGecZyVDxibeatCdFjdbc7wJ1L26MX9SOsRVTVtLMiuYhe
         hBKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692232235; x=1692837035;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3xjUNDJiBCoJcgjT/+49Msar3+0uyb3GjRudfsNPpjA=;
        b=IR5y4X4xGkEBfXICrd6X98Stoz4XFYBPfWbWxs3+kSr7s3r4rgB8U+zJeU93hOzg9w
         wrEN8uyCtEw889u5QXjdDOtrbDjT4AdjxMUOk6DskHA4zSmJC0f6QXi8Oo19psiPeRRW
         JGc/0yFzxve8IGz081cJF3HMmfP4Jn9cJ2QgsCIrZJAqICQStXrV3A+B0+Z+J/8EiTqM
         PJbUQ9UUAuJyR9dO1MIiL6jNuNOmYfXV2LQGpCtQjDV+8sz081NQLFvvKF4lxezFn82p
         4nD2MPz7iYDYdGWwJlKHrmFeV1unleMvlaRD5rcP/b8eILZr0HFkulX7JZtAYuFJ2vFG
         lPqA==
X-Gm-Message-State: AOJu0YwtXubwaSSa50TDrFubB9/2mUE0a+4ZtGphpQZFgOCcLmA4rvKj
	RA59Hb56kpsRiDYxrn4Z+BMa3Kd9pnmY
X-Google-Smtp-Source: AGHT+IFXQ7fYcd7YawZs3vGh87IG1agI3VzWVFMFYY7UPKBon+KAo2ZGhUuGKeey7RaOXJKKXMGpcZI4dNMW
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a81:430c:0:b0:58c:b5a4:8e1f with SMTP id
 q12-20020a81430c000000b0058cb5a48e1fmr49495ywa.3.1692232235400; Wed, 16 Aug
 2023 17:30:35 -0700 (PDT)
Date: Thu, 17 Aug 2023 00:30:20 +0000
In-Reply-To: <20230817003029.3073210-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230817003029.3073210-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
Message-ID: <20230817003029.3073210-4-rananta@google.com>
Subject: [PATCH v5 03/12] KVM: arm64: PMU: Clear PM{C,I}NTEN{SET,CLR} and
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
index 2ca2973abe66f..9d3d44d165eed 100644
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
2.41.0.694.ge786442a9b-goog

