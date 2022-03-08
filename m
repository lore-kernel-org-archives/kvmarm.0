Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A598C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  8 Mar 2022 15:33:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BE2A49EBC;
	Tue,  8 Mar 2022 10:33:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qpmBg8CT2Sat; Tue,  8 Mar 2022 10:33:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DBAD449EBA;
	Tue,  8 Mar 2022 10:33:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AB3B149EB1
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Mar 2022 10:33:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KGAFmjlzE7XI for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Mar 2022 10:33:15 -0500 (EST)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8345049E08
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Mar 2022 10:33:15 -0500 (EST)
Received: by mail-wr1-f74.google.com with SMTP id
 h11-20020a5d430b000000b001f01a35a86fso5584428wrq.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Mar 2022 07:33:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=oKAagiS3UYpwunP7Sy4zMqHeUF02cL/iWA5aLyx3lIw=;
 b=oew2eeCxmD+IHG2Wq1jU0MzeJ2j7Kpmp2jZx4AsCuT+d0O4sS8mH71HjRccdU1ZMmO
 zb5y1ljaLmbn8AnwVjKd/SX2huyP3mB5I2DUYemKAXw9EmPYb2L6NVHXbVBC5PsVo8aS
 gKE38AIjYtRL6KOVghQMbKCMnzl6Q0YTypU9xrRg9z2oDrCBGooLy7r2c/Ux4supZLlR
 lsvo6GM/qfFk6csqWGil0/on+Vn0yg+27MM3gi1tOHn+p1/RA7LRrITCKXUukm+nltgS
 fUbjZ0D1QAXa/A++50ArDaWDEqcToCGk8YKHNCPfLCyaY9FV3B1KZiUTHzHasOSifyks
 lZow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=oKAagiS3UYpwunP7Sy4zMqHeUF02cL/iWA5aLyx3lIw=;
 b=K5J52j2L5Vf/p/w4qYPy3YSDT3sYv53JHcqiytCq/65ucJXI1nByKNfs79hRjqKpaP
 hT0712dx1BFGb/Bc0uyrrYBBIUnvnelTSkkd+Bb+jZkPSlWMdOyvIDgFT0SbsXzNGmWc
 JqczqtWFKcvbAIa4+IKEoMfwkHce4+jVJUfnFAGp+I7eSMx5YceDsgrR5HhUT8ELJie3
 f8FbAE3aSxQAQJRW2zwBmLQ5/iIFFzAYjnedV7h0HhX1SeDiki0xw7cnuZ3szaeP1Zd4
 RpfaYm60rYj4stwQrqGp/nA+mYVwH6S11Or6uDLC1uqUJVrExwx6ii9+KHuLUqSYNJFd
 oWZg==
X-Gm-Message-State: AOAM530KxeD/XTz/uiG4d+RY+FIs7UrQDT0/pvOTcsVMAvUxUlZFiuar
 mWiAOOM6nTzgxce/KwtgV1/E+qDEyBkWPASSRPg=
X-Google-Smtp-Source: ABdhPJzDSUFsojdtm0TZ1ZFvzxwHmFK3nIFQdM8ndS4gHkA+y8jOIxofGG9cljM8f09tP/1Kh+ew1JX+ttcA8iwABO0=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by
 2002:a05:600c:252:b0:381:3461:1c64 with
 SMTP id 18-20020a05600c025200b0038134611c64mr4143631wmj.94.1646753594559;
 Tue, 08 Mar 2022 07:33:14 -0800 (PST)
Date: Tue,  8 Mar 2022 15:32:27 +0000
In-Reply-To: <20220308153227.2238533-1-sebastianene@google.com>
Message-Id: <20220308153227.2238533-2-sebastianene@google.com>
Mime-Version: 1.0
References: <20220308153227.2238533-1-sebastianene@google.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH kvmtool v9 1/3] aarch64: Populate the vCPU struct before
 target->init()
From: Sebastian Ene <sebastianene@google.com>
To: kvm@vger.kernel.org
Cc: maz@kernel.org, will@kernel.org, kvmarm@lists.cs.columbia.edu
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

Move the vCPU structure initialisation before the target->init() call to
 keep a reference to the kvm structure during init().
This is required by the pvtime peripheral to reserve a memory region
while the vCPU is beeing initialised.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arm/kvm-cpu.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
index 6a2408c..84ac1e9 100644
--- a/arm/kvm-cpu.c
+++ b/arm/kvm-cpu.c
@@ -116,6 +116,13 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 			die("Unable to find matching target");
 	}
 
+	/* Populate the vcpu structure. */
+	vcpu->kvm		= kvm;
+	vcpu->cpu_id		= cpu_id;
+	vcpu->cpu_type		= vcpu_init.target;
+	vcpu->cpu_compatible	= target->compatible;
+	vcpu->is_running	= true;
+
 	if (err || target->init(vcpu))
 		die("Unable to initialise vcpu");
 
@@ -125,13 +132,6 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 		vcpu->ring = (void *)vcpu->kvm_run +
 			     (coalesced_offset * PAGE_SIZE);
 
-	/* Populate the vcpu structure. */
-	vcpu->kvm		= kvm;
-	vcpu->cpu_id		= cpu_id;
-	vcpu->cpu_type		= vcpu_init.target;
-	vcpu->cpu_compatible	= target->compatible;
-	vcpu->is_running	= true;
-
 	if (kvm_cpu__configure_features(vcpu))
 		die("Unable to configure requested vcpu features");
 
-- 
2.35.1.616.g0bdcbb4464-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
