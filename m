Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0614C43219
	for <kvmarm@archiver.kernel.org>; Fri,  1 Apr 2022 01:08:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 58D4C4B269;
	Thu, 31 Mar 2022 21:08:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sQXfiOea5+vx; Thu, 31 Mar 2022 21:08:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 348904A014;
	Thu, 31 Mar 2022 21:08:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F33E04B269
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Mar 2022 21:08:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UiLH6bdS--BO for <kvmarm@lists.cs.columbia.edu>;
 Thu, 31 Mar 2022 21:08:41 -0400 (EDT)
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com
 [209.85.166.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B3B7640597
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Mar 2022 21:08:41 -0400 (EDT)
Received: by mail-il1-f201.google.com with SMTP id
 s14-20020a056e021a0e00b002c7c03a5d81so873934ild.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Mar 2022 18:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=06vWdix0nphKiUgy/DH5I5wyYbLVTiSxn7JE1pEyNQk=;
 b=FLhwlY5XN01iVZRMrKYr/uhdah5Vk/+PRwg8u6ly+7J8I0HOyqcf+E+ggm+HGeuUeL
 trFUgcq1JRk2zubIBPxJvdzUPy92mnt2WDytdEC8c2A8c2OmqKItvcVEoYHA4bVN5jmQ
 hCJuvk+U9bOfPqjchOOwA9uWCl8ArYmtSHyu2JZawi2ekEwIoQMtxvDJKQ3kwMOHbpOo
 0IBeHSWXx0DsHoCeHEC9p0AU2hesZh2XmMRKlIM1Gmu7BCpTqnKcwA6mUaTsu5GTbAUx
 KMptlZIF4ZDJZPmymeTAbH2Hc0aymqdbIZv7InT24VcPR0e2DQxpKruF7E9qg9jcz5yY
 6x5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=06vWdix0nphKiUgy/DH5I5wyYbLVTiSxn7JE1pEyNQk=;
 b=AgxKStP1WU22RfVx+kwqI9ThLoWXvvwA0U6InKSJY3Xqr9hcv8irjSYT7UF7LfO2jU
 lcvedSQ6FRe1qabpd1YFnaJI8YvqnesI0wuv2lboLj71IoTNI2ygZ1kFNp3X3R23vyJF
 Ao+pdoknUizyZfGA7n5h6YeaXbSw6lSSHG1EaMWaxQxji7s9vf1MVJ1IuKiab8FiCEBw
 s6CqMh/e9Kpdvi5bUOCToq4ZbzuHR/rPIWnj2T++JjT2kq58iF8QUUCWcvjBWlkdJHal
 6bh5sQNWC61DRQhcowHDdnEeWbtN1vEyjSBOjDdQnvj2wtwzCD2vwQKsVtwbHoOW8HjE
 ApAA==
X-Gm-Message-State: AOAM532ZJ3kUbhj8l129xNrzyhOFH+3sbnI2iih4TGRKguJ3xuV4SRBj
 XtdSZFCUIbPYaMKAIvTs31zcmn3Xrl0YDcqWalZVcZxuUDNr4ZxGyNvUDds52/Pz8sX7UmzKpvq
 VTa2I+aSGalb+kM3dJEt8EGYHpIoQMfDbZRC0Dmt+yBC9KXuy3uWHWw25sFDhyMpEFG5Zkw==
X-Google-Smtp-Source: ABdhPJxie27Eja2GBAYjy1wyGtshgFLEF0uMF2Yaxdt/g8WYlz3+cHfV7mgpsQgpGHu2s2wyB45MDZlErNY=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:dd3:b0:2c9:cf64:6be6
 with SMTP id
 l19-20020a056e020dd300b002c9cf646be6mr8239156ilj.68.1648775321155; Thu, 31
 Mar 2022 18:08:41 -0700 (PDT)
Date: Fri,  1 Apr 2022 01:08:31 +0000
In-Reply-To: <20220401010832.3425787-1-oupton@google.com>
Message-Id: <20220401010832.3425787-3-oupton@google.com>
Mime-Version: 1.0
References: <20220401010832.3425787-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v2 2/3] KVM: arm64: Plumb cp10 ID traps through the AArch64
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
 arch/arm64/kvm/sys_regs.c         | 61 +++++++++++++++++++++++++++++++
 3 files changed, 63 insertions(+)

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
index 8b791256a5b4..4863592d060d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2341,6 +2341,67 @@ static int kvm_handle_cp_64(struct kvm_vcpu *vcpu,
 
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
2.35.1.1094.g7c7d902a7c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
