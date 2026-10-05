Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7B2042AFB7;
	Mon,  5 Oct 2026 09:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791191298; cv=none; b=vE0XWTQ50FmK+mrysL7yq7ojH7BP5yVDTcGFiy6CzHYc8j7hFkqRdN4ihxi+B57ERZj+h57iBhqeXss9o05tnP1HVp3MkWqH0z9YIwIIMJ06dL62aNOhgqkZK0qPvw8r5ZouqPNHRf4xMTOqLkci53vpp/jjleIwpV/TalHDRNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791191298; c=relaxed/simple;
	bh=tQPgXa0jI7YAYMnIJ4TZ6BAVtiDhJcnzdYxdyAnW4NQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GZdeCkVIEsOv4K9pkldo+NRmS/eSW5eBOEPj55vZc7m+iETO6oXALCOhS7/Ot0CV4CZwFx8lwL0qKoCc3LTDpaaC6ky1Yc+G9CauAdYNYWZnsPBHN8wkZEB1YK2/8x5tmtj1QkAm08c3Dqm7D5bOgnzILGxf8CVTfo1QHakeu7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hihwFwTX; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hihwFwTX"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C34861684;
	Mon,  5 Oct 2026 02:08:09 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 100443F66F;
	Mon,  5 Oct 2026 02:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791191293; bh=tQPgXa0jI7YAYMnIJ4TZ6BAVtiDhJcnzdYxdyAnW4NQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hihwFwTXrTV59Vkez3RHvIk46uXsPbnD7qLKfZhgJuD5n45XvAqIv96vpzVYEPrXm
	 SoR1yIaQ0vUAfrRX3qjCCWB1+UhgQP3w7xLcdlyAYcJvRkv5TQwZQ3O7dl9IUIc3vT
	 KN7j3eR4+H7Ku1Z3c3drd6plDdyukmmtOYOVfmAM=
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: maz@kernel.org,
	will@kernel.org,
	catalin.marinas@arm.com,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	steven.price@arm.com,
	aneesh.kumar@kernel.org,
	oupton@kernel.org,
	gshan@redhat.com,
	joey.gouly@arm.com,
	tabba@google.com,
	yuzenghui@huawei.com,
	linux-coco@lists.linux.dev,
	gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com,
	alpergun@google.com,
	fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com,
	lpieralisi@kernel.org,
	enju.kohei@fujitsu.com,
	sudeep.holla@arm.com,
	jonathan.cameron@oss.qualcomm.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: [PATCH v22 02/23] KVM: arm64: Disable Steal time accounting for protected guests
Date: Mon,  5 Oct 2026 10:07:33 +0100
Message-ID: <20261005090754.2140522-3-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261005090754.2140522-1-suzuki.poulose@arm.com>
References: <20261005090754.2140522-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

PVTIME support is advertised by KVM_CAP_STEAL_TIME, which doesn't take into
account the kvm instance. Even with that, a VMM could skip the CAP check
and proceed to configure the PVTIME as we don't do further check on the
DEVICE_CTRL. Tighten this up by passing the KVM instance around wherever
possible and catch things early.

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 +-
 arch/arm64/kvm/arm.c              |  2 +-
 arch/arm64/kvm/pvtime.c           | 14 +++++++-------
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 27fe0cd5b2d7a..286489a69dff5 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1346,7 +1346,7 @@ long kvm_hypercall_pv_features(struct kvm_vcpu *vcpu);
 gpa_t kvm_init_stolen_time(struct kvm_vcpu *vcpu);
 void kvm_update_stolen_time(struct kvm_vcpu *vcpu);
 
-bool kvm_arm_pvtime_supported(void);
+bool kvm_arm_pvtime_supported(struct kvm *kvm);
 int kvm_arm_pvtime_set_attr(struct kvm_vcpu *vcpu,
 			    struct kvm_device_attr *attr);
 int kvm_arm_pvtime_get_attr(struct kvm_vcpu *vcpu,
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 8b080804bc90b..db36815630790 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -447,7 +447,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = system_supports_mte();
 		break;
 	case KVM_CAP_STEAL_TIME:
-		r = kvm_arm_pvtime_supported();
+		r = kvm_arm_pvtime_supported(kvm);
 		break;
 	case KVM_CAP_ARM_EL1_32BIT:
 		r = cpus_have_final_cap(ARM64_HAS_32BIT_EL1);
diff --git a/arch/arm64/kvm/pvtime.c b/arch/arm64/kvm/pvtime.c
index 4ceabaa4c30bd..579e0a4720ad2 100644
--- a/arch/arm64/kvm/pvtime.c
+++ b/arch/arm64/kvm/pvtime.c
@@ -67,9 +67,9 @@ gpa_t kvm_init_stolen_time(struct kvm_vcpu *vcpu)
 	return base;
 }
 
-bool kvm_arm_pvtime_supported(void)
+bool kvm_arm_pvtime_supported(struct kvm *kvm)
 {
-	return !!sched_info_on();
+	return !!sched_info_on() && (!kvm || !kvm_vm_is_protected(kvm));
 }
 
 int kvm_arm_pvtime_set_attr(struct kvm_vcpu *vcpu,
@@ -81,8 +81,8 @@ int kvm_arm_pvtime_set_attr(struct kvm_vcpu *vcpu,
 	int ret = 0;
 	int idx;
 
-	if (!kvm_arm_pvtime_supported() ||
-	    attr->attr != KVM_ARM_VCPU_PVTIME_IPA)
+	if (!kvm_arm_pvtime_supported(kvm) ||
+	    (attr->attr != KVM_ARM_VCPU_PVTIME_IPA))
 		return -ENXIO;
 
 	if (get_user(ipa, user))
@@ -110,8 +110,8 @@ int kvm_arm_pvtime_get_attr(struct kvm_vcpu *vcpu,
 	u64 __user *user = (u64 __user *)attr->addr;
 	u64 ipa;
 
-	if (!kvm_arm_pvtime_supported() ||
-	    attr->attr != KVM_ARM_VCPU_PVTIME_IPA)
+	if (!kvm_arm_pvtime_supported(vcpu->kvm) ||
+	    (attr->attr != KVM_ARM_VCPU_PVTIME_IPA))
 		return -ENXIO;
 
 	ipa = vcpu->arch.steal.base;
@@ -126,7 +126,7 @@ int kvm_arm_pvtime_has_attr(struct kvm_vcpu *vcpu,
 {
 	switch (attr->attr) {
 	case KVM_ARM_VCPU_PVTIME_IPA:
-		if (kvm_arm_pvtime_supported())
+		if (kvm_arm_pvtime_supported(vcpu->kvm))
 			return 0;
 	}
 	return -ENXIO;
-- 
2.43.0

