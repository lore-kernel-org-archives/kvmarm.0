Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A977340963D
	for <kvmarm@lists.linux.dev>; Tue, 19 May 2026 13:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779197424; cv=none; b=MhF8S5Ifm7K+hmzYZ9t25s+XsgXHCfbJfU1a3qhoMKJ4lsvejvy/LpKCv5mr0AQtEqQoFWGRhnX4dkco/cKYng9OOISwKZ1uQtxwUGQVMkTeoOEph7W0ultnN13MTsqUdMlFyKggAMjio2Lg+76SQhOCyJTGsVHa303gcbwyn7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779197424; c=relaxed/simple;
	bh=YJEcr8r23klc9DztrTLjkKpdfouFC/z7GBQHlTn7hFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=mGbchcbPSRck7DXNJYUpm1iP16m8zC+g11PYOgO/UIHo5mzG67XoRqgccOiEGrKLyx/XxlHeIhilCmIQkocZEYpIrpk5PP2U+PTm6bQzqaAcJCRV6RkrRZRwNH4k0h80GXOoMCJd6kTq7mPPMM2aYZ5p89aylGeeABgW/jsbXCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iVlQfAVV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iVlQfAVV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779197422;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qFB8bEbsG49icsTlwdP+dsQdEM638W12jl/FRcVdeeM=;
	b=iVlQfAVVJIIiapB8oYiLpqimvkpoSU8JQZLW3m27vOsycgKp15zouJ6B+9YW0NbYShcKCQ
	itjKdYPZGmoGxOS7Eg68WEQOZQjGtsM0iU13EyZoiOIANLN8xleSYaqcNkEjnNgudYyh4+
	ZGmyOfqkGdBvLe/i+MgSGDYGorNiTqY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-157-BpmEcQbAObyZVsv5EHeFgg-1; Tue,
 19 May 2026 09:30:18 -0400
X-MC-Unique: BpmEcQbAObyZVsv5EHeFgg-1
X-Mimecast-MFC-AGG-ID: BpmEcQbAObyZVsv5EHeFgg_1779197416
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A147119560A5;
	Tue, 19 May 2026 13:30:16 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.44.49.207])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 120621800352;
	Tue, 19 May 2026 13:30:09 +0000 (UTC)
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
	philmd@linaro.org
Cc: maz@kernel.org,
	oliver.upton@linux.dev,
	pbonzini@redhat.com,
	armbru@redhat.com,
	berrange@redhat.com,
	abologna@redhat.com,
	jdenemar@redhat.com
Subject: [PATCH v5 09/18] target/arm/kvm: Introduce kvm_get_writable_id_regs
Date: Tue, 19 May 2026 15:27:23 +0200
Message-ID: <20260519132905.145643-10-eric.auger@redhat.com>
In-Reply-To: <20260519132905.145643-1-eric.auger@redhat.com>
References: <20260519132905.145643-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: 8sN8ULg5dZY0xtHui_IwZFAS_sKIJCmpIyeu7nH8Y8Y_1779197416
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

From: Cornelia Huck <cohuck@redhat.com>

Add an helper to retrieve the writable id reg bitmask.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>

---

v4 -> v5:
- get rid of IdRegMap datatype
- do not store the status of the query in cpu anymore, just
  return the error in case the retrieval failed
- add implementation in kvm-stub.c
---
 target/arm/kvm-stub.c |  5 +++++
 target/arm/kvm.c      | 21 +++++++++++++++++++++
 target/arm/kvm_arm.h  |  2 ++
 3 files changed, 28 insertions(+)

diff --git a/target/arm/kvm-stub.c b/target/arm/kvm-stub.c
index 88cbe8d85c..cd88eb741a 100644
--- a/target/arm/kvm-stub.c
+++ b/target/arm/kvm-stub.c
@@ -119,3 +119,8 @@ char *kvm_print_register_name(uint64_t regidx)
 {
     g_assert_not_reached();
 }
+
+int kvm_arm_get_writable_id_regs(uint64_t *idregmap)
+{
+    g_assert_not_reached();
+}
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 7d194ea112..4adfd20050 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -505,6 +505,27 @@ void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu)
     env->features = arm_host_cpu_features.features;
 }
 
+int kvm_arm_get_writable_id_regs(uint64_t *idregmap)
+{
+    int cap_writable_id_regs;
+    struct reg_mask_range range = {
+        .range = 0, /* up to now only a single range is supported */
+        .addr = (uint64_t)idregmap,
+    };
+    int ret;
+
+    cap_writable_id_regs =
+        kvm_check_extension(kvm_state, KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES);
+
+    if (!cap_writable_id_regs ||
+        !(cap_writable_id_regs & (1 << KVM_ARM_FEATURE_ID_RANGE))) {
+        return -ENOSYS;
+    }
+
+    ret = kvm_vm_ioctl(kvm_state, KVM_ARM_GET_REG_WRITABLE_MASKS, &range);
+    return ret;
+}
+
 static bool kvm_no_adjvtime_get(Object *obj, Error **errp)
 {
     return !ARM_CPU(obj)->kvm_adjvtime;
diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index e7c40fb003..c1c2e7ec37 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -240,4 +240,6 @@ void arm_gic_cap_kvm_probe(GICCapability *v2, GICCapability *v3);
  */
 char *kvm_print_register_name(uint64_t regidx);
 
+int kvm_arm_get_writable_id_regs(uint64_t *idregmap);
+
 #endif
-- 
2.53.0

