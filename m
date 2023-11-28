Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CCD5199B2
	for <kvmarm@lists.linux.dev>; Tue, 28 Nov 2023 13:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from kwepemd500005.china.huawei.com (unknown [172.30.72.57])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4SfkNz5c5Vz1P8ql;
	Tue, 28 Nov 2023 21:50:27 +0800 (CST)
Received: from huawei.com (10.174.186.3) by kwepemd500005.china.huawei.com
 (7.221.188.140) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1258.28; Tue, 28 Nov
 2023 21:54:03 +0800
From: l00313349 <liting8@huawei.com>
To: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>
CC: <maz@kernel.org>, <oliver.upton@linux.dev>, <james.morse@arm.com>,
	<suzuki.poulose@arm.com>, <yuzenghui@huawei.com>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <zhengchuan@huawei.com>, <xiexiangyou@huawei.com>
Subject: [PATCH] KVM: arm64: fix MPIDR to vcpu index cache to support vcpu change at runtime
Date: Tue, 28 Nov 2023 21:54:02 +0800
Message-ID: <20231128135402.1943-1-liting8@huawei.com>
X-Mailer: git-send-email 2.24.1.windows.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemd500005.china.huawei.com (7.221.188.140)
X-CFilter-Loop: Reflected

From: Ting Li <liting8@huawei.com>

Consider vcpu change at runtime, for example online_vcpus is 8,
but only start 2 vcpu threads, MPIDR to vcpu index 0 may be overwrited
and vm hangs. When start other vcpu threads, cache will be outdated
and always get mismatch.
To solve this problem, codes update as followed:
1.First time only vcpu 0 can init MPIDR data, and use flags to avoid
index overwrite.
2.When MPIDR cache mismatch, fallback to old iterative method, and reinit
MPIDR to vcpu index cache data.

Signed-off-by: Ting Li <liting8@huawei.com>
---
 arch/arm64/kvm/arm.c | 49 ++++++++++++++++++++++++++++++++++++--------
 1 file changed, 41 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e5f75f1f1085..a3c038ad2f41 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -584,14 +584,16 @@ static int kvm_vcpu_initialized(struct kvm_vcpu *vcpu)
 static void kvm_init_mpidr_data(struct kvm *kvm)
 {
 	struct kvm_mpidr_data *data = NULL;
+	bool *index_inited_flags = NULL;
+	struct kvm_mpidr_data *data_to_del = NULL;
 	unsigned long c, mask, nr_entries;
 	u64 aff_set = 0, aff_clr = ~0UL;
 	struct kvm_vcpu *vcpu;

-	mutex_lock(&kvm->arch.config_lock);
+	if (atomic_read(&kvm->online_vcpus) == 1)
+		return;

-	if (kvm->arch.mpidr_data || atomic_read(&kvm->online_vcpus) == 1)
-		goto out;
+	mutex_lock(&kvm->arch.config_lock);

 	kvm_for_each_vcpu(c, vcpu, kvm) {
 		u64 aff = kvm_vcpu_get_mpidr_aff(vcpu);
@@ -618,16 +620,37 @@ static void kvm_init_mpidr_data(struct kvm *kvm)
 	if (!data)
 		goto out;

+	/*
+	 * Use index inited flags to avoid index overwrite.
+	 */
+	index_inited_flags = kcalloc(nr_entries, sizeof(bool), GFP_KERNEL);
+	if (!index_inited_flags) {
+		kfree(data);
+		goto out;
+	}
+
 	data->mpidr_mask = mask;

 	kvm_for_each_vcpu(c, vcpu, kvm) {
 		u64 aff = kvm_vcpu_get_mpidr_aff(vcpu);
 		u16 index = kvm_mpidr_index(data, aff);

+		/*
+		 * When index has inited, ignore set conflict index.
+		 */
+		if (index_inited_flags[index])
+			continue;
 		data->cmpidr_to_idx[index] = c;
+		index_inited_flags[index] = true;
 	}
-
+	/*
+	 * When mpidr_data exist, change to new data then free old data.
+	 */
+	if (kvm->arch.mpidr_data)
+		data_to_del = kvm->arch.mpidr_data;
 	kvm->arch.mpidr_data = data;
+	kfree(data_to_del);
+	kfree(index_inited_flags);
 out:
 	mutex_unlock(&kvm->arch.config_lock);
 }
@@ -655,7 +678,8 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 	if (likely(vcpu_has_run_once(vcpu)))
 		return 0;

-	kvm_init_mpidr_data(kvm);
+	if (vcpu->vcpu_id == 0)
+		kvm_init_mpidr_data(kvm);

 	kvm_arm_vcpu_init_debug(vcpu);

@@ -2459,15 +2483,24 @@ struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr)

 		vcpu = kvm_get_vcpu(kvm,
 				    kvm->arch.mpidr_data->cmpidr_to_idx[idx]);
+		/*
+		 * When mpidr mismatch, fallback to old iterative method.
+		 */
 		if (mpidr != kvm_vcpu_get_mpidr_aff(vcpu))
 			vcpu = NULL;
-
-		return vcpu;
+		else
+			return vcpu;
 	}

 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		if (mpidr == kvm_vcpu_get_mpidr_aff(vcpu))
+		if (mpidr == kvm_vcpu_get_mpidr_aff(vcpu)) {
+			/*
+			 * Reinit MPIDR to vcpu index cache.
+			 */
+			if (kvm->arch.mpidr_data)
+				kvm_init_mpidr_data(kvm);
 			return vcpu;
+		}
 	}
 	return NULL;
 }
--
2.33.0

