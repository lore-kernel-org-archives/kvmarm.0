Return-Path: <SRS0=qZbx=TQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 803F0C04AB4
	for <kvmarm@archiver.kernel.org>; Thu, 16 May 2019 11:40:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F08052166E
	for <kvmarm@archiver.kernel.org>; Thu, 16 May 2019 11:40:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="whVd+GPS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F08052166E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BB1B4A4E5;
	Thu, 16 May 2019 07:40:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3lkhIkiM2R9m; Thu, 16 May 2019 07:40:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6120C4A4D4;
	Thu, 16 May 2019 07:40:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD6294A4C6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 May 2019 07:40:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XQpHBFp9Hkg6 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 May 2019 07:39:59 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6F50A4A369
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 May 2019 07:39:59 -0400 (EDT)
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net
 [73.47.72.35])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 7970320862;
 Thu, 16 May 2019 11:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1558006798;
 bh=CF5+kLRFNxDfWRKm3e7Wn+rgcDaHbU6jyhlCwi/ZtrM=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=whVd+GPSv+oRmFk9phUWD1DSKTWXK+KEbZ5uLiHobr3sZzXtZ0EheIjJnT3JmTxMw
 iUyHpwLv2lpNqJ7Nb72dBr16EJGPWLtoqehizCqBAx4CI9+nKA1xW3Y9N+XNvuM3W9
 549e5BexC8S6mDrgP47J1yJz4dWkAQTCZ8O+/wbM=
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 20/34] KVM: arm/arm64: Ensure vcpu target is unset
 on reset failure
Date: Thu, 16 May 2019 07:39:17 -0400
Message-Id: <20190516113932.8348-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190516113932.8348-1-sashal@kernel.org>
References: <20190516113932.8348-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Cc: Marc Zyngier <marc.zyngier@arm.com>, Sasha Levin <sashal@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

From: Andrew Jones <drjones@redhat.com>

[ Upstream commit 811328fc3222f7b55846de0cd0404339e2e1e6d7 ]

A failed KVM_ARM_VCPU_INIT should not set the vcpu target,
as the vcpu target is used by kvm_vcpu_initialized() to
determine if other vcpu ioctls may proceed. We need to set
the target before calling kvm_reset_vcpu(), but if that call
fails, we should then unset it and clear the feature bitmap
while we're at it.

Signed-off-by: Andrew Jones <drjones@redhat.com>
[maz: Simplified patch, completed commit message]
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/arm/arm.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 9c486fad3f9f8..6202b4f718cea 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -949,7 +949,7 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_level,
 static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
 			       const struct kvm_vcpu_init *init)
 {
-	unsigned int i;
+	unsigned int i, ret;
 	int phys_target = kvm_target_cpu();
 
 	if (init->target != phys_target)
@@ -984,9 +984,14 @@ static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
 	vcpu->arch.target = phys_target;
 
 	/* Now we know what it is, we can reset it. */
-	return kvm_reset_vcpu(vcpu);
-}
+	ret = kvm_reset_vcpu(vcpu);
+	if (ret) {
+		vcpu->arch.target = -1;
+		bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
+	}
 
+	return ret;
+}
 
 static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 					 struct kvm_vcpu_init *init)
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
