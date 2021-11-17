Return-Path: <SRS0=Jx+E=QE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A656C433FE
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 06:54:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C34DC615E6
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 06:53:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C34DC615E6
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 777794B1BD;
	Wed, 17 Nov 2021 01:53:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id grxjBGknI5pE; Wed, 17 Nov 2021 01:53:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE6F04B1C0;
	Wed, 17 Nov 2021 01:53:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C45114B177
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 01:53:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ikb6SVsEdvHA for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Nov 2021 01:53:54 -0500 (EST)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 156CE4B17C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 01:53:54 -0500 (EST)
Received: by mail-pl1-f202.google.com with SMTP id
 m17-20020a170902db1100b001421cb34857so560942plx.15
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Nov 2021 22:53:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=3Vy8zl0uiB6BzrVyosP76h+gx7fVBOmrAidLKwyOmLo=;
 b=SIFfTVfI7I8A9xtfgW2SGwAAgVjhFtCYzxi+nqRkzYADw/h3e55zX8dv0tcR7U3gTs
 Ow0HGNvpz/NuJG85fy363/AcS51o/aycC/kCv5uCjNhS+RCTNdAFQi4+DcDeTOnDeDse
 FVkEWvlwCHnfDvOvPIJ9ghlPfoOQgt8kKi10mbK55MgoCJkbF1IJEjpJu1oblfYzNLKq
 y4xT6lWYpL+xwM+iKPJwn2wFgMnVAK5Or854NPyaNECj9/og+mfPKEOLl7iIRm4Lmngr
 PItBcWboqdv21plvaPRpZkKCuZVq0DXHslVP9GpedQEfAciDbpFEfcddLsx2m9IGBW55
 wq+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=3Vy8zl0uiB6BzrVyosP76h+gx7fVBOmrAidLKwyOmLo=;
 b=yzhTNcQc243KvOqlopRoqEnGQq6v0GjQ1DhX9ZKMOcxVkn7WiUbUmbqL4SrMF/6reI
 x2iyx5R1YWJOHFH79k9oEbue8eCZpFmWx6Qtq4BKECWofiD5AcpmgsmBlMBPMzCUQ2s9
 kPlfpC7avJVKtFYKn92cpx2p+Hcu0qtdvFAMEGJiS/+qdStTIOVPU6Hm7gNpXXycixqO
 QIZ94eVH/dz5Wrz/BHthMlFd61BJSWq9VPxDcJjKT96dXmJCQoiXEQ2lp165fXPqsMs4
 RMozGsu91N9/z6/2MCBtlZREAiOvXcuiDURQ6zJzowZJRFZ3OQagItZfMBejNjYIHysu
 Focg==
X-Gm-Message-State: AOAM531OjhU2KE5NHbPFc6vNx5Lh9ebmbSyDNFlmZbPGAao28P41OrWt
 OAcgHBqfv714D/lWmcGRkMqfMeVg4SE=
X-Google-Smtp-Source: ABdhPJyuYg+X9kpMVUPN5OoZNv12tw8vlVgjnQ4xCZ/tC4KYbUa1SUFiMJwvsngrbAH2RAUicLELQrXc63o=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:ed89:b0:141:f601:d6a with SMTP id
 e9-20020a170902ed8900b00141f6010d6amr52839367plj.77.1637132033292; Tue, 16
 Nov 2021 22:53:53 -0800 (PST)
Date: Tue, 16 Nov 2021 22:43:58 -0800
In-Reply-To: <20211117064359.2362060-1-reijiw@google.com>
Message-Id: <20211117064359.2362060-29-reijiw@google.com>
Mime-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v3 28/29] KVM: arm64: Add kunit test for trap
 initialization
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Add KUnit tests for functions that initialize traps.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs_test.c | 238 +++++++++++++++++++++++++++++++++
 1 file changed, 238 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs_test.c b/arch/arm64/kvm/sys_regs_test.c
index 8d27c7c361fb..f73b207be4ee 100644
--- a/arch/arm64/kvm/sys_regs_test.c
+++ b/arch/arm64/kvm/sys_regs_test.c
@@ -844,6 +844,241 @@ static void validate_mvfr1_el1_test(struct kunit *test)
 	test_kvm_vcpu_fini(test, vcpu);
 }
 
+static void feature_trap_activate_test(struct kunit *test)
+{
+	struct kvm_vcpu *vcpu;
+	struct feature_config_ctrl config_data, *config = &config_data;
+	u64 cfg_mask, cfg_val;
+
+	vcpu = test_kvm_vcpu_init(test);
+	KUNIT_EXPECT_TRUE(test, vcpu);
+	if (!vcpu)
+		return;
+
+	vcpu->arch.hcr_el2 = 0;
+	config->ftr_reg = SYS_ID_AA64MMFR1_EL1;
+	config->ftr_shift = 4;
+	config->ftr_min = 2;
+	config->ftr_signed = FTR_UNSIGNED;
+
+	/* Test for hcr_el2 */
+	config->cfg_reg = VCPU_HCR_EL2;
+	cfg_mask = 0x30000800000;
+	cfg_val = 0x30000800000;
+	config->cfg_mask = cfg_mask;
+	config->cfg_val = cfg_val;
+
+	vcpu->arch.hcr_el2 = 0;
+	feature_trap_activate(vcpu, config);
+	KUNIT_EXPECT_EQ(test, vcpu->arch.hcr_el2 & cfg_mask, cfg_val);
+
+	cfg_mask = 0x30000800000;
+	cfg_val = 0;
+	config->cfg_mask = cfg_mask;
+	config->cfg_val = cfg_val;
+
+	vcpu->arch.hcr_el2 = 0;
+	feature_trap_activate(vcpu, config);
+	KUNIT_EXPECT_EQ(test, vcpu->arch.hcr_el2 & cfg_mask, cfg_val);
+
+	/* Test for mdcr_el2 */
+	config->cfg_reg = VCPU_MDCR_EL2;
+	cfg_mask = 0x30000800000;
+	cfg_val = 0x30000800000;
+	config->cfg_mask = cfg_mask;
+	config->cfg_val = cfg_val;
+
+	vcpu->arch.mdcr_el2 = 0;
+	feature_trap_activate(vcpu, config);
+	KUNIT_EXPECT_EQ(test, vcpu->arch.mdcr_el2 & cfg_mask, cfg_val);
+
+	cfg_mask = 0x30000800000;
+	cfg_val = 0x0;
+	config->cfg_mask = cfg_mask;
+	config->cfg_val = cfg_val;
+
+	vcpu->arch.mdcr_el2 = 0;
+	feature_trap_activate(vcpu, config);
+	KUNIT_EXPECT_EQ(test, vcpu->arch.mdcr_el2 & cfg_mask, cfg_val);
+
+	/* Test for cptr_el2 */
+	config->cfg_reg = VCPU_CPTR_EL2;
+	cfg_mask = 0x30000800000;
+	cfg_val = 0x30000800000;
+	config->cfg_mask = cfg_mask;
+	config->cfg_val = cfg_val;
+
+	vcpu->arch.cptr_el2 = 0;
+	feature_trap_activate(vcpu, config);
+	KUNIT_EXPECT_EQ(test, vcpu->arch.cptr_el2 & cfg_mask, cfg_val);
+
+	cfg_mask = 0x30000800000;
+	cfg_val = 0x0;
+	config->cfg_mask = cfg_mask;
+	config->cfg_val = cfg_val;
+
+	vcpu->arch.cptr_el2 = 0;
+	feature_trap_activate(vcpu, config);
+	KUNIT_EXPECT_EQ(test, vcpu->arch.cptr_el2 & cfg_mask, cfg_val);
+
+	test_kvm_vcpu_fini(test, vcpu);
+}
+
+static bool test_need_trap_aa64dfr0(struct kvm_vcpu *vcpu)
+{
+	u64 val;
+
+	val = __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(SYS_ID_AA64DFR0_EL1));
+	return ((val & 0xf) == 0);
+}
+
+static void id_reg_features_trap_activate_test(struct kunit *test)
+{
+	struct kvm_vcpu *vcpu;
+	u32 id;
+	u64 cfg_mask0, cfg_val0, cfg_mask1, cfg_val1, cfg_mask2, cfg_val2;
+	u64 cfg_mask, cfg_val, id_reg_sys_val;
+	struct id_reg_info id_reg_data;
+	struct feature_config_ctrl *config, config0, config1, config2;
+	struct feature_config_ctrl *trap_features[] = {
+		&config0, &config1, &config2, NULL,
+	};
+
+	vcpu = test_kvm_vcpu_init(test);
+	KUNIT_EXPECT_TRUE(test, vcpu);
+	if (!vcpu)
+		return;
+
+	id_reg_sys_val = 0x7777777777777777;
+	id = SYS_ID_AA64DFR0_EL1;
+	id_reg_data.sys_reg = id;
+	id_reg_data.sys_val = id_reg_sys_val;
+	id_reg_data.vcpu_limit_val  = (u64)-1;
+	id_reg_data.trap_features =
+			(const struct feature_config_ctrl *(*)[])trap_features;
+
+	cfg_mask0 = 0x3;
+	cfg_val0 = 0x3;
+	config = &config0;
+	memset(config, 0, sizeof(*config));
+	config->ftr_reg = id;
+	config->ftr_shift = 60;
+	config->ftr_min = 2;
+	config->ftr_signed = FTR_UNSIGNED;
+	config->cfg_reg = VCPU_HCR_EL2;
+	config->cfg_mask = cfg_mask0;
+	config->cfg_val = cfg_val0;
+
+	cfg_mask1 = 0x70000040;
+	cfg_val1 = 0x30000040;
+	config = &config1;
+	memset(config, 0, sizeof(*config));
+	config->ftr_reg = id;
+	config->ftr_need_trap = test_need_trap_aa64dfr0;
+	config->ftr_signed = FTR_UNSIGNED;
+	config->cfg_reg = VCPU_HCR_EL2;
+	config->cfg_mask = cfg_mask1;
+	config->cfg_val = cfg_val1;
+
+	/* Feature with signed ID register field */
+	cfg_mask2 = 0x70000000800;
+	cfg_val2 = 0x30000000800;
+	config = &config2;
+	memset(config, 0, sizeof(*config));
+	config->ftr_reg = id;
+	config->ftr_shift = 4;
+	config->ftr_min = 0;
+	config->ftr_signed = FTR_SIGNED;
+	config->cfg_reg = VCPU_HCR_EL2;
+	config->cfg_mask = cfg_mask2;
+	config->cfg_val = cfg_val2;
+
+	/* Enable features for config0, 1 and 2 */
+	__vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id)) = id_reg_sys_val;
+
+	vcpu->arch.hcr_el2 = 0;
+	id_reg_features_trap_activate(vcpu, &id_reg_data);
+	KUNIT_EXPECT_EQ(test, vcpu->arch.hcr_el2, 0);
+
+	/* Disable features for config0 only */
+	__vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id)) = 0x1;
+	cfg_mask = cfg_mask0;
+	cfg_val = cfg_val0;
+
+	vcpu->arch.hcr_el2 = 0;
+	id_reg_features_trap_activate(vcpu, &id_reg_data);
+	KUNIT_EXPECT_EQ(test, vcpu->arch.hcr_el2 & cfg_mask, cfg_val);
+
+	/* Disable features for config0 and config1 */
+	__vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id)) = 0x0;
+	cfg_mask = (cfg_mask0 | cfg_mask1);
+	cfg_val = (cfg_val0 | cfg_val1);
+
+	vcpu->arch.hcr_el2 = 0;
+	id_reg_features_trap_activate(vcpu, &id_reg_data);
+	KUNIT_EXPECT_EQ(test, vcpu->arch.hcr_el2 & cfg_mask, cfg_val);
+
+	/* Disable features for config0, 1, and 2 */
+	__vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id)) = 0xf0;
+	cfg_mask = (cfg_mask0 | cfg_mask1 | cfg_mask2);
+	cfg_val = (cfg_val0 | cfg_val1 | cfg_val2);
+
+	vcpu->arch.hcr_el2 = 0;
+	id_reg_features_trap_activate(vcpu, &id_reg_data);
+	KUNIT_EXPECT_EQ(test, vcpu->arch.hcr_el2 & cfg_mask, cfg_val);
+
+	/* Test with id_reg_info == NULL */
+	vcpu->arch.hcr_el2 = 0;
+	id_reg_features_trap_activate(vcpu, NULL);
+	KUNIT_EXPECT_EQ(test, vcpu->arch.hcr_el2, 0);
+
+	/* Test with id_reg_data.trap_features = NULL */
+	id_reg_data.trap_features = NULL;
+	__vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id)) = 0xf0;
+
+	vcpu->arch.hcr_el2 = 0;
+	id_reg_features_trap_activate(vcpu, &id_reg_data);
+	KUNIT_EXPECT_EQ(test, vcpu->arch.hcr_el2, 0);
+
+	test_kvm_vcpu_fini(test, vcpu);
+}
+
+static void vcpu_need_trap_ptrauth_test(struct kunit *test)
+{
+	struct kvm_vcpu *vcpu;
+	u32 id = SYS_ID_AA64ISAR1_EL1;
+
+	vcpu = test_kvm_vcpu_init(test);
+	KUNIT_EXPECT_TRUE(test, vcpu);
+	if (!vcpu)
+		return;
+
+	if (system_has_full_ptr_auth()) {
+		__vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id)) = 0x0;
+		KUNIT_EXPECT_TRUE(test, vcpu_need_trap_ptrauth(vcpu));
+
+		/* GPI = 1, API = 1 */
+		__vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id)) = 0x10000100;
+		KUNIT_EXPECT_FALSE(test, vcpu_need_trap_ptrauth(vcpu));
+
+		/* GPI = 1, APA = 1 */
+		__vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id)) = 0x10000010;
+		KUNIT_EXPECT_FALSE(test, vcpu_need_trap_ptrauth(vcpu));
+
+		/* GPA = 1, API = 1 */
+		__vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id)) = 0x01000100;
+		KUNIT_EXPECT_FALSE(test, vcpu_need_trap_ptrauth(vcpu));
+
+		/* GPA = 1, APA = 1 */
+		__vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id)) = 0x01000010;
+		KUNIT_EXPECT_FALSE(test, vcpu_need_trap_ptrauth(vcpu));
+	} else {
+		KUNIT_EXPECT_FALSE(test, vcpu_need_trap_ptrauth(vcpu));
+	}
+
+	test_kvm_vcpu_fini(test, vcpu);
+}
+
 static struct kunit_case kvm_sys_regs_test_cases[] = {
 	KUNIT_CASE_PARAM(arm64_check_feature_one_test, feature_one_gen_params),
 	KUNIT_CASE_PARAM(arm64_check_features_test, features_gen_params),
@@ -859,6 +1094,9 @@ static struct kunit_case kvm_sys_regs_test_cases[] = {
 	KUNIT_CASE(validate_id_aa64dfr0_el1_test),
 	KUNIT_CASE(validate_id_dfr0_el1_test),
 	KUNIT_CASE(validate_mvfr1_el1_test),
+	KUNIT_CASE(vcpu_need_trap_ptrauth_test),
+	KUNIT_CASE(feature_trap_activate_test),
+	KUNIT_CASE(id_reg_features_trap_activate_test),
 	{}
 };
 
-- 
2.34.0.rc1.387.gb447b232ab-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
