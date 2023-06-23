Received: from out-18.mta1.migadu.com (out-18.mta1.migadu.com [95.215.58.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2B41078A
	for <kvmarm@lists.linux.dev>; Fri, 23 Jun 2023 19:43:17 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1687549395;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xo78XdM1xxQ3YTpkgHbHC9I9D7DrEHA7xRVY/dCqGKs=;
	b=XoOIqotP3IXEsd8vIw69jNmsr2GUJCYAjY4aYmchqUakVjfNSZUNhb7JZbZD8rBgU6FTpS
	SX5qx7CKnoKlfzFCSDIbRg8B8v2kG71jqrGQbKt1kJzwqfIH1zAGYXtRjzsoujl3Gf45Be
	eFMvSmLmEnwtaxJIKoeV+F0+l5NM42I=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jing Zhang <jingzhangos@google.com>,
	Reiji Watanabe <reijiw@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 4/4] KVM: arm64: Always return generic v8 as the preferred target
Date: Fri, 23 Jun 2023 19:42:58 +0000
Message-ID: <20230623194258.2648987-5-oliver.upton@linux.dev>
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

Userspace selecting an implementation-specific vCPU target has been
completely useless for a very long time. Let's go whole hog and start
returning the generic v8 target across all implementations as the
preferred target.

Uphold the pre-existing behavior by tolerating either the generic target
or an implementation-specific target if the vCPU happens to be running
on one of the lucky few parts.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/arm.c   | 3 ++-
 arch/arm64/kvm/guest.c | 4 +---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3fa63fdbbf34..5a3b8b2e779b 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1250,7 +1250,8 @@ static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
 {
 	int ret;
 
-	if (init->target != kvm_target_cpu())
+	if (init->target != KVM_ARM_TARGET_GENERIC_V8 &&
+	    init->target != kvm_target_cpu())
 		return -EINVAL;
 
 	ret = kvm_vcpu_init_check_features(vcpu, init);
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 20280a5233f6..6b099a914fd4 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -886,8 +886,6 @@ u32 __attribute_const__ kvm_target_cpu(void)
 
 void kvm_vcpu_preferred_target(struct kvm_vcpu_init *init)
 {
-	u32 target = kvm_target_cpu();
-
 	memset(init, 0, sizeof(*init));
 
 	/*
@@ -896,7 +894,7 @@ void kvm_vcpu_preferred_target(struct kvm_vcpu_init *init)
 	 * specific features available for the preferred
 	 * target type.
 	 */
-	init->target = (__u32)target;
+	init->target = KVM_ARM_TARGET_GENERIC_V8;
 }
 
 int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
-- 
2.41.0.178.g377b9f9a00-goog

