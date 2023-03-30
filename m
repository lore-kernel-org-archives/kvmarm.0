Received: from out-9.mta1.migadu.com (out-9.mta1.migadu.com [95.215.58.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B1CC8836
	for <kvmarm@lists.linux.dev>; Thu, 30 Mar 2023 15:49:42 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1680191380;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=560sj2doaNK8wT5E9c0AZOy12bNucsrZK3LC6aHGghw=;
	b=K2jMZQuL4rIQ38GDJsjhdo3SVO1pHH0mI8+c1kQMaUQmkMYTzxM0o61vn+f0jz1JegUu3o
	h7FOpp+R/lFCro20/sf55dPQ5CA2gMJ5LkfMzZUXAdgSJlWEY4h32iYAEXm82EaCLpVJBr
	IlGHVwtL2tZ0dmvxgh+buW08saBSEOQ=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sean Christopherson <seanjc@google.com>,
	Salil Mehta <salil.mehta@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 06/13] KVM: arm64: Refactor hvc filtering to support different actions
Date: Thu, 30 Mar 2023 15:49:11 +0000
Message-Id: <20230330154918.4014761-7-oliver.upton@linux.dev>
In-Reply-To: <20230330154918.4014761-1-oliver.upton@linux.dev>
References: <20230330154918.4014761-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

KVM presently allows userspace to filter guest hypercalls with bitmaps
expressed via pseudo-firmware registers. These bitmaps have a narrow
scope and, of course, can only allow/deny a particular call. A
subsequent change to KVM will introduce a generalized UAPI for filtering
hypercalls, allowing functions to be forwarded to userspace.

Refactor the existing hypercall filtering logic to make room for more
than two actions. While at it, generalize the function names around
SMCCC as it is the basis for the upcoming UAPI.

No functional change intended.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/uapi/asm/kvm.h |  9 +++++++++
 arch/arm64/kvm/hypercalls.c       | 19 +++++++++++++++----
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index f8129c624b07..bbab92402510 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -469,6 +469,15 @@ enum {
 /* run->fail_entry.hardware_entry_failure_reason codes. */
 #define KVM_EXIT_FAIL_ENTRY_CPU_UNSUPPORTED	(1ULL << 0)
 
+enum kvm_smccc_filter_action {
+	KVM_SMCCC_FILTER_ALLOW = 0,
+	KVM_SMCCC_FILTER_DENY,
+
+#ifdef __KERNEL__
+	NR_SMCCC_FILTER_ACTIONS
+#endif
+};
+
 #endif
 
 #endif /* __ARM_KVM_H__ */
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 5ead6c6afff0..194c65d9ca05 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -65,7 +65,7 @@ static void kvm_ptp_get_time(struct kvm_vcpu *vcpu, u64 *val)
 	val[3] = lower_32_bits(cycles);
 }
 
-static bool kvm_hvc_call_default_allowed(u32 func_id)
+static bool kvm_smccc_default_allowed(u32 func_id)
 {
 	switch (func_id) {
 	/*
@@ -93,7 +93,7 @@ static bool kvm_hvc_call_default_allowed(u32 func_id)
 	}
 }
 
-static bool kvm_hvc_call_allowed(struct kvm_vcpu *vcpu, u32 func_id)
+static bool kvm_smccc_test_fw_bmap(struct kvm_vcpu *vcpu, u32 func_id)
 {
 	struct kvm_smccc_features *smccc_feat = &vcpu->kvm->arch.smccc_feat;
 
@@ -117,19 +117,30 @@ static bool kvm_hvc_call_allowed(struct kvm_vcpu *vcpu, u32 func_id)
 		return test_bit(KVM_REG_ARM_VENDOR_HYP_BIT_PTP,
 				&smccc_feat->vendor_hyp_bmap);
 	default:
-		return kvm_hvc_call_default_allowed(func_id);
+		return false;
 	}
 }
 
+static u8 kvm_smccc_get_action(struct kvm_vcpu *vcpu, u32 func_id)
+{
+	if (kvm_smccc_test_fw_bmap(vcpu, func_id) ||
+	    kvm_smccc_default_allowed(func_id))
+		return KVM_SMCCC_FILTER_ALLOW;
+
+	return KVM_SMCCC_FILTER_DENY;
+}
+
 int kvm_smccc_call_handler(struct kvm_vcpu *vcpu)
 {
 	struct kvm_smccc_features *smccc_feat = &vcpu->kvm->arch.smccc_feat;
 	u32 func_id = smccc_get_function(vcpu);
 	u64 val[4] = {SMCCC_RET_NOT_SUPPORTED};
 	u32 feature;
+	u8 action;
 	gpa_t gpa;
 
-	if (!kvm_hvc_call_allowed(vcpu, func_id))
+	action = kvm_smccc_get_action(vcpu, func_id);
+	if (action == KVM_SMCCC_FILTER_DENY)
 		goto out;
 
 	switch (func_id) {
-- 
2.40.0.348.gf938b09366-goog

