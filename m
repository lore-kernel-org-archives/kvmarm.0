Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9302EC433EF
	for <kvmarm@archiver.kernel.org>; Tue,  3 May 2022 06:02:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 125174B1BA;
	Tue,  3 May 2022 02:02:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id puK49zOHWvLi; Tue,  3 May 2022 02:02:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D30DB4B20A;
	Tue,  3 May 2022 02:02:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B44834B1AD
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 02:02:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pzYAGj91f4Yf for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 May 2022 02:02:12 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 501924B1E9
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 02:02:12 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-2f16f3a7c34so152351867b3.17
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 May 2022 23:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=XfyYlyiUJYzy5P/tDVrVjfvZblAQAF1Q2S7Fvl/b6ww=;
 b=pYELEqhevmMMRFuo6qeYvGhQHMgyHNM/ESphHsgQXBuoLUhwPjQueCU9NdIhTEYN8N
 8W8v0dnP2cnMGt/b+WnLn01n5KQq42//Qvk2HBXynA1bEfwIQfS8Qkhj2p4dkqNoXfQH
 wqrylyW+j6Gl8pjO68sPlrX7IiHYeSqO175EJk/57UAcuf5T+HYmABQVaLjL9lqd5qtm
 pKPwShW6lKIAhihNqdN0tn2BSgEHWvGNuXgBIUwL6Pem5qetdQuitxp7jG4ma9Ofk8fA
 PW7Hcuy1Jty7yE2xNwjGi9tuQNAgir2JRejlGnd/xz0VkWs0glMJFZD4f4dDTBW+XQzw
 nR6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=XfyYlyiUJYzy5P/tDVrVjfvZblAQAF1Q2S7Fvl/b6ww=;
 b=esnXXOPn7aZOLJ33b8LOAWnhLGrhAS+QDlAk4PKAHEJbwNdxWtokl/NKGFchXVPKch
 fl5ngPxSDsLEnL5jXU5Z4PMI7jQPKLjEomcRUaouin704jYQwnt2zK6G764SNrW8GU+/
 ZAU3DwuckVA9m1T4BUUKos+E3kdXsg8K+qAzr9HZAvkctik6ItNOddA13hAmYQtd5lEn
 +LUlS0qlUzxIJMhGuh3Qiz5/Yg7zDwKYlGOM6mFSaN4qld4YnREdyGoDcJRPQmjLmHk/
 DLikGrQoJruaCfi18JW+QS5w0/nf+L+KZDIBJlM4l63dxIMAjK464yc81NKcZ6xYWzMj
 lgDw==
X-Gm-Message-State: AOAM533nFtIKZSHaY/85zyCj7YikdQ1kaGX1293YzoTEiUWXoNwkQTSS
 XBCJVLSGLxmVoLeVRaZf4P5XsPudiX57QFSsyHG/0J5hUYWigK4ZX+CPP7OJZdx52+TEzlctV0Z
 5QLSE3lnu20VDv3ISBm+VtTQS0iIsUxR6gaoUi0sOPtlv/DQc3V7aU+P5jidbzdYIF+k3JA==
X-Google-Smtp-Source: ABdhPJzWMTJ9eoHCayt8gdpKf+kTy89PEfM2q9IK/XBP9Olgr+AMTdtkI9bHjeCPHU8wQk/OhYk/vEOyRCc=
X-Received: from oupton3.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a25:74d4:0:b0:646:cfd6:daa3 with SMTP id
 p203-20020a2574d4000000b00646cfd6daa3mr12728747ybc.235.1651557731765; Mon, 02
 May 2022 23:02:11 -0700 (PDT)
Date: Tue,  3 May 2022 06:02:00 +0000
In-Reply-To: <20220503060205.2823727-1-oupton@google.com>
Message-Id: <20220503060205.2823727-3-oupton@google.com>
Mime-Version: 1.0
References: <20220503060205.2823727-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v4 2/7] KVM: arm64: Don't write to Rt unless sys_reg emulation
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
2.36.0.464.gb9c8b46e94-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
