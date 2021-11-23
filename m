Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 262D4C43219
	for <kvmarm@archiver.kernel.org>; Tue, 23 Nov 2021 16:36:53 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A31D04B20E;
	Tue, 23 Nov 2021 11:36:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ARfZCRQpoupv; Tue, 23 Nov 2021 11:36:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AAC94B1B2;
	Tue, 23 Nov 2021 11:36:52 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B05F4B172
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Nov 2021 11:36:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1FP74PwFMKlr for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Nov 2021 11:36:50 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 261214B126
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Nov 2021 11:36:50 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E04C60F5D;
 Tue, 23 Nov 2021 16:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1637685409;
 bh=plK5J/t7M/GlW86iF1TJCxPLnyKdb3OQjKr63ahMX9M=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=gL+JfqMn4zmSYTLx2l+OXc+j6OKAqMORXivtQvMguOjH7gWVn7AklM7Sa3jVHaVxT
 Ju4PJp7tl280dwFY/Rpj5Ij4XImwQ+rOt7onZ6rUaiEsu2sqQ6gxTZIl+EkBqAwtAE
 RX/EFRUzIzdf29cldJIcYM7j9VBulAmH1RlAr1l0Mv0eov4JiOBD/EXdiJhb6B1B0S
 M3x7lEdmwsip5gXgKoJaWsut1KIuIaCRoX7xlgB71iL0jKw0QOxS2Vl6nntwXStLhc
 Mx9Axbg9USK/tBnuZkQSIKPOWO/rkG7GEpDoZk9fdlLp4SzF6mihaQgftQnI+Eg+JR
 AoFu+LNY6lX9A==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH MANUALSEL 5.15 8/8] KVM: arm64: Cap KVM_CAP_NR_VCPUS by
 kvm_arm_default_max_vcpus()
Date: Tue, 23 Nov 2021 11:36:30 -0500
Message-Id: <20211123163630.289306-8-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211123163630.289306-1-sashal@kernel.org>
References: <20211123163630.289306-1-sashal@kernel.org>
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
index 9b328bb05596a..1ed82b6d5e8db 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -223,7 +223,14 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
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
