Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C5A45F68
	for <kvmarm@lists.linux.dev>; Mon,  9 Oct 2023 23:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YvRJTD8o"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d9a509861acso349325276.2
        for <kvmarm@lists.linux.dev>; Mon, 09 Oct 2023 16:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696892952; x=1697497752; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WVPLom817QijAmu2ToM6KNwT4YXyplIKJbzjUf63Skc=;
        b=YvRJTD8onFkx9pBLUX7wwJTBxYQeSVIY0ZRWhBMIj8WwRVnybplZJl7vHp7H8As2wh
         y1krNguy6EC5V+SJoPdpqieC+ZOB9MF7zebu/AJDH1enkMTvRQ3Dnp98WU8Y6hCaltj7
         6n/RgDRE9cFqrqMGT3KBOvj68EZdoi76E/voZm1jDtlENZgE8RzAKOIPvcxMUrWwLZS8
         vdiP4RRqsdVnwVfTv/0VfuYTLa16ehiMH3AF/T2nOMcKx1CJYa7WbyV5ep7CdSPvUQkt
         qWdUoTNd2PQJZYd3qrmI5EzdjCKbXfHaIXbsMQTkNj1Q8zhpsVLR/E+mVt+ZXfzDf+Ha
         QeyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696892952; x=1697497752;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WVPLom817QijAmu2ToM6KNwT4YXyplIKJbzjUf63Skc=;
        b=MuHwJZWDP0fNW2eXrHIsRNWNcFt95N2qyRagSmPbc3sxj3EcIPFKEkIQ8cCObHvEJe
         QApWHCzO05GhycjpDxRSWuPiSONnoOTl1dXyjeDLgcsIAq8unHTeObsotjfzYJjwWiBe
         B7lCXiwd5bIJNKdPu5Gc47T62nj9oS2X8KvzY7G2Q8/Fdane1wx0AS5VGHeC0qwQGxwX
         aMluxnubO9Jxa3DBZrpGp8PDK7rs8mzL9vPNs4+P23UUFOt4idMvvUjn0wDWpUMczSBY
         BxiGPHxxnmOqklTM3PEmbx6E9gPpmr0HrW/inLnqN4YZ30SgTex0wwyAuz3Af/OUBUZX
         HT1A==
X-Gm-Message-State: AOJu0YwkuPGQ5x3kWa4lVWb/chEPOZ4PPct8A+lqfxPt77WePBJ9Pb9r
	ypGFekZFl3OdNnLcEM2xwhpU5F+taNUM
X-Google-Smtp-Source: AGHT+IFyNG907oCnWxlCAmcf3y3TzafJxvxtebFLo6APkYcTiodd1Eri22KDLIo7rsKWPkhluSmUKsZppbb+
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:20a1])
 (user=rananta job=sendgmr) by 2002:a25:5057:0:b0:d9a:5e8f:1562 with SMTP id
 e84-20020a255057000000b00d9a5e8f1562mr1171ybb.6.1696892951907; Mon, 09 Oct
 2023 16:09:11 -0700 (PDT)
Date: Mon,  9 Oct 2023 23:08:54 +0000
In-Reply-To: <20231009230858.3444834-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231009230858.3444834-1-rananta@google.com>
X-Mailer: git-send-email 2.42.0.609.gbb76f46606-goog
Message-ID: <20231009230858.3444834-9-rananta@google.com>
Subject: [PATCH v7 08/12] KVM: arm64: PMU: Allow userspace to limit PMCR_EL0.N
 for the guest
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

KVM does not yet support userspace modifying PMCR_EL0.N (With
the previous patch, KVM ignores what is written by userspace).
Add support userspace limiting PMCR_EL0.N.

Disallow userspace to set PMCR_EL0.N to a value that is greater
than the host value as KVM doesn't support more event counters
than what the host HW implements. Also, make this register
immutable after the VM has started running. To maintain the
existing expectations, instead of returning an error, KVM
returns a success for these two cases.

Finally, ignore writes to read-only bits that are cleared on
vCPU reset, and RES{0,1} bits (including writable bits that
KVM doesn't support yet), as those bits shouldn't be modified
(at least with the current KVM).

Signed-off-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/kvm/sys_regs.c | 57 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 55 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c750722fbe4a..0c8d337b0370 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1087,6 +1087,59 @@ static int get_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 	return 0;
 }
 
+static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
+		    u64 val)
+{
+	struct kvm *kvm = vcpu->kvm;
+	u64 new_n, mutable_mask;
+
+	mutex_lock(&kvm->arch.config_lock);
+
+	/*
+	 * Make PMCR immutable once the VM has started running, but do
+	 * not return an error (-EBUSY) to meet the existing expectations.
+	 */
+	if (kvm_vm_has_ran_once(vcpu->kvm)) {
+		mutex_unlock(&kvm->arch.config_lock);
+		return 0;
+	}
+
+	new_n = (val >> ARMV8_PMU_PMCR_N_SHIFT) & ARMV8_PMU_PMCR_N_MASK;
+	if (new_n != kvm->arch.pmcr_n) {
+		u8 pmcr_n_limit = kvm_arm_get_num_counters(kvm);
+
+		/*
+		 * The vCPU can't have more counters than the PMU hardware
+		 * implements. Ignore this error to maintain compatibility
+		 * with the existing KVM behavior.
+		 */
+		if (new_n <= pmcr_n_limit)
+			kvm->arch.pmcr_n = new_n;
+	}
+	mutex_unlock(&kvm->arch.config_lock);
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
+	return 0;
+}
+
 /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
 #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
 	{ SYS_DESC(SYS_DBGBVRn_EL1(n)),					\
@@ -2150,8 +2203,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_CTR_EL0), access_ctr },
 	{ SYS_DESC(SYS_SVCR), undef_access },
 
-	{ PMU_SYS_REG(PMCR_EL0), .access = access_pmcr,
-	  .reset = reset_pmcr, .reg = PMCR_EL0, .get_user = get_pmcr },
+	{ PMU_SYS_REG(PMCR_EL0), .access = access_pmcr, .reset = reset_pmcr,
+	  .reg = PMCR_EL0, .get_user = get_pmcr, .set_user = set_pmcr },
 	{ PMU_SYS_REG(PMCNTENSET_EL0),
 	  .access = access_pmcnten, .reg = PMCNTENSET_EL0 },
 	{ PMU_SYS_REG(PMCNTENCLR_EL0),
-- 
2.42.0.609.gbb76f46606-goog

