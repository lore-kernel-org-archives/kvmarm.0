Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93198535B4
	for <kvmarm@lists.linux.dev>; Wed, 14 Feb 2024 13:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707916713; cv=none; b=qgSGjx2TStmlsgT6DleZldic2HHsl6QaRQ2PLtqnEpyZVFV7rZZHuswMvzVsNoz4wdBblBTSFtlSW2Q7PAfbTEJoEJcbPbHjtMKtBSKMJc5bw5A8BVPneQJBGNacLUfbZ/gfhC2IobA2hGs24hjdus4/jAYEUOkRyioTmw3Jtq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707916713; c=relaxed/simple;
	bh=5vRlXGNPw+t8CSN/WB8SMPvqzMf0CIBVixpJqhMcQMg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lNZwkEeeKpoG7J9is9AlmW3OiIIz3/ufmAOIlBRUgalZWiXal5aaIvIc38kP3wh3f++oqsWgS35aCCeewK0yJzRXycSy0J2/Q1ruaLhXJcjU/VpmWUD1SG1W7L2Vj9dTg36pXJq+f2hXRf0umnKkdseZaTorE2IFLqKcFhMeizw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C/B5Zhut; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C/B5Zhut"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C9AC433B2;
	Wed, 14 Feb 2024 13:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707916713;
	bh=5vRlXGNPw+t8CSN/WB8SMPvqzMf0CIBVixpJqhMcQMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C/B5ZhutF7s11uS//xvTp9nAHRkk1GjtpRuaj+13flDA4sAxaG4EB0fDLsM/ryDeS
	 FmjMxlBG4y+L1v1K9eLQqSUdy3T7PDerffob6rO8m91bTztkmLizMWaZZlSou8g+vz
	 7HrO2s5wZtEXwmEOV68+zlJP7lsGuEKXswXe6V5PNGE3yCVWXS06gpg0uD602pRZSG
	 Or2c5WKp8sItQ5jbuVRtnXXzMZfcapzdqtXm/IGdPvqSyjRSiiCnG4dRHOxqtbAPXC
	 UsE4s8YJJ+y/GmPlqGjVTJ+pP65QZ2xo/s2/ndrjfZs2oLwbXhuSNF7+Dt/tZ6BlFn
	 lv0jiMZi9I/gg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1raF9j-00394l-5k;
	Wed, 14 Feb 2024 13:18:31 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v4 03/26] KVM: arm64: nv: Add sanitising to VNCR-backed sysregs
Date: Wed, 14 Feb 2024 13:18:04 +0000
Message-Id: <20240214131827.2856277-4-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240214131827.2856277-1-maz@kernel.org>
References: <20240214131827.2856277-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

VNCR-backed "registers" are actually only memory. Which means that
there is zero control over what the guest can write, and that it
is the hypervisor's job to actually sanitise the content of the
backing store. Yeah, this is fun.

In order to preserve some form of sanity, add a repainting mechanism
that makes use of a per-VM set of RES0/RES1 masks, one pair per VNCR
register. These masks get applied on access to the backing store via
__vcpu_sys_reg(), ensuring that the state that is consumed by KVM is
correct.

So far, nothing populates these masks, but stay tuned.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Joey Gouly <joey.gouly@arm.com>
---
 arch/arm64/include/asm/kvm_host.h | 22 ++++++++++++++++-
 arch/arm64/kvm/arm.c              |  1 +
 arch/arm64/kvm/nested.c           | 41 ++++++++++++++++++++++++++++++-
 3 files changed, 62 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 527da3d2cedb..8cda003d6267 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -238,6 +238,8 @@ static inline u16 kvm_mpidr_index(struct kvm_mpidr_data *data, u64 mpidr)
 	return index;
 }
 
+struct kvm_sysreg_masks;
+
 struct kvm_arch {
 	struct kvm_s2_mmu mmu;
 
@@ -312,6 +314,9 @@ struct kvm_arch {
 #define KVM_ARM_ID_REG_NUM	(IDREG_IDX(sys_reg(3, 0, 0, 7, 7)) + 1)
 	u64 id_regs[KVM_ARM_ID_REG_NUM];
 
+	/* Masks for VNCR-baked sysregs */
+	struct kvm_sysreg_masks	*sysreg_masks;
+
 	/*
 	 * For an untrusted host VM, 'pkvm.handle' is used to lookup
 	 * the associated pKVM instance in the hypervisor.
@@ -474,6 +479,13 @@ enum vcpu_sysreg {
 	NR_SYS_REGS	/* Nothing after this line! */
 };
 
+struct kvm_sysreg_masks {
+	struct {
+		u64	res0;
+		u64	res1;
+	} mask[NR_SYS_REGS - __VNCR_START__];
+};
+
 struct kvm_cpu_context {
 	struct user_pt_regs regs;	/* sp = sp_el0 */
 
@@ -868,7 +880,15 @@ static inline u64 *__ctxt_sys_reg(const struct kvm_cpu_context *ctxt, int r)
 
 #define ctxt_sys_reg(c,r)	(*__ctxt_sys_reg(c,r))
 
-#define __vcpu_sys_reg(v,r)	(ctxt_sys_reg(&(v)->arch.ctxt, (r)))
+u64 kvm_vcpu_sanitise_vncr_reg(const struct kvm_vcpu *, enum vcpu_sysreg);
+#define __vcpu_sys_reg(v,r)						\
+	(*({								\
+		const struct kvm_cpu_context *ctxt = &(v)->arch.ctxt;	\
+		u64 *__r = __ctxt_sys_reg(ctxt, (r));			\
+		if (vcpu_has_nv((v)) && (r) >= __VNCR_START__)		\
+			*__r = kvm_vcpu_sanitise_vncr_reg((v), (r));	\
+		__r;							\
+	}))
 
 u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg);
 void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a25265aca432..c063e84fc72c 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -206,6 +206,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 		pkvm_destroy_hyp_vm(kvm);
 
 	kfree(kvm->arch.mpidr_data);
+	kfree(kvm->arch.sysreg_masks);
 	kvm_destroy_vcpus(kvm);
 
 	kvm_unshare_hyp(kvm, kvm + 1);
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index d55e809e26cb..c976cd4b8379 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -163,15 +163,54 @@ static u64 limit_nv_id_reg(u32 id, u64 val)
 
 	return val;
 }
+
+u64 kvm_vcpu_sanitise_vncr_reg(const struct kvm_vcpu *vcpu, enum vcpu_sysreg sr)
+{
+	u64 v = ctxt_sys_reg(&vcpu->arch.ctxt, sr);
+	struct kvm_sysreg_masks *masks;
+
+	masks = vcpu->kvm->arch.sysreg_masks;
+
+	if (masks) {
+		sr -= __VNCR_START__;
+
+		v &= ~masks->mask[sr].res0;
+		v |= masks->mask[sr].res1;
+	}
+
+	return v;
+}
+
+static void __maybe_unused set_sysreg_masks(struct kvm *kvm, int sr, u64 res0, u64 res1)
+{
+	int i = sr - __VNCR_START__;
+
+	kvm->arch.sysreg_masks->mask[i].res0 = res0;
+	kvm->arch.sysreg_masks->mask[i].res1 = res1;
+}
+
 int kvm_init_nv_sysregs(struct kvm *kvm)
 {
+	int ret = 0;
+
 	mutex_lock(&kvm->arch.config_lock);
 
+	if (kvm->arch.sysreg_masks)
+		goto out;
+
+	kvm->arch.sysreg_masks = kzalloc(sizeof(*(kvm->arch.sysreg_masks)),
+					 GFP_KERNEL);
+	if (!kvm->arch.sysreg_masks) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
 	for (int i = 0; i < KVM_ARM_ID_REG_NUM; i++)
 		kvm->arch.id_regs[i] = limit_nv_id_reg(IDX_IDREG(i),
 						       kvm->arch.id_regs[i]);
 
+out:
 	mutex_unlock(&kvm->arch.config_lock);
 
-	return 0;
+	return ret;
 }
-- 
2.39.2

