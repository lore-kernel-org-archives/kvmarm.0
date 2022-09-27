Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 832BEC07E9D
	for <kvmarm@archiver.kernel.org>; Tue, 27 Sep 2022 00:27:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DF08840B8D;
	Mon, 26 Sep 2022 20:27:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id R8aWUkXXyhJp; Mon, 26 Sep 2022 20:27:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C471B40FAA;
	Mon, 26 Sep 2022 20:27:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD76940BC2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Sep 2022 20:27:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Qc+O81dBoKCt for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Sep 2022 20:27:21 -0400 (EDT)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8D7ED40B8D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Sep 2022 20:27:21 -0400 (EDT)
Received: by mail-pf1-f201.google.com with SMTP id
 g24-20020a056a00079800b0054b1a110543so4830076pfu.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Sep 2022 17:27:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
 :subject:date; bh=9LlUllMuSCCNuvy8nXr0WUw6cjOfzqrjmVjCju9k9xE=;
 b=ib28nrR8JpjsrppII6G9v/dkNoieDbqAEGPjxFDDXpZ6X2dzYHAQgGQAGNeZsoN0E+
 QivbBd1z3z72bEgc4ZrqGDiqM5n8tCaBCejTC384XUmG+MXYCSNsPSCMPasXavv9I9ju
 7UxNYQXgwEHcdbOixKGvEN8J1at2ARMARli6/3VS5Vquhqwyf0HYlB/5vJ784LvBoNBt
 r0Ue8vNvTZXN6cpds0UdPc0Wjh7tN2e6knqL4lQQjuPByoh94Hfrp/pylM5QAgzvOgMi
 uPw2vyCKgVaO1z0v7Ynf3hRhgS3OJcG5bElgEhT0Y4BPuktbEk4Rdt7sJcnwJBSLPTZl
 VxLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:mime-version:date:reply-to
 :x-gm-message-state:from:to:cc:subject:date;
 bh=9LlUllMuSCCNuvy8nXr0WUw6cjOfzqrjmVjCju9k9xE=;
 b=Qa36glf813I37hIDsXjpRj5TTt6BtyCjwTolpVr35dchGQrfvsMtR13bUmAV3jB0I7
 GtDZqE6vpFdQxyv2hPwmTHHSXg+dDeDpshACJ3N7VNoVLegw//NaV9e2eeVIvH9IWPFA
 WE48OpUEXemSsWBFp3KEcsMSur+bhBLmKToSueRTv+9Lw6uzOC82H2/u5++4j3HkjEAz
 +6yBQsTi40lfljb0qzHJFoUU4LK6dcgRjdgb8cKJcPIlmq8A7CXZeCVLB/UoWepXbjtI
 2o9ywRCI/U0Mlk8Rmn2fSwHXG+wnFEZBPVkHnQiBc0TunxfK5LfW48D1E4Vrul8KFW0D
 759w==
X-Gm-Message-State: ACrzQf11R1oGkifKAhTQf/sX5YCxEMAFnzOdyRrJrTulSjjK3BCMGJPs
 qU8Lnl2yVcSHfEo5LNFdZFH8goiJG+HI
X-Google-Smtp-Source: AMsMyM7beut503w2dGOmNLcBHb2fmbJhHsJKZpriWBWPTuRptWckWaynxJFBeEmIGXr7bX7q5SvnLReY33W1
X-Received: from mizhang-super.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a05:6a00:1342:b0:545:4d30:eecb with SMTP
 id k2-20020a056a00134200b005454d30eecbmr25908814pfu.69.1664238440461; Mon, 26
 Sep 2022 17:27:20 -0700 (PDT)
Date: Tue, 27 Sep 2022 00:27:15 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
Message-ID: <20220927002715.2142353-1-mizhang@google.com>
Subject: [PATCH] KVM: arm64: Cleanup the __get_fault_info() to take out the
 code that validates HPFAR
From: Mingwei Zhang <mizhang@google.com>
To: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>
Cc: linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Mingwei Zhang <mizhang@google.com>
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

Cleanup __get_fault_info() to take out the code that checks HPFAR. The
conditions in __get_fault_info() that checks if HPFAR contains a valid IPA
is slightly messy in that several conditions are written within one IF
statement acrossing multiple lines and are connected with different logical
operators. Among them, some conditions come from ARM Spec, while others
come from CPU erratum. This makes the code hard to read and difficult to
extend.

So, cleanup the function to improve the readability. In particular,
explicitly specify each condition separately within a newly created inline
function.

No functional changes are intended.

Suggested-by: Oliver Upton <oupton@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/fault.h | 36 ++++++++++++++++----------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/fault.h b/arch/arm64/kvm/hyp/include/hyp/fault.h
index 1b8a2dcd712f..4575500d26ff 100644
--- a/arch/arm64/kvm/hyp/include/hyp/fault.h
+++ b/arch/arm64/kvm/hyp/include/hyp/fault.h
@@ -41,12 +41,6 @@ static inline bool __translate_far_to_hpfar(u64 far, u64 *hpfar)
 	return true;
 }
 
-static inline bool __get_fault_info(u64 esr, struct kvm_vcpu_fault_info *fault)
-{
-	u64 hpfar, far;
-
-	far = read_sysreg_el2(SYS_FAR);
-
 	/*
 	 * The HPFAR can be invalid if the stage 2 fault did not
 	 * happen during a stage 1 page table walk (the ESR_EL2.S1PTW
@@ -58,14 +52,30 @@ static inline bool __get_fault_info(u64 esr, struct kvm_vcpu_fault_info *fault)
 	 * permission fault or the errata workaround is enabled, we
 	 * resolve the IPA using the AT instruction.
 	 */
-	if (!(esr & ESR_ELx_S1PTW) &&
-	    (cpus_have_final_cap(ARM64_WORKAROUND_834220) ||
-	     (esr & ESR_ELx_FSC_TYPE) == FSC_PERM)) {
-		if (!__translate_far_to_hpfar(far, &hpfar))
-			return false;
-	} else {
+static inline bool __hpfar_is_valid(u64 esr)
+{
+	if (esr & ESR_ELx_S1PTW)
+		return true;
+
+	if ((esr & ESR_ELx_FSC_TYPE) == FSC_PERM)
+		return false;
+
+	if (cpus_have_final_cap(ARM64_WORKAROUND_834220))
+		return false;
+
+	return true;
+}
+
+static inline bool __get_fault_info(u64 esr, struct kvm_vcpu_fault_info *fault)
+{
+	u64 hpfar, far;
+
+	far = read_sysreg_el2(SYS_FAR);
+
+	if (!__hpfar_is_valid(esr) && !__translate_far_to_hpfar(far, &hpfar))
+		return false;
+	else
 		hpfar = read_sysreg(hpfar_el2);
-	}
 
 	fault->far_el2 = far;
 	fault->hpfar_el2 = hpfar;

base-commit: c59fb127583869350256656b7ed848c398bef879
-- 
2.37.3.998.g577e59143f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
