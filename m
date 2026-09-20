Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93BDC472558;
	Sun, 20 Sep 2026 21:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789939752; cv=none; b=ZmoL0dAQe9otWQ4LYcY7FOXTFOawZqyEIPzanDqQws/4QRqRtfsZIHSV3qIWN/XEQYR4tB2i3NyCiCXifBMAguvQ/r+x1yb5Q7MKuwcSbnAscoHHwA2q6n2WZUPtX6JheKb0NAwSOxXFUJJUNCa3PMtTO0tZbP48t5cy8R/LBRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789939752; c=relaxed/simple;
	bh=w7FAk0eZ93K6FDhEb3vwlKZnmt572gLFjnJCTSvurl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g823BAotWUq0Wd/3MnYO/qS5jd3whmQZ62JXMVd5hW4/BppBXDDrVQxG2fyp8HpLSjJa2CAw9p4H5B4gjFujP0t74vicsgUbf7ajwDM8K3EVF75Wd6QClDmYLC4endwm6yfpL0e34rDbQFFe1ZSpjfMIb5/pLenBbekAs6lFBr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=sw0hcnDH; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="sw0hcnDH"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E29711650;
	Sun, 20 Sep 2026 14:29:04 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 915933F632;
	Sun, 20 Sep 2026 14:29:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789939748; bh=w7FAk0eZ93K6FDhEb3vwlKZnmt572gLFjnJCTSvurl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sw0hcnDHFQ4inpjQpFvrzR9D1uWcBSU6Ws5PC8xDapOd+fvooZPCuqFViNIfRak8h
	 m3YqLpbQEyFOwfS6OA9XSfVM2MyZjpZ6XnBco13T/RMS1St84oziJ3bHvkMGn4uy5J
	 p350hSiIjE09FYHS36YbzJ9Ilhc/NlxcD0TYWHfU=
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
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: [PATCH v19 02/20] KVM: arm64: Disable Steal time accounting for protected guests
Date: Sun, 20 Sep 2026 22:28:27 +0100
Message-ID: <20260920212845.707-3-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260920212845.707-1-suzuki.poulose@arm.com>
References: <20260920212845.707-1-suzuki.poulose@arm.com>
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

