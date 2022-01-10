Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56C16C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 10 Jan 2022 05:41:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A82EE4B1F7;
	Mon, 10 Jan 2022 00:41:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4+IcEtbvg+Cj; Mon, 10 Jan 2022 00:41:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 99D0B4B1FC;
	Mon, 10 Jan 2022 00:41:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E9FA4B1F5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 00:41:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 09zFQFZuIcZU for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Jan 2022 00:41:12 -0500 (EST)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 955BD4B1AC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 00:41:12 -0500 (EST)
Received: by mail-pj1-f73.google.com with SMTP id
 d92-20020a17090a6f6500b001b35ac5f393so8138274pjk.7
 for <kvmarm@lists.cs.columbia.edu>; Sun, 09 Jan 2022 21:41:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=P1aAJUJH4MNJA7hqf+LRqj2aY6nDmgn4ybYnyTkArAE=;
 b=DKYr9uQS09X33zIc7+1zVb3NQ0xRf8HBTMLLm3p4pinup+CxLE+HbHLqhHvzqvqAb3
 olhmXPyqbPsUCCdHiJUGtosE19JLvR49S1qjZI4NX924Y68uziCJNmqT7LElQs3CUgru
 ExwQbM7Qg6Bp7LwtNaXcprLPD7B9xYFoOVH2UWJDlxBXG+XmnTWYmM1BLt8KxaIs0Ln/
 W4dqLxfV+V9VxkGMAIITblVgrtK4ZoaKN54r589zJ60edJKeaDB8mrTHaHEhBl8zRdZ5
 R3D+YC4m8EYrXYfBL75jWzbnqUsG/7N57JvFqLytLroLG8h0FO7JdV6M7gHFF0CP0/Lb
 9J2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=P1aAJUJH4MNJA7hqf+LRqj2aY6nDmgn4ybYnyTkArAE=;
 b=d3oEPax0rVEGMAXlPdRAr39pf3hB90SEv7c4Z5MBity1GI63CRXcyvhVJKrYRys9Yt
 F9PJP8qO2uG2b4ItFutjD+3bjyXv4s2fKBTAkcm/IyKI2vAuOGGCH4rIZhG9H28TzMvi
 16JnnFK9jWs1l/7FICjGW2RairQGWb5M+N57oXSZqX8hwUoJGl86M5Rs80oDbzYpBZlg
 TK6d6HisW7EFS2sjqpnQylwaCQB3I6hL6eggO+iAEEbZYwvFjH8Q9UoYdCJtrimWesVH
 FtfwSqdSJ9AxAq/SSDVLtmiCSUgpsAE8ojBg5X6V0Nx4hvT/4rBwqbd0eIRmVNdWw5BQ
 5lfQ==
X-Gm-Message-State: AOAM531iUewthFwAdz/TFbYplSaPsBr3Tu1c5Mus26P5jQf0NUnKt29P
 VRK9EYrBYNhYgjEXuQ5ANK/a1xO9dUI=
X-Google-Smtp-Source: ABdhPJy2ff3+Ra0eAAdVIR8qPPRFVBp537t4vFeJtOPbXf4dGRZKqRvR8mgwpxO5W3cOouanq7W4upyND6M=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:d64:b0:4ba:cb6f:87e0 with SMTP id
 n36-20020a056a000d6400b004bacb6f87e0mr74125375pfv.72.1641793271719; Sun, 09
 Jan 2022 21:41:11 -0800 (PST)
Date: Sun,  9 Jan 2022 21:40:41 -0800
Message-Id: <20220110054042.1079932-1-reijiw@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.575.g55b058a8bb-goog
Subject: [PATCH 1/2] KVM: arm64: mixed-width check should be skipped for
 uninitialized vCPUs
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org
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

vcpu_allowed_register_width() checks if all the VCPUs are either
all 32bit or all 64bit.  Since the checking is done even for vCPUs
that are not initialized (KVM_ARM_VCPU_INIT has not been done) yet,
the non-initialized vCPUs are erroneously treated as 64bit vCPU,
which causes the function to incorrectly detect a mixed-width VM.

Fix vcpu_allowed_register_width() to skip the check for vCPUs that
are not initialized yet.

Fixes: 66e94d5cafd4 ("KVM: arm64: Prevent mixed-width VM creation")
Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/reset.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 426bd7fbc3fd..ef78bbc7566a 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -180,8 +180,19 @@ static bool vcpu_allowed_register_width(struct kvm_vcpu *vcpu)
 	if (kvm_has_mte(vcpu->kvm) && is32bit)
 		return false;
 
+	/*
+	 * Make sure vcpu->arch.target setting is visible from others so
+	 * that the width consistency checking between two vCPUs is done
+	 * by at least one of them at KVM_ARM_VCPU_INIT.
+	 */
+	smp_mb();
+
 	/* Check that the vcpus are either all 32bit or all 64bit */
 	kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
+		/* Skip if KVM_ARM_VCPU_INIT is not done for the vcpu yet */
+		if (tmp->arch.target == -1)
+			continue;
+
 		if (vcpu_has_feature(tmp, KVM_ARM_VCPU_EL1_32BIT) != is32bit)
 			return false;
 	}

base-commit: df0cc57e057f18e44dac8e6c18aba47ab53202f9
-- 
2.34.1.575.g55b058a8bb-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
