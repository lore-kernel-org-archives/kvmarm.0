Received: from out-20.mta0.migadu.com (out-20.mta0.migadu.com [91.218.175.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B164ABA3E
	for <kvmarm@lists.linux.dev>; Tue,  4 Apr 2023 15:41:34 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1680622893;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NSIUR8mHHbifDtbyu16mqeRpfGM5O+UjJD7hC2Zaz1Y=;
	b=hcCMlS/Mkfi8b4XVvfKILbuWwvqIf9JM73EkYuzOYeVjHhJ4cdbvW1DD5s7KlTQrWW4lz+
	gfzoce5dOVzWEjPXsjyvBtnIZGQnWRCd8KUc4F6npzNXAcsGXp3nqgtiWawrWxpdOnkYrx
	GCG+sOpdgx/u7cTlmWlu3lt6/lvoc5I=
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
Subject: [PATCH v3 10/13] KVM: arm64: Return NOT_SUPPORTED to guest for unknown PSCI version
Date: Tue,  4 Apr 2023 15:40:47 +0000
Message-Id: <20230404154050.2270077-11-oliver.upton@linux.dev>
In-Reply-To: <20230404154050.2270077-1-oliver.upton@linux.dev>
References: <20230404154050.2270077-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

A subsequent change to KVM will allow negative returns from SMCCC
handlers to exit to userspace. Make way for this change by explicitly
returning SMCCC_RET_NOT_SUPPORTED to the guest if the VM is configured
to use an unknown PSCI version. Add a WARN since this is undoubtedly a
KVM bug.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/psci.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 7fbc4c1b9df0..aff54b106c30 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -435,6 +435,7 @@ static int kvm_psci_0_1_call(struct kvm_vcpu *vcpu)
 int kvm_psci_call(struct kvm_vcpu *vcpu)
 {
 	u32 psci_fn = smccc_get_function(vcpu);
+	int version = kvm_psci_version(vcpu);
 	unsigned long val;
 
 	val = kvm_psci_check_allowed_function(vcpu, psci_fn);
@@ -443,7 +444,7 @@ int kvm_psci_call(struct kvm_vcpu *vcpu)
 		return 1;
 	}
 
-	switch (kvm_psci_version(vcpu)) {
+	switch (version) {
 	case KVM_ARM_PSCI_1_1:
 		return kvm_psci_1_x_call(vcpu, 1);
 	case KVM_ARM_PSCI_1_0:
@@ -453,6 +454,8 @@ int kvm_psci_call(struct kvm_vcpu *vcpu)
 	case KVM_ARM_PSCI_0_1:
 		return kvm_psci_0_1_call(vcpu);
 	default:
-		return -EINVAL;
+		WARN_ONCE(1, "Unknown PSCI version %d", version);
+		smccc_set_retval(vcpu, SMCCC_RET_NOT_SUPPORTED, 0, 0, 0);
+		return 1;
 	}
 }
-- 
2.40.0.348.gf938b09366-goog

