Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 010701A5A8
	for <kvmarm@lists.linux.dev>; Fri, 20 Oct 2023 21:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nkUjl56Q"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5a839b31a0dso23806477b3.0
        for <kvmarm@lists.linux.dev>; Fri, 20 Oct 2023 14:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697838064; x=1698442864; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eWANe28YHA3Ik3VAhdhi3PR1V7Sp1rEPcSjU6me6VYQ=;
        b=nkUjl56QGD+a1kE8Maz6yL+aQMCB5DHW9aZZApRUhk7btMkrnpH/+cUl0QHpAnj0bA
         UqoA85CsM8+l/lmeFO1s5jyck+9StXqbiYICkMcfL0lHTFpJmuhb54tqEnd6YV3uomX/
         McPZtAM8lOc1UID4i34RaFEjIy/3jLlSY1XdGFwZcgYE63VJSqvBuUSMQ60wgwVFHk6L
         es1eLNENtBZIbdlvnJgdXZcALDRxZcYpR6uA1jb2SjvGbM14VkTESNy8TXNteXcm2Cj+
         UAUqejPQsnp9ppvL0MCY26E64iCQ/IzpGGzwJMKjzJ4Q6MpoxP8Na1MzkzNyPFnCL12z
         I9Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697838064; x=1698442864;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eWANe28YHA3Ik3VAhdhi3PR1V7Sp1rEPcSjU6me6VYQ=;
        b=vcPhtMkG7bt0cyeELIOb8/VfAIGEcpjdavALS7OWYcEaiQZlK5d4NvhX8IgFFWGWIP
         Mc2lHaQOxI4GmQVTDvaditwdGYOGYbPo0o+dAIV25VDqotkZTd0PplAN5cCshYQn4oz0
         njn5r/86Dyq3OsVi7iAAyyYwepkBTj1oZsQaHyiOkEkE9BrXZKibGzxsETuBkVMzUo5T
         ADpv0WjJIgvv7YeQNOkWdakurTL1Na97c0G2lu+/wv4TUwxWdBMcakpjN4Xcc++fPtlx
         5q9PBl0r4Cvnlg9bH0h7jQ1AXK6RvgpVE9XCmM1HU7X2mQxTytT2kdF0Q1VPGd7+YXuH
         gqZA==
X-Gm-Message-State: AOJu0YzZ2i0oNJ+YdPZ0BON+3ed76BWc3zM4xwU2EScz3y4BW/KHH6Mx
	AUpBEbvi0YrRK0tfMgehbAt6Fn32Q1JD
X-Google-Smtp-Source: AGHT+IGdgdjVHKqx6Bu9LPm2rggnnmwoBhDoh8QKCazmacm9yfZUPsDbAbEK8fK3ImY6VtPJpzzcreKswMJJ
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:20a1])
 (user=rananta job=sendgmr) by 2002:a05:6902:1083:b0:d9a:c946:c18c with SMTP
 id v3-20020a056902108300b00d9ac946c18cmr92087ybu.6.1697838063913; Fri, 20 Oct
 2023 14:41:03 -0700 (PDT)
Date: Fri, 20 Oct 2023 21:40:47 +0000
In-Reply-To: <20231020214053.2144305-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231020214053.2144305-1-rananta@google.com>
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
Message-ID: <20231020214053.2144305-8-rananta@google.com>
Subject: [PATCH v8 07/13] KVM: arm64: PMU: Allow userspace to limit PMCR_EL0.N
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
index 2e5d497596ef8..a2c5f210b3d6b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1176,6 +1176,59 @@ static int get_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
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
+	 * Make PMCR immutable once the VM has started running, but
+	 * do not return an error to meet the existing expectations.
+	 */
+	if (kvm_vm_has_ran_once(vcpu->kvm)) {
+		mutex_unlock(&kvm->arch.config_lock);
+		return 0;
+	}
+
+	new_n = (val >> ARMV8_PMU_PMCR_N_SHIFT) & ARMV8_PMU_PMCR_N_MASK;
+	if (new_n != kvm->arch.pmcr_n) {
+		u8 pmcr_n_limit = kvm_arm_pmu_get_max_counters(kvm);
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
@@ -2309,8 +2362,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_CTR_EL0), access_ctr },
 	{ SYS_DESC(SYS_SVCR), undef_access },
 
-	{ PMU_SYS_REG(PMCR_EL0), .access = access_pmcr,
-	  .reset = reset_pmcr, .reg = PMCR_EL0, .get_user = get_pmcr },
+	{ PMU_SYS_REG(PMCR_EL0), .access = access_pmcr, .reset = reset_pmcr,
+	  .reg = PMCR_EL0, .get_user = get_pmcr, .set_user = set_pmcr },
 	{ PMU_SYS_REG(PMCNTENSET_EL0),
 	  .access = access_pmcnten, .reg = PMCNTENSET_EL0,
 	  .get_user = get_pmcnten, .set_user = set_pmcnten },
-- 
2.42.0.655.g421f12c284-goog

