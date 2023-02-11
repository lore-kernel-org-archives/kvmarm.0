Received: from out-248.mta1.migadu.com (out-248.mta1.migadu.com [95.215.58.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8907F4
	for <kvmarm@lists.linux.dev>; Sat, 11 Feb 2023 01:47:26 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1676079492;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SnleMSFb+rskKwYj4g6FPeijRBKlwpY8LmQKrkG/ANo=;
	b=nztVWU9+Q7ym6nSUBYzgYeAyrMBfd/c406v3xQtei5pQdZ5jHcvInPraLAwgYvWjDqcp0r
	3jpX3ODaav/lhtF4UZ9wggAIPTlux0040sD5Ln0AzT+BBNJra8aGXU4jjPi7esbr1TqsJ3
	+ODX5l8KYfXXQWPJgjE0MVW7NR/xbI8=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	kvmarm@lists.linux.dev,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org,
	Salil Mehta <salil.mehta@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [RFC PATCH v2 1/6] KVM: arm64: Add a helper to check if a VM has ran once
Date: Sat, 11 Feb 2023 01:37:54 +0000
Message-Id: <20230211013759.3556016-2-oliver.upton@linux.dev>
In-Reply-To: <20230211013759.3556016-1-oliver.upton@linux.dev>
References: <20230211013759.3556016-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The test_bit(...) pattern is quite a lot of keystrokes. Replace
existing callsites with a helper.

No functional change intended.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h | 3 +++
 arch/arm64/kvm/pmu-emul.c         | 4 ++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 35a159d131b5..012e94bc9e4a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1019,6 +1019,9 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
 	(system_supports_32bit_el0() &&				\
 	 !static_branch_unlikely(&arm64_mismatched_32bit_el0))
 
+#define kvm_vm_has_ran_once(kvm)					\
+	(test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &(kvm)->arch.flags))
+
 int kvm_trng_call(struct kvm_vcpu *vcpu);
 #ifdef CONFIG_KVM
 extern phys_addr_t hyp_mem_base;
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 24908400e190..a0fc569fdbca 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -880,7 +880,7 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
 	list_for_each_entry(entry, &arm_pmus, entry) {
 		arm_pmu = entry->arm_pmu;
 		if (arm_pmu->pmu.type == pmu_id) {
-			if (test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &kvm->arch.flags) ||
+			if (kvm_vm_has_ran_once(kvm) ||
 			    (kvm->arch.pmu_filter && kvm->arch.arm_pmu != arm_pmu)) {
 				ret = -EBUSY;
 				break;
@@ -963,7 +963,7 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 
 		mutex_lock(&kvm->lock);
 
-		if (test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &kvm->arch.flags)) {
+		if (kvm_vm_has_ran_once(kvm)) {
 			mutex_unlock(&kvm->lock);
 			return -EBUSY;
 		}
-- 
2.39.1.581.gbfd45094c4-goog

