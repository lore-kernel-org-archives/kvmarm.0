Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5C117279E
	for <kvmarm@lists.linux.dev>; Mon,  7 Oct 2024 23:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728343846; cv=none; b=YK97PHsr/Evg54nEuVROYiVLaOMPfzwJ4G0N8IbRMLVoBUCAEhR6VODbzXFybWHup2PRUzGpFnK9MX8jtaHtilkk87UtSXo+L4HLV6v6XcpsfYcf7MBbKF+uQdz+mEB9xLMu09tptB0ymDtIgl+HumZW13gxeCcHL0d6O/ZKvF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728343846; c=relaxed/simple;
	bh=sTeSGcniAwd4HsJNFjnoKDNNfQxvYIe6P8GvDP7rk7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AVNnlwB6OvR0JrEu/3ajFiYXbCTHrlOGcN20pKvbY+UblcxobSmaTdstXF7KWkuH1TrjcCC5pd5FZCBPCriTPt+8q0vynqHFq7bMv4TpfFOj5+dMtc7DphqqMQOXhplkIqMwZDvv1MMgk19eMZvcgCx88sMJVmR2XvnvcYTPGkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NPasr4xT; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NPasr4xT"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728343843;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GNmRrXPAjtnsG1Z2nHodndBI5zpjK65cKSlPcuWMf6I=;
	b=NPasr4xTYUI+37bx0hQgwv+5dp0E6P8spNcoHA/B3L/cSodUQ7eXJUdEJwY933tKGJC+On
	L2HoHJpE76Erh7hqL5X9grCr9Cnv+B8asYMbcVdNj1zCMeiwFVxV4t2tVEnaqMsQXPEbYW
	5Ft0yvyHr1JFkKWOGaT7/HVXsgQo3FE=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sean Christopherson <seanjc@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 3/4] KVM: arm64: nv: Punt stage-2 recycling to a vCPU request
Date: Mon,  7 Oct 2024 23:30:27 +0000
Message-ID: <20241007233028.2236133-4-oliver.upton@linux.dev>
In-Reply-To: <20241007233028.2236133-1-oliver.upton@linux.dev>
References: <20241007233028.2236133-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Currently, when a nested MMU is repurposed for some other MMU context,
KVM unmaps everything during vcpu_load() while holding the MMU lock for
write. This is quite a performance bottleneck for large nested VMs, as
all vCPU scheduling will spin until the unmap completes.

Start punting the MMU cleanup to a vCPU request, where it is then
possible to periodically release the MMU lock and CPU in the presence of
contention.

Ensure that no vCPU winds up using a stale MMU by tracking the pending
unmap on the S2 MMU itself and requesting an unmap on every vCPU that
finds it.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h   |  7 +++++++
 arch/arm64/include/asm/kvm_nested.h |  2 ++
 arch/arm64/kvm/arm.c                |  2 ++
 arch/arm64/kvm/nested.c             | 28 ++++++++++++++++++++++++++--
 4 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 329619c6fa96..89707b8bf753 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -51,6 +51,7 @@
 #define KVM_REQ_RELOAD_PMU	KVM_ARCH_REQ(5)
 #define KVM_REQ_SUSPEND		KVM_ARCH_REQ(6)
 #define KVM_REQ_RESYNC_PMU_EL0	KVM_ARCH_REQ(7)
+#define KVM_REQ_NESTED_S2_UNMAP	KVM_ARCH_REQ(8)
 
 #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
 				     KVM_DIRTY_LOG_INITIALLY_SET)
@@ -211,6 +212,12 @@ struct kvm_s2_mmu {
 	 */
 	bool	nested_stage2_enabled;
 
+	/*
+	 * true when this MMU needs to be unmapped before being used for a new
+	 * purpose.
+	 */
+	bool	pending_unmap;
+
 	/*
 	 *  0: Nobody is currently using this, check vttbr for validity
 	 * >0: Somebody is actively using this.
diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index e74b90dcfac4..233e65522716 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -78,6 +78,8 @@ extern void kvm_s2_mmu_iterate_by_vmid(struct kvm *kvm, u16 vmid,
 extern void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu);
 extern void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu);
 
+extern void check_nested_vcpu_requests(struct kvm_vcpu *vcpu);
+
 struct kvm_s2_trans {
 	phys_addr_t output;
 	unsigned long block_size;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a0d01c46e408..c7b659604bae 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1031,6 +1031,8 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
 
 		if (kvm_dirty_ring_check_request(vcpu))
 			return 0;
+
+		check_nested_vcpu_requests(vcpu);
 	}
 
 	return 1;
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 58d3b998793a..c4b17d90fc49 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -632,9 +632,9 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
 	/* Set the scene for the next search */
 	kvm->arch.nested_mmus_next = (i + 1) % kvm->arch.nested_mmus_size;
 
-	/* Clear the old state */
+	/* Make sure we don't forget to do the laundry */
 	if (kvm_s2_mmu_valid(s2_mmu))
-		kvm_stage2_unmap_range(s2_mmu, 0, kvm_phys_size(s2_mmu), false);
+		s2_mmu->pending_unmap = true;
 
 	/*
 	 * The virtual VMID (modulo CnP) will be used as a key when matching
@@ -650,6 +650,16 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
 
 out:
 	atomic_inc(&s2_mmu->refcnt);
+
+	/*
+	 * Set the vCPU request to perform an unmap, even if the pending unmap
+	 * originates from another vCPU. This guarantees that the MMU has been
+	 * completely unmapped before any vCPU actually uses it, and allows
+	 * multiple vCPUs to lend a hand with completing the unmap.
+	 */
+	if (s2_mmu->pending_unmap)
+		kvm_make_request(KVM_REQ_NESTED_S2_UNMAP, vcpu);
+
 	return s2_mmu;
 }
 
@@ -1199,3 +1209,17 @@ int kvm_init_nv_sysregs(struct kvm *kvm)
 
 	return 0;
 }
+
+void check_nested_vcpu_requests(struct kvm_vcpu *vcpu)
+{
+	if (kvm_check_request(KVM_REQ_NESTED_S2_UNMAP, vcpu)) {
+		struct kvm_s2_mmu *mmu = vcpu->arch.hw_mmu;
+
+		write_lock(&vcpu->kvm->mmu_lock);
+		if (mmu->pending_unmap) {
+			kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), true);
+			mmu->pending_unmap = false;
+		}
+		write_unlock(&vcpu->kvm->mmu_lock);
+	}
+}
-- 
2.47.0.rc0.187.ge670bccf7e-goog

