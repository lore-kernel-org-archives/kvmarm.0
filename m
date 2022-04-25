Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72CEFC433FE
	for <kvmarm@archiver.kernel.org>; Mon, 25 Apr 2022 23:53:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1EA984B1AB;
	Mon, 25 Apr 2022 19:53:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jWKZ0Wsn04wE; Mon, 25 Apr 2022 19:53:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 704074B1E7;
	Mon, 25 Apr 2022 19:53:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AD494B0DD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 19:53:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2FV6BC9nVY0K for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Apr 2022 19:53:51 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CF6404B17C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 19:53:51 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 b6-20020a5b0b46000000b006457d921729so10583195ybr.23
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 16:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=wr+Rt5L1fqDdNsPuVYqckLa+loKYmG6z4kIr1v4ZOZY=;
 b=EeDwVIDEftJAHw+7lFAJyKPjIUdU/YIlyW0SNBlS/QT4grmabJllnVJuEP6Mv1O8Wf
 rKjf/TucTNU9jNcODbVYpgc+yl4hBVu7ybByuUwdC6M+1KSQcIpFK8Re8vB4feQSiX2v
 LQWB+GTdFjxxojybDofWu/ldjrv0xOQQhlxloyfCsHTFGaaWBXqCXoCN8myGejr56xT0
 cnfvu/rX7PwroYhTHswVjeL4VLmRbHyoj5xQDg0I+gE5kAPwMxy0sprCcqP674JJCAej
 fmFx5Q8N4HCU2hSvne48aTtwwaf6HWyOZsZJxjX/SGPV81iuzkFUcZz7NNlN8IoxH1m0
 +wgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=wr+Rt5L1fqDdNsPuVYqckLa+loKYmG6z4kIr1v4ZOZY=;
 b=3/dUOeP46jGzaHxw5+r3QL8OjeBaJdZGuWgVM9VKAX7JRXnNS66ZHie4Zy6SYm1mOE
 reTk2+Faw2U4ovKg0AuiK1y8x1OMLybaYTIDL//EXDCpjQ84Ml/W095tQ/Fz+1R/VPHr
 w2zoOSJZe9IdbBHeKNKX/1K44XqsYwuee5IVJpnt3JEHDuvnV8MlGApHCOzRVUpetTv1
 x93gTaiDHwkz3MYuqkLoF+DphFFtFyeNuvdJ0nJ21HO9RCWtaJH2WWHy7sSYJm1Mfc6F
 wUytH92rAH1RC/ASadeXCKP+0pkC/hc1lR9FM45maPIK7GjQTimFc7Nxd46rLnEhIFP4
 17BA==
X-Gm-Message-State: AOAM533/fhNx97/yATumbr05hEJo0m5Y4zrATMxqPwbzBvVqv1UCLU+e
 EhLvSSV+XZ0HMETXC5eMYH78y989k7ScrZwODYZbFnAVZjE9GG3DiTuqhtd5OnoYVxWT5tmpHJA
 XZdn599Epl2KrnRS1XQVaSBz2BS815jBYJkG4xb6aN3ktvofhnlhm4Kqp//eBOlbjqanZWA==
X-Google-Smtp-Source: ABdhPJxBErIBYNvwXwNCxTHUviYLMLxthYdrHWKFrj3kf90D9/VOIBMyU80/pjUfCacWFKLe8trGOzrMsP4=
X-Received: from oupton3.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a81:6642:0:b0:2eb:c364:b8e1 with SMTP id
 a63-20020a816642000000b002ebc364b8e1mr19066493ywc.64.1650930831272; Mon, 25
 Apr 2022 16:53:51 -0700 (PDT)
Date: Mon, 25 Apr 2022 23:53:41 +0000
In-Reply-To: <20220425235342.3210912-1-oupton@google.com>
Message-Id: <20220425235342.3210912-5-oupton@google.com>
Mime-Version: 1.0
References: <20220425235342.3210912-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v3 4/5] KVM: arm64: Plumb cp10 ID traps through the AArch64
 sysreg handler
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
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

In order to enable HCR_EL2.TID3 for AArch32 guests KVM needs to handle
traps where ESR_EL2.EC=0x8, which corresponds to an attempted VMRS
access from an ID group register. Specifically, the MVFR{0-2} registers
are accessed this way from AArch32. Conveniently, these registers are
architecturally mapped to MVFR{0-2}_EL1 in AArch64. Furthermore, KVM
already handles reads to these aliases in AArch64.

Plumb VMRS read traps through to the general AArch64 system register
handler.

Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/handle_exit.c      |  1 +
 arch/arm64/kvm/sys_regs.c         | 71 +++++++++++++++++++++++++++++++
 3 files changed, 73 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 94a27a7520f4..05081b9b7369 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -683,6 +683,7 @@ int kvm_handle_cp14_64(struct kvm_vcpu *vcpu);
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
index f403ea47b8a3..586b292ca94f 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2346,6 +2346,77 @@ static int kvm_handle_cp_64(struct kvm_vcpu *vcpu,
 
 static bool emulate_sys_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *params);
 
+/*
+ * The CP10 ID registers are architecturally mapped to AArch64 feature
+ * registers. Abuse that fact so we can rely on the AArch64 handler for accesses
+ * from AArch32.
+ */
+static bool kvm_esr_cp10_id_to_sys64(u32 esr, struct sys_reg_params *params)
+{
+	u8 reg_id = (esr >> 10) & 0xf;
+	bool valid;
+
+	params->is_write = ((esr & 1) == 0);
+	params->Op0 = 3;
+	params->Op1 = 0;
+	params->CRn = 0;
+	params->CRm = 3;
+
+	/* CP10 ID registers are read-only */
+	valid = !params->is_write;
+
+	switch (reg_id) {
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
+		valid = false;
+	}
+
+	if (valid)
+		return true;
+
+	kvm_pr_unimpl("Unhandled cp10 register %s: %u\n",
+		      params->is_write ? "write" : "read", reg_id);
+	return false;
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
+
+	/* UNDEF on any unhandled register access */
+	if (!kvm_esr_cp10_id_to_sys64(esr, &params)) {
+		kvm_inject_undefined(vcpu);
+		return 1;
+	}
+
+	if (emulate_sys_reg(vcpu, &params))
+		vcpu_set_reg(vcpu, Rt, params.regval);
+
+	return 1;
+}
+
 /**
  * kvm_emulate_cp15_id_reg() - Handles an MRC trap on a guest CP15 access where
  *			       CRn=0, which corresponds to the AArch32 feature
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
