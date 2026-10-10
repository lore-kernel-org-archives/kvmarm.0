Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F9617DFFA
	for <kvmarm@lists.linux.dev>; Sat, 10 Oct 2026 13:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791639579; cv=none; b=IurifATyfRs6okCsE98yp3qK6hLDxQEfNngiYwcoyqqbPtmXmRH2wg/BBNiznnOLq0K2+IRJlxrah6EoZtC2KkSyBALYrpL+Exxu6SNWKcXKQXatR5rMaHWDVcyN6+PBDSm6SGGWUSsiA9u4NxGHXijS24+CwGZf5G3ech3Rvt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791639579; c=relaxed/simple;
	bh=GHFAxlyXRmkWCZ7uxY+ubbDZoLNsj12XSAN0mhGVhOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=CkpKGdaDqOdaHO+1bJmVr/v7tCG5tr5y2LH012EwaLMcfT7sMgB7dIscQiLfGFYoBtM9GKkoXR1t4+ne42mlNxye56vX2v+f6jLBuTdNRrgSWFp83aL7LqLBfltejQDxfivgw3S1OZHLBNXDgnzQkHjkFoSOaR+r6wFXomAgGRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T0u7xdNJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T0u7xdNJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791639576;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dX+xl4MgWhLToR/5btAo7lKrv5fuNuvLk2lGV95KcY0=;
	b=T0u7xdNJWNsju1PmakHLfTvayTSBYHSddLSM2wOCALBgMnmy2uFTej1c6JLnuwbS5mXOu6
	k2FJgg2MEU5YsI6tFG1U+X4NfeGWcZ3NNQuhE4IFHDtnu7hk2SzAfkQZ0vryRO20tnvnbZ
	f7cyruCgjpjfSmzaYZlUxzHpYTvbUxU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-627-i6KLxWWUNOKz7jXeBMYRHg-1; Sat,
 10 Oct 2026 13:39:32 +0000
X-MC-Unique: i6KLxWWUNOKz7jXeBMYRHg-1
X-Mimecast-MFC-AGG-ID: i6KLxWWUNOKz7jXeBMYRHg_1791639570
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 235BC1802146;
	Sat, 10 Oct 2026 13:39:30 +0000 (UTC)
Received: from laptop.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B3AA330000E5;
	Sat, 10 Oct 2026 13:39:25 +0000 (UTC)
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
Subject: [PATCH v10 23/26] target/arm/kvm: Introduce kvm_arm_vcpu_prepare_init_features helper
Date: Sat, 10 Oct 2026 15:36:27 +0200
Message-ID: <20261010133725.642498-24-eric.auger@redhat.com>
In-Reply-To: <20261010133725.642498-1-eric.auger@redhat.com>
References: <20261010133725.642498-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: k_e8rKYcRnH7qMlp40Js6wI2DR-Nfy5dhwtkS6xvdq8_1791639570
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
index 1f6f9ba586..840501f9bf 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -2191,27 +2191,18 @@ int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
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
@@ -2235,6 +2226,23 @@ int kvm_arch_init_vcpu(CPUState *cs, Error **errp)
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

