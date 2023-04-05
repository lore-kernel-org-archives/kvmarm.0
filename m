Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F18747F
	for <kvmarm@lists.linux.dev>; Wed,  5 Apr 2023 17:21:54 +0000 (UTC)
Received: by mail-pg1-f201.google.com with SMTP id q196-20020a632acd000000b005140cc9e00aso2548169pgq.22
        for <kvmarm@lists.linux.dev>; Wed, 05 Apr 2023 10:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680715314;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WWvgVvokzVtW6s2OIVOS99I+rqD3+bkRk2aW50YpeN0=;
        b=j/1V6fLcO5MCU6O7YAV/G5BlxlaAe4AN9W0ZvXEQpkr9vFRBJV2drsrnFfWVlDRtvY
         dkl3sATeqjmQ9T3CdsdYi4tC5m3glGlDvyjVdxf6NlSAnoTq9HDZqucOcmpjwNBrPrKq
         Hni8XWq5z7o0srp+ior7Uoa3lLdp8FsICD87EDrhfhfHt5gT6Ri7et7A39iLTUeiMdlX
         7FzVly2/H0UfIRasyH4vXNMHFdBZB/c1fjLpdHGPwV4PSsRuzwsNe21Vot5wD8WRqhKh
         UqruFFdXrZf3LyAlHmBCXGs1tRN/rH6JHQ3AcEUcUzTQCCm4Yf5Ck/sTWWrjvpBqcSqM
         9yRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680715314;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WWvgVvokzVtW6s2OIVOS99I+rqD3+bkRk2aW50YpeN0=;
        b=X878062BuaBhXwre9RA0LUI2w7ACryA0HQpAoo/XsMKyp1N97NOUf27CeskQHOxiub
         6RHw2xx7SiJx9uQ6jQRoKV+rRg2xtsBYyjm8Yk3KjWuture7wlSmsJGg2vQM8JDT0RLF
         3+1EA+mkeOSkwKnL13m8JEHAAr01vqHbgypqnLJTe8y4LshAqfZ71YAfUaZyYlEhVNe7
         WduJbXurGA50olU5HuQvT/PRiiZ1v1DRybM9qaTDpCOR6Bzte6cD7Y/t4b9wGbPiJ57/
         7vK3Ei/lR9ZFTGZgkW+dbt1xmm9pwIFjvqciAxKCGKJilTKkVJoh/DYD61Dx5U/HkGXL
         jiCA==
X-Gm-Message-State: AAQBX9cY0NABhhDWxE8ZNEW55O1BRXYQCL6T4Qr1w832qsrunLSS3UEb
	zxjnLLta2twrHRnsDl+EoneeE0P4mo9P0bkDNg==
X-Google-Smtp-Source: AKy350Y4PEb/T97cu7UgpksR6evhMIjDmRGpJvHiT01ZPsICbmPY3Pzd2/iDx/BakPDf8DwDhhYRmUHV5XMrX4leGQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:902:b284:b0:19f:a694:6d3f with
 SMTP id u4-20020a170902b28400b0019fa6946d3fmr2853316plr.6.1680715314255; Wed,
 05 Apr 2023 10:21:54 -0700 (PDT)
Date: Wed,  5 Apr 2023 17:21:45 +0000
In-Reply-To: <20230405172146.297208-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230405172146.297208-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230405172146.297208-4-jingzhangos@google.com>
Subject: [PATCH v3 3/4] KVM: arm64: Enable writable for ID_AA64PFR0_EL1
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

Return an error if userspace tries to set SVE field of the register
to a value that conflicts with SVE configuration for the guest.
SIMD/FP/SVE fields of the requested value are validated according to
Arm ARM.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/id_regs.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
index 11d3a1d46ee5..20d1a2d2a0cc 100644
--- a/arch/arm64/kvm/id_regs.c
+++ b/arch/arm64/kvm/id_regs.c
@@ -283,6 +283,9 @@ static u64 read_sanitised_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 
 	val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU);
 
+	if (!system_supports_sve())
+		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_SVE);
+
 	return val;
 }
 
@@ -291,6 +294,22 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 			       u64 val)
 {
 	u8 csv2, csv3;
+	int fp, simd;
+	bool has_sve = id_aa64pfr0_sve(val);
+
+	simd = cpuid_feature_extract_signed_field(val, ID_AA64PFR0_EL1_AdvSIMD_SHIFT);
+	fp = cpuid_feature_extract_signed_field(val, ID_AA64PFR0_EL1_FP_SHIFT);
+	/* AdvSIMD field must have the same value as FP field */
+	if (simd != fp)
+		return -EINVAL;
+
+	/* fp must be supported when sve is supported */
+	if (has_sve && (fp < 0))
+		return -EINVAL;
+
+	/* Check if there is a conflict with a request via KVM_ARM_VCPU_INIT */
+	if (vcpu_has_sve(vcpu) ^ has_sve)
+		return -EPERM;
 
 	/*
 	 * Allow AA64PFR0_EL1.CSV2 to be set from userspace as long as
@@ -582,7 +601,7 @@ const struct sys_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] = {
 	  .get_user = get_id_reg,
 	  .set_user = set_id_aa64pfr0_el1,
 	  .reset = read_sanitised_id_aa64pfr0_el1,
-	  .val = ID_AA64PFR0_EL1_CSV2_MASK | ID_AA64PFR0_EL1_CSV3_MASK, },
+	  .val = GENMASK(63, 0), },
 	ID_SANITISED(ID_AA64PFR1_EL1),
 	ID_UNALLOCATED(4, 2),
 	ID_UNALLOCATED(4, 3),
-- 
2.40.0.348.gf938b09366-goog

