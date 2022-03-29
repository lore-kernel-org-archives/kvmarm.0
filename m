Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3258C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 29 Mar 2022 01:13:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B10F4B159;
	Mon, 28 Mar 2022 21:13:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bxoZP3Ag-22b; Mon, 28 Mar 2022 21:13:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 57C474B19D;
	Mon, 28 Mar 2022 21:13:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 006C74B0B8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Mar 2022 21:13:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9IGYFr-E8fKS for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Mar 2022 21:13:11 -0400 (EDT)
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com
 [209.85.166.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C3B6949EFE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Mar 2022 21:13:11 -0400 (EDT)
Received: by mail-il1-f201.google.com with SMTP id
 t16-20020a056e02061000b002c7ddaa0006so8772286ils.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Mar 2022 18:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=FQq173QwTqE1vm53MnjGUP0EAX6a1keGndPoCP0qNcw=;
 b=pxowAXIpP5cCzv+qqYGhi0KwRqqH7Oz5whjeSHml4XTfSbB3TMoAuyso+QOUOMzArl
 r2ROzDegAe81hX5m7OEFnHIRPF5gbXbE9TjUIUjTgTDvKxjl7owBoCLbo7TkUt5AR/n7
 chQZ6EyPHV5byJ+on1yh6WpGgMsf1XTQgywAT5TN/BNQJsnO9Zw9hN7LqVQI+iHo786I
 cT0tREPMb7E5bqvW/mbVfmWJz4e6BjIGV/ozdzn2VEjllG/lqPrhQHpSwEiRbjkwaO3r
 g/3bOlQfQPoYQ/yjOdBOEWZ67FvKQsMQgTAA3ix/qwLxilqrowJaXVXrDUWuOQvW7Zxo
 Y9YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=FQq173QwTqE1vm53MnjGUP0EAX6a1keGndPoCP0qNcw=;
 b=xii7+lSTzabuJkeBsEYXOJgBZ0GssLgkPplPqCLX7Aavca/CTdcxDJoRVhOBOHclMN
 WYDxaeVUe9gm0VMsW2SsNY/oao42DDnFynN9+yEC0SQcIkGD+Aks5eXo7ecCPKDhHlME
 UZm5Q3Qw7Y677/YDHbrPFxpWBK+XkdcP9fvZ3FVRyOhmM4IKdYWB8adTjnKiLwITkU0q
 mvsjigE3jnwwPMH2S35f8S7olwGAc9EeCHd0jFm6hoy5J+czs3Ca0ooert9KZ3gSbSSG
 PGsZzlYd9RqZsE0CpDQNtZsxRRID2O+iTkA4TBl6+KTk1OwRdVq/4a/3nROtpKcYIL2B
 +f6Q==
X-Gm-Message-State: AOAM532apo3F+pASpNx5Vo7HgKNKfd0qDXN/9Ed+2d9ylOfElR1UgUhO
 PZpLyNF865Dv9qpXk/jdCuTInDYVuUuswV0RnzYuw70DYFOu8gZ4W5egPnMoFhQ5mOr627leI7x
 hZCyisa6BP4s79N8a0LyhROcvLRsNEQ1ptL3j4VKNzHpFrMfpOBIQE60N6aB3zYTE1Fn0Tw==
X-Google-Smtp-Source: ABdhPJxwn5p9L3a3y2OKxHPvrs5F4XlRM25GIQM8EcT9hZl3cZuWipuAOX4zHxJwp2rkASW4XqH/Qx8PIT4=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6602:80a:b0:649:f33:ecb2
 with SMTP id
 z10-20020a056602080a00b006490f33ecb2mr7618020iow.150.1648516391021; Mon, 28
 Mar 2022 18:13:11 -0700 (PDT)
Date: Tue, 29 Mar 2022 01:13:00 +0000
In-Reply-To: <20220329011301.1166265-1-oupton@google.com>
Message-Id: <20220329011301.1166265-3-oupton@google.com>
Mime-Version: 1.0
References: <20220329011301.1166265-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
Subject: [PATCH 2/3] KVM: arm64: Plumb cp10 ID traps through the AArch64
 sysreg handler
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-arm-kernel@lists.infradead.org
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

In order to enable HCR_EL2.TID3 for AArch32 guests KVM needs to handle
traps where ESR_EL2.EC=0x8, which corresponds to an attempted VMRS
access from an ID group register. Specifically, the MVFR{0-2} registers
are accessed this way from AArch32. Conveniently, these registers are
architecturally mapped to MVFR{0-2}_EL1 in AArch64. Furthermore, KVM
already handles reads to these aliases in AArch64.

Plumb VMRS read traps through to the general AArch64 system register
handler.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/handle_exit.c      |  1 +
 arch/arm64/kvm/sys_regs.c         | 62 +++++++++++++++++++++++++++++++
 3 files changed, 64 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0e96087885fe..7a65ac268a22 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -673,6 +673,7 @@ int kvm_handle_cp14_64(struct kvm_vcpu *vcpu);
 int kvm_handle_cp15_32(struct kvm_vcpu *vcpu);
 int kvm_handle_cp15_64(struct kvm_vcpu *vcpu);
 int kvm_handle_sys_reg(struct kvm_vcpu *vcpu);
+int kvm_handle_cp10_id(struct kvm_vcpu *vcpu);
 
 void kvm_reset_sys_regs(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 97fe14aab1a3..5088a86ace5b 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -167,6 +167,7 @@ static exit_handle_fn arm_exit_handlers[] = {
 	[ESR_ELx_EC_CP15_64]	= kvm_handle_cp15_64,
 	[ESR_ELx_EC_CP14_MR]	= kvm_handle_cp14_32,
 	[ESR_ELx_EC_CP14_LS]	= kvm_handle_cp14_load_store,
+	[ESR_ELx_EC_CP10_ID]	= kvm_handle_cp10_id,
 	[ESR_ELx_EC_CP14_64]	= kvm_handle_cp14_64,
 	[ESR_ELx_EC_HVC32]	= handle_hvc,
 	[ESR_ELx_EC_SMC32]	= handle_smc,
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 30771f950027..1caac72b0cb0 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2341,6 +2341,68 @@ static int kvm_handle_cp_64(struct kvm_vcpu *vcpu,
 
 static int emulate_sys_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *params);
 
+/*
+ * The CP10 ID registers are architecturally mapped to AArch64 feature
+ * registers. Abuse that fact so we can rely on the AArch64 handler for accesses
+ * from AArch32.
+ */
+static bool kvm_esr_cp10_id_to_sys64(u32 esr, struct sys_reg_params *params)
+{
+	params->is_write = ((esr & 1) == 0);
+	params->Op0 = 3;
+	params->Op1 = 0;
+	params->CRn = 0;
+	params->CRm = 3;
+
+	switch ((esr >> 10) & 0xf) {
+	/* MVFR0 */
+	case 0b0111:
+		params->Op2 = 0;
+		break;
+	/* MVFR1 */
+	case 0b0110:
+		params->Op2 = 1;
+		break;
+	/* MVFR2 */
+	case 0b0101:
+		params->Op2 = 2;
+		break;
+	default:
+		return false;
+	}
+
+	return true;
+}
+
+/**
+ * kvm_handle_cp10_id() - Handles a VMRS trap on guest access to a 'Media and
+ *			  VFP Register' from AArch32.
+ * @vcpu: The vCPU pointer
+ *
+ * MVFR{0-2} are architecturally mapped to the AArch64 MVFR{0-2}_EL1 registers.
+ * Work out the correct AArch64 system register encoding and reroute to the
+ * AArch64 system register emulation.
+ */
+int kvm_handle_cp10_id(struct kvm_vcpu *vcpu)
+{
+	int Rt = kvm_vcpu_sys_get_rt(vcpu);
+	u32 esr = kvm_vcpu_get_esr(vcpu);
+	struct sys_reg_params params;
+	int ret;
+
+	/* UNDEF on any unhandled register or an attempted write */
+	if (!kvm_esr_cp10_id_to_sys64(esr, &params) || params.is_write) {
+		kvm_inject_undefined(vcpu);
+		return 1;
+	}
+
+	params.regval = vcpu_get_reg(vcpu, Rt);
+	ret = emulate_sys_reg(vcpu, &params);
+
+	vcpu_set_reg(vcpu, Rt, params.regval);
+	return ret;
+}
+
 /**
  * kvm_emulate_cp15_id_reg() - Handles an MRC trap on a guest CP15 access where
  *			       CRn=0, which corresponds to the AArch32 feature
-- 
2.35.1.1021.g381101b075-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
