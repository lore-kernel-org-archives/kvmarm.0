Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CD4D580387;
	Tue,  8 Sep 2026 16:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788884607; cv=none; b=H5jvBs0QYnP8KGU218lhdHbaIeuwgvVCBC97ew2dvis9unsWBlUH1Bfd85mExZ/83othyYjjgMc73XknnVBuXhwwH0WkGkzxtzKt76etUqKL896CVCkyKgBR093cFJBnCLt0F5wKqv4yitQIas4cAc6ZfOQ6/ovKB+MxdEW1d4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788884607; c=relaxed/simple;
	bh=X91qpxlmCb+RcASVwWsSL4AP+f2WCekRe8JKe4PKM9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cbOIP2K82Dv0+VFUTSB/shKMIHILlqZB+14jbdrWnk9JWMpjKYCo0qKvVWcoAJ0HNH1V8pOFj7REXSnYfit3EKnShPD+4DnL+e4f4r8IvvL7Qbd5GzwSsuIca8HXNnZrqbcM2TaBScxhdLonPhLKhwaoLroZeQdsjCeZqznXnH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OH674DE6; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OH674DE6"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 32B571476;
	Tue,  8 Sep 2026 09:23:21 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 9009E3F7B4;
	Tue,  8 Sep 2026 09:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788884604; bh=X91qpxlmCb+RcASVwWsSL4AP+f2WCekRe8JKe4PKM9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OH674DE6RzZ1E5TLddbpKAdwRgPW35U59OH0+ZgFxiyjHnqexeWj+Ks77CBOV+pin
	 cydpWohwNRxiQunWmrmtkKMCFzbW9949shwjmdj4SlY4utGeaBpEgF1ZLB4lag4Esc
	 gzStEowg3HcQ76Uk2j8IHe3RHWEOJZzf4yS8VTRU=
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
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v17 10/20] KVM: arm64: coco: Disable Steal time accounting for coco guests
Date: Tue,  8 Sep 2026 17:22:13 +0100
Message-ID: <20260908162223.1683432-11-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260908162223.1683432-1-suzuki.poulose@arm.com>
References: <20260908162223.1683432-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

PVTIME support is advertised by KVM_CAP_STEAL_TIME, which doesn't take into
account the kvm instance. Even with that, a VMM could skip the CAP check and
proceed to configure the PVTIME as we don't do further check on the DEVICE_CTRL.
Tighten this up by passing the KVM instance around wherever possible and
catch things early

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 +-
 arch/arm64/kvm/arm.c              |  2 +-
 arch/arm64/kvm/pvtime.c           | 10 +++++-----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 020aef5a1b698..0f258f16fdf81 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1367,7 +1367,7 @@ long kvm_hypercall_pv_features(struct kvm_vcpu *vcpu);
 gpa_t kvm_init_stolen_time(struct kvm_vcpu *vcpu);
 void kvm_update_stolen_time(struct kvm_vcpu *vcpu);
 
-bool kvm_arm_pvtime_supported(void);
+bool kvm_arm_pvtime_supported(struct kvm *kvm);
 int kvm_arm_pvtime_set_attr(struct kvm_vcpu *vcpu,
 			    struct kvm_device_attr *attr);
 int kvm_arm_pvtime_get_attr(struct kvm_vcpu *vcpu,
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 2ecd92156f7cc..b5e0893ea16f1 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -473,7 +473,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = system_supports_mte();
 		break;
 	case KVM_CAP_STEAL_TIME:
-		r = kvm_arm_pvtime_supported();
+		r = kvm_arm_pvtime_supported(kvm);
 		break;
 	case KVM_CAP_ARM_EL1_32BIT:
 		r = cpus_have_final_cap(ARM64_HAS_32BIT_EL1);
diff --git a/arch/arm64/kvm/pvtime.c b/arch/arm64/kvm/pvtime.c
index 4ceabaa4c30bd..41fbfd92cd292 100644
--- a/arch/arm64/kvm/pvtime.c
+++ b/arch/arm64/kvm/pvtime.c
@@ -67,9 +67,9 @@ gpa_t kvm_init_stolen_time(struct kvm_vcpu *vcpu)
 	return base;
 }
 
-bool kvm_arm_pvtime_supported(void)
+bool kvm_arm_pvtime_supported(struct kvm *kvm)
 {
-	return !!sched_info_on();
+	return !!sched_info_on() && (!kvm || !kvm_vm_is_confidential(kvm));
 }
 
 int kvm_arm_pvtime_set_attr(struct kvm_vcpu *vcpu,
@@ -81,7 +81,7 @@ int kvm_arm_pvtime_set_attr(struct kvm_vcpu *vcpu,
 	int ret = 0;
 	int idx;
 
-	if (!kvm_arm_pvtime_supported() ||
+	if (!kvm_arm_pvtime_supported(kvm) ||
 	    attr->attr != KVM_ARM_VCPU_PVTIME_IPA)
 		return -ENXIO;
 
@@ -110,7 +110,7 @@ int kvm_arm_pvtime_get_attr(struct kvm_vcpu *vcpu,
 	u64 __user *user = (u64 __user *)attr->addr;
 	u64 ipa;
 
-	if (!kvm_arm_pvtime_supported() ||
+	if (!kvm_arm_pvtime_supported(vcpu->kvm) ||
 	    attr->attr != KVM_ARM_VCPU_PVTIME_IPA)
 		return -ENXIO;
 
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

