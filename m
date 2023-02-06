Received: from out-214.mta1.migadu.com (out-214.mta1.migadu.com [95.215.58.214])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ACCB7F
	for <kvmarm@lists.linux.dev>; Tue,  7 Feb 2023 01:21:26 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1675727567;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=oSxRZGZxs/XExY9w4DSgRyxd/gRTVlq/nNC2hab9vvI=;
	b=hiKWCsL761e83+q0KmkByIECez+xvIjKjy7W5HbD1Bqul8Hl6Rs3Y5bR6zOCyu8S21wVBG
	nqBCp89ZQRaPK4wb6enPGX7iAP110nvxuwigS0U+67Jrxv1vf/eYj3oLbD1A9mKnGc1uqp
	zHLVCxumbIrfkHPGslKOcH7izqOTGPQ=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	kvmarm@lists.linux.dev,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH] KVM: arm64: Mark some VM-scoped allocations as __GFP_ACCOUNT
Date: Mon,  6 Feb 2023 23:52:29 +0000
Message-Id: <20230206235229.4174711-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Generally speaking, any memory allocations that can be associated with a
particular VM should be charged to the cgroup of its process.
Nonetheless, there are a couple spots in KVM/arm64 that aren't currently
accounted:

 - the ccsidr array containing the virtualized cache hierarchy

 - the cpumask of supported cpus, for use of the vPMU on heterogeneous
   systems

Go ahead and set __GFP_ACCOUNT for these allocations.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---

 Applies to github.com/oupton/linux kvm-arm64/virtual-cache-geometry

 arch/arm64/kvm/arm.c      | 2 +-
 arch/arm64/kvm/sys_regs.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9c5573bc4614..3619f1e472f5 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -146,7 +146,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (ret)
 		goto err_unshare_kvm;
 
-	if (!zalloc_cpumask_var(&kvm->arch.supported_cpus, GFP_KERNEL)) {
+	if (!zalloc_cpumask_var(&kvm->arch.supported_cpus, GFP_KERNEL_ACCOUNT)) {
 		ret = -ENOMEM;
 		goto err_unshare_kvm;
 	}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 6a742af8010f..5dc13d02721e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -160,7 +160,7 @@ static int set_ccsidr(struct kvm_vcpu *vcpu, u32 csselr, u32 val)
 		if (val == get_ccsidr(vcpu, csselr))
 			return 0;
 
-		ccsidr = kmalloc_array(CSSELR_MAX, sizeof(u32), GFP_KERNEL);
+		ccsidr = kmalloc_array(CSSELR_MAX, sizeof(u32), GFP_KERNEL_ACCOUNT);
 		if (!ccsidr)
 			return -ENOMEM;
 
-- 
2.39.1.519.gcb327c4b5f-goog

