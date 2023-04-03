Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46EBF366
	for <kvmarm@lists.linux.dev>; Mon,  3 Apr 2023 00:37:28 +0000 (UTC)
Received: by mail-pl1-f202.google.com with SMTP id j18-20020a170902da9200b001a055243657so16607981plx.19
        for <kvmarm@lists.linux.dev>; Sun, 02 Apr 2023 17:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680482247;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=n9hPEYzgNXRlO9uoyqPqxQh7PdJy06R+RDjdkmdpz/c=;
        b=NRtbxi5vrt9eFXSSXs1twqJTwK/3Nket9yy3+qA3Ojsm17zd1APFPfJECa5atNFHQj
         I7pa4qqiZr8xG/dNvazCN94z6uTO7gUjY2+6T4lZwnEYt9grt6Qez8JflWMZF9SvaVrB
         DYI79IDdOSY5GKqu8eKGn6WHZCqt6R3IY3pB3HTfpxE7FSiovK8QXN0WadG5+yxCL58n
         way45DpLZgkVGHd+QDzu4I0skN4V9OjHfYRaGJIkcjinyTj19Cl8ehZUy0MStUQhIsQ5
         jyu74KvTkJVwt+QaZHkHFaxjAeObyoRQOfQfAYIdQls2+cxf8jgcBLsXXLB0bdQ5DXQ8
         aLAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680482247;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n9hPEYzgNXRlO9uoyqPqxQh7PdJy06R+RDjdkmdpz/c=;
        b=jAKhFjK7YlpeXY6jNK6y/dnS4mQVStP53/r1WTzDtAaqRhhutoJPa7Z2tP9/9dGPLm
         s//T0TM/Y9WzG+rJ4vYR8EgBBk+Pn93nzmflszC9Ybd2vRylBb96YiTXwEO2yAlx5xGU
         zpu+qaG5CCn/POLSbN2tRQRiRPBCalwD5unMh8owSz96fML735+ygmS07+mpSV8t0y6J
         vKLrQ/es+bug0ATzGTegDniTmZx2IGTEB7dstn2dwWkCWElCmB/OPwncYl3Qn0ZH6Trc
         qVru3VBvVn0ERGmI2Q+tg9uViPodx/RKKkiZ9fhb453RqiM/Y8NcduLMyYJ9sZeqz2xk
         DGEQ==
X-Gm-Message-State: AAQBX9duKWMP0R6+Ab2sJb/rLwYBFHquUzfYOxOebU+/XBjFMjIJFJGf
	aSZABtLp93kt++qMnP+lBpSjDxvNZz/tPziyXg==
X-Google-Smtp-Source: AKy350YvYZD4xlcGV3J9XFyvItXlNeRUnWMXoeihnesDdqKMO8h8/ozUdcGAtvsc5vhiQSgXaBt6M2uddrnRjkBf+w==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6a00:2d8f:b0:62d:ccc4:2e03 with
 SMTP id fb15-20020a056a002d8f00b0062dccc42e03mr6387878pfb.4.1680482247647;
 Sun, 02 Apr 2023 17:37:27 -0700 (PDT)
Date: Mon,  3 Apr 2023 00:37:22 +0000
In-Reply-To: <20230403003723.3199828-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230403003723.3199828-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230403003723.3199828-2-jingzhangos@google.com>
Subject: [PATCH v2 1/2] KVM: arm64: Enable writable for ID_AA64DFR0_EL1
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@google.com>
Cc: Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

Since number of context-aware breakpoints must be no more than number
of supported breakpoints according to Arm ARM, return an error if
userspace tries to set CTX_CMPS field to such value.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/id_regs.c | 43 ++++++++++++++++++++++------------------
 1 file changed, 24 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
index 395eaf84a0ab..7ca76a167c90 100644
--- a/arch/arm64/kvm/id_regs.c
+++ b/arch/arm64/kvm/id_regs.c
@@ -355,10 +355,15 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 			       const struct sys_reg_desc *rd,
 			       u64 val)
 {
-	u8 pmuver, host_pmuver;
+	u8 pmuver, host_pmuver, brps, ctx_cmps;
 	bool valid_pmu;
 	int ret;
 
+	brps = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_BRPs), val);
+	ctx_cmps = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_CTX_CMPs), val);
+	if (ctx_cmps > brps)
+		return -EINVAL;
+
 	host_pmuver = kvm_arm_pmu_get_pmuver_limit();
 
 	/*
@@ -377,28 +382,28 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 	if (kvm_vcpu_has_pmu(vcpu) != valid_pmu)
 		return -EINVAL;
 
-	if (valid_pmu) {
-		mutex_lock(&vcpu->kvm->arch.config_lock);
-		ret = set_id_reg(vcpu, rd, val);
-		if (ret) {
-			mutex_unlock(&vcpu->kvm->arch.config_lock);
-			return ret;
-		}
+	if (!valid_pmu) {
+		/* Igore the pmuver field in val */
+		pmuver = FIELD_GET(ID_AA64DFR0_EL1_PMUVer_MASK, read_id_reg(vcpu, rd));
+		val &= ~ID_AA64DFR0_EL1_PMUVer_MASK;
+		val |= FIELD_PREP(ID_AA64DFR0_EL1_PMUVer_MASK, pmuver);
+	}
 
-		IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
-		IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) |=
-			FIELD_PREP(ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon), pmuver_to_perfmon(pmuver));
+	mutex_lock(&vcpu->kvm->arch.config_lock);
+	ret = set_id_reg(vcpu, rd, val);
+	if (ret) {
 		mutex_unlock(&vcpu->kvm->arch.config_lock);
-	} else {
-		/* We can only differ with PMUver, and anything else is an error */
-		val ^= read_id_reg(vcpu, rd);
-		val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
-		if (val)
-			return -EINVAL;
+		return ret;
+	}
 
+	IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
+	IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) |=
+		FIELD_PREP(ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon), pmuver_to_perfmon(pmuver));
+
+	if (!valid_pmu)
 		assign_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags,
 			   pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF);
-	}
+	mutex_unlock(&vcpu->kvm->arch.config_lock);
 
 	return 0;
 }
@@ -610,7 +615,7 @@ static struct id_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] = {
 		.get_user = get_id_reg,
 		.set_user = set_id_aa64dfr0_el1, },
 	  .ftr_bits = ftr_id_aa64dfr0,
-	  .writable_mask = ID_AA64DFR0_EL1_PMUVer_MASK,
+	  .writable_mask = GENMASK(63, 0),
 	  .read_kvm_sanitised_reg = read_sanitised_id_aa64dfr0_el1,
 	},
 	ID_SANITISED(ID_AA64DFR1_EL1),
-- 
2.40.0.348.gf938b09366-goog

