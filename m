Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3A236B07
	for <kvmarm@lists.linux.dev>; Mon,  9 Oct 2023 23:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a+VcBYvS"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-d9a581346c4so137279276.0
        for <kvmarm@lists.linux.dev>; Mon, 09 Oct 2023 16:09:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696892947; x=1697497747; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JVCCYYHAr8CSZ5MG69SHY7zRH5V9FX2+QRsBdoTJR7I=;
        b=a+VcBYvSrEQrZTWfpy6KqTgIWPGtfbwOoK77Nrw+wyuYOdwrkkPOc1UMEHS3yGGXDU
         DOYnK2nmaMLnGkyaz0F0FGFwvmRvgNnXMkutWvWXOqmdv8z0T9z8/F4DUO6WjgqgJrH4
         EED5YCZlKaMrovaelkjRW/67QLDpceoIk2x3+oXzZV0k0pZWQO9045UAuvaQplzZei5o
         c/sljx/uCFC6rVzVxqf8gzfnkEK5hN18cVqDt4QSPcUO4Y1npp6hm/nU5yRLf4UevoQI
         0FxzUQoWZp1mqmALtoYCW6DYovuPA4lBEkyQxHEWEL2Yjdifc4AzbjtZzNgUPsnNoZXb
         6fDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696892947; x=1697497747;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JVCCYYHAr8CSZ5MG69SHY7zRH5V9FX2+QRsBdoTJR7I=;
        b=fSlN1b6eK28QnvbBPE3AeM1KitTFiEdW8AZbZ1Kzh1QNHjGbup4wxmMVt4HN45IyK3
         Gz2BzQT637JG2P2ViYJP0f5eX+iI39oMOcec81NX+7m8KXZjJhDWUdtyyDqOMW7/hPCq
         Fw0+1MVDtGa8jCP3szhKhNfeHD9qmYNDznA90eE1jQzdQ2Rtbk2lMi/IiSvhsZnNbfQT
         DYqAIj/WVTsBScMkwJsyOOrkZ+NxbPHfcvy4Ul/+/IiLhcLzhTESJUcXHDpUT1oNkVPj
         yTxdXhP+58qfL11dAMWxcS+u6XzVUeZ5wLOhoRCvxmPJWCiaBMzM4MS00FqPdriE6K/x
         2Ang==
X-Gm-Message-State: AOJu0YzP3qCe7CmG3Fbir74KyY5OaZvDyHSFCpZU4M3Sf7unVzFqmeb+
	gROZ+YnayZMuhioS/KIHD7zzrGXcu1pj
X-Google-Smtp-Source: AGHT+IHIs4oBYizNBaeSJxR7psR+gQ2uPd5kPXIt+bfHzIRybaO/dEl/UqH/5vlJK0t0Tca8kOKZZSSy04NM
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:20a1])
 (user=rananta job=sendgmr) by 2002:a25:d313:0:b0:d7b:92d7:5629 with SMTP id
 e19-20020a25d313000000b00d7b92d75629mr287651ybf.8.1696892947170; Mon, 09 Oct
 2023 16:09:07 -0700 (PDT)
Date: Mon,  9 Oct 2023 23:08:49 +0000
In-Reply-To: <20231009230858.3444834-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231009230858.3444834-1-rananta@google.com>
X-Mailer: git-send-email 2.42.0.609.gbb76f46606-goog
Message-ID: <20231009230858.3444834-4-rananta@google.com>
Subject: [PATCH v7 03/12] KVM: arm64: PMU: Clear PM{C,I}NTEN{SET,CLR} and
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
index 818a52e257ed..3dbb7d276b0e 100644
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
2.42.0.609.gbb76f46606-goog

