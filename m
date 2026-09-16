Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2919C30216D
	for <kvmarm@lists.linux.dev>; Wed, 16 Sep 2026 14:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789570175; cv=none; b=b+QEKTW3dGmbmQocY5M4KNA6dqS75klCOk30yOPhpBnWBOW7yNAguInVwV+PoGASzrCDbxovkS6DWxuU+HYLmJ1alYRvMnTpRJZ9yjsbRB6LV6g0qiTicH+vOxMc17k2r5FEgMTvYbhXr/zB9vQmJ3yi3Evh/tV30Jfs4syjfYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789570175; c=relaxed/simple;
	bh=PH7782k5m4Mk3/ObYi6UCpeIhkGicvcpIB8drAp/EKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=i8L2P3/NuQlSdV5ABpZLMaRPdHkToPmNMjvTgPhzA7QOxDYfd/RuyOyPDmtKpYhndirjR+qZGZj/Hlb+aSMy6FbERpQGc4A3PUCTMY1Tcx/MtyHYof57MA4FhNwUWlzTlfNlLWJ71xKF7prSoGr7EcC0hx+PON4IkRPKplZiZFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ImKAsdpr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ImKAsdpr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789570173;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e02JHTK5vtyACAt9OjPCN3RGbXnELCnkz1SQgi2oqUc=;
	b=ImKAsdprh6YE8zLwoerS5/xy1yzX4W7HWI5sJAVbPA7wORI4v0nrMW+fw5TPzP1oMVUmsA
	xVceayI8KeyymtZ8pM/QxOP8D0IJ8C1MZ4BxGaBG9S8rwyenaMM1tYoB/JxdK1gyy80GgQ
	AN3WWAG8fEQQuNqttvAxWoiO5M31fLc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-355-pDKpRdLvO4mUUX9UnosilA-1; Wed,
 16 Sep 2026 10:49:29 -0400
X-MC-Unique: pDKpRdLvO4mUUX9UnosilA-1
X-Mimecast-MFC-AGG-ID: pDKpRdLvO4mUUX9UnosilA_1789570167
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 99FF2183019A;
	Wed, 16 Sep 2026 14:49:27 +0000 (UTC)
Received: from laptop.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EA73919560AB;
	Wed, 16 Sep 2026 14:49:22 +0000 (UTC)
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
Subject: [PATCH v9 22/26] target/arm/kvm: Add an error handle to kvm_arm_create_scratch_host_vcpu
Date: Wed, 16 Sep 2026 16:45:45 +0200
Message-ID: <20260916144721.751810-23-eric.auger@redhat.com>
In-Reply-To: <20260916144721.751810-1-eric.auger@redhat.com>
References: <20260916144721.751810-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: rv6H_3gtG83vO5WzkdhYe1q-vEJuxV0NtmCYzo5Kn9c_1789570167
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

This allows to report a precise error message if any error occurs.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 target/arm/kvm_arm.h |  3 ++-
 target/arm/kvm.c     | 15 ++++++++++++---
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index bace69efed..185018e00c 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -106,6 +106,7 @@ struct kvm_vcpu_init;
  * @init: filled in with the necessary values for creating a host
  * vcpu. If NULL is provided, will not init the vCPU (though the cpufd
  * will still be set up).
+ * @errp: Error handle
  *
  * Create a scratch vcpu in its own VM of the type preferred by the host
  * kernel (as would be used for '-cpu host'), for purposes of probing it
@@ -115,7 +116,7 @@ struct kvm_vcpu_init;
  * false on failure (and fdarray and init are not valid).
  */
 bool kvm_arm_create_scratch_host_vcpu(int *fdarray,
-                                      struct kvm_vcpu_init *init);
+                                      struct kvm_vcpu_init *init, Error **errp);
 
 /**
  * kvm_arm_destroy_scratch_host_vcpu:
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index f7ca0e0250..43fb61bef4 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -107,13 +107,14 @@ static int kvm_arm_vcpu_finalize(ARMCPU *cpu, int feature)
 }
 
 bool kvm_arm_create_scratch_host_vcpu(int *fdarray,
-                                      struct kvm_vcpu_init *init)
+                                      struct kvm_vcpu_init *init, Error **errp)
 {
     int ret = 0, kvmfd = -1, vmfd = -1, cpufd = -1;
     int max_vm_pa_size;
 
     kvmfd = qemu_open_old("/dev/kvm", O_RDWR);
     if (kvmfd < 0) {
+        error_setg(errp, "Failed opening /dev/kvm");
         goto err;
     }
     max_vm_pa_size = ioctl(kvmfd, KVM_CHECK_EXTENSION, KVM_CAP_ARM_VM_IPA_SIZE);
@@ -124,6 +125,7 @@ bool kvm_arm_create_scratch_host_vcpu(int *fdarray,
         vmfd = ioctl(kvmfd, KVM_CREATE_VM, max_vm_pa_size);
     } while (vmfd == -1 && errno == EINTR);
     if (vmfd < 0) {
+        error_setg(errp, "Failed creating the scratch VM");
         goto err;
     }
 
@@ -143,6 +145,7 @@ bool kvm_arm_create_scratch_host_vcpu(int *fdarray,
 
     cpufd = ioctl(vmfd, KVM_CREATE_VCPU, 0);
     if (cpufd < 0) {
+        error_setg(errp, "Failed creating the scratch VCPU");
         goto err;
     }
 
@@ -156,12 +159,14 @@ bool kvm_arm_create_scratch_host_vcpu(int *fdarray,
 
         ret = ioctl(vmfd, KVM_ARM_PREFERRED_TARGET, &preferred);
         if (ret < 0) {
+            error_setg(errp, "Failed getting the preferred target");
             goto err;
         }
         init->target = preferred.target;
     }
     ret = ioctl(cpufd, KVM_ARM_VCPU_INIT, init);
     if (ret < 0) {
+        error_setg(errp, "Failed the init of the scratch vcpu");
         goto err;
     }
 
@@ -659,6 +664,7 @@ kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
     bool el2_supported;
     bool pmu_supported = false;
     uint64_t features = 0;
+    Error *local_err = NULL;
     int err;
 
     ahcf->target = QEMU_KVM_ARM_TARGET_NONE;
@@ -706,7 +712,8 @@ kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
         features |= 1ULL << ARM_FEATURE_PMU;
     }
 
-    if (!kvm_arm_create_scratch_host_vcpu(fdarray, &init)) {
+    if (!kvm_arm_create_scratch_host_vcpu(fdarray, &init, &local_err)) {
+        error_report_err(local_err);
         return;
     }
 
@@ -3093,8 +3100,10 @@ void arm_cpu_kvm_set_irq(void *arm_cpu, int irq, int level)
 void arm_gic_cap_kvm_probe(GICCapability *v2, GICCapability *v3)
 {
     int fdarray[3];
+    Error *err = NULL;
 
-    if (!kvm_arm_create_scratch_host_vcpu(fdarray, NULL)) {
+    if (!kvm_arm_create_scratch_host_vcpu(fdarray, NULL, &err)) {
+        error_report_err(err);
         return;
     }
 
-- 
2.53.0

