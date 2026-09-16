Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C14D33C536
	for <kvmarm@lists.linux.dev>; Wed, 16 Sep 2026 14:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789570151; cv=none; b=lSV37LVQL/HILODNz0sv46nUtbJmEcd40jHDfQESH2vBbvMCiFiMDDNUpUeuQ9XCGXQuiG2TyMug4Fb7utUC587oVGaJuip4QgXu19SPsFIKkGvpIqQXLvK7wLu8/E25uU29Fj1vVrUtqMtW5g7cc+08ID23x1HkufSFzfIJ4nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789570151; c=relaxed/simple;
	bh=fJOMnUhYePLQywGQipVwX1/IQgP1xQ4QxaDel3IDzFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=PmB1m0SP3YXvknsy7PFCMimZoFJjdLCpOoR8vXmwKsF4qitghhqvDWUWZFNKu5OxD4wjFwywegIAxywwDRoh6ZJvr39rM3KvtlVX5XXClAVq788LozmcxI13SSUGzQgFclfyB1uWqnTtJG5Zka3DpdZbIyb1lL+BX2zUpS11Wok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i27DU2cA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i27DU2cA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789570149;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EiBclqfnHyEK7XPO+qxnPMI8the5N2406mXliaMHR/I=;
	b=i27DU2cAdDkQ25yoKDbUoDLUbc82JcOhvC0ePYmmkQ2Vk3UT8tp5z8ZtlVjNPq0TjcIA5G
	XZsvAjU7Y/GMcVSyV4CeejauEUohm7AGIl96i2KZjYhMdI825UtRhZg6Oe3nvdrqnguAqK
	/Ke1LfQa1uKCFvKYg/jI3/fgPBT+In8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-665-uHjc4MGCNpW2kIzBVsog1g-1; Wed,
 16 Sep 2026 10:49:02 -0400
X-MC-Unique: uHjc4MGCNpW2kIzBVsog1g-1
X-Mimecast-MFC-AGG-ID: uHjc4MGCNpW2kIzBVsog1g_1789570141
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E843818009D8;
	Wed, 16 Sep 2026 14:49:00 +0000 (UTC)
Received: from laptop.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 215941956053;
	Wed, 16 Sep 2026 14:48:55 +0000 (UTC)
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
Subject: [PATCH v9 17/26] target/arm/kvm: Add consistency checking for SYSREG props
Date: Wed, 16 Sep 2026 16:45:40 +0200
Message-ID: <20260916144721.751810-18-eric.auger@redhat.com>
In-Reply-To: <20260916144721.751810-1-eric.auger@redhat.com>
References: <20260916144721.751810-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: l_rvQOCyGkGLRPx3QnK-RM73vvCr2dK4hiua5esYJoE_1789570141
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Since legacy composite options (such as SVE, virtualization, ...)
and new SYSREG props coexist, add some basic consistency checks.

Those checks are performed both in kvm_arch_init_vcpu() before
applying the SYSREG props at the end of the initialization chain.

Some ID reg fields corresponding to legacy composite option scope
are not writable. In that case we just check that the field has
not become writable.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 target/arm/kvm.c | 105 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 105 insertions(+)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index ddf320d0e6..f52c03745e 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -340,6 +340,107 @@ static ARM64SysRegField *get_field(int i, ARM64SysReg *reg)
     return NULL;
 }
 
+
+/**
+ * kvm_arm_vcpu_validate_sysreg:
+ *
+ * Validate a SYSREG field value is consistent with legacy composite options
+ * Some checks are not implemented because the corresponding sysreg field
+ * is not currently writable. In that case we make sure the field has not
+ * become writable, which would mean the user had the capability to set the
+ * corresponding property.
+ *
+ * return true if consistent. false if it is not, along with an error handle
+ */
+static bool kvm_arm_vcpu_validate_sysreg(ARMCPU *cpu, ARM64SysRegField *field,
+                                         uint64_t value, Error **errp)
+{
+    const char *fieldname = field->name;
+    ARM64SysReg *sysregdesc = &arm64_id_regs[field->index];
+    const char *regname = sysregdesc->name;
+    g_autofree char *propname = g_strdup_printf("SYSREG_%s_%s", regname, fieldname);
+
+    /* virtualization */
+    if (!strcmp(propname, "SYSREG_ID_AA64PFR0_EL1_EL2")) {
+        /* consistency with machine virtualization property */
+        if (cpu->has_el2 && value == 0) {
+            error_setg(errp,
+                "Inconsistent -machine virtualization=on and "
+                "%s=0", propname);
+            return false;
+        } else if (!cpu->has_el2 && value > 0) {
+            error_setg(errp,
+                "Inconsistent -machine virtualization=off and "
+                "%s > 0", propname);
+            return false;
+        }
+    /* secure */
+    } else if (!strcmp(propname, "SYSREG_ID_AA64PFR0_EL1_EL3") && value > 0) {
+        /* consistency with machine secure property */
+        error_setg(errp, "%s is set but qemu is not ready to support it",
+                   propname);
+        return false;
+    /* MTE */
+    } else if (!strcmp(propname, "SYSREG_ID_AA64PFR1_EL1_MTE")) {
+        error_setg(errp, "%s is now exposed but qemu is not ready to support it",
+                   propname);
+        return false;
+    /* SVE */
+    } else if (!strcmp(propname, "SYSREG_ID_AA64PFR0_EL1_SVE")) {
+        error_setg(errp, "%s is now exposed but qemu is not ready to support it",
+                   propname);
+        return false;
+    } else if (!strcmp(propname, "SYSREG_ID_AA64ZFR0_EL1_SVEver")) {
+        if (cpu_isar_feature(aa64_sve, cpu) && value == 0) {
+            error_setg(errp, "sve is set but %s is set to 0", propname);
+            return false;
+        } else if (!cpu_isar_feature(aa64_sve, cpu) && value > 0) {
+            error_setg(errp, "sve is not set but %s is greater than 0",
+                       propname);
+            return false;
+        }
+    /* PAUTH */
+    } else if (!strcmp(propname, "SYSREG_ID_AA64ISAR1_EL1_APA")) {
+        /* PAUTH QARMA5 address authentification */
+        error_setg(errp, "%s is now exposed but qemu is not ready to support it",
+                   propname);
+        return false;
+    } else if (!strcmp(propname, "SYSREG_ID_AA64ISAR1_EL1_API")) {
+        /* PAUTH Impl Defined address authentification */
+        error_setg(errp, "%s is now exposed but qemu is not ready to support it",
+                   propname);
+        return false;
+    } else if (!strcmp(propname, "SYSREG_ID_AA64ISAR1_EL1_GPA")) {
+        /* QARMA5 generic code authentification */
+        error_setg(errp, "%s is now exposed but qemu is not ready to support it",
+                   propname);
+        return false;
+    } else if (!strcmp(propname, "SYSREG_ID_AA64ISAR1_EL1_GPI")) {
+        /* QARMA5 generic code authentification */
+        error_setg(errp, "%s is now exposed but qemu is not ready to support it",
+                   propname);
+        return false;
+    /* PMU */
+    } else if (!strcmp(propname, "SYSREG_ID_AA64DFR0_EL1_PMUVer")) {
+        if (cpu->has_pmu && value == 0) {
+            error_setg(errp, "%s is 0 whereas pmu is set", propname);
+            return false;
+        } else if (!cpu->has_pmu && value) {
+            error_setg(errp, "%s is non null whereas pmu is unset", propname);
+            return false;
+        }
+    /* aarch64 false */
+    } else if (!arm_feature(&cpu->env, ARM_FEATURE_AARCH64)) {
+        if ((!strcmp(propname, "SYSREG_ID_AA64PFR0_EL1_EL0") ||
+             !strcmp(propname, "SYSREG_ID_AA64PFR0_EL1_EL1") ||
+             !strcmp(propname, "SYSREG_ID_AA64PFR0_EL1_EL2")) && value < 2)
+            error_setg(errp, "%s is < 2 while aarch64 is set to off",
+                       propname);
+            return false;
+    }
+    return true;
+}
+
 #define MAKE_IDREG_KEY(reg_idx, field_shift) \
     (((uint64_t)(reg_idx) << 8) | ((uint64_t)(field_shift) & 0xFF))
 
@@ -2241,6 +2342,10 @@ static int kvm_arm_apply_sysreg_props(ARMCPU *cpu, Error **errp)
         uint64_t oldfv;
         int ret;
 
+        if (!kvm_arm_vcpu_validate_sysreg(cpu, field, value, errp)) {
+            return -1;
+        }
+
         mask = MAKE_64BIT_MASK(lower, length);
         value = value << lower;
 
-- 
2.53.0

