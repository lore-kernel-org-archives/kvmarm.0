Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC52FC433FE
	for <kvmarm@archiver.kernel.org>; Mon, 25 Apr 2022 23:53:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F1AE4B183;
	Mon, 25 Apr 2022 19:53:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6nUk95rBvEsL; Mon, 25 Apr 2022 19:53:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 25C714B1A2;
	Mon, 25 Apr 2022 19:53:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 593114B159
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 19:53:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LFtsBVK5BuNi for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Apr 2022 19:53:50 -0400 (EDT)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 000D949EDF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 19:53:48 -0400 (EDT)
Received: by mail-pl1-f202.google.com with SMTP id
 i10-20020a1709026aca00b00158f14b4f2fso10309857plt.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 16:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=QZV9K9pshxsZaFz07eLh3A0iu/mpSkO/sGN/L0MnWRg=;
 b=BGaHIHlNvrPvSybSjzu/EsScWWrF5JLyW44N9iVFpCsDI4RdR4s5jaapPfFEF051xW
 uEl4LqPlnkp/TPbtE9AfoBR2OdWBduFArF5HPtPGq5pheLGAnnSS5+TJsEG3ax6YQLwx
 P0TPB928oo6rvMj5jIBdctRMs49ipSURFvV/E3nDJp5V90u6hvooBa1Om8DpZMBl0S4+
 NX+Soe17zx7HmGHAEcWZddf4lXIveePE6XBo68a7E0rDwhmR70ISpml+9N0JgZDTfnDu
 wYXK49IqiRFEpyEx6EoYdf/DQhVkPfW0AgNYPYqMHLa3siDY+/k0AIEagxJQzOSK0jwa
 RYig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=QZV9K9pshxsZaFz07eLh3A0iu/mpSkO/sGN/L0MnWRg=;
 b=PJbse4cnPK+h3P5B5/DEKPTA0ao96TFXQiIjwPoEluRxzgC+m3CxiHzZVQmJkIPIKC
 NtsjoDNMZXLD9Bd2FxQC3hX0qQDfYwueWWrHSlwaqoJfwWZiAEFEjzl2s6isNxQ8frXm
 Z++fTUDUu9tVfuR2xIMtCfa9RWUW5UQckqSMtUz/UIS7ELwJ/V1FAEiTba/1pDEwAwT7
 71WG1jthnE1E64x3f0olYmDMzczo5fu3XcoEB6sUfo4+AZpgEhnNTOY13q7abzblbthy
 HTWI89OKraRlm1DlngaiQ8qk4kwP5NUcQqRbHRq40RgPwdA5TRqB+kqfpZEjfuDlWQAV
 uX4g==
X-Gm-Message-State: AOAM531dBP6iLdLLcquRG2bAErqq0iP6FoVzLk4RpZV8jyZQiVqg/ljK
 SAgb8xT4zBOp7yAwycqj/sV2nF2xWNtAVGhmcE9iWbCBGmVPFJW3Eh6e3b6Byj6EUUVdOlKsKBH
 3TpJRs/VXTC4dT7OmD1gUepQQiaMHWWm+xVGte1rT2aeHLqO/oGsgpwNqQkQYcJkr8f8pHA==
X-Google-Smtp-Source: ABdhPJz3d1qm5YaR40k8hHxXiIU3PFGNzDxiDIEVI2CGNmaGlbR+i/rQymo4a2m1+vruLE2lWlAKZfM3Z2c=
X-Received: from oupton3.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a17:90b:2249:b0:1d9:859e:59ad with SMTP id
 hk9-20020a17090b224900b001d9859e59admr5995203pjb.16.1650930827793; Mon, 25
 Apr 2022 16:53:47 -0700 (PDT)
Date: Mon, 25 Apr 2022 23:53:39 +0000
In-Reply-To: <20220425235342.3210912-1-oupton@google.com>
Message-Id: <20220425235342.3210912-3-oupton@google.com>
Mime-Version: 1.0
References: <20220425235342.3210912-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v3 2/5] KVM: arm64: Don't write to Rt unless sys_reg emulation
 succeeds
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

emulate_sys_reg() returns 1 unconditionally, even though a a system
register access can fail. Furthermore, kvm_handle_sys_reg() writes to Rt
for every register read, regardless of if it actually succeeded.

Though this pattern is safe (as params.regval is initialized with the
current value of Rt) it is a bit ugly. Indicate failure if the register
access could not be emulated and only write to Rt on success.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/sys_regs.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 36895c163eae..f0a076e5cc1c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2401,7 +2401,14 @@ static bool is_imp_def_sys_reg(struct sys_reg_params *params)
 	return params->Op0 == 3 && (params->CRn & 0b1011) == 0b1011;
 }
 
-static int emulate_sys_reg(struct kvm_vcpu *vcpu,
+/**
+ * emulate_sys_reg - Emulate a guest access to an AArch64 system register
+ * @vcpu: The VCPU pointer
+ * @params: Decoded system register parameters
+ *
+ * Return: true if the system register access was successful, false otherwise.
+ */
+static bool emulate_sys_reg(struct kvm_vcpu *vcpu,
 			   struct sys_reg_params *params)
 {
 	const struct sys_reg_desc *r;
@@ -2410,7 +2417,10 @@ static int emulate_sys_reg(struct kvm_vcpu *vcpu,
 
 	if (likely(r)) {
 		perform_access(vcpu, params, r);
-	} else if (is_imp_def_sys_reg(params)) {
+		return true;
+	}
+
+	if (is_imp_def_sys_reg(params)) {
 		kvm_inject_undefined(vcpu);
 	} else {
 		print_sys_reg_msg(params,
@@ -2418,7 +2428,7 @@ static int emulate_sys_reg(struct kvm_vcpu *vcpu,
 				  *vcpu_pc(vcpu), *vcpu_cpsr(vcpu));
 		kvm_inject_undefined(vcpu);
 	}
-	return 1;
+	return false;
 }
 
 /**
@@ -2446,18 +2456,18 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu)
 	struct sys_reg_params params;
 	unsigned long esr = kvm_vcpu_get_esr(vcpu);
 	int Rt = kvm_vcpu_sys_get_rt(vcpu);
-	int ret;
 
 	trace_kvm_handle_sys_reg(esr);
 
 	params = esr_sys64_to_params(esr);
 	params.regval = vcpu_get_reg(vcpu, Rt);
 
-	ret = emulate_sys_reg(vcpu, &params);
+	if (!emulate_sys_reg(vcpu, &params))
+		return 1;
 
 	if (!params.is_write)
 		vcpu_set_reg(vcpu, Rt, params.regval);
-	return ret;
+	return 1;
 }
 
 /******************************************************************************
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
