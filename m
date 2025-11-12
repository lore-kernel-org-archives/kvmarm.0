Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4146934A3BF
	for <kvmarm@lists.linux.dev>; Wed, 12 Nov 2025 18:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762971254; cv=none; b=gxtTs6iibwW+kRV96xhogZ0/65/H7dKtr5FkIZ4vGhD3D0kcQIR4KoTgR+Jszcr+6QA7tBhoVrK4XG3jYE7R6+EEqj2i+tkY437OPJgYCgD18TzJFTpmSTzD4lbQrwDhKr5Rb7IZTPJU3RQYbu14RLGXYgGm5Qlz5BLwoa1xN/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762971254; c=relaxed/simple;
	bh=E/lPvDFxtdKz/fvz2i0BZfz6Y2YfQQrewCfi1yv0nLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=E3RpxoZIAu49a6d6Ez5egw3zOA1IBaYTx9QI73t/sU5yWZ/WLXAu5aVbDd5CSqffyXPAyWSozyF6sGUvCHxThQddFWmrFHLz9rCtLL/7rpb2EzVImQEGVchK6JFOTxUMSJ9cTGna6PscL+1cQf/VKyzR+6LPwekGE57+PexRFSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LQvq+82c; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LQvq+82c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762971252;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tvPCq7VyEuzcNyp7CnFoOXZYmZVPIQ6yNur1I1qze6g=;
	b=LQvq+82c+TKqZrsRYfTk1QRnD/pZRAFJb5460tZtnei3MqkQ67VBz0LWwwJvgOyxX5Erfb
	N8aPXw2hHE+y2qdtsypbhFOqruoZzjsO3LDMD/mUl8pHAeAU/OqSAVZGcqEZwEPjMRkjOU
	w45srn8uMB36icl4VzUuuia4UG8Dgw8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-490-0EMgAcdXPhOOTzYjhOoISw-1; Wed, 12 Nov 2025 13:14:10 -0500
X-MC-Unique: 0EMgAcdXPhOOTzYjhOoISw-1
X-Mimecast-MFC-AGG-ID: 0EMgAcdXPhOOTzYjhOoISw_1762971249
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4773e108333so50635e9.0
        for <kvmarm@lists.linux.dev>; Wed, 12 Nov 2025 10:14:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762971249; x=1763576049;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tvPCq7VyEuzcNyp7CnFoOXZYmZVPIQ6yNur1I1qze6g=;
        b=AYDlg5j7qoQB09GDGCilD3ba8iLsOy3PAlcL4Ms7N2Dd7U+EMpTRbycnrgzQdE8niM
         etZHX+BH6h1pVKxnkxOpHCN3TOn47uxgqVg+ee9kSDDTbFGnf2Afrl23ZfQ920ZrG7kX
         nlTLVf/wLUt0RcGQiLxnu1zsVA6zoffruLFXNlWazfQwhvFTWkdCTrg7+C3qcGLH7TZr
         Q7qG0qfWcegBGI4/NmE+A9N8Uq5VT++tEKABK5MAgqByIWIp7aWvBsZOMNm9kC55+d/L
         TWZ4Lx2sbFjkacqyP+91BsAWZ1n83dKHRf6jPBWoWgdTIMzwEyOg6euqKrYtrTf7Vpd4
         JcoQ==
X-Forwarded-Encrypted: i=1; AJvYcCXVYAIPtkhA7EJdhs7WxnDcFPw5rTwfR38+1R/81Y6qhjW+9kU7ROxfH2kS61yMOxj5E0OAc2s=@lists.linux.dev
X-Gm-Message-State: AOJu0YxY30EAXavEsFyZExYQKAfg5HdL7t2UzK5SSdSiXhRBhtNjbyM1
	1IKaIy1lXQ750+oYALbgU94JpF6FMJNnK+C5m4P2eoqgewUoyVHWUv6sxOZZ1edlwTB8PbnMh6T
	MDueg1WBrBYL60Cs1JFWhEi9EoWYga80a+hwGPVsAArB0rwdzGQgvPJiJtw==
X-Gm-Gg: ASbGncuZ6NixDtD2/kF82DjioQrwtN8wu5w6Usg/uBZfwRAm67LkW8fJRbHBoWlQjoE
	/oam/HPi014D9nHJLrdMj0brtsg/d1TZtQWJLKD108FUrYsk6RPYOZNoGSSJvAZ4v5mtChclMaZ
	8awFouMgMPvJUi2gGRq4liXta1cagW2HX5zA0ViAt7/KioPJ2Ma+kBDk9bq1Q+zluezwji6UX28
	EplThAN/TsQiQ/3fP2gEn1oKBIJ72r2UYhOYLi6zCt+4prPf+HrhczUW0zwNlMkW3FWlTdt6xa2
	qCqADf8HlG7JA0tY+FRcpNI5dKLAxBnZtPtSuBX3ADsq7kNKRg6aw8+Mkp2dL0Deyv8bwSe+Um8
	daPUiHHLy5N03tFQpb9gQdxQY4vg1PiSbvoOdPHRomL8xb4Uk2nDHrmMRMgyQ5A==
X-Received: by 2002:a05:600c:6305:b0:45d:dc85:c009 with SMTP id 5b1f17b1804b1-4778704c87amr36369895e9.10.1762971248732;
        Wed, 12 Nov 2025 10:14:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGOtRuApVaSJzjluxq/syrI6PaRRaNwBA+5BiNbfifiB+oERbEdmvKrC/cBX/JWi/+NkctM3Q==
X-Received: by 2002:a05:600c:6305:b0:45d:dc85:c009 with SMTP id 5b1f17b1804b1-4778704c87amr36369595e9.10.1762971248323;
        Wed, 12 Nov 2025 10:14:08 -0800 (PST)
Received: from rh.fritz.box (p200300f6af131a0027bd20bfc18c447d.dip0.t-ipconnect.de. [2003:f6:af13:1a00:27bd:20bf:c18c:447d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47787e51e49sm46851355e9.7.2025.11.12.10.14.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 10:14:07 -0800 (PST)
From: Sebastian Ott <sebott@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eric Auger <eric.auger@redhat.com>
Cc: qemu-arm@nongnu.org,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Sebastian Ott <sebott@redhat.com>
Subject: [PATCH v3 2/2] target/arm/kvm: add kvm-psci-version vcpu property
Date: Wed, 12 Nov 2025 19:13:57 +0100
Message-ID: <20251112181357.38999-3-sebott@redhat.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251112181357.38999-1-sebott@redhat.com>
References: <20251112181357.38999-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tQBGrm22U9k4FLL2CIAvwqL8WcT9-BQugvLcsEfYEyI_1762971249
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Provide a kvm specific vcpu property to override the default
(as of kernel v6.13 that would be PSCI v1.3) PSCI version emulated
by kvm. Current valid values are: 0.1, 0.2, 1.0, 1.1, 1.2, and 1.3

Note: in order to support PSCI v0.1 we need to drop vcpu
initialization with KVM_CAP_ARM_PSCI_0_2 in that case.

Signed-off-by: Sebastian Ott <sebott@redhat.com>
---
 docs/system/arm/cpu-features.rst |  5 +++
 target/arm/cpu.h                 |  6 +++
 target/arm/kvm.c                 | 64 +++++++++++++++++++++++++++++++-
 3 files changed, 74 insertions(+), 1 deletion(-)

diff --git a/docs/system/arm/cpu-features.rst b/docs/system/arm/cpu-features.rst
index 37d5dfd15b..1d32ce0fee 100644
--- a/docs/system/arm/cpu-features.rst
+++ b/docs/system/arm/cpu-features.rst
@@ -204,6 +204,11 @@ the list of KVM VCPU features and their descriptions.
   the guest scheduler behavior and/or be exposed to the guest
   userspace.
 
+``kvm-psci-version``
+  Override the default (as of kernel v6.13 that would be PSCI v1.3)
+  PSCI version emulated by the kernel. Current valid values are:
+  0.1, 0.2, 1.0, 1.1, 1.2, and 1.3
+
 TCG VCPU Features
 =================
 
diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index 39f2b2e54d..c2032070b7 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -981,6 +981,12 @@ struct ArchCPU {
      */
     uint32_t psci_version;
 
+    /*
+     * Intermediate value used during property parsing.
+     * Once finalized, the value should be read from psci_version.
+     */
+    uint32_t prop_psci_version;
+
     /* Current power state, access guarded by BQL */
     ARMPSCIState power_state;
 
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 0d57081e69..e91b1abfb8 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -484,6 +484,49 @@ static void kvm_steal_time_set(Object *obj, bool value, Error **errp)
     ARM_CPU(obj)->kvm_steal_time = value ? ON_OFF_AUTO_ON : ON_OFF_AUTO_OFF;
 }
 
+struct psci_version {
+    uint32_t number;
+    const char *str;
+};
+
+static const struct psci_version psci_versions[] = {
+    { QEMU_PSCI_VERSION_0_1, "0.1" },
+    { QEMU_PSCI_VERSION_0_2, "0.2" },
+    { QEMU_PSCI_VERSION_1_0, "1.0" },
+    { QEMU_PSCI_VERSION_1_1, "1.1" },
+    { QEMU_PSCI_VERSION_1_2, "1.2" },
+    { QEMU_PSCI_VERSION_1_3, "1.3" },
+    { -1, NULL },
+};
+
+static char *kvm_get_psci_version(Object *obj, Error **errp)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+    const struct psci_version *ver;
+
+    for (ver = psci_versions; ver->number != -1; ver++) {
+        if (ver->number == cpu->psci_version)
+            return g_strdup(ver->str);
+    }
+
+    return g_strdup_printf("Unknown PSCI-version: %x", cpu->psci_version);
+}
+
+static void kvm_set_psci_version(Object *obj, const char *value, Error **errp)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+    const struct psci_version *ver;
+
+    for (ver = psci_versions; ver->number != -1; ver++) {
+        if (!strcmp(value, ver->str)) {
+            cpu->prop_psci_version = ver->number;
+            return;
+        }
+    }
+
+    error_setg(errp, "Invalid PSCI-version value");
+}
+
 /* KVM VCPU properties should be prefixed with "kvm-". */
 void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
 {
@@ -505,6 +548,12 @@ void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
                              kvm_steal_time_set);
     object_property_set_description(obj, "kvm-steal-time",
                                     "Set off to disable KVM steal time.");
+
+    object_property_add_str(obj, "kvm-psci-version", kvm_get_psci_version,
+                            kvm_set_psci_version);
+    object_property_set_description(obj, "kvm-psci-version",
+                                    "Set PSCI version. "
+                                    "Valid values are 0.1, 0.2, 1.0, 1.1, 1.2, 1.3");
 }
 
 bool kvm_arm_pmu_supported(void)
@@ -1959,7 +2008,12 @@ int kvm_arch_init_vcpu(CPUState *cs)
     if (cs->start_powered_off) {
         cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_POWER_OFF;
     }
-    if (kvm_check_extension(cs->kvm_state, KVM_CAP_ARM_PSCI_0_2)) {
+    if (cpu->prop_psci_version != QEMU_PSCI_VERSION_0_1 &&
+        kvm_check_extension(cs->kvm_state, KVM_CAP_ARM_PSCI_0_2)) {
+        /*
+         * Versions >= v0.2 are backward compatible with v0.2
+         * omit the feature flag for v0.1 .
+         */
         cpu->psci_version = QEMU_PSCI_VERSION_0_2;
         cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_PSCI_0_2;
     }
@@ -1998,6 +2052,14 @@ int kvm_arch_init_vcpu(CPUState *cs)
         }
     }
 
+    if (cpu->prop_psci_version) {
+        psciver = cpu->prop_psci_version;
+        ret = kvm_set_one_reg(cs, KVM_REG_ARM_PSCI_VERSION, &psciver);
+        if (ret) {
+            error_report("PSCI version %"PRIx64" is not supported by KVM", psciver);
+            return ret;
+        }
+    }
     /*
      * KVM reports the exact PSCI version it is implementing via a
      * special sysreg. If it is present, use its contents to determine
-- 
2.42.0

