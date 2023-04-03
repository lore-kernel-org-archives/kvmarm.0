Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0121366
	for <kvmarm@lists.linux.dev>; Mon,  3 Apr 2023 00:37:30 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-545ef25cfb7so211885577b3.2
        for <kvmarm@lists.linux.dev>; Sun, 02 Apr 2023 17:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680482249;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0DpiYHNHtrOBdSzxOB0HhqYUe3wXm51WnVubK0bjlBk=;
        b=GtTKA0ObjbHcJ3EjXiXnMdv+2ZaEbqCaQyY6Y2xmUW3oIzLw8aDaP6wUbPYp2AT5wL
         8Z/Zctn+lxDa1DR+ePaq1tLF8re2Pytt0u+HA1gwaoRad+Jm/391vzYqG22OsIjzpxTh
         ntz0XRxDNS1S5DRgPwb36ewWn6jBfIGYctNaxyzh+ItzwzqEffquN2XqJoCUNQukMOmi
         fnpN9LSPjcexhRDqamgGDXz4X+AYtVn33gB49GvptmZuzh+jLpg8c+L1xVezZ+2wUHZ8
         YO89kKmSfS/Ttre5kh61VwQyzTlSJt8/Z8EaWInlc0KFDPQbYkr8+6WwbpH5f+HvSzx7
         YQhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680482249;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0DpiYHNHtrOBdSzxOB0HhqYUe3wXm51WnVubK0bjlBk=;
        b=Cn6ZTQM00Y3onQFe3xx4aohjAx9SCRNqKEnSRGbBXt2UY8uG/g+nDA44ha8NLTIDmp
         cein9IRscNVTejXsnf6Ri8u7ZJ1gkY/2BptT395Nt/cgzeYKCZrCsxV9str0GYt0muTw
         iHqs82pnCavAU4qq0HJpgDGKe4JUjNrPLR9/mNeCHH4p9nZC64w0g22BS1wT0Y7eg1Se
         4mB8rltOjDuf98u6lQQY+IQgpgGONmF+e5K45JFRmsFtHgS5tSf4AWrgEwPRjjFDU8kE
         TUmqrDSYAX49OpG5LAgZRnXkCr12Yt3MyQXMCbKYt6nLqgKKPyJOPNQ0QgpsTouJYsNo
         kc5A==
X-Gm-Message-State: AAQBX9dvNpp14FTZy0zjtQnzZK93llyK+U9ohrJOD0Lv99oDcw7qCLTg
	Gu1V71A9SVdIDdAbs9hU4VEXnGODZkgQkOH9tA==
X-Google-Smtp-Source: AKy350av+d6VbgmFzuOft067V0HLrX54LmHyG0tsHYmBgkFAW7aECB/LZb1/44Vo5tN6sgirn8HdCBXK/wU5j8gvWQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a05:6902:110b:b0:b7d:4c96:de0 with
 SMTP id o11-20020a056902110b00b00b7d4c960de0mr10519688ybu.5.1680482249727;
 Sun, 02 Apr 2023 17:37:29 -0700 (PDT)
Date: Mon,  3 Apr 2023 00:37:23 +0000
In-Reply-To: <20230403003723.3199828-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230403003723.3199828-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230403003723.3199828-3-jingzhangos@google.com>
Subject: [PATCH v2 2/2] KVM: arm64: Enable writable for ID_DFR0_EL1
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

All valid fields in ID_DFR0_EL1 are writable from usrespace with this
change.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/id_regs.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
index 7ca76a167c90..17f134d343e3 100644
--- a/arch/arm64/kvm/id_regs.c
+++ b/arch/arm64/kvm/id_regs.c
@@ -451,28 +451,28 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
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
+		/* Ignore the PerfMon field in val */
+		perfmon = FIELD_GET(ID_DFR0_EL1_PerfMon_MASK, read_id_reg(vcpu, rd));
+		val &= ~ID_DFR0_EL1_PerfMon_MASK;
+		val |= FIELD_PREP(ID_DFR0_EL1_PerfMon_MASK, perfmon);
+	}
 
-		IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
-		IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |=
-			FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), perfmon_to_pmuver(perfmon));
+	mutex_lock(&vcpu->kvm->arch.config_lock);
+	ret = set_id_reg(vcpu, rd, val);
+	if (ret) {
 		mutex_unlock(&vcpu->kvm->arch.config_lock);
-	} else {
-		/* We can only differ with PerfMon, and anything else is an error */
-		val ^= read_id_reg(vcpu, rd);
-		val &= ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
-		if (val)
-			return -EINVAL;
+		return ret;
+	}
 
+	IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
+	IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |=
+		FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), perfmon_to_pmuver(perfmon));
+
+	if (!valid_pmu)
 		assign_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags,
 			   perfmon == ID_DFR0_EL1_PerfMon_IMPDEF);
-	}
+	mutex_unlock(&vcpu->kvm->arch.config_lock);
 
 	return 0;
 }
@@ -560,7 +560,7 @@ static struct id_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] = {
 		.set_user = set_id_dfr0_el1,
 		.visibility = aa32_id_visibility, },
 	  .ftr_bits = ftr_id_dfr0,
-	  .writable_mask = ID_DFR0_EL1_PerfMon_MASK,
+	  .writable_mask = GENMASK(63, 0),
 	  .read_kvm_sanitised_reg = read_sanitised_id_dfr0_el1,
 	},
 	ID_HIDDEN(ID_AFR0_EL1),
-- 
2.40.0.348.gf938b09366-goog

