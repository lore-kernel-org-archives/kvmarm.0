Received: from out-43.mta0.migadu.com (out-43.mta0.migadu.com [91.218.175.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE342A9F6
	for <kvmarm@lists.linux.dev>; Fri, 26 May 2023 22:17:40 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1685139458;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MU2M1ZiX5q0ate1WNsMicGGyt4l+oxVKOB4rPZVtPdc=;
	b=o2nk8FiBcSon0KJRIx4Tf2UelcNYGYlN+6lPzDozMRPqEveNF49s5Iu3k5DbTBZbP0U1Lh
	cMU4d8zMUCJE81/N4x5xhM7nnT6AwySoTgwrkvs1gIS2Dr/joUIFt0PAjDBb+GG3yFG7pp
	taNWQkaMOFyKXpNyAvbe53Rfayvpz0E=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Salil Mehta <salil.mehta@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH kvmtool 08/21] arm: Add support for resetting a vCPU
Date: Fri, 26 May 2023 22:16:59 +0000
Message-ID: <20230526221712.317287-9-oliver.upton@linux.dev>
In-Reply-To: <20230526221712.317287-1-oliver.upton@linux.dev>
References: <20230526221712.317287-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

In order to handle PSCI, we need a way to reset a vCPU. Fortunately, the
KVM_ARM_VCPU_INIT ioctl is said to have the effect of an architectural
reset. Reconfigure features after the INIT ioctl, if necessary (SVE).

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arm/include/arm-common/kvm-cpu-arch.h |  2 ++
 arm/kvm-cpu.c                         | 14 +++++++++++---
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/arm/include/arm-common/kvm-cpu-arch.h b/arm/include/arm-common/kvm-cpu-arch.h
index bf5223eaa851..64a4fecd0aee 100644
--- a/arm/include/arm-common/kvm-cpu-arch.h
+++ b/arm/include/arm-common/kvm-cpu-arch.h
@@ -38,6 +38,8 @@ void kvm_cpu__set_kvm_arm_generic_target(struct kvm_arm_target *target);
 
 int kvm_cpu__register_kvm_arm_target(struct kvm_arm_target *target);
 
+void kvm_cpu__arm_reset(struct kvm_cpu *vcpu);
+
 static inline bool kvm_cpu__emulate_io(struct kvm_cpu *vcpu, u16 port, void *data,
 				       int direction, int size, u32 count)
 {
diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
index 0ac488a93eef..426fc135f927 100644
--- a/arm/kvm-cpu.c
+++ b/arm/kvm-cpu.c
@@ -35,6 +35,15 @@ int kvm_cpu__register_kvm_arm_target(struct kvm_arm_target *target)
 	return -ENOSPC;
 }
 
+void kvm_cpu__arm_reset(struct kvm_cpu *vcpu)
+{
+	if (ioctl(vcpu->vcpu_fd, KVM_ARM_VCPU_INIT, &vcpu->init))
+		die_perror("KVM_ARM_VCPU_INIT failed");
+
+	if (kvm_cpu__configure_features(vcpu))
+		die("Unable to configure requested vcpu features");
+}
+
 struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 {
 	struct kvm_arm_target *target;
@@ -122,15 +131,14 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 	if (err || target->init(vcpu))
 		die("Unable to initialise vcpu");
 
+	kvm_cpu__arm_reset(vcpu);
+
 	coalesced_offset = ioctl(kvm->sys_fd, KVM_CHECK_EXTENSION,
 				 KVM_CAP_COALESCED_MMIO);
 	if (coalesced_offset)
 		vcpu->ring = (void *)vcpu->kvm_run +
 			     (coalesced_offset * PAGE_SIZE);
 
-	if (kvm_cpu__configure_features(vcpu))
-		die("Unable to configure requested vcpu features");
-
 	return vcpu;
 }
 
-- 
2.41.0.rc0.172.g3f132b7071-goog

