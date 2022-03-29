Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92482C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 29 Mar 2022 01:13:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 36AA74B15C;
	Mon, 28 Mar 2022 21:13:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fKDoGS9hgCd8; Mon, 28 Mar 2022 21:13:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3798E4B187;
	Mon, 28 Mar 2022 21:13:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 48A684B187
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Mar 2022 21:13:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hGUkWIYF1d-3 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Mar 2022 21:13:11 -0400 (EDT)
Received: from mail-il1-f202.google.com (mail-il1-f202.google.com
 [209.85.166.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 06DDD4B0B8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Mar 2022 21:13:10 -0400 (EDT)
Received: by mail-il1-f202.google.com with SMTP id
 o17-20020a92c691000000b002c2c04aebe7so8766323ilg.8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Mar 2022 18:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=htFRtOyZ6uolAOd+Si3+5Uh8OfwPEQrnbEsfTJih2b0=;
 b=Vgd7moNsWmoGoWT3hkitkk2U6NneUuTDgwg+dc2HeyQxPq+N2vDMHohiU9BHi+m0ID
 kAluu2Wy1zDXo0RVwcP9tKg6naMo8Ox8UJ0pCGBvD1O3iX5j3KrAQ+N58hStq4LFCdo0
 fW8SzSj/Xg5vUfaEH91Ns3qWyrQbkkMhkTYyzDVAyAc2JF7yhw/GpYUqYS05aRLwD18X
 hRAWlvsswDKhW1Wj2N3AIOTmm//8NOdh5K5Xl+DC+/FJ/z+L3pjarnT12AA3K0R5gGYa
 eshrwN4aDKduvxbSeuWM+SFxwIsTVDllLn5CBr5z92gWE6PToQ9OIcnyvE1fesiOvi31
 bgTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=htFRtOyZ6uolAOd+Si3+5Uh8OfwPEQrnbEsfTJih2b0=;
 b=FqLmETTiYcYVmedRoJ1+LjNTnVlReJp0QJ1mcHhlbP0Jx25A1brg2LyHXPENmK+Ysl
 AWc+qThFIf+pbw0AkfucSvkzb6V3svPXM7JCwFpQzMAKbZJ0Googc43RYjNplNoQc/dQ
 mHO+b6H5MSRgFM/1sbgjAFdGCpXR2D2xDJ0jCEXoQQLrwpF9oHb45qtD9L1HOlQ0rawV
 Aoi/pzxuEQyPI2wtpLUcgCo5z3hj3apNmGxBB9APXjr7pdtNlsaG7eNM8PbBEVv8AmKk
 nC+YPJTItdQljo6UicLV1zAeVhqt8Fz5TwqbDxHsOKa/Vz+9WX1CthyhuO/eF9AHvZpT
 Bqgw==
X-Gm-Message-State: AOAM532RSstsPrQKh9d6CwYnw6gnudkdEz+qG7LO9HZ+6LAm1rn5j2wd
 DhFvtWbbQu0HWc9tfp8eUhTgNGlgfYjzzEdbrYT6tM7SXxivxff5blBm7mp/aWL/a1jF83wYk8t
 y37cjC6Ikgg9uQDzeq09XkeMaI7/Gx7TAvd7B339l8oqjGUGa3sHQ5TS96n9ZciDvxABICA==
X-Google-Smtp-Source: ABdhPJx9kYVH6UxwFrBRPPnEgN4FD1oy0p4csE/CGQ+j8IF62YSB8Yf55th8evusYewf+f0N/Kbur7dmQig=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6638:388f:b0:321:523d:4449
 with SMTP id
 b15-20020a056638388f00b00321523d4449mr14926113jav.276.1648516390091; Mon, 28
 Mar 2022 18:13:10 -0700 (PDT)
Date: Tue, 29 Mar 2022 01:12:59 +0000
In-Reply-To: <20220329011301.1166265-1-oupton@google.com>
Message-Id: <20220329011301.1166265-2-oupton@google.com>
Mime-Version: 1.0
References: <20220329011301.1166265-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
Subject: [PATCH 1/3] KVM: arm64: Wire up CP15 feature registers to their
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
 arch/arm64/kvm/sys_regs.c | 66 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index dd34b5ab51d4..30771f950027 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2339,6 +2339,65 @@ static int kvm_handle_cp_64(struct kvm_vcpu *vcpu,
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
+	/* Treat impossible writes to RO registers as UNDEFINED */
+	if (params->is_write)
+		unhandled_cp_access(vcpu, params);
+	else
+		vcpu_set_reg(vcpu, Rt, params->regval);
+
+	return ret;
+}
+
+/**
+ * kvm_is_cp15_id_reg() - Returns true if the specified CP15 register is an
+ *			  AArch32 ID register.
+ * @params: the system register access parameters
+ *
+ * Note that CP15 ID registers where CRm=0 are excluded from this check, as they
+ * are already correctly handled in the CP15 register table.
+ */
+static inline bool kvm_is_cp15_id_reg(struct sys_reg_params *params)
+{
+	return params->CRn == 0 && params->Op1 == 0 && params->CRm != 0;
+}
+
 /**
  * kvm_handle_cp_32 -- handles a mrc/mcr trap on a guest CP14/CP15 access
  * @vcpu: The VCPU pointer
@@ -2360,6 +2419,13 @@ static int kvm_handle_cp_32(struct kvm_vcpu *vcpu,
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
2.35.1.1021.g381101b075-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
