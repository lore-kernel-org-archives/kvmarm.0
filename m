Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFBA3C433FE
	for <kvmarm@archiver.kernel.org>; Fri,  1 Apr 2022 01:08:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 62A024B208;
	Thu, 31 Mar 2022 21:08:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id i9jXjizvH3SI; Thu, 31 Mar 2022 21:08:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 17F8D4B26E;
	Thu, 31 Mar 2022 21:08:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D6EFC4B20D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Mar 2022 21:08:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KZRzuj8IPNOb for <kvmarm@lists.cs.columbia.edu>;
 Thu, 31 Mar 2022 21:08:40 -0400 (EDT)
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com
 [209.85.166.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9F2E64B20B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Mar 2022 21:08:40 -0400 (EDT)
Received: by mail-il1-f201.google.com with SMTP id
 v15-20020a056e0213cf00b002c9f78d2e9bso918625ilj.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Mar 2022 18:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=tJKETW3xC0BA9np6sF82o0D7VasG3t942AJvWUmRnxU=;
 b=B/bXvY56GF5eO60/AO8lEUgQFJfWtls40z9XRuLlPmxguRmB8w2/FpZzax/3GNrjRc
 ukF7d5ZHPQjd6RYHqYHeC7Zjy564byyQSOD5tQPAPxwNmaj7tJsEynwunCEH8Uq0Cjb3
 Gi6kbafnhqwWOyqHmrwWksRvh8k/6paDxV0cmW2fdyaAk6pdsMTs4Yi48DruyAWjoh5p
 JNT1RLkBNzady2pf9dFs3BkH3mMVa5OQ5tQR1Gwc1b/sYkudGglqnA7MS+xbBh98FYXb
 zey3LuEc/Bulv23bs4PPNnqsrdh4QhMHT3qwmbo5QVFDwybrdiyDYP6pLpUc55RSR0UY
 p4ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=tJKETW3xC0BA9np6sF82o0D7VasG3t942AJvWUmRnxU=;
 b=0MCkczPihzP/4qrvzPHlNLWG5oz3GMOqF19e9N2IknNvyo/CAErAV80HCeJYLzsvQa
 RVmA7bQUeX4yPE2z820wyC8cy9Vs6O0SvbLUr2QEmHrmoPHHs4Wpy9eA0C4unyhgsHRV
 Vw9hENS5PnKMBcS9+/pMTvIiYJf+ZdnmfUhxofmV17JDLLATmE1DAxzTfjnENQKWM/1r
 gzbN0F9wXShkspL1+BCoKaj0cemeTasDhETC4DQ18aPVy4bZESXCv7qL5CagaFuOIvlm
 p3EMdDcXYZtEYXU/tUEa5IYTEFttB2Qizhg+TLNHgkYf87KaYml9L5e2ngPnaVxwbe3e
 NVxA==
X-Gm-Message-State: AOAM531CewcV1w3HDLRLD/r7wT12DnhQYPoX0MO6uauo0kAcXy8t2lNP
 c223IoR6YHZWojadr4Lqhhlyltb3cZMuskk2G34Iy1aoFAQcCnif326HRShRRXT/VMS4oCy8+n/
 nge21+xthMurMEMh04f6ecqIJ9AxEwKNAF/RNQpRA8HN+7A1Dz8RvbiEL8kI24vrJSzKw+g==
X-Google-Smtp-Source: ABdhPJxCK1k5vsp5pXgoijRpo+sfq7iPlp4iAm1skz8UP7VT6maiDL0AWUWXA5ZTagCZ+WJJQ+61SWOGI6s=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6638:22cd:b0:31a:4e2a:25b9
 with SMTP id
 j13-20020a05663822cd00b0031a4e2a25b9mr4345510jat.57.1648775320066; Thu, 31
 Mar 2022 18:08:40 -0700 (PDT)
Date: Fri,  1 Apr 2022 01:08:30 +0000
In-Reply-To: <20220401010832.3425787-1-oupton@google.com>
Message-Id: <20220401010832.3425787-2-oupton@google.com>
Mime-Version: 1.0
References: <20220401010832.3425787-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v2 1/3] KVM: arm64: Wire up CP15 feature registers to their
 AArch64 equivalents
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

KVM currently does not trap ID register accesses from an AArch32 EL1.
This is painful for a couple of reasons. Certain unimplemented features
are visible to AArch32 EL1, as we limit PMU to version 3 and the debug
architecture to v8.0. Additionally, we attempt to paper over
heterogeneous systems by using register values that are safe
system-wide. All this hard work is completely sidestepped because KVM
does not set TID3 for AArch32 guests.

Fix up handling of CP15 feature registers by simply rerouting to their
AArch64 aliases. Punt setting HCR_EL2.TID3 to a later change, as we need
to fix up the oddball CP10 feature registers still.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/sys_regs.c | 68 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index dd34b5ab51d4..8b791256a5b4 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2339,6 +2339,67 @@ static int kvm_handle_cp_64(struct kvm_vcpu *vcpu,
 	return 1;
 }
 
+static int emulate_sys_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *params);
+
+/**
+ * kvm_emulate_cp15_id_reg() - Handles an MRC trap on a guest CP15 access where
+ *			       CRn=0, which corresponds to the AArch32 feature
+ *			       registers.
+ * @vcpu: the vCPU pointer
+ * @params: the system register access parameters.
+ *
+ * Our cp15 system register tables do not enumerate the AArch32 feature
+ * registers. Conveniently, our AArch64 table does, and the AArch32 system
+ * register encoding can be trivially remapped into the AArch64 for the feature
+ * registers: Append op0=3, leaving op1, CRn, CRm, and op2 the same.
+ *
+ * According to DDI0487G.b G7.3.1, paragraph "Behavior of VMSAv8-32 32-bit
+ * System registers with (coproc=0b1111, CRn==c0)", read accesses from this
+ * range are either UNKNOWN or RES0. Rerouting remains architectural as we
+ * treat undefined registers in this range as RAZ.
+ */
+static int kvm_emulate_cp15_id_reg(struct kvm_vcpu *vcpu,
+				   struct sys_reg_params *params)
+{
+	int Rt = kvm_vcpu_sys_get_rt(vcpu);
+	int ret = 1;
+
+	/* Treat impossible writes to RO registers as UNDEFINED */
+	if (params->is_write) {
+		unhandled_cp_access(vcpu, params);
+		return 1;
+	}
+
+	params->Op0 = 3;
+
+	/*
+	 * All registers where CRm > 3 are known to be UNKNOWN/RAZ from AArch32.
+	 * Avoid conflicting with future expansion of AArch64 feature registers
+	 * and simply treat them as RAZ here.
+	 */
+	if (params->CRm > 3)
+		params->regval = 0;
+	else
+		ret = emulate_sys_reg(vcpu, params);
+
+	vcpu_set_reg(vcpu, Rt, params->regval);
+	return ret;
+}
+
+/**
+ * kvm_is_cp15_id_reg() - Returns true if the specified CP15 register is an
+ *			  AArch32 ID register.
+ * @params: the system register access parameters
+ *
+ * Note that CP15 ID registers where CRm=0 are excluded from this check. The
+ * only register trapped in the CRm=0 range is CTR, which is already handled in
+ * the cp15 register table.
+ */
+static inline bool kvm_is_cp15_id_reg(struct sys_reg_params *params)
+{
+	return params->CRn == 0 && params->Op1 == 0 && params->CRm != 0;
+}
+
 /**
  * kvm_handle_cp_32 -- handles a mrc/mcr trap on a guest CP14/CP15 access
  * @vcpu: The VCPU pointer
@@ -2360,6 +2421,13 @@ static int kvm_handle_cp_32(struct kvm_vcpu *vcpu,
 	params.Op1 = (esr >> 14) & 0x7;
 	params.Op2 = (esr >> 17) & 0x7;
 
+	/*
+	 * Certain AArch32 ID registers are handled by rerouting to the AArch64
+	 * system register table.
+	 */
+	if (ESR_ELx_EC(esr) == ESR_ELx_EC_CP15_32 && kvm_is_cp15_id_reg(&params))
+		return kvm_emulate_cp15_id_reg(vcpu, &params);
+
 	if (!emulate_cp(vcpu, &params, global, nr_global)) {
 		if (!params.is_write)
 			vcpu_set_reg(vcpu, Rt, params.regval);
-- 
2.35.1.1094.g7c7d902a7c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
