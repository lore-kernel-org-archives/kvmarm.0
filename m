Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ACFDC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 23 Nov 2021 16:37:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 365714B1AD;
	Tue, 23 Nov 2021 11:37:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ojMPKq7hwTXP; Tue, 23 Nov 2021 11:37:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF1634B1CA;
	Tue, 23 Nov 2021 11:37:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B07B4B1CA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Nov 2021 11:37:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FybmXGx1ebfw for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Nov 2021 11:37:03 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6402C4B1AD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Nov 2021 11:37:03 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 925F560F90;
 Tue, 23 Nov 2021 16:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1637685422;
 bh=ph8ObFbS8FOqN0/4yg+iMdjHcoQg5c5WDq4v+jpLOoM=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=Flo0GOrE6WQx5Vuq80BoHrdHWeNNgVfMRrcsSik9BLffxNINWA9xPBRczZrtS2XEn
 OdOIhPk+HLeOAz6vGAi1zJaVyM3oS3WiKILvWJiG4tRhaKEjDj6lWwviopuBOJKIeg
 9ttXuc4DJtYQVleoBWEV9jfHO1Mk4KTZGvhTLI6FBOfGKJG3lKsTq2p4CQEowMQCcN
 fLDj11o6TqxrjaFCPB1o9Q+w08UU3s+hg/x+m29OjpKolt7G4kYC3LLuj7wV2mlfMV
 vGyVeT2c20DjLJfIig3k0L7DmV0/SInFO7RmeYN0Vg2Eb8Todz+DBN7tDN940oNiTz
 vXF684/NWumuA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH MANUALSEL 5.10 5/5] KVM: arm64: Cap KVM_CAP_NR_VCPUS by
 kvm_arm_default_max_vcpus()
Date: Tue, 23 Nov 2021 11:36:49 -0500
Message-Id: <20211123163652.289483-5-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211123163652.289483-1-sashal@kernel.org>
References: <20211123163652.289483-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Cc: Sasha Levin <sashal@kernel.org>, Marc Zyngier <maz@kernel.org>,
 catalin.marinas@arm.com, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

From: Vitaly Kuznetsov <vkuznets@redhat.com>

[ Upstream commit f60a00d7295057cb4baea5a321501efc72794453 ]

Generally, it doesn't make sense to return the recommended maximum number
of vCPUs which exceeds the maximum possible number of vCPUs.

Note: ARM64 is special as the value returned by KVM_CAP_MAX_VCPUS differs
depending on whether it is a system-wide ioctl or a per-VM one. Previously,
KVM_CAP_NR_VCPUS didn't have this difference and it seems preferable to
keep the status quo. Cap KVM_CAP_NR_VCPUS by kvm_arm_default_max_vcpus()
which is what gets returned by system-wide KVM_CAP_MAX_VCPUS.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20211116163443.88707-2-vkuznets@redhat.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/arm.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 5bc978be80434..7737a10ba735f 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -204,7 +204,14 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = 1;
 		break;
 	case KVM_CAP_NR_VCPUS:
-		r = num_online_cpus();
+		/*
+		 * ARM64 treats KVM_CAP_NR_CPUS differently from all other
+		 * architectures, as it does not always bound it to
+		 * KVM_CAP_MAX_VCPUS. It should not matter much because
+		 * this is just an advisory value.
+		 */
+		r = min_t(unsigned int, num_online_cpus(),
+			  kvm_arm_default_max_vcpus());
 		break;
 	case KVM_CAP_MAX_VCPUS:
 	case KVM_CAP_MAX_VCPU_ID:
-- 
2.33.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
