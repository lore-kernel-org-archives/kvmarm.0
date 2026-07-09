Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0152343B4A7;
	Thu,  9 Jul 2026 18:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783622449; cv=none; b=djlGSZh/oWUruEJ5Io0VhLsUzyrH0d89YJoFAzyiideyhMMFpg+SffcHcpoNG6Yy1b1BfxkGS6X3J9K1cO3bZkgIAZtNHKzyvhlIsP7kcZD38HbDUoc4pe5Z8AFLsPns3P7+MFBOugkS0NgmYS3GodY1gwLadk9ygMTGjIXftCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783622449; c=relaxed/simple;
	bh=sk5UV4D8nxCJMJ3xILivF4E7O/FkNOR/tMjqIGqB6Y0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kLMbP2UICnId+r9x6fcvwJl55ya2Tcdn0M4OdzQJ9VIndvsJz8go2tgh34z275YPlqyWHuZ3Iv0JyHY4fdZ8uypEqVuHmlM/ydZDRFj1erkIMniX8UPIvqD0zuvRacqgfniETVRqUwmfNIoSmJPi9x6SRpLu09OOHM6YLgd0qOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mgKrxYgS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mgKrxYgS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 007F41F00A3D;
	Thu,  9 Jul 2026 18:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783622447;
	bh=/D7A+/K09S6yFl/i+7JwiO/DHtiAAbsIdjqdAGJ7jGk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mgKrxYgSIcBlpe4Bo27wDH0q+ZeuEC0ninInExr/W1Yqo3U1WVz6ydh4pge7oCiWt
	 bILrQokD5f9APsTOc459WS424W1DvtacpBJ1sgsP+3yZakufGvxcwrVEky8ykFCKc5
	 Emc84V4sPzsXQHpBHA1DlNI0HtMkGmca5+dirLqM+HYjc4RXaw7xIApQ365KGTkclf
	 1Lx2VBIu5osET/0Z1MsQ7txX2JHUFt9TvT0Zi5UN1c+M/EJe87nQe3L4yQbrPWXVnt
	 7JQZ0dBFAb50PB+ASw5TmfZ0hZvtsuDpOXtN8aCLppZeWrO6G/1WHXkHRxV2E4n7Uo
	 fH/8vGsAHgA3A==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 09 Jul 2026 19:27:30 +0100
Subject: [PATCH v12 09/29] KVM: arm64: Define internal features for SME
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260709-kvm-arm64-sme-v12-9-d0301d79ef58@kernel.org>
References: <20260709-kvm-arm64-sme-v12-0-d0301d79ef58@kernel.org>
In-Reply-To: <20260709-kvm-arm64-sme-v12-0-d0301d79ef58@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Fuad Tabba <tabba@google.com>, 
 Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
 Jean-Philippe Brucker <jpb@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Peter Maydell <peter.maydell@linaro.org>, 
 Eric Auger <eric.auger@redhat.com>, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3307; i=broonie@kernel.org;
 h=from:subject:message-id; bh=sk5UV4D8nxCJMJ3xILivF4E7O/FkNOR/tMjqIGqB6Y0=;
 b=kA0DAAoBJNaLcl1Uh9AByyZiAGpP6vGixroq2Dqygirl/HNE1Gkjv+/lzgYvCL8/RgFecFYwQ
 YkBMwQAAQoAHRYhBK3maKpnVxi1n+Kf6iTWi3JdVIfQBQJqT+rxAAoJECTWi3JdVIfQo/UIAIHS
 s5yxPE+7oCWVKhITts7HuEm7l1olgpo6JbGKUqAgxynCfj8qAh7BEev4IH5210e223eBSgRlUKo
 /riXtJtMgYc8/hI/Nt3EQLhk37hhaZ1p3Bd07IM564c3ZYfixQRTzZuKBxnv5+QMePmFICCrnkx
 z/6hDvBsurCKVWxE8ZNZ+b9jF4LzX8PjEJj5hvr/zLzac96hjnA1wfMxWdyzsR8g+2SF4Qb9So7
 09vohPckvwihA/If7RjRsialVdFDIWqSQZGL0nXq826A0nYrBxa9y3j/SLsnuqJ0nVLZY6QYQCb
 Bg7wXkjjfbzMjBAqmmjf6SfCxgobaPfCAPazBwU=
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

In order to simplify interdependencies in the rest of the series define
the feature detection for SME and its subfeatures.  Due to the need for
vector length configuration we define a flag for SME like for SVE.  We
also have two subfeatures which add architectural state, FA64 and SME2,
which are configured via the normal ID register scheme.

Also provide helpers which check if the vCPU is in streaming mode or has
ZA enabled.

Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 35 ++++++++++++++++++++++++++++++++++-
 arch/arm64/kvm/sys_regs.c         |  2 +-
 2 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8b746b1a1e53..8e185e43fbff 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -367,6 +367,8 @@ struct kvm_arch {
 #define KVM_ARCH_FLAG_WRITABLE_IMP_ID_REGS		10
 	/* Unhandled SEAs are taken to userspace */
 #define KVM_ARCH_FLAG_EXIT_SEA				11
+	/* SME exposed to guest */
+#define KVM_ARCH_FLAG_GUEST_HAS_SME			12
 	unsigned long flags;
 
 	/* VM-wide vCPU feature set */
@@ -1133,7 +1135,16 @@ struct kvm_vcpu_arch {
 #define vcpu_has_sve(vcpu)	kvm_has_sve((vcpu)->kvm)
 #endif
 
-#define vcpu_has_vec(vcpu) vcpu_has_sve(vcpu)
+#define kvm_has_sme(kvm)	(system_supports_sme() &&		\
+				 test_bit(KVM_ARCH_FLAG_GUEST_HAS_SME, &(kvm)->arch.flags))
+
+#ifdef __KVM_NVHE_HYPERVISOR__
+#define vcpu_has_sme(vcpu)	kvm_has_sme(kern_hyp_va((vcpu)->kvm))
+#else
+#define vcpu_has_sme(vcpu)	kvm_has_sme((vcpu)->kvm)
+#endif
+
+#define vcpu_has_vec(vcpu) (vcpu_has_sve(vcpu) || vcpu_has_sme(vcpu))
 
 #ifdef CONFIG_ARM64_PTR_AUTH
 #define vcpu_has_ptrauth(vcpu)						\
@@ -1650,6 +1661,28 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
 #define kvm_has_sctlr2(k)				\
 	(kvm_has_feat((k), ID_AA64MMFR3_EL1, SCTLRX, IMP))
 
+#define kvm_has_fa64(k)					\
+	(system_supports_fa64() &&			\
+	 kvm_has_feat((k), ID_AA64SMFR0_EL1, FA64, IMP))
+
+#define kvm_has_sme2(k)					\
+	(system_supports_sme2() &&			\
+	 kvm_has_feat((k), ID_AA64PFR1_EL1, SME, SME2))
+
+#ifdef __KVM_NVHE_HYPERVISOR__
+#define vcpu_has_sme2(vcpu)	kvm_has_sme2(kern_hyp_va((vcpu)->kvm))
+#define vcpu_has_fa64(vcpu)	kvm_has_fa64(kern_hyp_va((vcpu)->kvm))
+#else
+#define vcpu_has_sme2(vcpu)	kvm_has_sme2((vcpu)->kvm)
+#define vcpu_has_fa64(vcpu)	kvm_has_fa64((vcpu)->kvm)
+#endif
+
+#define vcpu_in_streaming_mode(vcpu) \
+	(__vcpu_sys_reg(vcpu, SVCR) & SVCR_SM_MASK)
+
+#define vcpu_za_enabled(vcpu) \
+	(__vcpu_sys_reg(vcpu, SVCR) & SVCR_ZA_MASK)
+
 static inline bool kvm_arch_has_irq_bypass(void)
 {
 	return true;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index b352cd323e30..ba8a3ed8f5ff 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2028,7 +2028,7 @@ static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
 static unsigned int sme_visibility(const struct kvm_vcpu *vcpu,
 				   const struct sys_reg_desc *rd)
 {
-	if (kvm_has_feat(vcpu->kvm, ID_AA64PFR1_EL1, SME, IMP))
+	if (vcpu_has_sme(vcpu))
 		return 0;
 
 	return REG_HIDDEN;

-- 
2.47.3

