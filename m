Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B80E5C433FE
	for <kvmarm@archiver.kernel.org>; Tue, 22 Mar 2022 01:33:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CDFC40CDE;
	Mon, 21 Mar 2022 21:33:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MLj7Jlak-lUh; Mon, 21 Mar 2022 21:33:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC379410FF;
	Mon, 21 Mar 2022 21:33:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 75B54410FF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Mar 2022 21:33:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rI0biiktHC0G for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Mar 2022 21:33:13 -0400 (EDT)
Received: from mail-il1-f202.google.com (mail-il1-f202.google.com
 [209.85.166.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4E3AD40CDE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Mar 2022 21:33:13 -0400 (EDT)
Received: by mail-il1-f202.google.com with SMTP id
 g5-20020a92dd85000000b002c79aa519f4so8386968iln.10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Mar 2022 18:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=qjnBCMCBFj8PplPtYytxZfhoVlLYfUvFpjjjdycnFWE=;
 b=pII/Xw7Dal4aBB+0PLm2RyxWxoqjmtvsNRZQUUfR8ns77VDJYyDzs2nROTIb/UUqAA
 pOLPYNJLawy0NMA2CTpM/hp7vTo7rIebJsWKYgdAdRvsxw9rBxbE5a2hL+ma38I9AtbL
 xJlNHTMBF+w4lcS3PXcjeCxP1olVlxESHzW0LMS1qpFdc72NqG7R+mndkElUfBpFX7oV
 c0/MgLBIHNm2lFKCG/S3LAAHjSMU9Zlct80kEqajjVsWN0oBRQwd9zgVqwYl4Ecs1z8R
 mRwQw5elwVXfc1hf9Mm1hfeyorNWbGBLLqTIJwPApN5eRiuoSnQ10XVgqx8O4VkWvWoC
 7Ldg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=qjnBCMCBFj8PplPtYytxZfhoVlLYfUvFpjjjdycnFWE=;
 b=scUekQ/8tGeSFH7rWcNrIZOe/seYRAQjkKhvgC+ChOA2XOlJzUPzSS1EDf62Git3Xi
 husy0fZScMYmjkvoipFcDO2p/55xAZ5QX6+HQqZtqp0rzUWoya1fMfyDfJLAT1nF9p7L
 IDSEW7B9WXeIxRf1Muujn8e34JdWUKXF6fmgPd1QDjjRcgQn5TE3Iy7vDDh38e/rPMxX
 AhQZVoIt/K8eisfZkehhfY8aBh8jCcs9H3pwhRvTYQMIbyLEYXHKKa4l3yi8rAHEJcVA
 wKe9+JM74xV5rRjNcqzmUGmQGtuJhIOj2wrhbORMpZFKETuu4AYzU6YMO521gLqYO2xE
 +1Uw==
X-Gm-Message-State: AOAM532llY+ptVASJBhFBd/S7VzNbsB7VaNbaQRCiz+yZ/5kYQgL3M0+
 bYKnNdpWnLlOKDI0mRiZ5mFBvhqJ3cdEhBCSBbRCH59cSJS3aIwo2YzEsWY4H2gD+slhgKixS4u
 +8cdcn/6MCIaS/yE20RwNI2N74q1KSRZa4igceCSrXJ+mio8PvJ38bb0DH8FEn/fnL4iVqQ==
X-Google-Smtp-Source: ABdhPJwbCwwXb7MoS1YP0fzzPvJ9s+3FAN1k0iq644mgxX1DYCS9sZ9azTh6FyvitRYmbm8F1GECFravlPg=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6602:73c:b0:649:5e22:f3ee
 with SMTP id
 g28-20020a056602073c00b006495e22f3eemr8149186iox.156.1647912792555; Mon, 21
 Mar 2022 18:33:12 -0700 (PDT)
Date: Tue, 22 Mar 2022 01:33:10 +0000
In-Reply-To: <20220318193831.482349-1-oupton@google.com>
Message-Id: <20220322013310.1880100-1-oupton@google.com>
Mime-Version: 1.0
References: <20220318193831.482349-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH] KVM: arm64: Drop unneeded minor version check from PSCI v1.x
 handler
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

We already sanitize the guest's PSCI version when it is being written by
userspace, rejecting unsupported version numbers. Additionally, the
'minor' parameter to kvm_psci_1_x_call() is a constant known at compile
time for all callsites.

Though it is benign, the additional check against the
PSCI kvm_psci_1_x_call() is unnecessary and likely to be missed the next
time KVM raises its maximum PSCI version. Drop the check altogether and
rely on sanitization when the PSCI version is set by userspace.

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
---

Sorry for not sending this with the other ones. I took another read and
do not believe this check is necessary + might hurt when we raise the
PSCI version again.

Applies on top of the series [1], which itself is based on kvmarm/next
at commit:

  21ea45784275 ("KVM: arm64: fix typos in comments")

[1]: http://lore.kernel.org/r/20220318193831.482349-1-oupton@google.com

 arch/arm64/kvm/psci.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 0d771468b708..7cd3fe62275f 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -315,9 +315,6 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
 	unsigned long val;
 	int ret = 1;
 
-	if (minor > 1)
-		return -EINVAL;
-
 	val = kvm_psci_check_allowed_function(vcpu, psci_fn);
 	if (val)
 		goto out;
-- 
2.35.1.894.gb6a874cedc-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
