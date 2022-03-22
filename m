Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1577BC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 22 Mar 2022 18:35:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC8B349F2A;
	Tue, 22 Mar 2022 14:35:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id k94jTGQSMCxJ; Tue, 22 Mar 2022 14:35:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D8FA49F1C;
	Tue, 22 Mar 2022 14:35:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E06EF49E1E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 14:35:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ikfOamZ7iqHx for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Mar 2022 14:35:45 -0400 (EDT)
Received: from mail-oo1-f73.google.com (mail-oo1-f73.google.com
 [209.85.161.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A746C49F14
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 14:35:45 -0400 (EDT)
Received: by mail-oo1-f73.google.com with SMTP id
 g16-20020a4a2510000000b00324173d3201so12166479ooa.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 11:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=3PzR5vzjBym0Xrr1WAh6EkOFmL2w1PsYl+ih5Ad/dqk=;
 b=SGblp6gYJTNQJbOVKJuZHzVH1+KspPybgjStuKKj0ooDhsYubYE8RgbOz71CqIVIjr
 SP/4dvB0b76AjPGSoyzVZ1LBu501I1vwxlx8D1FWgRrsHFXbOuQci+fEdW5XRxq4bGOX
 5rlIbDFc2u7S1S7WTteu0BD6kmSRpMILcW1q6F4oKF0zemBXr5gKSSOuPwbCiLDpRkkP
 2c5b8tXImTSrhnxbW/JVf+0W7g3mBcSg64r10QY+/AJQ+fiXoTxUjbtz1cjBNvw8Aw0F
 Ls0OzeMV1Ac8oK7Yww2DOCYx+7o3/XAGcuiFnV2+o8Wh/vssPQd/XsBMgzi6x8gYr0UT
 yMcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=3PzR5vzjBym0Xrr1WAh6EkOFmL2w1PsYl+ih5Ad/dqk=;
 b=s3mdFLzezBeI1eaZhgiGovqt2mkWxk4fQG9FPLiKVbiANtHjN89RjG88cQ1KNpFyz/
 DyG6BrAG7vPTkduPp3FBYvf2mGcBKqOADnS8ONHsobtlqxvh6tJTMRzZft0bAsnD47g6
 EDnkiCQPrBwymI+IP9TB3O5FCiEOoZ0xhrrQKdHAhgUPSqHiTHaNDi4ERlbsdi5qsJBg
 FDgppktZLDFRc60xhKkquN/7KBUfhQZJe1PuG1UwsJNgQ4wM7n8oXwTvMBMdVfLspNDK
 nMi918ANrTsCoQorVcZ2cCCqaSo25w4FhQ5c/ucY5wK5Vdy999bRpiO+EPC0rKScqiWD
 WWCA==
X-Gm-Message-State: AOAM531ey8MAnhyy8lth3AKfYTe91C/OTfqLvAJvhL4ApZ9YsQoMpfE2
 EYONqvLEvaIG328N7RUJa27ZFjQyrumDQnZKnqJxQT8KilZQhQIyLZo0VcRgCJBxyNJb4LF2G25
 r0t9x0UEcB6AVXjwg1EFCQjQ1pIIuN4U16SIDrzSuCTCubDdxVPd8EikhW0v51cxLkh/ktw==
X-Google-Smtp-Source: ABdhPJzn9OAifeYpnFU+SY/qxn1hQQpBef9smelEDXHHVlma7uJiqUTGI5RF9LlKNBUY6ZOaiPTb3GAZ4wE=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6808:1283:b0:2ec:f440:e076
 with SMTP id
 a3-20020a056808128300b002ecf440e076mr2801595oiw.157.1647974144916; Tue, 22
 Mar 2022 11:35:44 -0700 (PDT)
Date: Tue, 22 Mar 2022 18:35:36 +0000
In-Reply-To: <20220322183538.2757758-1-oupton@google.com>
Message-Id: <20220322183538.2757758-2-oupton@google.com>
Mime-Version: 1.0
References: <20220322183538.2757758-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH v2 1/3] KVM: arm64: Generally disallow SMC64 for AArch32 guests
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
Acked-by: Will Deacon <will@kernel.org>
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
