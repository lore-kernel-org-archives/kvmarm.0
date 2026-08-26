Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F69C272E56
	for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 09:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787737197; cv=none; b=rhshisUYyUsf5XMZvTdiumbbE4NpyEzBVOIg5klQQnoJS+PeHhG4PCQftfp8KaFtxG3NDmua5HswVBMc0+ywFltu+9SlU0gU4TtfrfV9kgPwy1xR9WcGd0kQNM0hvvFqdEA1uaqwqkfCN/Z8HZLZCgf6ASt5VWg1eQN/SzBUbcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787737197; c=relaxed/simple;
	bh=Bq1EsSTbxFmpV/EzuYqAidaiX21eEd/BlERCycHg3eA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=lrclFIVbqlSPK98F/ykNraccWQJC2khxAsCRP0UkGZEw2gc2cBBTOWJhxom+7QGOBn43p8uaEUGJi7qquuI3JSUraGh9w/6xEaDP+gzAmG2u8h/VL8EZBFPXgoDna6LYTmsEp9heIfLLIm8ZXe/OBZQzayLcbv2eh6bDy9NRvqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hFdwiSDf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hFdwiSDf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787737195;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=akwd9qnyOgB/+NOpR7ufAEDjrr9laviPT/bwUHPvhIQ=;
	b=hFdwiSDfyxN+mB1M1eELrVuxyfIUnhdD5s6B6FOkmr0zyrLesHgQLabMaI+lwLPh8yYetk
	Li4O3CtFgJcSEzWm+FY4Is/1Mo2z8zQ/Izq6vUuJ8gYj19/jbELUktjVZVWB7cET8HHqs6
	zyzRFZ4UHSobx5lPD5BlKdItwGbziA4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-599-W-BwHplmNR-QufqqTa6UgQ-1; Wed,
 26 Aug 2026 05:39:51 -0400
X-MC-Unique: W-BwHplmNR-QufqqTa6UgQ-1
X-Mimecast-MFC-AGG-ID: W-BwHplmNR-QufqqTa6UgQ_1787737189
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 603FA18CD2A4;
	Wed, 26 Aug 2026 09:39:49 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.44.48.93])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6C0951955F05;
	Wed, 26 Aug 2026 09:39:43 +0000 (UTC)
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
Subject: [RFC PATCH v8 17/20] target/arm/kvm: add utility to write idregs in scratch vcpu
Date: Wed, 26 Aug 2026 11:36:22 +0200
Message-ID: <20260826093747.1670077-18-eric.auger@redhat.com>
In-Reply-To: <20260826093747.1670077-1-eric.auger@redhat.com>
References: <20260826093747.1670077-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: sL6e5KUlcpD1i8tM6dbr-pZ-s6T35n8L6z5oH1xUc1w_1787737189
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 target/arm/kvm_arm.h    |  3 +++
 target/arm/kvm-stub.c   |  6 +++++
 target/arm/kvm.c        | 51 +++++++++++++++++++++++++++++++++++++++++
 target/arm/trace-events |  1 +
 4 files changed, 61 insertions(+)

diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index 2b3474cc36..68e0597ac6 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -250,4 +250,7 @@ void arm_gic_cap_kvm_probe(GICCapability *v2, GICCapability *v3);
  */
 char *kvm_print_register_name(uint64_t regidx);
 
+bool kvm_idreg_write_scratch_vcpu(int cpufd, Visitor *v, const char *name,
+                                  void *opaque, Error **errp);
+
 #endif
diff --git a/target/arm/kvm-stub.c b/target/arm/kvm-stub.c
index 88cbe8d85c..264938d2c5 100644
--- a/target/arm/kvm-stub.c
+++ b/target/arm/kvm-stub.c
@@ -119,3 +119,9 @@ char *kvm_print_register_name(uint64_t regidx)
 {
     g_assert_not_reached();
 }
+
+bool kvm_idreg_write_scratch_vcpu(int cpufd, Visitor *v, const char *name,
+                                  void *opaque, Error **errp)
+{
+    g_assert_not_reached();
+}
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 8ec9bc51cd..bb1c49d44e 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -340,6 +340,57 @@ static ARM64SysRegField *get_field(int i, ARM64SysReg *reg)
     return NULL;
 }
 
+bool kvm_idreg_write_scratch_vcpu(int cpufd, Visitor *v, const char *name,
+                                  void *opaque, Error **errp)
+{
+    ARM64SysRegField *field = (ARM64SysRegField *)opaque;
+    uint64_t mask, old_reg_val, new_reg_val, oldfv, newfv;
+    struct kvm_one_reg reg;
+    int lower = field->shift;
+    int length = field->length;
+    int index = field->index;
+    uint64_t kidx;
+    int ret;
+
+    mask = MAKE_64BIT_MASK(lower, length);
+
+    if (!visit_type_uint64(v, name, &newfv, errp)) {
+        return false;
+    }
+
+    kidx = idregs_sysreg_to_kvm_reg(id_register_sysreg[index]);
+    ret = read_sys_reg64(cpufd, &old_reg_val, kidx);
+    if (ret) {
+        error_setg(errp, "failed to read the scratch vcpu value for field %s %m",
+                   field->name);
+        return false;
+    }
+    oldfv = (old_reg_val & mask) >> lower;
+
+    new_reg_val = old_reg_val & ~mask;
+    new_reg_val |= newfv << lower;
+
+    reg.id = kidx;
+    reg.addr = (uintptr_t)&new_reg_val;
+    ret = ioctl(cpufd, KVM_SET_ONE_REG, &reg);
+    if (ret) {
+        error_setg(errp, "failed to apply new value 0x%"PRIx64" for field %s "
+                   "(previous is 0x%"PRIx64"): %m", newfv, field->name, oldfv);
+        return false;
+    } else {
+        uint64_t check_val, actualfv;
+
+        ret = read_sys_reg64(cpufd, &check_val, kidx);
+        if (ret) {
+            error_setg(errp, "failed to read the new reg value: %m");
+            return false;
+        }
+        actualfv = (check_val & mask) >> lower;
+        trace_kvm_idreg_write_scratch_vcpu(field->name, oldfv, newfv, actualfv);
+    }
+    return true;
+}
+
 static void set_sysreg_prop(Object *obj, Visitor *v,
                             const char *name, void *opaque,
                             Error **errp)
diff --git a/target/arm/trace-events b/target/arm/trace-events
index e67730de6b..71a2f5770c 100644
--- a/target/arm/trace-events
+++ b/target/arm/trace-events
@@ -20,6 +20,7 @@ get_sysreg_prop(const char *name, uint64_t value) "%s 0x%"PRIx64
 set_sysreg_prop(const char *name, uint64_t old, uint64_t mask, uint64_t field_value, uint64_t new) "%s old reg value=0x%"PRIx64" mask=0x%"PRIx64" new field value=0x%"PRIx64" new reg value=0x%"PRIx64
 nb_sysreg_props(const char *name, int count) "%s: %d SYSREG properties"
 unexpected_writable_reserved_field(const char *reg_name, const char *field_name, int lower, int upper) "Unexpected writable reserved field: %s.%s [%d,%d], skip it ..."
+kvm_idreg_write_scratch_vcpu(const char *name, uint64_t oldfv, uint64_t newfv, uint64_t actualfv) "successful dry-run for %s old=0x%"PRIx64" new=0x%"PRIx64" actual=0x%"PRIx64
 
 # cpu.c
 arm_cpu_reset(uint64_t mp_aff) "cpu %" PRIu64
-- 
2.53.0

