Received: from mail-ot1-f73.google.com (mail-ot1-f73.google.com [209.85.210.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D811F2FE0E
	for <kvmarm@lists.linux.dev>; Fri, 20 Oct 2023 21:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V+UHnRas"
Received: by mail-ot1-f73.google.com with SMTP id 46e09a7af769-6ce2b33816eso1853005a34.3
        for <kvmarm@lists.linux.dev>; Fri, 20 Oct 2023 14:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697838062; x=1698442862; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hSrXoi5TDQ0wnG/0Nd2sUM6CDNcuaYRq6rz2yKTajHM=;
        b=V+UHnRasEdTxDrm7pDv3/94RPyzg1VqvujOsz8B2ja1b7HnPT0duHiAOsrMNvsXfSy
         bF11bVzgAd957B1msxxDr4PT525mYBDXD19XlaQ2XIo4BT+ytrrLjB5YgnA97XtCHY7m
         SpkalK4cqQ9lGkaXZ6qdcR2n+2ajyG7pMEIkOFFdv+BbmBGDHr5XaSlybC5sgwwGPzaK
         /LNFydfN3avXbAaEDVxSk97DpO66Y1T3DX9QuF6jzGqnECh8I8xMxAbFQtEK3AVcQ5g+
         cjihYcSVYqwwdHCD0qkNMfIZCZG3xZ7zrhIEaH7XH1av3VEYoRZbYm9y663k8NKlHRx7
         Xsqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697838062; x=1698442862;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hSrXoi5TDQ0wnG/0Nd2sUM6CDNcuaYRq6rz2yKTajHM=;
        b=c4QqDuj1Pgp9GfK2lyeYlyo9FxsrpGTWHks1i3ECZRwdAcJNTjPWV02NbeRavK71iz
         TO3Vtv5OIE65PhmTkck6lfzvEGnyxNyXOrJOyQ1/YJvTpfRoVqnO7su2+kJ5ftmcyNYs
         y8715ASPc6XmSpYxuuZU+GHlGpQfDOt4SBvv2UCBrhzhVIgeveXzxHH58uuNGHcD+gRA
         ASRjrgnO3BQ7guqkR1NcjDqLGzTArP6t3NThxxddMtPDBPEKi+Z8FQgBiZzOD6jdeZX4
         zhRVQA0N3EoKFISCQGF1WV6bDMwi26HqZ9JZoc3NA2jN6DCGJsfRPSFSHUyGC/STqLCb
         XTgg==
X-Gm-Message-State: AOJu0YywG3desNiogb706dV1yiH0lXBCTMXalRZZ7a1ZX2URME83p5We
	wzKEMILikZmBL2Bm02R1EedCs4lZwIDP
X-Google-Smtp-Source: AGHT+IFJqyHvsAhBFGWa8RbM0GaRa8vnaP3vXD/CJFEq612x9pQyV0ppNsns19cnmmWbeODxydr05GC904O7
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:20a1])
 (user=rananta job=sendgmr) by 2002:a9d:7f90:0:b0:6c4:a036:cc11 with SMTP id
 t16-20020a9d7f90000000b006c4a036cc11mr838958otp.2.1697838061951; Fri, 20 Oct
 2023 14:41:01 -0700 (PDT)
Date: Fri, 20 Oct 2023 21:40:45 +0000
In-Reply-To: <20231020214053.2144305-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231020214053.2144305-1-rananta@google.com>
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
Message-ID: <20231020214053.2144305-6-rananta@google.com>
Subject: [PATCH v8 05/13] KVM: arm64: Add {get,set}_user for
 PM{C,I}NTEN{SET,CLR}, PMOVS{SET,CLR}
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

For unimplemented counters, the bits in PM{C,I}NTEN{SET,CLR} and
PMOVS{SET,CLR} registers are expected to RAZ. To honor this,
explicitly implement the {get,set}_user functions for these
registers to mask out unimplemented counters for userspace reads
and writes.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/kvm/sys_regs.c | 91 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 85 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index faf97878dfbbb..2e5d497596ef8 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -987,6 +987,45 @@ static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return true;
 }
 
+static void set_pmreg_for_valid_counters(struct kvm_vcpu *vcpu,
+					  u64 reg, u64 val, bool set)
+{
+	struct kvm *kvm = vcpu->kvm;
+
+	mutex_lock(&kvm->arch.config_lock);
+
+	/* Make the register immutable once the VM has started running */
+	if (kvm_vm_has_ran_once(kvm)) {
+		mutex_unlock(&kvm->arch.config_lock);
+		return;
+	}
+
+	val &= kvm_pmu_valid_counter_mask(vcpu);
+	mutex_unlock(&kvm->arch.config_lock);
+
+	if (set)
+		__vcpu_sys_reg(vcpu, reg) |= val;
+	else
+		__vcpu_sys_reg(vcpu, reg) &= ~val;
+}
+
+static int get_pmcnten(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
+			u64 *val)
+{
+	u64 mask = kvm_pmu_valid_counter_mask(vcpu);
+
+	*val = __vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & mask;
+	return 0;
+}
+
+static int set_pmcnten(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
+			u64 val)
+{
+	/* r->Op2 & 0x1: true for PMCNTENSET_EL0, else PMCNTENCLR_EL0 */
+	set_pmreg_for_valid_counters(vcpu, PMCNTENSET_EL0, val, r->Op2 & 0x1);
+	return 0;
+}
+
 static bool access_pmcnten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			   const struct sys_reg_desc *r)
 {
@@ -1015,6 +1054,23 @@ static bool access_pmcnten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return true;
 }
 
+static int get_pminten(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
+			u64 *val)
+{
+	u64 mask = kvm_pmu_valid_counter_mask(vcpu);
+
+	*val = __vcpu_sys_reg(vcpu, PMINTENSET_EL1) & mask;
+	return 0;
+}
+
+static int set_pminten(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
+			u64 val)
+{
+	/* r->Op2 & 0x1: true for PMINTENSET_EL1, else PMINTENCLR_EL1 */
+	set_pmreg_for_valid_counters(vcpu, PMINTENSET_EL1, val, r->Op2 & 0x1);
+	return 0;
+}
+
 static bool access_pminten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			   const struct sys_reg_desc *r)
 {
@@ -1039,6 +1095,23 @@ static bool access_pminten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return true;
 }
 
+static int set_pmovs(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
+		      u64 val)
+{
+	/* r->CRm & 0x2: true for PMOVSSET_EL0, else PMOVSCLR_EL0 */
+	set_pmreg_for_valid_counters(vcpu, PMOVSSET_EL0, val, r->CRm & 0x2);
+	return 0;
+}
+
+static int get_pmovs(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
+		      u64 *val)
+{
+	u64 mask = kvm_pmu_valid_counter_mask(vcpu);
+
+	*val = __vcpu_sys_reg(vcpu, PMOVSSET_EL0) & mask;
+	return 0;
+}
+
 static bool access_pmovs(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			 const struct sys_reg_desc *r)
 {
@@ -2184,9 +2257,11 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	/* PMBIDR_EL1 is not trapped */
 
 	{ PMU_SYS_REG(PMINTENSET_EL1),
-	  .access = access_pminten, .reg = PMINTENSET_EL1 },
+	  .access = access_pminten, .reg = PMINTENSET_EL1,
+	  .get_user = get_pminten, .set_user = set_pminten },
 	{ PMU_SYS_REG(PMINTENCLR_EL1),
-	  .access = access_pminten, .reg = PMINTENSET_EL1 },
+	  .access = access_pminten, .reg = PMINTENSET_EL1,
+	  .get_user = get_pminten, .set_user = set_pminten },
 	{ SYS_DESC(SYS_PMMIR_EL1), trap_raz_wi },
 
 	{ SYS_DESC(SYS_MAIR_EL1), access_vm_reg, reset_unknown, MAIR_EL1 },
@@ -2237,11 +2312,14 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ PMU_SYS_REG(PMCR_EL0), .access = access_pmcr,
 	  .reset = reset_pmcr, .reg = PMCR_EL0, .get_user = get_pmcr },
 	{ PMU_SYS_REG(PMCNTENSET_EL0),
-	  .access = access_pmcnten, .reg = PMCNTENSET_EL0 },
+	  .access = access_pmcnten, .reg = PMCNTENSET_EL0,
+	  .get_user = get_pmcnten, .set_user = set_pmcnten },
 	{ PMU_SYS_REG(PMCNTENCLR_EL0),
-	  .access = access_pmcnten, .reg = PMCNTENSET_EL0 },
+	  .access = access_pmcnten, .reg = PMCNTENSET_EL0,
+	  .get_user = get_pmcnten, .set_user = set_pmcnten },
 	{ PMU_SYS_REG(PMOVSCLR_EL0),
-	  .access = access_pmovs, .reg = PMOVSSET_EL0 },
+	  .access = access_pmovs, .reg = PMOVSSET_EL0,
+	  .get_user = get_pmovs, .set_user = set_pmovs },
 	/*
 	 * PM_SWINC_EL0 is exposed to userspace as RAZ/WI, as it was
 	 * previously (and pointlessly) advertised in the past...
@@ -2269,7 +2347,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ PMU_SYS_REG(PMUSERENR_EL0), .access = access_pmuserenr,
 	  .reset = reset_val, .reg = PMUSERENR_EL0, .val = 0 },
 	{ PMU_SYS_REG(PMOVSSET_EL0),
-	  .access = access_pmovs, .reg = PMOVSSET_EL0 },
+	  .access = access_pmovs, .reg = PMOVSSET_EL0,
+	  .get_user = get_pmovs, .set_user = set_pmovs },
 
 	{ SYS_DESC(SYS_TPIDR_EL0), NULL, reset_unknown, TPIDR_EL0 },
 	{ SYS_DESC(SYS_TPIDRRO_EL0), NULL, reset_unknown, TPIDRRO_EL0 },
-- 
2.42.0.655.g421f12c284-goog

