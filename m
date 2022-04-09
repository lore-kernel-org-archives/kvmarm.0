Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8E19C433F5
	for <kvmarm@archiver.kernel.org>; Sat,  9 Apr 2022 18:46:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CA1249F11;
	Sat,  9 Apr 2022 14:46:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id H+5uk7S-o9u4; Sat,  9 Apr 2022 14:46:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C9694B159;
	Sat,  9 Apr 2022 14:46:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 26EDD4B0ED
 for <kvmarm@lists.cs.columbia.edu>; Sat,  9 Apr 2022 14:46:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dNI0-s0vPGuq for <kvmarm@lists.cs.columbia.edu>;
 Sat,  9 Apr 2022 14:46:01 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2704E4B0C5
 for <kvmarm@lists.cs.columbia.edu>; Sat,  9 Apr 2022 14:46:01 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 o71-20020a25d74a000000b006410bd28f4eso3465404ybg.3
 for <kvmarm@lists.cs.columbia.edu>; Sat, 09 Apr 2022 11:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=DMzmQt8j2gXQ34IYdSrbWnWZ1QMlmXcDpNCPmrEOebY=;
 b=NG4TL6XT7gnV8l/zru+9eN9qrrveBeZGlb+4CWYOSECMBCtX7Hh1T+caa19frZuH1p
 +EA32ATnD+LOjuqKUOrMj5mole9xDSK7al5vTLca3jkuvUixfPgRmo4zu387CynwlrM0
 F0aiMvjaakbeWQJoqYsS+ah6NDOlz4UQmiNXUo5rhvPbIf50TR8UcyGVaTTl/MJyA5EW
 O5SxEhj/ROxyychujtu+2H6CL78ZN6uaJsp7y0QTMLk1lCV7AZr8XZhQwDntBC31x2+X
 fKYZneniAdLL0ybiDSFJxy86ObDJB9vAmGWp/0FgXANDHeZH1cPkBoEoMfhjuqNJ/pNM
 GWEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=DMzmQt8j2gXQ34IYdSrbWnWZ1QMlmXcDpNCPmrEOebY=;
 b=u5aFnl35BJJy5qyHqfOMFi6tWu2eUJTCKgYePXjuTA5fMw6WmObdwOvK0+xsrvnjJ1
 20XDApKns8G3r7TF/9eGql6qj+w/G2uzQ9y+EsGIIX5gWX+s3thupuCkQ7ajlE9aFOpy
 8A1kOV5XGxxAgd4MglP9XSSiege970PvSD9mRk5dvfuUq8x2S7A+6+E3G4vAUJJbtMPT
 RC7YxpGAW7ef/QnEMychKvt1fkYWS6yKGP+2OTlIPASzNeQUmA5C2uopVGNke2++EwEh
 ki2TX/KrHbzMFygYctRsI1oAQwc159dL4QpeT1Lnh7N0ZMTrxZk5szfeeq+D5QP5ufcb
 tsJA==
X-Gm-Message-State: AOAM531TLy8R5p03m+oWGkD8VGdIcOjN1XNTeg/nswZSY0SO1OFkjHlF
 PAIFo9H6GhOKlQB4almbhYJJEZfx+a877Jt63apq4i7j+uNZCrJiAHirVmKWdXSklvYky9aPrZ3
 U8q+9eTwM/o8tBqszsi+ywXDX7nKvd9ldV5tAfYmcPakCxSuR+Il8kWQhuq++fsf44zJwBw==
X-Google-Smtp-Source: ABdhPJwb/utx76+XP84h3iTnGw5IeZy4uquOiqucLInRckn7SQuOn6r08CCG2JkrbHBFJs03Kgcgly9FTkM=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:59c3:0:b0:63d:8ccc:37b0 with
 SMTP id
 n186-20020a2559c3000000b0063d8ccc37b0mr17865179ybb.612.1649529960409; Sat, 09
 Apr 2022 11:46:00 -0700 (PDT)
Date: Sat,  9 Apr 2022 18:45:37 +0000
In-Reply-To: <20220409184549.1681189-1-oupton@google.com>
Message-Id: <20220409184549.1681189-2-oupton@google.com>
Mime-Version: 1.0
References: <20220409184549.1681189-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v5 01/13] KVM: arm64: Don't depend on fallthrough to hide
 SYSTEM_RESET2
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, wanpengli@tencent.com, kvm@vger.kernel.org, joro@8bytes.org,
 pshier@google.com, kvm-riscv@lists.infradead.org, atishp@atishpatra.org,
 pbonzini@redhat.com, vkuznets@redhat.com, jmattson@google.com
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

Depending on a fallthrough to the default case for hiding SYSTEM_RESET2
requires that any new case statements clean up the failure path for this
PSCI call.

Unhitch SYSTEM_RESET2 from the default case by setting val to
PSCI_RET_NOT_SUPPORTED outside of the switch statement. Apply the
cleanup to both the PSCI_1_1_FN_SYSTEM_RESET2 and
PSCI_1_0_FN_PSCI_FEATURES handlers.

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/psci.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index baac2b405f23..3d43350ffb07 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -304,9 +304,9 @@ static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
 
 static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
 {
+	unsigned long val = PSCI_RET_NOT_SUPPORTED;
 	u32 psci_fn = smccc_get_function(vcpu);
 	u32 arg;
-	unsigned long val;
 	int ret = 1;
 
 	switch(psci_fn) {
@@ -319,6 +319,8 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
 		if (val)
 			break;
 
+		val = PSCI_RET_NOT_SUPPORTED;
+
 		switch(arg) {
 		case PSCI_0_2_FN_PSCI_VERSION:
 		case PSCI_0_2_FN_CPU_SUSPEND:
@@ -337,13 +339,8 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
 			break;
 		case PSCI_1_1_FN_SYSTEM_RESET2:
 		case PSCI_1_1_FN64_SYSTEM_RESET2:
-			if (minor >= 1) {
+			if (minor >= 1)
 				val = 0;
-				break;
-			}
-			fallthrough;
-		default:
-			val = PSCI_RET_NOT_SUPPORTED;
 			break;
 		}
 		break;
@@ -364,7 +361,7 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
 			val = PSCI_RET_INVALID_PARAMS;
 			break;
 		}
-		fallthrough;
+		break;
 	default:
 		return kvm_psci_0_2_call(vcpu);
 	}
-- 
2.35.1.1178.g4f1659d476-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
