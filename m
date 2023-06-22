Received: from out-23.mta1.migadu.com (out-23.mta1.migadu.com [95.215.58.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484AD3AA98
	for <kvmarm@lists.linux.dev>; Thu, 22 Jun 2023 16:09:41 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1687450180;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=RATq31thgcRcKHIS3suxp2EOPxfIIWyNrIJxfCZemIM=;
	b=cB3rzpHCR3jtOIL+yuo9EOd8Cp9hHofgA03KgfzHiwaTBAUhoZqqihpbA6fiqAtJajNvS6
	QlB8+VpuriwKRb1Xaaqp+p7ZASr5F7RpWZpctUadSQEWUUw4pFzEr5l2OIvnNrOXvntU7L
	rCgNXDDMtEs+ivO9qQruemzswFgDysY=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH] KVM: arm64: Fix misuse of KVM_ARM_VCPU_POWER_OFF bit index
Date: Thu, 22 Jun 2023 16:09:22 +0000
Message-ID: <20230622160922.1925530-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

KVM_ARM_VCPU_POWER_OFF is as bit index, _not_ a literal bitmask.
Nonetheless, commit e3c1c0cae31e ("KVM: arm64: Relax invariance
of KVM_ARM_VCPU_POWER_OFF") started using it that way, meaning that
powering off a vCPU with the KVM_ARM_VCPU_INIT ioctl is completely
broken.

Fix it by using a shifted bit for the bitwise operations instead.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Fixes: e3c1c0cae31e ("KVM: arm64: Relax invariance of KVM_ARM_VCPU_POWER_OFF")
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/arm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 80ca7ec269dc..7d20bfd77e1c 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1250,8 +1250,8 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 	 * reflecting it in the finalized feature set, thus limiting its scope
 	 * to a single KVM_ARM_VCPU_INIT call.
 	 */
-	if (init->features[0] & KVM_ARM_VCPU_POWER_OFF) {
-		init->features[0] &= ~KVM_ARM_VCPU_POWER_OFF;
+	if (init->features[0] & (1UL << KVM_ARM_VCPU_POWER_OFF)) {
+		init->features[0] &= ~(1UL << KVM_ARM_VCPU_POWER_OFF);
 		power_off = true;
 	}
 

base-commit: 686672407e6eaf8c874d4a6bf315da798f281045
-- 
2.41.0.185.g7c58973941-goog

