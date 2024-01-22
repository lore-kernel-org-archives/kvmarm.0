Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9942D40BF4
	for <kvmarm@lists.linux.dev>; Mon, 22 Jan 2024 20:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705954738; cv=none; b=G4/hkOtBTZl3TFJPQpsPR6T78SCCR8hiZEJIaYvqTYB+JBLaN3h9v89Fp237yCN3ewLUhLW8+mOQZSHqaIoIhCfJ1qYcbbd25gMz7yf+sp7JrBK0slX684HEoGM6oTvhjcRcNlMuhn3OmIMI+++Aa6klyxJlLhsKY5a6bmSYJiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705954738; c=relaxed/simple;
	bh=UqZNEo6dLwf1SIggdLE9poxM0A+9+A5BII/W5/qA7tE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=s8KnuGAL39KGxOT4i/UwmlVECUeOKG6W1elNRB5FUFSUB3SZ2Hrs9sTtrtS80t+5+TV/XCcJ6J/fViaIbo3Q8E4NMd1ST0yTldKYNOTIGnMbds5+wnDbTM/EfOloo6Qy2aQNpgwxIbDXoQcfVINCpApSRltK1JRMrPsjV4o4o/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h1DgQrTS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h1DgQrTS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E68C43143;
	Mon, 22 Jan 2024 20:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705954738;
	bh=UqZNEo6dLwf1SIggdLE9poxM0A+9+A5BII/W5/qA7tE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h1DgQrTSPFa/Z9phXhtQc4mcgG4Y7VWK5Z5ZJgSr5N/sPwcklSR80hisqa19vBrBc
	 EK+7mfi+EvS4UAQow4fkw5FhZjiHiiff+E4mQb/KNsH6yzn2dCrgq6lnax63dba+Pz
	 DvCFxvlT5P6rxTWxBEY20qDlVMGKzKjoWw/uVjctBkxXEWBI16S1zCk+rc/ywUuUKv
	 5qZGq8UxIaqfaUI0v9EqxCP8dtRhj0tCN11IctWsIED5dJa1QU2qrhsz+QaoZ0sapw
	 ZUt5UNpDWoVpUbbZO9WUkwl26kZOHIn3eQ/fDb81q0n823bYO/4E/SNurebriILoKI
	 9t1uuRJ9AI9RA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rS0ky-00DjkQ-56;
	Mon, 22 Jan 2024 20:18:56 +0000
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
Subject: [PATCH 03/25] KVM: arm64: nv: Add sanitising to VNCR-backed sysregs
Date: Mon, 22 Jan 2024 20:18:30 +0000
Message-Id: <20240122201852.262057-4-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240122201852.262057-1-maz@kernel.org>
References: <20240122201852.262057-1-maz@kernel.org>
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
---
 arch/arm64/include/asm/kvm_host.h | 25 +++++++++++++++++++
 arch/arm64/kvm/arm.c              |  1 +
 arch/arm64/kvm/nested.c           | 41 ++++++++++++++++++++++++++++++-
 3 files changed, 66 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index c0cf9c5f5e8d..fe35c59214ad 100644
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
 
@@ -868,7 +880,20 @@ static inline u64 *__ctxt_sys_reg(const struct kvm_cpu_context *ctxt, int r)
 
 #define ctxt_sys_reg(c,r)	(*__ctxt_sys_reg(c,r))
 
+#if defined (__KVM_NVHE_HYPERVISOR__)
 #define __vcpu_sys_reg(v,r)	(ctxt_sys_reg(&(v)->arch.ctxt, (r)))
+#else
+u64 kvm_vcpu_sanitise_vncr_reg(const struct kvm_vcpu *, enum vcpu_sysreg);
+#define __vcpu_sys_reg(v,r)						\
+	(*({								\
+		const struct kvm_cpu_context *ctxt = &(v)->arch.ctxt;	\
+		u64 *__r = __ctxt_sys_reg(ctxt, (r));			\
+		if (unlikely(cpus_have_final_cap(ARM64_HAS_NESTED_VIRT) && \
+			     r >= __VNCR_START__ && ctxt->vncr_array))	\
+			*__r = kvm_vcpu_sanitise_vncr_reg((v), (r));	\
+		__r;							\
+	}))
+#endif
 
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

