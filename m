Received: from out-33.mta1.migadu.com (out-33.mta1.migadu.com [95.215.58.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213B6107B7
	for <kvmarm@lists.linux.dev>; Fri, 23 Jun 2023 19:43:13 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1687549392;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M4AUwWimPgF8ETigc4QIvYIsPbcUoZH0zPyuJWqIHNM=;
	b=FnZ9JGzm5hyfQGCk8CNye7Gxv9rCSlutQRo8ByViW1MwI2N2xvbEDkFfprqsTHEZjz0LZs
	XKORaXdc+A6XQHdTj9+fhtUOOlBJdYihMMV1Rqn9YZ/J4H9NORzVfDECCIoe4l7kiL/VgH
	kzAMzphP3z9cX5aW97Iu+fMrlYJS5TE=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jing Zhang <jingzhangos@google.com>,
	Reiji Watanabe <reijiw@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 2/4] KVM: arm64: Remove pointless check for changed init target
Date: Fri, 23 Jun 2023 19:42:56 +0000
Message-ID: <20230623194258.2648987-3-oliver.upton@linux.dev>
In-Reply-To: <20230623194258.2648987-1-oliver.upton@linux.dev>
References: <20230623194258.2648987-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

At any time there is only a single valid value for KVM_ARM_VCPU_INIT,
depending on the current CPU implementation. In all likelihood, this
will be the generic ARMv8 target.

Drop the pointless check for a changed target value between calls to
KVM_ARM_VCPU_INIT and instead rely on the check against
kvm_target_cpu().

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/arm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index c2c14059f6a8..3f844934b9f3 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1212,8 +1212,7 @@ static bool kvm_vcpu_init_changed(struct kvm_vcpu *vcpu,
 {
 	unsigned long features = init->features[0];
 
-	return !bitmap_equal(vcpu->arch.features, &features, KVM_VCPU_MAX_FEATURES) ||
-			vcpu->arch.target != init->target;
+	return !bitmap_equal(vcpu->arch.features, &features, KVM_VCPU_MAX_FEATURES);
 }
 
 static int __kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
-- 
2.41.0.178.g377b9f9a00-goog

