Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6C37C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 17:41:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F21349EE3;
	Fri, 11 Mar 2022 12:41:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dmCFri0LR4T3; Fri, 11 Mar 2022 12:41:15 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 85DBD49EF1;
	Fri, 11 Mar 2022 12:41:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C889943479
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 12:41:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BDAzZYUImp5I for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Mar 2022 12:41:09 -0500 (EST)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D69D140BEE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 12:41:09 -0500 (EST)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-2dbd2b5e180so74946417b3.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 09:41:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=w/UueSoSfkkV5ZaqeN0ZkehJnNoFhHswChR0IcyQwpo=;
 b=TfK01IHyAJv8UjNfgpMHJTRDOcY+rjaLXLwHX8CTPaggNTNSs0HThWZMwPyEW+RH6b
 Df/jtoIuvebeXdJL5qwLz6xDhezAQfiw2Q2Kqlk7SMBqvPfhBdPpqinjwyM6JndYT29J
 T5JEBqfXLSys4nSDeEviHGA23CQ5D40dPJYzfP8su0JbVaUV4U0ohlDz4pUmaPuJM7Xo
 f05u8DHN2kp/671bnZG7AMZ7a+0bvS+xvkBRgOuzxHHtfqq1CcbXJwn8ZtcOsTWUL7MZ
 FPM9x9cuBiYHoNf60PAc9taPpdHg3t5D2RCSUBVSWG+trlTI+MZ93yJFGyuuX9cQfLN8
 sLdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=w/UueSoSfkkV5ZaqeN0ZkehJnNoFhHswChR0IcyQwpo=;
 b=uDQ6baBsLSmbC7uCvVBA5fYkOdmgbns8wr2EOICQAG7TqvphixeUE3XcK2lGgd8tSE
 NVkvYPzAdUMnNzVKdOhVezReybcBrUjCVlI9w8FvyI9twIvMb7MpMNX8zV9qC/cDlGL9
 BGp6SDctxOUMomTVdBgEbcacsgongH2Goh7vITJIjBqMWC4yep9di1LWKpAe3vO6hVBr
 M0rvxosSZ9cKn1uIL4VGgbEQn78Ox7vRax+U/EaV4hwijoNo7VKHdBS8933ua112IkVp
 m3UcRRtybe8X18WVoZIdauxTRQRSH7Gs3YeD/83bAITyh8WxaA5E7/lcHKDIXDn+zZoR
 IeMQ==
X-Gm-Message-State: AOAM531gjudGrZkhmlao6SmzL3ugvi530/FRDorZyMTvR1M3eDyMBnaJ
 ya5CX3FMrpffwXgEiBsPNaDxEZWBsEqZavIg6m863s3APXiH9bhhSVNlEOdPAfILrbcseWoDHj1
 mLm2/skYZQq5DexKjwAnf7W4jWBkNZqK6Kk6U4AC8FSbMbYU81s5mb9VYhmyBP+YnUJ1ivg==
X-Google-Smtp-Source: ABdhPJxoEVMNtFjxHU99BsNcOYHXwhP+US3YZzXI2U5bhTrho6KkLYFgzIovIc/T+wSFvNoNO7bsaIvB9iM=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a5b:dcc:0:b0:628:d6d9:d4bc with
 SMTP id
 t12-20020a5b0dcc000000b00628d6d9d4bcmr8743678ybr.178.1647020469266; Fri, 11
 Mar 2022 09:41:09 -0800 (PST)
Date: Fri, 11 Mar 2022 17:39:54 +0000
In-Reply-To: <20220311174001.605719-1-oupton@google.com>
Message-Id: <20220311174001.605719-9-oupton@google.com>
Mime-Version: 1.0
References: <20220311174001.605719-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v4 08/15] KVM: arm64: Return a value from check_vcpu_requests()
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
index 7c297ddc8177..8eed0556ccaa 100644
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
+ *	   <= 0 if we should exit to userspace, where the return value indicates
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
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
