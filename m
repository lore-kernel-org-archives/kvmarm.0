Received: from out-5.mta0.migadu.com (out-5.mta0.migadu.com [91.218.175.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493A114AB8
	for <kvmarm@lists.linux.dev>; Mon, 10 Jul 2023 19:31:52 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1689017510;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5gJXsGH/UHfES5ZE0tKA6rv91XdL/UO4ZIAmZnB3DBg=;
	b=cuaGnxWfr/uDk3y/DJHFIWtQfu1kQs5SzxbdmaxyvaPw2Q6D4Me5L8s1v0lhPehKruqIAa
	kaSNr6FYvtxtJ0uuinlfnPLSIP8t7fedQw2ozBsZDLkJGPtL+2K7FCdpLWaiizrh/KQYu6
	avObAegE1o0eTt6LgGdWQ5pSuWV713s=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 2/4] KVM: arm64: Remove pointless check for changed init target
Date: Mon, 10 Jul 2023 19:31:38 +0000
Message-ID: <20230710193140.1706399-3-oliver.upton@linux.dev>
In-Reply-To: <20230710193140.1706399-1-oliver.upton@linux.dev>
References: <20230710193140.1706399-1-oliver.upton@linux.dev>
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
2.41.0.255.g8b1d071c50-goog

