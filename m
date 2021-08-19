Return-Path: <SRS0=/4wP=NK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 993F8C4338F
	for <kvmarm@archiver.kernel.org>; Thu, 19 Aug 2021 22:36:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2AD6E610A6
	for <kvmarm@archiver.kernel.org>; Thu, 19 Aug 2021 22:36:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2AD6E610A6
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D33994B11A;
	Thu, 19 Aug 2021 18:36:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wHIpMRuD1223; Thu, 19 Aug 2021 18:36:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E69A44B112;
	Thu, 19 Aug 2021 18:36:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E5D34B0D7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Aug 2021 18:36:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tCCxJ20IcqQU for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Aug 2021 18:36:46 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 286594B087
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Aug 2021 18:36:46 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 x5-20020a0569020505b0290592c25b8c59so7918584ybs.18
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Aug 2021 15:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=7MocV+zQPclsTGs3NFoQy/CJHXoVS8FPe3HyXWpOfLI=;
 b=JH+Naz2YWe6tlv1DbwAqHD8pyGp86U036FRjmuKxFKD3drI/nO6SVyjF9AYtfxkhSI
 9Yw6QFF8ihOvGTFaiJAYC8u5MSO3iwVmu31FiKHcJMRF4+/i8+B/rgZRIyABgFk7hgi1
 sIrpOPkuMVSSN2WN68NkilXSfz9okPy8eTkNAXNEkeB9CHySAlz/hRQzEjnSuR++RbzX
 CNbRx3Wp3rqlx4nmkSWegGRYNcKzlefd7b1qIHADD3Ca02pXvvRMDlOsNJDBV3XTLks0
 LAEBYRgJ83wHpXIR0LhlJNcNgaWXU3XxMbUGmnz4/+Yj3WJQEezr9f5p1AOJWhmePBMC
 g7MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=7MocV+zQPclsTGs3NFoQy/CJHXoVS8FPe3HyXWpOfLI=;
 b=D+Pg2GiDQmPPSfFzU7LserBZTmk885zhfPylS9yUFPbYqbd/5sGnVtxSQgHKR3MnYn
 VHuj/uVsLl0O4sQ3gxt/hG2KLaaW4BoQ7MsUOLO1kNkDove5MXdRf4GfSBdiw68qgpwA
 DMrWFFWbtoIw8Y4RR8YKTqZxNBfylBzmzIxks3df1TbNtj3CmZo/1ejqwbVuPsGL7nAr
 e+AvrxFb8AFihbyYMxs8S7qfdnRHWACoC2dNxQkUdraU8cCqwy1UCIYbmNrn8A6gyDvc
 r8r2uu3BRfZjwuyVCkPB3BXF0No4YlV2TS4foI7wVoHwYRuM/8CNHeG7fQn9PfuU3477
 o2TQ==
X-Gm-Message-State: AOAM531s5tf1ayOWgk5rNStuy8Xut3vy4acrXFcli8eXjuZ3rzvYkJsX
 LE9zJkeTLSWKYko7ClUx0k0nimyY5UM=
X-Google-Smtp-Source: ABdhPJwt1ogHucAHaphAZBWzPxt0QIqGHZGzqIb/0MTJvBKznzm60whzPOY/xCxgZLsfY8ECcW2KM57MkAU=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:7ac6:: with SMTP id
 v189mr21050262ybc.485.1629412605729; 
 Thu, 19 Aug 2021 15:36:45 -0700 (PDT)
Date: Thu, 19 Aug 2021 22:36:36 +0000
In-Reply-To: <20210819223640.3564975-1-oupton@google.com>
Message-Id: <20210819223640.3564975-3-oupton@google.com>
Mime-Version: 1.0
References: <20210819223640.3564975-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
Subject: [PATCH 2/6] KVM: arm64: Clean up SMC64 PSCI filtering for AArch32
 guests
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 Raghavendra Rao Anata <rananta@google.com>
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

The only valid calling SMC calling convention from an AArch32 state is
SMC32. Disallow any PSCI function that sets the SMC64 function ID bit
when called from AArch32 rather than comparing against known SMC64 PSCI
functions.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/psci.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index d46842f45b0a..310b9cb2b32b 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -208,15 +208,11 @@ static void kvm_psci_narrow_to_32bit(struct kvm_vcpu *vcpu)
 
 static unsigned long kvm_psci_check_allowed_function(struct kvm_vcpu *vcpu, u32 fn)
 {
-	switch(fn) {
-	case PSCI_0_2_FN64_CPU_SUSPEND:
-	case PSCI_0_2_FN64_CPU_ON:
-	case PSCI_0_2_FN64_AFFINITY_INFO:
-		/* Disallow these functions for 32bit guests */
-		if (vcpu_mode_is_32bit(vcpu))
-			return PSCI_RET_NOT_SUPPORTED;
-		break;
-	}
+	/*
+	 * Prevent 32 bit guests from calling 64 bit PSCI functions.
+	 */
+	if ((fn & PSCI_0_2_64BIT) && vcpu_mode_is_32bit(vcpu))
+		return PSCI_RET_NOT_SUPPORTED;
 
 	return 0;
 }
-- 
2.33.0.rc2.250.ged5fa647cd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
