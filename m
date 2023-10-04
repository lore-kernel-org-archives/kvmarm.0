Received: from out-202.mta0.migadu.com (out-202.mta0.migadu.com [91.218.175.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA8B37CBC
	for <kvmarm@lists.linux.dev>; Wed,  4 Oct 2023 23:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iEB4lm3J"
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1696463410;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fl86I5gPbdkyQPqJ+kvtLKD9yW4tKYQD63RMxf1odH8=;
	b=iEB4lm3JD0Rr+VngWeFL4XPKUNkBRNtWciw/ijB3miM5nDeBWTWIqyOQ8yeVB9pwjS4wTC
	TH/kp5fmo+/+o88jCqrYC97j5q+robY4i868718oaJYrkzcnfngUd5cTRAYmVq+vXNoxaj
	gEmI3pMevEm7NqxA5TbuECUwFJhlJRY=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 3/3] KVM: arm64: Use mtree_empty() to determine if SMCCC filter configured
Date: Wed,  4 Oct 2023 23:49:47 +0000
Message-ID: <20231004234947.207507-4-oliver.upton@linux.dev>
In-Reply-To: <20231004234947.207507-1-oliver.upton@linux.dev>
References: <20231004234947.207507-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The smccc_filter maple tree is only populated if userspace attempted to
configure it. Use the state of the maple tree to determine if the filter
has been configured, eliminating the VM flag.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h | 4 +---
 arch/arm64/kvm/hypercalls.c       | 7 +------
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index af06ccb7ee34..feb63db7a5cf 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -239,10 +239,8 @@ struct kvm_arch {
 #define KVM_ARCH_FLAG_VM_COUNTER_OFFSET			5
 	/* Timer PPIs made immutable */
 #define KVM_ARCH_FLAG_TIMER_PPIS_IMMUTABLE		6
-	/* SMCCC filter initialized for the VM */
-#define KVM_ARCH_FLAG_SMCCC_FILTER_CONFIGURED		7
 	/* Initial ID reg values loaded */
-#define KVM_ARCH_FLAG_ID_REGS_INITIALIZED		8
+#define KVM_ARCH_FLAG_ID_REGS_INITIALIZED		7
 	unsigned long flags;
 
 	/* VM-wide vCPU feature set */
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 20a878c64ba7..a61213786e5f 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -164,7 +164,7 @@ static int kvm_smccc_filter_insert_reserved(struct kvm *kvm)
 
 static bool kvm_smccc_filter_configured(struct kvm *kvm)
 {
-	return test_bit(KVM_ARCH_FLAT_SMCCC_FILTER_CONFIGURED, &kvm->arch.flags);
+	return !mtree_empty(&kvm->arch.smccc_filter);
 }
 
 static int kvm_smccc_set_filter(struct kvm *kvm, struct kvm_smccc_filter __user *uaddr)
@@ -201,11 +201,6 @@ static int kvm_smccc_set_filter(struct kvm *kvm, struct kvm_smccc_filter __user
 
 	r = mtree_insert_range(&kvm->arch.smccc_filter, start, end,
 			       xa_mk_value(filter.action), GFP_KERNEL_ACCOUNT);
-	if (r)
-		goto out_unlock;
-
-	set_bit(KVM_ARCH_FLAG_SMCCC_FILTER_CONFIGURED, &kvm->arch.flags);
-
 out_unlock:
 	mutex_unlock(&kvm->arch.config_lock);
 	return r;
-- 
2.42.0.609.gbb76f46606-goog

