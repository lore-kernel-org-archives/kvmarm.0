Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 927C4C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  4 May 2022 03:25:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F36664B0F7;
	Tue,  3 May 2022 23:25:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gR7QFzCQSFrB; Tue,  3 May 2022 23:24:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8230C4B152;
	Tue,  3 May 2022 23:24:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A9D2A49F38
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 23:24:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BwFhCkdMTrkX for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 May 2022 23:24:56 -0400 (EDT)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 92C1F49EE3
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 23:24:56 -0400 (EDT)
Received: by mail-pl1-f201.google.com with SMTP id
 u18-20020a170902e21200b0015e5e660618so144642plb.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 03 May 2022 20:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=UE0HcXTxgX958/wjfkT/IQbNNoXqwMiaNuwDtFEI/7w=;
 b=KIkwxXGDCX2GNwXt49UEWppqkI7IuskxNWAKGQOf+GUm67FzQ0X1o25H3Jno+gfiQ6
 CX+0aLwHtRTaNLQs29WkmCJMoWyaOkjQqIWLpSwPP7wG0/CdKC1mqFIHVqsIJk4Y2Yfc
 KnziFWF/93i9FsyNJbcWs8Pf8x+QTHGpT4DXq1tcxC4vMfc7g347aVmL63yjmqaZNb+h
 lDhMlK7TwEMCTXURJiwbX2D8ZDAMyFwyWizp6BtKadlBYfWFMqjwV34OBer2HNf+ygVM
 m9DJ4/oVnjPeZVtsTl6/6i7FQ5jr1pUrX9agQOX1Y0A/XyVBjSCVeyph5Hfw3piovqnt
 LbnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=UE0HcXTxgX958/wjfkT/IQbNNoXqwMiaNuwDtFEI/7w=;
 b=eh6JwB68VhmKqzvp/JWchtXgRh3PP+EpQeoq4I/XTl9HhI4NoOlyXRb2VNrCe0MrBm
 FEkTTDx2rx5qCt7Ub6KBgfKTK7fi7suqIZ9OquOFEsyXcOLKjfJ63h1jcC7YaEZ+Z2J9
 A436hodH2hgV2+lIj0ffODjs7p24cJ2JRXQeAZVrR/Kxrj4azg8rYp8KvZVGo0IVbKkJ
 qoiMe4pZJ99s/YCuBtotM9H7VIYdqux0ipvgSk8xQKY5pNcRiueJBiWggBNvKOqF+yJf
 lb3WKL0bii9LCP9NPvONUP02ZQxEcrnsoedXZ/te3da0PSUf7RjgMAupePW7lw7T1C6a
 aA/w==
X-Gm-Message-State: AOAM531mzGvO+2UcxLx2Ed0QIxoBjxw+i2o9lA+u8tRJIeBphXWQwElZ
 Bol1JuQuikI5rANMWmVQsHSYTtAtLaVNA/lf94u5RHn+QbcQyQl1G53D84OSTNlRhTAHlEXvULD
 Y5itrzehHbpEy8PbctKcDFw/9iGSoZR39GUdzbu14iUncjAllSHLjFheJ095d0/tM/Fu5qw==
X-Google-Smtp-Source: ABdhPJyd1Jxi1pP3kjM7I5iyXKCDdQGPA7cTg9gLCDVjhwSerOtbMrOWP35WmZ55PAcThzOFr0nC8wgJPwQ=
X-Received: from oupton3.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a17:902:db05:b0:15e:b542:3f23 with SMTP id
 m5-20020a170902db0500b0015eb5423f23mr7097374plx.143.1651634695538; Tue, 03
 May 2022 20:24:55 -0700 (PDT)
Date: Wed,  4 May 2022 03:24:35 +0000
In-Reply-To: <20220504032446.4133305-1-oupton@google.com>
Message-Id: <20220504032446.4133305-2-oupton@google.com>
Mime-Version: 1.0
References: <20220504032446.4133305-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v6 01/12] KVM: arm64: Don't depend on fallthrough to hide
 SYSTEM_RESET2
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

Depending on a fallthrough to the default case for hiding SYSTEM_RESET2
requires that any new case statements clean up the failure path for this
PSCI call.

Unhitch SYSTEM_RESET2 from the default case by setting val to
PSCI_RET_NOT_SUPPORTED outside of the switch statement. Apply the
cleanup to both the PSCI_1_1_FN_SYSTEM_RESET2 and
PSCI_1_0_FN_PSCI_FEATURES handlers.

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/psci.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 708d80e8e60d..67fbd6ef022c 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -305,9 +305,9 @@ static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
 
 static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
 {
+	unsigned long val = PSCI_RET_NOT_SUPPORTED;
 	u32 psci_fn = smccc_get_function(vcpu);
 	u32 arg;
-	unsigned long val;
 	int ret = 1;
 
 	switch(psci_fn) {
@@ -320,6 +320,8 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
 		if (val)
 			break;
 
+		val = PSCI_RET_NOT_SUPPORTED;
+
 		switch(arg) {
 		case PSCI_0_2_FN_PSCI_VERSION:
 		case PSCI_0_2_FN_CPU_SUSPEND:
@@ -338,13 +340,8 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
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
@@ -365,7 +362,7 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
 			val = PSCI_RET_INVALID_PARAMS;
 			break;
 		}
-		fallthrough;
+		break;
 	default:
 		return kvm_psci_0_2_call(vcpu);
 	}
-- 
2.36.0.464.gb9c8b46e94-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
