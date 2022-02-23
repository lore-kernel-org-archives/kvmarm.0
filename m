Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5CA6C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 23 Feb 2022 04:19:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 487254C3DA;
	Tue, 22 Feb 2022 23:19:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zauIWjVaT4Dc; Tue, 22 Feb 2022 23:19:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DD05C4C3E1;
	Tue, 22 Feb 2022 23:19:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED8734C3D4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 23:19:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RaenHfAEONrw for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Feb 2022 23:19:12 -0500 (EST)
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com
 [209.85.166.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E906A4C369
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 23:19:10 -0500 (EST)
Received: by mail-io1-f73.google.com with SMTP id
 d194-20020a6bcdcb000000b0063a4e3b9da6so13060282iog.6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 20:19:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=uWbRYWTJnCUA8B0m1XqBGGOg6aYqCe4xM0wdu1aYSFo=;
 b=bRtQOIBWnzglQDthYZQEg4R64vK2cq/f77YtdtQkrhMtj29gKK28wkyzLwvgdgXxlq
 U/MgFH/VrWkqymNlz2aBFl/uqvxMJBEElXcvrOGGd7f2yeoyZSly9DxJCRIop7YDhD5v
 TvgaN2nxJQH3Y6BQnVszO0fCUPiY1btF3S/xUV1gCpxo7HFoFzHKwBGg4+RJvrZax5d5
 otsZVN27i7gRsxm4mUOeXAt8qgEF4cyMLmHRlSjTVupL999U0egKcdjm7mWMlKFUZJg1
 FX8CiZd1idDFLVGGZK/JZQIn9GfJfFPeqmhaNmCOFcvVorhaWVFoGo24Q2XZXy5iUMe9
 ucHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=uWbRYWTJnCUA8B0m1XqBGGOg6aYqCe4xM0wdu1aYSFo=;
 b=zU4//h8Ha6ENTbhiswu6eCd0WJGXlAMdeDbTOo8Of9pAxvW9nWzjzXLaW207t4SJXy
 EKXAmIzVTG2bBKIMEIcIulxbw5T0PGKM5nX2/ZoW/FiIkxcTJJXgQ3CvOaDCauz4LB2c
 BxJpIiD72dmOvoGwpwABt69KqB5hLfotUA1l1Lf5VOP6V71gE9PcwrKwYEAdPcp7cKB5
 Z3LBYIm5C8FpBvLO5lLAFiCFUGF0ruvKO7B920C7LFWfdwbNE83+KKNWv2X1MZ2DYV9I
 D6ugN9/L7ETR93DHZLNSGVkBPTWoJn9tvoBJUItRcNZxwbYPde4sxLf5qULq16AKbn9q
 8smg==
X-Gm-Message-State: AOAM531iqE/DBbVl0AmRSpLl6IWyOwUyOjmh577Mmd5pjuND8hQ98oxg
 PajGZcIYhUEtxDUYQDhiEQuvsyIEuT6tVzWwfIyAUKf5gFKqRp28N2sysQQ7zxJWKsDac20BlM2
 4PWomCQi8Qoz7/JD2GH2wydesZOC44K+rLdzEPR0jM2JibceubWRgkCgZbLW/jFR8regJQQ==
X-Google-Smtp-Source: ABdhPJyvsx2h/KZBIMiFVVSt3DhBBXlspYS8MfSfF2nPMCpfqGuyTsJgaKVrZ1Bx7e3kEjpyTSXSWt1l5gI=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a6b:7d44:0:b0:641:347:477a with
 SMTP id
 d4-20020a6b7d44000000b006410347477amr10352933ioq.160.1645589950392; Tue, 22
 Feb 2022 20:19:10 -0800 (PST)
Date: Wed, 23 Feb 2022 04:18:29 +0000
In-Reply-To: <20220223041844.3984439-1-oupton@google.com>
Message-Id: <20220223041844.3984439-5-oupton@google.com>
Mime-Version: 1.0
References: <20220223041844.3984439-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH v3 04/19] KVM: arm64: Clean up SMC64 PSCI filtering for
 AArch32 guests
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Joerg Roedel <joro@8bytes.org>, Atish Patra <atishp@atishpatra.org>,
 Peter Shier <pshier@google.com>, kvm-riscv@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Jim Mattson <jmattson@google.com>
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
Reviewed-by: Reiji Watanabe <reijiw@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm64/kvm/psci.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index de1cf554929d..4335cd5193b8 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -229,15 +229,11 @@ static void kvm_psci_narrow_to_32bit(struct kvm_vcpu *vcpu)
 
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
2.35.1.473.g83b2b277ed-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
