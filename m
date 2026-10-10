Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947933769E0
	for <kvmarm@lists.linux.dev>; Sat, 10 Oct 2026 13:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791639568; cv=none; b=UcaOolGKED1oBioUIOQfwVsiS4hU+NqT0Qy/wFIZujt7LICW4UrjOcfFMKGVG3hX9eErbXghz6P9CBj4ejEOgzr0P25CGyNVsQJpuiXxvC1wRJMGJQqhr/ntOFpP7BK8z2rbf+H7DSQJ8i2BjQkP8nLj7tAYsckSTTCZGWRXvh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791639568; c=relaxed/simple;
	bh=LjcQmIvfgGCCmpxwcd1dcb/5lATBJ8uNwlmtdM0EA7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=u+9RnUHzJfL9ss4JDo/LJNboeiEAFtK6GsxztyfQBKm+6eilUeFKuX7xYVyh9uBBIGFlUIqGAamG2rM3nN4CsF51+e0kzAhRA6rO7ZiEI5rHjpG9M5Pla/e03jMynlfgMTLBqG732oqu9KKYtzEjoJzaGNOHnli1hnr8wvdquGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HPjsrF+9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HPjsrF+9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791639566;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v43ocM3DpQoBMOmnWjOUY1Uk4kwBrzKU6IVEiEb5hkU=;
	b=HPjsrF+9nEto+aA65DGBFAr8qYo1EKC89HmavKDZ9jQoyjtT8k6VzC6TUhOF2mfq7zHERZ
	3Ibhx0timxkbgTCWA3XHOywXNOegX62Xy7IIjl+DcDSZaOaMdGbrV5BrNt4aax2T1v/O0o
	hb+YyuySDU451JCUvLaCqEXNltK05d8=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-183-BPK8EFKOOj6vqxxTk1BCAQ-1; Sat,
 10 Oct 2026 13:39:22 +0000
X-MC-Unique: BPK8EFKOOj6vqxxTk1BCAQ-1
X-Mimecast-MFC-AGG-ID: BPK8EFKOOj6vqxxTk1BCAQ_1791639560
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1C8F31944B01;
	Sat, 10 Oct 2026 13:39:20 +0000 (UTC)
Received: from laptop.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AB66D30000E5;
	Sat, 10 Oct 2026 13:39:15 +0000 (UTC)
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
Subject: [PATCH v10 21/26] target/arm/cpu64: Add helper to test SYSREG props against a scratch vcpu
Date: Sat, 10 Oct 2026 15:36:25 +0200
Message-ID: <20261010133725.642498-22-eric.auger@redhat.com>
In-Reply-To: <20261010133725.642498-1-eric.auger@redhat.com>
References: <20261010133725.642498-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: ZkNCdBtnJx7ONvWIlssGM5HcCy1_czQFsx_J_Sb0rnc_1791639560
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Add kvm_idreg_write_scratch_vcpu helper that will be used
by qmp_query_cpu_model_expansion code to test SYSREG settings
against a scratch vcpu. Indeed when the expansion code is called
the actual vcpu has not been initialized so we use a scratch vcpu.
This latter has been initialized with features taken from
legacy compositive options (EL2, SVE, ...). So the trial is
very close to the final setup.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 target/arm/kvm_arm.h    |  4 ++++
 target/arm/kvm-stub.c   |  7 +++++++
 target/arm/kvm.c        | 21 +++++++++++++++++++++
 target/arm/trace-events |  1 +
 4 files changed, 33 insertions(+)

diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index e7c40fb003..25a1dec095 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -14,6 +14,7 @@
 #include "qapi/qapi-types-misc-arm.h"
 #include "system/kvm.h"
 #include "target/arm/cpu-qom.h"
+#include "cpu-idregs.h"
 
 #define KVM_ARM_VGIC_V2   (1 << 0)
 #define KVM_ARM_VGIC_V3   (1 << 1)
@@ -240,4 +241,7 @@ void arm_gic_cap_kvm_probe(GICCapability *v2, GICCapability *v3);
  */
 char *kvm_print_register_name(uint64_t regidx);
 
+bool kvm_idreg_write_scratch_vcpu(ARMCPU *cpu, int cpufd,
+                                  ARM64SysRegField *field, uint64_t newfv,
+                                  Error **errp);
 #endif
diff --git a/target/arm/kvm-stub.c b/target/arm/kvm-stub.c
index 88cbe8d85c..8e6fae0a4d 100644
--- a/target/arm/kvm-stub.c
+++ b/target/arm/kvm-stub.c
@@ -119,3 +119,10 @@ char *kvm_print_register_name(uint64_t regidx)
 {
     g_assert_not_reached();
 }
+
+bool kvm_idreg_write_scratch_vcpu(ARMCPU *cpu, int cpufd,
+                                  ARM64SysRegField *field, uint64_t newfv,
+                                  Error **errp)
+{
+    g_assert_not_reached();
+}
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 0c7e80aea8..82ffcac7e3 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -1297,6 +1297,27 @@ static int kvm_arm_apply_one_sysreg_prop(ARMCPU *cpu, ARM64SysRegField *field,
     return kvm_arm_override_idreg_field(CPU(cpu)->kvm_fd, field, newfv, errp);
 }
 
+bool kvm_idreg_write_scratch_vcpu(ARMCPU *cpu, int cpufd,
+                                  ARM64SysRegField *field, uint64_t newfv,
+                                  Error **errp)
+{
+    int ret;
+
+    if (!arm_cpu_validate_sysreg_prop(cpu, field, newfv, errp)) {
+        return false;
+    }
+
+    ret = kvm_arm_override_idreg_field(cpufd, field, newfv, errp);
+    if (ret) {
+        return false;
+    }
+
+    cpu->isar.idregs[field->index] =
+        deposit64(cpu->isar.idregs[field->index],
+                  field->shift, field->length, newfv);
+    return true;
+}
+
 static int kvm_arm_apply_sysreg_props(ARMCPU *cpu, Error **errp)
 {
     return arm_cpu_apply_sysreg_props(cpu, kvm_arm_apply_one_sysreg_prop, errp);
diff --git a/target/arm/trace-events b/target/arm/trace-events
index 81564f1d96..a731b5d4ba 100644
--- a/target/arm/trace-events
+++ b/target/arm/trace-events
@@ -15,6 +15,7 @@ arm_gt_update_irq(int timer, int irqstate) "gt_update_irq: timer %d irqstate %d"
 kvm_arm_fixup_msi_route(uint64_t iova, uint64_t gpa) "MSI iova = 0x%"PRIx64" is translated into 0x%"PRIx64
 get_host_cpu_idregs(const char *name, uint64_t value) "scratch vcpu host value for %s is 0x%"PRIx64
 kvm_arm_override_idreg_field(const char *reg_name, const char *field_name, uint64_t currentfv, uint64_t newfv) "%s.%s current=0x%"PRIx64" new=0x%"PRIx64
+kvm_arm_idreg_write_scratch_vcpu(const char *name, uint64_t oldfv, uint64_t newfv, uint64_t actualfv) "successful dry-run for %s old=0x%"PRIx64" new=0x%"PRIx64" actual=0x%"PRIx64
 
 # cpu.c
 arm_cpu_reset(uint64_t mp_aff) "cpu %" PRIu64
-- 
2.53.0

