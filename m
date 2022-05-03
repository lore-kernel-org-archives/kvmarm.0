Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3FC9C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  3 May 2022 06:02:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5797A4B211;
	Tue,  3 May 2022 02:02:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4Kq9SG6nl9PS; Tue,  3 May 2022 02:02:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 373C44B28F;
	Tue,  3 May 2022 02:02:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B12F4B218
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 02:02:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Bpb5XB7UdjEI for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 May 2022 02:02:15 -0400 (EDT)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DA0E94B20F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 02:02:15 -0400 (EDT)
Received: by mail-pj1-f74.google.com with SMTP id
 o16-20020a17090ab89000b001d84104fc2cso554852pjr.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 May 2022 23:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=kNIvmW+UQg4kyqFomsH3U0dCsHh4hH7Ihe0URim/gjs=;
 b=b8rMBUdg4rhRlWUVQAGU8hwTTgclcE+ZuT0I+HoyfNsYte5xd4WZREks7dSJU2hZMi
 W4nw4EmMJxc4L57f/GjA40yADNMoW/qKH/AkbNYA8gLS+qld7+pQcxsef2BeWecupjTd
 dXe+QrmXQEaFf793D6cRph4IQPhYTGEWOXVq3xNVWZ0yP1wcpHCOQsKJ04G2wiWyPbCt
 gX7KU4MCAOaZjeajKEHSt+YZNLVh2LTypdUfaeGYcMiBoSE7k+/dupBHNZWtdPPoxICl
 gj5s/tyxhC4ZfQMYwMtfRP+bfcTXubHDdnOnOc0Z2il9yqGfAj+XikS3UMysgF9YCBTx
 rsgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=kNIvmW+UQg4kyqFomsH3U0dCsHh4hH7Ihe0URim/gjs=;
 b=sJW4o5XOH/g6flh3l/JXfeyYTEyPeLjlR/akeDuHol4qg0TlSk4rp0bLJXFjNWzbvH
 LEjCDfLFDwQfMJMktBV2BEjHACeMTPWWlEqSR4xzPrkMN7zn8otys+75+aU8gQylkEkt
 KaK5WXFWe+r/b4g7kr76bHRQ0OAd+gXjDhj7/jVFcIl6fpXCzK/gcd3XrtlKEWJ2THR5
 S/pcXtuOuDJ+jAT7FH9jjHPW75Cs2IKPcSVSM6X3oBhDxLkRV6b0VOicbrUDwmv0KC1Y
 nl0Df8pOTOBEgGzFTmELaIsr5vnh//QUttotZSwJJil4SOQPFQeaTeT/DefbF15B55r2
 VMJA==
X-Gm-Message-State: AOAM5319IOI325IF6511VxmpcFyLrKKPyhTZhJmqWaTmqVTj/+6L0blz
 FzT0GLSbu95y2lxsU0Q0w0V5rZQ9jTYgUP/p+y28YW4XYKR95jQxmmQdrXuTLF7m8eYtxTRbQnO
 RGVyT8/WF5rdn8p9BiGtJ0Lf6jabzUs6gMJ1bCxSFXEfDWJx9Nzo9gaIGQXgA2Od/9iG7zA==
X-Google-Smtp-Source: ABdhPJwhlUbmJ/c+5cel5YbXwoabm+ZFEQDGUQzmk+0Grk7pE6oPCjZRhL0uNrGXFbrQzfvJ7uRjCYQnx/8=
X-Received: from oupton3.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a17:90a:5407:b0:1bf:43ce:f11b with SMTP id
 z7-20020a17090a540700b001bf43cef11bmr3031142pjh.31.1651557734948; Mon, 02 May
 2022 23:02:14 -0700 (PDT)
Date: Tue,  3 May 2022 06:02:02 +0000
In-Reply-To: <20220503060205.2823727-1-oupton@google.com>
Message-Id: <20220503060205.2823727-5-oupton@google.com>
Mime-Version: 1.0
References: <20220503060205.2823727-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v4 4/7] KVM: arm64: Plumb cp10 ID traps through the AArch64
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
2.36.0.464.gb9c8b46e94-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
