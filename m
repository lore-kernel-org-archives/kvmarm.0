Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CA41C43217
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 17:41:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FFAF40BD3;
	Fri, 11 Mar 2022 12:41:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZrSVbglK-9Hq; Fri, 11 Mar 2022 12:41:08 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D3DE343479;
	Fri, 11 Mar 2022 12:41:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F33FC40C10
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 12:41:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5e29-YCAWiQE for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Mar 2022 12:41:06 -0500 (EST)
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com
 [209.85.166.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D4D9440E00
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 12:41:04 -0500 (EST)
Received: by mail-io1-f73.google.com with SMTP id
 e27-20020a056602045b00b00645bd576184so6767790iov.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 09:41:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=/OTsX1zNy9viFOplBNYstPkRDHNcJFJG5fv5Uk1YQKg=;
 b=KhxDlCEP7i5pg+TPes7A4wiJybDXQnCja8W3xvkSNQF7H3DtgDmlWLCoPooaX4bWcG
 jNjBUpUgA/81YMzi2tT8kBAhg20V3w9qA9irPbwHGRIXeiq9EJ+WSw5f9HuvIqUXXN9i
 Q+H4xiqVVwfMuHybjREevMIZdBqDFKe2FTk7Pp5DEGVxYYxe14uDne8K+0kcHNNhWp8V
 7qNrsuG+AJ3rzAuEf2KGaUWJQa0yZiIkpi1Ho3pU7bMqDx2LXIRKFsK5fYO7KJROHDME
 SH3KK9Zmp7xrdleqoXvSOFBiVC9i9SvtKoEtKPIhJMGe6wzm3Tx2epfNkQolsZ+pWKyY
 0Diw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=/OTsX1zNy9viFOplBNYstPkRDHNcJFJG5fv5Uk1YQKg=;
 b=wjDqgs3aeAfZSVgiayV1OAroONBh1fAIVJiPPXz9SYuJiTPWTzKLAjOwsE6aVd9mK6
 PQeCy+z5Yd6oldJX3U5d+/a0N0yboHj8BNOL0r2X+HSRM/WywjGtNcd4GEOrA4z2MIC1
 pDoG/6qgC6qRtm6u+phspe62Q80Y0yJE1BlFukgwc4TQkUrza+OpZwpicuuivnqekSfB
 QIvS1c5DaevoyxG0elI+urf7H4tyJN62uRgt1iDb8Tlo+kOz3fJWqg+X8HzTZenFddDw
 qaLDonUYhDn/YmVzlCQ2Pe0oGSQG/bI/1eFAKGXeUumB+xwbHTHCEguZtZ5jWvhCKPRG
 oJoQ==
X-Gm-Message-State: AOAM530yJ6DYjkwhww+SYAYHRbWuu8WjVtp0vuB4rmfgrjcp0mgPo3aI
 PTQIo1sMw4bIlBVNx0P1AEOiTLAfoE3QfH/j4PEnojR6AtjjNysIUWwColwnOohDUDxTY8e9lfP
 M+2p0v55teyM4pqR9KEH8FI0YkdtMv1EQnHYmExDO9H4en5xJd1F4lZ3NhJ7o9c6WBNEUlg==
X-Google-Smtp-Source: ABdhPJwKry5EljdgitptBSCjxFA/9c5/1sGuFjMs3bGcqzT+eXHRrSrwo4UcxHiZrrN7ePcMplZ7dnDcXOQ=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a6b:750c:0:b0:641:3b39:7b24 with
 SMTP id
 l12-20020a6b750c000000b006413b397b24mr8761326ioh.139.1647020464165; Fri, 11
 Mar 2022 09:41:04 -0800 (PST)
Date: Fri, 11 Mar 2022 17:39:49 +0000
In-Reply-To: <20220311174001.605719-1-oupton@google.com>
Message-Id: <20220311174001.605719-4-oupton@google.com>
Mime-Version: 1.0
References: <20220311174001.605719-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v4 03/15] KVM: arm64: Don't depend on fallthrough to hide
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
index cd3ee947485f..2a228744d0c4 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -310,9 +310,9 @@ static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
 
 static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
 {
+	unsigned long val = PSCI_RET_NOT_SUPPORTED;
 	u32 psci_fn = smccc_get_function(vcpu);
 	u32 arg;
-	unsigned long val;
 	int ret = 1;
 
 	if (minor > 1)
@@ -328,6 +328,8 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
 		if (val)
 			break;
 
+		val = PSCI_RET_NOT_SUPPORTED;
+
 		switch(arg) {
 		case PSCI_0_2_FN_PSCI_VERSION:
 		case PSCI_0_2_FN_CPU_SUSPEND:
@@ -346,13 +348,8 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
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
@@ -373,7 +370,7 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
 			val = PSCI_RET_INVALID_PARAMS;
 			break;
 		}
-		fallthrough;
+		break;
 	default:
 		return kvm_psci_0_2_call(vcpu);
 	}
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
