Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CDE8C433FE
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 17:41:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F294240FF0;
	Fri, 11 Mar 2022 12:41:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KuLqLEpkfjNR; Fri, 11 Mar 2022 12:41:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B92DD412AF;
	Fri, 11 Mar 2022 12:41:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0621F40B91
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 12:41:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DfQJWfDacW5k for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Mar 2022 12:41:03 -0500 (EST)
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com
 [209.85.166.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D2B9C40AEA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 12:41:03 -0500 (EST)
Received: by mail-il1-f201.google.com with SMTP id
 m17-20020a923f11000000b002c10e8f4c44so5989984ila.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 09:41:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=bb6B842pEmhb30IvOzOiYqYYt77sVbIbggImUmDeV5M=;
 b=h/4vsGpJyL/y/LTn5xTMyoq+QkJyJ59Xi9313T5WhXTIsMtDBSJmbACMzL4slDnoKp
 kIA6/1hycnhNho9//xNJfeaYXzKCjk3Ec5Ix81+73rzg3+OAT+oC3kzOVvW6mo1n6zUF
 GSn+9mH69PuLAsh5LipoiG4W4ivojlNhQRAcxJPaz+xDAH7FW2wBcHAhvZsMyM7Mx3G3
 iPJpoPZgK/JDOZzsZWSvrPPX9QQe3KRS+Y4EEnuAABhwrI/Ia2bfYPkgqssjz0/4AVYN
 mX1ejFS0BmN9ZyhJ1+iy+SQHkAYMdyjJq0+3J58xuAW19dJo3pDpYHv7davgyHzTvXHU
 anTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=bb6B842pEmhb30IvOzOiYqYYt77sVbIbggImUmDeV5M=;
 b=AFelmzxeCcC9uZywf0vYTS7nB8maCDT5ZBnFHwAXuKmg46a+YoOx5TjLz7GbglbYWU
 vYB7cGPiREw965B79F5mrJcchmdppCKMAC+nE6CTVywYB8rT7ctkbwzuvWO3dsmbTVBp
 p5JLhej6XHbZeqY3SxU+OFWVDlZmS8zeo/nU52xrvCotVcEl4/RUngvCH75VI5IbY0Ge
 tJ0iZu5DgonnmOHDd2t3VXJNpU8NuM1QiaL5gOpvZ8fl4biKq6Z/wa+BnB8cLylM/Og+
 5U9lilYKSiLBBdEg7ppUj/nVvVFEpgYB5lrdnYqhXn9LHTSY2MTV4Jwyo2AB5qxMiLMp
 2aDg==
X-Gm-Message-State: AOAM532c7qxlaWQdyGhwOR2s/CRxsK2iU5LSBydyLT89O20XAP386NwS
 5BaVt/clx3yla5S0TO7+bjm11XnQhul7fD7BhZeuq5FbGNhMtcizWf5sYE8mVUqGn9VmCY4Egnt
 0O0JMnYygi+MOISaTo2Zhq+SN4WO8D7fsF9XGUfVnJ4yZtCq/DJ0qXF/7biMkygQcbhqQcQ==
X-Google-Smtp-Source: ABdhPJy26RVyRtQLKLLzR4hA+MhLcGGs86k+aA8I8jFVqssnsm7zreR/BVCQ4wVXWIAy9nqH55+p8NmX3Xs=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6638:12c3:b0:319:9b70:5ad8
 with SMTP id
 v3-20020a05663812c300b003199b705ad8mr9045950jas.132.1647020463061; Fri, 11
 Mar 2022 09:41:03 -0800 (PST)
Date: Fri, 11 Mar 2022 17:39:48 +0000
In-Reply-To: <20220311174001.605719-1-oupton@google.com>
Message-Id: <20220311174001.605719-3-oupton@google.com>
Mime-Version: 1.0
References: <20220311174001.605719-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v4 02/15] KVM: arm64: Generally disallow SMC64 for AArch32
 guests
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

The only valid calling SMC calling convention from an AArch32 state is
SMC32. Disallow any PSCI function that sets the SMC64 function ID bit
when called from AArch32 rather than comparing against known SMC64 PSCI
functions.

It is important to note that the SMC64 flavor of SYSTEM_RESET2
is unintentionally allowed for AArch32 guests without this change.

Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Reiji Watanabe <reijiw@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
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
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
