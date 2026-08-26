Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6C73546D6
	for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 09:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787737203; cv=none; b=JvDq5gs4S+GpWT9Y5w1f2QZTkntgnUh8p1a+wkRyVd8K9emtsM4laGcgao+MUF9buJyAFpATpVyKXH1oZzz2TImQeXqy13S+/z+ulgS0F4aXb99w7WijtXTlE0xuYAWQHSmRCCedlYLCKqogcEEVy43I4Sef/eQwQ6BEpgox10k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787737203; c=relaxed/simple;
	bh=E5c6vs61PXyNT65o6b6cd4Zm5eSVp0a8eXmGUkrLAy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=EruV01DajL1LoLulsYbHWDn0UsXudAGWGdO+RlB102/fqZbSgGfQt50KBB9kk1H1hUwsIcEFmaZsSRcG8afzZ9ZxEd0N6bqvOiFYG4AFglWoG/Y1sM3YhJoe+DBuVNCk8uh3nz2wLhTkDUqdgD5IEB/MmNeehDY0lanSrep5h2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CwTBttDQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CwTBttDQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787737201;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zFQHAYBHdMrAddfCZsE2VY/tTxCJjg9UL5w6n7EyOeI=;
	b=CwTBttDQlidQAFbvmbJXQyJPF6rqDWTI4xOxo3Gr7iI7SY8yesgR6Jx/nmTPmNLRuUMkT4
	OWPA1ADIBdjst6toBFGBDlymFivyOdoxO3gufqXqfvw2zEp58zJ3NdcI9vF9yUXQ1U21VH
	70lLk5UzY8WbkQ8iYuCrr/56MZqV0eo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-607-X06uXtpaP-W0K_KVH06BYQ-1; Wed,
 26 Aug 2026 05:39:57 -0400
X-MC-Unique: X06uXtpaP-W0K_KVH06BYQ-1
X-Mimecast-MFC-AGG-ID: X06uXtpaP-W0K_KVH06BYQ_1787737195
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D16B31870785;
	Wed, 26 Aug 2026 09:39:55 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.44.48.93])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D69BF1955F05;
	Wed, 26 Aug 2026 09:39:49 +0000 (UTC)
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
Subject: [RFC PATCH v8 18/20] target/arm/kvm: Add an error handle to kvm_arm_create_scratch_host_vcpu
Date: Wed, 26 Aug 2026 11:36:23 +0200
Message-ID: <20260826093747.1670077-19-eric.auger@redhat.com>
In-Reply-To: <20260826093747.1670077-1-eric.auger@redhat.com>
References: <20260826093747.1670077-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: vvDehVnpWZJarGbC2FxS-Rzxhv2VV8Dpq7sBh5HmEmo_1787737195
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
index 68e0597ac6..d049334d6d 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -105,6 +105,7 @@ struct kvm_vcpu_init;
  * @init: filled in with the necessary values for creating a host
  * vcpu. If NULL is provided, will not init the vCPU (though the cpufd
  * will still be set up).
+ * @errp: Error handle
  *
  * Create a scratch vcpu in its own VM of the type preferred by the host
  * kernel (as would be used for '-cpu host'), for purposes of probing it
@@ -114,7 +115,7 @@ struct kvm_vcpu_init;
  * false on failure (and fdarray and init are not valid).
  */
 bool kvm_arm_create_scratch_host_vcpu(int *fdarray,
-                                      struct kvm_vcpu_init *init);
+                                      struct kvm_vcpu_init *init, Error **errp);
 
 /**
  * kvm_arm_destroy_scratch_host_vcpu:
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index bb1c49d44e..8a7f5982fb 100644
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
 
@@ -542,6 +547,7 @@ kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
     bool el2_supported;
     bool pmu_supported = false;
     uint64_t features = 0;
+    Error *local_err = NULL;
     int err;
 
     ahcf->target = QEMU_KVM_ARM_TARGET_NONE;
@@ -589,7 +595,8 @@ kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
         features |= 1ULL << ARM_FEATURE_PMU;
     }
 
-    if (!kvm_arm_create_scratch_host_vcpu(fdarray, &init)) {
+    if (!kvm_arm_create_scratch_host_vcpu(fdarray, &init, &local_err)) {
+        error_report_err(local_err);
         return;
     }
 
@@ -2956,8 +2963,10 @@ void arm_cpu_kvm_set_irq(void *arm_cpu, int irq, int level)
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

