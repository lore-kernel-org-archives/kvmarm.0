Received: from mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513A5518124
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 13:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790863062; cv=none; b=WVhmb6K0H7xnEYIrPVTPt9e9STpdarNjQbIVWXG2CHajna3wNuOjwQt4RYlvXn3/LXaV4ydUEe7HQvpY/BU1hH66fIlAmoz65WVgNZf4qNpyNOPTBc4f0f5FlUFc5EoTabau7/XyGMkIo5FYlig//KZYf1v/dbiK5y0Dy4Rt05E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790863062; c=relaxed/simple;
	bh=1Ws9n6iE1+OrWs/XcdHuXlvIueQS+tIjV4+vXzqVwmw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Mhs+Ws5Y3xZNM8FEF/6Ng6VWtWSb8od3I/+I1tvfwGh4QjgV0twVBawDjjMtDNsGP7UhBVr6Hz2HVvcuJqz5wLGtiATJqOV0dL6W7zaaVlJn2+X1O17Pc0KXLQf7rwfDOSQzzbrYla7dHfWBi6l6Q4mwpziDxDcutA9YbDnp12s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vXZh9OT2; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vXZh9OT2"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=1Ws9n6iE1+OrWs/XcdHuXlvIueQS+tIjV4+vXzqVwmw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790863055; v=1; x=1791467855;
 b=vXZh9OT2GH+8/cDS93zQVOupF1QRfQWYYgYhatoqfaOJ7tb9uzEPJqYf0u4YZCBQKl95axC+
 x6GhSDoYIFVyicuwED89RnB1HqeIpSuVDD1bt0/j6SYBtUJ9s6d/XUqFv8j59bH9TxYi0LHag+o
 Y5ti5vlC1UxoW0JjZnRsnIzI=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id e098126e4f2d483f;
	Thu, 01 Oct 2026 13:57:35 +0000
X-Mizu-Trace-ID: e098126e4f2d483f
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: maz@kernel.org,
	oupton@kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	mark.rutland@arm.com,
	steven.price@arm.com,
	vdonnefort@google.com,
	qperret@google.com,
	tabba@google.com
Subject: [PATCH v4 04/18] KVM: arm64: Disable steal time for protected VMs
Date: Thu,  1 Oct 2026 14:56:57 +0100
Message-Id: <20261001135711.1640520-5-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261001135711.1640520-1-fuad.tabba@linux.dev>
References: <20261001135711.1640520-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pKVM doesn't support steal time for protected guests, and
KVM_CAP_STEAL_TIME already reads 0 for them on the VM file descriptor,
but kvm_arm_pvtime_supported() takes no VM, so the host still
accepts the KVM_ARM_VCPU_PVTIME_CTRL attribute, whose IPA would point
kvm_update_stolen_time() at the guest's private memory on every vCPU
load. Pass the VM in and return false for a protected one, so the
attribute returns -ENXIO as it does where steal time isn't implemented.

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h |  2 +-
 arch/arm64/kvm/arm.c              |  2 +-
 arch/arm64/kvm/pvtime.c           | 10 +++++-----
 3 files changed, 7 insertions(+), 7 deletions(-)

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
index 4ceabaa4c30bd..053fe831fa541 100644
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
2.39.5

