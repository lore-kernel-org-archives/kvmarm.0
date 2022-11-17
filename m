Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 772ABC43217
	for <kvmarm@archiver.kernel.org>; Thu, 17 Nov 2022 00:24:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1009C49F37;
	Wed, 16 Nov 2022 19:24:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WDEqzrcoSDRY; Wed, 16 Nov 2022 19:24:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F1D004B808;
	Wed, 16 Nov 2022 19:24:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6812149F53
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 19:24:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tKBhnASRN8H8 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Nov 2022 19:23:59 -0500 (EST)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2275449F37
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 19:23:59 -0500 (EST)
Received: by mail-pl1-f201.google.com with SMTP id
 m1-20020a170902db0100b00188eec2726cso60604plx.18
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 16:23:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
 bh=f1KDr+rH3XIqQLVQCEwig1RrLbtV2JH7CIwItqPq0uE=;
 b=Sb0CLlnDvxGcJjdPFEdXu3sQ7ExS0J2DsrUa96MG+x30pOPo41C8wX8lnkjEvFu692
 o3pvJ4nlLGDjV9D5+o/Xc1NHyPs2MuqEv5vvIqZ+sqZzIL/ssXgFKRuEh3ykOWsb8Aof
 8NuSb0SC0FoNWARBXd8nIP1nNXh5DasKaX+CcaBKFNHtvZl56/253TE6fwjP5JoMpiim
 gUPzWrrXnAvNi8nnM084PxpxGvTGH19Xn+GRoqghoBS14moljDfd44Cr3RqglOvym254
 gzMKd+B+aCWjFP6TQW5RMTEuFyf2CyJjQHrsUsqBJWG2Qn401exrcaqrEcOx43Ax6pEw
 +BbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=f1KDr+rH3XIqQLVQCEwig1RrLbtV2JH7CIwItqPq0uE=;
 b=2ym9G/RRq2g9uyngl7JBqK1/dYGZI1j5oG5NUWHJ+kPjBWOZistyKvJDVCDE2+g9jm
 2NIbecBom89WpIkq2ZrqXzwMYbwnmvVTStyWBZwA95aLOqM+Febi9qMW1uV+T0w4qZAo
 kJzGCo00egBKC56psnxxWAgxkEMu7DvXYHTXaNLDHMEirCh86ye9nZXkxkx0ytoTJ25P
 sFr/wj7H2a7T4Yeo2VsAQ+29TDtDtP46mjryJS4oWhUWQraYK8IABVPnL0fIuGldX63w
 1AeWVcraCdl3y/o6KhjGSddLmQh7EpNgk5W75Y0bZ09LUd4GMgJI5k5SKuevS9Jldu+7
 Z0QQ==
X-Gm-Message-State: ANoB5pkYKoDLtjT8YiP5hvKp0Y5k5HqtmwWl96/FmXRUtZRb043gbmpE
 Bx9HTeAwDACkoZUt+ByUAuyRV4Hg4jM=
X-Google-Smtp-Source: AA0mqf413lvrUg1TdHwZHTgN7XZflJ1bKJMT3jX1WCVJjGcPVxVBe4WRIWEnFUWoG+XWNbACIBeMBtLtEhE=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:a17:b0:213:2708:8dc3 with SMTP id
 gg23-20020a17090b0a1700b0021327088dc3mr636229pjb.2.1668644638088; Wed, 16 Nov
 2022 16:23:58 -0800 (PST)
Date: Thu, 17 Nov 2022 00:23:49 +0000
In-Reply-To: <20221117002350.2178351-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221117002350.2178351-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221117002350.2178351-2-seanjc@google.com>
Subject: [PATCH 1/2] KVM: arm64: selftests: Disable single-step with correct
 KVM define
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Sean Christopherson <seanjc@google.com>
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

Disable single-step by setting debug.control to KVM_GUESTDBG_ENABLE,
not to SINGLE_STEP_DISABLE.  The latter is an arbitrary test enum that
just happens to have the same value as KVM_GUESTDBG_ENABLE, and so
effectively disables single-step debug.

No functional change intended.

Cc: Reiji Watanabe <reijiw@google.com>
Fixes: b18e4d4aebdd ("KVM: arm64: selftests: Add a test case for KVM_GUESTDBG_SINGLESTEP")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/aarch64/debug-exceptions.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 947bd201435c..91f55b45dfc7 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -369,7 +369,7 @@ void test_single_step_from_userspace(int test_cnt)
 						KVM_GUESTDBG_SINGLESTEP;
 				ss_enable = true;
 			} else {
-				debug.control = SINGLE_STEP_DISABLE;
+				debug.control = KVM_GUESTDBG_ENABLE;
 				ss_enable = false;
 			}
 
-- 
2.38.1.431.g37b22c650d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
