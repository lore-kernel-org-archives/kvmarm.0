Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BD24C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 22 Mar 2022 18:35:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C77C149EE8;
	Tue, 22 Mar 2022 14:35:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 85debvydDF5L; Tue, 22 Mar 2022 14:35:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC8E349F5A;
	Tue, 22 Mar 2022 14:35:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC64149F14
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 14:35:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1XWY+ZsaMjTT for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Mar 2022 14:35:47 -0400 (EDT)
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com
 [209.85.166.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B386F49F35
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 14:35:47 -0400 (EDT)
Received: by mail-il1-f201.google.com with SMTP id
 x6-20020a923006000000b002bea39c3974so9664387ile.12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 11:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=lGW+qCdwzMwtGGlVg3y2ePu73Q+JTzIqWyWeB9h5azY=;
 b=Q4h5St4bE4rOW155Wn3EO80R//PDfJqRJZaeS2M2PHHwYAb5zLlzGAVLgI+8KcM5ue
 vASo5TsEVfEDWKQe/g/0ORUybF8ztFa/MVDOQTAcoaq+H538ch/z0Yxpf5sxOtMhO/mj
 1NvKR21tAZKlMkbhpGRqDnpFi0D2OUA2wDtnJwJEzaeaHmJNhVRNzuckM5UlO7U51Ccc
 YITlUK4lhH8zzVZtT2cDQSglIjKg4ygFpPgqjdjQ65imS+SRIzOc+5z7sPxPB2ce2sdq
 735gTDGZlMN8ChNHrTDGsmrGpERbIKbMzkO6tB3B2eNNL7XLUe98wL3O7tuwW3BJpocx
 qdZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=lGW+qCdwzMwtGGlVg3y2ePu73Q+JTzIqWyWeB9h5azY=;
 b=KCNqdGVxFXv5py5NjVktB+BPgtf6iUwfqZ1VPB9EyQfeKSe2KRAO7Iw5WtnoHQ5XST
 gXF7pHLgIclXZOm8wd3QdSmyrBNmDKAA3ifuWmpxTSe/aBXeSsF5q6Tjfq7GuTwWOyVh
 DaKSAX1dBU+HJt7xbEFtdfp4nxEO8p6y0bqCPmRzoQmeHePF9JuFYNrClil23CLuVKRQ
 EyFbvjRyt4Jdao7YyFJkQoHb9iZwimSbo2JSypt2mIz3YfENmwgATvqosKkm2Bi+3cE3
 fS1wHkSP8OlzkuERhraMasAR4Tkdh+S8qkB/o+gZuyM/Sn5X8IxTqtBoRDkekF++VQKb
 S4xA==
X-Gm-Message-State: AOAM532aXbVjxlCIStlgsxlEvps2bDgtR+Ve6GoyuXWyQbL6xqifTtRt
 1bqiyKy8lZFGUTI5Q4PJU3ZigtUrQT1uBc5zkTvY7FkUtbc+5hwmiFFtlgBNd90eRGiiGEPjfxx
 KThoiVVslxDup2LNc13RTpnN7fCfe8kEH+CxxUSx1Sr9cAYu7VRufYtfkEl5veDPs4qLWTg==
X-Google-Smtp-Source: ABdhPJxYqKXNgdI2Nn0wjD8p/zp8eXY/Rgm3sPEio6NQXm4jTPjyEFh8n9PKO7v2VGbk1KOuPT1TekwRGKE=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a92:d486:0:b0:2c7:b549:ede7 with
 SMTP id
 p6-20020a92d486000000b002c7b549ede7mr12361089ilg.84.1647974147115; Tue, 22
 Mar 2022 11:35:47 -0700 (PDT)
Date: Tue, 22 Mar 2022 18:35:38 +0000
In-Reply-To: <20220322183538.2757758-1-oupton@google.com>
Message-Id: <20220322183538.2757758-4-oupton@google.com>
Mime-Version: 1.0
References: <20220322183538.2757758-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH v2 3/3] KVM: arm64: Drop unneeded minor version check from
 PSCI v1.x handler
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
 arch/arm64/kvm/psci.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index d24ccc77500b..0b1b588f1f9b 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -310,9 +310,6 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
 	unsigned long val;
 	int ret = 1;
 
-	if (minor > 1)
-		return -EINVAL;
-
 	switch(psci_fn) {
 	case PSCI_0_2_FN_PSCI_VERSION:
 		val = minor == 0 ? KVM_ARM_PSCI_1_0 : KVM_ARM_PSCI_1_1;
-- 
2.35.1.894.gb6a874cedc-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
