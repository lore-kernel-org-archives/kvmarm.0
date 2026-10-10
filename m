Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B854C377575
	for <kvmarm@lists.linux.dev>; Sat, 10 Oct 2026 13:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791639554; cv=none; b=FAJhaX76VXtUWJXJjJOb/fC/mhI5GQ3P8vNMOt+JLFiTNuedIIAkOz2J8O6VpQmyJMmbzXUe5WP79B81OuF9Ek3j6fZrxtoCxgL60+c1t9uwBYOjXRUyLKN/NKCdKWWwa1hG49uBWEvGlyLYuzzuKsCBwwz8ohg8/qHqJ5Ajb8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791639554; c=relaxed/simple;
	bh=8nES2r3mSo6bXD9nRkvo9IrYuIyM/oUbJMmZG+opPSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=tq8Y2Yy8mZMF0ADiieerYB46n7I+RVItAMmj3wYADmYwi8KafQArJ5I/E7BDft0arvC3BYO1KH6/FWU7YsQNX1PmxoGibQxmTRmQzXOYVg11U8R7W3kuNvsVE+VlSD5+KiCnbGWcqekD6jj8+yhTc8qNvYHu7I50xOcdU0IW5Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QmcgAMkk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QmcgAMkk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791639551;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5ahJOvaYHs21/JKqAABHSIlAiPcEjA+M5FAHkRnQW3k=;
	b=QmcgAMkkQOBHpRVty6jAjDj2jaVLd/iTqD2ID4Eh/ey8KeEVyslPM1G4hO42GEykyojscS
	JAWxT3uHDzQRNXdJBMqRvMujHqX6tlT3FXn4+fzNtElA99uecEgXG6uEp6rf6chGQdmOz1
	V/aDOUOTuPuu1DxypvJpNlX7d3GaOOk=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-536-kcQYT6ZWMpy_MzRG2OuGFw-1; Sat,
 10 Oct 2026 13:39:02 +0000
X-MC-Unique: kcQYT6ZWMpy_MzRG2OuGFw-1
X-Mimecast-MFC-AGG-ID: kcQYT6ZWMpy_MzRG2OuGFw_1791639540
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A9FDB180ACCE;
	Sat, 10 Oct 2026 13:39:00 +0000 (UTC)
Received: from laptop.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DB74430000E5;
	Sat, 10 Oct 2026 13:38:55 +0000 (UTC)
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
Subject: [PATCH v10 17/26] target/arm/kvm: Introduce kvm_arm_override_idreg_field helper
Date: Sat, 10 Oct 2026 15:36:21 +0200
Message-ID: <20261010133725.642498-18-eric.auger@redhat.com>
In-Reply-To: <20261010133725.642498-1-eric.auger@redhat.com>
References: <20261010133725.642498-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: 7mTB5cvUPZZcreOPxClZjkJTPdqi0bh_xhn6khiS5TI_1791639540
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Introduce kvm_arm_override_idreg_field() helper that allows
to read an ID register value from a vcpu fd, override a
given field value and reinject the new register value in the
guest vcpu.

The helper is not used yet, hence the G_GNUC_UNUSED marker.
It will be used in subsequent patch to apply a new field
value set through SYSREG property.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 target/arm/kvm.c        | 48 ++++++++++++++++++++++++++++++++++++++++-
 target/arm/trace-events |  1 +
 2 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 6c15d8522f..c6c9ea03a5 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -1247,6 +1247,50 @@ bool kvm_arm_cpu_post_load(ARMCPU *cpu)
     return true;
 }
 
+static int G_GNUC_UNUSED
+kvm_arm_override_idreg_field(int fd, ARM64SysRegField *field,
+                             uint64_t newfv, Error **errp)
+{
+    uint64_t current, currentfv, value;
+    struct kvm_one_reg kvm_reg;
+    int index = field->index;
+    int length = field->length;
+    int lower = field->shift;
+    ARM64SysReg *reg;
+    uint64_t kvm_idx;
+    int ret;
+
+    reg = &arm64_id_regs[index];
+
+    kvm_idx = idregs_sysreg_to_kvm_reg(id_register_sysreg[index]);
+
+    ret = read_sys_reg64(fd, &current, kvm_idx);
+    if (ret) {
+        error_setg(errp, "failed to read %s current value", reg->name);
+        return ret;
+    }
+    currentfv = extract64(current, lower, length);
+
+    if (currentfv != newfv) {
+        value = deposit64(current, lower, length, newfv);
+        kvm_reg.id = kvm_idx;
+        kvm_reg.addr = (uintptr_t)&value;
+
+        ret = ioctl(fd, KVM_SET_ONE_REG, &kvm_reg);
+        if (ret) {
+            error_setg(errp,
+                       "ID register field %s.%s: fail to apply new value=0x%"
+                       PRIx64" (current is 0x%"PRIx64"): %m",
+                       reg->name, field->name, newfv, currentfv);
+
+            return ret;
+        }
+    }
+    trace_kvm_arm_override_idreg_field(reg->name, field->name,
+                                       currentfv, newfv);
+    return 0;
+}
+
 void kvm_arm_reset_vcpu(ARMCPU *cpu)
 {
     int ret;
@@ -1259,6 +1303,7 @@ void kvm_arm_reset_vcpu(ARMCPU *cpu)
         fprintf(stderr, "kvm_arm_vcpu_init failed: %s\n", strerror(-ret));
         abort();
     }
+
     if (!write_kvmstate_to_list(cpu)) {
         fprintf(stderr, "write_kvmstate_to_list failed\n");
         abort();
@@ -2204,7 +2249,8 @@ int kvm_arch_init_vcpu(CPUState *cs, Error **errp)
         return ret;
     }
     SET_IDREG(&cpu->isar, MPIDR, mpidr);
-    cpu->mp_affinity = mpidr & ARM64_AFFINITY_MASK;
+
+    cpu->mp_affinity = GET_IDREG(&cpu->isar, MPIDR) & ARM64_AFFINITY_MASK;
 
     return kvm_arm_init_cpreg_list(cpu, errp);
 }
diff --git a/target/arm/trace-events b/target/arm/trace-events
index ddc79eb666..81564f1d96 100644
--- a/target/arm/trace-events
+++ b/target/arm/trace-events
@@ -14,6 +14,7 @@ arm_gt_update_irq(int timer, int irqstate) "gt_update_irq: timer %d irqstate %d"
 # kvm.c
 kvm_arm_fixup_msi_route(uint64_t iova, uint64_t gpa) "MSI iova = 0x%"PRIx64" is translated into 0x%"PRIx64
 get_host_cpu_idregs(const char *name, uint64_t value) "scratch vcpu host value for %s is 0x%"PRIx64
+kvm_arm_override_idreg_field(const char *reg_name, const char *field_name, uint64_t currentfv, uint64_t newfv) "%s.%s current=0x%"PRIx64" new=0x%"PRIx64
 
 # cpu.c
 arm_cpu_reset(uint64_t mp_aff) "cpu %" PRIu64
-- 
2.53.0

