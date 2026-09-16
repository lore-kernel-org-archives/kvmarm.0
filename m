Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6650D3546D6
	for <kvmarm@lists.linux.dev>; Wed, 16 Sep 2026 14:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789570180; cv=none; b=gsBSXB//uTHbFeD186E9M1Ia0SQmwaLS3HZ2fa2mXzy4xbnfO1Kp7RL1XtwZ6x7Pzxmje4P+8Zj5v7jW1f4GTL/lDr73ldBkqnkW2N2wh2mgb1LesUUBd//aaFuFRtmPNt5o79p5A1qefGvga07m2oLb/vvNY0hR/Ftdgo+mBRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789570180; c=relaxed/simple;
	bh=w9UsymA8IlDgZOuoAw/B4AucbECOyPgPKsrX6YxICV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=mzRE+bt7sjIQzdlFArpNwHkI5c7lro3ZNY06tY05V9zVzRIfXP3Tulj9Ft6DP4jXk0mUPYF9Ouk3DzsxcqhIRL2P3DWr5xaXtPL/T8U+f4tPxV4wsQ19r7N6+g6ylOtj33BpgUtfUYHeWmFzDlH005JC+0LGoDxFPJ2pa0470LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LiwcmajB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LiwcmajB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789570178;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nHTQyV3fsb5dGPVizKLS+8CWG7EJNOQy7+/Wy/+0kNs=;
	b=LiwcmajBZsL/g0ca/+FZq9++QhpopzeCzQXptrUfGp1bZTnmu8kuIL1X7nv0L8fRaBlcZX
	4Uc1EY0YF4RSX8QvfjjIT0Ab9OiUVrLWtT9hcAOPF2PVel4U/DbUZCkqFvELQgJFW0HWIR
	eihcBBGDvJt62jFLsQOLsdoFBAgSIzI=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-648-yGtr9CB3M_GUjxiL2SnAzQ-1; Wed,
 16 Sep 2026 10:49:34 -0400
X-MC-Unique: yGtr9CB3M_GUjxiL2SnAzQ-1
X-Mimecast-MFC-AGG-ID: yGtr9CB3M_GUjxiL2SnAzQ_1789570172
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D0F9E1829E28;
	Wed, 16 Sep 2026 14:49:32 +0000 (UTC)
Received: from laptop.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F35C219560AB;
	Wed, 16 Sep 2026 14:49:27 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
	qemu-devel@nongnu.org,
	qemu-arm@nongnu.org,
	kvmarm@lists.linux.dev,
	peter.maydell@linaro.org,
	shaju.abraham@nutanix.com,
	khushit.shah@nutanix.com,
	yangjinqian1@huawei.com,
	cohuck@redhat.com,
	richard.henderson@linaro.org,
	sebott@redhat.com,
	skolothumtho@nvidia.com,
	philmd@oss.qualcomm.com
Cc: maz@kernel.org,
	oliver.upton@linux.dev,
	pbonzini@redhat.com,
	armbru@redhat.com,
	berrange@redhat.com,
	abologna@redhat.com,
	jdenemar@redhat.com
Subject: [PATCH v9 23/26] target/arm/kvm: Introduce kvm_arm_vcpu_prepare_init_features helper
Date: Wed, 16 Sep 2026 16:45:46 +0200
Message-ID: <20260916144721.751810-24-eric.auger@redhat.com>
In-Reply-To: <20260916144721.751810-1-eric.auger@redhat.com>
References: <20260916144721.751810-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: BUFn3ncH87dVTM7q_F6j-HFKFjT41C5H29yUrsKIjVY_1789570172
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Factorize the code that initializes the kvm init features from the
cpu settings in a helper. Use it kvm_arch_init_vcpu(). Soon it will
be used by another function.

The only change in the code relates to the check of kvm_state. The
future caller won't have the VM created when calling the helper and
for this caller it is OK ignoring PSCI version setting.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 target/arm/kvm.c | 36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 43fb61bef4..a459942a73 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -2448,27 +2448,18 @@ static int kvm_arm_apply_sysreg_props(ARMCPU *cpu, Error **errp)
     return 0;
 }
 
-int kvm_arch_init_vcpu(CPUState *cs, Error **errp)
+/* Determine init features for this CPU */
+static void kvm_arm_vcpu_prepare_init_features(ARMCPU *cpu)
 {
-    int ret;
-    uint64_t mpidr;
-    ARMCPU *cpu = ARM_CPU(cs);
+    CPUState *cs = CPU(cpu);
     CPUARMState *env = &cpu->env;
-    uint64_t psciver;
 
-    if (cpu->kvm_target == QEMU_KVM_ARM_TARGET_NONE) {
-        error_setg(errp, "KVM is not supported for this guest CPU type");
-        return -EINVAL;
-    }
-
-    qemu_add_vm_change_state_handler(kvm_arm_vm_state_change, cpu);
-
-    /* Determine init features for this CPU */
     memset(cpu->kvm_init_features, 0, sizeof(cpu->kvm_init_features));
+
     if (cs->start_powered_off) {
         cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_POWER_OFF;
     }
-    if (cpu->psci_version != QEMU_PSCI_VERSION_0_1 &&
+    if (cpu->psci_version != QEMU_PSCI_VERSION_0_1 && cs->kvm_state &&
         kvm_check_extension(cs->kvm_state, KVM_CAP_ARM_PSCI_0_2)) {
         /*
          * Versions >= v0.2 are backward compatible with v0.2
@@ -2492,6 +2483,23 @@ int kvm_arch_init_vcpu(CPUState *cs, Error **errp)
     if (cpu->has_el2 && kvm_arm_el2_supported()) {
         cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_HAS_EL2;
     }
+}
+
+int kvm_arch_init_vcpu(CPUState *cs, Error **errp)
+{
+    int ret;
+    uint64_t mpidr;
+    ARMCPU *cpu = ARM_CPU(cs);
+    uint64_t psciver;
+
+    if (cpu->kvm_target == QEMU_KVM_ARM_TARGET_NONE) {
+        error_setg(errp, "KVM is not supported for this guest CPU type");
+        return -EINVAL;
+    }
+
+    qemu_add_vm_change_state_handler(kvm_arm_vm_state_change, cpu);
+
+    kvm_arm_vcpu_prepare_init_features(cpu);
 
     /* Do KVM_ARM_VCPU_INIT ioctl */
     ret = kvm_arm_vcpu_init(cpu);
-- 
2.53.0

