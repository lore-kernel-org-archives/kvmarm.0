Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7982E28640F
	for <kvmarm@lists.linux.dev>; Tue,  2 Dec 2025 16:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764691746; cv=none; b=UuwUu8Ku16T09TPGbRTNamHQKjiOv5zDHtGUOqkWNbY/cGW6sgwPin+bweYXFr1x2uS7oQViDfw8O7umzNKTYYYx/Xfi9ZTqOGAzptvdgx+C7hqzf4NAy1DQkDv7jeTMvtqYqA/3+nQzB3b1Qkw/UHAFdSoM115s1xq67f2lZXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764691746; c=relaxed/simple;
	bh=SAC5PVF/M2K/FzmI2laJU5uE1ZFP3skk03G1HqtqQRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=kNYVk6p3JC5lY6S1w9lZap1CaiekaCKed3qLJvKW9F3O21UTJ63cAHscacngeslfbnDA3MS+oRH6zaSvLn9j3c5+ftf3YDxgFgMha4JntW/ExztMcD4MaRpPB6N/ssvhLJyTxt7SxynIPqimDrOp/jC/EvGE8nrAHOAARVAx7N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QOBMOUbp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QOBMOUbp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764691743;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1r6iwMV7OOxfpGBTEnAoro8MxvDg/dbyx+KBPvZFR2o=;
	b=QOBMOUbpeitCIvH9k8jaiPAxCwMjeBNH9vzzZE57lK+B+WMTAzh4v/La+FO20Mu0wRFUn7
	bof3pS/c88JaVJwcpriqGINyL4vn+UBLmftDPzmR9PMqlIxcFMn02lm9wue7u4QdZPCDBf
	l2bRk+nzVPHEBa6bYeJ7pzJMgmddfHQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-426-E7c8zeFaOPyYmOHACeigRQ-1; Tue, 02 Dec 2025 11:09:02 -0500
X-MC-Unique: E7c8zeFaOPyYmOHACeigRQ-1
X-Mimecast-MFC-AGG-ID: E7c8zeFaOPyYmOHACeigRQ_1764691741
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-42b3b5ed793so4463519f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 02 Dec 2025 08:09:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764691741; x=1765296541;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1r6iwMV7OOxfpGBTEnAoro8MxvDg/dbyx+KBPvZFR2o=;
        b=vV7DmXnzOi0UAhGHws/YkEtbK24eav8cJoINpuf+B8MvWewm5cDnIU0cBpLxLv0ohR
         TANhbMMq2SeEZ22fLaG00oyHXyHDqyRjKWNofTsdoMfNI5OsmAaLJIBV1H8MppfuZfuI
         lihiqJR0atw1uhHt7hrnreJvpfQntgvN5RhEzmAgOSj7h6a/CcPbPwh6wD2BMuae3DY+
         0iO39ItpZP9Em8KImtqsP8u0zqtg/4PAuiPYkCl2JRLWMmqSM+rTu2i83sujh6WlNllg
         8yG0w/HZHOMiMySM3sgDJB65GFxe+5AKn4P1Pyu8sYZTPZYSRri+zHfKYc1/36rbV5bv
         XzZg==
X-Forwarded-Encrypted: i=1; AJvYcCUs0go0UXTXNaaXESM3OT3fyrgLXylpCn7E0hgQnynDON8q4leU6aN0acJ1W2rftrQFXDxlOz0=@lists.linux.dev
X-Gm-Message-State: AOJu0YznyZAhHjWUqfJaID5zDsrvrkrZgsMHkrshv3OHb6k7BXHkl5Ju
	mO48KFqC3zmfnvvDDFw1sYyToisnZhEMIgNqd146E4YoAkipbyGaPADdvf5RwYqJB5nqxdol8fK
	wmJ+xefkfj0oyDa9IbMQycLEKA1HcV6S5dQhKPHIjn6d4BRpXFRObCkYDJA==
X-Gm-Gg: ASbGncvGHHSps4mXI4txuufu2ua5krvzsw6XLX6eFsNuwGHfx9lYpBy7MrSeywD4+8C
	GTa06iXwVfOhlmEg48pASvSxRejZ2rT+xja6qLR+Q1ovzzo/qCoay8CLHM3+Kc+n6sD7XJ1u5p6
	bUQW6lmfdOdMPFea/fY77itKHFoU0ZCgFEhc5tQOy2D+oYwDKc85ydxVYWdvBH5SGmxOEJPh9QP
	wvhbwf8vviGg0pT7hi83wDTgh4GJGqJYUOk5YLgV6HMKrv44Y/64/3ArIaaRw2z3HWZCXs0HNTO
	UqOJVR3MkZkZ5e/4CXLMZPW8uQhSVMdT5uNPLnxqXLt9SX/X9Lab+/7EY5ByvnN3ZFd3RSKNx1I
	2iQ5Zq9CJtHU2FtIP2fTaISoZstmgtIFmwmAL4W81QiMBIKpT70lOuGVjlIrcVIv4Unb1vjiu
X-Received: by 2002:a5d:584d:0:b0:42b:3592:1b82 with SMTP id ffacd0b85a97d-42cc1ac9c76mr46078121f8f.1.1764691740732;
        Tue, 02 Dec 2025 08:09:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG5eHkIz8G/4NXCExVWJEsXbaVN2WN77R5ZJZIrxOxxmaTtp/wopCTKYSwO8GkK2AKblszQOg==
X-Received: by 2002:a5d:584d:0:b0:42b:3592:1b82 with SMTP id ffacd0b85a97d-42cc1ac9c76mr46078089f8f.1.1764691740199;
        Tue, 02 Dec 2025 08:09:00 -0800 (PST)
Received: from rh.redhat.com (p200300f6af35a800883b071bf1f3e4b6.dip0.t-ipconnect.de. [2003:f6:af35:a800:883b:71b:f1f3:e4b6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42e1caa767dsm34300899f8f.38.2025.12.02.08.08.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 08:08:59 -0800 (PST)
From: Sebastian Ott <sebott@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eric Auger <eric.auger@redhat.com>
Cc: qemu-arm@nongnu.org,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Sebastian Ott <sebott@redhat.com>
Subject: [PATCH v4 2/2] target/arm/kvm: add kvm-psci-version vcpu property
Date: Tue,  2 Dec 2025 17:08:53 +0100
Message-ID: <20251202160853.22560-3-sebott@redhat.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251202160853.22560-1-sebott@redhat.com>
References: <20251202160853.22560-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NsY66SxZ_w7Umk1vfMIixJHvJu5-lH_lQMNrAOnze2g_1764691741
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Provide a kvm specific vcpu property to override the default
(as of kernel v6.13 that would be PSCI v1.3) PSCI version emulated
by kvm. Current valid values are: 0.1, 0.2, 1.0, 1.1, 1.2, and 1.3

Note: in order to support PSCI v0.1 we need to drop vcpu
initialization with KVM_CAP_ARM_PSCI_0_2 in that case.

Signed-off-by: Sebastian Ott <sebott@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
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
index 39f2b2e54d..e2b6b587ea 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -1035,6 +1035,12 @@ struct ArchCPU {
     bool kvm_vtime_dirty;
     uint64_t kvm_vtime;
 
+    /*
+     * Intermediate value used during property parsing.
+     * Once finalized, the value should be read from psci_version.
+     */
+    uint32_t kvm_prop_psci_version;
+
     /* KVM steal time */
     OnOffAuto kvm_steal_time;
 
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 0d57081e69..cf2de87287 100644
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
+            cpu->kvm_prop_psci_version = ver->number;
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
+    if (cpu->kvm_prop_psci_version != QEMU_PSCI_VERSION_0_1 &&
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
 
+    if (cpu->kvm_prop_psci_version) {
+        psciver = cpu->kvm_prop_psci_version;
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

