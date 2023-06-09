Received: from out-19.mta1.migadu.com (out-19.mta1.migadu.com [95.215.58.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA6F408EE
	for <kvmarm@lists.linux.dev>; Fri,  9 Jun 2023 19:01:11 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1686337269;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9BSuh5Q5IEL511Ru0FSGzPDSAuZ9VLVSvBqaJ5AKQq8=;
	b=gapKDPK0aWqkhA/pxeEc9E/VL/5R1C+pSYB/yyqtNtyhSTMpU/ttibcwjXVNd4pfUmEAkS
	2xQQwOCaCJ4hVYvV+3DWvWAJpmMXV4qQOwzaTAKN/OQ7xCIFkTW4YpBVGaCKTaMr8IrEnf
	PqlX5q9NMS0n3J+NIHITDz5hAXNYEiI=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-arm-kernel@lists.infradead.org,
	surajjs@amazon.com,
	Cornelia Huck <cohuck@redhat.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Jing Zhang <jingzhangos@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v12 02/11] KVM: arm64: Relax invariance of KVM_ARM_VCPU_POWER_OFF
Date: Fri,  9 Jun 2023 19:00:45 +0000
Message-ID: <20230609190054.1542113-3-oliver.upton@linux.dev>
In-Reply-To: <20230609190054.1542113-1-oliver.upton@linux.dev>
References: <20230609190054.1542113-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Allow the value of KVM_ARM_VCPU_POWER_OFF to differ between calls to
KVM_ARM_VCPU_INIT. Userspace can already change the state of the vCPU
through the KVM_SET_MP_STATE ioctl, so making the bit invariant seems
needlessly restrictive.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/arm.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index d5298054a8ed..a9c18f45df3f 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1236,8 +1236,19 @@ static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
 static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 					 struct kvm_vcpu_init *init)
 {
+	bool power_off = false;
 	int ret;
 
+	/*
+	 * Treat the power-off vCPU feature as ephemeral. Clear the bit to avoid
+	 * reflecting it in the finalized feature set, thus limiting its scope
+	 * to a single KVM_ARM_VCPU_INIT call.
+	 */
+	if (init->features[0] & KVM_ARM_VCPU_POWER_OFF) {
+		init->features[0] &= ~KVM_ARM_VCPU_POWER_OFF;
+		power_off = true;
+	}
+
 	ret = kvm_vcpu_set_target(vcpu, init);
 	if (ret)
 		return ret;
@@ -1266,7 +1277,7 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 	 */
 	spin_lock(&vcpu->arch.mp_state_lock);
 
-	if (test_bit(KVM_ARM_VCPU_POWER_OFF, vcpu->arch.features))
+	if (power_off)
 		__kvm_arm_vcpu_power_off(vcpu);
 	else
 		WRITE_ONCE(vcpu->arch.mp_state.mp_state, KVM_MP_STATE_RUNNABLE);
-- 
2.41.0.162.gfafddb0af9-goog

