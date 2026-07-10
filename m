Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71D73FBB73
	for <kvmarm@lists.linux.dev>; Fri, 10 Jul 2026 11:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783682159; cv=none; b=HU6epaQV/N2DPfG7waIOOdwWYszM96y+8Q1Dyna7jPK0DhSbH4tN+fcBU8ReKBUz3De+xYYYyl4z6ZFzsFs95wB8/lIqsIJd0favnk6HjtVWfCP89l8aSX95U7og1Cvw1hfeCzNCGf9Oul/jkoG7lyhL8JXul8X6n+WJQvF1TPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783682159; c=relaxed/simple;
	bh=fNgLUnEmlqyfrAV7tVVlH3jDqmlIGrds8QqIzA+zcPw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=rW1VHDBWu/7JJcQUvtlI7jaLNnLnGBb7s3leB6R0z4+dwA/8S+DxKpmOYkx6OKGpCbc2Jhx1COI5zMtVUDS/XCH+7yiv9oNggE6p3/WLeWIF2AZWlOWTAEsI+iNLddBKV91/1jN5ohAgeu7rBFK3GWvb8oq2ME5IUgDM8Cil8fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=oCRVGQbk reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="oCRVGQbk"
Received: from h183.csg.ci.i.u-tokyo.ac.jp (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 66ABEvsF024946
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 10 Jul 2026 20:15:09 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=A1U9p3xnoBS2jAZ6UnAQTf41UHMysFjf1pjjxobco+c=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-Id:To:Subject:Date;
        s=rs20250326; t=1783682109; v=1;
        b=oCRVGQbk2lJFPvYDCiIYcmDhY2QoB5j+kQXnVsbuWv987cCUgl7i2HpWFxWoj4xo
         Czpj/FgXnC5PBzcTKP8RIvTl5RiMT5sCZEmDaw+XgbWmFn035W3GelktZZYaeQ7T
         kdWnua8L2gbpgR2CWWteNtuHejoivSLGWRF79n6FkfGoMg3yyXk7X/c5MpVrhz5h
         PBCCb2F3Z0bEce6wNHnSUuErwyhDfUQJUMBTLg3vXDs41GQn6Icf0CrOrajjhT1j
         pfvs94NvMST8YYjoRWgMvnbxCepQOMFZCscRIPpny2g/N9lKAH19mnwcTrOB58hc
         28NpAO2Y1ljEpmevXf1mSw==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Fri, 10 Jul 2026 20:14:55 +0900
Subject: [PATCH v8 01/11] KVM: arm64: Serialize userspace MDCR_EL2 access
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-hybrid-v8-1-621409f3a592@rsg.ci.i.u-tokyo.ac.jp>
References: <20260710-hybrid-v8-0-621409f3a592@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260710-hybrid-v8-0-621409f3a592@rsg.ci.i.u-tokyo.ac.jp>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
        Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
        Yury Norov <yury.norov@gmail.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
X-Mailer: b4 0.16-dev-925f5
X-Developer-Signature: v=1; a=openpgp-sha256; l=2777;
 i=odaki@rsg.ci.i.u-tokyo.ac.jp; h=from:subject:message-id;
 bh=fNgLUnEmlqyfrAV7tVVlH3jDqmlIGrds8QqIzA+zcPw=;
 b=owGbwMvMwCWmMbc20y1CyJDxtFoSQ1bAFZM9IrZRGvlMeqLVClzr1HR2uRnwhHyw6qzWNz+z6
 v7c+u0dpSwMYlwMsmKKLClFu7k1oms/FSbEt8DMYWUCGcLAxSkAEzFpYvjvcVVnx2nF47oTHnvY
 /L2kvVD6Re9q+71iTSGfZ7LKTvgnzfA/MudQgPXLZ2rHoqwmf27ezuVkLFZqlpqabLFgduf7bg9
 eAA==
X-Developer-Key: i=odaki@rsg.ci.i.u-tokyo.ac.jp; a=openpgp;
 fpr=AEDC03C9AF734F2EC26A7BFFA4BAEAA73536753C

kvm_arm_set_nr_counters() updates MDCR_EL2.HPMN for every vCPU while
holding kvm->arch.config_lock. However, KVM_SET_ONE_REG currently writes
MDCR_EL2 through the generic sysreg path without taking the same lock.
Concurrent PMU configuration and register restore can therefore race and
lose updates to unrelated MDCR_EL2 bits.

Add explicit userspace accessors for MDCR_EL2. Serialize them with
config_lock so whole-register userspace writes cannot race with HPMN
rewrites, reject HPMN values above the configured PMU counter count, and
request a PMU reload when HPME changes to match guest trap behavior.

Fixes: c8823e51b534 ("KVM: arm64: Fix MDCR_EL2.HPMN reset value")
Closes: https://sashiko.dev/#/patchset/20260706-hybrid-v8-0-de459617b59d%40rsg.ci.i.u-tokyo.ac.jp?part=6
Assisted-by: Codex:gpt-5.5
Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
---
 arch/arm64/kvm/sys_regs.c | 39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index d217530359ba..2b2ea33159e9 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2949,6 +2949,42 @@ static bool access_mdcr(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static int get_mdcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
+		    u64 *val)
+{
+	struct kvm *kvm = vcpu->kvm;
+
+	guard(mutex)(&kvm->arch.config_lock);
+
+	*val = __vcpu_sys_reg(vcpu, MDCR_EL2);
+
+	return 0;
+}
+
+static int set_mdcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
+		    u64 val)
+{
+	struct kvm *kvm = vcpu->kvm;
+	u64 old, hpmn = FIELD_GET(MDCR_EL2_HPMN, val);
+
+	guard(mutex)(&kvm->arch.config_lock);
+
+	if (hpmn > vcpu->kvm->arch.nr_pmu_counters)
+		return -EINVAL;
+
+	old = __vcpu_sys_reg(vcpu, MDCR_EL2);
+	__vcpu_assign_sys_reg(vcpu, MDCR_EL2, val);
+
+	/*
+	 * Request a reload of the PMU to enable/disable the counters
+	 * affected by HPME.
+	 */
+	if ((old ^ val) & MDCR_EL2_HPME)
+		kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
+
+	return 0;
+}
+
 static bool access_ras(struct kvm_vcpu *vcpu,
 		       struct sys_reg_params *p,
 		       const struct sys_reg_desc *r)
@@ -3652,7 +3688,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG_FILTERED(SCTLR2_EL2, access_vm_reg, reset_val, 0,
 			 sctlr2_el2_visibility),
 	EL2_REG_VNCR(HCR_EL2, reset_hcr, 0),
-	EL2_REG(MDCR_EL2, access_mdcr, reset_mdcr, 0),
+	SYS_REG_USER_FILTER(MDCR_EL2, access_mdcr, reset_mdcr, 0,
+			    get_mdcr, set_mdcr, el2_visibility),
 	EL2_REG(CPTR_EL2, access_rw, reset_val, CPTR_NVHE_EL2_RES1),
 	EL2_REG_VNCR(HSTR_EL2, reset_val, 0),
 	EL2_REG_VNCR_FILT(HFGRTR_EL2, fgt_visibility),

-- 
2.55.0

