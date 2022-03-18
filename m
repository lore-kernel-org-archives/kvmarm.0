Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39C0DC4332F
	for <kvmarm@archiver.kernel.org>; Fri, 18 Mar 2022 19:38:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B0E6E40BD3;
	Fri, 18 Mar 2022 15:38:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Io9cYUgE+o18; Fri, 18 Mar 2022 15:38:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A529A49EE3;
	Fri, 18 Mar 2022 15:38:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC4C443479
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Mar 2022 15:38:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QVb1+pYIYf-G for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Mar 2022 15:38:51 -0400 (EDT)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CC92D49ECB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Mar 2022 15:38:51 -0400 (EDT)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-2d81518795fso79061877b3.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Mar 2022 12:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=A4+XIKos4PkA5PUWtKvp/crs3G2yPwben9yuSUF/Cok=;
 b=Mxysyu0JPDKhG4fvfBOTuNoi0uy6GPJJRW8Q1jj5BTfHEtrEGp07D5HRNAgDbyExup
 p3vBZlU07UyIadl0jVDljrOrR6HlGjiE+3NRxbRnRxx58H5vDI0Pf3SXshcd7gsJF/gZ
 X6SvI37MLemSbp7nqqXGjYR0iQASqxwCAbPULBQ8FDusHE6jmzRYWnQzqnAuEuAJRcUf
 9x0bzsdsJns3wBTBKWIKdmXMXgQsoF+iH3xW1UK55spGKFK650l01ZdMNaiN6sDUW2UC
 Ix+IRacvv6UmIgLLpZw4YGuzsstDVHeLuGqMVaHZc0lbP0aOhF82/tb9aoIA2z3b2Fef
 9MTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=A4+XIKos4PkA5PUWtKvp/crs3G2yPwben9yuSUF/Cok=;
 b=wl7mVTmCEpwU3sE3/c3cgHMpRURTMbPSmiu15kLSIAF+KICwim3+E8TpaAXrnDS9PJ
 Sc4TuOV81eS99ZMoYiXwM2Ged1qg2/3PyUcs7iyVMY9kX37ngzJdxj68TmB3t451OR/L
 DWvBPH1qgqhiJf6se63v2BkESiFFIjB2Ss4o8fRht1JXgIYSBfoQxIYB32parxHAilwQ
 exGBLmFfarO6y5c66vnZZIygx5/89BCBIHY864P/v6adYA0XBIPpO365vjaF4WasWiuH
 Q1Yce0juKY7DJbdHTUnP8GsJzmL8k7qgAR1ek6l7oKUAX92SUzHSgRvv+8YiZKuvGLxm
 Kw7Q==
X-Gm-Message-State: AOAM533AJqAEuWiVb02fIlgWLMR9SilwiQwgKTXlQ/RjHG8e19PSoEyA
 lVxMALrQeC8Bi2OQTARC/8qDhOKiYEYo17FqaHdFDJ+rpNPH5IKN8a1PafhCmBsw94cTMK5qJL9
 236DXGTIcxthR6BsqKKYFpJSAgADmq7VsWk31JFlobar9fZn92AVw+p0xYhomtfrg1XOPsA==
X-Google-Smtp-Source: ABdhPJztfEv9sfkm6TJFpaI48HRSsOUCD3lKH1sR2VDcArNkH6v02JyB7zu2cpTG/sDFd+RCzo3Se6/3MzE=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:7310:0:b0:633:b888:5639 with
 SMTP id
 o16-20020a257310000000b00633b8885639mr5504409ybc.351.1647632331235; Fri, 18
 Mar 2022 12:38:51 -0700 (PDT)
Date: Fri, 18 Mar 2022 19:38:30 +0000
In-Reply-To: <20220318193831.482349-1-oupton@google.com>
Message-Id: <20220318193831.482349-2-oupton@google.com>
Mime-Version: 1.0
References: <20220318193831.482349-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH 1/2] KVM: arm64: Generally disallow SMC64 for AArch32 guests
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org
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

Note that without this change KVM advertises the SMC64 flavor of
SYSTEM_RESET2 to AArch32 guests.

Fixes: d43583b890e7 ("KVM: arm64: Expose PSCI SYSTEM_RESET2 call to the guest")
Cc: Will Deacon <will@kernel.org>
Reviewed-by: Reiji Watanabe <reijiw@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/psci.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index a433c3eac9b7..cd3ee947485f 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -216,15 +216,11 @@ static void kvm_psci_narrow_to_32bit(struct kvm_vcpu *vcpu)
 
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
2.35.1.894.gb6a874cedc-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
