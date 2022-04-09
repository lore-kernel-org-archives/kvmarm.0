Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14A07C433F5
	for <kvmarm@archiver.kernel.org>; Sat,  9 Apr 2022 18:46:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE3FB4B1D0;
	Sat,  9 Apr 2022 14:46:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mMi9asxdhnzs; Sat,  9 Apr 2022 14:46:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E8ADD4B1D5;
	Sat,  9 Apr 2022 14:46:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A517F4B17C
 for <kvmarm@lists.cs.columbia.edu>; Sat,  9 Apr 2022 14:46:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rsmW1iU4ofSG for <kvmarm@lists.cs.columbia.edu>;
 Sat,  9 Apr 2022 14:46:06 -0400 (EDT)
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com
 [209.85.166.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 25F3F4B130
 for <kvmarm@lists.cs.columbia.edu>; Sat,  9 Apr 2022 14:46:06 -0400 (EDT)
Received: by mail-io1-f74.google.com with SMTP id
 y4-20020a6bd804000000b0064c68fa4f70so7645365iob.2
 for <kvmarm@lists.cs.columbia.edu>; Sat, 09 Apr 2022 11:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=a8ErjQkjJemApV/ArG2O1WzEXVxzEs6Cu64ADo489u4=;
 b=E6d759Z/bhHpp0/D3B+xqpOJBJs80FX++1SU7DHjYJBQhEqraMuQCF77w6lNUEuwWy
 seCONxq9h7jvFEvrK9pxx22jg6r5yAOe72z7duoT281XosOrsPIMih16pHltXbCefqvl
 SH6whpr+OTyW3MFdG+aGMeEHQ5Jo2Urp8LXo0/oghajD68dA/i/0zwT6DmbXDSLG3dgN
 q0Vz+vgqkFqgCacsPLUac59tFgLRZsb1MFYxoEc+2f2uFQWkFfajnFXJuvhqX5geHKlB
 4+JLxj9EABi7afYP65jYPoGXggMC59RFJxd9Z9cDeaGaUkQLkpZOXTut2sM5zqSaWCBP
 4cFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=a8ErjQkjJemApV/ArG2O1WzEXVxzEs6Cu64ADo489u4=;
 b=B/mojhAcYpa86pRWzFtZcAAFu9NNMuXcysi7Lp4jsGcktiG8yBYx+f0gKpW1yJztP3
 3m/U8INaR/Iqy9PMr9FCn2PzRWS/tRPrDn9B7edG2ssBaF6ycgr9dE6aB5WQJRVXFpVp
 xoFVwQaOv6lzl8EG0H2oIZxwzLId6k8P2kewC5v7s0QpaALmA4yEwRUmwN421aUTxjr+
 ArWoPo/hSGGRcnmvctORoP+ZZGoYi1oTDxiNvI3A3xUvSU7MsLM76lFYb+9EybJ9Ytrv
 hzb/2gyvvpWGDEBcByUxa2+FotFLHTKXVrWnE3q5tKW5mChYnMqIaZqwkWB3vEVKjyDf
 sI9Q==
X-Gm-Message-State: AOAM532CK3qgklXnsBGhzgSp0w5J7zkmljkZOm4F6OdK1+tQqZ1o18fj
 N4uzSi6dGYboCpZPYWbUfz9M04orrTovmgczfh0O5q6N108S9lKcLYcO9wHVbg1/Fh6mGqCdJGR
 yxoFWGna+ZUPa8dS1mS42tpYYgCcPmqkUbHD4DAtFgvl9Osi4H72bwG2T6TVBNPxwy1t+Lw==
X-Google-Smtp-Source: ABdhPJwM3NLh6dMiAtJ4udXU+7vQgFrC8s3Y1rHX2gzBrlErDj556HI9qaJ2Ilsl83NS+oCvkkk5pJNKs9Q=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:18ce:b0:2ca:1f4c:f2b2
 with SMTP id
 s14-20020a056e0218ce00b002ca1f4cf2b2mr11583960ilu.87.1649529965605; Sat, 09
 Apr 2022 11:46:05 -0700 (PDT)
Date: Sat,  9 Apr 2022 18:45:42 +0000
In-Reply-To: <20220409184549.1681189-1-oupton@google.com>
Message-Id: <20220409184549.1681189-7-oupton@google.com>
Mime-Version: 1.0
References: <20220409184549.1681189-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v5 06/13] KVM: arm64: Return a value from check_vcpu_requests()
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

A subsequent change to KVM will introduce a vCPU request that could
result in an exit to userspace. Change check_vcpu_requests() to return a
value and document the function. Unconditionally return 1 for now.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/arm.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 77b8b870c0fc..efe54aba5cce 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -648,7 +648,16 @@ void kvm_vcpu_wfi(struct kvm_vcpu *vcpu)
 	preempt_enable();
 }
 
-static void check_vcpu_requests(struct kvm_vcpu *vcpu)
+/**
+ * check_vcpu_requests - check and handle pending vCPU requests
+ * @vcpu:	the VCPU pointer
+ *
+ * Return: 1 if we should enter the guest
+ *	   0 if we should exit to userspace
+ *	   < 0 if we should exit to userspace, where the return value indicates
+ *	   an error
+ */
+static int check_vcpu_requests(struct kvm_vcpu *vcpu)
 {
 	if (kvm_request_pending(vcpu)) {
 		if (kvm_check_request(KVM_REQ_SLEEP, vcpu))
@@ -678,6 +687,8 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
 			kvm_pmu_handle_pmcr(vcpu,
 					    __vcpu_sys_reg(vcpu, PMCR_EL0));
 	}
+
+	return 1;
 }
 
 static bool vcpu_mode_is_bad_32bit(struct kvm_vcpu *vcpu)
@@ -793,7 +804,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		if (!ret)
 			ret = 1;
 
-		check_vcpu_requests(vcpu);
+		if (ret > 0)
+			ret = check_vcpu_requests(vcpu);
 
 		/*
 		 * Preparing the interrupts to be injected also
-- 
2.35.1.1178.g4f1659d476-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
