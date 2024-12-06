Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8503C46426
	for <kvmarm@lists.linux.dev>; Fri,  6 Dec 2024 11:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733484164; cv=none; b=pXTLGf+wSR8gEa4t7sQgNkJ3oDbjq5HI+yWLax08is2bN3e11DSL/5qKE27SWINA6ihtbWgdtPhg4Q9jRWlDqc8G+e8DaZ9KnVwqLVc4kVHva4D4T118NBRZwFaBiS4AUnO7WL1eBWhwN4kJO6AAmE75Ao1mj1GQ8x8Yv0+2mi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733484164; c=relaxed/simple;
	bh=N9oeF3LkXAwM098nOxrfOcZNs3To/fm9BmiGOikdfWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=Nd54StKVl4aiPalkNpopbZLWH/SjUyGoND62DEiBPO4yCMJdgY/JmYz1urPlSqz1+Z1nSJyEYcx0nUNh/5SuK/ikmbbeC/Cd30XOYF6nQueGTEZMN7YGmKvnbsj09HRAuwePZRqNW5HiObl3kptXJIf5ppsozW4fK804/xAyLls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GnmHO0DC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GnmHO0DC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733484158;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a+vW83SkNOGyD0qc4h80IZxlblDeSFgBKoINuDyWpR4=;
	b=GnmHO0DCCQLYu7gAyTYUwEyvG2uFemXuMZE04lhCR86StR/aQe3hW72QJg0stpN05x7zc1
	3W/fHiH+OmTkCubBv4Vvgb1JUnMBcud58oM7jt/Uf5we+tOz0eoNTDy4KodujxyETrCCEt
	cOrE+sfZtoeDC8xjkSE2jnXHCmzOfHY=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-191-nym_uZ5RNw-N5La_710GGg-1; Fri,
 06 Dec 2024 06:22:35 -0500
X-MC-Unique: nym_uZ5RNw-N5La_710GGg-1
X-Mimecast-MFC-AGG-ID: nym_uZ5RNw-N5La_710GGg
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 31FAA1954ADD;
	Fri,  6 Dec 2024 11:22:32 +0000 (UTC)
Received: from gondolin.str.redhat.com (dhcp-192-244.str.redhat.com [10.33.192.244])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1D81419560A2;
	Fri,  6 Dec 2024 11:22:25 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
	qemu-devel@nongnu.org,
	qemu-arm@nongnu.org,
	kvmarm@lists.linux.dev,
	peter.maydell@linaro.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	maz@kernel.org,
	oliver.upton@linux.dev,
	sebott@redhat.com,
	shameerali.kolothum.thodi@huawei.com,
	armbru@redhat.com,
	berrange@redhat.com,
	abologna@redhat.com,
	jdenemar@redhat.com
Cc: shahuang@redhat.com,
	mark.rutland@arm.com,
	philmd@linaro.org,
	pbonzini@redhat.com,
	Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH RFCv2 01/20] kvm: kvm_get_writable_id_regs
Date: Fri,  6 Dec 2024 12:21:54 +0100
Message-ID: <20241206112213.88394-2-cohuck@redhat.com>
In-Reply-To: <20241206112213.88394-1-cohuck@redhat.com>
References: <20241206112213.88394-1-cohuck@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Add an helper to retrieve the writable id reg bitmask. The
status of the query is stored in the CPU struct so that an
an error, if any, can be reported on vcpu realize().

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 target/arm/cpu.h     | 19 +++++++++++++++++++
 target/arm/kvm.c     | 32 ++++++++++++++++++++++++++++++++
 target/arm/kvm_arm.h |  7 +++++++
 3 files changed, 58 insertions(+)

diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index d86e641280d4..e359152a4dbc 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -828,6 +828,19 @@ typedef struct {
     uint32_t map, init, supported;
 } ARMVQMap;
 
+typedef enum ARMIdRegsState {
+    WRITABLE_ID_REGS_UNKNOWN,
+    WRITABLE_ID_REGS_NOT_DISCOVERABLE,
+    WRITABLE_ID_REGS_FAILED,
+    WRITABLE_ID_REGS_AVAIL,
+} ARMIdRegsState;
+
+#define NR_ID_REGS (3 * 8 * 8)
+
+typedef struct IdRegMap {
+    uint64_t regs[NR_ID_REGS];
+} IdRegMap;
+
 /**
  * ARMCPU:
  * @env: #CPUARMState
@@ -969,6 +982,12 @@ struct ArchCPU {
      */
     bool host_cpu_probe_failed;
 
+    /*
+     * state of writable id regs query used to report an error, if any,
+     * on KVM custom vcpu model realize
+     */
+    ARMIdRegsState writable_id_regs;
+
     /* QOM property to indicate we should use the back-compat CNTFRQ default */
     bool backcompat_cntfrq;
 
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 7b6812c0de2e..8577d6f520ba 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -49,6 +49,7 @@ const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
 static bool cap_has_mp_state;
 static bool cap_has_inject_serror_esr;
 static bool cap_has_inject_ext_dabt;
+static int cap_writable_id_regs;
 
 /**
  * ARMHostCPUFeatures: information about the host CPU (identified
@@ -495,6 +496,37 @@ void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu)
     env->features = arm_host_cpu_features.features;
 }
 
+int kvm_arm_get_writable_id_regs(ARMCPU *cpu, IdRegMap *idregmap)
+{
+    struct reg_mask_range range = {
+        .range = 0, /* up to now only a single range is supported */
+        .addr = (uint64_t)idregmap,
+    };
+    int ret;
+
+    if (!kvm_enabled()) {
+        cpu->writable_id_regs = WRITABLE_ID_REGS_NOT_DISCOVERABLE;
+        return -ENOSYS;
+    }
+
+    cap_writable_id_regs =
+        kvm_check_extension(kvm_state, KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES);
+
+    if (!cap_writable_id_regs ||
+        !(cap_writable_id_regs & (1 << KVM_ARM_FEATURE_ID_RANGE))) {
+        cpu->writable_id_regs = WRITABLE_ID_REGS_NOT_DISCOVERABLE;
+        return -ENOSYS;
+    }
+
+    ret = kvm_vm_ioctl(kvm_state, KVM_ARM_GET_REG_WRITABLE_MASKS, &range);
+    if (ret) {
+        cpu->writable_id_regs = WRITABLE_ID_REGS_FAILED;
+        return ret;
+     }
+    cpu->writable_id_regs = WRITABLE_ID_REGS_AVAIL;
+    return ret;
+}
+
 static bool kvm_no_adjvtime_get(Object *obj, Error **errp)
 {
     return !ARM_CPU(obj)->kvm_adjvtime;
diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index 2e6b49bf1376..426816ad3a74 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -221,6 +221,8 @@ int kvm_arm_set_irq(int cpu, int irqtype, int irq, int level);
 
 void kvm_arm_enable_mte(Object *cpuobj, Error **errp);
 
+int kvm_arm_get_writable_id_regs(ARMCPU *cpu, IdRegMap *idregmap);
+
 #else
 
 /*
@@ -247,6 +249,11 @@ static inline bool kvm_arm_mte_supported(void)
     return false;
 }
 
+static inline int kvm_arm_get_writable_id_regs(ARMCPU *cpu, IdRegMap *idregmap)
+{
+    return -ENOSYS;
+}
+
 /*
  * These functions should never actually be called without KVM support.
  */
-- 
2.47.0

